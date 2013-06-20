<?php

require_once(realpath(dirname(__FILE__)) . '/FileManagers.php');
$fileId = $_GET['fileId'];
$fileInfo = SourceDesAttachmentManager::getInstance()->downloadFile($fileId);

if ($fileInfo === null || !file_exists($fileInfo->path)) die('File Not Found.');

header("Content-type:application");
header("Content-Length: " . $fileInfo->Size);
header("Content-Disposition: attachment; filename=" . $fileInfo->Title);
readfile($fileInfo->path);

?>
