<?php
define("EZSQL_DB_USER", 'dataverse');//dataverse
define("EZSQL_DB_PASSWORD", 'dataverse');//dataverse
define("EZSQL_DB_NAME", 'colfusion');
define("EZSQL_DB_HOST", '192.168.33.11'); // The IP of the vagrant VM
if (!function_exists('gettext')) {
	function _($s) {return $s;}
}
?>
