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

    public function createChatRoomForStory($sid){
        $quer = "CREATE DATABASE IF NOT EXISTS colfusion_chat";
        $this->ezSql->query($query);
        
        $query = "CREATE TABLE IF NOT EXISTS `colfusion_chat`.`colfusion_webchat_users".$sid."`(`id` int(20) unsigned NOT NULL,`last_activity` timestamp NOT NULL default CURRENT_TIMESTAMP,PRIMARY KEY  (`id`),KEY `last_activity` (`last_activity`)) ENGINE=MyISAM  DEFAULT CHARSET=utf8;";
        $this->ezSql->query($query);

        $query = "CREATE TABLE IF NOT EXISTS `colfusion_chat`.`colfusion_webchat_lines".$sid."` (`id` int(10) unsigned NOT NULL auto_increment,`aid` int(20) NOT NULL,`text` varchar(255) NOT NULL,`ts` timestamp NOT NULL default CURRENT_TIMESTAMP,PRIMARY KEY  (`id`),KEY `ts` (`ts`)) ENGINE=MyISAM  DEFAULT CHARSET=utf8;";
        $this->ezSql->query($query);

        echo "success";
    }

    public function addToOnline($sid) {
        $query = "INSERT INTO  `colfusion_chat`.`colfusion_webchat_users".$sid."` (`id`,`last_activity`)VALUES ('".$this->user->user_id."',CURRENT_TIMESTAMP);";
        $this->ezSql->query($query);
        return "logged in";
    }

    public function getAllOnlineUsers($sid) {
        // Deleting chats older than 5 minutes and users inactive for 10 minites
        $query = "DELETE FROM `colfusion_chat`.`colfusion_webchat_lines".$sid."` WHERE ts < SUBTIME(NOW(),'0:5:0');";
        $this->ezSql->query($query);

        $query = "DELETE FROM `colfusion_chat`.`colfusion_webchat_users".$sid."` WHERE last_activity < SUBTIME(NOW(),'0:10:0');";
        $this->ezSql->query($query);

        //get all users
        $query = "SELECT id AS user_id, user_login FROM `colfusion_chat`.`colfusion_webchat_users".$sid."` WU, `colfusion`.`colfusion_users` U WHERE WU.id = U.user_id AND U.user_id !=".$this->user->user_id;
        $links =  $this->ezSql->get_results($query);

        $query = "SELECT count(*) AS total FROM `colfusion_chat`.`colfusion_webchat_users".$sid."` WHERE id !=".$this->user->user_id;
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

    public function getChats($lastID, $sid) {
        $lastID = (int)$lastID;
        $tableName = "colfusion_chat.colfusion_webchat_lines".$sid;
        $query = "SELECT id,aid,text,ts,user_login AS author FROM ".$tableName." WU, `colfusion`.`colfusion_users` U WHERE WU.id > ".$lastID." AND WU.aid = U.user_id ORDER BY id ASC";
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

    public function submitChat($details, $sid){
        $query = "INSERT INTO `colfusion_chat`.`colfusion_webchat_lines".$sid."` (`id`, `aid`, `text`, `ts`) VALUES (NULL, '".$this->user->user_id."', '".$details."', CURRENT_TIMESTAMP);";
        $this->ezSql->query($query);

        $query = "SELECT max(id) AS id FROM `colfusion_chat`.`colfusion_webchat_lines".$sid."`;";
        $result = $this->ezSql->get_results($query);

        $return_chat = array(
            "status" => 1,
            "id" => $result
            );
    
        return json_encode($return_chat);
    }

  
}

?>
