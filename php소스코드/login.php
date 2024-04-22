<?PHP
$id = $_GET["id"];
$ps = $_GET["ps"];

$file = "./Member/".$id."/".$id;
if(file_exists($file))
{
 $f = fopen($file, "r");
 if($ps == fgets($f))
 {
  echo "Login success!";
 }
 fclose($f);
}
?>