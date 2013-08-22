<?php
include_once('../Smarty.class.php');
$main_smarty = new Smarty;

include_once('../config.php');
include_once(mnminclude.'html1.php');
include_once(mnminclude.'link.php');
include_once(mnminclude.'user.php');
include_once(mnminclude.'smartyvariables.php');

require_once(realpath(dirname(__FILE__)) . "/../DAL/ExternalDBHandlers/DatabaseHandlerFactory.php");
require_once(realpath(dirname(__FILE__)) . "/../vendor/autoload.php");

check_referrer();

// require user to log in
force_authentication();

// restrict access to god only
$canIhaveAccess = 0;
$canIhaveAccess = $canIhaveAccess + checklevel('god');

if($canIhaveAccess == 0){	
	header("Location: " . getmyurl('login', $_SERVER['REQUEST_URI']));
	die();
}


function delete_storylink($linkid) {
    if (!is_numeric($linkid)) return;
   

    $query="SELECT * FROM " . table_links . " WHERE link_id = '$linkid'";
    if (! $result=mysql_query($query)) {error_page(mysql_error());}
    else {$sql_array = mysql_fetch_object($result); }

//var_dump($sql_array);

    # delete the story link
    $query="DELETE FROM " . table_links . " WHERE link_id = '$linkid'";
    if (! $result=mysql_query($query)) {error_page(mysql_error());}

    # delete the story comments
    $query="DELETE FROM " . table_comments . " WHERE comment_link_id = '$linkid'";
    if (! $result=mysql_query($query)) {error_page(mysql_error());}

    # delete the saved links
    $query="DELETE FROM " . table_saved_links . " WHERE saved_link_id = '$linkid'";
    if (! $result=mysql_query($query)) {error_page(mysql_error());}

    # delete the story tags
    $query="DELETE FROM " . table_tags . " WHERE tag_link_id = '$linkid'";
    if (! $result=mysql_query($query)) {error_page(mysql_error());}

    # delete the story trackbacks
    $query="DELETE FROM " . table_trackbacks . " WHERE trackback_link_id = '$linkid'";
    if (! $result=mysql_query($query)) {error_page(mysql_error());}

    # delete the story votes
    $query="DELETE FROM " . table_votes . " WHERE vote_link_id = '$linkid'";
    if (! $result=mysql_query($query)) {error_page(mysql_error());}

    # delete additional categories
    $query="DELETE FROM ".table_additional_categories." WHERE ac_link_id = '$linkid'";
    if (! $result=mysql_query($query)) {error_page(mysql_error());}

    $sid = $sql_array->link_title_url;

    # delete target database if local
    $query="SELECT * FROM ". table_prefix ."sourceinfo_DB WHERE sid = $sid";
    if (! $result=mysql_query($query)) {error_page(mysql_error());}
    else {
        $sql_array = mysql_fetch_object($result); 

//var_dump($sql_array);

        if ($sql_array->is_local == 1) {
            // deleing the target db here.
             
            $dbHandler = DatabaseHandlerFactory::createDatabaseHandler($sql_array->driver, $sql_array->user_name, $sql_array->password, $sql_array->source_database, $sql_array->server_address, $sql_array->port);
            $dbHandler->dropDatabase();
        }
    }

    //delete the sourceinfo which should triget casding deleting of all related info except cached queries and visualization stuff.
    $query="DELETE FROM ".table_prefix."sourceinfo WHERE sid = $sid";
    if (! $result=mysql_query($query)) {error_page(mysql_error());}

    //now the only thing left is Neo4J, need to delete node and all realtionships.
    // Connecting to the default port 7474 on localhost
    $client = new Everyman\Neo4j\Client();

    $sourceIndex = new Everyman\Neo4j\Index\NodeIndex($client, 'sources');

    $sourceFrom = $sourceIndex->queryOne("sid:$sid");

//var_dump($sourceFrom);

    if (isset($sourceFrom)) {
        $rels = $sourceFrom->getRelationships();

//var_dump($rels);

        if (isset($rels) && count($rels) > 0) 
        {
            foreach ($rels as $key => $rel) {

//var_dump($rel);

                $rel->delete();
            }
        }

        $sourceFrom->delete();
    }

    // module system hook
    $vars = array('link_id' => $linkid);
    check_actions('admin_story_delete', $vars);
}


$sql_query = "SELECT * FROM " . table_links . " WHERE link_status = 'discard'";

$result_storylinks = mysql_query($sql_query);
$num_rows = mysql_num_rows($result_storylinks);
                while($storylink = mysql_fetch_object($result_storylinks))
                {
                        delete_storylink($storylink->link_id);
                }

# set discards total to zero
$query="UPDATE " . table_totals . " SET total = '0' WHERE name = 'discard'";
if (!mysql_query($query)) error_page(mysql_error());

$query="DELETE FROM " . table_tag_cache;
if (!mysql_query($query)) {error_page(mysql_error());}

echo '<div style="padding:8px;margin:14px 2px;border:1px solid #bbb;background:#eee;">';

echo '	<h2 style="font-size: 18px;margin:0;padding:0;border-bottom:1px solid #629ACB;">'. $num_rows. ' '.$main_smarty->get_config_vars("PLIGG_Visual_AdminPanel_Discarded_Stories_Removed").'</h2>';

    $query = "SHOW TABLE STATUS";
    $result=mysql_query($query);
    $table_list = "";
    while ($cur_table = mysql_fetch_object($result)) {
        $table_list .= $cur_table->Name.", ";
    }

    if (!empty($table_list)) {
        $table_list = substr($table_list, 0, -2);
        $query = "OPTIMIZE TABLE ".$table_list;
        mysql_query($query);
	if (mysql_error())
		echo mysql_error();
	else
		echo '	<p style=\'font:13px arial, "Lucida Grande","Lucida Sans Unicode",Tahoma,Verdana,sans-serif;\'>'.$main_smarty->get_config_vars("PLIGG_Visual_AdminPanel_Discarded_Stories_Removed_Message").'</p>';
    }

echo '	<p style=\'font:13px arial, "Lucida Grande","Lucida Sans Unicode",Tahoma,Verdana,sans-serif;\'><a href="./admin_links.php" onclick="parent.$.fn.colorbox.close(); return false;">'.$main_smarty->get_config_vars("PLIGG_Visual_AdminPanel_Return_Story_Management").'</a></p>';
echo '</div>';

?>