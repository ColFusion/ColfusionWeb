<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';

require_once(mnminclude.'html1.php');
require_once(mnminclude.'link.php');

class NotificationDAO {

    private $ezSql;
    private $user;
    public function __construct() {
        global $db, $current_user;;
        $this->ezSql = $db;
        $this->user = $current_user;
    }

    public function getNumberOfUnreadNTF($userId) {
        
        $tableName = mysql_real_escape_string($tableName);
        $allColsSql = "SELECT di.cid, sid, tableName, dname_chosen FROM `colfusion_dnameinfo` di 
            INNER JOIN `colfusion_columnTableInfo` cti ON di.cid = cti.cid 
            WHERE sid = $sid AND tableName = '$tableName'";
        
        foreach($this->ezSql->get_results($allColsSql) as $row){
            $columns[$row->cid] = $row->dname_chosen;
        }
        
        return $columns;
    }

    public function allUserNTF() {
        $links = $this->ezSql->get_results($sql="SELECT C.user_login AS sender, A.ntf_id AS ntf_id, A.action AS action, B.receiver_id AS receiver_id, D.link_title AS target, D.link_id AS target_id
        FROM colfusion_notifications A, colfusion_notifications_unread B, colfusion_users C, colfusion_links D
        WHERE C.user_id = A.sender_id AND A.ntf_id = B.ntf_id AND D.link_id = A.target_id AND B.receiver_id=".$this->user->user_id);
        
        $results = array(
            "receiver" => $this->user->user_login,
            "notifications" => $links,
            );

        return json_encode($results);
    }

    public function getNTFnum() {
        $number = $this->ezSql->get_results($sql="SELECT count(*) AS total FROM colfusion_notifications_unread WHERE receiver_id=".$this->user->user_id);
        return json_encode($number);
    }

    public function removeNTF($ntf_id) {
        $query="DELETE FROM colfusion_notifications_unread WHERE ntf_id=".$ntf_id." AND receiver_id=".$this->user->user_id;
        echo $query;
        $this->ezSql->query($query);
        return "success";
    }
  
}

?>
