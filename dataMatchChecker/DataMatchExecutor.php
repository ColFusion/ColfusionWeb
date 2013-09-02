<?php


require_once(realpath(dirname(__FILE__)) . '/../DAL/ExternalDBHandlers/MSSQLHandler.php');
require_once(realpath(dirname(__FILE__)) . '/../DAL/QueryMakers/CheckdataMatchingQueryMaker.php');
require_once(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/LinkedServerCred.php');

/**
* Executes data matching.
*/
class DataMatchExecutor
{
	
	public function CheckDataMatching($from, $to) 
	{
//var_dump($from, $to);

		$checkDataMatchingQueryMaker = new CheckdataMatchingQueryMaker($from, $to);

        $notMatchedInFrom = $checkDataMatchingQueryMaker->getNotMachedInFromQuery();
        $notMatchedInTo = $checkDataMatchingQueryMaker->getNotMachedInToQuery();
        $countOfMached = $checkDataMatchingQueryMaker->getCountOfMached();
        $countOfTotalDistinct = $checkDataMatchingQueryMaker->getCountOfTotalDistinct();

//var_dump(MSSQLWLS_DB_USER, MSSQLWLS_DB_PASSWORD, MSSQLWLS_DB_NAME, MSSQLWLS_DB_HOST, MSSQLWLS_DB_PORT);

//var_dump($notMatchedInFrom, $notMatchedInTo, $countOfMached, $countOfTotalDistinct);

        $MSSQLHandler = new MSSQLHandler(MSSQLWLS_DB_USER, MSSQLWLS_DB_PASSWORD, MSSQLWLS_DB_NAME, MSSQLWLS_DB_HOST, MSSQLWLS_DB_PORT);

        $result = new stdClass;

        $result->notMatchedInFrom = $notMatchedInFrom;
        $result->notMatchedInTo = $notMatchedInTo;
        $result->countOfMached = $countOfMached;
        $result->countOfTotalDistinct = $countOfTotalDistinct;


        $columnsFrom = $checkDataMatchingQueryMaker->GetColumnsFromSource($from);
        $columnsTo = $checkDataMatchingQueryMaker->GetColumnsFromSource($to);

        $result->notMatchedInFromData = new stdClass;

        $ar = array("[", "]");
        $columnNames = str_replace($ar, "", $columnsFrom->columnNames);


        $result->notMatchedInFromData->columns = explode(",", $columnNames);
        $result->notMatchedInFromData->columnsAliases = explode(",", $columnsFrom->columnAliases);
        $result->notMatchedInFromData->rows = $MSSQLHandler->ExecuteQuery($notMatchedInFrom);

        $columnNames = str_replace($ar, "", $columnsTo->columnNames);


        $result->notMatchedInToData = new stdClass;
        $result->notMatchedInToData->columns = explode(",", $columnNames);
        $result->notMatchedInToData->columnsAliases = explode(",", $columnsTo->columnAliases);
        $result->notMatchedInToData->rows = $MSSQLHandler->ExecuteQuery($notMatchedInTo);

        $result->countOfMachedData = new stdClass;
        $result->countOfMachedData->columns = array("ct");
        $result->countOfMachedData->rows = $MSSQLHandler->ExecuteQuery($countOfMached);

        $result->countOfTotalDistinctData = new stdClass;
        $result->countOfTotalDistinctData->columns = array("ct");
        $result->countOfTotalDistinctData->rows = $MSSQLHandler->ExecuteQuery($countOfTotalDistinct);

        return $result;
	}

	 // source is an object {sid:, tableName, links:[]}
    // links are columns or transformations
    // $searchTerms is an associated array where keys are the links and values are search terms for associated links.
    public function GetDistinctForColumns($source, $perPage, $pageNo, $searchTerms = null) {

        $from = (object) array('sid' => $source->sid, 'tableName' => "[{$source->tableName}]");
        $fromArray = array($from);

        $transHandler = new TransformationHandler();

        $columnNames = array();
        $columnNamesNoBrack = array();

        $whereArray = array();

        foreach ($source->links as $key=>$link) {

            $column = $transHandler->decodeTransformationInput($link, true);
            $columnNames[] = "[$column]";
            $columnNamesNoBrack[] = $column;

            if (isset($searchTerms)) {
                if (isset($searchTerms[$link])) {
                    $whereArray[] = " [$column] like '%" . $searchTerms[$link] . "%' ";
                }
            }
        }

        $columns = implode(",", array_values($columnNames));


        $where = null;

        if (count($whereArray) > 0)
            $where = "where " . implode(" and ", array_values($whereArray));

        $queryEngine = new QueryEngine();

        $result = new stdClass;
        $result->columns = $columnNamesNoBrack;
        $result->rows = $queryEngine->doQuery("SELECT distinct $columns", $fromArray, $where, null, null, $perPage, $pageNo);
        $result->totalRows = $queryEngine->doQuery("SELECT COUNT(distinct $columns) as ct", $fromArray, $where, null, null, null, null);

        return $result;
    }
}

?>