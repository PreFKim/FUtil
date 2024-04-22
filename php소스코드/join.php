<?PHP
$id = $_GET["id"];
$pw = $_GET["pw"];

mkdir("./Member/".$id, 0777);
$file = "./Member/".$id."/".$id;
$f = fopen($file, "w");
fwrite($f, $pw);
fclose($f);
?>