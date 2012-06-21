<?php
require_once('../../../reckon/data/mysql_connect.php');

$min = 1000;
$max = $min + 30;
$br = "<br/>";

if (!isset($_GET['x']  ) ||
    !isset($_GET['y']  ) ||
    !isset($_GET['act'])) {
  exit("Not all inputs were set.");
}

$x = $min + (int) $_GET['x'];
$y = $min + (int) $_GET['y'];

if (!is_int($x) || !is_int($y)) {
  exit("Bad Input: " . '('.$x .','. $y.')');
}

if ($x < $min || $y < $min || $x > $max || $y > $max) {
  exit("Input out of bounds: " . '('.$x .','. $y.')');
}

if ($_GET[act] === 'start') {
  $act = 'start';
} else if ($_GET[act] === 'win') {
  $act = 'win';
} else {
  exit("Action unrecognized");
}

$ip = $_SERVER['REMOTE_ADDR'];
$time = time();

echo "X: "    . $x    . $br;
echo "Y: "    . $y    . $br;
echo "IP: "   . $ip   . $br;
echo "Time: " . $time . $br;
echo "Act: "  . $act  . $br;

$fields = "(x, y, time, ip, act)";
$values = "($x, $y, $time, '$ip', '$act')";
getQueryResult("INSERT INTO northwest_log $fields VALUES $values");

echo("Affected: " .mysql_affected_rows() . $br);
?>