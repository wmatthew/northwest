<?php
require_once('../../../reckon/data/mysql_connect.php');

$safety = 1000;
$max_reasonable = $safety + 100;
$b = "<br/>";

if (!isset($_GET['x']  ) ||
    !isset($_GET['y']  ) ||
    !isset($_GET['act'])) {

  exit("No Input.");

}

$x = $safety + (int)$_GET['x'];
$y = $safety + (int)$_GET['y'];
if (!is_int($x)||!is_int($y)) {
  exit("Bad Input: " . '('.$x .','. $y.')');
}
if ($x > $max_reasonable || $y > $max_reasonable) {
  exit("Big Input");
}

if ($_GET[act] == 'start') {
  $act = 'start';
} else if ($_GET[act] == 'win') {
  $act = 'win';
}
else {
  exit("Bad Act");
}

$ip = $_SERVER['REMOTE_ADDR'];
$time = time();

echo "X: " . $x . $b;
echo "Y: " . $y . $b;
echo "IP: " . $ip . $b;
echo "Time: " . $time . $b;
echo "Act: " . $act .$b;

$fields = "(x, y, time, ip, act)";
$values = "($x, $y, $time, '$ip', '$act')";

$query = "INSERT INTO northwest_log $fields VALUES $values";
getQueryResult($query);

echo("Affected: " .mysql_affected_rows() .$b);
?>