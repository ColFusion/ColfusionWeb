<?php
require_once('Smarty.class.php');

class OriginalSmarty extends Smarty {
    function __construct() {
       // $path = $_SERVER["DOCUMENT_ROOT"];
      //  if($path{strlen($path)-1} != '/') $path .= '/';
      //  $path = $path.'Colfusion';

        parent::__construct();
        $this->caching = false;
        
        $this->template_dir = SMARTY_DIR . 'templates'; // $path . '/OriginalSmarty/templates/';
        $this->compile_dir = SMARTY_DIR . 'templates_c'; //$path . '/OriginalSmarty/templates_c/';
        $this->config_dir = SMARTY_DIR . 'configs'; //$path . '/OriginalSmarty/configs/';
        $this->cache_dir = SMARTY_DIR . 'cache'; // $path . '/OriginalSmarty/cache/';
        
        // global variables.
        $this->assign('appRootPath', my_pligg_base);
    }
}
?>
