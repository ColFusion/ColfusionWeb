<?php
include_once('Smarty.class.php');
$main_smarty = new Smarty;

include('config.php');
include(mnminclude.'html1.php');
include(mnminclude.'link.php');
include(mnminclude.'tags.php');
include(mnminclude.'user.php');
include(mnminclude.'smartyvariables.php');

// -------------------------------------------------------------------------------------

/*// breadcrumbs and page titles
$navwhere['text1'] = ($main_smarty->get_config_vars('PLIGG_Visual_Search_Advanced'));
$navwhere['link1'] = 'advancedsearch_underconstruction.php';//getmyurl('advancesearch', '');
$main_smarty->assign('navbar_where', $navwhere);
$main_smarty->assign('posttitle', $main_smarty->get_config_vars('PLIGG_Visual_Search_Advanced'));

// sidebar
$main_smarty = do_sidebar($main_smarty);
 
// pagename	
define('pagename', 'advancedsearch_underconstruction');
$main_smarty->assign('pagename', pagename);
//to put the string 

// misc smarty
if(isset($search->setmek)){$main_smarty->assign('setmeka', $search->setmek);}else{$main_smarty->assign('setmeka', '');}
if(isset($search->ords)){$main_smarty->assign('paorder', $search->ords);}

$fetch_link_summary = true;

//the template

$main_smarty->display($the_template . '/header.tpl');
//$main_smarty->display($the_template . '/sidebar.tpl');
$main_smarty->display($the_template . '/sidebar2.tpl');
$main_smarty->display($the_template . '/footer.tpl');

//show the template
    	$main_smarty->assign('tpl_center', $the_template . '/advancedsearch_underconstruction_template');
    	$main_smarty->display($the_template . '/pligg.tpl');
		
//code for connecting to the database and displaying the result
*/
global $db;	
/*$dbuser= "root";
$dbpass= "";
$dbhost= "localhost";
$dbDatabase= "test";

$dbConn= mysql_connect($dbhost, $dbuser, $dbpass);

if ($dbConn)
{
    printf("<br/>connecting to the database");
    mysql_select_db($dbDatabase);
    printf("<br/>conncted to the database test");
}
else
{
    die("<br/>couldnot connect to the database");
}*/
     
//following is the code for selecting the total value for a particular dataset
if(isset($_POST["Location"]))
{
    
    $location= $_POST["Location"];
    $yearstart= $_POST["YearStart"];
    $dname= $_POST["Dname"];
    $yearend= $_POST["YearEnd"];
    echo "<br/>You have chosen to display data for the location:<b> ".$location."</b> and YearStart: <b>".$yearstart."</b> YearEnd: <b>".$yearend."</b><br/>";
	echo "<br/>";
    $query= mysql_query("SELECT * FROM colfusion_temporary 
                         WHERE Location='".$location."' and Dname='$dname' and Start >= '$yearstart' and End <= '$yearend'") 
						 or 
						 die("<br/>Data with the specific year or place doesnot exist, please make another selection <br/>Also, make sure that the START date PRECEDS END date");
    /*$query= $db->query($sql)
				or die("</b>Data with the specific year or place doesnot exist, please make another selection");*/
				
    $row= mysql_num_rows($query);
	//$row= $db->get_row($query);
    //$string="<br/>number of rows: ".$row;
	//$main_smarty->assign('result', $string);
    //to make sure that there is atleast one row in the result
    if($row!= 0)
    {
        echo("<table border='1' cellspacing='0'>");
        echo("<th>Spd</th>");
        echo("<th>Drd</th>");
        echo("<th>Dname</th>");
        echo("<th>Location</th>");
        echo("<th>Start</th>");
        echo("<th>End</th>");
        echo("<th>Total $dname</th>");
		echo("<th>Story Details</th>");
        while($row=  mysql_fetch_assoc($query))
        {
            echo("<tr>");
            echo("<td>".$row['Spd']."</td>");
            echo("<td>".$row['Drd']."</td>");
            echo("<td>".$row['Dname']."</td>");
            echo("<td>".$row['Location']."</td>");
            echo("<td>".$row['Start']."</td>");
            echo("<td>".$row['End']."</td>");
            echo("<td>".$row['Value']."</td>");
			echo("<td width='30%'><a href='story.php?title=".$row['Sid']."'>Go To Story</a></td>");
            echo("</tr>");
        }
        echo("</table>");
    }
    else echo("<br/><b>ERROR:<b/>There are no rows for specified selection. Please select a different combination<br/>Also, make sure that the START date PRECEDS END date");
}

#following is the code for calculating the Average value for a particular dataset
else if(isset($_POST["Location1"]))
{
    $locfamhouse= $_POST["Location1"];
    $yearfamhouse= $_POST["YearStart1"];
    $dname1= $_POST["Dname1"];
    $yearend1= $_POST["YearEnd1"];
    
    printf("<br/>the total Family Households information is below<br/>");
    printf("<br\>You have chosen to display data for the location:<b> ".$locfamhouse."</b> and Start Year: <b>".$yearfamhouse."</b> End Year:<b> ".$yearend1."</b>");
    $queryfamhouse= mysql_query("SELECT Dname, AVG(Value) FROM colfusion_temporary 
                         WHERE Location='".$locfamhouse."' and Dname='$dname1' and Start >= '$yearfamhouse' and End <= '$yearend1'") 
                or 
                die("<br/>Data with the specific year or place doesnot exist, please make another selection<br/>Also, make sure that the START date PRECEDS END date");
    $row= mysql_num_rows($queryfamhouse);
    if($row!= 0)
    {
        echo("<table border='1' cellspacing='0'>");
        echo("<th>Dname</th>");
        echo("<th>Avg $dname1</th>");
        while($row=  mysql_fetch_assoc($queryfamhouse))
        {
            echo("<tr>");
            echo("<td>".$row['Dname']."</td>");
            echo("<td>".$row['AVG(Value)']."</td>");
            echo("</tr>");
        } 
        
        echo("</table>");
    }
    else echo("<br/>There are no rows for specified selection. Please select a different combination<br/>Also, make sure that the START date PRECEDS END date");
}
else printf("not entering any of the loops");

?>