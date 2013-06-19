<?php
    require_once('FileManagers.php');  
    include_once('../libs/login.php');
    
    global $current_user;
    if(!$current_user->authenticated) die('Please login to use this function.');
    $fileId = $_GET['fileId'];
    
    SourceDesAttachmentManager::getInstance()->deleteFile($fileId, $current_user->user_id);
    echo $fileId;
?>