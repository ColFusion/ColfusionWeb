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
$navwhere['text1'] = 'db';
$navwhere['link1'] = 'db.php';
$main_smarty->assign('navbar_where', $navwhere);
$main_smarty->assign('posttitle', 'db');

if(isset($_POST['name'])){
$name=$_POST['name'];
$sql="SELECT *
    FROM colfusion_misc_data
    WHERE name like '%$name%'
    or data like '%$name%'";
 
$rst=mysql_query($sql);
 
echo "<table border='1'>
<tr>
<th>name</th>
<th>data</th>
</tr>";
    
while($row = mysql_fetch_array($rst)){
 $row['name']=preg_replace("/($name)/i","<b style=\"color:red\">\\1</b>",$row['name']);    
 $row['data']=preg_replace("/($name)/i","<b style=\"color:red\">\\1</b>",$row['data']);
  echo "<tr>";
  echo "<td>" . $row['name'] ."</td>";
  echo "<td>" . $row['data'] ."</td>";
} 
 
echo "</table>";
}

mysql_close();

//sidebar
$main_smarty = do_sidebar($main_smarty);
//show the template
$main_smarty->assign('tpl_center', $the_template . '/highlight');
$main_smarty->display($the_template . '/pligg.tpl');
?>
</body>
</html>

