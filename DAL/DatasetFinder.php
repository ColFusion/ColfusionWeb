<?php

require_once '../config.php';

class DatasetFinder {

    private $allDatasetInfo_sql = "select link_id, link_summary, link_title, user_login from colfusion_links links inner join colfusion_users users on links.link_author = users.user_id ";

    // private $allDatasetInfo_sql = "select sinfo.sid, sinfo.title, users.user_login, links.link_summary from colfusion_sourceinfo sinfo inner join colfusion_users users on sinfo.UserId = users.user_id inner join colfusion_links links on sinfo.Sid = links.link_id ";

    public function findDatasetInfoBySidOrName($searchTerm) {
        global $db;
        $dsInfo_sid = $this->findDatasetInfoBySid($searchTerm);
        if ($dsInfo_sid != null) {
            $datasetsInfo["$dsInfo_sid->link_id"] = $dsInfo_sid;
        }

        $dsInfo_name = $this->findDatasetInfoByName($searchTerm);
        foreach ($dsInfo_name as $dsInfo) {
            $datasetsInfo["$dsInfo->link_id"] = $dsInfo;
        }

        return array_values($datasetsInfo);
    }

    public function findDatasetInfoBySid($sid) {
        global $db;
        $sid = mysql_real_escape_string($sid);
        $sql = $this->allDatasetInfo_sql . "where link_id = '$sid'";
        $dsInfo = $db->get_row($sql);
        return $dsInfo;
    }

    public function findDatasetInfoByName($dsName) {
        global $db;
        $dsName = mysql_real_escape_string($dsName);
        $sql = $this->allDatasetInfo_sql . "where link_title like '%$dsName%'";
        $dsInfo = $db->get_results($sql);
        return $dsInfo;
    }

}

?>
