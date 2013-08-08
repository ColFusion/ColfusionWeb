<?php


include_once(realpath(dirname(__FILE__)) . "/FromFileQueryMaker.php");
include_once(realpath(dirname(__FILE__)) . "/FromLinkedServerQueryMaker.php");
include_once(realpath(dirname(__FILE__)) . "/../DALUtils.php");
include_once(realpath(dirname(__FILE__)) . '/../TransformationHandler.php');

class CheckdataMatchingQueryMaker {

    private $from;
    private $to;

    private $fromQuery;
    private $toQuery;

    public function __construct($from, $to) {
        if (count($from->links) != count($to->links)) {
            throw new Exception("Number of links in from and to are not the same.");
        }

        $this->from = $from;
        $this->to = $to;

        $this->fromQuery = $this->prepareOneQuery($this->from);
        $this->toQuery = $this->prepareOneQuery($this->to);
    }

    function prepareOneQuery($source) {

        $columns = $this->GetColumnsFromSource($source);

        if (DALUtils::GetSourceType($source->sid) == "database"){

            return FromLinkedServerQueryMaker::MakeQueryOneTable($source, $columns);
        }
        else {

            return FromFileQueryMaker::MakeQueryToRotateTable($columns);            
        }
    }

    public function MakeOrUpdateFromAndToQuery($forseUpdate = false) {
        if (!isset($this->fromQuery) || $forseUpdate)
            $this->prepareOneQuery($this->from);

        if (!isset($this->toQuery) || $forseUpdate)
            $this->prepareOneQuery($this->to);
    }

    public function getIntersectionQuery($forseUpdate = false) {
        $this->MakeOrUpdateFromAndToQuery($forseUpdate);

        return $this->fromQuery . " intersect " . $this->toQuery;
    }

    public function getNotMachedInFromQuery($forseUpdate = false) {
        $this->MakeOrUpdateFromAndToQuery($forseUpdate);

        return $this->fromQuery . " except " . $this->toQuery;
    }

    public function getNotMachedInToQuery($forseUpdate = false) {
         $this->MakeOrUpdateFromAndToQuery($forseUpdate);

        return $this->toQuery . " except " . $this->fromQuery;
    }

    public function getCountOfMached($forseUpdate = false) {
         $this->MakeOrUpdateFromAndToQuery($forseUpdate);

        return "select count(*) as ct from (" . $this->toQuery . " intersect " . $this->fromQuery . ") as t";
    }

    public function getCountOfTotalDistinct($forseUpdate = false) {
        $this->MakeOrUpdateFromAndToQuery($forseUpdate);

        return "select count(*) as ct from (" . $this->toQuery . " union " . $this->fromQuery . ") as t";
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

        foreach ($source->links as $key=>$link) {
            //TODO: fix, currently only one column, no transformation is supported.
            $ar = array("cid(", ")");                
            $cidsArray[] = str_replace($ar, "", $link);
            $columnName = $transHandler->decodeTransformationInput($link, true); // DALUtils::decodeLinkPart($link, $usedColumnNames);
            $columnNamesArray[] = "[" . $columnName . "]";
           // $columnAlias = "column$i";
            $i += 1;

            if (isset($columnAlias))
                $columnNameAndAliasArray[] = "[" . $columnName . "] as '" . $columnAlias . "'";
            else
                $columnNameAndAliasArray[] = "[" . $columnName . "]";

            $columnAliasArray[] = $columnAlias;
        }

        $result = new stdClass;
        $result->cids = implode(",", array_values($cidsArray));
        $result->columnNames = implode(",", array_values($columnNamesArray));
        $result->columnNameAndAlias = implode(",", array_values($columnNameAndAliasArray));
        $result->columnAliases = implode(",", array_values($columnAliasArray));

        return $result; 
    }

}

?>