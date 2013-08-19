<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/TransformationHandler.php';
require_once realpath(dirname(__FILE__)) . '/../Exceptions/SynonymExistedException.php';
require_once realpath(dirname(__FILE__)) . '/../Exceptions/ValueNotFoundException.php';

class DataMatchingCheckerDAO {

    const SynFromTable = "colfusion_synonyms_from";
    const SynToTable = "colfusion_synonyms_to";

    private $ezSql;
    private $transformationHandler;

    public function __construct() {
        global $db;
        $this->ezSql = $db;
        $this->transformationHandler = new TransformationHandler();
    }

    public function storeSynonym($fromSid, $fromTableName, $fromTransInput, $fromValue, $toSid, $toTableName, $toTransInput, $toValue, $userId) {
        if ($this->isMappingExisted($userId, $fromSid, $fromTableName, $fromTransInput, $fromValue, $toSid, $toTableName, $toTransInput, $toValue)) {
            throw new SynonymExistedException("You have already defined this mapping");
        }

        $synId = $this->getNewSynonymId();
        $this->insertSynonymValues($synId, $fromSid, $fromTableName, $fromTransInput, $fromValue, $userId, DataMatchingCheckerDAO::SynFromTable);
        $this->insertSynonymValues($synId, $toSid, $toTableName, $toTransInput, $toValue, $userId, DataMatchingCheckerDAO::SynToTable);
    }

    private function getNewSynonymId() {
        $sql = "select syn_id from colfusion_synonyms_from order by syn_id desc limit 1";
        $objSynId = $this->ezSql->get_row($sql);
        return $objSynId == null ? 0 : $objSynId->syn_id + 1;
    }

    private function isMappingExisted($userId, $fromSid, $fromTableName, $fromTransInput, $fromValue, $toSid, $toTableName, $toTransInput, $toValue) {
        $fromMappings = $this->getSynonymValues($fromSid, $fromTableName, $fromTransInput, $fromValue, $userId, DataMatchingCheckerDAO::SynFromTable);
        $toMappings = $this->getSynonymValues($toSid, $toTableName, $toTransInput, $toValue, $userId, DataMatchingCheckerDAO::SynToTable);

        if (!isset($fromMappings) || !isset($toMappings))
                return false;

        foreach ($fromMappings as $fromMapping) {
            $fromSynIds[] = $fromMapping->syn_Id;
        }
        
        foreach ($toMappings as $toMapping) {
            $toSynIds[] = $toMapping->syn_Id;
        }
        
        $intersect = array_intersect($fromSynIds, $toSynIds);
        if (count($intersect) != 0) {
            return true;
        }

        return false;
    }

    private function getSynonymValues($sid, $tableName, $transInput, $value, $userId, $synTable) {
        $transInput = mysql_real_escape_string($this->transformationHandler->encodeTransformationInput($sid, $tableName, $transInput));
        $value = mysql_real_escape_string($value);
        $sql = "select * from $synTable where sid=$sid and tableName='$tableName' and transInput='$transInput' and `value`='$value' and userId=$userId";
        return $this->ezSql->get_results($sql);
    }

    private function insertSynonymValues($synId, $sid, $tableName, $transInput, $value, $userId, $synTable) {
        $transInput = mysql_real_escape_string($this->transformationHandler->encodeTransformationInput($sid, $tableName, $transInput));
        $value = mysql_real_escape_string($value);
        $sql = "insert into $synTable(syn_id, userId, sid, tableName, transinput, value) values($synId, $userId, $sid, '$tableName', '$transInput', '$value')";
        $this->ezSql->query($sql);
    }

    public function getSynonymnsByCids($cid1, $cid2) {
        $query = "SELECT syn_from.transInput as linkFrom, syn_from.value as valueFrom, syn_to.transInput as linkTo, syn_to.value as valueTo
FROM  `colfusion_synonyms_from` syn_from,  `colfusion_synonyms_to` syn_to
WHERE syn_from.syn_id = syn_to.syn_id 
AND ((syn_from.transInput = '$cid1' AND syn_to.transInput = '$cid2') OR (syn_from.transInput = '$cid2' AND syn_to.transInput = '$cid1'))";

        return $this->ezSql->get_results($query);

    }

}

?>
