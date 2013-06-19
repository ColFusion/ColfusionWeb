<html>
<body>

<?php
include_once('Smarty.class.php');
$main_smarty = new Smarty;

include('config.php');
include(mnminclude.'html1.php');
include(mnminclude.'link.php');
include(mnminclude.'smartyvariables.php');

// breadcrumbs and page titles
$navwhere['text1'] = 'resulthighlight';
$navwhere['link1'] = 'resulthighlight.php';
$main_smarty->assign('navbar_where', $navwhere);
$main_smarty->assign('posttitle', 'resulthighlight');


if(isset($_POST['name'])){
$name=$_POST['name'];
$sql="SELECT name
    FROM colfusion_misc_data
    WHERE name like '%$name%'";
  $result=mysql_query($sql);
    echo "<table border='1'>
   <tr>
<th>name</th>
</tr>";
while($row = mysql_fetch_array($result))
 { echo"<tr>";
  $row['name']=preg_replace("/($name)/i","<b style=\"color:red\">\\1</b>",$row['name']);    
  echo "<td>" . $row['name'] . "</td>";           
 }

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

