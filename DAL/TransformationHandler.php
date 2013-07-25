<?php

require_once realpath(dirname(__FILE__)) . '/RelationshipDAO.php';
require_once realpath(dirname(__FILE__)) . '/DatasetDAO.php';

class TransformationHandler {

    private $relationshipDao;
    private $datasetDao;
    private $columnDict;

    public function __construct() {
        $this->relationshipDao = new RelationshipDAO();
        $this->datasetDao = new DatasetDAO();
    }

    // TansInput includes link part and synonym in links.
    public function decodeTransformationInput($transInput, $needOriginal = false) {
        preg_match_all('/cid\([0-9]+\)/', $transInput, $matches);
        foreach ($matches[0] as $match) {
            $cid = substr($match, 4, strlen($match) - 5);
            if (!isset($this->columnDict[$cid])) {
                if ($needOriginal)
                    $this->columnDict[$cid] = $this->relationshipDao->getColumnInfo($cid)->dname_original_name;
                else
                    $this->columnDict[$cid] = $this->relationshipDao->getColumnInfo($cid)->dname_chosen;
            }

            $transInput = str_replace("cid($cid)", $this->columnDict[$cid], $transInput);
        }
        
        return $transInput;
    }

    public function encodeTransformationInput($sid, $tableName, $transInput) {
        $tableColumnDict = $this->datasetDao->getTableColumns($sid, $tableName);
        foreach($tableColumnDict as $cid => $columnName){
            $transInput = str_replace ($columnName, "cid($cid)", $transInput);
        }
        
        return $transInput;
    }
}

?>
