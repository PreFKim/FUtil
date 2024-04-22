<?PHP
$id = $_GET["id"];
$filename = $GET["filename"];

$file = "./Member/".$id."/".$filename;
if(file_exists($file))
{
 echo "Use";
}else{
 echo "no file";
}
?>