<?php

    include_once('Smarty.class.php');
    $main_smarty = new Smarty;

    include('config.php');
    include(mnminclude.'html1.php');
    include(mnminclude.'link.php');
    include(mnminclude.'group.php');
    include(mnminclude.'smartyvariables.php');
    include_once(mnminclude.'user.php');
    
    global $current_user, $globals, $the_template, $smarty, $db;
    $timestamp = date("Y-m-d H:i:m");
    



    if(isset($_GET['date'])) {$modified_date = $_GET['date'];} else {$modified_date=null;}

    $Sid = $_GET['id'];
    $Cid = $_GET['cid'];
    if(isset($_GET['userid'])) {
        $userId = $_GET['userid'];
        
        $value = $_GET['value'];
        $notification = $_GET['notification'];
        $comment = $_GET['comment'];

        //echo $Sid;
        //echo $value;
        
        //create a table for preview data editing

        
        
        //set previous vision's checked attribute to false
        $sql_update = "UPDATE record_history_{$Sid} ";
        $sql_update .="SET checked = false ";
        $sql_update .="WHERE cid = '{$Cid}' and checked = true";
        $db->query($sql_update);
        
        
        $sql_insert = "INSERT INTO record_history_".$Sid." (sid,user_id,cid,timestamp,value,notification,comment,checked) 
                VALUES ('{$Sid}','{$userId}','{$Cid}','{$timestamp}','{$value}','{$notification}','{$comment}',true)";
        
        if($db->query($sql_insert)) {
            echo $value;
        }
            
            //echo $value;


    }  else {
        $sql_select = "SELECT user_id, timestamp, comment, notification FROM record_history_{$Sid} WHERE (COMMENT <> 'null' OR NOTIFICATION <> 'null') AND cid = '{$Cid}' ORDER BY timestamp";
        
        $output = "<table class='table table-striped'>";
        $output .= "<tr><th>USER ID</th><th>DATE</th><th>COMMENT</th><th>NOTIFICATION</th></tr>";
        $result = mysql_query($sql_select);
        while($row = mysql_fetch_array($result)) {

            $output .= "<tr><td>".$row['user_id']."</td><td>".$row['timestamp']."</td><td>".$row['comment']."</td></tr>";
        }
        $output .= "</table>";

        echo $output;
    }   
    
    /*
    $sql_select = "SELECT comment, user_login, timestamp 
                 FROM record_history_{$Sid} AS r, colfusion_users AS u  
                 WHERE r.user_id=u.user_id AND cid = '{$Cid}' AND comment <> 'null'";

    


     $result = mysql_query($sql_select);
     $count = 0;
     $printout;
     while($row = mysql_fetch_array($result)) {
        $count++;


     }

     if($count == 0) {

        $printout =  '<a href="#myModal" role="button" data-toggle="modal"></a>';

     }
    


*/
    


















?>