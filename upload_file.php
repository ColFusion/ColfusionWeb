<?php
    session_start();
    include_once('Smarty.class.php');
    $main_smarty = new Smarty;
    
    include('config.php');
    include(mnminclude.'html1.php');
    include(mnminclude.'link.php');
    include(mnminclude.'tags.php');
    include(mnminclude.'user.php');
    include_once(mnminclude.'utils.php');
    include(mnminclude.'smartyvariables.php');
    
    // breadcrumbs and page titles
    $navwhere['text1'] = 'Upload Local File';
    $navwhere['link1'] = 'uploadlocalfile.php';
    $main_smarty->assign('navbar_where', $navwhere);
    $main_smarty->assign('posttitle', 'Upload Local File');
 
	 if($current_user->authenticated != TRUE)
    {
		$vars = '';
		check_actions('anonymous_story_user_id', $vars);
		if ($vars['anonymous_story'] != true)
			force_authentication();
	}

    //pagename
    define('pagename', 'uploadlocalfile');
    $main_smarty->assign('pagename', pagename);
    
    //define upload direction
    //$upload_dir =get_misc_data('raw_data_directory');
	
	    
    // determine which step of the submit process we are on
    if(isset($_POST["phase"]) && is_numeric($_POST["phase"]))
    	$phase = $_POST["phase"];
    else if(isset($_GET["phase"]) && is_numeric($_GET["phase"]))
    	$phase = $_GET["phase"];
    else
    	$phase = 0;
    	
    switch ($phase) {
		case 0:
			upload_0();
			break;
		case 1:
			upload_1();
			break;
		case 2:
			upload_2();
			break;
	}
    
    function upload_0(){
    
    	global $main_smarty, $the_template;
    	
    	//show the template
    	$main_smarty->assign('tpl_center', $the_template . '/upload_file');
    	$main_smarty->display($the_template . '/pligg.tpl');
    }
    
    function upload_1(){   
    	global $upload_dir, $db, $current_user;
		
    	//save upload file	     
		if ($_FILES['upload_file']['error'] > 0) {	
			$error = "ERROR: ".get_file_err($_FILES['upload_file']['error'])."</br>";
			$_SESSION['upload_file']=array('error' => $error);		
		} else {		
		// the file name that should be uploaded		
			$file_tmp=$_FILES['upload_file']['tmp_name']; 
			$file_name=$_FILES['upload_file']['name']; 
			$unique_file_name=$current_user->user_login."_".$file_name;
			$upload_dir = get_misc_data('raw_data_directory');
			$upload_path=mnmpath.$upload_dir.$unique_file_name;
			if(file_exists($upload_path)){
			
				$error = "ERROR: Already exits.</br>";
				$_SESSION['upload_file']=array('error' => $error);
			
			} else 
			{
			
				$upload = move_uploaded_file($file_tmp, $upload_path);
				echo $upload;		
		
				// check upload status
				if (!$upload) { 
					
					$error = "ERROR:failed to save. </br>";
					$_SESSION['upload_file']=array('error' => $error);
				
				} else {
					
					$sql="INSERT INTO ".table_prefix."files 
								SET file_user_id={$current_user->user_id},
							    file_real_size='{$_FILES['upload_file']['size']}',
						    	file_name='".$db->escape("$upload_path")."'";
					$db->query($sql);
					$loc_msg = my_base_url.my_pligg_base.$upload_dir.$unique_file_name;
					$_SESSION['upload_file']=array('loc' => $loc_msg);
				}
			}			
		}							
	}
	function upload_2(){					
		if($_SESSION['upload_file']['error'])		
			echo $_SESSION['upload_file']['error'];		
		else if($_SESSION['upload_file']['loc'])	
			echo $_SESSION['upload_file']['loc'];		
		else
			echo "ERROR: Failed";
	}
?>