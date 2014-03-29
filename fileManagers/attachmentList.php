<?php
	include_once(realpath(dirname(__FILE__)) . '/FileManagers.php');
	require_once(realpath(dirname(__FILE__)) . '/../OriginalSmarty/OriginalSmarty.class.php');

	$sid = $_POST['sid'];
	$allowDeleteFiles = $_POST['allowDeleteFiles'];

	$attachmentInfos = SourceDesAttachmentManager::getInstance()->getSourceAttachmentsInfo($sid);

	// Assign model to template. 
	$smarty = new OriginalSmarty();
	$smarty->assign('attachmentInfos', $attachmentInfos);
	$smarty->assign('allowDeleteFiles', $allowDeleteFiles);
	$smarty->display('attachmentList.tpl');
?>
