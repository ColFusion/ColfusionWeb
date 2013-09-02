<?php

include_once(realpath(dirname(__FILE__)) . '/../DAL/ExternalDBHandlers/MSSQLHandler.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/TransformationHandler.php');

include_once(realpath(dirname(__FILE__)) . '/DataMatchExecutor.php');

/**
* Operations for data match checker
*/
class DataMatcher
{
	
	public function CheckDataMatching($from, $to) {
		$dataMatchExecutor = new DataMatchExecutor();

		return $dataMatchExecutor->CheckDataMatching($from, $to);
        
    }

    // source is an object {sid:, tableName, links:[]}
    // links are columns or transformations
    // $searchTerms is an associated array where keys are the links and values are search terms for associated links.
    public function GetDistinctForColumns($source, $perPage, $pageNo, $searchTerms = null) {

        $dataMatchExecutor = new DataMatchExecutor();

		return $dataMatchExecutor->GetDistinctForColumns($source, $perPage, $pageNo, $searchTerms);
    }

    /**
     * Calculated data matching ratios for all links in a relationship specified by rel_id. The computation is done in a background.
     * While computing the ratios distinct values from stories involved in the relationship might be cached in MSSQL server. The caching happens only if two stories are form 
     * different locations (e.g. different DBMS and server).
     * 
     * @param  [type] $rel_ids colfusion relationship id for which to calculate links data matching rations.
     * @return [type]          [description]
     */
    public function calculateDataMatchingRatios($rel_ids)
    {

    }
}

?>