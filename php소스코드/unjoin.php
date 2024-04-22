<?PHP
$id = $_GET["id"];
$dirname =  $_SERVER['DOCUMENT_ROOT']."/Member/".$id;

if(is_dir($dirname)){
        $data_list = @opendir($dirname);
        while(false !== ($file = readdir($data_list))){
            if($file != "." && $file != "..") @unlink($dirname."/".$file);
        }
        closedir($data_list);
     @rmdir($dirname);
 echo "delete";
}else{
 echo "no folder";
}
?>

