<?php

error_reporting(E_ALL ^ E_STRICT);
set_time_limit(0);
ini_set('session.gc_maxlifetime', 3 * 60 * 60);

include_once('../Smarty.class.php');
$main_smarty = new Smarty;

include_once('../config.php');
include(mnminclude . 'html1.php');
include(mnminclude . 'link.php');
include(mnminclude . 'tags.php');
include(mnminclude . 'user.php');
include(mnminclude . 'smartyvariables.php');

include_once 'UtilsForWizard.php';
include_once 'process_excelV2.php';
include_once './excelProcessors/PreviewExcelProcessor.php';
include_once './excelProcessors/MatchSchemaExcelProcessor.php';
include_once 'NothingFilter.php';
include_once 'FileUtil.php';
include_once 'KTRManager.php';

if (isset($_POST["phase"]) && is_numeric($_POST["phase"]))
    $phase = $_POST["phase"];
else if (isset($_GET["phase"]) && is_numeric($_GET["phase"]))
    $phase = $_GET["phase"];
else
    $phase = 0;

$sid = getSid();
$dataSource_filename = $_SESSION["raw_file_name_$sid"];
$dataSource_dir = "upload_raw_data/$sid/";
$dataSource_dirPath = mnmpath . $dataSource_dir;
$dataSource_filePath = $dataSource_dirPath . $dataSource_filename;
$dataSource_filePath = str_replace('\\', '/', $dataSource_filePath);

switch ($phase) {
    case 0:
// When submit btn in step1 is clicked, the function executes.
        createTemplate();
        break;
    case 1:
// when jump to step 3, this function is called.
        add_sheets();
        break;
    case 2:
// when jump to step 4, this function is called.
        match_schema();
        break;
    case 3:
// Step 2 - get sheet name.
        printSheet();
        break;
    case 4:
// Step 2 - get start column.
        dynamic_column();
        break;
    case 5:      
        // When submit btn in step4 is clicked, this is called.
        add_normalizer();
        unsetFileResources();
        break;
    case 6:
        display_excel_table();
        break;
    case 7:
        get_sid();
        break;
    case 8:
        loadExcelPreview();
        getExcelPreview();
        break;
    case 9:
        estimateLoadingProgress();
        break;
}
exit;

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

function createTemplate() {
    global $dataSource_filename, $dataSource_filePath, $dataSource_dir, $dataSource_dirPath, $sid;

    $ext = strtolower(pathinfo($dataSource_filename, PATHINFO_EXTENSION));
    if ($ext == 'xls' || $ext == 'xlsx') {
        $tmpDir = 'excel-to-target_schema.ktr';
    } else if ($ext == 'csv') {
        $tmpDir = 'csv_to_target_schema.ktr';
    }

    $newDir = mnmpath . "temp/" . getSid() . '.ktr';
    copy($tmpDir, $newDir);

    foreach (scandir($dataSource_dirPath) as $dataSource_filename) {
        if (FileUtil::isXLSXFile($dataSource_filename) || FileUtil::isXLSFile($dataSource_filename)) {
            $fileURLs[] = my_base_url . my_pligg_base . "/$dataSource_dir" . $dataSource_filename;
        }
    }
    
    $ktrManager = new KTRManager($tmpDir, $newDir);
    $_SESSION["ktrArguments_$sid"]["ktrManager"] = serialize($ktrManager);
    $_SESSION["ktrArguments_$sid"]["fileUrls"] = $fileURLs;
}

function add_file($newDir, $filePath) {
    $ktr = simplexml_load_file($newDir);
    $steps = $ktr->step;

    foreach ($steps as $step) {
        $name = $step->name;
        if ($name == 'CSV file input') {
// delete the sheet node when user go back
            unset($step->filename);
            $step->addChild('filename', $filePath);
        }
        file_put_contents($newDir, $ktr->asXML());
    }

    display_csv();
}

function display_csv() {
    global $dataSource_filename, $dataSource_filePath;

    $content = str_replace("\n", "\r", file_get_contents($dataSource_filePath));
    file_put_contents($dataSource_filePath, $content);
    $file_handle = fopen($dataSource_filePath, "r");

    $line_of_text = fgetcsv($file_handle, 1024, "\r");

    $baseHeader = explode(",", $line_of_text[0]);
    $_SESSION['$baseHeader'] = $baseHeader;

    foreach ($line_of_text as $value) {
        echo $value . "<br/>";
    }

    fclose($file_handle);
}

function loadExcelPreview() {
    global $sid, $dataSource_filePath;
    
    $previewRowsPerPage = $_POST['previewRowsPerPage'];
    $previewPage = $_POST['previewPage'];

    $PHPExcel = new PreviewExcelProcessor($dataSource_filePath, $previewPage, $previewRowsPerPage);
    $_SESSION["excelPreviewPage_$sid"] = $previewPage;
    $_SESSION["excelPreviewRowsPerPage_$sid"] = $previewRowsPerPage;
    $_SESSION["excelPreview_$sid"] = serialize($PHPExcel);
}

function getExcelPreview() {
    global $sid;
    $PHPExcel = unserialize($_SESSION["excelPreview_$sid"]);
    echo json_encode($PHPExcel->getCellData());
}

function printSheet() {
    global $dataSource_filePath;
    echo json_encode(Process_excel::getSheetName($dataSource_filePath));
}

function dynamic_column() {
    
}

function add_sheets() {
    global $dataSource_filename, $dataSource_filePath, $sid;

    $newDir = mnmpath . "temp/" . getSid() . '.ktr';
    $sheetsRange = $_POST["sheetsRange"];

    foreach ($sheetsRange as $sheetName => $settings) {
        $arr_sheet_name[] = $sheetName;
        $arr_start_row[] = $settings['startRow'];
        $arr_start_column[] = $settings['startColumn'];
    }

    $sheets = array($arr_sheet_name, $arr_start_row, $arr_start_column);

//check the headers from different sheets
    if (isReloadNeeded($arr_start_row)) {
        $process = new MatchSchemaExcelProcessor($dataSource_filePath, $sheetsRange);
    } else {
        $process = unserialize($_SESSION["excelPreview_$sid"]);
    }

    $base_sheetNameNumber = Process_excel::getSheetNameIndex($dataSource_filePath, $sheets[0][0]);
    $baseHeader = $process->getHeader($base_sheetNameNumber, $sheets[1][0], $sheets[2][0]);
    for ($i = 1; $i < count($sheets[0]); $i++) {
        $arr_sheetNameNumber = $process->getSheetNameIndex($dataSource_filePath, $sheets[0][$i]);
        $arrHeader = $process->getHeader($arr_sheetNameNumber, $sheets[1][$i], $sheets[2][$i]);
        $diff_arr = array_diff($baseHeader, $arrHeader);
        if (!empty($diff_arr) || count($baseHeader) != count($arrHeader))
            exit("<div style=\"color:red\">Please choose the right row and column to get the same headers from different sheets</div>");
    }

    if (isset($baseHeader)) {
        $data[$arr_sheet_name[0]] = $baseHeader;

        $_SESSION["ktrArguments_$sid"]['baseHeader'] = $data;
        //TODO: get rid of it later.
        $_SESSION['sheetZero'] = $arr_sheet_name[0];

        // each column name in option value will be prefixed with word file.
        echo UtilsForWizard::PrintTableForSchemaMatchingStep($data);
    } else {
        echo "please reload";
    }

    $_SESSION["ktrArguments_$sid"]["sheetNamesRowsColumns"] = $sheets;
}

function isReloadNeeded($headerRows) {
    global $sid;
    if (isset($_SESSION["excelPreviewPage_$sid"], $_SESSION["excelPreviewRowsPerPage_$sid"])) {
        $loadedPage = $_SESSION["excelPreviewPage_$sid"];
        $perPage = $_SESSION["excelPreviewRowsPerPage_$sid"];
        $isReloadNeeded = false;
        foreach ($headerRows as $headerRow) {
            $isReloadNeeded = $isReloadNeeded || !($headerRow > ($loadedPage - 1) * $perPage && $headerRow <= $loadedPage * $perPage);
        }
        return $isReloadNeeded;
    } else {
        return true;
    }
}

function estimateLoadingProgress() {
    global $dataSource_filePath;

    $ext = pathinfo($dataSource_filePath, PATHINFO_EXTENSION);
    $sampleFilePath = $ext == 'xlsx' ? "loadingTimeSample.xlsx" : "loadingTimeSample.xls";

    $PHPExcelReader = Process_excel::createExcelReader($dataSource_filePath);
    $PHPExcelReader->setReadDataOnly(true);
    $PHPExcelReader->setReadFilter(new NothingFilter());

    $sampleStart = time();
    $PHPExcelReader->load($sampleFilePath);
    $sampleEnd = time();
    $sampleLoadTime = $sampleEnd - $sampleStart;

    $targetFileSize = (float) filesize($dataSource_filePath);
    $sampleFileSize = (float) filesize($sampleFilePath);
    $estimatedSeconds = ($sampleLoadTime * $targetFileSize / $sampleFileSize);
    $estimatedSeconds = $ext == 'xlsx' ? $estimatedSeconds * 4 : $estimatedSeconds;

    echo $estimatedSeconds;
}

function match_schema() {
    global $sid;

    $ktrManager = unserialize($_SESSION["ktrArguments_$sid"]["ktrManager"]);

    $spd = $_POST["schemaMatchingUserInputs"]["spd"];
    $spd2 = $_POST["schemaMatchingUserInputs"]["spd2"];
    $drd = $_POST["schemaMatchingUserInputs"]["drd"];
    $drd2 = $_POST["schemaMatchingUserInputs"]["drd2"];
    $start = $_POST["schemaMatchingUserInputs"]["start"];
    $start2 = $_POST["schemaMatchingUserInputs"]["start2"];
    $end = $_POST["schemaMatchingUserInputs"]["end"];
    $end2 = $_POST["schemaMatchingUserInputs"]["end2"];
    $location = $_POST["schemaMatchingUserInputs"]["location"];
    $location2 = $_POST["schemaMatchingUserInputs"]["location2"];
    $aggrtype = $_POST["schemaMatchingUserInputs"]["aggrtype"];
    $aggrtype2 = $_POST["schemaMatchingUserInputs"]["aggrtype2"];

    if ($spd != "" && $spd != "other") {
        $spd = UtilsForWizard::stripWordUntilFirstDot($spd);
        $ktrManager->updateColumnAndStreamName('Spd', $spd);
    } else if ($spd2 != "") {
        $ktrManager->addConstants('Spd_from_input', $spd2, 'Date', 'yyyy/MM/dd');
        $ktrManager->updateColumnAndStreamName('Spd', 'Spd_from_input');
    }

    if ($drd != "" && $drd != "other") {
        $drd = UtilsForWizard::stripWordUntilFirstDot($drd);
        $ktrManager->updateColumnAndStreamName('Drd', $drd);
    } else if ($drd2 != "") {
        $ktrManager->addConstants('Drd_from_input', $drd2, 'Date', 'yyyy/MM/dd');
        $ktrManager->updateColumnAndStreamName('Drd', 'Drd_from_input');
    }

    if ($start != "" && $start != "other") {
        $start = UtilsForWizard::stripWordUntilFirstDot($start);
        $ktrManager->updateColumnAndStreamName('Start', $start);
    } else if ($start2 != "") {
        $ktrManager->addConstants('Start_from_input', $start2, 'Date', 'yyyy/MM/dd');
        $ktrManager->updateColumnAndStreamName('Start', 'Start_from_input');
    }

    if ($end != "" && $end != "other") {
        $end = UtilsForWizard::stripWordUntilFirstDot($end);
        $ktrManager->updateColumnAndStreamName('End', $end);
    } else if ($end2 != "") {
        $ktrManager->addConstants('End_from_input', $end2, 'Date', 'yyyy/MM/dd');
        $ktrManager->updateColumnAndStreamName('End', 'End_from_input');
    }

    if ($location != "" && $location != "other") {
        $location = UtilsForWizard::stripWordUntilFirstDot($location);
        $ktrManager->updateColumnAndStreamName('Location', $location);
    } else if ($location2 != "") {
        $ktrManager->addConstants('Location_from_input', $location2, 'String', '');
        $ktrManager->updateColumnAndStreamName('Location', 'Location_from_input');
    }

    if ($aggrtype != "" && $aggrtype != "other") {
        $aggrtype = UtilsForWizard::stripWordUntilFirstDot($aggrtype);
        $ktrManager->updateColumnAndStreamName('AggrType', $aggrtype);
    } else if ($aggrtype2 != "") {
        $ktrManager->addConstants('AggrType_from_input', $aggrtype2, 'String', '');
        $ktrManager->updateColumnAndStreamName('AggrType', 'AggrType_from_input');
    }

    $no_need_Array = array($spd, $drd, $start, $end, $location, $aggrtype);
    $normalizer_header = array_diff(reset($_SESSION["ktrArguments_$sid"]['baseHeader']), $no_need_Array);

    // Should be more complicated like the case with DB to take care of different sheets names
    $data[$_SESSION['sheetZero']] = $normalizer_header;
    $_SESSION['$normalizer_header'] = $data;		

    $_SESSION["ktrArguments_$sid"]["ktrManager"] = serialize($ktrManager);
    echo UtilsForWizard::PrintTableForDataMatchingStep($data);
}

function add_normalizer() {
    global $db, $sid;

    $ktrManager = unserialize($_SESSION["ktrArguments_$sid"]["ktrManager"]);
    $fileUrls = $_SESSION["ktrArguments_$sid"]["fileUrls"];
    $sheetNamesRowsColumns = $_SESSION["ktrArguments_$sid"]["sheetNamesRowsColumns"];
    $baseHeader = $_SESSION["ktrArguments_$sid"]['baseHeader'];
    $dataMatchingUserInputs = $_POST["dataMatchingUserInputs"];

    if (isset($_POST["dataMatchingUserInputs"])) {

        foreach ($dataMatchingUserInputs as &$value) {
            $value["originalDname"] = UtilsForWizard::stripWordUntilFirstDot($value["originalDname"]);
        }

        $ktrManager->createTemplate($fileUrls, $sheetNamesRowsColumns, $baseHeader, $dataMatchingUserInputs);
        unset($_SESSION["ktrArguments_$sid"]);

        UtilsForWizard::processSchemaMatchingUserInputsStoreDB($sid, $_POST["schemaMatchingUserInputs"]);
        UtilsForWizard::processDataMatchingUserInputsStoreDB($sid, $_POST["dataMatchingUserInputs"]);        
    } else {
        echo "error";
    }
}

function unsetFileResources() {
    global $sid;

    unset($_SESSION["excelPreviewPage_$sid"]);
    unset($_SESSION["excelPreviewRowsPerPage_$sid"]);
    unset($_SESSION["excelPreview_$sid"]);
    unset($_SESSION["raw_file_name_$sid"]);
}

?>
