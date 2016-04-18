<?php
header('Access-Control-Allow-Credentials: true');
header('Access-Control-Allow-Origin: http://itis.cs.msu.ru');
require_once "../config.inc.php";
require_once "../utils.inc.php";

if(isset($_GET['GalleryName'])) {
	$galname=$_GET['GalleryName'];
	
	$link = getDBLink();
	$query_str = "CALL GetGalPictures('".$galname."');";
	$query = $link->query($query_str,MYSQLI_USE_RESULT);
	$result= [];
	if (!$query) {
		die('Invalid query: ' . mysql_error());
	}
	while ($row = $query->fetch_assoc()) {
		$picDesc = new stdClass();
		$picDesc->Name = $row['Name'];
		$picDesc->URL = $row['URL'];
		$picDesc->Caption = $row['Caption'];
		array_push($result,$picDesc);
	};

	$query->free();
	$link->close();
	
	//echo ("length is "+count($result));
	echo json_encode($result);
	header('Content-Type: application/json');
	http_response_code(200);	
}
else
{
	header("HTTP/1.1 400 GalleryName parameter is not specified");
}
?>