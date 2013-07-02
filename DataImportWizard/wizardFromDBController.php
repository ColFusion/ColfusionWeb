<?php

include_once('../config.php');
include_once('../DAL/QueryEngine.php');
include_once('../DAL/ExternalDBHandlers/ExternalDBs.php');
include_once('UtilsForWizard.php');

$action = $_GET["action"];
$action();
exit;

function TestConnection() {
    // get submitted form information from dashboard.php
    $serverName = $_POST['serverName'];
    $userName = $_POST['userName'];
    $password = $_POST['password']; // controls how many tuples shown on each page
    $port = $_POST['port'];
    $driver = $_POST['driver'];
    $database = $_POST['database'];

    // TODO: This should not return json. The resul of this call should be transformed to json here and trhen returned.
    ExternalDBs::TestConnection($serverName, $userName, $password, $port, $driver, $database);
}

function LoadDatabaseTables() {
    // get submitted form information from dashboard.php
    $serverName = $_POST['serverName'];
    $userName = $_POST['userName'];
    $password = $_POST['password']; // controls how many tuples shown on each page
    $database = $_POST['database'];
    $port = $_POST['port'];
    $driver = $_POST['driver'];

    echo json_encode(ExternalDBs::LoadDatabaseTables($serverName, $userName, $password, $port, $driver, $database));
}

function PrintTableForSchemaMatchingStep() {
    $serverName = $_POST['serverName'];
    $userName = $_POST['userName'];
    $password = $_POST['password']; // controls how many tuples shown on each page
    $database = $_POST['database'];
    $port = $_POST['port'];
    $driver = $_POST['driver'];
    $selectedTables = $_POST["selectedTables"];

    $tablesColumns = ExternalDBs::GetColumnsForSelectedTables($serverName, $userName, $password, $port, $driver, $database, $selectedTables);

    $_SESSION['baseHeader'] = $tablesColumns;

    echo UtilsForWizard::PrintTableForSchemaMatchingStep($tablesColumns);
}

function PrintTableForDataMatchingStep() {
    $spd = $_POST["schemaMatchingUserInputs"]["spd"];
    $drd = $_POST["schemaMatchingUserInputs"]["drd"];
    $start = $_POST["schemaMatchingUserInputs"]["start"];
    $end = $_POST["schemaMatchingUserInputs"]["end"];
    $location = $_POST["schemaMatchingUserInputs"]["location"];
    $aggrtype = $_POST["schemaMatchingUserInputs"]["aggrtype"];

    $baseHeader = $_SESSION['baseHeader'];

    if ($spd != "" && $spd != "other") {
        $tableName = UtilsForWizard::getWordUntilFirstDot($spd);
        $spd = UtilsForWizard::stripWordUntilFirstDot($spd);
        $baseHeader[$tableName] = array_diff($baseHeader[$tableName], array($spd));
    }

    if ($drd != "" && $drd != "other") {
        $tableName = UtilsForWizard::getWordUntilFirstDot($drd);
        $drd = UtilsForWizard::stripWordUntilFirstDot($drd);
        $baseHeader[$tableName] = array_diff($baseHeader[$tableName], array($drd));
    }

    if ($start != "" && $start != "other") {
        $tableName = UtilsForWizard::getWordUntilFirstDot($start);
        $start = UtilsForWizard::stripWordUntilFirstDot($start);
        $baseHeader[$tableName] = array_diff($baseHeader[$tableName], array($start));
    }

    if ($end != "" && $end != "other") {
        $tableName = UtilsForWizard::getWordUntilFirstDot($end);
        $end = UtilsForWizard::stripWordUntilFirstDot($end);
        $baseHeader[$tableName] = array_diff($baseHeader[$tableName], array($end));
    }

    if ($location != "" && $location != "other") {
        $tableName = UtilsForWizard::getWordUntilFirstDot($location);
        $location = UtilsForWizard::stripWordUntilFirstDot($location);
        $baseHeader[$tableName] = array_diff($baseHeader[$tableName], array($location));
    }

    if ($aggrtype != "" && $aggrtype != "other") {
        $tableName = UtilsForWizard::getWordUntilFirstDot($aggrtype);
        $aggrtype = UtilsForWizard::stripWordUntilFirstDot($aggrtype);
        $baseHeader[$tableName] = array_diff($baseHeader[$tableName], array($aggrtype));
    }

    $_SESSION['$normalizer_header'] = $baseHeader;

    echo UtilsForWizard::PrintTableForDataMatchingStep($baseHeader);
}

//TODO: the logic should be moved to some other classes
function Execute() {
    global $db;

    $inputData = $_POST;

    $sid = getSid();
    $queryEngine = new QueryEngine();

    $queryEngine->simpleQuery->addSourceDBInfo($sid, $inputData["server"], $inputData["port"], $inputData["user"], $inputData["password"], $inputData["database"], $inputData["driver"]);

    UtilsForWizard::processSchemaMatchingUserInputsStoreDB($sid, $inputData["schemaMatchingUserInputs"]);
    UtilsForWizard::processDataMatchingUserInputsStoreDB($sid, $inputData["dataMatchingUserInputs"]);

    $queryEngine->simpleQuery->setSourceTypeBySid($sid, 'database');

    $resultJson = new stdClass();
    $resultJson->isSuccessful = true;
    $resultJson->message = 'Success!';
    echo json_encode($resultJson);
}

/* * ************************************************************************************************** */

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