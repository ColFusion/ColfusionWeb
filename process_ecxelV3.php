<?php
include('config.php');
/** Error reporting */
error_reporting(E_ALL);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);


define('EOL',(PHP_SAPI == 'cli') ? PHP_EOL : '<br />');

/** Include PHPExcel */
require_once 'Classes/PHPExcel.php';


	$filePath = "williamlion_census.xlsx";//$_SESSION['file_name'];// //$_GET["filePath"];
	//$currentSheetNum = $_GET["curSheetNum"];
	echo $filePath;
		//$filePath = 'williamlion_census.xlsx';

		// Create new PHPExcel object and read EXCEL sheets
		$PHPExcel = new PHPExcel();

		//Checnk file type
		$PHPReader = new PHPExcel_Reader_Excel2007();
		if(!$PHPReader->canRead($filePath)){
			$PHPReader = new PHPExcel_Reader_Excel5();	
			if(!$PHPReader->canRead($filePath)){	
				echo 'no Excel';
			return ;
			}
		}

		$PHPExcel = $PHPReader->load($filePath);
		$sheetnum = $PHPExcel->getSheetCount();
		$sheetAllName = $PHPExcel->getSheetNames();


		$sheetArray = array();

		for ($currentSheetNum = 0; $currentSheetNum <= $sheetnum-1; $currentSheetNum++){
			$currentSheet = $PHPExcel->getSheet($currentSheetNum);
			echo '<table title = "'.$sheetAllName[$currentSheetNum].'">';
			echo '<tbody>';
			$lastColumn = $currentSheet->getHighestColumn();
			$lastColumn = PHPExcel_Cell::columnIndexFromString($lastColumn)-1;
			$lastRow = $currentSheet->getHighestRow();

			for ($row = 1; $row <= $lastRow; $row++){
				echo '<tr>';

			for ($column = 0; $column <= $lastColumn; $column++){
				$cell = $currentSheet->getCellByColumnAndRow($column,$row)->getCalculatedValue();
				echo '<td>'.$cell.'</td>';

   //if(!is_null($cell)){
 //   if(strpos("=", $cell) == false){
//    $explosion = explode("=", $cell);
//    if(count($explosion) >1){
// //print_r($explosion);echo "</br></br></br></br></br></br>";
//    //echo $explosion[1];
//        $cell = $currentSheet->getCell($explosion[1])->getValue();

//    }

 //   }
   	//$sheetArray[$row][$column] = $cell;
   //}
   	}
				echo '</tr>';

			}
			echo '</tbody>';
			echo '</table>';
		}


		//Blank for extension if header are in the start column


		//return $sheetArray;





?>