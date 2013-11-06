<?php

require_once realpath(dirname(__FILE__)) . '/../config.php';

require_once(mnminclude.'html1.php');
require_once(mnminclude.'link.php');

class ChatDAO {

    private $ezSql;
    private $user;
    public function __construct() {
        global $db, $current_user;
        $this->ezSql = $db;
        $this->user = $current_user;
    }

    // get unread notifications from notification_unread
    public function addToOnline() {
        $query = "INSERT INTO  `colfusion`.`colfusion_webchat_users` (`id`,`last_activity`)VALUES ('".$this->user->user_id."',CURRENT_TIMESTAMP);";
        $this->ezSql->query($query);
        return "success";
    }

    public function getAllOnlineUsers() {
        // Deleting chats older than 5 minutes and users inactive for 10 minites
        $query = "DELETE FROM colfusion_webchat_lines WHERE ts < SUBTIME(NOW(),'0:5:0');";
        $this->ezSql->query($query);

        $query = "DELETE FROM colfusion_webchat_users WHERE last_activity < SUBTIME(NOW(),'0:10:0');";
        $this->ezSql->query($query);

        //get all users
        $query = "SELECT id AS user_id, user_login FROM `colfusion_webchat_users` WU, `colfusion_users` U WHERE WU.id = U.user_id AND U.user_id !=".$this->user->user_id;
        $links =  $this->ezSql->get_results($query);

        $query = "SELECT count(*) AS total FROM `colfusion_webchat_users` WHERE id !=".$this->user->user_id;
        $number = $this->ezSql->get_results($query);
        foreach ($number as $r) {
            $total = $r->total;
        }

        $results = array(
            "total" => $total,
            "users" => $links,
            );

        return json_encode($results);
    }

    public function getChats($lastID) {
        $lastID = (int)$lastID;
        
        $query = "SELECT id,aid,text,ts,user_login AS author FROM colfusion_webchat_lines WU, colfusion_users U WHERE WU.id > ".$lastID." AND WU.aid = U.user_id ORDER BY id ASC";
        $result = $this->ezSql->get_results($query);
        $chats = array();
        if($result){
            foreach ($result as $chat) {
                $date = date('Y-m-d H:i:s',strtotime($chat->ts));
                //$date = new DateTime(strtotime($chat->ts)); 
                //date->setTimezone(new DateTimeZone('EST')); 
                date_default_timezone_set("America/New_York");

                $chat->time = array(
                    'hours'     => date('H',$date),
                    'minutes'   => date('i',$date)
                );
                $chats[] = $chat;
            }
        }
        $return_chat = array(
            "chats" => $chats
            );
    
        return json_encode($return_chat);
    }

    public function submitChat($details){
        $query = "INSERT INTO `colfusion`.`colfusion_webchat_lines` (`id`, `aid`, `text`, `ts`) VALUES (NULL, '".$this->user->user_id."', '".$details."', CURRENT_TIMESTAMP);";
        $this->ezSql->query($query);

        $query = "SELECT max(id) AS id FROM colfusion_webchat_lines";
        $result = $this->ezSql->get_results($query);

        $return_chat = array(
            "status" => 1,
            "id" => $result
            );
    
        return json_encode($return_chat);
    }

  
}

?>
