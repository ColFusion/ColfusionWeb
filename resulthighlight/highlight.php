<html>
<body>

<?php
include_once('../Smarty.class.php');
$main_smarty = new Smarty;

include('../config.php');
include(mnminclude.'html1.php');
include(mnminclude.'link.php');
include(mnminclude.'smartyvariables.php');

// breadcrumbs and page titles
$navwhere['text1'] = 'hightlight';
$navwhere['link1'] = 'hightlight.php';
$main_smarty->assign('navbar_where', $navwhere);
$main_smarty->assign('posttitle', 'highlight');
$main_smarty->assign('value',$rst);

if(isset($_POST['name'])){
$name=explode(",", $_POST['name']);
$sql="SELECT *
    FROM colfusion_links
    WHERE link_title like '%$name%'
   or link_content like '%$name%'";
 
$rst=mysql_query($sql);
 

$searchResults = "<table border='0'>
<tr>
<th>title</th>
<th>content</th>
</tr>";
    
while($row = mysql_fetch_array($rst)){
  $row['link_title']=preg_replace("/($name)/i","<b style=\"color:red\">\\1</b>",$row['link_title']);    
  $row['link_content']=preg_replace("/($name)/i","<b style=\"color:red\">\\1</b>",$row['link_content']);
  $searchResults = $searchResults."<tr>";
  $searchResults = $searchResults."<td>" . $row['link_title'] ."</td>";
  $searchResults = $searchResults."<td>" . $row['link_content'] ."</td>";
} 
 
$searchResults = $searchResults."</table>";
}

mysql_close();

$main_smarty->assign('searchResults',$searchResults);

//sidebar
$main_smarty = do_sidebar($main_smarty);
//show the template
$main_smarty->assign('tpl_center', $the_template . '/highlight');
$main_smarty->display($the_template . '/pligg.tpl');
?>
</body>
</html>

