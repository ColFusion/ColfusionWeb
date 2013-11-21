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
    
    
    //get the values from other page
    $Sid = $_GET['id'];
    $rollback = $_GET['rollback']; //true or false
    
    if(isset($_GET['date'])) {$modified_date = $_GET['date'];} else {$modified_date=null;}
    if(isset($_GET['modifieduser'])) {$modified_user = $_GET['modifieduser'];} else {$modified_user=null;}    
    //echo $modified_user;
    if(isset($_GET['titlestr'])) {$title = $_GET['titlestr'];$title_noti= $_GET['titlenoti'];} else {$title=null;} 
    if(isset($_GET['desstr'])) {$description = $_GET['desstr'];$des_noti= $_GET['desnoti'];} else {$description=null;}
    if(isset($_GET['category'])) {$category = $_GET['category'];$category_noti = $_GET['categorynoti'];} else {$category=0;}
    if(isset($_GET['tagsstr'])) {$tags = $_GET['tagsstr'];$tags_noti= $_GET['tagsnoti'];} else {$tags="000";}
    
    
    $s = $db->get_row("SELECT link_id, UserId, Title, link_tags, link_category, link_title, link_content, link_summary FROM ".table_prefix."sourceinfo s inner join colfusion_links l on s.sid = l.link_id  WHERE Sid = $Sid");
    $link_id = $s->link_id;
    $userId = $s->UserId;
    //$link_tags = $s->link_tags;
    // title is going to be modified
        // if the modified text is different from original text($title!=null), import into database
    if ($title != null) {
        //echo "here";
        //update the title from input
        $title= \mysql_real_escape_string($title);
        $sql_update = "UPDATE colfusion_sourceinfo ";
        $sql_update .="SET Title = '{$title}' ";
        $sql_update .="WHERE Sid = {$link_id}";
        
        if($db->query($sql_update)) {
            //update the link_title
            $sql_update = "UPDATE colfusion_links ";
            $sql_update .="SET link_title = '{$title}' ";
            $sql_update .="WHERE link_id = {$link_id}";
            if($db->query($sql_update)) {
                //set previous checked to false
                $sql_update = "UPDATE wiki_history ";
                $sql_update .="SET checked = false ";
                $sql_update .="WHERE sid = {$link_id} and field = 'title' and checked = true";
                $db->query($sql_update);
                // update the wiki history
                //rollback==0 means normal modification
                if ($rollback==0) {
                    $title_noti = \mysql_real_escape_string($title_noti);
                    $sql_insert = "INSERT INTO wiki_history (sid,user_id,timestamp,field,value,notification,checked) 
                            VALUES ('{$link_id}','{$userId}','{$timestamp}','title','{$title}','{$title_noti}',true)";
                    $db->query($sql_insert);                    
                } else {
                    //if rollback, I should change the default checked radio button
                    //find userid
                    $target_user = $db->get_row("SELECT user_id FROM colfusion_users WHERE user_login = '{$modified_user}'");
                    $target_user_id = $target_user->user_id;
                    //echo $target_user_id;
                    $sql_update = "UPDATE wiki_history ";
                    $sql_update .="SET checked = true ";
                    $sql_update .="WHERE sid = {$link_id} and field = 'title' and timestamp = '{$modified_date}' and user_id = {$target_user_id} ";
                    $db->query($sql_update);  
            
                }
            }
        }
    }        
    
    // description is going to be modified
    // if the modified text is different from original text, import into database
    if ($description !=null) {
        //update the link_content from input
        $description= \mysql_real_escape_string($description);
        $sql_update = "UPDATE colfusion_links ";
        $sql_update .="SET link_content = '{$description}' ";
        $sql_update .="WHERE link_id = {$link_id}";
        
        if($db->query($sql_update)) {
            //update the link_summary
            $sql_update = "UPDATE colfusion_links ";
            $sql_update .="SET link_summary = '{$description}' ";
            $sql_update .="WHERE link_id = {$link_id}";
            if ($db->query($sql_update)){
                
                //set previous checked to false
                $sql_update = "UPDATE wiki_history ";
                $sql_update .="SET checked = false ";
                $sql_update .="WHERE sid = {$link_id} and field = 'description' and checked = true";
                $db->query($sql_update);
                
                if ($rollback==0) {
                    // update the wiki history
                    $des_noti = \mysql_real_escape_string($des_noti);
                    $sql_insert = "INSERT INTO wiki_history (sid,user_id,timestamp,field,value,notification,checked) 
                            VALUES ('{$link_id}','{$userId}','{$timestamp}','description','{$description}','{$des_noti}',true)";
                    $db->query($sql_insert);
                } else {
                    //if rollback, I should change the default checked radio button
                    //find userid
                    $target_user = $db->get_row("SELECT user_id FROM colfusion_users WHERE user_login = '{$modified_user}'");
                    $target_user_id = $target_user->user_id;
                    //echo $target_user_id;
                    $sql_update = "UPDATE wiki_history ";
                    $sql_update .="SET checked = true ";
                    $sql_update .="WHERE sid = {$link_id} and field = 'description' and timestamp = '{$modified_date}' and user_id = {$target_user_id} ";
                    $db->query($sql_update);  
                }                    
                  
            }
        }
    }
    
    // category is going to be modified
    // if the option is different from original one, import into database
    if ($category!=0) {
        //update the category
        $sql_update = "UPDATE colfusion_links ";
        $sql_update .="SET link_category = '{$category}' ";
        $sql_update .="WHERE link_id = {$link_id}";
        if($db->query($sql_update)) {
            
            //set previous checked to false
            $sql_update = "UPDATE wiki_history ";
            $sql_update .="SET checked = false ";
            $sql_update .="WHERE sid = {$link_id} and field = 'category' and checked = true";
            $db->query($sql_update);
            switch ($category) {
                case 1:
                    $category = "News";
                    break;
                case 2:
                    $category = "Bussiness";
                    break;
                case 3:
                    $category = "History";
                    break;
                default:
                    break;
            }
            
            if ($rollback==0) {
                // update the wiki history
                $sql_insert = "INSERT INTO wiki_history (sid,user_id,timestamp,field,value,notification,checked) 
                        VALUES ('{$link_id}','{$userId}','{$timestamp}','category','{$category}','{$category_noti}',true)";
                $db->query($sql_insert);
                
            } else {
                //if rollback, I should change the default checked radio button
                //find userid
                $target_user = $db->get_row("SELECT user_id FROM colfusion_users WHERE user_login = '{$modified_user}'");
                $target_user_id = $target_user->user_id;
                //echo $target_user_id;
                $sql_update = "UPDATE wiki_history ";
                $sql_update .="SET checked = true ";
                $sql_update .="WHERE sid = {$link_id} and field = 'category' and timestamp = '{$modified_date}' and user_id = {$target_user_id} ";
                $db->query($sql_update);  
            }                              
        }
    }     
    
    // tags is going to be modified
    // if the modified text is different from original text, import into database
    if ($tags != "000") {
        //echo "here";
        //update the tags from input
        //update the link_tags
        $tags= \mysql_real_escape_string($tags);
        $sql_update = "UPDATE colfusion_links ";
        $sql_update .="SET link_tags = '{$tags}' ";
        $sql_update .="WHERE link_id = {$link_id}";
        if($db->query($sql_update)) {
            
            //set previous checked to false
            $sql_update = "UPDATE wiki_history ";
            $sql_update .="SET checked = false ";
            $sql_update .="WHERE sid = {$link_id} and field = 'tags' and checked = true";
            $db->query($sql_update);
            
            if ($rollback==0) {
                // update the wiki history
                $tags_noti = \mysql_real_escape_string($tags_noti);
                $sql_insert = "INSERT INTO wiki_history (sid,user_id,timestamp,field,value,notification,checked) 
                        VALUES ('{$link_id}','{$userId}','{$timestamp}','tags','{$tags}','{$tags_noti}',true)";
                if($db->query($sql_insert)) {
                    $sql_update = "UPDATE colfusion_tags ";
                    $sql_update .="SET tag_words = '{$tags}' ";
                    $sql_update .="WHERE tag_link_id = {$link_id}";
                    $db->query($sql_update);
                }
            } else {
                //if rollback, I should change the default checked radio button
                //find userid
                $target_user = $db->get_row("SELECT user_id FROM colfusion_users WHERE user_login = '{$modified_user}'");
                $target_user_id = $target_user->user_id;
                //echo $target_user_id;
                $sql_update = "UPDATE wiki_history ";
                $sql_update .="SET checked = true ";
                $sql_update .="WHERE sid = {$link_id} and field = 'tags' and timestamp = '{$modified_date}' and user_id = {$target_user_id} ";
                $db->query($sql_update);  
            }                              
        }
        
    }         


    //echo $str."<br/>";
    /*
    error_reporting(E_ALL ^ E_DEPRECATED);
    $con = mysql_connect($servername,$username,$password);
    if (!$con){
        die('Could not connect: ' . mysql_error());
        //echo 'fail to connect';
    } else {
        mysql_select_db($database,$con);
        $sql_select = " SELECT content
                        FROM description
                        WHERE id=(SELECT MAX(id)
                                  FROM description)";
        if (!mysql_query($sql_select,$con)) {
            die('Error: ' . mysql_error());
        } else {
            $result = mysql_query($sql_select,$con);
            $row = mysql_fetch_array($result);
        }
        if ($row['content']!=$str) {
            $str= \mysql_real_escape_string($str);
            $sql="INSERT INTO description (content) VALUES('{$str}')";
            //mysql_query($create_table,$con);
            if (!mysql_query($sql,$con)) {
                die('Error: ' . mysql_error());
            } else {
                echo "insert succeeded";
            }      
        }

    }
    */

?>
