<?php

include_once(realpath(dirname(__FILE__)) . '/../DAL/ExternalDBHandlers/MSSQLHandler.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/TransformationHandler.php');

include_once(realpath(dirname(__FILE__)) . '/DataMatchExecutor.php');
include_once(realpath(dirname(__FILE__)) . '/DataMatcherLinkOnePart.php');

include_once(realpath(dirname(__FILE__)) . '/../DataImportWizard/ExecutionManager.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/RelationshipDAO.php');

/**
* Operations for data match checker
*/
class DataMatcher
{
	
	public function CheckDataMatching(DataMatcherLinkOnePart $from, DataMatcherLinkOnePart $to) {

//		var_dump($from, $to);
		$dataMatchExecutor = new DataMatchExecutor($from, $to);

		return $dataMatchExecutor->CheckDataMatching($from, $to);
        
    }

    // source is an object {sid:, tableName, links:[]}
    // links are columns or transformations
    // $searchTerms is an associated array where keys are the links and values are search terms for associated links.
    public function GetDistinctForColumns($dataMatcherLinkOnePart, $perPage, $pageNo, $searchTerms = null) {

      	return DataMatchExecutor::GetDistinctForColumns($dataMatcherLinkOnePart, $perPage, $pageNo, $searchTerms);
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

 //var_dump($rel_ids);

 		if (!isset($rel_ids) || count($rel_ids) == 0)
 			return;


    	$relationshipDAO = new RelationshipDAO();

    	foreach ($rel_ids as $key => $rel_id) {
    		$rel = $relationshipDAO->getRelationship($rel_id, 1); //this might too expensive, I don't need all infor about relationships, just sids, tablemes and links

    		foreach ($rel->links as $key => $link) {

    			$from = new DataMatcherLinkOnePart();
				$from->sid = $rel->fromDataset->sid;
				$from->tableName = $rel->fromTableName;
				$from->transformation = $link->fromPartEncoded;

				$to = new DataMatcherLinkOnePart();
				$to->sid = $rel->toDataset->sid;
				$to->tableName = $rel->toTableName;
				$to->transformation = $link->toPartEncoded;

//var_dump($from, $to);

    			ExecutionManager::callChildProcessToCacheDistinctColumnValues($from, $to);
    		}
    	}

    	
    }
}

?>