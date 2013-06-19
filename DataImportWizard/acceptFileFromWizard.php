<?php

session_start();
set_time_limit(0);

include_once('../Smarty.class.php');
include_once('../Classes/CSVToExcelConverter.php');
include_once('FileUtil.php');
$main_smarty = new Smarty;

include('../config.php');
include(mnminclude . 'html1.php');
include(mnminclude . 'link.php');
include(mnminclude . 'tags.php');
include(mnminclude . 'user.php');
include_once(mnminclude . 'utils.php');
include(mnminclude . 'smartyvariables.php');


//to check anonymous mode activated
global $current_user;

// module system hook
$vars = '';
check_actions('submit_post_authentication', $vars);


// determine which step of the submit process we are on
if (isset($_POST["phase"]) && is_numeric($_POST["phase"]))
    $phase = $_POST["phase"];
else if (isset($_GET["phase"]) && is_numeric($_GET["phase"]))
    $phase = $_GET["phase"];
else
    $phase = 0;

switch ($phase) {
    case 0:
        upload_0();
        break;
    case 1:
        upload_1();
        break;
    case 2:
        upload_2();
        break;
    case 3:
        get_Ext();
        break;
}

function upload_0() {
    global $db, $current_user;

    $author = $current_user->user_id;

    // check file type
    $extension = end(explode(".", $_FILES["upload_file"]["name"]));
    $mimes = array('xls', 'xlsx', 'csv', 'zip');
    if (count($_FILES) <= 0) {
        $error = "ERROR: No file was uploaded.";
        $_SESSION['upload_file'] = array('error' => $error);
    } else if (!in_array($extension, $mimes)) {
        $error = "ERROR: please upload excel, csv, or zip file.";
        $_SESSION['upload_file'] = array('error' => $error);
    } else {
        $_SESSION['extension'] = $extension;
        $sid = getSid();

        //save upload file	     
        if ($_FILES['upload_file']['error'] > 0) {
            $error = "ERROR: " . get_file_err($_FILES['upload_file']['error']) . "</br>";
            $_SESSION['upload_file'] = array('error' => $error);
        } else {
            // the file name that should be uploaded		
            $file_tmp = $_FILES['upload_file']['tmp_name'];
            $raw_file_name = $_FILES['upload_file']['name'];
            $ext = pathinfo($raw_file_name, PATHINFO_EXTENSION);

            $sql2 = "UPDATE " . table_prefix . "sourceinfo SET raw_data_path='$file_name' WHERE Sid=$sid;";
            $db->query($sql2);

            // match the raw_data_file to sid
            $upload_dir = mnmpath . "upload_raw_data/$sid/";
            mkdir($upload_dir);
            $upload_path = $upload_dir . $raw_file_name;

            // check upload status
            if (!(move_uploaded_file($file_tmp, $upload_path))) {
                $error = "ERROR: failed to save file.";
                $_SESSION['upload_file'] = array('error' => $error);
            } else {

                // If a csv file is provided, create a excel file and write the csv value to it.
                if (strtolower($ext) == 'csv') {

                    $csvFilePath = $upload_path;
                    $xlsxFilePath = FileUtil::convertCSVtoXLSX($csvFilePath);
                    $xlsxFileName = pathinfo($xlsxFilePath, PATHINFO_BASENAME);
                    $raw_file_name = $xlsxFileName;
                    unlink($csvFilePath);
                } else if (strtolower($ext) == 'zip') {

                    // If a zip file is provided, unzip all files.
                    $zipFilePath = $upload_path;
                    $zip = new ZipArchive;
                    $res = $zip->open($zipFilePath);
                    if ($res === TRUE) {
                        $zip->extractTo($upload_dir);
                        $zip->close();
                    } else {
                        $error = "ERROR: failed to unzip file.";
                        $_SESSION['upload_file'] = array('error' => $error);
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
                        unlink($filePath);
                    }

                    $dirFilesAfterTrans = scandir($upload_dir, SCANDIR_SORT_DESCENDING);
                    foreach ($dirFilesAfterTrans as $filename) {
                        if (FileUtil::isXLSXFile($filename) || FileUtil::isXLSFile($filename)) {
                            $raw_file_name = $filename;
                        }
                    }

                    if (!isset($raw_file_name)) {
                        $error = "ERROR: No valid file is included.";
                        $_SESSION['upload_file'] = array('error' => $error);
                    }
                }

                $_SESSION['raw_file_name']["$sid"] = $raw_file_name;
                $loc_msg = "uploaded successfully";
                $_SESSION['upload_file'] = array('loc' => $loc_msg);
            }
        }
    }

    $json_response = array();
    if (isset($_SESSION['upload_file']['error'])) {
        $json_response['isSuccessful'] = false;
        $json_response['message'] = $_SESSION['upload_file']['error'];
    } else {
        $json_response['isSuccessful'] = true;
        $json_response['message'] = $_SESSION['upload_file']['loc'];
    }
    echo json_encode($json_response);
}

function get_Ext() {
    $sid = getSid();
    $var = end(explode(".", $_SESSION['raw_file_name']["$sid"]));
    echo $var;
}

function getSid() {
    // determine which step of the submit process we are on
    if (isset($_POST["sid"]))
        $sid = $_POST["sid"];
    else if (isset($_GET["sid"]))
        $sid = $_GET["sid"];
    else {
        echo json_encode("no sid");
        die();
    }

    return $sid;
}

?>
