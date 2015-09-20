<?php
require_once('Smarty.class.php');

class OriginalSmarty extends Smarty {
    function __construct() {
        parent::__construct();
        $this->caching = false;
        
        $this->template_dir = SMARTY_DIR . 'templates'; // $path . '/OriginalSmarty/templates/';
        $this->compile_dir = SMARTY_DIR . 'templates_c'; //$path . '/OriginalSmarty/templates_c/';
        $this->config_dir = SMARTY_DIR . 'configs'; //$path . '/OriginalSmarty/configs/';
        $this->cache_dir = SMARTY_DIR . 'cache'; // $path . '/OriginalSmarty/cache/';
    
        $appRootPath = str_replace("fileManagers", "", my_pligg_base);

        // global variables.
        $this->assign('appRootPath', $appRootPath);
    }
}
?>
