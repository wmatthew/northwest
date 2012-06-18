<?php
require_once('../../../reckon/data/mysql_connect.php');

$current_ip = $_SERVER['REMOTE_ADDR'];

$fields = "CONCAT(x,'_',y),act,count(*)";
$groups = "x,y,act";
$query = "SELECT $fields FROM northwest_log GROUP BY $groups";

$result = getQueryResult($query);

$wins  = array();
$plays = array();
while ($row = mysql_fetch_row($result)) {
  switch ($row[1]) {
    case 'win':
      $wins[$row[0]] = $row[2];
      break;
    case 'play':
    case 'start':
      $plays[$row[0]] = $row[2];
      break;
  }
}

$boardSize = 12;
$br = " ";

echo("hw=new Array();$br"); // hw = historical wins on that tile
echo("hp=new Array();$br"); // hp = historical plays on that tile

for ($i=0; $i<$boardSize; $i++) {
 echo("hw[$i]=new Array();$br");
 echo("hp[$i]=new Array();$br");

 for ($j=0; $j<$boardSize; $j++) {
  $index = (1000+$i) . "_" . (1000+$j);
  $wCount = $wins[$index] ? $wins[$index] : 0;
  $pCount = $plays[$index] ? $plays[$index] : 0;
  
  echo("hw[$i][$j]=$wCount;$br");
  echo("hp[$i][$j]=$pCount;$br");
 }
}

echo("history_loaded = true;$br");
