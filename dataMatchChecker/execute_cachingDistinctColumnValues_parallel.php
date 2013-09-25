<?php

require_once(realpath(dirname(__FILE__)) . "/DataMatchExecutor.php");
require_once(realpath(dirname(__FILE__)) . "/../DAL/RelationshipDAO.php");
require_once(realpath(dirname(__FILE__)) . "/../DataImportWizard/ExecutionManager.php");

$dataMatcherLinkOnePartFrom = unserialize($_POST["dataMatcherLinkOnePartFrom"]);
$dataMatcherLinkOnePartTo = unserialize($_POST["dataMatcherLinkOnePartTo"]);

// "disable partial output" or
// "enable buffering" to give out all at once later
ob_start();

// "say hello" to client (parent script in this case) disconnection
// before child ends - we need not care about it
ignore_user_abort(1);

// we will work forever
set_time_limit(0);

// we need to say something to parent to stop its waiting
// it could be something useful like client ID or just "OK"
echo "OKKKK";

//var_dump($sid,$logId,$ktrManager, $db);

// push buffer to parent

ob_flush();
flush();


$areDatasetsProcessed = checkIfDatasetsAreProcessed($dataMatcherLinkOnePartFrom, $dataMatcherLinkOnePartTo);

$count = 0;

while (!$areDatasetsProcessed) {
    sleep(20);

    $areDatasetsProcessed = checkIfDatasetsAreProcessed($dataMatcherLinkOnePartFrom, $dataMatcherLinkOnePartTo);

    //TODO do something to make sure that process die if this checking happens for a log time.
    $count += 1;

    if ($count > 10000000)
        die; //write this action in some log (e.g. in some db table);
}

callDataMatchingRatioComputation($dataMatcherLinkOnePartFrom, $dataMatcherLinkOnePartTo);

exit;


function checkIfDatasetsAreProcessed($dataMatcherLinkOnePartFrom, $dataMatcherLinkOnePartTo)
{
    $statusFrom = ExecutionManager::getExecutionStatusForOneTable($dataMatcherLinkOnePartFrom->sid, $dataMatcherLinkOnePartFrom->tableName);
    $statusTo = ExecutionManager::getExecutionStatusForOneTable($dataMatcherLinkOnePartTo->sid, $dataMatcherLinkOnePartTo->tableName);

    if ($statusFrom->status == "error" || $statusTo->status == "error") {
        die("datasets are in error");
    }

    if ($statusFrom->status == "success" && $statusTo->status == "success") {
        return true;
    }

    return false;
}

function callDataMatchingRatioComputation($dataMatcherLinkOnePartFrom, $dataMatcherLinkOnePartTo)
{
    $dataMatchExecutor = new DataMatchExecutor($dataMatcherLinkOnePartFrom, $dataMatcherLinkOnePartTo);
    $dataMatchExecutor->getDataMatchingRatios();
}


?>