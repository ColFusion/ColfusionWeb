<?php
    $con = mysql_connect('localhost','root','');
    if (!$con){
        die('Could not connect: ' . mysql_error());}
    
    mysql_select_db("Colfusion", $con);
    $sql = "SELECT * FROM colfusion_config";
    $rst = mysql_query($sql);
    $rows = array();
    while($r = mysql_fetch_array($rst, MYSQL_ASSOC)){
        $rows[] = $r;}
    echo json_encode($rows);
    
    mysql_close($con);
?> 