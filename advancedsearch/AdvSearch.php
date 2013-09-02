<?php
set_time_limit (0);

include_once("../DataImportWizard/UtilsForWizard.php");
include_once("../DAL/ExternalDBHandlers/ExternalMSSQL.php");

require_once(realpath(dirname(__FILE__)) . "/../DAL/Neo4JDAO.php");

include_once(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');
include_once(realpath(dirname(__FILE__)) . '/../DAL/RelationshipDAO.php');

class AdvSearch {
	
	private $searchKeyWords;
	private $joinKeywords;
	private $whereVariable;
	private $whereRule;
	private $whereCondition;
	
	public function setSearchKeywords($searchKeyWords) {
		$this->searchKeyWords = $searchKeyWords;
	}
	
	public function getSearchKeywords() {
		return $this->searchKeyWords;
	}
	
	public function setJoinKeywords($joinKeywords) {
		$this->joinKeywords = $joinKeywords;
	}
	
	public function getJoinKeywords() {
		return $this->joinKeywords;
	}
	
	public function setWhereVariable($whereVariable) {
		$this->whereVariable = $whereVariable;
	}
	
	public function getWhereVariable() {
		return $this->whereVariable;
	}
	
	public function setWhereRule($whereRule) {
		$this->whereRule = $whereRule;
	}
	
	public function getWhereRule() {
		return $this->whereRule;
	}
	
	public function setWhereCondition($whereCondition) {
		$this->whereCondition = $whereCondition;
	}
	
	public function getWhereCondition() {
		return $this->whereCondition;
	}
	

	public function doSearch() {
		global $db;
		
		if (!isset($this->searchKeyWords))
			return "";
		
		$sids = $this->getSidsContainingSearchKeys();

		if (!isset($sids) || count($sids) == 0)
			return array();
// echo "sids:";
// var_dump($sids);
// echo "\n";

		$result = $this->getRelationshipToJoin($sids);

		$result = $this->getMoreInfoForEachRel($result);

		return $result;
	}

	private function getSidsContainingSearchKeys() {
		global $db;

		$chunks = array_map('trim', $this->searchKeyWords);
		
		$inCrit = implode("','", $chunks);

		$sql = "select distinct di.sid from colfusion_dnameinfo di, colfusion_sourceinfo si where (dname_chosen in ('$inCrit') or dname_original_name in ('$inCrit')) and di.sid = si.sid and si.Status = 'queued';";
        
//echo $sql;

		$rst = $db->get_results($sql);
		
		if (!isset($rst) || count($rst) == 0)
			return array();

		$result = array();

		foreach ($rst as $key => $value) {
			$result[] = $value->sid;
		}
	
		return $result;
	}
	
	private function getRelationshipToJoin($sids) {
//TODO: move to neo4j handler class

		$neo4JDAO = new Neo4JDAO();

		$allSearchRes = array();
    
	    $targetSidsCopy = $sids;
	  


	    do {

			$node1Sid = array_pop($targetSidsCopy);
            
// echo "iteration in getRelationshipToJoin\n";
// echo "node1Sid:";
// var_dump($node1Sid);
// echo "\n";
// echo "targetSidsCopy:";
// var_dump($targetSidsCopy);
// echo "\n";

	    	$res = $this->rec($neo4JDAO, $node1Sid, $targetSidsCopy, "\t", array(), array());
	    	
	    	$oneSearchRes = new stdClass();
	    	
	    	if (count($res->ar) == 0) {
	    		$oneSearchRes->oneSid = true;
	    		$oneSearchRes->value = $node1Sid;
	    	}
	    	else {
	    		$oneSearchRes->oneSid = false;
	    		$oneSearchRes->value = $res->ar;
	    	}
	    	
	    	$allSearchRes[] = $oneSearchRes;
	    	
	    	$targetSidsCopy = $res->needToCheck;
	    	
	    } while (count($targetSidsCopy) > 0);

// echo "done:";
// var_dump($allSearchRes);

	    
	    return $allSearchRes;
	}

	//TODO: move to other class for neo4j handler
	private function rec($neo4JDAO, $node, $list, $intend, $needToCheckAccumul, $resultAccumul) {

// echo "$intend rec iteration:\n";
// echo "$intend \t sid:{$node}\n";
// echo "$intend \t list:";
// var_dump($list);
// echo "\n";
// echo "$intend \t needToCheckAccumul:";
// var_dump($needToCheckAccumul);
// echo "\n";
// echo "$intend \t resultAccumul:";
// var_dump($resultAccumul);
// echo "\n";

        if (count($list) == 0) {

        	$result = new stdClass();

            $result->ar = $resultAccumul;
            $result->needToCheck = $needToCheckAccumul;

            return $result;
        }

        $otherNode = array_pop($list);
// echo "$intend \t otherNode:{$otherNode}\n";   

        $paths = $neo4JDAO->getAllPathsBetweenTwoNodes($node, $otherNode);

// echo "$intend \t paths:";
// var_dump($paths->paths);
// echo "\n";

        if (count($paths) == 0) {
                        
        	$needToCheck = array_merge($needToCheckAccumul, array($otherNode));

            return $this->rec($neo4JDAO, $node, $list, $intend . "\t", $needToCheck, $resultAccumul);
        }
        else {

            if (count($resultAccumul) == 0) {
                $resultAccumul = $paths;
            }
            else {
            	$resultAccumul = $this->mergePaths($paths, $resultAccumul);
            }       

            return $this->rec($neo4JDAO, $otherNode, $list, $intend . "\t", $needToCheckAccumul, $resultAccumul);
        }
    }

    private function mergePaths($newPaths, $foundBefore) {
    	$result = array();

		for ($j=0; $j < count($newPaths); $j++) {
            for ($i=0; $i < count($foundBefore); $i++) { 

                $newMergedPath = array_unique(array_merge($foundBefore[$i], $newPaths[$j]));

                $found = false;

                foreach ($result as $key => $path) {
                	if (count(array_diff($path, $newMergedPath)) == 0) {
                		$found = true;
                		break;
                	}
                }

                if (!$found)
                	$result[] = $newMergedPath;
            }
        }  

        return $result;
    }

	// TODO: refactor created additional classes and use them
	private function getMoreInfoForEachRel($searchResults) {
		global $db;
        
		$result = array();

		$i = 0;
		$j = 0;

		foreach ($searchResults as $key => $value) {

			$i += 1;

			$oneSearchResult = new stdClass();

			$oneSearchResult->oneSid = $value->oneSid;

			if ($value->oneSid) {
				$oneSearchResult->sid = $value->value;
				$oneSearchResult->title = $this->getTitleBySid($value->value);
				$oneSearchResult->tableName = $this->getTableNameBySearchKeys($oneSearchResult->sid);
				$oneSearchResult->allColumns = $this->getColumnsBySid($value->value, $oneSearchResult->tableName);
				
				$oneSearchResult->foundSearchKeys = $this->checkFoundSearchKeysAndMerge(array(), $oneSearchResult->allColumns);

				$from = (object) array('inputObj' => $oneSearchResult, 'tableName' => $oneSearchResult->tableName);
		        $fromArray = array($from);
		       
		        $queryEngine = new QueryEngine();

		        $select = "select * ";// . implode(", ", $selectAr);

			//	$oneSearchResult->queryTest = $queryEngine->doQuery($select, $fromArray, null, null, null, null, null);

			}
			else {

				$allPaths = array();

				$allPossiblePaths = $value->value;
				//$value here is one search result which include several possible paths
				//$value->value is array of all possible paths.
				foreach ($allPossiblePaths as $key => $onePath) {

					$j += 1;

					$onePathResult = new stdClass();

					$totalConfidence = 0;
					$onePathSidTitles = array();
					$onePathSids = array();
					$onePathRelIds = array();
					$onePathAllColumns = array();
					
					$onePathRelationships = array();

					foreach ($onePath as $key => $oneRel) {

						$onePathOneRelation = new stdClass();
						
						$onePathRelIds[] = $oneRel;


						$moreInfo = $this->getSidsAndTableNamesByRelId($oneRel);
						$onePathOneRelation->sidFrom = new stdClass();
						$onePathOneRelation->sidFrom->sid = $moreInfo->sid1;
						$onePathOneRelation->sidFrom->tableName = $moreInfo->tableName1;
						$onePathOneRelation->sidFrom->sidTitle = $this->getTitleBySid($moreInfo->sid1);
						$onePathOneRelation->sidFrom->allColumns = $this->getColumnsBySid($moreInfo->sid1, $onePathOneRelation->sidFrom->tableName);

						if (!in_array($moreInfo->sid1, $onePathSids)) {
							$onePathSids[] = $moreInfo->sid1;
						}

						if (!in_array($onePathOneRelation->sidFrom->sidTitle, $onePathSidTitles)) {
							$onePathSidTitles[] = $onePathOneRelation->sidFrom->sidTitle;
						}

						$dif = $this->objectArrayDiff($onePathAllColumns, $onePathOneRelation->sidFrom->allColumns);
					//	var_dump($dif);
						$onePathAllColumns = array_merge($onePathAllColumns, $dif);
					//	var_dump($onePathAllColumns);
						$onePathOneRelation->sidTo = new stdClass();
						$onePathOneRelation->sidTo->sid = $moreInfo->sid2;
						$onePathOneRelation->sidTo->tableName = $moreInfo->tableName2;
						$onePathOneRelation->sidTo->sidTitle = $this->getTitleBySid($moreInfo->sid2);
						$onePathOneRelation->sidTo->allColumns = $this->getColumnsBySid($moreInfo->sid2, $onePathOneRelation->sidTo->tableName);

						if (!in_array($moreInfo->sid2, $onePathSids)) {
							$onePathSids[] = $moreInfo->sid2;
						}

						if (!in_array($onePathOneRelation->sidTo->sidTitle, $onePathSidTitles)) {
							$onePathSidTitles[] = $onePathOneRelation->sidTo->sidTitle;
						}
						
						$dif = $this->objectArrayDiff($onePathAllColumns, $onePathOneRelation->sidTo->allColumns);
						$onePathAllColumns = array_merge($onePathAllColumns, $dif);

						$onePathOneRelation->relId = $oneRel;
						$onePathOneRelation->relName = $moreInfo->name;
						$onePathOneRelation->confidence = $this->getRelationshipCofidence($oneRel);

						$onePathRelationships[] = $onePathOneRelation; 

						$totalConfidence += $onePathOneRelation->confidence;

					}

					$onePathResult->avgConfidence = $totalConfidence / count($onePath);
					$onePathResult->relationships = $onePathRelationships;
					$onePathResult->sidTitles = $onePathSidTitles;
					$onePathResult->sids = $onePathSids;
					$onePathResult->relIds = $onePathRelIds;
					$onePathResult->allColumns = $onePathAllColumns;
					$onePathResult->oneSid = false;
					$onePathResult->tableName = "NA";
					$onePathResult->title = "Search result $i, path $j";
					$onePathResult->sid = implode(",", $onePathResult->sids) . ',' . implode(",", $onePathResult->relIds);

					$chunks = array_map('trim', $this->searchKeyWords);

					$onePathResult->foundSearchKeys = $this->checkFoundSearchKeysAndMerge(array(), $onePathAllColumns);
					


					$from = (object) array('inputObj' => $onePathResult, 'tableName' => "NA");
			        $fromArray = array($from);
			       
			        $queryEngine = new QueryEngine();
			        
			       // var_dump($fromArray);

			        $selectAr = array();

			        foreach ($onePathResult->foundSearchKeys as $key => $fSearchKeys) {
			        	$selectAr[] = "cid({$fSearchKeys->cid}) as {$fSearchKeys->dname_chosen} ";
			        }

			        $select = "select * ";// . implode(", ", $selectAr);

				//	$onePathResult->queryTest = $queryEngine->doQuery($select, $fromArray, null, null, null, null, null);

					$allPaths[] = $onePathResult;	
				}

				$oneSearchResult->allPaths = $allPaths;
				$oneSearchResult->title = "Search result $i";
				
			}

			$result[] = $oneSearchResult;
		}

		return $result;

	}

	private function objectArrayDiff($onePathAllColumns, $oneStoryAllColumns) {
		$result = array();

		foreach ($oneStoryAllColumns as $key => $oneStoryColumn) {
			$found = false;

			foreach ($onePathAllColumns as $key => $onePathColumn) {
				if ($oneStoryColumn->cid == $onePathColumn->cid) {
					$found = true;
					break;
				}
			}

			if (!$found) {
				$result[] = $oneStoryColumn;
			}
		}

		return $result;	
	}

	private function checkFoundSearchKeysAndMerge($alreadyFoundAr, $allColumns) {
		$chunks = array_map('trim', $this->searchKeyWords);

		foreach ($allColumns as $key => $column) {
			if (in_array($column->dname_chosen, $chunks) || in_array($column->dname_original_name, $chunks)) {
				
				$found = false;
				foreach ($alreadyFoundAr as $key => $columnInFound) {
					if ($columnInFound->cid == $column->cid) {
						$found = true;
						break;
					}
				}

				if (!$found) {
					$alreadyFoundAr[] = $column;
				}
			}
		}

		return $alreadyFoundAr;
	}


	private function getTitleBySid($sid) {
		global $db;

		$sql = "select title from colfusion_sourceinfo where sid = $sid";

		return $db->get_row($sql)->title;
	}

	private function getColumnsBySid($sid, $tableName = null) {
		
		$queryEngine = new QueryEngine();
	    
	    $result = $queryEngine->GetTablesInfo($sid);
	   
	    return $result[$tableName];
	}

//TODO: look at closer, posisble wrong results
	private function getTableNameBySearchKeys($sid) {
		global $db;

		$chunks = array_map('trim', $this->searchKeyWords);
		
		$inCrit = implode("','", $chunks);

		$sql = "select tableName from colfusion_dnameinfo inner join colfusion_columnTableInfo on (colfusion_dnameinfo.cid = colfusion_columnTableInfo.cid) where sid = $sid and dname_chosen in ('$inCrit') limit 1";
         
		$res = $db->get_results($sql);
		$result = array();

		foreach ($res as $key => $value) {
			$result[] = $value->tableName;
		}
	
		return $result[0];
	}

	private function getSidsAndTableNamesByRelId($rel_id) {
		global $db;

		$sql = "select sid1, sid2, tableName1, tableName2, name FROM  colfusion_relationships where rel_id = $rel_id";

//echo $sql;

		$res = $db->get_row($sql);

		return $res;
	}

	private function getRelationshipCofidence($rel_id){
		$relDAO = new RelationshipDAO();
		return $relDAO->getRelationshipAverageConfidenceByRelId($rel_id);
	}

	private function constructResultArray($sidDnames, $searchKeyWords) {
		
		global $db;
		
		$result = array();
		
		if (empty($sidDnames))
			return $result;
		
		do {
			$toJoin = array(); //search result entry
			
			array_push($toJoin, array_pop($sidDnames)); //take first from the sql query restult and remove it from the array
			
			if (is_null($toJoin[0]->sidTo)) {
				
				$sids = array($toJoin[0]->sid);
				
				$allColumns = $this->getAllColumnsFromJoin($sids);
				
				$schemaAndWhereKeyWordsIntersect = array_intersect($allColumns, $this->whereVariable);
				
				if (isset($this->whereVariable) || count($schemaAndWhereKeyWordsIntersect) == count($this->whereVariable)) {
				
					$oneResult = $this->constractOneSearchResult($sids, $searchKeyWords, $allColumns);
								
					array_push($result, $oneResult);
				}
				
				continue;
			}
			
			$resultOneRecord = array_merge(array($toJoin[0]->sid), spliti(',', $toJoin[0]->sidTo));
			
			$i = 1;
			do {
				$searchId = $resultOneRecord[$i];

				for ($j = count($sidDnames) - 1; $j >=0; $j--) {
					if ($sidDnames[$j]->sid == $searchId) {
						$resultOneRecord = $this->mergeDiff($resultOneRecord, spliti(',', $sidDnames[$j]->sidTo));
						array_splice($sidDnames, $j, 1);
					}
					else if (in_array($searchId, spliti(',', $sidDnames[$j]->sidTo))) {
						$resultOneRecord = $this->mergeDiff($resultOneRecord, array($sidDnames[$j]->sid));
						$resultOneRecord = $this->mergeDiff($resultOneRecord, spliti(',', $sidDnames[$j]->sidTo));
						array_splice($sidDnames, $j, 1);
					}					
				}
				
				$i++;	
			}
			while ($i < count($resultOneRecord) && !empty($sidDnames));
			
			$allColumns = $this->getAllColumnsFromJoin($resultOneRecord);
			
			$schemaAndWhereKeyWordsIntersect = array_intersect($allColumns, $this->whereVariable);
			
			if (isset($this->whereVariable) || count($schemaAndWhereKeyWordsIntersect) == count($this->whereVariable)) {
			
				$oneResult = $this->constractOneSearchResult($resultOneRecord, $searchKeyWords, $allColumns);
			
				array_push($result, $oneResult);
			}		
		}
		while (!empty($sidDnames));
			
		return $result;

		
	}
	
	private function constractOneSearchResult($sids, $searchKeyWords, $allColumns) {
		$oneResult = "";
		
		$oneResult->datasets = $this->getDatasets($sids);
		$oneResult->searchColumns = $this->getFoundSearchKeyWords($sids, $searchKeyWords);
		$oneResult->sisToSearch = implode(",", $sids);
		$oneResult->where = $this->getWherePart();
		$oneResult->allColumns = $allColumns;
		//TODO: implement
		$oneResult->commonColumns = array("add here explanation of relationships");
			
		$oneResult->joinQuery = $this->getJoinQuery($sids, $oneResult->searchColumns);
		$oneResult->joinResults = $this->getJoinResults($oneResult->joinQuery);
		
		$__SESSION['joinQuery'] = $oneResult->joinQuery;

		return $oneResult;
	}
	
	private function getWherePart() {
		$wherePart = "";

		if (isset($this->whereVariable)) {
			$wherePart = " where ";

			for($i = 0; $i < count($this->whereVariable); ++$i) {
				$wherePart .= chr(96) . $this->whereVariable[$i] . chr(96) . " " . $this->whereRule[$i] . " '" . $this->whereCondition[$i] . "' AND ";
			}

			$wherePart = substr($wherePart, 0, -5);
		};
		
		return $wherePart;
	}
	
	// returns an array of objects with sid and link title for each sid in input param
	private function getDatasets($sids) {
		global $db;
		
		$sidsNoTableName = array_map('UtilsForWizard::getWordUntilFirstDot', $sids);
		
		$sidsString = implode("','", $sidsNoTableName);
		
		$query = "select sid, Title as link_title
from colfusion_sourceinfo
where sid in ('$sidsString');";
		
		 return $rst = $db->get_results($query);
		
	}
	
	private function getFoundSearchKeyWords($sids, $searchKeyWords) {
		global $db;
		
		$sidsString = implode("','", $sids);
		$searchKeyWordsString = implode("','", $searchKeyWords);
		
		$query = "select distinct dname_chosen
from (
		select dname_chosen, CONCAT(sid, '.', tableName) as sidTable
		from colfusion_dnameinfo di, colfusion_columnTableInfo cti
		where di.cid = cti.cid
	) as t
where sidTable in ('$sidsString')
		and dname_chosen in ('$searchKeyWordsString');";
		
		$rst = $db->get_results($query);

		foreach ($rst as $row) {
			$result[] = $row->dname_chosen;
		}
		
		return $result;
	}
	
	private function getAllColumnsFromJoin($sids) {
		global $db;
	
		$sidsString = implode("','", $sids);
			
		$query = "select distinct dname_chosen
from (
		select dname_chosen, CONCAT(sid, '.', tableName) as sidTable
		from colfusion_dnameinfo di, colfusion_columnTableInfo cti
		where di.cid = cti.cid
	) as t
where sidTable in ('$sidsString');";
	
		$rst = $db->get_results($query);
	
		foreach ($rst as $row) {
			$result[] = $row->dname_chosen;
		}
	
		return $result;
	}
	
	private function mergeDiff($ar1, $ar2) {
		$values = array_values($ar2);
		
		for($i = 0; $i < count($values); ++$i) {
			if (!in_array($values[$i], $ar1)) {
				array_push($ar1, $values[$i]);
			}
		}
		
		return $ar1;
	}
	
	private function getJoinQuery($sids, $foundSearchKeyWords) {
		return ExternalMSSQL::getJoinQuery($sids, $foundSearchKeyWords, 10, 1);
	}
	
	
	private function getJoinResults($query) {
		return ExternalMSSQL::runQueryWithLinkedServers($query);
	}
	
// 	public function doSearch() {
	
			
// 		global $db;
	
// 		if (!isset($this->searchKeyWords))
// 			return "";
	
// 		//	$chunks = $this->searchKeyWords;
// 		// spliti(',', $this->searchKeyWords[0]);
	
// 		$chunks = array_map('trim', $this->searchKeyWords);
	
// 		$inCrit = implode("','", $chunks);
	
// 		// 		$sql = "select  sid, link_title, GROUP_CONCAT(distinct dname) as columns from colfusion_temporary,  colfusion_links where colfusion_temporary.sid = colfusion_links.link_id and".
// 		// 				" dname in ('" . $inCrit . "') group by sid, link_title";
	
// 		$sql = "select  ct.sid, ss.link_title, ss.searchColumns,  GROUP_CONCAT(distinct TRIM(dname)) as allColumns
// 		from colfusion_temporary as ct,
// 		(select  sid, link_title, GROUP_CONCAT(distinct TRIM(dname)) as searchColumns
// 		from colfusion_temporary,  colfusion_links
// 		where colfusion_temporary.sid = colfusion_links.link_id and
// 		dname in ('" . $inCrit . "')
// 		group by sid, link_title) ss
// 		where ct.sid = ss.sid
// 		group by sid, link_title";
	
	
// 		$rst = $db->get_results($sql);
	
// 		$res = $this->constructResultArray($rst);
	
// 		//	$res = $db->query("call doJoin(\"4\");");
// 		//	$res = $db->get_results("select * from resultDoJoin;");
// 		//	$res2 = $db->get_col("select * from resultDoJoin;");
	
	
// 		return $res;
// 	}
	
// 	private function constructResultArray($sidDnames) {
	
// 		global $db;
	
// 		$result = array();
	
// 		if (empty($sidDnames))
// 			return $result;
	
// 		do {
// 			$toJoin = array(); //search result entry
				
// 			array_push($toJoin, array_pop($sidDnames)); //take first from the sql query restult and remove it from the array
				
// 			$toJoinSearchColumns = spliti(',', $toJoin[0]->searchColumns);
// 			$toJoinAllColumns = spliti(',', $toJoin[0]->allColumns); // dnames which will be check to join on
	
// 			$commonColumns = array();
				
// 			//	$toJoin[0]->allColumns = $toJoinDnames;
				
// 			unset($toJoin[0]->searchColumns);
// 			unset($toJoin[0]->allColumns);
				
// 			for($i = count($sidDnames) - 1; $i >= 0; --$i) {
					
// 				$withJoinAllColumns = spliti(',', $sidDnames[$i]->allColumns); // dnames which will be check to join with
// 				$withJoinSearchColumns = spliti(',', $sidDnames[$i]->searchColumns);
	
// 				$arIner = array_intersect($toJoinAllColumns, $withJoinAllColumns);
	
// 				if (!empty($arIner)){
// 					unset($sidDnames[$i]->allColumns);
// 					unset($sidDnames[$i]->searchColumns);
	
// 					array_push($toJoin, $sidDnames[$i]);
						
						
// 					$toJoinSearchColumns = $this->mergeDiff($toJoinSearchColumns, $withJoinSearchColumns);
// 					$toJoinAllColumns = $this->mergeDiff($toJoinAllColumns, $withJoinAllColumns);
// 					$commonColumns = $this->mergeDiff($commonColumns, $arIner);
						
	
						
						
// 					array_splice($sidDnames, $i, 1);
// 				}
	
// 			}
				
// 			$oneResult = "";
// 			$oneResult->datasets = $toJoin;
// 			$oneResult->searchColumns = $toJoinSearchColumns;
// 			$oneResult->commonColumns = $commonColumns;
// 			$oneResult->allColumns = $toJoinAllColumns;
// 			$oneResult->joinResults = array();
				
// 			$values = array_values($toJoin);
// 			$sids = array();
// 			for($i = 0; $i < count($values); ++$i) {
// 				array_push($sids, $values[$i]->sid);
// 			}
				
// 			$sisToSearch = implode(",", $sids);
				
// 			$oneResult->sids = $sids;
// 			$oneResult->sisToSearch = $sisToSearch;
	
				
// 			$schemaAndWhereKeyWordsIntersect = array_intersect($toJoinAllColumns, $this->whereVariable);
				
// 			if (isset($this->whereVariable) || count($schemaAndWhereKeyWordsIntersect) == count($this->whereVariable)) {
	
					
// 				$wherePart = "";
	
// 				if (isset($this->whereVariable)) {
// 					$wherePart = " where ";
						
// 					for($i = 0; $i < count($this->whereVariable); ++$i) {
// 						$wherePart .= chr(96) . $this->whereVariable[$i] . chr(96) . " " . $this->whereRule[$i] . " '" . $this->whereCondition[$i] . "' AND ";
// 					}
						
						
// 					$wherePart = substr($wherePart, 0, -5);
// 				};
	
// 				//	$sqlQr = "call doJoin(\"222\")";
// 				$sqlQr = "call doJoin(\"". $sisToSearch. "\")";
// 				$res = $db->query($sqlQr);
	
// 				$sqlQr = "select * from resultDoJoin " . $wherePart . " limit 5;";
// 				$res = $db->get_results($sqlQr);
	
	
// 				//$res = $db->get_results($sqlQr);
	
// 				$oneResult->joinResults = $res;
// 				$oneResult->where = $wherePart;
// 			}
				
				
// 			array_push($result, $oneResult);
				
				
				
// 		}
// 		while (!empty($sidDnames));
			
// 		return $result;
// 	}
}

?>