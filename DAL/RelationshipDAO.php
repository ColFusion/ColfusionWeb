<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
require_once realpath(dirname(__FILE__)) . '/DatasetFinder.php';
require_once realpath(dirname(__FILE__)) . '/../datasetModel/Relationship.php';
require_once realpath(dirname(__FILE__)) . '/../datasetModel/Link.php';
require_once realpath(dirname(__FILE__)) . '/../datasetModel/Comment.php';

class RelationshipDAO {

    private $ezSql;

    public function __construct() {
        global $db;
        $this->ezSql = $db;
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
        $relationship->createdTime = $relInfo->creation_time;

        $datasetFinder = new DatasetFinder();
        $fromDataset = $datasetFinder->findDatasetInfoBySid($relInfo->sid1);
        $toDataset = $datasetFinder->findDatasetInfoBySid($relInfo->sid2);

        $relationship->fromDataset = $fromDataset;
        $relationship->toDataset = $toDataset;
        $relationship->fromTableName = $relInfo->tableName1;
        $relationship->toTableName = $relInfo->tableName2;

        $linksSql = "select cl_from, cl_to from `colfusion_relationships_columns` where rel_id = '" . mysql_real_escape_string($relId) . "'";
        $linkInfos = $this->ezSql->get_results($linksSql);

        foreach ($linkInfos as $linkInfo) {
            $rawLinkParts[] = $linkInfo->cl_from;
            $rawLinkParts[] = $linkInfo->cl_to;
        }
        $usedColumnNames = $this->getUsedColumnNames($rawLinkParts);

        foreach ($linkInfos as $linkInfo) {
            $link = new Link();
            $link->fromPart = $this->decodeLinkPart($linkInfo->cl_from, $usedColumnNames);
            $link->toPart = $this->decodeLinkPart($linkInfo->cl_to, $usedColumnNames);
            $relationship->links[] = $link;
        }

        return $relationship;
    }

    // Decode cid(xxx) in link parts and return an array of used column names.
    private function getUsedColumnNames(array $linkParts) {
        foreach ($linkParts as $linkPart) {
            preg_match_all('/cid\([0-9]+\)/', $linkPart, $matches);
            foreach ($matches[0] as $match) {
                $encodedCols[$match] = $match;
            }
        }
        $encodedCols = array_keys($encodedCols);

        $sql = "select cid, dname_chosen from `colfusion_dnameinfo` where 1=2";
        foreach ($encodedCols as $encodedCol) {
            $cid = substr($encodedCol, 4, strlen($encodedCol) - 5);
            $sql .= " OR cid=$cid";
        }

        $colNameRows = $this->ezSql->get_results($sql);
        foreach ($colNameRows as $colNameRow) {
            $colNames[$colNameRow->cid] = $colNameRow->dname_chosen;
        }

        return $colNames;
    }

    private function decodeLinkPart($linkPart, $usedColumnNames) {
        preg_match_all('/cid\([0-9]+\)/', $linkPart, $matches);
        foreach ($matches[0] as $match) {
            $cid = substr($match, 4, strlen($match) - 5);
            $linkPart = str_replace("cid($cid)", "$usedColumnNames[$cid]", $linkPart);
        }

        return $linkPart;
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

        $sql = "delete from colfusion_user_relationship_verdict where rel_id = '$relId' and user_id = '$userId'";

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