<?php


include_once(realpath(dirname(__FILE__)) . "/FromFileQueryMaker.php");
include_once(realpath(dirname(__FILE__)) . "/FromLinkedServerQueryMaker.php");
include_once(realpath(dirname(__FILE__)) . "/../DALUtils.php");
include_once(realpath(dirname(__FILE__)) . '/../TransformationHandler.php');
include_once(realpath(dirname(__FILE__)) . "/../../config.php");
include_once(realpath(dirname(__FILE__)) . '/../../dataMatchChecker/DataMatcherLinkOnePart.php');

// CheckdataMatchingQueryMaker can only run on MSSQL.
class CheckdataMatchingQueryMaker {

    private $from;
    private $to;

    private $fromQuery;
    private $toQuery;

    public function __construct(DataMatcherLinkOnePart $from, DataMatcherLinkOnePart $to) {
        if (count($from->transformation) != count($to->transformation)) {
            throw new Exception("Number of links in from and to are not the same.");
        }

        $this->from = $from;
        $this->to = $to;

        $this->fromQuery = $this->prepareOneQuery($this->from);
        $this->toQuery = $this->prepareOneQuery($this->to);
    }

    function prepareOneQuery(DataMatcherLinkOnePart $source) {

//var_dump('in prepareOneQuery');

        $columns = $this->GetColumnsFromSource($source);

        if (DALUtils::GetSourceType($source->sid) == "data file"){

            $fromLinkedServerQueryMaker = new FromLinkedServerQueryMaker($source, $columns);

            return $fromLinkedServerQueryMaker->MakeQueryOneTable();
        }
        else {

            return FromFileQueryMaker::MakeQueryToRotateTable($columns);            
        }
    }

    public function MakeOrUpdateFromAndToQuery($forseUpdate = false) {

//var_dump($this->fromQuery, $forseUpdate);

        if (!isset($this->fromQuery) || $forseUpdate)
            $this->fromQuery = $this->prepareOneQuery($this->from);

        if (!isset($this->toQuery) || $forseUpdate)
            $this->toQuery = $this->prepareOneQuery($this->to);
    }

    public function getIntersectionQuery($forseUpdate = false) {
        $this->MakeOrUpdateFromAndToQuery($forseUpdate);

        return $this->fromQuery . " intersect " . $this->toQuery;
    }

    public function getNotMachedInFromQuery($forseUpdate = false) {
        $this->MakeOrUpdateFromAndToQuery($forseUpdate);

        return $this->fromQuery . " except " . $this->toQuery . " except " . $this->getSynonymsQueryFor("from", "to");
    }

    public function getSynonymsQueryFor($direction, $opositeDirection) {
        $linkedServerName = my_pligg_base_no_slash;

        if ($direction == "from") {
            $source1 = $this->from;
            $source2 = $this->to;
        }
        else {
            $source1 = $this->to;
            $source2 = $this->from;
        }

        $query = <<<EOQ
           
        SELECT value
        FROM [$linkedServerName]...[colfusion_synonyms_$direction] as syn
        WHERE syn.sid = {$source1->sid} AND syn.tableName = '{$source1->tableName}' AND syn.transInput = '{$source1->transformation}'
              AND syn.syn_id in (SELECT syn_id
                                 FROM [$linkedServerName]...[colfusion_synonyms_$opositeDirection] as syn2
                                 WHERE syn2.sid = {$source2->sid} AND syn2.tableName = '{$source2->tableName}' AND syn2.transInput = '{$source2->transformation}'
                                )
EOQ;
    
        return $query;

    }

    public function getNotMachedInToQuery($forseUpdate = false) {
         $this->MakeOrUpdateFromAndToQuery($forseUpdate);

        return $this->toQuery . " except " . $this->fromQuery . " except " . $this->getSynonymsQueryFor("to", "from");
    }

    public function getCountOfMached($forseUpdate = false) {
         $this->MakeOrUpdateFromAndToQuery($forseUpdate);

        return "select count(*) as ct from ( (" . $this->toQuery . " intersect " . $this->fromQuery . ") union " . $this->getSynonymsQueryFor("to", "from") . ") as t";
    }

    public function getCountOfTotalDistinct($forseUpdate = false) {
        $this->MakeOrUpdateFromAndToQuery($forseUpdate);

        return "select count(*) as ct from (" . $this->toQuery . " union " . $this->fromQuery . ") as t";
    }

    public function getCountOfNotMachedInFromQuery($forseUpdate = false)
    {
        $this->MakeOrUpdateFromAndToQuery($forseUpdate);

        return "select count(*) as ct from (" . $this->getNotMachedInFromQuery() . " ) as temp ";
    }

    public function getCountOfNotMachedInToQuery($forseUpdate = false)
    {
        $this->MakeOrUpdateFromAndToQuery($forseUpdate);

        return "select count(*) as ct from (" . $this->getNotMachedInToQuery() . " ) as temp ";
    }

    public function getCountOfDistinctInFromQuery($forseUpdate = false)
    {
        $this->MakeOrUpdateFromAndToQuery($forseUpdate);

        return "select count(*) as ct from (" . $this->fromQuery . " ) as temp ";
    }

    public function getCountOfDistinctInToQuery($forseUpdate = false)
    {
        $this->MakeOrUpdateFromAndToQuery($forseUpdate);

        return "select count(*) as ct from (" . $this->toQuery . " ) as temp ";
    }

    // source has sid, links (array of cids) and table name.
    public function GetColumnsFromSource($source) {
        // get string names of columns which are involved in the links
   
        $transHandler = new TransformationHandler();
 
        $i = 0;

        $cidsArray = array();
        $columnNamesArray = array();
        $columnNameAndAliasArray = array();
        $columnAliasArray = array();

     //   foreach ($source->transformation as $key=>$transformation) {
            //TODO: fix, currently only one column, no transformation is supported.
            $ar = array("cid(", ")");                
            $cidsArray[] = str_replace($ar, "", $source->transformation);
            $columnName = $transHandler->decodeTransformationInput($source->transformation, true); // DALUtils::decodeLinkPart($link, $usedColumnNames);
            $columnNamesArray[] = "[" . $columnName . "]";
           // $columnAlias = "column$i";
            $i += 1;

            if (isset($columnAlias))
                $columnNameAndAliasArray[] = "[" . $columnName . "] as '" . $columnAlias . "'";
            else
                $columnNameAndAliasArray[] = "[" . $columnName . "]";

            $columnAliasArray[] = $columnAlias;
    //    }

        $result = new stdClass;
        $result->cids = implode(",", array_values($cidsArray));
        $result->columnNames = implode(",", array_values($columnNamesArray));
        $result->columnNameAndAlias = implode(",", array_values($columnNameAndAliasArray));
        $result->columnAliases = implode(",", array_values($columnAliasArray));

        return $result; 
    }

}

?>