<?php

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
$dataSource_dir = "upload_raw_data/$sid/";
$dataSource_dirPath = mnmpath . $dataSource_dir;
$excelFileMode = $_SESSION["excelFileMode_$sid"];

switch ($phase) {
    case 0:
// When submit btn in step1 is clicked, the function executes.
        createTemplate($sid, $dataSource_dir, $dataSource_dirPath, $excelFileMode);
        break;
    case 1:
// when jump to step 3, this function is called.
        addSheetsSettings($sid, $dataSource_dirPath);
        match_schema($sid);
        break;
    case 2:
        break;
    case 3:
        // Step 2 - get sheet name.
        printSheet($sid, $dataSource_dir, $dataSource_dirPath);
        break;
    case 4:
        break;
    case 5:
        // When submit btn in step4 is clicked, this is called.
        add_normalizer($sid, $dataSource_dir, $dataSource_dirPath);
        unsetFileResources($sid, $dataSource_dir, $dataSource_dirPath);
        break;
    case 6:
        display_excel_table($sid, $dataSource_dir, $dataSource_dirPath);
        break;
    case 7:
        get_sid();
        break;
    case 8:
        getFileSources($sid, $dataSource_dir, $dataSource_dirPath);
        break;
    case 9:
        $filenames = $_SESSION["ktrArguments_$sid"]["filenames"];
        $totalSeconds = 0;
        foreach ($filenames as $filename) {
            $totalSeconds += estimateLoadingProgress($dataSource_dirPath . $filename);
        }
        echo $totalSeconds;
        break;
    case 10:
        getExcelPreview($sid, $dataSource_dirPath);
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
        die("Source not specified.");
    }

    return $sid;
}

function createTemplate($sid, $dataSource_dir, $dataSource_dirPath, $excelFileMode) {

    $template = 'excel-to-target_schema.ktr';
    $newDir = mnmpath . "temp/$sid";
    if (!file_exists($newDir)) {
        mkdir($newDir);
    }

    if ($excelFileMode == 'append') {
        $ktrFilePath = "$newDir/$sid.ktr";
        copy($template, $ktrFilePath);

        foreach (scandir($dataSource_dirPath) as $dataSource_filename) {
            if (FileUtil::isXLSXFile($dataSource_filename) || FileUtil::isXLSFile($dataSource_filename)) {
                $filenames[] = $dataSource_filename;
                $filePaths[] = $dataSource_dirPath . $dataSource_filename;
                $fileURLs[] = my_base_url . my_pligg_base . "/$dataSource_dir" . $dataSource_filename;
            }
        }

        $ktrManagers[$filenames[0]] = new KTRManager($template, $ktrFilePath, $filePaths);
    } else {
        foreach (scandir($dataSource_dirPath) as $dataSource_filename) {
            if (FileUtil::isXLSXFile($dataSource_filename) || FileUtil::isXLSFile($dataSource_filename)) {
                $filenames[] = $dataSource_filename;
                $filePath = $dataSource_dirPath . $dataSource_filename;
                $filePaths[] = $filePath;
                $fileURLs[] = my_base_url . my_pligg_base . "/$dataSource_dir" . $dataSource_filename;
                $ktrFilePath = "$newDir/$dataSource_filename.ktr";
                copy($template, $ktrFilePath);
                $ktrManagers[$dataSource_filename] = new KTRManager($template, $ktrFilePath, array($filePath));
            }
        }
    }

    $_SESSION["ktrArguments_$sid"]["ktrManagers"] = serialize($ktrManagers);
    $_SESSION["ktrArguments_$sid"]["filenames"] = $filenames;
    $_SESSION["ktrArguments_$sid"]["filePaths"] = $filePaths;
    $_SESSION["ktrArguments_$sid"]["fileUrls"] = $fileURLs;
}

function getFileSources($sid) {

    $ktrManagers = unserialize($_SESSION["ktrArguments_$sid"]["ktrManagers"]);
    if (isset($ktrManagers)) {
        $json["isSuccessful"] = true;
        foreach ($ktrManagers as $ktrManager) {
            $paths = $ktrManager->getFilePaths();
            $json["data"][] = getSheets($paths[0]);
        }
    } else {
        $json["isSuccessful"] = false;
    }

    echo json_encode($json);
}

function getExcelPreview($sid, $dataSource_dirPath) {
    $filename = $_POST['filename'];
    $filePath = $dataSource_dirPath . $filename;
    $previewRowsPerPage = $_POST['previewRowsPerPage'];
    $previewPage = $_POST['previewPage'];
    loadSingleExcelPreview($sid, $filePath, $previewPage, $previewRowsPerPage);
    echo json_encode(getSingleExcelPreview($sid, $filename));
}

function loadSingleExcelPreview($sid, $filePath, $previewPage, $previewRowsPerPage) {
    $filename = pathinfo($filePath, PATHINFO_BASENAME);
    $PHPExcel = new PreviewExcelProcessor($filePath, $previewPage, $previewRowsPerPage);
    $_SESSION["excelPreviewPage_$sid"][$filename] = $previewPage;
    $_SESSION["excelPreviewRowsPerPage_$sid"][$filename] = $previewRowsPerPage;
    $_SESSION["excelPreview_$sid"][$filename] = serialize($PHPExcel);
    return $PHPExcel;
}

function getSingleExcelPreview($sid, $filename) {
    $PHPExcel = unserialize($_SESSION["excelPreview_$sid"][$filename]);
    return $PHPExcel->getCellData();
}

function getSheets($filePath) {
    $filename = pathinfo($filePath, PATHINFO_BASENAME);
    $sheets = Process_excel::getSheetName($filePath);

    $sheetNames = new stdClass();
    $sheetNames->filename = $filename;
    $sheetNames->worksheets = $sheets;

    return $sheetNames;
}

function addSheetsSettings($sid, $dataSource_dirPath) {
    $sheetsRanges = $_POST["sheetsRanges"];
    foreach ($sheetsRanges as $filename => $sheetsRange) {
        $fileUrl = $dataSource_dirPath . $filename;
        $baseheader = addSheetSettings($sheetsRange, $fileUrl, $sid);
    }
}

function addSheetSettings($sheetsRange, $dataSource_filePath, $sid) {

    foreach ($sheetsRange as $sheetName => $settings) {
        $arr_sheet_name[] = $sheetName;
        $arr_start_row[] = $settings['startRow'];
        $arr_start_column[] = $settings['startColumn'];
    }
    $filename = pathinfo($dataSource_filePath, PATHINFO_BASENAME);
    $sheets = array($arr_sheet_name, $arr_start_row, $arr_start_column);

    //check the headers from different sheets
    if (isReloadNeeded($filename, $arr_start_row)) {
        $process = new MatchSchemaExcelProcessor($dataSource_filePath, $sheetsRange);
    } else {
        $process = unserialize($_SESSION["excelPreview_$sid"][pathinfo($dataSource_filePath, PATHINFO_BASENAME)]);
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

    $sheetHeader[$arr_sheet_name[0]] = $baseHeader;

    $_SESSION["ktrArguments_$sid"][$filename]['baseHeader'] = $baseHeader;
    $_SESSION["ktrArguments_$sid"][$filename]["sheetNamesRowsColumns"] = $sheets;

    // each column name in option value will be prefixed with word file.
    return $sheetHeader[$arr_sheet_name[0]];
}

function match_schema($sid) {

    $ktrManagers = unserialize($_SESSION["ktrArguments_$sid"]["ktrManagers"]);
    foreach ($ktrManagers as $filename => $ktrManager) {
        $filename_baseheaders[$filename] = $_SESSION["ktrArguments_$sid"][$filename]['baseHeader'];
    }

    $_SESSION["ktrArguments_$sid"]["ktrManagers"] = serialize($ktrManagers);
    echo UtilsForWizard::PrintTableForDataMatchingStep($filename_baseheaders);
}

function add_normalizer($sid, $dataSource_dir, $dataSource_dirPath) {

    $ktrManagers = unserialize($_SESSION["ktrArguments_$sid"]["ktrManagers"]);

    $dataMatchingUserInputs = $_POST["dataMatchingUserInputs"];

    if (!isset($_POST["dataMatchingUserInputs"])) {
        throw new Exception("Invalid arguments");
    }

    foreach ($ktrManagers as $filename => $ktrManager) {
        $baseHeader = $_SESSION["ktrArguments_$sid"][$filename]['baseHeader'];
        $sheetNamesRowsColumns = $_SESSION["ktrArguments_$sid"][$filename]["sheetNamesRowsColumns"];

        $replaceCount = 1;
        foreach ($dataMatchingUserInputs as &$value) {
            if ($value["tableName"] == $filename) {
                $value["originalDname"] = str_replace("$filename.", '', $value["originalDname"], $replaceCount);
                $dataMatchingUserInputsForATable[] = $value;
            }
        }

        $ktrManager->createTemplate($sheetNamesRowsColumns, $baseHeader, $dataMatchingUserInputsForATable);
    }

    UtilsForWizard::processDataMatchingUserInputsWithTableNameStoreDB($sid, $_POST["dataMatchingUserInputs"]);
}

function isReloadNeeded($filename, $headerRows) {
    global $sid;
    if (isset($_SESSION["excelPreviewPage_$sid"][$filename], $_SESSION["excelPreviewRowsPerPage_$sid"][$filename])) {
        $loadedPage = $_SESSION["excelPreviewPage_$sid"][$filename];
        $perPage = $_SESSION["excelPreviewRowsPerPage_$sid"][$filename];
        $isReloadNeeded = false;
        foreach ($headerRows as $headerRow) {
            $isReloadNeeded = $isReloadNeeded || !(((int) $headerRow > ((int) $loadedPage - 1) * (int) $perPage) && ((int) $headerRow <= (int) $loadedPage * (int) $perPage));
        }
        return $isReloadNeeded;
    } else {
        return true;
    }
}

function estimateLoadingProgress($dataSource_filePath) {
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

function unsetFileResources($sid, $dataSource_dir, $dataSource_dirPath) {

    unset($_SESSION["excelPreviewPage_$sid"]);
    unset($_SESSION["excelPreviewRowsPerPage_$sid"]);
    unset($_SESSION["excelPreview_$sid"]);
    unset($_SESSION["raw_file_name_$sid"]);
}

?>
