<?php
include_once('Smarty.class.php');
$main_smarty = new Smarty;

include ('DataImportWizard/process_excelV2.php');

include('config.php');
include(mnminclude.'html1.php');
include(mnminclude.'link.php');
include(mnminclude.'tags.php');
include(mnminclude.'user.php');
include_once(mnminclude.'utils.php');
include(mnminclude.'smartyvariables.php');

// breadcrumbs and page titles
$navwhere['text1'] = 'Upload Local File';
$navwhere['link1'] = 'uploadlocalfile.php';
$main_smarty->assign('navbar_where', $navwhere);
$main_smarty->assign('posttitle', 'Upload Local File');

if($current_user->authenticated != TRUE)
{
	$vars = '';
	check_actions('anonymous_story_user_id', $vars);
	if ($vars['anonymous_story'] != true)
		force_authentication();
}

//pagename
define('pagename', 'test');
$main_smarty->assign('pagename', pagename);

	    
    // determine which step of the submit process we are on
    if(isset($_POST["phase"]) && is_numeric($_POST["phase"]))
    	$phase = $_POST["phase"];
    else if(isset($_GET["phase"]) && is_numeric($_GET["phase"]))
    	$phase = $_GET["phase"];
    else
    	$phase = 0;
	
	switch ($phase) {
		case 0:
		display_wizard();
			break;
		case 1:
		generate();
			break;
	}

function display_wizard(){
	global $main_smarty, $the_template;
	echo $phase;echo "yes";
	$main_smarty->assign('tpl_center', $the_template . '/startWizard');
	$main_smarty->display($the_template . '/pligg.tpl');
}

function generate(){
	global $upload_dir, $db, $current_user,$main_smarty, $the_template;
	
	
	// the file name that should be uploaded		
	$file_tmp=$_FILES['upload_file']['tmp_name']; 
	$file_name=$_FILES['upload_file']['name']; 
	$unique_file_name="tingtest1.ktr";
	$upload_dir = get_misc_data('upload_directory');
	$upload_path=mnmpath.$upload_dir.$unique_file_name;

	$upload = move_uploaded_file($file_tmp, $upload_path);		
	/*create new ktr file*/
	$tmpDir = 'excel-to-target_schema.ktr';			
	$newDir ='0.ktr';
	copy($tmpDir,$newDir);

	$a1=$_POST["sheet"];
	$b1= $_POST["row"];
	$c1= $_POST["col"];

	$a=array ($a1,"","");
	$b=array($b1,"","");
	$c=array($c1,"","");
	$sheets = array($a, $b, $c);

	
	$spd=$_POST["spd"];
	$drd= $_POST["drd"];
	$start= $_POST["start"];
	$end=$_POST["end"];
	$start2= $_POST["start2"];
	$end2=$_POST["end2"];
	$location= $_POST["location"];
	$aggrtype= $_POST["aggrtype"];
	$location2= $_POST["location2"];
	$aggrtype2= $_POST["aggrtype2"];
	
	$process=new Process_excel;
	$arr_Sheet_name=$process->getSheetName('census.xls');

	$arr_Header=$process->getHeader('dataverse_census.xls', 0, 11, 'A');

	//print_r ($process->getHeader('tradestatistics.xls', 1, 23, 'A'));

     echo $start;
	
	/* adding url*/
	add_url(0,'http://colfusion.exp.sis.pitt.edu/colfusion/upload_raw_data/irule_dataverse_census.xls');
	echo "hello";
	//add_sheets(0, $sheets);
	addSheets(0, "Table HH-1", 10, 0);
	addConstants('Spd',$spd,'Date','yyyyMMdd');
	addConstants('Drd',$drd,'Date','yyyyMMdd');
	add_excel_input_fields($arr_Header);
	add_sample_target();
	
	//$arr_Header - $array_no_need_normalize
	$no_need_Array=array($start,$end,$location,$aggrtype);
	//print_r ($no_need_Array);
	//print_r($arr_Header);
	$result=array_diff($arr_Header, $no_need_Array);
//	print_r($result);

/*--------------------the second $result are from user , the first $result need to use AJAX to present to user------*/
	add_normalizer($result,$result);

		
	
	
	
	
	
	//for variable of star
	if($start!=""){
		//$start from excel
		update_target('Start',$start);
	}else{
		//$start from user input
		addConstants('Start_from_input',$start2,'Date','yyyyMMdd');
		update_target('Start','Start_from_input');
	}
	
	//for variable of end
	if($end!=""){
		//$start from excel
		update_target('End',$end);
	}else{
		//$start from user input
		addConstants('End_from_input',$end2,'Date','yyyyMMdd');
		update_target('End','End_from_input');
	}
	
	//for variable of location
	if($location!=""){
		echo $location;
		//$start from excel
		update_target('Location',$location);
	}else{
		//$start from user input
		echo $location2;
		addConstants('Location_from_input',$location2,'String','');
		update_target('Location','Location_from_input');
	}
	
	//for variable of aggrType
	if($aggrtype!=""){
		//$start from excel
		update_target('AggrType',$aggrtype);
	}else{
		//$start from user input
		addConstants('AggrType_from_input',$aggrtype2,'String','');
		update_target('AggrType','AggrType_from_input');
	}
	
	
	
	//add_normalize($ArrayKey,$ArrayValue);
    echo $start; echo "........1<br/>";
	echo $start2; echo ".......2<br/>";
	echo $end; echo "..........3<br/>";
	echo $end2; echo "...........4<br/>";
	echo $location; echo "............5<br/>";
	echo $location2; echo "..........6<br/>";
	echo $aggrtype; echo "..........7<br/>";
	echo $aggrtype2; echo "............8<br/>";
	echo $spd; echo ".........9<br/>";
	echo $drd; echo "..........10<br/>";
	
}


function add_url($sid,$URL){
	$xmldoc = new DOMDocument();
	$xmldoc->load('0.ktr');
	$xpathvar = new Domxpath($xmldoc);

	$queryResult = $xpathvar->query('//step/file/name[@id="url"]');
	$queryResult2 = $xpathvar->query('//step/spreadsheet_type[@id="sheet_type"]');
	$extension=pathinfo($URL, PATHINFO_EXTENSION);

	if($extension=='xls'){
		$queryResult2->item(0)->nodeValue="JXL";
	}else if($extension=='xlsx'){
	}
	
	foreach($queryResult as $result){	
		$result->nodeValue=$URL;
	}		
	print $xmldoc->save('0.ktr');
}
//need to modify
function add_sheets($sid, $sheets ){
	$temp_file = '0.ktr';
	$ktr = simplexml_load_file($temp_file);	

	$steps = $ktr->step;
	
	foreach($steps as $step){
		$name = $step->name;
		if($name == 'Excel Input File'){		
			for($i=0;$i<count($sheets[0]);$i++){
				$s = $step->sheets;
				echo  $sheets[0][0];
				$sheet = $s->addChild('sheet');
				$sheet->addChild('name', $sheets[0][$i]);
				$sheet->addChild('startrow', $sheets[1][$i]);
				$sheet->addChild('startcol', $sheets[2][$i]);
			}
		}
		file_put_contents($temp_file, $ktr->asXML());
	}
}

function addSheets($sid, $sheetname, $startrow, $startcolumn){
	$temp_file = '0.ktr';
	$ktr = simplexml_load_file($temp_file);	

	$steps = $ktr->step;
	foreach($steps as $step){
		$name = $step->name;
		echo $name;

		if($name == 'Excel Input File'){

			$sheets = $step->sheets;

			$sheet = $sheets->addChild('sheet');
			$sheet->addChild('name', $sheetname);
			$sheet->addChild('startrow', $startrow);
			$sheet->addChild('startcol', $startcolumn);

			echo $sheets->sheet;

			file_put_contents($temp_file, $ktr->asXML());
			
			// 	$sheet = array();

			// 	$sheet[] = array(
			// 		'name' => $sheetname,
			// 		'startrow' => $startrow,
			// 		'startcol' => $startcolumn);

			// 	//print_r($sheetsnode);
			// 	$sheet = $sheets->createElement('sheet');
			// 	$sheet->appendChild($sheet);

			// 	$ktr->save($temp_file);

		}else{
			echo "Not found";
		}		
	}	
}	

function add_excel_input_fields($Array){

	$temp_file = '0.ktr';
	$ktr = simplexml_load_file($temp_file);	

	$steps = $ktr->step;
	foreach($steps as $step){
		$name = $step->name;
		if($name == 'Excel Input File'){
			foreach($Array as $item){
				$fields = $step->fields;
				
				$field = $fields->addChild('field');
				$field->addChild('name', $item);
				$field->addChild('type', 'String');
				$field->addChild('length', '-1');
				$field->addChild('precision', '-1');
				$field->addChild('trim_type', 'none');
				$field->addChild('repeat', 'N');
				$field->addChild('format');
				$field->addChild('currency');
				$field->addChild('decimal');
				$field->addChild('group');
				echo $item;
			}
		}
	}
		 	file_put_contents($temp_file, $ktr->asXML());
}

function add_sample_target(){
	$temp_file = '0.ktr';
	$ktr = simplexml_load_file($temp_file);	
	echo "enter it";
	$steps = $ktr->step;
	foreach($steps as $step){
		$name = $step->name;
		if($name == 'Target Schema'){
			$fields = $step->fields;
			
			$field = $fields->addChild('field');
		
			$field->addChild('column_name', 'Spd');
			$field->addChild('stream_name', 'Spd');
			$field = $fields->addChild('field');
			$field->addChild('column_name', 'Drd');
			$field->addChild('stream_name', 'Drd');
			$field = $fields->addChild('field');
			$field->addChild('column_name', 'Dname');
			$field->addChild('stream_name', 'Dname');
			$field = $fields->addChild('field');
			$field->addChild('column_name', 'Sid');
			$field->addChild('stream_name', 'Sid');
			$field = $fields->addChild('field');
			$field->addChild('column_name', 'Eid');
			$field->addChild('stream_name', 'Eid');
			$field = $fields->addChild('field');
			$field->addChild('column_name', 'value');
			$field->addChild('stream_name', 'value');
		}
	}
	file_put_contents($temp_file, $ktr->asXML());
}

function update_target($name1,$value1){
	$temp_file = '0.ktr';
	$ktr = simplexml_load_file($temp_file);	

	$steps = $ktr->step;
	foreach($steps as $step){
		$name = $step->name;
		if($name == 'Target Schema'){
			$fields = $step->fields;
			
			$field = $fields->addChild('field');
			
			$field->addChild('column_name', $name1);
			$field->addChild('stream_name', $value1);
		}
	}
	file_put_contents($temp_file, $ktr->asXML());
}


//for each variable
function addConstants($name1,$value,$type,$format){
	$temp_file = '0.ktr';
	$ktr = simplexml_load_file($temp_file);	

	$steps = $ktr->step;
	foreach($steps as $step){
		$name = $step->name;
		if($name == 'Add Constants'){
			$fields = $step->fields;
	
			$field = $fields->addChild('field');
			$field->addChild('name', $name1);
			$field->addChild('type', $type);
			$field->addChild('format',$format);
			$field->addChild('currency');
			$field->addChild('decimal');
			$field->addChild('group');
			$field->addChild('nullif',$value);
			$field->addChild('length', '-1');
			$field->addChild('precision', '-1');
			
			
		}
	}
	file_put_contents($temp_file, $ktr->asXML());
}	

//$ArrayValue may be from user input
function add_normalizer($ArrayKey,$ArrayValue){
	$temp_file = '0.ktr';
	$ktr = simplexml_load_file($temp_file);	

	$steps = $ktr->step;
	foreach($steps as $step){
		$name = $step->name;
		if($name == 'Row Normalizer'){
			foreach (array_combine($ArrayKey, $ArrayValue) as $ArrayKey => $ArrayValue) {
				
				$fields = $step->fields;
				
				$field = $fields->addChild('field');
				$field->addChild('name', $ArrayKey);
				$field->addChild('value', $ArrayValue);
				$field->addChild('norm', 'value');
	
			}
		}
	}
	file_put_contents($temp_file, $ktr->asXML());
}


	
?>