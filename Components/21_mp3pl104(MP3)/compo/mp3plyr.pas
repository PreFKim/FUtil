{
    MP3Player - Free Delphi Component
    Copyright (C) 1999  Kei Ishida

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
{$define ASM_X86}
//{$define UseIntegerDecoder}


unit MP3Plyr;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms, MMSystem;

const
  //  Decode の入出力用バッファのバイト数
  InBufSize = 16*1024;
  OutBufSize = 5*1024;

  //  PCM デバイスからの出力で何ミリ秒分のバッファを確保するか
  PCMOutBufTimeLen = 2000;

  //  PCM デバイスからの出力でバッファを何分割するか
  PCMOutBufCount = 4;

  MaxFrameBytes = 1441;

  //  for decode thread message
  MPM_PAUSE = WM_USER+0;
  MPM_UNPAUSE = WM_USER+1;
  MPM_STOP = WM_USER+2;
  MPM_SEEK = WM_USER+3;

  //  for main thread message
  MPM_CHANGEPOSITION = WM_USER+10;
  MPM_DECODEERROR = WM_USER+11;
  MPM_DECODEEND = WM_USER+12;
  MPM_PCMOUTHASROOM = WM_USER+13;
  MPM_CHANGESTATUS = WM_USER+14;
  MPM_ENDPLAY = WM_USER+15;
  MPM_CHANGEEQUALIZER = WM_USER+16;

  //  for pcm out thread message
  MPM_WAVEFILEWRITE = WM_USER+20;

  //   for TMPThread class message
  MPM_TERMINATETHREAD = WM_USER+30;
  MPM_WATCHEVENT = WM_USER+31;
  MPM_SYNCTHREAD = WM_USER+32;
  MPM_TIMEOUTTHREAD = WM_USER+33;

  MPM_FIRST = WM_USER;
  MPM_LAST = WM_USER+39;


type
  EMP3Error = Exception;

  TEvent = class(TObject)
  private
    FHandle: THandle;
  protected
  public
    constructor Create(
      EventAttributes: PSecurityAttributes = nil;
      ManualReset: Boolean = True;
      InitialState: Boolean = False;
      const Name: string = ''
    );
    destructor Destroy; override;

    procedure SetEvent;
    procedure ResetEvent;
    function WaitFor(TimeOut: LongWord): LongWord;

    property Handle: THandle read FHandle;
  end;

  TSimpleEvent = class(TEvent)
  end;

  TCriticalSection = class(TObject)
  private
    FCS: TRTLCriticalSection;
  protected
  public
    constructor Create;
    destructor Destroy; override;

    procedure Enter;
    procedure Leave;
  end;

  TThreadErrorEvent = procedure(Sender: TObject; E: Exception;
    var Handled: Boolean) of object;

  TMPThread = class(TObject)
  private
    FThreadID: DWORD;
    FHandle: THandle;

    FOnThreadError: TThreadErrorEvent;

    FWatchEvent: TEvent;
    FParent: TObject;
    FTimeOut: DWord;

    function GetPriority: Integer;
    procedure SetPriority(const Value: Integer);
    function GetTerminated: Boolean;
  protected
    procedure Execute;
  public
    constructor Create(Parent: TObject);
    destructor Destroy; override;

    procedure Resume;
    procedure Suspend;
    procedure PostMessage(Msg: UINT; wParam: WPARAM; lParam: LPARAM);
    procedure WaitForProcessMessages;
    procedure WaitForTerminate;
    procedure Terminate;

    property Terminated: Boolean read GetTerminated;
    property Handle: THandle read FHandle;
    property ThreadID: DWORD read FThreadID;
    property Priority: Integer read GetPriority write SetPriority;
    property WatchEvent: TEvent read FWatchEvent;
    property OnThreadError: TThreadErrorEvent
      read FOnThreadError write FOnThreadError;
    property TimeOut: DWord read FTimeOut write FTimeOut;
  end;

  //  Stream 読込補助クラス
  TStreamReader = class(TObject)
  private
    FStream: TStream;
    FSeekable: Boolean;
    FSize: Integer;

    FBuffer: PChar;
    FBufSize: Integer;
    FPosition: Integer;
    FAvailableBytes: Integer;
  protected
  public
    // BufSize は読込に使うバッファサイズ
    constructor Create(BufSize: Integer);

    destructor Destroy; override;

    //  Stream からの読込開始
    //    Stream は読込可能でなくてはならない
    //    Stream.Seek メソッドが使えるかどうかを Seekable で指定
    //    Seekable な Stream を指定する場合、このメソッドを呼ぶ前に Stream は
    //    先頭に Seek しておくこと
    //    Close メソッドを呼ぶまで Stream を直接操作や Free してはいけない
    procedure Open(Stream: TStream; Seekable: Boolean);

    //  Open で開始した読込を終了する
    procedure Close;

    //  引数・戻値は TStream.Seek と同じ意味
    //    非Seekable な Stream だと例外生成
    function Seek(Offset: Longint; Origin: Word): Longint;

    //  Strema から読み込んで Buffer を Count バイト埋める
    //    成功すれば、戻値は True
    //    成功すれば、AvailableBytes は Count 以上ある
    //    失敗したら、読み込めるだけ読み込んで False を返す
    //    Count は BufSize 以下にすること
    //    Fill は現在の Position を変えずに Buffer を埋める
    //    FillTail は Stream の終端の Count バイトで Buffer を埋める
    function Fill(Count: Integer): Boolean;
    function FillTail(Count: Integer): Boolean;

    //  Position を Count バイト増加する
    //    成功すれば、戻値は True
    function Skip(Count: Integer): Boolean;

    //  Stream が何バイトあるか
    //    非Seekable な Stream だと MaxInt を返す
    property Size: Integer read FSize;

    //  Buffer が指す先頭バイトが Stream 内で先頭から何バイト目にあるか
    property Position: Integer read FPosition;

    //  Stream から読み込んだ結果が入っているバッファ
    //    書き換えても Stream に反映されない
    property Buffer: PChar read FBuffer;

    //  Buffer 内で有効なバイト数
    property AvailableBytes: Integer read FAvailableBytes;

    //  バッファのバイト数
    property BufSize: Integer read FBufSize;
  end;

  TDoneOutputEvent = procedure(Sender: TObject; DoneSize: Integer) of object;

  TSoundOut = class(TObject)
  private
    FSamplingRate: Integer;
    FChannels: Integer;
    FBitsPerSample: Integer;
    FIsOpen: Boolean;
    FVolume: Integer;
    FOnThreadError: TThreadErrorEvent;
    FOnDoneOutput: TDoneOutputEvent;

    FWaveOutHandle: HWAVEOUT;
    FWaveOutHeaders: array[0..PCMOutBufCount-1] of TWaveHdr;

    FWaveStream: TFileStream;

    FBufs: array[0..PCMOutBufCount-1] of  PChar;
    FBufIndex: Integer;
    FBufAvailableLen: Integer;
    FUsedBufCount: Integer;
    FBufItemSize: Integer;
    FVolBalance: Integer;

    FWaveOutThread: TMPThread;

    FRequestCS: TCriticalSection;
    FRequestedEvent: TEvent;
    FRequestedWindowHandle: THandle;
    FEmptyEvent: TEvent;
    FWaveFileName: TFileName;
    FLastTime: LongWord;
    FDoneByteCS: TCriticalSection;

    procedure SetVolumeToWaveDevice;

    procedure SetBitsPerSample(const Value: Integer);
    procedure SetChannels(const Value: Integer);
    procedure SetSamplingRate(const Value: Integer);
    procedure SetVolume(const Value: Integer);

    procedure CheckWaveOut(ErrorCode: MMRESULT);
    procedure RequestCheck;
    procedure WaveWrite;
    procedure SetVolBalance(const Value: Integer);
    procedure SetWaveFileName(const Value: TFileName);
    function GetDoneBytes: Integer;
  protected
    procedure MMWomDone(var Msg: TMessage); message MM_WOM_DONE;
    procedure MPMWaveFileWrite(var Msg: TMessage); message MPM_WAVEFILEWRITE;
    procedure MPMTimeOutThread(var Msg: TMessage); message MPM_TIMEOUTTHREAD;
    procedure ThreadError(Sender: TObject; E: Exception; var Handled: Boolean);
    procedure DoneOutput(DoneSize: Integer);
  public
    constructor Create;
    destructor  Destroy; override;

    procedure Open;
    procedure Close;
    procedure Stop;
    procedure Flush;
    procedure Pause;
    procedure Unpause;

    //  出力バッファに書込む
    //    バッファに書込んだバイト数を返す
    function  Write(const Buf; Count: Integer): Integer;

    //  出力バッファの空きがあるかどうか
    //    1バイトでも空きがあれば True
    function  HasRoom: Boolean;

    //  出力バッファの空き通知を要請する
    procedure RequestEvent(Event: TEvent);
    procedure RequestMessage(WindowHandle: THandle);

    //  バッファが空になるまで待つ
    procedure WaitForEmpty;

    //  バッファの空きを 100 分率で返す
    function  BufRoomRate: Integer ;

    //  Open 済みかどうか
    property  IsOpen: Boolean read FIsOpen;

    //  サンプリングレート(即値)
    //    デフォルトは 44100
    property  SamplingRate: Integer read FSamplingRate write SetSamplingRate;

    //  チャンネル数
    //    範囲は 1..2
    //    デフォルトは 2
    property  Channels: Integer read FChannels write SetChannels;

    //  サンプルあたりのビット数
    //    範囲は 8 or 16
    //    デフォルトは 16
    property  BitsPerSample: Integer read FBitsPerSample write SetBitsPerSample;

    //  ボリューム
    //    範囲は 0..100
    //    ファイル出力時は無効
    //    デフォルトは起動時のサウンドドライバの設定値
    property  Volume: Integer read FVolume write SetVolume;

    //  ボリュームの左右のバランス
    //    範囲は -100..100
    //    負数で左寄り、正数で右寄り
    //    デフォルトは 0
    property  VolBalance: Integer read FVolBalance write SetVolBalance;

    //  出力するファイル名
    //    設定したファイルに RIFF/WAVE 形式で出力する
    //    Open メソッド前に設定すること
    //    音源出力する時は '' にすること
    //    デフォルトは ''
    property  WaveFileName: TFileName read FWaveFileName write SetWaveFileName;

    //  出力中の別スレッドエラーの発生通知イベント
    //    別スレッドで呼ばれる
    property OnThreadError: TThreadErrorEvent
      read FOnThreadError write FOnThreadError;

    //  出力が終ったバイト数を通知するイベント
    //    別スレッドで呼ばれる
    property OnDoneOutput: TDoneOutputEvent
      read FOnDoneOutput write FOnDoneOutput;
  end;

  TMP3StreamType = set of (mstSeekable, mstOwn);
  TMP3Status = (mstStop, mstPlay, mstPause);
  TMP3EndPlayReason = (merSuccessful, merStoped, merFailure);
  TMP3EndPlayEvent = procedure(Sender: TObject;
    Reason: TMP3EndPlayReason) of object;
  TMP3InfoType = set of (mitID3V1, mitID3V2, mitRiff);
  TMP3Capabilities = set of (mcbCanOpen, mcbCanClose, mcbCanPlay, mcbCanStop,
    mcbCanPause, mcbCanUnpause, mcbCanSeek, mcbCanPlayToFile);
  TMP3CpuCapabilities = set of (mccMMX, mcc3DNow, mccKNI, mccE3DNow);
  TMP3EqualizerMode = (memSubBand, memFreq);

const
  MccAll = [mccMMX, mcc3DNow, mccKNI, mccE3DNow];

type
  TMpegHead = record
    Sync: Integer;
    ID: Integer;
    Option: Integer;
    Prot: Integer;
    BrIndex: Integer;
    SrIndex: Integer;
    Pad: Integer;
    PrivateBit: Integer;
    Mode: Integer;
    ModeExt: Integer;
    Cr: Integer;
    Original: Integer;
    Emphasis: Integer;
  end;
  PMpegHead = ^TMpegHead;
  TMpegRawHead = DWORD;
  PMpegRawHead = ^TMpegRawHead;

  TDecInfo = record
    Channels: Integer;
    Outvalues: Integer;
    Samprate: LongInt;
    Bits: Integer;
    Framebytes: Integer;
    DecType: Integer;
  end;
  PDecInfo = ^TDecInfo;

  TMP3Player = class(TComponent)
  private
    FStream: TStream;
    FStreamType: TMP3StreamType;
    FReader: TStreamReader;
    FFrameBytes: Integer;
    FFirstHeader: TMpegHead;
    FFirstRawHead: DWORD;
    FFramePosList: TThreadList;

    //  MP3 ファイルを
    //  ・ファイル先頭の音には関係無い情報(Riff header や IDTV2)
    //  ・音本体(Riff では Data chunk)
    //  ・音本体ではないのだけど、よーわからん(Lycos 埋め込みとか)
    //  ・ファイル末尾の音には関係無い情報(Riff の List chunk や IDTV1)
    //  の４つに分ける
    //  ファイル先頭から上記の順番で現れる
    //  音本体は必須。他はあったりなかったり
    FBodyPos: Integer;        //  音本体のファイル先頭からの OFFSET
                              //  非 0 なら、音本体の前は、先頭非音情報
                              //  最初のフレームの同期ヘッダを指していること
    FBodyBytes: Integer;      //  音本体のバイト数
                              //  確定前は MaxInt
    FTailInfoPos: Integer;    //  末尾非音情報のファイル先頭からの OFFSET
                              //  無いか、見つける前は MaxInt
    FInfoType: TMP3InfoType;  //  どのような非音情報を持っているか？


    FAutoPlay: Boolean;
    FAutoOpen: Boolean;
    FFileName: TFileName;
    FChangePosStep: Integer;
    FVolBalance: Integer;
    FVolume: Integer;

    FStatus: TMP3Status;

    FTrack: String;
    FGenre: String;
    FYear: String;
    FArtist: String;
    FAlbum: String;
    FComment: String;
    FTitle: String;
    FChannels: Integer;
    FLayer: Integer;
    FVersion: Integer;
    FSamplingRate: Integer;
    FBitRate: Integer;
    FRiffInfos: TStrings;

    FOnChangeStatus: TNotifyEvent;
    FOnChangePosition: TNotifyEvent;

    FOnEndPlay: TMP3EndPlayEvent;
    FEndPlayReason: TMP3EndPlayReason;

    FSoundOut: TSoundOut;
    FOutBuf: PChar;
    FOutBufAvailableLen: Integer;
    FPCMDoneOutBytes: Integer;
    FOutFrameBytes: Integer;
    FOutputBytes: Integer;
    FOutputFileName: TFileName;
    FPCMDoneOutBytesCS: TCriticalSection;

    FNeedInitDecode: Boolean;

    FWindowHandle: THandle;
    FDecodeThread: TMPThread;

    FLastChangePos: Integer;

    FUsingCpuCapabilities: TMP3CpuCapabilities;

    FEqualizerCount: Integer;
    FEqualizerMode: TMP3EqualizerMode;
    FEqualizer: array[0..31] of Integer;
    FEqualizerFreq: array[0..31] of Integer;
    FEqualizerEnabled: Boolean;

    procedure SetAutoOpen(const Value: Boolean);
    procedure SetAutoPlay(const Value: Boolean);
    procedure SetFileName(const Value: TFileName);
    procedure SetStatus(Value: TMP3Status);
    function  GetLength: integer;
    function  GetPosition: Integer;
    procedure SetChangePosStep(const Value: Integer);
    procedure SetVolume(const Value: Integer);
    function  GetIsOpen: Boolean;
    procedure SetVolBalance(const Value: Integer);
    function  GetCapabilities: TMP3Capabilities;

    procedure WndProc(var Message: Tmessage);
    procedure PostMessage(Msg: UINT; wParam: WPARAM; lParam: LPARAM);
    procedure PostUniqMessage(Msg: UINT; wParam: WPARAM; lParam: LPARAM);
    procedure RemoveMessages(MsgFilterMin, MsgFilterMax: UINT);

    procedure ReadHeadInfo;
    procedure ReadTailInfo;
    procedure ClearInfo;
    procedure ResetDecode;
    function  GetFrameBytes(var Buf; var H: TMpegHead): Integer;
    function  InitLMC(var h: TMpegHead; framebytes_arg: Integer;
     reduction_code: Integer; transform_code: Integer; convert_code: Integer;
     freq_limit: Integer): Integer;
    function  IsValidRawHeader(RawH: TMpegRawHead): Boolean;

    procedure ThreadError(Sender: TObject; E: Exception; var Handled: Boolean);
    procedure PCMDoneOutput(Sender: TObject; DoneSize: Integer);

    function GetHasCpuCapabilities: TMP3CpuCapabilities;
    procedure SetUsingCpuCapabilities(const Value: TMP3CpuCapabilities);

    function GetEqualizer(Index: Integer): Integer;
    procedure SetEqualizer(Index: Integer; const Value: Integer);
    procedure SetEqualizerEnabled(const Value: Boolean);
    function GetEqualizerFreq(Index: Integer): Integer;
    procedure SetEqualizerCount(const Value: Integer);
    procedure SetEqualizerFreq(Index: Integer; const Value: Integer);
    procedure SetEqualizerMode(const Value: TMP3EqualizerMode);
  protected
    procedure Loaded; override;

    procedure MPMPause(var Msg: TMessage); message MPM_PAUSE;
    procedure MPMUnpause(var Msg: TMessage); message MPM_UNPAUSE;
    procedure MPMStop(var Msg: TMessage); message MPM_STOP;
    procedure MPMSeek(var Msg: TMessage); message MPM_SEEK;

    procedure MPMWatchEvent(var Msg: TMessage); message MPM_WATCHEVENT;

    procedure MPMChangePosition(var Msg: TMessage); message MPM_CHANGEPOSITION;
    procedure MPMDecodeError(var Msg: TMessage); message MPM_DECODEERROR;
    procedure MPMDecodeEnd(var Msg: TMessage); message MPM_DECODEEND;
    procedure MPMChangeStatus(var Msg: TMessage); message MPM_CHANGESTATUS;
    procedure MPMEndPlay(var Msg: TMessage); message MPM_ENDPLAY;
    procedure MPMChangeEqualizer(var Msg: TMessage); message MPM_CHANGEEQUALIZER;

    procedure ChangeStatus(Sender: TObject); virtual;
    procedure ChangePosition(Sender: TObject); virtual;
    procedure EndPlay(Sender: TObject); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;

    procedure Open;
    procedure OpenStream(Stream: TStream; StreamType: TMP3StreamType);
    procedure Play;
    procedure PlayToFile(FileName: TFileName);
    procedure Stop;
    procedure Pause;
    procedure Unpause;
    procedure Close;
    procedure Seek(NewPosition: Integer);
    procedure SetEqualizerFreqs(MinFreq, MaxFreq: Integer);

    property  Status: TMP3Status read FStatus;
    property  IsOpen: Boolean read GetIsOpen;
    property  Capabilities: TMP3Capabilities read GetCapabilities;

    property Title: String read FTitle;
    property Artist: String read FArtist;
    property Album: String read FAlbum;
    property Year: String read FYear;
    property Comment: String read FComment;
    property Genre: String read FGenre;
    property Track: String read FTrack;
    property BitRate: Integer read FBitRate;
    property Channels: Integer read FChannels;
    property SamplingRate: Integer read FSamplingRate;
    property Layer: Integer read FLayer;
    property Version: Integer read FVersion;
    property RiffInfos: TStrings read FRiffInfos;
    property InfoType: TMP3InfoType read FInfoType;

    property Position: Integer read GetPosition;
    property Length: Integer read GetLength;
    property Equalizer[Index: Integer]: Integer read GetEqualizer write SetEqualizer;
    property HasCpuCapabilities: TMP3CpuCapabilities read GetHasCpuCapabilities;
    property EqualizerFreq[Index: Integer]: Integer
      read GetEqualizerFreq write SetEqualizerFreq;
  published
    property AutoOpen: Boolean read FAutoOpen write SetAutoOpen;
    property AutoPlay: Boolean read FAutoPlay write SetAutoPlay;
    property ChangePosStep: Integer read FChangePosStep write SetChangePosStep;
    property EqualizerEnabled: Boolean read FEqualizerEnabled write SetEqualizerEnabled;
    property EqualizerCount: Integer read FEqualizerCount write SetEqualizerCount;
    property EqualizerMode: TMP3EqualizerMode read FEqualizerMode write SetEqualizerMode;
    property FileName: TFileName read FFileName write SetFileName;
    property UsingCpuCapabilities: TMP3CpuCapabilities
      read FUsingCpuCapabilities write SetUsingCpuCapabilities;
    property VolBalance: Integer read FVolBalance write SetVolBalance;
    property Volume: Integer read FVolume write SetVolume;

    property OnChangePosition: TNotifyEvent
      read FOnChangePosition write FOnChangePosition;
    property OnChangeStatus: TNotifyEvent
      read FOnChangeStatus write FOnChangeStatus;
    property OnEndPlay: TMP3EndPlayEvent read FOnEndPlay write FOnEndPlay;
  end;

procedure Register;

implementation

uses
  Math, Consts;

resourcestring
  SInvalidMP3Format = 'unknown MPEG Audio format.';
  SUnknownPCMOutAPIError = 'unknown wave out API error.';

const
  GenreTbl: array[Byte] of String = (
    'Blues',
    'Classic Rock',
    'Country',
    'Dance',
    'Disco',
    'Funk',
    'Grunge',
    'Hip-Hop',
    'Jazz',
    'Metal',
    'New Age',
    'Oldies',
    'Other',
    'Pop',
    'R&B',
    'Rap',
    'Reggae',
    'Rock',
    'Techno',
    'Industrial',
    'Alternative',
    'Ska',
    'Death Metal',
    'Pranks',
    'Soundtrack',
    'Euro-Techno',
    'Ambient',
    'Trip-Hop',
    'Vocal',
    'Jazz+Funk',
    'Fusion',
    'Trance',
    'Classical',
    'Instrumental',
    'Acid',
    'House',
    'Game',
    'Sound Clip',
    'Gospel',
    'Noise',
    'AlternRock',
    'Bass',
    'Soul',
    'Punk',
    'Space',
    'Meditative',
    'Instrumental Pop',
    'Instrumental Rock',
    'Ethnic',
    'Gothic',
    'Darkwave',
    'Techno-Industrial',
    'Electronic',
    'Pop-Folk',
    'Eurodance',
    'Dream',
    'Southern Rock',
    'Comedy',
    'Cult',
    'Gangsta',
    'Top 40',
    'Christian Rap',
    'Pop/Funk',
    'Jungle',
    'Native American',
    'Cabaret',
    'New Wave',
    'Psychadelic',
    'Rave',
    'Showtunes',
    'Trailer',
    'Lo-Fi',
    'Tribal',
    'Acid Punk',
    'Acid Jazz',
    'Polka',
    'Retro',
    'Musical',
    'Rock & Roll',
    'Hard Rock',
    'Folk',
    'Folk/Rock',
    'National Folk',
    'Swing',
    'Fast Fusion',
    'Bebob',
    'Latin',
    'Revival',
    'Celtic',
    'Bluegrass',
    'Avantgarde',
    'Gothic Rock',
    'Progressive Rock',
    'Psychedelic Rock',
    'Symphonic Rock',
    'Slow Rock',
    'Big Band',
    'Chorus',
    'Easy Listening',
    'Acoustic',
    'Humour',
    'Speech',
    'Chanson',
    'Opera',
    'Chamber Music',
    'Sonata',
    'Symphony',
    'Booty Bass',
    'Primus',
    'Porn Groove',
    'Satire',
    'Slow Jam',
    'Club',
    'Tango',
    'Samba',
    'Folklore',
    'Ballad',
    'Power Ballad',
    'Rhysmic Soul',
    'Freestyle',
    'Duet',
    'Punk Rock',
    'Drum Solo',
    'Acapella',
    'Euro-House',
    'Dance-Hall',
    'Goa',
    'Drum & Bass',
    'Hardcore',
    'Club-House',
    'Terror',
    'Indie',
    'BritPop',
    'Negerpunk',
    'Polsk Punk',
    'Beat',
    'Christian Gangsta Rap',
    'Heavy Metal',
    'Blank Metal',
    'Crossover',
    'Contemporrary Christian',
    'Christian Rock',
    'Merengue',
    'Salsa',
    'Trash Metal',
    'Anime',
    'JPop',
    'Synthpop',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    'Heavy Rock(J)',
    'Doom Rock(J)',
    'J-POP(J)',
    'Seiyu(J)',
    'Tecno Ambient(J)',
    'Moemoe(J)',
    'Tokusatsu(J)',
    'Anime(J)'
  );

type

  TInOut = record
    InBytes: Integer;
    OutBytes: Integer;
  end;


  TBitDat = record
    BitBuf: Cardinal;
    Bits: Integer;
    BsPtr: PChar;
    BsPtr0: PChar;
    BsPtrEnd: PChar;
  end;
  PBitDat = ^TBitDat;


procedure Register;
begin
  RegisterComponents('Samples', [TMP3Player]);
end;

var
  __turboFloat: LongBool = False;

procedure _memmove(dest, source: Pointer; count: Integer);cdecl;
begin
  Move(source^, dest^, count);
end;

procedure _memset(P: Pointer; B: Byte; count: Integer);cdecl;
begin
  FillChar(P^, count, B);
end;

function _sin(x: Double): Double; cdecl;
begin
  Result := System.Sin(x);
end;

function _cos(x: Double): Double; cdecl;
begin
  Result := System.Cos(x);
end;

function _atan(x: Double): Double; cdecl;
begin
  Result := System.ArcTan(x);
end;

function _pow(x, y: Double): Double; cdecl;
begin
  Result := Math.Power(x, y);
end;

function _sqrt(x: Double): Double; cdecl;
begin
  Result := System.Sqrt(x);
end;

function  _fabs(x: Double): Double; cdecl;
begin
  Result := System.abs(x);
end;

function __ftol: Integer;
var
  f: double;
begin
  asm
    lea    eax, f
    fstp  qword ptr [eax]
  end;
  Result := Trunc(f);
end;

{$link 'mhead.obj'}
{$link 'cupl3.obj'}
{$link 'csbt.obj'}
{$link 'cdct.obj'}
{$link 'cup.obj'}
{$link 'cwinm.obj'}
{$link 'dec8.obj'}
{$link 'hwin.obj'}
{$link 'l3dq.obj'}
{$link 'l3init.obj'}
{$link 'mdct.obj'}
{$link 'msis.obj'}
{$link 'uph.obj'}
{$link 'upsf.obj'}
{$link 'narroweq.obj'}

{$ifdef UseIntegerDecoder}
{$link 'icdct.obj'}
{$link 'isbt.obj'}
{$link 'iup.obj'}
{$link 'iwinm.obj'}
{$endif}


{$ifdef ASM_X86}
{$link 'msisasm.obj'}
{$link 'mdctasm.obj'}
{$link 'cdctasm.obj'}
{$link 'cwin8asm.obj'}
{$link 'cwinasm.obj'}
{$link 'cupL3asm.obj'}
{$link 'cpucaps.obj'}
{$endif}

{$link vars.obj}

procedure _sbt_mono(sample: PSingle;  pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _sbt_dual(sample: PSingle;  pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _sbt_dual_mono(sample: PSingle;  pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _sbt_dual_left(sample: PSingle;  pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _sbt_dual_right(sample: PSingle;  pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _sbt16_mono(sample: PSingle;  pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _sbt16_dual(sample: PSingle;  pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _sbt16_dual_mono(sample: PSingle;  pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _sbt16_dual_left(sample: PSingle;  pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _sbt16_dual_right(sample: PSingle;  pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _sbt8_mono(sample: PSingle;  pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _sbt8_dual(sample: PSingle;  pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _sbt8_dual_mono(sample: PSingle;  pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _sbt8_dual_left(sample: PSingle;  pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _sbt8_dual_right(sample: PSingle;  pcm: PSmallInt; n: Integer);  cdecl; external;

procedure _sbtB_mono(sample: PSingle;  pcm: PChar; n: Integer);  cdecl; external;
procedure _sbtB_dual(sample: PSingle;  pcm: PChar; n: Integer);  cdecl; external;
procedure _sbtB_dual_mono(sample: PSingle;  pcm: PChar; n: Integer);  cdecl; external;
procedure _sbtB_dual_left(sample: PSingle;  pcm: PChar; n: Integer);  cdecl; external;
procedure _sbtB_dual_right(sample: PSingle;  pcm: PChar; n: Integer);  cdecl; external;
procedure _sbtB16_mono(sample: PSingle;  pcm: PChar; n: Integer);  cdecl; external;
procedure _sbtB16_dual(sample: PSingle;  pcm: PChar; n: Integer);  cdecl; external;
procedure _sbtB16_dual_mono(sample: PSingle;  pcm: PChar; n: Integer);  cdecl; external;
procedure _sbtB16_dual_left(sample: PSingle;  pcm: PChar; n: Integer);  cdecl; external;
procedure _sbtB16_dual_right(sample: PSingle;  pcm: PChar; n: Integer);  cdecl; external;
procedure _sbtB8_mono(sample: PSingle;  pcm: PChar; n: Integer);  cdecl; external;
procedure _sbtB8_dual(sample: PSingle;  pcm: PChar; n: Integer);  cdecl; external;
procedure _sbtB8_dual_mono(sample: PSingle;  pcm: PChar; n: Integer);  cdecl; external;
procedure _sbtB8_dual_left(sample: PSingle;  pcm: PChar; n: Integer);  cdecl; external;
procedure _sbtB8_dual_right(sample: PSingle;  pcm: PChar; n: Integer);  cdecl; external;

{$ifdef UseIntegerDecoder}
procedure _i_sbt_mono(sample: PInteger; pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _i_sbt_dual(sample: PInteger; pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _i_sbt_dual_mono(sample: PInteger; pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _i_sbt_dual_left(sample: PInteger; pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _i_sbt_dual_right(sample: PInteger; pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _i_sbt16_mono(sample: PInteger; pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _i_sbt16_dual(sample: PInteger; pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _i_sbt16_dual_mono(sample: PInteger; pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _i_sbt16_dual_left(sample: PInteger; pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _i_sbt16_dual_right(sample: PInteger; pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _i_sbt8_mono(sample: PInteger; pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _i_sbt8_dual(sample: PInteger; pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _i_sbt8_dual_mono(sample: PInteger; pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _i_sbt8_dual_left(sample: PInteger; pcm: PSmallInt; n: Integer);  cdecl; external;
procedure _i_sbt8_dual_right(sample: PInteger; pcm: PSmallInt; n: Integer);  cdecl; external;

procedure _i_sbtB_mono(sample: PInteger; pcm: PChar; n: Integer);  cdecl; external;
procedure _i_sbtB_dual(sample: PInteger; pcm: PChar; n: Integer);  cdecl; external;
procedure _i_sbtB_dual_mono(sample: PInteger; pcm: PChar; n: Integer);  cdecl; external;
procedure _i_sbtB_dual_left(sample: PInteger; pcm: PChar; n: Integer);  cdecl; external;
procedure _i_sbtB_dual_right(sample: PInteger; pcm: PChar; n: Integer);  cdecl; external;
procedure _i_sbtB16_mono(sample: PInteger; pcm: PChar; n: Integer);  cdecl; external;
procedure _i_sbtB16_dual(sample: PInteger; pcm: PChar; n: Integer);  cdecl; external;
procedure _i_sbtB16_dual_mono(sample: PInteger; pcm: PChar; n: Integer);  cdecl; external;
procedure _i_sbtB16_dual_left(sample: PInteger; pcm: PChar; n: Integer);  cdecl; external;
procedure _i_sbtB16_dual_right(sample: PInteger; pcm: PChar; n: Integer);  cdecl; external;
procedure _i_sbtB8_mono(sample: PInteger; pcm: PChar; n: Integer);  cdecl; external;
procedure _i_sbtB8_dual(sample: PInteger; pcm: PChar; n: Integer);  cdecl; external;
procedure _i_sbtB8_dual_mono(sample: PInteger; pcm: PChar; n: Integer);  cdecl; external;
procedure _i_sbtB8_dual_left(sample: PInteger; pcm: PChar; n: Integer);  cdecl; external;
procedure _i_sbtB8_dual_right(sample: PInteger; pcm: PChar; n: Integer);  cdecl; external;

function _i_audio_decode_init(var h: TMpegHead; framebytes_arg: Integer;
   reduction_code: Integer; transform_code: Integer; convert_code: Integer;
     freq_limit: Integer): Integer;  cdecl; external;
procedure _i_audio_decode_info(var info: TDecInfo);  cdecl; external;
function _i_audio_decode(var bs, pcm): TInOut;  cdecl; external;
procedure _i_sbt_init;  cdecl; external;

function _i_dct_coef_addr: PInteger;  cdecl; external;

procedure _i_dct32(sample: PInteger; vbuf: PInteger);  cdecl; external;
procedure _i_dct32_dual(sample: PInteger; vbuf: PInteger);  cdecl; external;
procedure _i_dct32_dual_mono(sample: PInteger; vbuf: PInteger);  cdecl; external;

procedure _i_dct16(sample: PInteger; vbuf: PInteger);  cdecl; external;
procedure _i_dct16_dual(sample: PInteger; vbuf: PInteger);  cdecl; external;
procedure _i_dct16_dual_mono(sample: PInteger; vbuf: PInteger);  cdecl; external;

procedure _i_dct8(sample: PInteger; vbuf: PInteger);  cdecl; external;
procedure _i_dct8_dual(sample: PInteger; vbuf: PInteger);  cdecl; external;
procedure _i_dct8_dual_mono(sample: PInteger; vbuf: PInteger);  cdecl; external;
{$endif}

function _L1audio_decode(var bs,  pcm): TInOut;  cdecl; external;
function _L2audio_decode(var bs,  pcm): TInOut;  cdecl; external;
function _L3audio_decode(var bs,  pcm): TInOut;  cdecl; external;
function _audio_decode(var bs, pcm): TInOut;  cdecl; external;

function _L1audio_decode_init(var h: TMpegHead; framebytes_arg: Integer;
       reduction_code: Integer; transform_code: Integer; convert_code: Integer;
      freq_limit: Integer): Integer;  cdecl; external;
function _L3audio_decode_init(var h: TMpegHead; framebytes_arg: Integer;
       reduction_code: Integer; transform_code: Integer; convert_code: Integer;
      freq_limit: Integer): Integer;  cdecl; external;

function _quant_init_global_addr: PSingle;  cdecl; external;
function _quant_init_scale_addr: Pointer;  cdecl; external;
function _quant_init_pow_addr: PSingle;  cdecl; external;
function _quant_init_subblock_addr: PSingle;  cdecl; external;

function _hwin_init_addr: Pointer;  cdecl; external;
function _bitget(n: Integer): Cardinal;  cdecl; external;

function _head_info(var buf; n: Cardinal; var h: TMpegHead): Integer;  cdecl; external;
function _head_info2(var buf; n: Cardinal; var h: TMpegHead; var br: Integer): Integer;  cdecl; external;
function _head_info3(var buf; n: Cardinal; var h: TMpegHead; var br: Integer; var searchForward: Cardinal): Integer;  cdecl; external;

function _audio_decode_init(var h: TMpegHead; framebytes_arg: Integer;
   reduction_code: Integer; transform_code: Integer; convert_code: Integer;
   freq_limit: Integer): Integer;  cdecl; external;
procedure _audio_decode_info(var info: TDecInfo);  cdecl; external;

function _audio_decode8_init(var h: TMpegHead; framebytes_arg: Integer;
   reduction_code: Integer; transform_code: Integer; convert_code: Integer;
    freq_limit: Integer): Integer;  cdecl; external;
procedure _audio_decode8_info(var info: TDecInfo);  cdecl; external;
function _audio_decode8(var bs, pcm): TInOut;  cdecl; external;

function _equalizer_addr(n: Integer): PSingle; cdecl; external;
function _enableEQ_addr: PInteger; cdecl; external;
function _n_equalizer_addr(n: Integer):PSingle; cdecl; external;
function _n_enableEQ_addr: PInteger; cdecl; external;


{$ifdef ASM_X86}
function  _get_cpu_caps: Integer; cdecl; external;
procedure _set_using_cpu_caps(Caps:LongWord); cdecl; external;
function _get_using_cpu_caps: Integer; cdecl; external;
{$endif}

{ TEvent }

constructor TEvent.Create(EventAttributes: PSecurityAttributes;
  ManualReset, InitialState: Boolean; const Name: string);
begin
  inherited Create;

  FHandle := CreateEvent(EventAttributes, ManualReset, InitialState, PChar(Name));

  if FHandle = 0 then begin
    RaiseLastWin32Error;
  end;
end;

destructor TEvent.Destroy;
begin
  if FHandle <> 0 then begin
    CloseHandle(FHandle);
  end;

  inherited Destroy;
end;

procedure TEvent.ResetEvent;
begin
  Windows.ResetEvent(FHandle);
end;

procedure TEvent.SetEvent;
begin
  Windows.SetEvent(FHandle);
end;

function TEvent.WaitFor(TimeOut: LongWord): LongWord;
begin
  Result := Windows.WaitForSingleObject(FHandle, TimeOut);
end;

{ TCriticalSection }

constructor TCriticalSection.Create;
begin
  inherited Create;

  InitializeCriticalSection(FCS);
end;

destructor TCriticalSection.Destroy;
begin
  DeleteCriticalSection(FCS);

  inherited Destroy;
end;

procedure TCriticalSection.Enter;
begin
  EnterCriticalSection(FCS);
end;

procedure TCriticalSection.Leave;
begin
  LeaveCriticalSection(FCS);
end;

{ TMPThread }

function ThreadProc(Parent: TMPThread): Integer;
begin
  Result := 0;
  try
    Parent.Execute;
  finally
    EndThread(Result);
  end;
end;

constructor TMPThread.Create(Parent: TObject);
begin
  inherited Create;

  FParent := Parent;

  FHandle := BeginThread(nil, 0, @ThreadProc, Self, CREATE_SUSPENDED, FThreadId );

  FWatchEvent := TEvent.Create(nil, True, False, '');

  FTimeOut := INFINITE;
end;

destructor TMPThread.Destroy;
begin
  Terminate;
  WaitForTerminate;

  if FHandle <> 0 then begin
    CloseHandle(FHandle);
  end;

  FWatchEvent.Free;

  inherited Destroy;
end;

procedure TMPThread.Execute;
var
  watchHandle: THandle;
  msg: TMsg;
  errorHandled: Boolean;

  procedure DispatchMessage(Msg: UINT; WParam, LParam: Integer);
  var
    message: TMessage;
  begin
    if not Assigned(FParent) then begin
      Exit;
    end;

    FillChar(message, 0, SizeOf(message));
    message.Msg := Msg;
    message.WParam := WParam;
    message.LParam := LParam;
    FParent.Dispatch(message);
  end;

begin
  watchHandle := WatchEvent.Handle;
  while True do begin
    try

      case MsgWaitForMultipleObjects(1, watchHandle, False, FTimeOut,
        QS_ALLINPUT) of
        WAIT_OBJECT_0: begin
          DispatchMessage(MPM_WATCHEVENT, 0, 0);
        end;
        WAIT_TIMEOUT: begin
          DispatchMessage(MPM_TIMEOUTTHREAD, 0, 0);
        end;
      end;
      while PeekMessage(msg, 0, 0, 0, PM_REMOVE) do begin
        case msg.message of
        MPM_TERMINATETHREAD: begin
          Exit;
        end;
        MPM_SYNCTHREAD: begin
          if (msg.wParam <> 0) and (TObject(msg.wParam) is TEvent) then begin
            TEvent(msg.wParam).SetEvent;
          end;
        end;
        else
          with msg do begin
            DispatchMessage(message, wParam, lParam);
          end;
        end;
      end;
    except
      on e: Exception do begin
        errorHandled := False;
        if Assigned(FOnThreadError) then  begin
          FOnThreadError(Self, e, errorHandled);
        end;
        if not errorHandled then begin
          Application.ShowException(e);
        end;
      end;
    end;
  end;
end;

function TMPThread.GetPriority: Integer;
begin
  Result := GetThreadPriority(FHandle);
end;

function TMPThread.GetTerminated: Boolean;
begin
  Result := WaitForSingleObject(FHandle, 0) = WAIT_OBJECT_0;
end;

procedure TMPThread.PostMessage(Msg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  PostThreadMessage(FThreadID, Msg, wParam, lParam);
end;

procedure TMPThread.Resume;
begin
  ResumeThread(FHandle);
end;

procedure TMPThread.SetPriority(const Value: Integer);
begin
  SetThreadPriority(FHandle, Value);
end;

procedure TMPThread.Suspend;
begin
  SuspendThread(FHandle);
end;

procedure TMPThread.Terminate;
begin
  PostMessage(MPM_TERMINATETHREAD, 0, 0);
end;

procedure TMPThread.WaitForProcessMessages;
var
  event: TEvent;
  handles: array[0..1] of THandle;
begin
  event := TSimpleEvent.Create;
  try
    handles[0] := FHandle;
    handles[1] := event.Handle;
    PostMessage(MPM_SYNCTHREAD, DWORD(event), 0);
    WaitForMultipleObjects(2, @handles, False, INFINITE);
  finally
    event.Free;
  end;
end;

procedure TMPThread.WaitForTerminate;
begin
  Terminate;
  WaitForSingleObject(FHandle, INFINITE);
end;


{ TStreamReader }

procedure TStreamReader.Close;
begin
  FStream := nil;
  FAvailableBytes := 0;
  FSize := 0;

  if Assigned(FBuffer) then begin
    FreeMem(FBuffer);
    FBuffer := nil;
  end;
end;

constructor TStreamReader.Create(BufSize: Integer);
begin
  inherited Create;

  Assert(0 < BufSize);
  FBufSize := BufSize;
end;

destructor TStreamReader.Destroy;
begin
  Close;

  inherited Destroy;
end;


function TStreamReader.Fill(Count: Integer): Boolean;
const
  defaultReadLen = 4*1024;
var
  readLen: Integer;
begin
  Result := False;

  Assert(FStream <> nil);
  Assert(0 <= Count);
  Assert(Count <= FBufSize);
  Assert(FBuffer <> nil);

  while FAvailableBytes < Count do begin

    if defaultReadLen <= Count-FAvailableBytes then begin
      readLen := Count-FAvailableBytes;
    end
    else if defaultReadLen <= FBufSize-FAvailableBytes then begin
      readLen := defaultReadLen;
    end
    else begin
      readLen := FBufSize-FAvailableBytes;
    end;

    readLen := FStream.Read(FBuffer[FAvailableBytes], readLen);
    if readLen = 0 then begin
      Exit;
    end;

    Dec(Count, readLen);
    Inc(FAvailableBytes, readLen);
  end;

  Result := True;
end;

function TStreamReader.FillTail(Count: Integer): Boolean;
begin
  Assert(FStream <> nil);
  Assert(0 <= Count);
  Assert(Count <= FBufSize);
  Assert(FBuffer <> nil);

  if FSeekable then begin
    Seek(-Count, soFromEnd);
    Result := Fill(Count);
  end
  else begin
    while Fill(FBufSize) do begin
      Skip(FBufSize-Count+1);
    end;

    Skip(FAvailableBytes-Count);
    Result := True;
  end;
end;

procedure TStreamReader.Open(Stream: TStream; Seekable: Boolean);
begin
  Close;

  FStream := Stream;
  FSeekable := Seekable;
  FPosition := 0;
  FAvailableBytes := 0;
  if Assigned(FStream) then begin
    GetMem(FBuffer, FBufSize);
    if FSeekable then begin
      FSize := FStream.Size;
    end;
  end;
end;

function TStreamReader.Seek(Offset: Integer; Origin: Word): Longint;
begin
  Assert(FStream <> nil);
  Assert(FSeekable);

  if Origin = soFromCurrent then begin
    FPosition := FStream.Seek(Offset-FAvailableBytes, Origin);
  end
  else begin
    FPosition := FStream.Seek(Offset, Origin);
  end;
  Result := FPosition;
  FAvailableBytes := 0;
end;

function TStreamReader.Skip(Count: Integer): Boolean;
begin
  Result := False;

  Assert(FStream <> nil);
  Assert(0 <= Count);

  if Count <= FAvailableBytes then begin
    Dec(FAvailableBytes, Count);
    Move(FBuffer[Count], FBuffer[0], FAvailableBytes);
    Inc(FPosition, Count);
    Result := True;
  end
  else begin
    if FSeekable then begin
      if FPosition+Count <= FSize then begin
        Seek(Count, soFromCurrent);
        Result := True;
      end
      else begin
        Seek(0, soFromEnd);
      end;
    end
    else begin
      while Fill(1) do begin

        Fill(FBufSize);
        if Count <= FAvailableBytes then begin
          Result := Skip(Count);
          Break;
        end;

        //  Skip(FAvailableBytes);
        Inc(FPosition, FAvailableBytes);
        FAvailableBytes := 0;
      end;
    end;
  end;
end;

{ TSoundOut }

function TSoundOut.BufRoomRate: Integer;
begin
  Result := 0;
  if IsOpen then begin
    Result := ((PCMOutBufCount-FUsedBufCount-1)*FBufItemSize+
      (FBufItemSize-FBufAvailableLen))*100 div (FBufItemSize*PCMOutBufCount);
  end;
end;

procedure TSoundOut.CheckWaveOut(ErrorCode: MMRESULT);
var
  errorMsg: String;
begin
  if ErrorCode <> MMSYSERR_NOERROR then begin
    SetLength(errorMsg, MAXERRORLENGTH+1);
    if MMSystem.WaveOutGetErrorText(ErrorCode, PChar(errorMsg), MAXERRORLENGTH) =
      MMSYSERR_NOERROR then begin
      raise EMP3Error.Create(errorMsg);
    end
    else begin
      raise EMP3Error.Create(SUnknownPCMOutAPIError);
    end;
  end;
end;


type
  TWaveHeader = packed record
    MainChunk: array[0..3] of Char;
    FileSize: Integer;
    FormType: array[0..3] of Char;
    SubChunk: array[0..3] of Char;
    ChunkLen: Integer;
    Format: SmallInt;
    Modus: SmallInt;
    SampleRate: Integer;
    BitRate: Integer;
    BlockSize: SmallInt;
    SampleDepth: SmallInt;
    DataChunk: array[0..3] of Char;
    DataSize: Integer;
  end;

procedure TSoundOut.Close;
var
  bufIdx: Integer;

  procedure CloseDevice;
  var
    bufIdx: Integer;
  begin
    FWaveOutThread.TimeOut := INFINITE;

    Flush;
    WaitForEmpty;

    for bufIdx := 0 to PCMOutBufCount-1 do begin
      if FBufs[bufIdx] <> nil then begin
        while MMSystem.WaveOutUnprepareHeader(FWaveOutHandle, @(FWaveOutHeaders[bufIdx]),
          SizeOf(FWaveOutHeaders[bufIdx])) = WAVERR_STILLPLAYING do begin
          Sleep(100);
        end;
      end;
    end;

    if FWaveOutHandle <> 0 then begin
      MMSystem.WaveOutClose(FWaveOutHandle);
    end;
    FWaveOutHandle := 0;
  end;

  procedure CloseFile;
  var
    fileSize: Integer;
    dataSize: Integer;
  begin
    try
      fileSize := FWaveStream.Position-8;
      dataSize := fileSize-SizeOf(TWaveHeader);

      FWaveStream.Seek(4, soFromBeginning);
      FWaveStream.WriteBuffer(fileSize, SizeOf(fileSize));

      FWaveStream.Seek(SizeOf(TWaveHeader)-SizeOf(dataSize), soFromBeginning);
      FWaveStream.WriteBuffer(dataSize, SizeOf(dataSize));
    finally
      FWaveStream.Free;
      FWaveStream := nil;
    end;
  end;

begin
  FRequestedEvent := nil;
  FRequestedWindowHandle := 0;

  try
    if Assigned(FWaveStream) then begin
      CloseFile;
    end;

    if FWaveOutHandle <> 0 then begin
      CloseDevice;
    end;
  finally
    FIsOpen := False;

    for bufIdx := 0 to PCMOutBufCount-1 do begin
      if FBufs[bufIdx] <> nil then begin
        FreeMem(FBufs[bufIdx]);
        FBufs[bufIdx] := nil;
      end;
    end;
  end;

end;

constructor TSoundOut.Create;
var
  waveFormat: TWaveFormatEx;
  curVol: DWORD;
begin
  inherited Create;

  FSamplingRate := 44100;
  FChannels := 2;
  FBitsPerSample := 16;

  FRequestCS := TCriticalSection.Create;
  FEmptyEvent := TSimpleEvent.Create;
  FDoneByteCS := TCriticalSection.Create;

  FillChar(waveFormat, 0, SizeOf(waveFormat));
  with waveFormat do begin
    wFormatTag := WAVE_FORMAT_PCM;
    nChannels := FChannels;
    nSamplesPerSec := FSamplingRate;
    wBitsPerSample := FBitsPerSample;
    nBlockAlign := FChannels*FBitsPerSample div 8;
    nAvgBytesPerSec := nBlockAlign*FSamplingRate;
    cbSize := 0;
  end;
  CheckWaveOut(MMSystem.WaveOutOpen(@FWaveOutHandle, WAVE_MAPPER, @waveFormat,
    0, 0, CALLBACK_NULL or WAVE_ALLOWSYNC));
  CheckWaveOut(MMSystem.waveOutGetVolume(FWaveOutHandle, @curVol));
  if HiWord(curVol) <= LoWord(curVol) then begin
    FVolume := LoWord(curVol)*100 div 65535;
  end
  else begin
    FVolume := HiWord(curVol)*100 div 65535;
  end;
  MMSystem.WaveOutClose(FWaveOutHandle);
  FWaveOutHandle := 0;

  FWaveOutThread := TMPThread.Create(Self);
  with FWaveOutThread do begin
    OnThreadError := Self.ThreadError;
    Resume;
  end;
end;

destructor TSoundOut.Destroy;
begin
  Close;

  FRequestCS.Free;
  FEmptyEvent.Free;
  FDoneByteCS.Free;

  FWaveOutThread.Free;
  inherited Destroy;
end;

procedure TSoundOut.DoneOutput(DoneSize: Integer);
begin
  if Assigned(FOnDoneOutput) then begin
    FOnDoneOutput(Self, DoneSize);
  end;
end;

procedure TSoundOut.Flush;
begin
  if not IsOpen then begin
    Exit;
  end;

  if 0 < FBufAvailableLen then begin
    WaveWrite;

    FWaveOutThread.WaitForProcessMessages;
  end;
end;

function TSoundOut.GetDoneBytes: Integer;
var
  info: TMMTime;
begin
  if not Assigned(FWaveStream) then begin
    info.wType := TIME_BYTES;
    FDoneByteCS.Enter;
    try
      CheckWaveOut(waveOutGetPosition(FWaveOutHandle, @info, SizeOf(info)));
      Result := info.cb-FLastTime;
      FLastTime := info.cb;
    finally
      FDoneByteCS.Leave;
    end;
  end
  else begin
    Result := 0;
  end;
end;

function TSoundOut.HasRoom: Boolean;
begin
  FRequestCS.Enter;
  try
    Result := ((FUsedBufCount < PCMOutBufCount) and
      (FBufAvailableLen < FBufItemSize));
  finally
    FRequestCS.Leave;
  end;
end;


procedure TSoundOut.MMWomDone(var Msg: TMessage);
var
  doneBytes: Integer;
begin
  if InterlockedDecrement(FUsedBufCount) <= 0 then begin
    FEmptyEvent.SetEvent;
    FWaveOutThread.TimeOut := INFINITE;
  end
  else begin
    FWaveOutThread.TimeOut := 100;
  end;

  Assert(0 <= FUsedBufCount);

  RequestCheck;

  if not Assigned(FWaveStream) then begin
    doneBytes := GetDoneBytes;
    if 0 < doneBytes then begin
      DoneOutput(doneBytes);
    end;
  end;
end;

procedure TSoundOut.MPMTimeOutThread(var Msg: TMessage);
begin
  if not Assigned(FWaveStream) then begin
    DoneOutput(GetDoneBytes);
  end;
end;

procedure TSoundOut.MPMWaveFileWrite(var Msg: TMessage);
var
  doneMsg: TMessage;
begin
  Assert(Assigned(FWaveStream));

  with FWaveOutHeaders[Msg.LParam] do begin
    FWaveStream.WriteBuffer(lpData[0], dwBufferLength);
    DoneOutput(dwBufferLength);
  end;

  FillChar(doneMsg, SizeOf(doneMsg), 0);
  doneMsg.Msg := MM_WOM_DONE;
  doneMsg.LParam := DWORD(@(FWaveOutHeaders[Msg.LParam]));
  MMWomDone(doneMsg);
end;


procedure TSoundOut.Open;

  procedure AllocateBuf;
  var
    bufIdx: Integer;
  begin
    FBufItemSize := (((int64(FChannels)*(FBitsPerSample div 8)*FSamplingRate*PCMOutBufTimeLen div 1000 div PCMOutBufCount)+3) div 4)*4;
    for bufIdx := 0 to PCMOutBufCount-1 do begin
      GetMem(FBufs[bufIdx], FBufItemSize);
      FillChar(FWaveOutHeaders[bufIdx], SizeOf(FWaveOutHeaders[bufIdx]), 0);
      with FWaveOutHeaders[bufIdx] do begin
        lpData := FBufs[bufIdx];
        dwBufferLength := FBufItemSize;
      end;
    end;
  end;

  procedure DeviceOpen;
  var
    bufIdx: Integer;
    waveFormat: TWaveFormatEx;
  begin
    FLastTime := 0;

    FillChar(waveFormat, 0, SizeOf(waveFormat));
    with waveFormat do begin
      wFormatTag := WAVE_FORMAT_PCM;
      nChannels := FChannels;
      nSamplesPerSec := FSamplingRate;
      wBitsPerSample := FBitsPerSample;
      nBlockAlign := FChannels*FBitsPerSample div 8;
      nAvgBytesPerSec := nBlockAlign*FSamplingRate;
      cbSize := 0;
    end;

    CheckWaveOut(MMSystem.WaveOutOpen(@FWaveOutHandle, WAVE_MAPPER, @waveFormat,
      DWORD(FWaveOutThread.ThreadID), 0, CALLBACK_THREAD or WAVE_ALLOWSYNC));

    SetVolumeToWaveDevice;

    AllocateBuf;

    for bufIdx := 0 to PCMOutBufCount-1 do begin
      CheckWaveOut(MMSystem.WaveOutPrepareHeader(FWaveOutHandle, @(FWaveOutHeaders[bufIdx]),
        SizeOf(FWaveOutHeaders[bufIdx])));
    end;

    FWaveOutThread.TimeOut := 100;
  end;

  procedure FileOpen;
  var
    waveHeader: TWaveHeader;
  begin
    FWaveStream := TFileStream.Create(FWaveFileName, fmCreate);

    with waveHeader do begin
      StrLCopy(MainChunk, 'RIFF', 4);
      FileSize := 0;
      StrLCopy(FormType, 'WAVE', 4);
      StrLCopy(SubChunk, 'fmt ', 4);
      ChunkLen := 16;
      Format := 1;
      Modus := 2;
      SampleRate := FSamplingRate;
      BlockSize := FChannels*FBitsPerSample div 8;
      BitRate := BlockSize*FSamplingRate;
      SampleDepth := FBitsPerSample;
      StrLCopy(DataChunk, 'data', 4);
      DataSize := 0;
    end;

    FWaveStream.WriteBuffer(waveHeader, SizeOf(waveHeader));

    AllocateBuf;
   end;

begin
  if IsOpen then begin
    Exit;
  end;

  try

    if FWaveFileName = '' then begin
      DeviceOpen;
    end
    else begin
      FileOpen;
    end;
    FBufIndex := 0;
    FBufAvailableLen := 0;
    FUsedBufCount := 0;
    FEmptyEvent.SetEvent;
  except
    Close;
    raise;
  end;

  FIsOpen := True;
end;


procedure TSoundOut.Pause;
begin
  if IsOpen and not Assigned(FWaveStream) then begin
    CheckWaveOut(MMSystem.WaveOutPause(FWaveOutHandle));
  end;
end;

procedure TSoundOut.RequestCheck;
begin
  if (FRequestedEvent <> nil) or (FRequestedWindowHandle <> 0) then begin
    if HasRoom then begin
      if FRequestedEvent <> nil then begin
        FRequestedEvent.SetEvent;
        FRequestedEvent := nil;
      end;
      if FRequestedWindowHandle <> 0 then begin
        Windows.PostMessage(FRequestedWindowHandle, MPM_PCMOUTHASROOM, 0, 0);
        FRequestedWindowHandle := 0;
      end;
    end;
  end;
end;

procedure TSoundOut.RequestEvent(Event: TEvent);
begin
  FRequestedEvent := Event;

  RequestCheck;
end;

procedure TSoundOut.RequestMessage(WindowHandle: THandle);
begin
  FRequestedWindowHandle := WindowHandle;

  RequestCheck;
end;

procedure TSoundOut.SetBitsPerSample(const Value: Integer);
begin
  if Value in [8,16] then begin
    FBitsPerSample := Value;
  end;
end;

procedure TSoundOut.SetChannels(const Value: Integer);
begin
  if Value in [1,2] then begin
    FChannels := Value;
  end;
end;

procedure TSoundOut.SetSamplingRate(const Value: Integer);
begin
  if 0 < Value then begin
    FSamplingRate := Value;
  end;
end;

procedure TSoundOut.SetVolume(const Value: Integer);
begin
  if Value in [0..100] then begin
    FVolume := Value;
    if IsOpen and not Assigned(FWaveStream) then begin
      SetVolumeToWaveDevice;
    end;
  end;
end;

procedure TSoundOut.SetVolBalance(const Value: Integer);
begin
  if (-100 <= Value) and (Value <= 100) then begin
    FVolBalance := Value;
    if IsOpen and not Assigned(FWaveStream) then begin
      SetVolumeToWaveDevice;
    end;
  end;
end;


procedure TSoundOut.SetVolumeToWaveDevice;
var
  lVol: DWORD;
  rVol: DWORD;
begin
  lVol := FVolume*65535 div 100;
  rVol := lVol;
  case FVolBalance of
    1..100: begin
      lVol := lVol*Cardinal(100-FVolBalance) div 100;
    end;
    -100..-1: begin
      rVol := rVol*Cardinal(100+FVolBalance) div 100;
    end;
  end;
  CheckWaveOut(MMSystem.WaveOutSetVolume(FWaveOutHandle, rVol shl 16+lVol));
end;

procedure TSoundOut.SetWaveFileName(const Value: TFileName);
begin
  if not IsOpen then begin
    FWaveFileName := Value;
  end;
end;

procedure TSoundOut.Stop;
begin
  if IsOpen and not Assigned(FWaveStream) then begin
    FBufAvailableLen := 0;
    MMSystem.WaveOutReset(FWaveOutHandle);
    FLastTime := 0;
  end;
end;

procedure TSoundOut.ThreadError(Sender: TObject; E: Exception;
  var Handled: Boolean);
begin
  if Assigned(FOnThreadError) then begin
    FOnThreadError(Self, E, Handled);
  end;
end;

procedure TSoundOut.Unpause;
begin
  if IsOpen and not Assigned(FWaveStream) then begin
    CheckWaveOut(MMSystem.WaveOutRestart(FWaveOutHandle));
  end;
end;

procedure TSoundOut.WaitForEmpty;
var
  handles: array[0..1] of THandle;
begin
  handles[0] := FWaveOutThread.Handle;
  handles[1] := FEmptyEvent.Handle;

  WaitForMultipleObjects(2, @handles, False, INFINITE);
end;

procedure TSoundOut.WaveWrite;
begin
  FRequestCS.Enter;
  try
    InterlockedIncrement(FUsedBufCount);
    FEmptyEvent.ResetEvent;
    Assert(FUsedBufCount <= PCMOutBufCount);
    FWaveOutHeaders[FBufIndex].dwBufferLength := FBufAvailableLen;
    FBufAvailableLen := 0;
  finally
    FRequestCS.Leave;
  end;

  if not Assigned(FWaveStream) then begin
    Assert(FWaveOutHandle <> 0);
    CheckWaveOut(MMSystem.WaveOutWrite(FWaveOutHandle, @(FWaveOutHeaders[FBufIndex]),
      SizeOf(FWaveOutHeaders[FBufIndex])));
  end
  else begin
    FWaveOutThread.PostMessage(MPM_WAVEFILEWRITE, 0, FBufIndex );
  end;
  FBufIndex := (FBufIndex+1) mod PCMOutBufCount;
end;

function  TSoundOut.Write(const Buf; Count: Integer): Integer;
var
  bufRoomLen: Integer;
  curPos: Integer;
  writeLen: Integer;
begin
  curPos := 0;
  Result := 0;
  while 0 < Count do  begin
    if not HasRoom then begin
      Exit;
    end;

    bufRoomLen := FBufItemSize-FBufAvailableLen;
    if Count <= bufRoomLen then begin
      writeLen := Count;
    end
    else begin
      writeLen := bufRoomLen;
    end;

    Move(PChar(@Buf)[curPos], FBufs[FBufIndex][FBufAvailableLen], writeLen);
    Dec(Count, writeLen);
    Inc(Result, writeLen);
    Inc(FBufAvailableLen, writeLen);
    Inc(curPos, writeLen);

    if FBufItemSize <= FBufAvailableLen then begin
      WaveWrite;
    end;
  end;
end;



{ TMP3Player }

function CpuCapsToCpuCapabilities(CpuCaps: LongWord): TMP3CpuCapabilities;
begin
  Result := [];
  if CpuCaps and 1 <> 0 then begin
    Include(Result, mccMMX);
  end;
  if CpuCaps and 2 <> 0 then begin
    Include(Result, mcc3DNow);
  end;
  if CpuCaps and 4 <> 0 then begin
    Include(Result, mccKNI);
  end;
  if CpuCaps and 8 <> 0 then begin
    Include(Result, mccE3DNow);
  end;
end;

function CpuCapabilitiesToCpuCaps(Capabilities: TMP3CpuCapabilities): LongWord;
begin
  Result := 0;
  if mccMMX in Capabilities then begin
    Inc(Result, 1);
  end;
  if mcc3DNow in Capabilities then begin
    Inc(Result, 2);
  end;
  if mccKNI in Capabilities then begin
    Inc(Result, 4);
  end;
  if mccE3DNow in Capabilities then begin
    Inc(Result, 8);
  end;
end;


procedure TMP3Player.ChangePosition(Sender: TObject);
begin
  if not(csDestroying in ComponentState) and
    Assigned(FOnChangePosition) then begin
    FOnChangePosition(Self);
  end;
end;

procedure TMP3Player.ChangeStatus(Sender: TObject);
begin
  if not(csDestroying in ComponentState) and
    Assigned(FOnChangeStatus) then begin
    FOnChangeStatus(Self);
  end;
end;

procedure TMP3Player.ClearInfo;
begin
  FTrack := '';
  FGenre := '';
  FYear := '';
  FArtist := '';
  FAlbum := '';
  FComment := '';
  FTitle := '';
  FInfoType := [];
  FRiffInfos.Clear;
end;

procedure TMP3Player.Close;
begin
  if IsOpen and (FStatus <> mstStop) then begin
    Stop;
  end;

  FReader.Close;
  if Assigned(FOutBuf) then begin
    FreeMem(FOutBuf);
    FOutBuf := nil;
  end;

  FFileName := '';

  if Assigned(FStream) and (mstOwn in FStreamType) then begin
    FStream.Free;
  end;
  FStream := nil;

  ClearInfo;
  FillChar(FFirstHeader, SizeOf(FFirstHeader), 0);
  FFirstRawHead := 0;
  FBitRate := 0;
  FChannels := 0;
  FLayer := 0;
  FVersion := 0;
  FSamplingRate := 0;
  FPCMDoneOutBytes := 0;
  FOutFrameBytes := 0;

  SetStatus(mstStop);
end;

constructor TMP3Player.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAutoPlay := True;
  FAutoOpen := True;
  FVolume := 100;
  FStatus := mstStop;
  FChangePosStep := 400;
  FRiffInfos := TStringList.Create;
  FPCMDoneOutBytesCS := TCriticalSection.Create;

  FUsingCpuCapabilities := MccAll;

  ClearInfo;

  FWindowHandle := AllocateHWnd(WndProc);

  FFramePosList := TThreadList.Create;

  FReader := TStreamReader.Create(InBufSize);

  FSoundOut := TSoundOut.Create;
  with FSoundOut do begin
    OnThreadError := Self.ThreadError;
    OnDoneOutput := PCMDoneOutput;
  end;

  FEqualizerCount := 6;

  FDecodeThread := TMPThread.Create(Self);
  with FDecodeThread do begin
    OnThreadError := ThreadError;
    Resume;
  end;
end;

destructor TMP3Player.Destroy;
begin
  Stop;
  Close;

  DeallocateHWnd(FWindowHandle);

  FSoundOut.Free;

  FDecodeThread.Free;

  FReader.Free;

  FFramePosList.Free;

  FRiffInfos.Free;

  FPCMDoneOutBytesCS.Free;

  inherited Destroy;
end;

procedure TMP3Player.EndPlay(Sender: TObject);
begin
  if Assigned(FOnEndPlay) then begin
    FOnEndPlay(Sender, FEndPlayReason);
  end;
  FEndPlayReason := merStoped;
end;

function TMP3Player.GetCapabilities: TMP3Capabilities;
begin
  Result := [mcbCanOpen];

  if IsOpen then begin
    Include(Result, mcbCanClose);

    if FStatus in [mstStop] then begin
      Include(Result, mcbCanPlay);
    end;

    if FStatus in [mstPlay, mstPause] then begin
      Include(Result, mcbCanStop);
    end;

    if (FStatus in [mstPlay]) and (FOutputFileName = '') then begin
      Include(Result, mcbCanPause);
    end;

    if (FStatus in [mstPause])  and (FOutputFileName = '') then begin
      Include(Result, mcbCanUnpause);
    end;

    if (mstSeekable in FStreamType) and (FStatus in [mstPlay, mstPause]) and
      (FOutputFileName = '') then begin
      Include(Result, mcbCanSeek);
    end;

    if FStatus in [mstStop] then begin
      Include(Result, mcbCanPlayToFile);
    end;
  end;
end;

function TMP3Player.GetEqualizer(Index: Integer): Integer;
begin
  if (Index < 0) or (32 <= Index) then begin
    raise EListError.CreateFmt(SListIndexError, [Index]);
  end;

  Result := FEqualizer[Index];
end;

function TMP3Player.GetEqualizerFreq(Index: Integer): Integer;
begin
  if (Index < 0) or (32 <= Index) then begin
    raise EListError.CreateFmt(SListIndexError, [Index]);
  end;

  if (FEqualizerMode = memSubBand) and (FSamplingRate = 0) then begin
    Result := 0;
  end
  else begin
    Result := FEqualizerFreq[Index];
  end;
end;

function TMP3Player.GetFrameBytes(var Buf; var H: TMpegHead): Integer;
var
  rawHead: TMpegRawHead;
begin
  Result := _head_info(Buf, 0, H);

  if 0 < Result then begin

    if not(H.Option in [1, 2, 3]) then begin
      Result := 0;
      Exit;
    end;

    Move(Buf, rawHead, SizeOf(rawHead));
    if not IsValidRawHeader(rawHead) then begin
      Result := 0;
      Exit;
    end;

    if FLayer = 1 then begin
      Inc(Result, H.Pad*4);
    end
    else begin
      Inc(Result, H.Pad);
    end;
  end;
end;

function TMP3Player.GetHasCpuCapabilities: TMP3CpuCapabilities;
begin
{$ifdef ASM_X86}
  Result := CpuCapsToCpuCapabilities(_get_cpu_caps);
{$else}
  Result := MccAll;
{$endif}
end;

function TMP3Player.GetIsOpen: Boolean;
begin
  Result := FStream <> nil;
end;

function TMP3Player.GetLength: integer;
begin
  Result := 0;
  if (0 < FSamplingRate) and (0 < FOutputBytes) then begin
    Result := Int64(FOutputBytes)*1000 div (FSamplingRate*FChannels*2);
  end
  else if (0 < FBitRate) and (FBodyBytes < MaxInt) then begin
    Result := Int64(FBodyBytes)*8*1000 div FBitRate;
  end;
end;

function TMP3Player.GetPosition: Integer;
begin
  Result := 0;
  with FSoundOut do begin
    if IsOpen then begin
      FPCMDoneOutBytesCS.Enter;
      try
        Inc(FPCMDoneOutBytes, GetDoneBytes);
      finally
        FPCMDoneOutBytesCS.Leave;
      end;
      Result := Int64(FPCMDoneOutBytes)*1000*8 div (SamplingRate*Channels*BitsPerSample);
    end;
  end;
end;

function TMP3Player.InitLMC(var h: TMpegHead; framebytes_arg,
  reduction_code, transform_code, convert_code,
  freq_limit: Integer): Integer;
begin
  if FLayer = 1 then begin
    Dec(framebytes_arg, h.Pad*4);
  end
  else begin
    Dec(framebytes_arg, h.Pad);
  end;

  Result := _audio_decode_init(h, framebytes_arg, reduction_code,
    transform_code, convert_code, freq_limit);
end;

function TMP3Player.IsValidRawHeader(RawH: TMpegRawHead): Boolean;
const
  mask = $000CFEFF;
begin
  Result := (FFirstRawHead and mask) = (RawH and mask);
end;

procedure TMP3Player.Loaded;
begin
  inherited Loaded;

  if (FEqualizerMode = memFreq) and
    not(csDesigning in ComponentState) then begin
    SetEqualizerFreqs(60, 16000);
  end;

  if FAutoOpen and (FFileName <> '') and
    not(csDesigning in ComponentState) then begin
    Open;
  end;
end;

procedure TMP3Player.MPMChangeEqualizer(var Msg: TMessage);

  function SubBandFreq(N: Integer): Integer;
  begin
    Assert(0 < FSamplingRate);
    Assert(0 <= N);
    Assert(N < 32);

    Result := Round(FSamplingRate/64.0*(N+0.5));
  end;

  function NSubBandFreq(N: Integer): Integer;
  begin
    Assert(0 < FSamplingRate);
    Assert(0 <= N);
    Assert(N < 576);

    Result := Round(FSamplingRate/1152.0*(N+0.5));
  end;

  procedure FreqMode;
  var
    bandIdx: Integer;
    freqIdx: Integer;
    nearestFreqIdx: Integer;
    minDistFreq: Single;
    distFreq: Single;
    freq: Integer;
  begin
    if FLayer = 3 then begin
      _enableEQ_addr^ := 0;
      _n_enableEQ_addr^ := Ord(FEqualizerEnabled);
      if FEqualizerEnabled then begin
        for bandIdx := 0 to 575 do begin
          minDistFreq := MaxInt;
          nearestFreqIdx := 0;
          for freqIdx := 0 to FEqualizerCount-1 do begin
            freq := FEqualizerFreq[freqIdx];
            if freq < 1 then begin
              freq := 1;
            end;
            distFreq := 1.0*freq/NSubBandFreq(bandIdx);
            if distFreq < 1.0 then begin
              distFreq := 1.0/distFreq;
            end;
            if distFreq < minDistFreq then begin
              minDistFreq := distFreq;
              nearestFreqIdx := freqIdx;
            end;
          end;
          _n_equalizer_addr(bandIdx)^ :=
            Power(10, FEqualizer[nearestFreqIdx]/100.0);
        end;
      end;
    end
    else begin
      _enableEQ_addr^ := Ord(FEqualizerEnabled);
      _n_enableEQ_addr^ := 0;
      if FEqualizerEnabled then begin
        for bandIdx := 0 to 31 do begin
          minDistFreq := MaxInt;
          nearestFreqIdx := 0;
          for freqIdx := 0 to FEqualizerCount-1 do begin
            freq := FEqualizerFreq[freqIdx];
            if freq < 1 then begin
              freq := 1;
            end;
            distFreq := 1.0*freq/SubBandFreq(bandIdx);
            if distFreq < 1.0 then begin
              distFreq := 1.0/distFreq;
            end;
            if distFreq < minDistFreq then begin
              minDistFreq := distFreq;
              nearestFreqIdx := freqIdx;
            end;
          end;
          _equalizer_addr(bandIdx)^ :=
            Power(10, FEqualizer[nearestFreqIdx]/100.0);
        end;
      end;
    end;
  end;

  procedure SubBandMode;
  var
    idx: Integer;
  begin
    _enableEQ_addr^ := Ord(FEqualizerEnabled);
    _n_enableEQ_addr^ := 0;
    for idx := 0 to 31 do begin
      _equalizer_addr(idx)^ := Power(10, FEqualizer[idx]/100.0);
    end;
    if 0 < FSamplingRate then begin
      for idx := 0 to 31 do begin
        FEqualizerFreq[idx] := Round(FSamplingRate/64.0*(idx+0.5));
      end;
    end;
  end;

begin
  RemoveMessages(MPM_CHANGEEQUALIZER, MPM_CHANGEEQUALIZER);

  if not IsOpen then begin
    Exit;
  end;
  
  case EqualizerMode of
    memFreq: begin
      FreqMode;
    end;
    memSubBand: begin
      SubBandMode;
    end;
  end;
end;

procedure TMP3Player.MPMChangePosition(var Msg: TMessage);
begin
  RemoveMessages(MPM_CHANGEPOSITION, MPM_CHANGEPOSITION);
  ChangePosition(Self);
end;

procedure TMP3Player.MPMChangeStatus(var Msg: TMessage);
begin
  RemoveMessages(MPM_CHANGESTATUS, MPM_CHANGESTATUS);
  ChangeStatus(Self);
end;

procedure TMP3Player.MPMDecodeEnd(var Msg: TMessage);
begin
  FEndPlayReason := merSuccessful;
  if mstSeekable in FStreamType then begin
    Stop;
  end
  else begin
    Close;
  end;
end;

procedure TMP3Player.MPMDecodeError(var Msg: TMessage);
var
  e: Exception;
  event: TEvent;
begin
  e := Exception(Msg.LParam);
  event := TEvent(Msg.WParam);
  try
    if e <> nil then begin
      Application.ShowException(e);
    end;
  finally
    if event <> nil then begin
      event.SetEvent;
    end;
  end;

  FEndPlayReason := merFailure;
  Stop;
end;

procedure TMP3Player.MPMEndPlay(var Msg: TMessage);
begin
  RemoveMessages(MPM_ENDPLAY, MPM_ENDPLAY);
  EndPlay(Self);
end;

procedure TMP3Player.MPMPause(var Msg: TMessage);
begin
  FDecodeThread.WatchEvent.ResetEvent;
  FSoundOut.Pause;
end;

procedure TMP3Player.MPMSeek(var Msg: TMessage);
var
  aimPCMOutSize: int64;
  aimFrameIdx: int64;
  pausing: Boolean;
  frames: TList;
  curSyncPos: Integer;

  function SkipFrame: Boolean;
  var
    header: TMpegHead;
    frameBytes: Integer;
  begin
    Result := False;

    if not FReader.Fill(SizeOf(TMpegRawHead)) then begin
      Exit;
    end;

    frameBytes := GetFrameBytes(FReader.Buffer[0], header);
    if frameBytes <= 0 then begin
      Exit;
    end;

    if int64(FBodyPos)+FBodyBytes < FReader.Position+frameBytes then begin
      Exit;
    end;

    if not FReader.Skip(frameBytes) then begin
      Exit;
    end;

    Result := True;
  end;

begin
  Assert(mstSeekable in FStreamType);
  Assert(0<= Msg.LParam);

  pausing := FStatus = mstPause;
  FSoundOut.Stop;
  FSoundOut.WaitForEmpty;
  ResetDecode;

  aimPCMOutSize := Int64(Msg.LParam)*FSamplingRate*FChannels*2 div 1000;
  aimFrameIdx := (aimPCMOutSize+FOutFrameBytes-1) div FOutFrameBytes;
  if MaxInt < aimFrameIdx then begin
    aimFrameIdx := MaxInt;
  end;

  frames := FFramePosList.LockList;
  try
    if frames.Count <= aimFrameIdx then begin
      FReader.Seek(Integer(frames[frames.Count-1]), soFromBeginning);
      if not SkipFrame then begin
        aimFrameIdx := frames.Count-1;
      end
      else begin
        while frames.Count <= aimFrameIdx do begin

          curSyncPos := FReader.Position;

          if not SkipFrame then begin
            aimFrameIdx := frames.Count-1;
            Break;
          end;

          frames.Add(Pointer(curSyncPos));
        end;
      end;
    end;

    FReader.Seek(Integer(frames[aimFrameIdx]), soFromBeginning);
    FPCMDoneOutBytes := aimFrameIdx*FOutFrameBytes;
  finally
    FFramePosList.UnlockList;
  end;

  if pausing then begin
    FDecodeThread.WatchEvent.ResetEvent;
    FSoundOut.Pause;
  end;
end;

procedure TMP3Player.MPMStop(var Msg: TMessage);
begin
  with FSoundOut do begin
    Stop;
    Close;
  end;
  FDecodeThread.WatchEvent.ResetEvent;
end;

procedure TMP3Player.MPMUnpause(var Msg: TMessage);
begin
  FSoundOut.Unpause;
  FDecodeThread.WatchEvent.SetEvent;
end;

procedure TMP3Player.MPMWatchEvent(var Msg: TMessage);
var
  inOut: TInOut;
  wroteLen: Integer;
  header: TMpegHead;

  procedure EOD;
  begin
    FBodyBytes := FReader.Position-FBodyPos;
    Exit;
  end;

begin
  if FOutBufAvailableLen = 0 then begin

    if FBodyBytes <= FReader.Position-FBodyPos then begin
      FSoundOut.RequestEvent(nil);
      FSoundOut.Flush;
      FSoundOut.WaitForEmpty;
      FDecodeThread.WatchEvent.ResetEvent;
      Self.PostMessage(MPM_DECODEEND, 0, 0);
      Exit;
    end;

    if FFrameBytes <= 0 then begin
      if not FReader.Fill(SizeOf(TMpegRawHead)) then begin
        EOD;
        Exit;
      end;
      FFrameBytes := GetFrameBytes(FReader.Buffer[0], header);
      if FFrameBytes <= 0 then begin
        EOD;
        Exit;
      end;
    end;

    if FNeedInitDecode then begin
      if InitLMC(header, FFrameBytes, 0,0,0, 24000) = 0 then begin
        EOD;
        Exit;
      end;
      FNeedInitDecode := False;
    end;

    if not FReader.Fill(FFrameBytes) then begin
      EOD;
      Exit;
    end;

    inOut := _audio_decode(FReader.Buffer[0], FOutBuf[0]);

    if inOut.InBytes <= 0 then begin
      EOD;
      Exit;
    end;

    FOutBufAvailableLen := inOut.OutBytes;
    FReader.Skip(inOut.InBytes);
    FFrameBytes := 0;
  end;

  Assert(0 < FOutBufAvailableLen);

  if FSoundOut.HasRoom then begin
    wroteLen := FSoundOut.Write(FOutBuf[0], FOutBufAvailableLen);
    Dec(FOutBufAvailableLen, wroteLen);
    Move(FOutBuf[wroteLen], FOutBuf[0], FOutBufAvailableLen);
  end
  else begin
    FDecodeThread.WatchEvent.ResetEvent;
    FSoundOut.RequestEvent(FDecodeThread.WatchEvent);
    with FReader do begin
      Fill(BufSize-AvailableBytes);
    end;
  end;

  if FSoundOut.BufRoomRate <= 25 then begin
    Sleep(0);
  end;
end;


procedure TMP3Player.Open;
var
  openingFileName: TFileName;
begin
  if FFileName <> '' then begin
    openingFileName := FFileName;
    OpenStream(TFileStream.Create(FFileName, fmOpenRead or fmShareDenyWrite),
      [mstSeekable, mstOwn]);
    FFileName := openingFileName;
  end
  else begin
    Close;
  end;
end;

const
  VbrFramesFlag = $1;
  VbrBytesFlag = $2;
  VbrTocFlag = $4;
  VbrScaleFlag = $8;

function  ReadBigEndianInteger(const Buf): Integer;
begin
  Result := Ord(PChar(@Buf)[0]);
  Result := Result shl 8;
  Result := Result or Ord(PChar(@Buf)[1]);
  Result := Result shl 8;
  Result := Result or Ord(PChar(@Buf)[2]);
  Result := Result shl 8;
  Result := Result or Ord(PChar(@Buf)[3]);
end;


procedure TMP3Player.OpenStream(Stream: TStream; StreamType: TMP3StreamType);
var
  topPos: Cardinal;
  decInfo: TDecInfo;
  xingPos: Integer;
  xingFlags: Integer;
begin
  try
    Close;
  except
    if (Stream <> nil) and (mstOwn in StreamType) then begin
      Stream.Free;
    end;
    raise;
  end;

  FStream := Stream;
  FStreamType := StreamType;

  if IsOpen then begin

    try
      FFramePosList.Clear;
      FReader.Open(FStream, mstSeekable in FStreamType);
      GetMem(FOutBuf, OutBufSize);

      if mstSeekable in FStreamType then begin
        FBodyPos := 0;
        FBodyBytes := FReader.Size;
        FOutputBytes := 0;
        FTailInfoPos := MaxInt;

        ReadHeadInfo;

        if FTailInfoPos < FReader.Size then begin
          FReader.Seek(FTailInfoPos, soFromBeginning);
        end
        else begin
          FReader.Seek(FReader.Size, soFromBeginning);
        end;
        ReadTailInfo;

        FReader.Seek(FBodyPos, soFromBeginning);
      end
      else begin
        FBodyPos := 0;
        FBodyBytes := MaxInt;
        FTailInfoPos := MaxInt;

        ReadHeadInfo;
      end;

      FOutBufAvailableLen := 0;
      FPCMDoneOutBytes := 0;
      FLastChangePos := -FChangePosStep;

      FReader.Fill(MaxFrameBytes);

      if _head_info3(FReader.Buffer[0], FReader.AvailableBytes, FFirstHeader,
        FBitRate, topPos) <= 0 then begin
        raise EMP3Error.Create(SInvalidMP3Format);
      end;

      if 0 < topPos then begin
        Inc(FBodyPos, topPos);
        if not FReader.Skip(topPos) then begin
          raise EMP3Error.Create(SInvalidMP3Format);
        end;
        FReader.Fill(MaxFrameBytes);
        if FReader.AvailableBytes < SizeOf(FFirstRawHead) then begin
          raise EMP3Error.Create(SInvalidMP3Format);
        end;
      end;
      Move(FReader.Buffer[0], FFirstRawHead, SizeOf(FFirstRawHead));
      FFramePosList.Add(Pointer(FReader.Position));
      FFrameBytes := GetFrameBytes(FReader.Buffer[0], FFirstHeader);
      if (FFrameBytes <= 0) or not(FFirstHeader.Option in [1, 2, 3]) then begin
        raise EMP3Error.Create(SInvalidMP3Format);
      end;

      case FFirstHeader.Option of
        1: begin
          FLayer := 3;
        end;
        2: begin
          FLayer := 2;
        end;
        3: begin
          FLayer := 1;
        end;
      else
        raise EMP3Error.Create(SInvalidMP3Format);
      end;
      case FFirstHeader.ID of
        0: begin
          case FFirstHeader.Sync of
            1: begin
              FVersion := 2;
            end;
            2: begin
              FVersion := 3;
            end;
          else
            raise EMP3Error.Create(SInvalidMP3Format);
          end;
        end;
        1: begin
          FVersion := 1;
        end;
      else
        raise EMP3Error.Create(SInvalidMP3Format);
      end;
      if not FReader.Fill(FFrameBytes) then begin
        raise EMP3Error.Create(SInvalidMP3Format);
      end;


      if InitLMC(FFirstHeader, FFrameBytes, 0,0,0, 24000) = 0 then begin
        raise EMP3Error.Create(SInvalidMP3Format);
      end;
      FNeedInitDecode := False;

      _audio_decode_info(decInfo);

      with FSoundOut do begin
        SamplingRate := decInfo.Samprate;
        BitsPerSample := decInfo.Bits;
        Channels := decInfo.Channels;
      end;

      FSamplingRate := decInfo.Samprate;
      FChannels := decInfo.Channels;
      FOutFrameBytes := decInfo.Outvalues*decInfo.Bits div 8;

      xingPos := 0;
      case FFirstHeader.ID of
        0: begin  //  MPEG 2 or 2.5
          if FFirstHeader.Mode <> 3 then begin
            Inc(xingPos, 21);
          end
          else begin
            Inc(xingPos, 13);
          end;
        end;
        1: begin  //  MPEG 1
          if FFirstHeader.Mode <> 3 then begin
            Inc(xingPos, 36);
          end
          else begin
            Inc(xingPos, 21);
          end;
        end;
      end;
      if StrLComp(@(FReader.Buffer[xingPos]), 'Xing', 4) = 0 then begin
        FBitRate := 0;
        Inc(xingPos, 4);

        xingFlags := ReadBigEndianInteger(FReader.Buffer[xingPos]);
        Inc(xingPos, 4);

        if (xingFlags and VbrFramesFlag) <> 0 then begin
          FOutputBytes := ReadBigEndianInteger(FReader.Buffer[xingPos])*FOutFrameBytes;
          Inc(xingPos, 4);
        end;

        if (xingFlags and VbrBytesFlag) <> 0 then begin
          FBodyBytes := ReadBigEndianInteger(FReader.Buffer[xingPos]);
//          Inc(xingPos, 4);
        end;
      end;

    except
      Close;
      raise;
    end;
    PostUniqMessage(MPM_CHANGEEQUALIZER, 0, 0);
    SetStatus(mstStop);
  end;

  if FAutoPlay then begin
    Play;
  end;
end;

procedure TMP3Player.Pause;
begin
  if mcbCanPause in Capabilities then begin
    with FDecodeThread do begin
      PostMessage(MPM_PAUSE, 0, 0);
      WaitForProcessMessages;
    end;
    SetStatus(mstPause);
  end;
end;

procedure TMP3Player.PCMDoneOutput(Sender: TObject; DoneSize: Integer);
var
  pos: Integer;
begin
  FPCMDoneOutBytesCS.Enter;
  try
    Inc(FPCMDoneOutBytes, DoneSize);
  finally
    FPCMDoneOutBytesCS.Leave;
  end;

  pos := Position;
  if FChangePosStep <= pos-FLastChangePos then begin
    PostUniqMessage(MPM_CHANGEPOSITION, 0, 0);
    FLastChangePos := pos;
  end;
end;

procedure TMP3Player.Play;
begin
  if mcbCanPlay in Capabilities then begin

    try
      with FSoundOut do begin
        WaveFileName := Self.FOutputFileName;
        Open;
      end;
      FDecodeThread.WatchEvent.SetEvent;
    except
      Stop;
      raise;
    end;

    SetStatus(mstPlay);
    FEndPlayReason := merStoped;
    PostUniqMessage(MPM_CHANGEPOSITION, 0, 0);
  end;
end;


procedure TMP3Player.PlayToFile(FileName: TFileName);
begin
  if mcbCanPlayToFile in Capabilities then begin
    FOutputFileName := FileName;
    Play;
  end;
end;

procedure TMP3Player.PostMessage(Msg: UINT; wParam: WPARAM; lParam: LPARAM);
begin
  Assert(FWindowHandle <> 0);
  Windows.PostMessage(FWindowHandle, Msg, WParam, LParam);
end;

procedure TMP3Player.PostUniqMessage(Msg: UINT; wParam: WPARAM;
  lParam: LPARAM);
var
  message: TMsg;
begin
  Assert(FWindowHandle <> 0);

  if not PeekMessage(message, FWindowHandle, Msg, Msg, PM_NOREMOVE) then begin
    Windows.PostMessage(FWindowHandle, Msg, WParam, LParam);
  end;
end;

type
  TID3V1Tag = packed record
    Tag: array[0..2] of Char;
    Title: array[0..29] of Char;
    Artist: array[0..29] of Char;
    Album: array[0..29] of Char;
    Year: array[0..3] of Char;
    Comment: array[0..29] of Char;
    Genre: Byte;
  end;
  PID3V1Tag = ^TID3V1Tag;

  TID3V2Tag = packed record
    Tag: array[0..2] of Char;
    Version: Byte;
    Revision: Byte;
    Flags: Byte;
    Size: array[0..3] of Byte;
  end;
  PID3V2Tag = ^TID3V2Tag;

  TRiffHeadChunk = packed record
    ID: array[0..3] of Char;
    Size: LongInt;
    FormType: array[0..3] of Char;
  end;
  PRiffHeadChunk = ^TRiffHeadChunk;
  TRiffCommonChunk = packed record
    ID: array[0..3] of Char;
    Size: LongInt;
  end;
  PRiffCommonChunk = ^TRiffCommonChunk;
  TRiffListChunk = TRiffHeadChunk;
  PRIffListChunk = ^TRiffListChunk;

function CharArrayToString(Chars: PChar; Size: Integer): String;
begin
  SetLength(Result, Size);
  FillChar(Result[1], Size, 0);
  StrLCopy(PChar(Result), Chars, Size);
  Result := TrimRight(Result);
end;

//  N は正数と仮定
function  RoundUpToEven(N: Integer): Integer;
begin
  Result := (N+1) div 2 *2;
end;

procedure TMP3Player.ReadHeadInfo;

  function  ReadID3V2Tag: Boolean;
  var
    pTag: PID3V2Tag;
  begin
    Result := False;

    if not FReader.Fill(SizeOf(TID3V2Tag)) then begin
      Exit;
    end;
    pTag := PID3V2Tag(FReader.Buffer);
    if StrLComp(pTag^.Tag, 'ID3', 3) <> 0 then begin
      Exit;
    end;

    with pTag^ do begin
      FBodyPos := Integer(Size[0]) shl 21+
                  Integer(Size[1]) shl 14+
                  Integer(Size[2]) shl 7+
                  Integer(Size[3]);
    end;

    Result := True;
  end;

  function  ReadRiffTag: Boolean;
  var
    pHeadChunk: PRiffHeadChunk;
    pCommonChunk: PRiffCommonChunk;
  begin
    Result := False;

    if not FReader.Fill(SizeOf(TRiffHeadChunk)) then begin
      Exit;
    end;
    pHeadChunk := PRiFFHeadChunk(FReader.Buffer);
    if StrLComp(pHeadChunk^.ID, 'RIFF', 4) <> 0 then begin
      Exit;
    end;
    FReader.Skip(SizeOf(TRiffHeadChunk));

    while True do begin
      if not FReader.Fill(SizeOf(TRiffCommonChunk)) then begin
        Exit;
      end;
      pCommonChunk := PRiFFCommonChunk(FReader.Buffer);
      if pCommonChunk^.Size <= 0 then begin
        Exit;
      end;

      if StrLComp(pCommonChunk^.ID, 'data', 4) = 0 then begin
        FBodyPos := FReader.Position+SizeOf(TRiffCommonChunk);
        FBodyBytes := pCommonChunk^.Size;
        FTailInfoPos := FBodyPos+RoundUpToEven(FBodyBytes);
        Result := True;
        Exit;
      end;

      FReader.Skip(RoundUpToEven(pCommonChunk^.Size+SizeOf(TRiffCommonChunk)));
    end;
  end;

begin
  ClearInfo;

  Assert(FStream <> nil);

  if ReadID3V2Tag then begin
    FInfoType := FInfoType+[mitID3V2];
  end
  else if ReadRiffTag then begin
    FInfoType := FInfoType+[mitRiff];
  end;

end;

procedure TMP3Player.ReadTailInfo;

  function  ReadID3V1Tag: Boolean;
  var
    pTag: PID3V1Tag;
  begin
    Result := False;

    if not FReader.FillTail(SizeOf(TID3V1Tag)) then begin
      Exit;
    end;
    pTag := PID3V1Tag(FReader.Buffer);
    if StrLComp(pTag^.Tag, 'TAG', 3) <> 0 then begin
      Exit;
    end;

    FTitle := CharArrayToString(pTag^.Title, SizeOf(pTag^.Title));
    FArtist := CharArrayToString(pTag^.Artist, SizeOf(pTag^.Artist));
    FAlbum := CharArrayToString(pTag^.Album, SizeOf(pTag^.Album));
    FYear := CharArrayToString(pTag^.Year, SizeOf(pTag^.Year));
    FComment := CharArrayToString(pTag^.Comment, SizeOf(pTag^.Comment));
    FGenre := GenreTbl[Ord(pTag^.Genre)];
    if pTag^.Comment[28] = #0 then begin
      FTrack := IntToStr(Ord(pTag^.Comment[29]));
    end;

    Result := True;
  end;

  function  ReadRiffTag: Boolean;
  var
    pListChunk: PRiffListChunk;
    pCommonChunk: PRiffCommonChunk;
    infoName: String;
    info: String;
    infoSize: Integer;
    listEndPos: Integer;
  begin
    Result := False;

    if FTailInfoPos < FReader.Position then begin
      Exit;
    end;

    if not FReader.Skip(FTailInfoPos-FReader.Position) then begin
      Exit;
    end;

    while True do begin

      if not FReader.Fill(SizeOf(TRiffCommonChunk)) then begin
        Exit;
      end;
      pCommonChunk := PRiFFCommonChunk(FReader.Buffer);
      if pCommonChunk^.Size < 0 then begin
        Exit;
      end;

      if StrLComp(pCommonChunk^.ID, 'LIST', 4) = 0 then begin

        if not FReader.Fill(SizeOf(TRiffListChunk)) then begin
          Exit;
        end;
        pListChunk := PRiFFListChunk(FReader.Buffer);

        if StrLComp(pListChunk^.FormType, 'INFO', 4) = 0 then begin
          listEndPos := Int64(FReader.Position)+pListChunk^.Size+
            SizeOf(TRiffCommonChunk);

          if not FReader.Skip(SizeOf(TRiffListChunk)) then begin
            Exit;
          end;

          while FReader.Position < listEndPos do begin
            if not FReader.Fill(SizeOf(TRiffCommonChunk)) then begin
              Exit;
            end;
            pCommonChunk := PRiFFCommonChunk(FReader.Buffer);

            infoName := CharArrayToString(pCommonChunk^.ID, SizeOf(pCommonChunk^.ID));
            infoSize := pCommonChunk^.Size;
            if not FReader.Skip(SizeOf(TRiffCommonChunk)) then begin
              Exit;
            end;

            if infoSize < 0 then begin
              Exit;
            end;

            if infoName = 'IID3' then begin
              Result := True;
              Exit;
            end;

            if not FReader.Fill(infoSize) then begin
              Exit;
            end;
            info := CharArrayToString(FReader.Buffer, infoSize);
            if (infoName <> '') and (info <> '') then begin
              FRiffInfos.Add(infoName+'='+info);
            end;

            if not FReader.Skip(RoundUpToEven(infoSize)) then begin
              Exit;
            end;
          end;
          Result := True;
        end;
      end
      else begin
        if not FReader.Skip(RoundUpToEven(pCommonChunk^.Size+SizeOf(TRiffCommonChunk))) then begin
          Exit;
        end;
      end;

    end;
  end;

begin
  Assert(FStream <> nil);

  if mitRiff in FInfoType then begin
    ReadRiffTag;
  end;
  if ReadID3V1Tag then begin
    FInfoType := FInfoType+[mitID3V1];
  end;
end;


procedure TMP3Player.ResetDecode;
begin
  FOutBufAvailableLen := 0;
  FFrameBytes := 0;
  FPCMDoneOutBytes := 0;
  FLastChangePos := -FChangePosStep;
end;

procedure TMP3Player.RemoveMessages(MsgFilterMin, MsgFilterMax: UINT);
var
  msg: TMsg;
begin
  Assert(MsgFilterMin <= MsgFilterMax);
  while PeekMessage(msg, FWindowHandle, MsgFilterMin, MsgFilterMax,
    PM_REMOVE) do begin
  end;
end;

procedure TMP3Player.Seek(NewPosition: Integer);
begin
  if (0 <= NewPosition) and (mcbCanSeek in Capabilities) then begin
    with FDecodeThread do begin
      PostMessage(MPM_SEEK, 0, NewPosition);
      WaitForProcessMessages;
    end;
    PostUniqMessage(MPM_CHANGEPOSITION, 0, 0);
  end;
end;

procedure TMP3Player.SetAutoOpen(const Value: Boolean);
begin
  FAutoOpen := Value;
  if FAutoOpen and not(csDesigning in ComponentState) and
    not(csLoading in ComponentState) then begin
    Open;
  end;
end;

procedure TMP3Player.SetAutoPlay(const Value: Boolean);
begin
  FAutoPlay := Value;
  if IsOpen and (FStatus in [mstStop, mstPause]) then begin
    Play;
  end;
end;

procedure TMP3Player.SetChangePosStep(const Value: Integer);
begin
  if 100 <= Value then begin
    FChangePosStep := Value;
  end;
end;

procedure TMP3Player.SetEqualizer(Index: Integer; const Value: Integer);
begin
  if (Index < 0) or (32 <= Index) then begin
    raise EListError.CreateFmt(SListIndexError, [Index]);
  end;

  if (-100.0 <= Value) and (Value <= 100.0) then begin
    FEqualizer[Index] := Value;
    PostUniqMessage(MPM_CHANGEEQUALIZER, 0,0);
  end;
end;

procedure TMP3Player.SetEqualizerCount(const Value: Integer);
begin
  if (0 < Value) and (Value <> FEqualizerCount) then begin
    FEqualizerCount := Value;
    PostUniqMessage(MPM_CHANGEEQUALIZER, 0, 0);
  end;
end;

procedure TMP3Player.SetEqualizerEnabled(const Value: Boolean);
begin
  if Value <> FEqualizerEnabled then begin
    FEqualizerEnabled := Value;
    PostUniqMessage(MPM_CHANGEEQUALIZER, 0, 0);
  end;
end;

procedure TMP3Player.SetEqualizerFreq(Index: Integer;
  const Value: Integer);
begin
  if (Index < 0) or (32 <= Index) then begin
    raise EListError.CreateFmt(SListIndexError, [Index]);
  end;

  if (FEqualizerMode = memFreq) and
    (1 <= Value) and (Value <= 24000) then begin
    FEqualizerFreq[Index] := Value;
    PostUniqMessage(MPM_CHANGEEQUALIZER, 0, 0);
  end;
end;

procedure TMP3Player.SetEqualizerFreqs(MinFreq, MaxFreq: Integer);
var
  freqIdx: Integer;
begin
  if (FEqualizerMode = memFreq) and
    (1 <= MinFreq) and (MinFreq <= MaxFreq) and (MaxFreq <= 24000) then begin

    FEqualizerFreq[0] := MinFreq;
    for freqIdx := 1 to FEqualizerCount-2 do begin
      FEqualizerFreq[freqIdx] :=
        Round(
          FEqualizerFreq[freqIdx-1]*
          Power(1.0*MaxFreq/FEqualizerFreq[freqIdx-1],
            1.0/(FEqualizerCount-freqIdx)));
      Assert(FEqualizerFreq[freqIdx-1] <= FEqualizerFreq[freqIdx]);
    end;
    FEqualizerFreq[FEqualizerCount-1] := MaxFreq;

    PostUniqMessage(MPM_CHANGEEQUALIZER, 0, 0);
  end;
end;

procedure TMP3Player.SetEqualizerMode(const Value: TMP3EqualizerMode);
begin
  if FEqualizerMode <> Value then begin
    FEqualizerMode := Value;
    PostUniqMessage(MPM_CHANGEEQUALIZER, 0, 0);
  end;
end;

procedure TMP3Player.SetFileName(const Value: TFileName);
begin
  FFileName := Value;
  if FAutoOpen and not(csDesigning in ComponentState) and
    not(csLoading in ComponentState) then begin
    Open;
  end;
end;

procedure TMP3Player.SetStatus(Value: TMP3Status);
var
  needEndPlayEvent: Boolean;
begin
  needEndPlayEvent := IsOpen and
    (FStatus in [mstPlay, mstPause]) and (Value = mstStop);
  FStatus := Value;
  PostUniqMessage(MPM_CHANGESTATUS, 0, 0);
  if needEndPlayEvent then begin
    PostMessage(MPM_ENDPLAY, 0, 0);
  end;
end;

procedure TMP3Player.SetUsingCpuCapabilities(const Value: TMP3CpuCapabilities);
begin
{$ifdef ASM_X86}
  if not(csDesigning in ComponentState) then begin
    _set_using_cpu_caps(CpuCapabilitiesToCpuCaps(Value));
    FUsingCpuCapabilities := CpuCapsToCpuCapabilities(_get_using_cpu_caps);
  end
  else begin
    FUsingCpuCapabilities := Value * mccALL;
  end;
{$endif}
end;

procedure TMP3Player.SetVolBalance(const Value: Integer);
begin
  if (-100 <= Value) and (Value <= 100) then begin
    FVolBalance := Value;
    FSoundOut.VolBalance := FVolBalance;
  end;
end;

procedure TMP3Player.SetVolume(const Value: Integer);
begin
  if Value in [0..100] then begin
    if (Value = 0) and
      (csLoading in ComponentState) and
      not(csDesigning in ComponentState) then begin
      FVolume := FSoundOut.Volume;
    end
    else begin
      FVolume := Value;
      FSoundOut.Volume := FVolume;
    end;
  end;
end;

procedure TMP3Player.Stop;
begin
  FOutputFileName := '';
  with FDecodeThread do begin
    PostMessage(MPM_STOP, 0, 0);
    WaitForProcessMessages;
  end;

  if IsOpen and (mstSeekable in FStreamType) then begin
    FReader.Seek(FBodyPos, soFromBeginning);
  end;

  ResetDecode;
  FNeedInitDecode := True;

  SetStatus(mstStop);
  PostUniqMessage(MPM_CHANGEPOSITION, 0, 0);

  if IsOpen and not(mstSeekable in FStreamType) then begin
    Close;
  end;
end;

procedure TMP3Player.ThreadError(Sender: TObject; E: Exception;
  var Handled: Boolean);
var
  event: TEvent;
begin
  event := TSimpleEvent.Create;
  try
    PostMessage(MPM_DECODEERROR, DWORD(event), DWORD(E));
    event.WaitFor(INFINITE);
    Handled := True;
  finally
    event.Free;
  end;
end;

procedure TMP3Player.Unpause;
begin
  if mcbCanUnpause in Capabilities then begin
    with FDecodeThread do begin
      PostMessage(MPM_UNPAUSE, 0, 0);
      WaitForProcessMessages;
    end;
    SetStatus(mstPlay);
  end;
end;

procedure TMP3Player.WndProc(var Message: Tmessage);
begin
  case Message.Msg of
    MPM_FIRST..MPM_LAST: begin
      Dispatch(Message);
    end;
  else
    with Message do begin
      Result := DefWindowProc(FWindowHandle, Msg, wParam, lParam);
    end;
  end;
end;

end.

