<?php
include('../config.php');

$vid = $_POST["vid"];
$type = $_POST["type"];
$top = $_POST["top"];
$left = $_POST["left"];
$width = $_POST["width"];
$height = $_POST["height"];
$setting = $_POST["setting"];
$userid = $_POST["userid"];
$titleNo = $_POST["titleNo"];

$sql = "SELECT count(*) FROM `colfusion_visualization` WHERE vid = '$vid'";
$is_vid_exist = $db->get_var($sql);


if($is_vid_exist == 0)
{
	$sql = "INSERT INTO `colfusion_visualization`" 
		. "(`vid`, `type`, `top`, `left`, `width`, `height`, `setting`, `userid`, `titleno`) " 
		. "VALUES ('$vid', '$type', '$top', '$left', '$width', '$height', '$setting', '$userid', '$titleNo')";
	$rs=$db->query($sql);
	//echo "insert";
	echo "success";
}
else
{
	$sql = "UPDATE `colfusion_visualization` SET " 
		. " `top`='$top',`left`='$left',`width`='$width',`height`='$height', `setting`='$setting' WHERE `vid` = '$vid' ";
	$rs=$db->query($sql);
	//echo "update " . $vid;
	echo "success";
}
?>