<?php

require_once(realpath(dirname(__FILE__)) . '/../config.php');

define("FILETODB_DB_USER", 'dataverse');
define("FILETODB_DB_PASSWORD", 'dataverse');
define("FILETODB_DB_NAMEPREFIX", my_pligg_base_no_slash . '_fileToDB_');
define("FILETODB_DB_HOST", 'localhost');
define("FILETODB_DB_PORT", '3306');
define("FILETODB_DB_ENGINE", 'mysql');

?>