<?php

set_time_limit(0);
require_once 'PHPExcel.php';

/*
  $inputFileName = 'E:/veryLarge2.csv';
  $objReader = PHPExcel_IOFactory::createReader('CSV');
  $objReader->load($inputFileName);
  var_dump('CSV mem usage: ' + memory_get_peak_usage());
 */

/*
  $inputFileName = 'E:/veryLarge2.xls';
  $objReader = PHPExcel_IOFactory::createReader('Excel5');
  $objReader->load($inputFileName);
  var_dump('XLS mem usage: ' . memory_get_peak_usage());
 */

/*
  $inputFileName = 'E:/veryLarge2.xlsx';
  $objReader = PHPExcel_IOFactory::createReader('Excel2007');
  $objReader->load($inputFileName);
  var_dump('XLSX mem usage: ' + memory_get_peak_usage());
 */

$handle = @fopen('E:/veryLarge2.csv', "r");
$beginLine = 10;
$read_rows = 20;
$returnCount = 0;

if($handle === false){
    echo 'Errors occur when reading file';
    exit;
}

while ($returnCount < $beginLine) {
    $char = fgetc($handle);
    if ($char === FALSE)
        break;
    else if ($char == "\n")
        $returnCount++;
}

for ($i = 0; $i < $read_rows, $buffer = fgets($handle); $i++) {
    $rows[] = $buffer;
}
@fclose($handle);
var_dump($rows);
var_dump(memory_get_peak_usage());
?>
