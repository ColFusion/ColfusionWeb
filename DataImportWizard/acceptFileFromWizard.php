<?php

session_start();
set_time_limit(0);

include_once(realpath(dirname(__FILE__) . '/../config.php'));
include_once(mnminclude . 'html1.php');
include_once(mnminclude . 'link.php');
include_once(mnminclude . 'tags.php');
include_once(mnminclude . 'user.php');
include_once(mnminclude . 'utils.php');

include_once('../Smarty.class.php');
include_once('../Classes/CSVToExcelConverter.php');
include_once('FileUtil.php');
include_once('rawHttpParser.php');
include_once(realpath(dirname(__FILE__) . "/../DAL/DBImporters/DatabaseImporterFactory.php"));

// module system hook
$vars = '';
check_actions('submit_post_authentication', $vars);

// When mime type is application/octet-stream, parse input stream to get params.
$params = array();
parse_raw_http_request($params);

if(count($params) == 0){ // Params are from $_POST.
	$params = $_POST;
}

$sid = $params['sid'];
$uploadTimestamp = $params['uploadTimestamp'];
$fileType = $params['fileType'];
//TODO FIXME: once appeding of files is resolved uncomment here;
$excelFileMode = "jpon";//$params['excelFileMode'];
$dbType = $params['dbType'];

upload_0($sid, $uploadTimestamp, $fileType, $excelFileMode, $dbType);

function upload_0($sid, $uploadTimestamp, $fileType, $excelFileMode, $dbType) {

	$_SESSION["excelFileMode_$sid"] = $excelFileMode;

	// check file type
	$explodeRes = explode(".", $_FILES["upload_file"]["name"]);
	$extension = end($explodeRes);
	$mimes = array('xls', 'xlsx', 'csv', 'sql', 'zip');

	if (count($_FILES) <= 0) {

		$error = "ERROR: No file was uploaded.";
		$_SESSION["upload_file_$sid"]['error'] = $error;

	} else if (!in_array($extension, $mimes)) {

		$error = "ERROR: please upload excel, csv, sql, or zip file.";
		$_SESSION["upload_file_$sid"]['error'] = $error;

	} else {

		//save upload file
		if ($_FILES['upload_file']['error'] > 0) {

			$error = "ERROR: " . $_FILES['upload_file']['error'] . "</br>";
			$_SESSION["upload_file_$sid"]['error'] = $_FILES['upload_file']['error'];

		} else {

			$upload_dir = mnmpath . "upload_raw_data/$sid/";

			if (!file_exists($upload_dir)) {
				mkdir($upload_dir);
			}

			// Delete former files if user upload more than one time.
			if (isset($_SESSION["uploadTimestamp_$sid"]) && $_SESSION["uploadTimestamp_$sid"] != $uploadTimestamp) {
				emptyDir($upload_dir);
			}
			$_SESSION["uploadTimestamp_$sid"] = $uploadTimestamp;

			// the file name that should be uploaded
			$file_tmp = $_FILES['upload_file']['tmp_name'];
			$raw_file_name = $_FILES['upload_file']['name'];
			$ext = pathinfo($raw_file_name, PATHINFO_EXTENSION);

			$upload_path = $upload_dir . $raw_file_name;

			// check upload status
			if (!(move_uploaded_file($file_tmp, $upload_path))) {

				$error = "ERROR: failed to save file.";
				$_SESSION["upload_file_$sid"]['error'] = $_FILES['upload_file']['error'];

			} else {

				// If a csv file is provided, create a excel file and write the csv value to it.
				if (strtolower($ext) == 'csv') {

					/*$csvFilePath = $upload_path;
					$xlsxFilePath = FileUtil::convertCSVtoXLSX($csvFilePath);
					$xlsxFileName = pathinfo($xlsxFilePath, PATHINFO_BASENAME);
					$raw_file_name = $xlsxFileName;
					unlink($csvFilePath);*/
                    
				} else if (strtolower($ext) == 'zip') {

					//TODO FIXME: for now just set to append, later zip files always shoule be append
					// even though user chooses join, because zip file might be required to join with 
					// other excel files.
					$_SESSION["excelFileMode_$sid"] = "append";

					// If a zip file is provided, unzip all files.
					$zipFilePath = $upload_path;
					$zip = new ZipArchive;
					$res = $zip->open($zipFilePath);
					if ($res === TRUE) {
						$zip->extractTo($upload_dir);
						$zip->close();
					} else {
						$error = "ERROR: failed to unzip file.";
						$_SESSION["upload_file_$sid"]['error'] = $error;
					}

					// Convert all csv files into xlsx files.
					$dirFiles = scandir($upload_dir);
					$i = 1;
					foreach ($dirFiles as $filename) {
						$filePath = $upload_dir . $filename;
						if (FileUtil::isCSVFile($filePath)) {
							$newFilePath = $upload_dir . $i++ . '.csv';
							rename($filePath, $newFilePath);
							$filePath = $newFilePath;
							$csvFilePath = $filePath;
							$xlsxFilePath = FileUtil::convertCSVtoXLSX($csvFilePath);
							$xlsxFileName = pathinfo($xlsxFilePath, PATHINFO_BASENAME);
						}
						//unlink($filePath);
					}
                    
				} else if (strtolower($ext) == 'sql') {
					try {
						$dbImporter = DatabaseImporterFactory::createDatabaseImporter($dbType, $sid, my_pligg_base_no_slash);
						$dbImporter->importDbSchema($upload_path);
                        
                        // Store dump file path for the last step.
                        $_SESSION["dump_file_$sid"] = $upload_path;
					}
                    catch (Exception $e) {
						$_SESSION["upload_file_$sid"]['error'] = $e->getMessage();
					}
				}

				$loc_msg = "uploaded successfully";
				$_SESSION["upload_file_$sid"]['loc'] = $loc_msg;
			}
		}
	}

	$json_response = array();
	if (isset($_SESSION["upload_file_$sid"]['error'])) {
		$json_response['isSuccessful'] = false;
		$json_response['message'] = $_SESSION["upload_file_$sid"]['error'];
	} else {
		$json_response['isSuccessful'] = true;
		$json_response['message'] = $_SESSION["upload_file_$sid"]['loc'];
	}

	unset($_SESSION["upload_file_$sid"]['error']);
	unset($_SESSION["upload_file_$sid"]['loc']);
	echo json_encode($json_response);
}

function emptyDir($dirPath) {
	if (file_exists($dirPath)) {
		$it = new RecursiveDirectoryIterator($dirPath);
		$files = new RecursiveIteratorIterator($it, RecursiveIteratorIterator::CHILD_FIRST);
		foreach ($files as $file) {
			if ($file->getFilename() == '.' || $file->getFilename() == '..') {
				continue;
			}
			if ($file->isDir()) {
				rmdir($file->getRealPath());
			} else {
				unlink($file->getRealPath());
			}
		}
	}
}

?>