<?php

	include_once('Smarty.class.php');
    $main_smarty = new Smarty;
    
    include('config.php');
    include(mnminclude.'html1.php');
    include(mnminclude.'link.php');
    include(mnminclude.'tags.php');
    include(mnminclude.'user.php');
    include(mnminclude.'smartyvariables.php');
    
    // breadcrumbs and page titles
    $navwhere['text1'] = 'Wizard Page';
    $navwhere['link1'] = 'launchW.php';
    $main_smarty->assign('navbar_where', $navwhere);
    $main_smarty->assign('posttitle', 'Wizard');
    
    //pagename
    define('pagename', 'wizard');
    $main_smarty->assign('pagename', pagename);
    
    //sidebar
    $main_smarty = do_sidebar($main_smarty);
	

include("classes/easy_upload/upload_class.php"); //classes is the map where the class file is stored

$error = '';
$image = '';
$copy_link = '';
		
if (isset($_POST['Submit'])) {
	$my_upload = new file_upload();
	$my_upload->upload_dir = 'uploads/';//$_SERVER['DOCUMENT_ROOT']."/modal-upload/files/";
	$my_upload->extensions = array(".xlsx"); // allowed extensions
	$my_upload->rename_file = true;
	$my_upload->the_temp_file = $_FILES['upload']['tmp_name'];
	$my_upload->the_file = $_FILES['upload']['name'];
	$my_upload->http_error = $_FILES['upload']['error'];
	if ($my_upload->upload()) {
		$image = $my_upload->file_copy;
		$copy_link = ' | <a id="closelink" href="#" onclick="self.parent.tb_remove();">Pass file name</a>';
	} 
	$error = $my_upload->show_error_string();
}


	//show the template
    $main_smarty->assign('tpl_center', $the_template . '/wizard1');
    $main_smarty->display($the_template . '/pligg.tpl');
?>
