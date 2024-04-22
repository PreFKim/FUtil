<?PHP
$id = $_GET["id"];
$lists = $_GET["lists"];

$file = "./Member/".$id."/simple";
$f = fopen($file, "w");
fwrite($f, $lists);
fclose($f);
?>