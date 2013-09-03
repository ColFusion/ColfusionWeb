<?php


require_once(realpath(dirname(__FILE__)) . '/../DAL/ExternalDBHandlers/MSSQLHandler.php');
require_once(realpath(dirname(__FILE__)) . '/../DAL/QueryMakers/CheckDataMatchingQueryMaker.php');
require_once(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/LinkedServerCred.php');
include_once(realpath(dirname(__FILE__)) . '/DataMatcherLinkOnePart.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/DataMatchingCheckerDAO.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/RelationshipDAO.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/Neo4JDAO.php');


/**
* Executes data matching.
*/
class DataMatchExecutor
{
	
	private $from;
	private $to;

	 public function __construct(DataMatcherLinkOnePart $from, DataMatcherLinkOnePart $to) {
       $this->from = $from;
       $this->to = $to;
    }

	public function CheckDataMatching() 
	{
//var_dump($from, $to);
//
//var_dump("in DataMatchExecutor");

		$checkDataMatchingQueryMaker = new CheckdataMatchingQueryMaker($this->from, $this->to);

        $notMatchedInFrom = $checkDataMatchingQueryMaker->getNotMachedInFromQuery();
        $notMatchedInTo = $checkDataMatchingQueryMaker->getNotMachedInToQuery();
        $countOfMached = $checkDataMatchingQueryMaker->getCountOfMached();
        $countOfTotalDistinct = $checkDataMatchingQueryMaker->getCountOfTotalDistinct();

       

//var_dump($notMatchedInFrom, $notMatchedInTo, $countOfMached, $countOfTotalDistinct);

//var_dump(MSSQLWLS_DB_USER, MSSQLWLS_DB_PASSWORD, MSSQLWLS_DB_NAME, MSSQLWLS_DB_HOST, MSSQLWLS_DB_PORT);

//var_dump($notMatchedInFrom, $notMatchedInTo, $countOfMached, $countOfTotalDistinct);

        $MSSQLHandler = new MSSQLHandler(MSSQLWLS_DB_USER, MSSQLWLS_DB_PASSWORD, MSSQLWLS_DB_NAME, MSSQLWLS_DB_HOST, MSSQLWLS_DB_PORT);

        $result = new stdClass;

        $result->notMatchedInFrom = $notMatchedInFrom;
        $result->notMatchedInTo = $notMatchedInTo;
        $result->countOfMached = $countOfMached;
        $result->countOfTotalDistinct = $countOfTotalDistinct;

        $columnsFrom = $checkDataMatchingQueryMaker->GetColumnsFromSource($this->from);
        $columnsTo = $checkDataMatchingQueryMaker->GetColumnsFromSource($this->to);

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

        $result->ratios = $this->getDataMatchingRatios();

        return $result;
	}

	 // source is an object {sid:, tableName, links:[]}
    // links are columns or transformations
    // $searchTerms is an associated array where keys are the links and values are search terms for associated links.
    public static function GetDistinctForColumns($dataMatcherLinkOnePart, $perPage, $pageNo, $searchTerms = null) {

        $from = (object) array('sid' => $dataMatcherLinkOnePart->sid, 'tableName' => "[{$dataMatcherLinkOnePart->tableName}]");
        $fromArray = array($from);

        $transHandler = new TransformationHandler();

        $columnNames = array();
        $columnNamesNoBrack = array();

        $whereArray = array();

        foreach ($dataMatcherLinkOnePart->transformation as $key=>$transformation) {

            $column = $transHandler->decodeTransformationInput($transformation, true);
            $columnNames[] = "[$column]";
            $columnNamesNoBrack[] = $column;

            if (isset($searchTerms)) {
                if (isset($searchTerms[$transformation])) {
                    $whereArray[] = " [$column] like '%" . $searchTerms[$transformation] . "%' ";
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

    public function getDataMatchingRatios()
    {

    	//TODO: here need to check the ratios might calculated already, so just need to pool them out form database.

    	$checkDataMatchingQueryMaker = new CheckdataMatchingQueryMaker($this->from, $this->to);

    	$countOfNotMachedInFromQuery = $checkDataMatchingQueryMaker->getCountOfNotMachedInFromQuery();
        $countOfNotMachedInToQuery = $checkDataMatchingQueryMaker->getCountOfNotMachedInToQuery();

        $countOfDistinctInFromQuery = $checkDataMatchingQueryMaker->getCountOfDistinctInFromQuery();
        $countOfDistinctInToQuery = $checkDataMatchingQueryMaker->getCountOfDistinctInToQuery();

//var_dump($countOfNotMachedInFromQuery, $countOfNotMachedInToQuery, $countOfDistinctInFromQuery, $countOfDistinctInToQuery);

		$MSSQLHandler = new MSSQLHandler(MSSQLWLS_DB_USER, MSSQLWLS_DB_PASSWORD, MSSQLWLS_DB_NAME, MSSQLWLS_DB_HOST, MSSQLWLS_DB_PORT);


		$countOfNotMachedInFrom = $MSSQLHandler->ExecuteQuery($countOfNotMachedInFromQuery);
		$countOfNotMachedInTo = $MSSQLHandler->ExecuteQuery($countOfNotMachedInToQuery);

		$countOfDistinctInFrom = $MSSQLHandler->ExecuteQuery($countOfDistinctInFromQuery);
		$countOfDistinctInTo = $MSSQLHandler->ExecuteQuery($countOfDistinctInToQuery);


//var_dump($countOfNotMachedInFrom, $countOfNotMachedInTo, $countOfDistinctInFrom, $countOfDistinctInTo);

        $result = new stdClass;

        $result->countOfNotMachedInFromQuery = $countOfNotMachedInFromQuery;
        $result->countOfNotMachedInToQuery = $countOfNotMachedInToQuery;

        $result->countOfDistinctInFromQuery = $countOfDistinctInFromQuery;
        $result->countOfDistinctInToQuery = $countOfDistinctInToQuery;

        $result->countOfNotMachedInFrom = $countOfNotMachedInFrom[0]['ct'];
        $result->countOfNotMachedInTo = $countOfNotMachedInTo[0]['ct'];

        $result->countOfDistinctInFrom = $countOfDistinctInFrom[0]['ct'];
        $result->countOfDistinctInTo = $countOfDistinctInTo[0]['ct'];

//var_dump($result->countOfNotMachedInFrom, $result->countOfNotMachedInTo, $result->countOfDistinctInFrom,  $result->countOfDistinctInTo);

		
//var_dump(is_numeric($result->countOfDistinctInFrom), is_numeric($result->countOfNotMachedInFrom));

		if (is_numeric($result->countOfDistinctInFrom) && is_numeric($result->countOfNotMachedInFrom)) {
        	$result->dataMatchingFromRatio = (floatval($result->countOfDistinctInFrom) - floatval($result->countOfNotMachedInFrom)) / floatval($result->countOfDistinctInFrom);
        }
        else {
        	$result->dataMatchingFromRatio = "NULL";
        }

        if (is_numeric($result->countOfDistinctInTo) && is_numeric($result->countOfNotMachedInTo)) {
        	$result->dataMatchingToRatio = (floatval($result->countOfDistinctInTo) - floatval($result->countOfNotMachedInTo)) / floatval($result->countOfDistinctInTo);
        }
        else {
        	$result->dataMatchingToRatio = "NULL";
        }

        $this->storeRatiosInDB($result->dataMatchingFromRatio, $result->dataMatchingToRatio);

        return $result;
    }

    public function storeRatiosInDB($dataMatchingFromRatio, $dataMatchingToRatio)
    {
    	$dataMatchingCheckerDAO = new DataMatchingCheckerDAO();

    	$dataMatchingCheckerDAO->storeDataMatchingRatios($this->from->transformation, $dataMatchingFromRatio, $this->to->transformation, $dataMatchingToRatio);

//var_dump($this->from->transformation, $this->to->transformation);

    	$relationshipDAO = new RelationshipDAO();
    	$res = $relationshipDAO->getRelIdByTransformations($this->from->transformation, $this->to->transformation);
    	$rel_id = $res->rel_id;

    	$rel = $relationshipDAO->getRelationship($rel_id);

//var_dump($rel_id, $rel);

    	if (isset($rel)) {
    		if ($rel->creator == "ColfusionAgent") {
    			$relationshipDAO->updateComment($rel_id, $rel->creatorId, max($dataMatchingFromRatio, $dataMatchingToRatio), "Based on data matching ratio");

    			$avgConfidence = $relationshipDAO->getRelationshipAverageConfidenceByRelId($rel_id);
	    		$n4jDao = new Neo4JDAO();
	    		$n4jDao->updateCostByRelId($rel_id, 1 - $avgConfidence);
    		}
    	}
    }
}

?>