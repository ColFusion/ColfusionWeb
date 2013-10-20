<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/DatasetFinder.php';
require_once realpath(dirname(__FILE__)) . '/../datasetModel/Relationship.php';
require_once realpath(dirname(__FILE__)) . '/../datasetModel/ColfusionLink.php';
require_once realpath(dirname(__FILE__)) . '/../datasetModel/Comment.php';
require_once realpath(dirname(__FILE__)) . '/TransformationHandler.php';

class RelationshipDAO 
{

    private $ezSql;

    public function __construct() {
        global $db;
        $this->ezSql = $db;
    }

     /**
     * Adds colfusion relationship between two stories. 
     * @param [type] $user_id     id of the user who adds new relationships.
     * @param [type] $name        name of the relationship.
     * @param [type] $description short textual description for new relationship.
     * @param [type] $from        object containing info about From dataset sid and columns of the relationships from From dataset. TODO: create a class for that object.
     * @param [type] $to          object containing info about To dataset sid and columns of the relationships from To dataset. TODO: the class class as for From should be used.
     * @param [type] $confidence  confidence value for the relationship.
     * @param [type] $comment     shor textual comment for the relationship.
     *
     * @return [type] id of newly added relationship.
     */
    public function addRelationship($user_id, $name, $description, $from, $to, $confidence, $comment)
    {
        $sql = "INSERT INTO %srelationships (name, description, creator, creation_time, sid1, sid2, tableName1, tableName2) VALUES ('%s', '%s', %d, CURRENT_TIMESTAMP, %d, %d, '%s', '%s')";
        $sql = sprintf($sql, table_prefix, $name, $description, $user_id, $from["sid"], $to["sid"], $from["tableName"], $to["tableName"]);
        $rs = $this->ezSql->query($sql);

        $rel_id = mysql_insert_id();

        $numberOfLinks = count($from["columns"]);

        for ($i = 0; $i < $numberOfLinks; $i++) {
            $sql = "INSERT INTO %srelationships_columns (rel_id, cl_from, cl_to) VALUES (%d, '%s', '%s')";

            $fromCol = mysql_real_escape_string($from["columns"][$i]);
            $toCol = mysql_real_escape_string($to["columns"][$i]);

            $sql = sprintf($sql, table_prefix, $rel_id, $fromCol, $toCol);
            $rs = $this->ezSql->query($sql);
        }

        $sql = "INSERT INTO %suser_relationship_verdict (rel_id, user_id, confidence, comment, `when`) VALUES (%d, %d, %f, '%s', CURRENT_TIMESTAMP)";
        $sql = sprintf($sql, table_prefix, $rel_id, $user_id, $confidence, $comment);
        $rs = $this->ezSql->query($sql);

        return $rel_id;
    }

    public function getRelationship($relId) {
        $sql = "SELECT name, description, user_id, user_login, sid1, sid2, tableName1, tableName2, creation_time 
            FROM  `colfusion_relationships` CR INNER JOIN  `colfusion_users` U ON CR.creator = U.user_id 
            WHERE CR.rel_id = '" . mysql_real_escape_string($relId) . "'";

        $relInfo = $this->ezSql->get_row($sql);
        if ($relInfo == null) {
            throw new Exception('Relationship Not Found');
        }

        $relationship = new Relationship();
        $relationship->rid = $relId;
        $relationship->name = $relInfo->name;
        $relationship->description = $relInfo->description;
        $relationship->creator = $relInfo->user_login;
        $relationship->creatorId = $relInfo->user_id;
        $relationship->createdTime = $relInfo->creation_time;

        $datasetFinder = new DatasetFinder();
        $fromDataset = $datasetFinder->findDatasetInfoBySid($relInfo->sid1, true);
        $toDataset = $datasetFinder->findDatasetInfoBySid($relInfo->sid2, true);

        $relationship->fromDataset = $fromDataset;
        $relationship->toDataset = $toDataset;
        $relationship->fromTableName = $relInfo->tableName1;
        $relationship->toTableName = $relInfo->tableName2;
        
        // $relationship->links[] = $this->GetLinksByRelId($relId);
        $relationship->links = $this->GetLinksByRelId($relId);

        return $relationship;
    }

    public function GetLinksByRelId($relId) {
        $links = array();

        $linksSql = "select cl_from, cl_to from `colfusion_relationships_columns` where rel_id = '" . mysql_real_escape_string($relId) . "'";
        $linkInfos = $this->ezSql->get_results($linksSql);
        
        $linkRatioSql = "select cl_from, cl_to, dataMatchingFromRatio, dataMatchingToRatio from colfusion_relationships_columns where rel_id = $relId";
        $linkRatios = $this->ezSql->get_results($linkRatioSql);
        $linkRatioValues = array();
        
        foreach($linkRatios as $linkRatio){
            $linkRatioValues["{$linkRatio->cl_from}_{$linkRatio->cl_to}"]['fromRatio'] = $linkRatio->dataMatchingFromRatio;
            $linkRatioValues["{$linkRatio->cl_from}_{$linkRatio->cl_to}"]['toRatio'] = $linkRatio->dataMatchingToRatio;
        }
     
        $transHandler = new TransformationHandler();
        foreach ($linkInfos as $linkInfo) {
            $link = new ColfusionLink();
            $link->fromPart = $transHandler->decodeTransformationInput($linkInfo->cl_from, true);
            $link->toPart = $transHandler->decodeTransformationInput($linkInfo->cl_to, true);

            $link->fromPartEncoded = $linkInfo->cl_from;
            $link->toPartEncoded = $linkInfo->cl_to;
            
            $link->fromRatio = $linkRatioValues["{$link->fromPartEncoded}_{$link->toPartEncoded}"]['fromRatio'];
            $link->toRatio = $linkRatioValues["{$link->fromPartEncoded}_{$link->toPartEncoded}"]['toRatio'];
                          
            $links[] = $link;
        }

        return $links;
    }

    public function deleteRelationship($relId, $userId) {
        
        // Check if deleter is creator.
        $sql = "select rel_id from colfusion_relationships where creator = '$userId'";
        $matchCreatorResult = $this->ezSql->get_results($sql);    
        if(!$matchCreatorResult){
            throw new Exception("You are not able to delete this relationship.");
        }
        
        $delSql = "update colfusion_relationships set status = 1 where creator = '$userId' and rel_id='$relId'";
        $this->ezSql->query($delSql);
    }

    public function getColumnInfo($cid){
        $sql = "select * from `colfusion_dnameinfo` where cid = $cid";   
        return $this->ezSql->get_row($sql);       
    }
      
    public function getComments($relId) {
        $sql = "SELECT confidence, comment, `when`, user_login, user_email, URV.user_id, rel_id 
            FROM  `colfusion_user_relationship_verdict` URV INNER JOIN  `colfusion_users` U ON URV.user_id = U.user_id 
            WHERE URV.rel_id = '" . mysql_real_escape_string($relId) . "'";

        $commentInfos = $this->ezSql->get_results($sql);

        foreach ($commentInfos as $commentInfo) {
            $comments[] = $this->mapDbCommentRowToComment($commentInfo);
        }

        return $comments;
    }

    public function getComment($relId, $userId) {
        $relId = mysql_real_escape_string($relId);
        $userId = mysql_real_escape_string($userId);

        $sql = "SELECT confidence, comment, `when`, user_email, user_login, URV.user_id, rel_id 
            FROM  `colfusion_user_relationship_verdict` URV INNER JOIN  `colfusion_users` U ON URV.user_id = U.user_id 
            WHERE URV.rel_id = '$relId' and URV.user_id = '$userId'";

        $commentInfo = $this->ezSql->get_row($sql);
        return $this->mapDbCommentRowToComment($commentInfo);
    }

    public function addComment($relId, $userId, $confidence, $comment) {
        $relId = mysql_real_escape_string($relId);
        $userId = mysql_real_escape_string($userId);
        $confidence = mysql_real_escape_string($confidence);
        $comment = mysql_real_escape_string($comment);

        $sql = "insert into colfusion_user_relationship_verdict(rel_id, user_id, confidence, comment, `when`) 
            values('$relId', '$userId', '$confidence', '$comment', NOW())";

        return $this->ezSql->query($sql);
    }

    public function removeComment($relId, $userId) {
        $relId = mysql_real_escape_string($relId);
        $userId = mysql_real_escape_string($userId);

        $sql = "delete from colfusion_user_relationship_verdict where rel_id = $relId and user_id = $userId";
        return $this->ezSql->query($sql);
    }

    public function updateComment($relId, $userId, $confidence, $comment) {

        $relId = mysql_real_escape_string($relId);
        $userId = mysql_real_escape_string($userId);
        $confidence = mysql_real_escape_string($confidence);
        $comment = mysql_real_escape_string($comment);

        $sql = "update colfusion_user_relationship_verdict 
            set confidence = '$confidence', comment = '$comment' 
            where rel_id = '$relId' and user_id = '$userId'";

        return $this->ezSql->query($sql);
    }

    private function mapDbCommentRowToComment($dbCommentRow) {
        $comment = new Comment();
        $comment->rid = $dbCommentRow->rel_id;
        $comment->userId = $dbCommentRow->user_id;
        $comment->userName = $dbCommentRow->user_login;
        $comment->userEmail = $dbCommentRow->user_email;
        $comment->comment = $dbCommentRow->comment;
        $comment->commentTime = $dbCommentRow->when;
        $comment->confidence = $dbCommentRow->confidence;
        return $comment;
    }

    public function getRelIdsForSid($sid) {
        $sid = mysql_real_escape_string($sid);

        $query = "SELECT distinct rel_id 
            FROM  `colfusion_relationships`  
            WHERE  sid1 = $sid or sid2 = $sid";

        $queryResult =  $this->ezSql->get_results($query);

        $result = array();
        
        if($queryResult != null){
            foreach ($queryResult as $key => $rel) {
                $result[] = $rel->rel_id;
            }
        }

        return $result;
    }

    /**
     * Return average confidence of the relationship by given relationship id
     * @param  int $rel_id id of the relationship
     * @return float         average confidcen value
     */
    public function getRelationshipAverageConfidenceByRelId($rel_id) {
        $rel_id = mysql_real_escape_string($rel_id);
        

        $sql = "select avg(confidence) as avgconf 
            from colfusion_user_relationship_verdict 
            where rel_id = $rel_id";

        return $this->ezSql->get_row($sql)->avgconf;
    }

    public function getRelationshipAverageDataMatchingRatios($rel_id)
    {
        $rel_id = mysql_real_escape_string($rel_id);
        

        $sql = "select avg(dataMatchingFromRatio) as avgFrom, avg(dataMatchingToRatio) as avgTo
            from colfusion_relationships_columns 
            where rel_id = $rel_id";

        return $this->ezSql->get_row($sql);
    }

    /**
     * Mine new relationships for given sid.
     * @param  [type] $sid sid of the story for which need to do mining of new relationshipsю
     * @return [type]      array of rel_id which were added.
     */
    public function mineRelationships($sid)
    {
        // relationships which existed before mining for given sid.
        $relsForCurrentSidBeforeMining = $this->getRelIdsForSid($sid);
        if (!isset($relsForCurrentSidBeforeMining))
            $relsForCurrentSidBeforeMining = array ();

        //do the mining TODO: this might take long time, think about execution in background.
        $res = $this->ezSql->query("call doRelationshipMining('" . $sid . "')");

        // get all realtionships for given sid including existed before mining and just mined.
        $relsForCurrentSidAfterMining = $this->getRelIdsForSid($sid);
        if (!isset($relsForCurrentSidAfterMining))
            $relsForCurrentSidAfterMining = array ();

        // find relationships which were just added by mining.
        $diff = array_diff($relsForCurrentSidAfterMining, $relsForCurrentSidBeforeMining);

        return $diff;
    }

    /**
     * [getAllRelationshipInfoBySid description]
     * @param  [type] $sid [description]
     * @return [type]      [description]
     */
    public function getAllRelationshipInfoBySid($sid)
    {
        $query = <<< EOQ
                SELECT rel.rel_id, rel.name, rel.description, rel.creator, rel.creation_time as creationTime, u. user_login as creatorLogin,
       siFrom.sid as sidFrom, siTo.sid as sidTo,
       siFrom.Title as titleFrom, siTo.Title as titleTo,
       rel.tableName1 as tableNameFrom, rel.tableName2 as tableNameTo,
       statOnVerdicts.numberOfVerdicts, statOnVerdicts.numberOfApproved, statOnVerdicts.numberOfReject,
       statOnVerdicts.numberOfNotSure, statOnVerdicts.avgConfidence

FROM
    colfusion_relationships as rel,
    colfusion_users as u,
    colfusion_sourceinfo as siFrom,
    colfusion_sourceinfo as siTo,
    statOnVerdicts

where
        rel.creator = u.user_id
        and rel.status = 0
        and rel.rel_id = statOnVerdicts.rel_id
        and rel.sid1 = siFrom.Sid
        and rel.sid2 = siTo.Sid
        and (rel.sid1 = $sid or rel.sid2 = $sid)
EOQ;

        $res = $this->ezSql->get_results($query);

        return $res;
    }

    public function getRelIdByTransformations($from, $to)
    {
        $query = "select rel_id from colfusion_relationships_columns where cl_from = '$from' and cl_to = '$to' limit 1";

//var_dump($query);

        //TODO: check here there is only one rel_id, other wire it might be problem.
        
        return  $this->ezSql->get_row($query);
    }
}

function testRelDAO() {
    $datasetFinder = new DatasetFinder();
    //var_dump($datasetFinder->findDatasetInfoBySid(1495));
    //var_dump($datasetFinder->findDatasetInfoBySid(1487));

    $relDAO = new RelationshipDAO();
    var_dump($relDAO->getRelationship(752));
    //var_dump($relDAO->getComments(1454));
    //var_dump($relDAO->getComment(1462, 20));
    //var_dump($relDAO->updateComment(1462, 20, 0.7, 'Test update'));
}

?>
