<?php     
    if(!isset($_GET['sid']) || is_int($_GET['sid'])) die;
    
    require_once(realpath(dirname(__FILE__)) . '/FileManagers.php');
    require_once(realpath(dirname(__FILE__)) . '/../OriginalSmarty/OriginalSmarty.class.php');
    
    include_once(realpath(dirname(__FILE__)) . '/../libs/login.php');
    global $current_user;
    if(!$current_user->authenticated) die('Please login to use this function.');
    
    $model = SourceDesAttachmentManager::getInstance()->createFileUploadPageModel();
    
    // Assign model to template. 
    $smarty = new OriginalSmarty();
    $smarty->assign('model', $model);
    $smarty->assign('sid', $_GET['sid']);
    $smarty->display('sourceAttachmentUploadPage.tpl');
?>