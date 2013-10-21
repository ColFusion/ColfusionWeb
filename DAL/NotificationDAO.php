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

    // get unread notifications from notification_unread
    public function allUserNTF() {
        $links = $this->ezSql->get_results($sql="SELECT C.user_login AS sender, A.ntf_id AS ntf_id, A.action AS action, B.receiver_id AS receiver_id, D.link_title AS target, D.link_id AS target_id
        FROM colfusion_notifications A, colfusion_notifications_unread B, colfusion_users C, colfusion_links D
        WHERE C.user_id = A.sender_id AND A.ntf_id = B.ntf_id AND D.link_id = A.target_id AND B.receiver_id=".$this->user->user_id." AND A.sender_id !=".$this->user->user_id);
        
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

    //see every notification
    public function seeAll() {
        $links = $this->ezSql->get_results($sql="SELECT user_login AS sender, action AS action, link_title AS target, N.target_id AS target_id FROM colfusion_notifications N, colfusion_saved_links S, colfusion_users U, colfusion_links L 
            WHERE N.sender_id = U.user_id AND N.target_id = S.saved_link_id AND S.saved_link_id = L.link_id AND S.saved_user_id=".$this->user->user_id." AND N.sender_id !=".$this->user->user_id." UNION (SELECT U.user_login AS sender, 
                N.action AS action, L.link_title AS target, N.target_id AS target_id FROM colfusion_notifications N, colfusion_users U, colfusion_links L WHERE N.sender_id = U.user_id AND N.target_id = L.link_id AND L.link_author = ".$this->user->user_id.")");
        // 1st part is ntfs to user's saved datasets
        // union part is ntfs to user's published datasets
        $results = array(
            "receiver" => $this->user->user_login,
            "notifications" => $links,
            );

        return json_encode($results);
    }

    public function addNTFtoDB($relID, $do) {
        switch ($do) {
            case 'addComment':
                $userAction = "added a commment on";
                break;
            case 'updateComment':
                $userAction = "updated previous commment on";
                break;
            case 'removeComment':
                $userAction = "removed commment from";
                break;   
            default:
                # code...
                break;
        }
         
        $query = "INSERT INTO `colfusion`.`colfusion_notifications` (`sender_id`, `target_id`, `action`) SELECT '".$this->user->user_id."',sid2,'".$userAction."' FROM colfusion_relationships WHERE rel_id=".$relID;
        $this->ezSql->query($query);
        $this->addUnreadNTFs($relID);
        return;
    }

    public function addUnreadNTFs($relID){
        $query = "INSERT INTO  `colfusion`.`colfusion_notifications_unread` (`ntf_id` ,`receiver_id`) SELECT ntf_id, L.saved_user_id
                    FROM colfusion_saved_links L, colfusion_notifications N
                    WHERE L.saved_link_id = N.target_id
                    AND L.saved_user_id !=".$this->user->user_id."
                    AND ntf_id = ( 
                    SELECT MAX( ntf_id ) 
                    FROM colfusion_notifications )";
        $this->ezSql->query($query);
        
        $query = "INSERT INTO  `colfusion`.`colfusion_notifications_unread` (`ntf_id` ,`receiver_id`) SELECT MAX(ntf_id), link_author 
                    FROM colfusion_notifications N, colfusion_links L
                    WHERE L.link_id = (SELECT sid2 FROM colfusion_relationships WHERE rel_id = ".$relID.")";
        $this->ezSql->query($query);
    }
  
}

?>
