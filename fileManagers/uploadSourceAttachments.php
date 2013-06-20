<?php	
include_once(realpath(dirname(__FILE__)) . '/FileManagers.php');
include_once(realpath(dirname(__FILE__)) . '/../libs/login.php');
global $current_user;
if(!$current_user->authenticated) die('Please login to use this function.');

$userId = $current_user->user_id;
$sid = $_GET['sid'];
$description = trim($_POST['description']);

$fileMgr = SourceDesAttachmentManager::getInstance();
$listItemModel = $fileMgr->saveFile($sid, $userId, $_FILES['files'], $description);

$files[] = $listItemModel;

$fileList = array('files' => $files);
echo json_encode($fileList);
?>