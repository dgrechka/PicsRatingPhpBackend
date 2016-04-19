<?php
header('Access-Control-Allow-Credentials: true');
header('Access-Control-Allow-Origin: http://itis.cs.msu.ru');
require_once "../config.inc.php";
require_once "../utils.inc.php";

$votername=$_GET['username'];
$galname=$_GET['voteName'];
$picWin=$_GET['picWin'];
$picLose=$_GET['picLose'];
$userSig=$_GET['userSig'];
$voteSig=$_GET['voteSig'];

$link = getDBLink();
$query_str = "CALL Vote('".$votername."','".$userSig."','".$galname."','".$picWin."','".$picLose."','".$voteSig."');";
$query = $link->query($query_str,MYSQLI_USE_RESULT);
#$result= [];
if (!$query) {
    die('Invalid query: ' . mysql_error());
}
#$entry = $query->fetch_assoc();

#$query->free();
$link->close();

http_response_code(200);

?>
