<?php

include_once('../config.php');
include_once('../DAL/QueryEngine.php');
include_once('../DAL/ExternalDBHandlers/ExternalDBs.php');
include_once('UtilsForWizard.php');
require_once(realpath(dirname(__FILE__)) . "/../DAL/ExternalDBHandlers/DatabaseHandler.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/ExternalDBHandlers/DatabaseHandlerFactory.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/DBImporters/DatabaseImporterFactory.php");

$sid = $_POST['sid'];
if (!isset($sid)) {
    die('Source not specified.');
}

if (isset($_SESSION["dbHandler_$sid"])) {
    $dbHandler = unserialize($_SESSION["dbHandler_$sid"]);
}

$action = $_GET["action"];
$action($sid, $dbHandler);
exit;

function TestConnection($sid) {

    $isImport = $_POST['isImport'];
    $driver = strtolower($_POST['driver']);

    if ($isImport == 'true') {
        $importSettings = DatabaseImporterFactory::$importSettings[$driver];

        $serverName = 'localhost';
        $database = my_pligg_base_no_slash . "_external_$sid";
        $userName = $importSettings['user'];
        $password = $importSettings['password']; // controls how many tuples shown on each page
        $port = $importSettings['port'];
    } else {
        $userName = $_POST['userName'];
        $password = $_POST['password']; // controls how many tuples shown on each page
        $port = $_POST['port'];
        $serverName = $_POST['serverName'];
        $database = $_POST['database'];
    }

    $serverName = $serverName ? $serverName : 'a fail host';
    $json = new stdClass();

    try {
        if ($port) {
            $dbHandler = DatabaseHandlerFactory::createDatabaseHandler($driver, $userName, $password, $database, $serverName, $port);
        } else {
            $dbHandler = DatabaseHandlerFactory::createDatabaseHandler($driver, $userName, $password, $database, $serverName);
        }
        $dbHandler->setDriver($driver);
        $dbHandler->getConnection();
        $_SESSION["dbHandler_$sid"] = serialize($dbHandler);

        $json->isSuccessful = true;
        $json->message = "Connected successfully";
        echo json_encode($json);
    } catch (Exception $e) {
        $json->isSuccessful = false;
        $json->message = $e->getMessage();
        echo json_encode($json);
    }
}

function LoadDatabaseTables($sid, DatabaseHandler $dbHandler) {
    try {
        $tables = $dbHandler->loadTables();
        $json["isSuccessful"] = true;
        $json["data"] = $tables;
    } catch (Exception $e) {
        $json["isSuccessful"] = false;
    }
    echo json_encode($json);
}

function PrintTableForDataMatchingStep($sid, DatabaseHandler $dbHandler) {
    $selectedTables = $_POST["selectedTables"];
    $tablesColumns = $dbHandler->getColumnsForSelectedTables($selectedTables);
    $baseHeader = $tablesColumns;
    $_SESSION['$normalizer_header'] = $baseHeader;

    echo UtilsForWizard::PrintTableForDataMatchingStep($baseHeader);
}

//TODO: the logic should be moved to some other classes
function Execute($sid, $dbHandler) {
    global $driver;

    $inputData = $_POST;
    $queryEngine = new QueryEngine();

    $queryEngine->simpleQuery->addSourceDBInfo($sid, $dbHandler->getHost(), $dbHandler->getPort(), $dbHandler->getUser(), $dbHandler->getPassword(), $dbHandler->getDatabase(), $dbHandler->getDriver());

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