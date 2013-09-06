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
					$totalDataMatchinRatio = 0;
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
						$onePathOneRelation->dataMatchingRatio = $this->getRelationshipDataMatchingRatio($oneRel);

						$onePathRelationships[] = $onePathOneRelation; 

						$totalConfidence += $onePathOneRelation->confidence;

						$totalDataMatchinRatio += $onePathOneRelation->dataMatchingRatio;

					}

					$onePathResult->avgConfidence = $totalConfidence / count($onePath);
					$onePathResult->avgDataMatchingRatio = $totalDataMatchinRatio / count($onePath);
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

	private function getRelationshipDataMatchingRatio($rel_id) {
		$relationshipDAO = new RelationshipDAO();

		$res = $relationshipDAO->getRelationshipAverageDataMatchingRatios($rel_id);

		return max($res->avgFrom, $res->avgTo);

	}

}

?>