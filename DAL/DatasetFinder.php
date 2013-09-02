<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';
include_once (realpath(dirname(__FILE__)) . '/../datasetModel/Dataset.php');

class DatasetFinder {
    
    // Dataset can be 'draft' if not submitted.
    // DatasetFinder only queries datasets with status 'queued' (submitted).
    private $allDatasetInfo_sql = "select
        sid, title, entryDate, lastUpdated, userId, user_login , link_content as description
        from colfusion_sourceinfo sinfo
        inner join colfusion_users users on sinfo.UserId = users.user_id
        left join colfusion_links cl on cl.link_id = sid 
        where  Status = 'queued'";
    
    private $ezSql;

    public function __construct() {
        global $db;
        $this->ezSql = $db;
    }

    public function findDatasetInfoByUserId($userId){
        $userId = mysql_real_escape_string($userId);
        $sql = $this->allDatasetInfo_sql . " and UserId = '$userId'";
        $dsInfos = $this->ezSql->get_results($sql);
        foreach ($dsInfos as $dsInfo) {
            $datasets[] = $this->mapDbColumnsToDataset($dsInfo);
        }
        return $datasets;
    }

    public function findDatasetInfoBySidOrName($searchTerm) {
        $dataset_sid = $this->findDatasetInfoBySid($searchTerm);
        if ($dataset_sid != null) {
            $datasetsInfo["$dataset_sid->sid"] = $dataset_sid;
        }

        $dataset_name = $this->findDatasetInfoByName($searchTerm);
        foreach ($dataset_name as $dataset) {
            $datasetsInfo["$dataset->sid"] = $dataset;
        }

        return array_values($datasetsInfo);
    }

    public function findDatasetInfoBySid($sid, $includeDraft = false) {
        $sid = mysql_real_escape_string($sid);

        $sql = $this->allDatasetInfo_sql . " and sid = '$sid'";

        if ($includeDraft)
            $sql = str_replace("Status = 'queued'", "(Status = 'queued' or Status = 'draft')", $sql);

        $dsInfo = $this->ezSql->get_row($sql);
        return $this->mapDbColumnsToDataset($dsInfo);
    }

    public function findDatasetInfoByName($dsName) {
        $dsName = mysql_real_escape_string($dsName);
        $sql = $this->allDatasetInfo_sql . " and title like '%$dsName%'";
        $dsInfos = $this->ezSql->get_results($sql);
        foreach ($dsInfos as $dsInfo) {
            $datasets[] = $this->mapDbColumnsToDataset($dsInfo);
        }
        return $datasets;
    }

    private function mapDbColumnsToDataset($dsInfo) {
        if ($dsInfo == null) {
            return null;
        }

        $dataset = new Dataset();

        $dataset->sid = $dsInfo->sid;
        $dataset->title = $dsInfo->title;
        $dataset->description = $dsInfo->description;
        $dataset->userId = $dsInfo->userId;
        $dataset->userName = $dsInfo->user_login;
        $dataset->entryDate = $dsInfo->entryDate;
        $dataset->lastUpdated = $dsInfo->lastUpdated;

        return $dataset;
    }

}

?>
