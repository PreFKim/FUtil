unit sThirdParty;
{$I sDefs.inc}

interface

uses
  SysUtils, Classes, Windows, Graphics, Controls, imglist, comctrls, StdCtrls,
  {$IFNDEF ALITE}sToolBar, {$ENDIF}
  {$IFDEF USEPNG}PngImageList, PngFunctions, PngImage, {$ENDIF}
  sCommonData, sConst, sBitBtn, sSpeedButton;


var
  ThirdPartySkipForms: TStringList;
  InitDevEx: procedure (const Active: boolean);
  CheckDevEx: function (const Control: TControl): boolean;
  RefreshDevEx: procedure;


type
  TacDrawGlyphData = record
    DstBmp: TBitmap;
    Canvas: TCanvas;
    Images: TCustomImageList;
    ImageIndex: integer;
    Glyph: TBitmap;
    SkinIndex: integer;
    SkinManager: TObject;
    ImgRect: TRect;
    NumGlyphs: integer;
    Enabled: boolean;
    Blend: integer;
    Down: boolean;
    Grayed: boolean;
    CurrentState: integer;
    DisabledGlyphKind: TsDisabledGlyphKind;
    Reflected: boolean;
  end;


function GetImageCount(ImgList: TCustomImageList): integer;
procedure DrawBtnGlyph(Button: TControl; Canvas: TCanvas = nil);
procedure CopyToolBtnGlyph(ToolBar: TToolBar; Button: TToolButton; State: TCustomDrawState; Stage: TCustomDrawStage; var Flags: TTBCustomDrawFlags; BtnBmp: TBitmap);
procedure acDrawGlyphEx(const DrawData: TacDrawGlyphData);


implementation

uses
  math,
  {$IFDEF DEVEX2011}acLFPainter, {$ENDIF}
  {$IFDEF DEVEX6}acLFPainter6, {$ENDIF} // for projects which uses the DEVEX key
  sDefaults, sGraphUtils, acAlphaImageList, acntUtils, acPNG, sButton, sAlphaGraph, sSkinManager, sMessages;


function GetImageCount(ImgList: TCustomImageList): integer;
begin
  Result := 0;
  if ImgList = nil then
    Exit;
{$IFDEF USEPNG}
  if ImgList is TPngImageList then
    Result := TPngImageList(ImgList).PngImages.Count
  else
{$ENDIF}
    if ImgList is TsVirtualImageList then
      Result := TsVirtualImageList(ImgList).Count
    else
      Result := ImgList.Count;
end;


procedure acDrawGlyphEx(const DrawData: TacDrawGlyphData);
var
  GrayColor: TColor;
  IRect: TRect;
  Bmp: TBitmap;
  MaskColor: TsColor;
  nEvent: TNotifyEvent;
  b: boolean;
  X, Y: integer;
  S0, S: PRGBAArray;
  DeltaS: integer;
  SrcRect: TRect;
  TmpPng: TPNGGraphic;
  ActBlend: integer;
{$IFDEF USEPNG}
  PngCopy: TPNGObject;
{$ENDIF}
  SM: TsSkinManager;

  procedure PrepareGlyph;
  begin
    with DrawData do begin
      Bmp.Width := Images.Width;
      Bmp.Height := Images.Height;
      Bmp.PixelFormat := pf32bit;
      if Images.BkColor <> clNone then
        MaskColor.C := Images.BkColor
      else
        MaskColor.C := clFuchsia;

      Bmp.Canvas.Brush.Color := MaskColor.C;
      Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));
      Images.GetBitmap(ImageIndex, Bmp);
    end;
  end;

begin
  with DrawData do begin
    SM := TsSkinManager(SkinManager);
    if (CurrentState = 0) and Grayed or (not Enabled and (dgGrayed in DisabledGlyphKind)) then
      if SkinIndex >= 0 then
        GrayColor := SM.gd[SkinIndex].Props[0].Color
      else
        GrayColor := $FFFFFF
    else
      GrayColor := clNone;

    if Assigned(Images) and (ImageIndex > -1) and (GetImageCount(Images) > ImageIndex) then begin
      IRect := ImgRect;
{$IFDEF USEPNG}
      if (Images is TPngImageList) and (TPngImageCollectionItem(TPngImageList(Images).PngImages.Items[ImageIndex]).PngImage <> nil) then begin
        PngCopy := nil;
        if Enabled then
          if (CurrentState > 0) or ((Blend = 0) and not Grayed) then begin
            PngCopy := TPngImageCollectionItem(TPngImageList(Images).PngImages.Items[ImageIndex]).PngImage;
            if DstBmp <> nil then
              PngCopy.Draw(DstBmp.Canvas, IRect)
            else
              PngCopy.Draw(Canvas, IRect);
          end
          else begin
            if Blend > 0 then begin
              PngCopy := TPNGObject.Create;
              PngCopy.Assign(TPngImageCollectionItem(TPngImageList(Images).PngImages.Items[ImageIndex]).PngImage);
              MakeImageBlended(PngCopy);
            end;
            if Grayed then begin
              if PngCopy = nil then begin
                PngCopy := TPNGObject.Create;
                PngCopy.Assign(TPngImageCollectionItem(TPngImageList(Images).PngImages.Items[ImageIndex]).PngImage);
              end;
              MakeImageGrayscale(PngCopy);
            end;
            if PngCopy = nil then
              PngCopy := TPngImageCollectionItem(TPngImageList(Images).PngImages.Items[ImageIndex]).PngImage;

            if DstBmp <> nil then
              PngCopy.Draw(DstBmp.Canvas, IRect)
            else
              PngCopy.Draw(Canvas, IRect);

            FreeAndNil(PngCopy);
          end
        else begin
          if dgBlended in DisabledGlyphKind then begin
            PngCopy := TPNGObject.Create;
            PngCopy.Assign(TPngImageCollectionItem(TPngImageList(Images).PngImages.Items[ImageIndex]).PngImage);
            MakeImageBlended(PngCopy);
          end;
          if dgGrayed in DisabledGlyphKind then begin
            if PngCopy = nil then begin
              PngCopy := TPNGObject.Create;
              PngCopy.Assign(TPngImageCollectionItem(TPngImageList(Images).PngImages.Items[ImageIndex]).PngImage);
            end;
            MakeImageGrayscale(PngCopy);
          end;
          if PngCopy = nil then
            PngCopy := TPngImageCollectionItem(TPngImageList(Images).PngImages.Items[ImageIndex]).PngImage;

          if DstBmp <> nil then
            PngCopy.Draw(DstBmp.Canvas, IRect)
          else
            PngCopy.Draw(Canvas, IRect);

          FreeAndNil(PngCopy);
        end;
      end
      else
{$ENDIF}
      if (Images is TsAlphaImageList) or (Images is TsVirtualImageList) then
        if DstBmp <> nil then
          DrawAlphaImgList(Images, DstBmp, IRect.Left, IRect.Top, ImageIndex,
                 max(iffi((CurrentState = 0), Blend, 0), iffi(not Enabled and (dgBlended in DisabledGlyphKind), 50, 0)), GrayColor,
                 CurrentState + integer(Down), NumGlyphs, Reflected)
        else
          DrawAlphaImgListDC(Images, DrawData.Canvas.Handle, IRect.Left, IRect.Top, ImageIndex,
                 max(iffi((CurrentState = 0), Blend, 0), iffi(not Enabled and (dgBlended in DisabledGlyphKind), 50, 0)), GrayColor,
                 CurrentState + integer(Down), NumGlyphs, Reflected)
      else begin
        Bmp := TBitmap.Create;
        try
          if DstBmp <> nil then begin
            PrepareGlyph;
            if not Enabled then begin
              if dgGrayed in DisabledGlyphKind then
                GrayScaleTrans(Bmp, TsColor(Bmp.Canvas.Pixels[0, 0]));

              if dgBlended in DisabledGlyphKind then
                BlendTransRectangle(DstBmp, IRect.Left, IRect.Top, Bmp, Rect(0, 0, Bmp.Width, Bmp.Height), 0.5)
              else
                CopyTransBitmaps(DstBmp, Bmp, IRect.Left, IRect.Top, MaskColor);
            end
            else begin
              if (CurrentState = 0) and Grayed then
                GrayScaleTrans(Bmp, TsColor(Bmp.Canvas.Pixels[0, 0]));

              if (CurrentState = 0) and (Blend > 0) then
                BlendTransRectangle(DstBmp, IRect.Left, IRect.Top, Bmp, Rect(0, 0, Bmp.Width, Bmp.Height), Blend / 100)
              else
                CopyTransBitmaps(DstBmp, Bmp, IRect.Left, IRect.Top, MaskColor);
            end;
          end
          else begin
            Images.Draw(DrawData.Canvas, IRect.Left, IRect.Top, ImageIndex);
{            Bmp.Transparent := True;
            Bmp.TransparentColor := clFuchsia;
            if not Enabled then
              if dgGrayed in DisabledGlyphKind then
                GrayScaleTrans(Bmp, TsColor(Bmp.Canvas.Pixels[0, 0]));

            BitBlt(DrawData.Canvas.Handle, IRect.Left, IRect.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);}
//            Bmp.Canvas.Draw(IRect.Left, IRect.Top, Bmp);
          end;
        finally
          FreeAndNil(Bmp);
        end;
      end;
    end
    else
      if Assigned(Glyph) and not Glyph.Empty then begin
        if (Glyph.PixelFormat = pfDevice) or not Enabled or (Glyph.PixelFormat = pf32bit) and ((DefaultManager = nil) or DefaultManager.Options.CheckEmptyAlpha) then begin
          nEvent := Glyph.OnChange;
          Glyph.OnChange := nil;
          Glyph.HandleType := bmDIB;
          if (Glyph.Handle <> 0) and (Glyph.PixelFormat = pf32bit) then begin // Checking for an empty alpha-channel
            b := False;
            if InitLine(Glyph, Pointer(S0), DeltaS) then
              for Y := 0 to Glyph.Height - 1 do begin
                S := Pointer(LongInt(S0) + DeltaS * Y);
                for X := 0 to Glyph.Width - 1 do
                  if S[X].A <> 0 then begin
                    b := True;
                    Break;
                  end;
              end;
              
            if not b then
              Glyph.PixelFormat := pf24bit;
          end;
          Glyph.OnChange := nEvent;
        end;
        if (Glyph.PixelFormat = pf32bit) then begin // Patch if Png, dosn't work in std. mode
          SrcRect.Left := WidthOf(ImgRect) * min(CurrentState, NumGlyphs - 1);
          SrcRect.Top := 0;
          SrcRect.Right := SrcRect.Left + WidthOf(ImgRect);
          SrcRect.Bottom := Glyph.Height;

          if DstBmp <> nil then begin
            Glyph.Handle;
            CopyBmp32(ImgRect, SrcRect, DstBmp, Glyph, EmptyCI, False, GrayColor, iffi(CurrentState = 0, Blend, 0), Reflected);
          end
          else begin
            TmpPng := TPNGGraphic.Create;
            TmpPng.PixelFormat := pf32bit;
            TmpPng.Width := WidthOf(ImgRect);
            TmpPng.Height := HeightOf(ImgRect);
            BitBlt(TmpPng.Canvas.Handle, 0, 0, TmpPng.Width, Glyph.Height, Glyph.Canvas.Handle, SrcRect.Left, SrcRect.Top, SRCCOPY);
            TmpPng.Reflected := Reflected;
            if not Enabled and (dgBlended in DisabledGlyphKind) then
              ActBlend := max(50, Blend)
            else
              ActBlend := Blend;

            if (CurrentState = 0) and (ActBlend <> 0) then
              if InitLine(TmpPng, Pointer(S0), DeltaS) then
                for Y := 0 to TmpPng.Height - 1 do begin
                  S := Pointer(LongInt(S0) + DeltaS * Y);
                  for X := 0 to TmpPng.Width - 1 do
                    S[X].A := (S[X].A * ActBlend) div 100;
                end;

            if (not Enabled and (dgGrayed in DisabledGlyphKind)) or ((CurrentState = 0) and Grayed) then
              GrayScale(TmpPng);

            Bmp := CreateBmp32(WidthOf(ImgRect), HeightOf(ImgRect));
            BitBlt(Bmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, Canvas.Handle, ImgRect.Left, ImgRect.Top, SRCCOPY);
            Bmp.Canvas.Draw(0, 0, TmpPng);
            BitBlt(Canvas.Handle, ImgRect.Left, ImgRect.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
            FreeAndNil(Bmp);              
            FreeAndNil(TmpPng);
          end;
        end
        else
          if DstBmp = nil then begin
            Bmp := CreateBmp32(WidthOf(ImgRect), HeightOf(ImgRect));
            BitBlt(Bmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height, Canvas.Handle, ImgRect.Left, ImgRect.Top, SRCCOPY);
            sGraphUtils.DrawGlyphEx(Glyph, Bmp, Rect(0, 0, Bmp.Width, Bmp.Height), NumGlyphs, Enabled, DisabledGlyphKind, CurrentState, Blend, Down, Reflected);
            BitBlt(Canvas.Handle, ImgRect.Left, ImgRect.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
            FreeAndNil(Bmp);
          end
          else
            sGraphUtils.DrawGlyphEx(Glyph, DstBmp, ImgRect, NumGlyphs, Enabled, DisabledGlyphKind, CurrentState, Blend, Down, Reflected);
      end
  end;
end;


procedure DrawBtnGlyph(Button: TControl; Canvas: TCanvas = nil);
var
  DrawData: TacDrawGlyphData;
begin
  DrawData.Canvas := Canvas;
  if Button is TsButton then
    with TsButton(Button) do begin
      DrawData.Images            := Images;
      DrawData.Glyph             := nil;
      DrawData.ImageIndex        := GlyphIndex;
      DrawData.SkinIndex         := SkinData.SkinIndex;
      DrawData.SkinManager       := SkinData.SkinManager;
      DrawData.DstBmp            := SkinData.FCacheBmp;
      DrawData.ImgRect           := GlyphRect;
      DrawData.NumGlyphs         := 1;
      DrawData.Enabled           := Enabled;
      DrawData.Blend             := 0;
      DrawData.Down              := CurrentState = 2;
      DrawData.Grayed            := SkinData.Skinned and (SkinData.SkinManager <> nil) and SkinData.SkinManager.Effects.DiscoloredGlyphs;
      DrawData.CurrentState      := CurrentState;
      DrawData.DisabledGlyphKind := DefDisabledGlyphKind;
      DrawData.Reflected         := Reflected;
    end
  else
    if Button is TsBitBtn then
      with TsBitBtn(Button) do begin
        DrawData.Images            := Images;
        DrawData.Glyph             := Glyph;
        DrawData.ImageIndex        := ImageIndex;
        DrawData.SkinIndex         := SkinData.SkinIndex;
        DrawData.SkinManager       := SkinData.SkinManager;
        DrawData.DstBmp            := SkinData.FCacheBmp;
        DrawData.ImgRect           := ImgRect;
        DrawData.NumGlyphs         := NumGlyphs;
        DrawData.Enabled           := Enabled;
        DrawData.Blend             := Blend;
        DrawData.Down              := Down;
        DrawData.Grayed            := Grayed;
        DrawData.CurrentState      := CurrentState;
        DrawData.DisabledGlyphKind := DisabledGlyphKind;
        DrawData.Reflected         := Reflected;
      end
    else
      if Button is TsSpeedButton then
        with TsSpeedButton(Button) do begin
          DrawData.Images            := Images;
          DrawData.Glyph             := Glyph;
          DrawData.ImageIndex        := ImageIndex;
          DrawData.SkinManager       := SkinData.SkinManager;
          DrawData.CurrentState      := CurrentState;

          if (DrawData.CurrentState = 0) and
               (SkinData.FOwnerControl.Parent <> nil) and
                 (SkinData.SkinIndex >= 0) and
                   (SkinData.SkinManager.gd[SkinData.SkinIndex].Props[0].Transparency = 100) then
            DrawData.SkinIndex := GetFontIndex(Button, SkinData.SkinIndex, SkinData.SkinManager)
          else
            DrawData.SkinIndex := SkinData.SkinIndex;

          DrawData.DstBmp            := SkinData.FCacheBmp;
          DrawData.ImgRect           := ImgRect;
          DrawData.NumGlyphs         := NumGlyphs;
          DrawData.Enabled           := Enabled;
          DrawData.Blend             := Blend;
          DrawData.Down              := Down;
          DrawData.Grayed            := Grayed;
          DrawData.DisabledGlyphKind := DisabledGlyphKind;
          DrawData.Reflected         := Reflected;
        end
      else
        Exit;

  if DrawData.SkinIndex < 0 then
    DrawData.DstBmp := nil;

  acDrawGlyphEx(DrawData);
end;


procedure CopyToolBtnGlyph(ToolBar: TToolBar; Button: TToolButton; State: TCustomDrawState; Stage: TCustomDrawStage; var Flags: TTBCustomDrawFlags; BtnBmp: TBitmap);
var
  DrawData: TacDrawGlyphData;
  sd: TsCommonData;

  function AddedWidth: integer;
  begin
    Result := integer(Button.Style = tbsDropDown) * 8;
  end;

  function ImgRect: TRect;
  begin
    with ToolBar do
      if not List then begin
        Result.Left := (Button.Width - Images.Width) div 2 + 1 - AddedWidth;
        Result.Top := (Button.Height - Images.Height - integer(ShowCaptions) * (BtnBmp.Canvas.TextHeight('A') + 3)) div 2;
        Result.Right := Result.Left + Images.Width;
        Result.Bottom := Result.Top + Images.Height;
      end
      else begin
        Result.Left := 5;
        Result.Top := (Button.Height - Images.Height) div 2;
        Result.Right := Result.Left + Images.Width;
        Result.Bottom := Result.Top + Images.Height;
      end;
  end;

  function GetImages: TCustomImageList;
  begin
    with ToolBar do
      if (DrawData.CurrentState <> 0) and Assigned(HotImages) and (Button.ImageIndex < GetImageCount(HotImages)) then
        Result := HotImages
      else
        if not Button.Enabled and Assigned(DisabledImages) then
          Result := DisabledImages
        else
          Result := Images;
  end;

begin
  with ToolBar do begin
    if (cdsHot in State) then
      DrawData.CurrentState := 1
    else
      if (cdsChecked in State) then
        DrawData.CurrentState := 2
      else
        DrawData.CurrentState := 0;

{$IFNDEF ALITE}
    if ToolBar is TsToolBar then
      sd := TsToolBar(ToolBar).SkinData
    else
{$ENDIF}    
      sd := TsCommonData(SendMessage(Handle, SM_ALPHACMD, MakeWParam(0, AC_GETSKINDATA), 0));

    if sd <> nil then begin
      DrawData.Grayed            := (sd.SkinManager <> nil) and sd.SkinManager.Effects.DiscoloredGlyphs;
      DrawData.SkinManager       := sd.SkinManager;
      if (DrawData.CurrentState = 0) and
           (sd.FOwnerControl.Parent <> nil) and
             (sd.SkinManager.gd[sd.SkinIndex].Props[0].Transparency = 100) then
        DrawData.SkinIndex := GetFontIndex(ToolBar, sd.SkinIndex, sd.SkinManager)
      else
        DrawData.SkinIndex := sd.SkinIndex;
    end
    else begin
      DrawData.Grayed            := False;
      DrawData.SkinManager       := nil;
      DrawData.SkinIndex         := -1;
    end;
    if (cdsDisabled in State) and (DisabledImages <> nil) then
      DrawData.Images            := DisabledImages
    else
      DrawData.Images            := Images;

    DrawData.Glyph             := nil;
    DrawData.ImageIndex        := Button.ImageIndex;
    DrawData.ImgRect           := ImgRect;
    DrawData.NumGlyphs         := 1;
    DrawData.Enabled           := Enabled;
    DrawData.Blend             := 0;
    DrawData.Down              := DrawData.CurrentState = 2;
    DrawData.DisabledGlyphKind := [dgBlended];
    DrawData.Reflected         := False;
    DrawData.DstBmp            := BtnBmp;
  end;
  if (DrawData.CurrentState = 2) then
    if (DrawData.SkinManager = nil) or TsSkinManager(DrawData.SkinManager).ButtonsOptions.ShiftContentOnClick then
      OffsetRect(DrawData.ImgRect, 1, 1);

  acDrawGlyphEx(DrawData);
end;


initialization
  // Create a list of form types which will be excluded from skinning
  ThirdPartySkipForms := TStringList.Create;
  ThirdPartySkipForms.Sorted := True;
  ThirdPartySkipForms.Add('TApplication');
//  ThirdPartySkipForms.Add('TQRStandardPreview');
  ThirdPartySkipForms.Add('TfcPopup'); {FastCube popup}
  ThirdPartySkipForms.Add('TcxComboBoxPopupWindow');
  ThirdPartySkipForms.Add('TcxCustomPopupWindow');
  ThirdPartySkipForms.Add('TcxDateEditPopupWindow');
  ThirdPartySkipForms.Add('TcxGridFilterPopup');

  
finalization
  ThirdPartySkipForms.Free;

end.
