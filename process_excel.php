<?php

/** Error reporting */
error_reporting(E_ALL);
ini_set('display_errors', TRUE);
ini_set('display_startup_errors', TRUE);


define('EOL',(PHP_SAPI == 'cli') ? PHP_EOL : '<br />');

/** Include PHPExcel */
require_once 'Classes/PHPExcel.php';

// include_once('Smarty.class.php');
// $main_smarty = new Smarty;

// include('config.php');
// include(mnminclude.'html1.php');
// include(mnminclude.'link.php');
// include(mnminclude.'tags.php');
// include(mnminclude.'user.php');
// include(mnminclude.'smartyvariables.php');


//$filePath = "http://localhost:8888/colfusion/upload_raw_data/census_23456.xls";
//$filePath = 'williamlion_census.xlsx';

//check file exists or not
// if (file_exists($filePath)){
// 	echo "The file $filePath exists";
// }else{
// 	echo "The file $filePath does not exist";
// }


//print_r(getSheetName('williamlion_census.xlsx'));

//print_r(getAllContent('williamlion_census.xlsx', 1));

//print_r(getHeader('williamlion_census.xls', 0, 5, 'A'));

$phase = isset($_GET["phase"]) && is_numeric($_GET["phase"]) ? $_GET["phase"] : 2;

switch($phase) {
	case 0:
	    getAllContent();
	    break;
	case 1:
        getHeader();
        break;
    case 2:
        getSheetName();
}

exit;



function getSheetName(){
	
	// $dataset_name = $_SESSION['fname'];
	// $filePath = "upload_raw_data/".$dataset_name;
	$filePath = 'williamlion_census.xlsx';
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
    //echo $sheetnum;

    $sheetAllName = $PHPExcel->getSheetNames();
    //print_r($sheetAllName);
    $sheetlength = count($sheetAllName, 0);

	echo "<table border='1' id='display'>";
	echo "<th> Sheet </th> <th> Start row </th> <th> Start column </th>";

	for($i = 0; $i < $sheetlength; $i++){
		echo "<tr><td><select id='sheet".$i."'>";
		for($j = 0; $j < $sheetlength; $j++){
			echo "<option value='".$j."'>".$sheetAllName[$j]."</option>";
		}		
		echo "</select></td>";
		echo "<td><input type='text' name='row".$i."'></td>";
		echo "<td><input type='text' name='col".$i."'></td></tr>";

	}
	

	echo "</table>";

	//return $sheetAllName;   

}

function getAllContent(){

	$filePath = 'williamlion_census.xlsx';

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


}

//print_r(getHeader('williamlion_census.xls', 0, 5, 'A'));

//print_r(getHeader('tradestatistics.xls', 1, 23, 'A'));


//Get header after user choose start row and start column
function getHeader($filePath, $currentSheetNum, $startRow, $startColumn){

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

	$headerArray = array();

    $startColumn = PHPExcel_Cell::columnIndexFromString($startColumn)-1;
	$currentSheet = $PHPExcel->getSheet($currentSheetNum);
	$lastColumn = $currentSheet->getHighestColumn();
	$lastColumn = PHPExcel_Cell::columnIndexFromString($lastColumn)-1;


	for ($column = $startColumn; $column <= $lastColumn; $column++){

		//modified
		$cell = $currentSheet->getCellByColumnAndRow($column,$startRow)->getCalculatedValue();
		//echo 'Value of '.$column.' is '.$cell.'<br>';

        //still need extension of program
		if(!is_null($cell)){
			// if(strpos("=", $cell) == false){
			// 	$explosion = explode("=", $cell);
			// 	if(count($explosion) >1){
			// 		//print_r($explosion);echo "</br></br></br></br></br></br>";
			// 	    //echo $explosion[1];
			// 	    $cell = $currentSheet->getCell($explosion[1])->getValue();

			// 	}

			// }
			//echo $cell;


			$headerArray[PHPExcel_Cell::stringFromColumnIndex($column)] = $cell;
		}
		
	}
	

	//Blank for extension if header are in the start column


	return $headerArray;
}


?>