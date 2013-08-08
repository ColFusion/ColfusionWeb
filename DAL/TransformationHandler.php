<?php

require_once realpath(dirname(__FILE__)) . '/RelationshipDAO.php';
require_once realpath(dirname(__FILE__)) . '/DatasetDAO.php';

class TransformationHandler {

    private $relationshipDao;
    private $datasetDao;
    private $columnDict;
    private $columnPrefixDict;

    public function __construct() {
        $this->relationshipDao = new RelationshipDAO();
        $this->datasetDao = new DatasetDAO();
    }

    // TansInput includes link part and synonym in links.
    //TODO: needOrigianl never used, probably this method by itself should assess if we need origianl name or chosen, depending on the source type of the column
    public function decodeTransformationInput($transInput, $needOriginal = false) {
        if (!isset($transInput))
            return $transInput;

        $cids = $this->getCidsFromTransInput($transInput);

        return $this->decodeTransformationInputBase($transInput, $cids, $needOriginal, null, false);
    }

    // TansInput includes link part and synonym in links.
    //TODO: needOrigianl never used, probably this method by itself should assess if we need origianl name or chosen, depending on the source type of the column
    public function decodeTransformationInputWithPrefix($transInput, $prefixStringArr) {
        if (!isset($transInput))
            return $transInput;

        $cids = $this->getCidsFromTransInput($transInput);

        foreach ($cids as $key => $cid) {
            if (!isset($this->columnPrefixDict[$cid]))  {
                $this->columnPrefixDict[$cid] = $this->getColumnPrefixByCid($cid, $prefixStringArr);                   
            }
        }

        return  $this->decodeTransformationInputBase($transInput, $cids, $needOriginal, $this->columnPrefixDict, true);
    }

    public function getColumnPrefixByCid($cid, $prefixStringArr) {
        $result = "";

    //    var_dump($cid);
    //    var_dump($prefixStringArr);

        foreach ($prefixStringArr as $key => $prefixName) {
            switch ($prefixName) {
                case 'tableName':
                    $result .= $this->datasetDao->getTableNameByCid($cid);
                    break;
                
                case 'sid':
                    $result .= $this->datasetDao->getSidByCid($cid);
                    break;

                default:
                    throw new Exception("Error Processing Request. Prefix name is unknown", 1);
                    
                    break;
            }
        }   

        return $result;
    }

    // TansInput includes link part and synonym in links.
    //TODO: needOrigianl never used, probably this method by itself should assess if we need origianl name or chosen, depending on the source type of the column
    private function decodeTransformationInputBase($transInput, $cids, $needOriginal = false, $columnPrefixDict = null, $needToEnclose = false) {
        foreach ($cids as $key => $cid) {
            if (!isset($this->columnDict[$cid])) {
                if ($needOriginal && $this->isFromDatabase($cid))
                    $this->columnDict[$cid] = $this->relationshipDao->getColumnInfo($cid)->dname_original_name;
                else
                    $this->columnDict[$cid] = $this->relationshipDao->getColumnInfo($cid)->dname_chosen;
            }

            if (isset($columnPrefixDict) && isset($columnPrefixDict[$cid])) {
                if ($needToEnclose) {
                    $transInput = str_replace("cid($cid)", "[{$columnPrefixDict[$cid]}].[{$this->columnDict[$cid]}]", $transInput);
                }
                else {
                    $transInput = str_replace("cid($cid)", "{$columnPrefixDict[$cid]}.{$this->columnDict[$cid]}", $transInput);
                }
                
            }
            else {
                if ($needToEnclose) {
                    $transInput = str_replace("cid($cid)", "[{$this->columnDict[$cid]}]", $transInput);
                }
                else {
                    $transInput = str_replace("cid($cid)", "{$this->columnDict[$cid]}", $transInput);
                }
                
            }
        }
        
        return $transInput;
    }

    private function isFromDatabase($cid) {
        $source = $this->datasetDao->GetColumnsSourceInfo($cid);

        if ($source->source_type === database)
            return true;
        else
            return false;
    }

    private function getCidsFromTransInput($transInput) {
        $result = array();

        preg_match_all('/cid\([0-9]+\)/', $transInput, $matches);
        foreach ($matches[0] as $match) {
            $cid = substr($match, 4, strlen($match) - 5);
            $result[] = $cid;
        }

        return $result;
    }

    public function encodeTransformationInput($sid, $tableName, $transInput) {
        $tableColumnDict = $this->datasetDao->getTableColumns($sid, $tableName);
        foreach($tableColumnDict as $cid => $columnName){
            $transInput = str_replace ($columnName, "cid($cid)", $transInput);
        }
        
        return $transInput;
    }
    
    public function getWrappedCids($decodedInput){
        preg_match_all('/cid\([0-9]+\)/', $decodedInput, $matches);
        foreach ($matches[0] as $match) {
            $wrappedCids[] = $match;
        }
        
        return $wrappedCids;
    }
}

?>
