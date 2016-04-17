<?php
require_once "config.inc.php";

function getDBLink() {
  global $dblocation,$username,$password,$db;  
  $link=new mysqli($dblocation,$username,$password,$db);
  if ($link->connect_error)
    {
    echo "</p><font color='#FF0000'>Connection with SQL server can't be estabished! Maybe server is down.<br/> ".mysql_error()."</font></p>";
    die();
    }
  else
    return $link;
}
?>