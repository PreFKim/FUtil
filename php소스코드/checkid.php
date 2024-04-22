<?PHP
$id = $_GET["id"];

$file = "./Member/".$id."/".$id;
if(file_exists($file))
{
 echo "Use";
}else{
 echo "Noid";
}
?>