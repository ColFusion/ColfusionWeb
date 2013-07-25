<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/TransformationHandler.php';

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
        $synId = $this->getNewSynonymId();
        $this->insertSynonymValues($synId, $fromSid, $fromTableName, $fromTransInput, $fromValue, $userId, DataMatchingCheckerDAO::SynFromTable);
        $this->insertSynonymValues($synId, $toSid, $toTableName, $toTransInput, $toValue, $userId, DataMatchingCheckerDAO::SynToTable);
    }

    private function getNewSynonymId() {
        $sql = "select syn_id from colfusion_synonyms_from order by syn_id desc limit 1";
        $objSynId = $this->ezSql->get_row($sql);
        return $objSynId == null ? 0 : $objSynId->syn_id + 1;
    }

    private function insertSynonymValues($synId, $sid, $tableName, $transInput, $value, $userId, $synTable) {
        $transInput = mysql_real_escape_string($this->transformationHandler->encodeTransformationInput($sid, $tableName, $transInput));
        $value = mysql_real_escape_string($value);
        $sql = "insert into $synTable(syn_id, userId, sid, tableName, transinput, value) values($synId, $userId, $sid, '$tableName', '$transInput', '$value')";
        $this->ezSql->query($sql);
    }

}

?>
