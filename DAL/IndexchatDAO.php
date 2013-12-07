<?php
include_once realpath(dirname(__FILE__)) . '/../chat/indexchat_config.php';
include_once realpath(dirname(__FILE__)) . '/../libs/dbconnect.php';

class IndexchatDAO {

    public function __construct() {
        global $current_user;
        $this->user = $current_user;
        date_default_timezone_set('America/New_York');
    }

    public function addNewUser(){
        $query1 = "SELECT * FROM `".EZSQL_DB_NAME."`.`colfusion_users`";
        $query2 = "SELECT * FROM `".CHAT_DB."`.`index_users`";
        $num1 = mysql_num_rows(mysql_query($query1));
        if (mysql_query($query2)){
            $num2 = mysql_num_rows(mysql_query($query2));
        }
        else
            $num2 = -1;
        if($num1!=$num2){
            $query = "INSERT INTO `".CHAT_DB."`.`index_users`(`id`, `username`, `chat_status`, `offlineshift`) SELECT user_id, user_login, 'offline', '0' FROM `".EZSQL_DB_NAME."`.`colfusion_users` HAVING user_id NOT IN (SELECT id FROM `".CHAT_DB."`.`index_users`)";
            mysql_query($query);
        }
    }

    public function setStatus($chat_status, $offlineshift){
        $query = "UPDATE ".CHAT_DB.".`index_users` SET chat_status='".$chat_status."', offlineshift='".$offlineshift."' WHERE id='".$this->user->user_id."'";
        mysql_query($query);
    }

    public function sendMessage($to_id, $message){
        //check if selected user is online
        $check_status = mysql_query("SELECT * FROM `".CHAT_DB."`.`index_users` WHERE id='".$to_id."' AND chat_status='online'");
        if(mysql_num_rows($check_status) > 0){

            //insert message into chat table
            $query = "INSERT INTO `".CHAT_DB."`.`index_chat` (from_id,to_id,message,sent) VALUES('".$this->user->user_id."','".$to_id."','".$message."','".time()."')";
            if(mysql_query($query)){
                return 1;
            }else{
                return mysql_error();
            }

        }   
    }

    public function loadMessage($partner_id, $is_typing){
        $sent_time = time() - '7200'; //2 hours

        //check if partner is offline, print it on the end
        $check_offline = mysql_query("SELECT chat_status FROM `".CHAT_DB."`.`index_users` WHERE id='".$partner_id."' AND chat_status='offline' AND UNIX_TIMESTAMP(NOW()) > offlineshift;");

        if(mysql_num_rows($check_offline) > 0){
            $print_offline = '<p><span class="error">User is offline!</span></p>';
        }

        //set is typing record
        if(isset($is_typing)){ 
            $query = mysql_query("SELECT * FROM `".CHAT_DB."`.`index_typing` WHERE typing_from = '".$this->user->user_id."' AND typing_to = '".$partner_id."'");
            $result = mysql_fetch_assoc($query);
            $num = mysql_num_rows($query);
            if($num) {
            //update
                mysql_query("UPDATE `".CHAT_DB."`.`index_typing` SET typing_ornot = '".$is_typing."' WHERE typing_from='".$this->user->user_id."' AND typing_to = '".$partner_id."'");
            } else {
            //insert
                mysql_query("INSERT INTO `".CHAT_DB."`.`index_typing` (`typing_from`, `typing_to`, `typing_ornot`) VALUES ('".$this->user->user_id."', '".$partner_id."', '".$is_typing."')");
            }
        }

        //check if current user has unreceived messages which are older than limit, if yes, display it with date
        $check_unreceived = mysql_query("SELECT * FROM `".CHAT_DB."`.`index_chat` WHERE from_id='".$partner_id."' AND to_id='".$this->user->user_id."' AND sent < '".$sent_time."' AND recd='0' ORDER BY id");
        if(mysql_num_rows($check_unreceived) > 0){
            while($check_ur_row = mysql_fetch_assoc($check_unreceived)){
            //there is/are an unreceived message(s)
                //mark message(s) received and update their received times
                mysql_query("UPDATE `".CHAT_DB."`.`index_chat` SET recd='1',sent='".time()."' WHERE id='".$check_ur_row['id']."' AND recd='0'");
            }
        
            //insert info message as system into current chat
            mysql_query("INSERT INTO `".CHAT_DB."`.`index_chat` (from_id,to_id,message,sent,system_message) VALUES('".$partner_id."','".$this->user->user_id."','These are unreceived messages from the previous chat session!','".time()."','yes')");
        }

        //delete messages 2 hours before 
        $query = "DELETE FROM `".CHAT_DB."`.`index_chat` WHERE sent < ".$sent_time;
        mysql_query($query);
        //load messages
        $query = "SELECT * FROM `".CHAT_DB."`.`index_chat` WHERE (from_id='".$this->user->user_id."' AND to_id='".$partner_id."' AND sent > '".$sent_time."') OR (from_id='".$partner_id."' AND to_id='".$this->user->user_id."' AND sent > '".$sent_time."') ORDER BY sent";
        $res = mysql_query($query);
        if(mysql_num_rows($res) > 0){
            while($row = mysql_fetch_assoc($res)){
                //print messages
                if($row['system_message'] != 'no'){             
                    //message from system               
                        print '<p class="system">'.$row['message'].'</p>';                                  
                }elseif($row['from_id'] != $_POST['own_id']){
                    $res2 = mysql_query("SELECT username FROM `".CHAT_DB."`.`index_users` WHERE id='".$row['from_id']."'");
                    $row2 = mysql_fetch_assoc($res2);
                    print '<p><b>'.$row2['username'].':</b> '.$row['message'].'</p>';
                }else{
                    print '<p class="me"><b>Me:</b> '.$row['message'].'</p>';
                }
                
                
                //if to_id = current user, mark message as received
                if($row['to_id'] == $this->user->user_id){
                    mysql_query("UPDATE `".CHAT_DB."`.`index_chat` SET recd='1' WHERE id='".$row['id']."' AND recd='0'");
                }       
                
                $last_msg = $row['sent'];
            }   
            
            //print last message time if older than 2 mins
            $math = time() - $last_msg;
            if($math > 120){
                return '<p class="system">Last message sent at '.date('H:i').'</p>';
            }
            
            return $print_offline;
            
        }else{

            return $print_offline;
        }

    }

    public function isTyping($partner_id){
        $res = mysql_query("SELECT typing_ornot FROM `".CHAT_DB."`.`index_typing` WHERE typing_from='".$partner_id."' AND typing_to='".$this->user->user_id."' AND typing_ornot='1'");
        if(mysql_num_rows($res) > 0){
            return '1';
        }else{
            return '0';
        }

    }

    public function loadPopupMessage(){
        $sent_time = time() - $hide_old_messages_tstamp;

        //check if there is an unreceived message for current user
        $res = mysql_query("SELECT * FROM `".CHAT_DB."`.`index_chat` WHERE to_id='".$this->user->user_id."' AND recd='0' GROUP BY from_id LIMIT 0,1");
        if(mysql_num_rows($res) > 0){
            $row = mysql_fetch_assoc($res);
                
            //return user id and username
            $res2 = mysql_query("SELECT username FROM `".CHAT_DB."`.`index_users` WHERE id='".$row['from_id']."'");
            $row2 = mysql_fetch_assoc($res2);       
            
            return $row['from_id'].';;;'.$row2['username'];

        }else{
            return '0';
        }
    }
}

?>
