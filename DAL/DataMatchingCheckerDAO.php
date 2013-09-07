<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/TransformationHandler.php';
require_once realpath(dirname(__FILE__)) . '/../Exceptions/SynonymExistedException.php';
require_once realpath(dirname(__FILE__)) . '/../Exceptions/ValueNotFoundException.php';

class DataMatchingCheckerDAO {

    const SynFromTable = "colfusion_synonyms_from";
    const SynToTable = "colfusion_synonyms_to";

    //status values for relationships columns caching execution info
    
    const RelColCachExecInfoSt_Success = "success";
    const RelColCachExecInfoSt_Failure = "failure";
    const RelColCachExecInfoSt_InProgress = "in progress";
    
    //--------------------------------------------------------------

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
        
        // A mapping has an synId stored in both SynFromTable and SynToTable.
        $synId = $this->getNewSynonymId();
        $this->insertSynonymValues($synId, $fromSid, $fromTableName, $fromTransInput, $fromValue, $userId, DataMatchingCheckerDAO::SynFromTable);
        $this->insertSynonymValues($synId, $toSid, $toTableName, $toTransInput, $toValue, $userId, DataMatchingCheckerDAO::SynToTable);
    }
    
    public function getLinkSynonyms($fromSid, $fromTableName, $fromTransInput, $toSid, $toTableName, $toTransInput){
        $query = "SELECT f.syn_id, f.userId, f.sid as fromSid, f.tableName as fromTableName, f.value as fromValue, 
        t.sid as toSid, t.tableName as toTableName, t.value as toValue 
        FROM colfusion_synonyms_from f INNER JOIN colfusion_synonyms_to t ON f.syn_id=t.syn_id;";
        
        return $this->ezSql->get_results($query);
    }
    
    public function deleteSynonym($synId, $userId){
        $this->deleteSynonymFromOneTable($synId, $userId, DataMatchingCheckerDAO::SynFromTable);
        $this->deleteSynonymFromOneTable($synId, $userId, DataMatchingCheckerDAO::SynToTable);
    }
    
    private function deleteSynonymFromOneTable($synId, $userId, $tableName){
        $query = "DELETE FROM $tableName WHERE syn_id=$synId and userId = $userId;";
        $this->ezSql->query($query);
    }

    //FIXME: in sql colfusion_ is prefix which can be set to different value. So here in sql we need to first get table prefix, which is set in config.php file.
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


    public function getRelationshipColumnCachingExecutionInfo($transformation)
    {
        $sql = "select * from colfusion_relationships_columns_cachingExecutionInfo where transformation = '$transformation'";
        return $this->ezSql->get_row($sql);
    }

    public function setStartedRelationshipColumnCaching($transformation)
    {
        $sql = "insert into colfusion_relationships_columns_cachingExecutionInfo (transformation, status, timeStart) values ('$transformation', '" . DataMatchingCheckerDAO::RelColCachExecInfoSt_InProgress ."', CURRENT_TIMESTAMP) 
        on duplicate key update status = '" . DataMatchingCheckerDAO::RelColCachExecInfoSt_InProgress . "', timeStart = CURRENT_TIMESTAMP;";
       
        $this->ezSql->query($sql);
    }

    public function setSuccessRelationshipColumnCaching($transformation)
    {
        $sql = "update colfusion_relationships_columns_cachingExecutionInfo set status = '" . DataMatchingCheckerDAO::RelColCachExecInfoSt_Success . "', timeEnd = CURRENT_TIMESTAMP, errorMessage = '' 
        where transformation = '$transformation';";
       
        $this->ezSql->query($sql);
    }

    public function setFailureRelationshipColumnCaching($transformation, $errorMessage)
    {
        $errorMessage = mysql_real_escape_string($errorMessage);

        $sql = "update colfusion_relationships_columns_cachingExecutionInfo set status = '" . DataMatchingCheckerDAO::RelColCachExecInfoSt_Failure . "', timeEnd = CURRENT_TIMESTAMP, errorMessage = '$errorMessage'  
        where transformation = '$transformation';";
       
        $this->ezSql->query($sql);
    }

    public function setQueryRelationshipColumnCaching($transformation, $query)
    {
        $query = mysql_real_escape_string($query);

        $sql = "update colfusion_relationships_columns_cachingExecutionInfo set query = '$query' where transformation = '$transformation';";
       
        $this->ezSql->query($sql);
    }

    public function storeDataMatchingRatios($transformationFrom, $dataMatchingFromRatio, $transformationTo, $dataMatchingToRatio)
    {

      //  var_dump($transformationFrom, $dataMatchingFromRatio, $transformationTo, $dataMatchingToRatio);

        $sql = "update colfusion_relationships_columns set dataMatchingFromRatio = $dataMatchingFromRatio, dataMatchingToRatio = $dataMatchingToRatio 
                where cl_from = '$transformationFrom' and cl_to = '$transformationTo'";

        $this->ezSql->query($sql);
    }
}

?>
