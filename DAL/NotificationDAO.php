<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';

require_once(mnminclude.'html1.php');
require_once(mnminclude.'link.php');

class NotificationDAO {

    private $ezSql;
    private $user;
    public function __construct() {
        global $db, $current_user;
        $this->ezSql = $db;
        $this->user = $current_user;
    }

    // get unread notifications from notification_unread
    public function allUserNTF() {
        $links = $this->ezSql->get_results($sql="SELECT C.user_login AS sender, A.ntf_id AS ntf_id, A.action AS action, B.receiver_id AS receiver_id, D.link_title AS target, D.link_id AS target_id
        FROM colfusion_notifications A, colfusion_notifications_unread B, colfusion_users C, colfusion_links D
        WHERE C.user_id = A.sender_id AND A.ntf_id = B.ntf_id AND D.link_id = A.target_id AND B.receiver_id=".$this->user->user_id." AND A.sender_id !=".$this->user->user_id."
        union
        SELECT C.user_login AS sender, A.ntf_id AS ntf_id, A.action AS action, B.receiver_id AS receiver_id, 'not a title', '0' AS target_id
        FROM colfusion_notifications A, colfusion_notifications_unread B, colfusion_users C,colfusion_friends WHERE C.user_id = A.sender_id AND A.ntf_id = B.ntf_id AND B.receiver_id=".$this->user->user_id." AND A.sender_id !=".$this->user->user_id."
        ");
        
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
        $links = $this->ezSql->get_results($sql="SELECT user_login AS sender, action AS action, link_title AS target, N.target_id AS target_id, N.datetime AS datetime FROM colfusion_notifications N, colfusion_saved_links S, colfusion_users U, colfusion_links L 
            WHERE N.sender_id = U.user_id AND N.target_id = S.saved_link_id AND S.saved_link_id = L.link_id AND S.saved_user_id=".$this->user->user_id." AND N.sender_id !=".$this->user->user_id." UNION (SELECT U.user_login AS sender, 
                N.action AS action, L.link_title AS target, N.target_id AS target_id, N.datetime AS datetime FROM colfusion_notifications N, colfusion_users U, colfusion_links L WHERE N.sender_id = U.user_id AND N.target_id = L.link_id AND L.link_author = ".$this->user->user_id.")");
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
            case 'addRelationship':
                $userAction = "added a relationship on";
                break;
            case 'removeRelationship':
                $userAction = "removed previous relationship on";
                break;  
            default:
                # code...
                break;
        }
        date_default_timezone_set('America/New_York');
        $datetime = date('Y/m/d H:i:s');
        $query = "INSERT INTO `colfusion`.`colfusion_notifications` (`sender_id`, `target_id`, `action`, `datetime`) SELECT '".$this->user->user_id."',sid2,'".$userAction."', '".$datetime."' FROM colfusion_relationships WHERE rel_id=".$relID;
        $this->ezSql->query($query);
        $this->addUnreadNTFs($relID);
        return;
    }

    public function friend($to_user, $act){
        date_default_timezone_set('America/New_York');
        $datetime = date('Y/m/d H:i:s');
        // insert the ntf to ntf table
        $query = "INSERT INTO `colfusion`.`colfusion_notifications` (`ntf_id`, `sender_id`, `target_id`, `action`, `datetime`) VALUES (NULL, '".$this->user->user_id."', '0', '".$act."', '".$datetime."');";//target id set 0! to mean that this is a friend ntf
        $this->ezSql->query($query);

        $query = "INSERT INTO `colfusion`.`colfusion_notifications_unread` (`ntf_id`, `receiver_id`) SELECT MAX(ntf_id),'".$to_user."' FROM `colfusion`.`colfusion_notifications`;";
        $this->ezSql->query($query);
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

        $query = "SELECT link_author FROM colfusion_links WHERE link_id = (SELECT sid2 FROM colfusion_relationships WHERE rel_id= ".$relID.")";
        $result = $this->ezSql->get_results($query);
        foreach ($result as $r) {
            $link_author = $r->link_author;
        }
        if($link_author != $this->user->user_id){
            $query = "INSERT INTO  `colfusion`.`colfusion_notifications_unread` (`ntf_id` ,`receiver_id`) "
            ."SELECT MAX(ntf_id), '".$link_author."' FROM colfusion_notifications";
            $this->ezSql->query($query);
        }
    }
  
}

?>