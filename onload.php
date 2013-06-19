<?php

include_once('Smarty.class.php');
$main_smarty = new Smarty;

include('config.php');
include(mnminclude.'html1.php');
include(mnminclude.'link.php');
include(mnminclude.'tags.php');
include(mnminclude.'user.php');
include(mnminclude.'smartyvariables.php');


global $db;	
/*$dbuser= "root";
$dbpass= "";
$dbhost= "localhost";
$dbDatabase= "test";

$dbConn= mysql_connect($dbhost, $dbuser, $dbpass);

if ($dbConn)
{
    //printf("<br/>connecting to the database");
    mysql_select_db($dbDatabase);
    //printf("<br/>conncted to the database test");
}
else
{
    die("<br/>couldnot connect to the database");
}
*/
//loading the datasets:
if(isset($_POST["totoalvaluelocations"]))
 {
    //loading the locations:
    $query= mysql_query("SELECT DISTINCT Location FROM colfusion_temporary") 
                            or 
                           die("</b>Data with the specific year or place doesnot exist, please make another selection");


    echo '<select id="totalHouseholdsLocation">';
    while ($row= mysql_fetch_array($query))
    {
        echo '<option value="'.$row['Location'].'">'.$row['Location'].'</option>';

    }

     echo '</select>';
 }
 else if(isset($_POST["avgvaluelocations"]))
 {
    //loading the locations:
    $query= mysql_query("SELECT DISTINCT Location FROM colfusion_temporary") 
                            or 
                           die("</b>Data with the specific year or place doesnot exist, please make another selection");


        echo '<select id="totalfamilyHouseholdsLocation">';
    while ($row= mysql_fetch_array($query))
    {
        echo '<option value="'.$row['Location'].'">'.$row['Location'].'</option>';

    }

     echo '</select>';
 }
 
 else if(isset($_POST["totalval"]))
 {
     $query= mysql_query("SELECT DISTINCT Dname FROM colfusion_temporary") 
                            or 
                           die("</b>Data with the specific year or place doesnot exist, please make another selection");
 
    while ($row= mysql_fetch_array($query))
    {
        echo $row['Dname'];
        echo ',';
    }
 }
 
 else if(isset($_POST["avgval"]))
 {
     $query= mysql_query("SELECT DISTINCT Dname FROM colfusion_temporary") 
                            or 
                           die("</b>Data with the specific year or place doesnot exist, please make another selection");
 
    while ($row= mysql_fetch_array($query))
    {
        echo $row['Dname'];
        echo ',';
    }
 }
  mysql_close($dbConn);
?>
