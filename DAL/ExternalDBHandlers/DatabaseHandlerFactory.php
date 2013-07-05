<?php

require_once(realpath(dirname(__FILE__)) . "/DatabaseHandler.php");
require_once(realpath(dirname(__FILE__)) . "/MySQLHandler.php");
require_once(realpath(dirname(__FILE__)) . "/MSSQLHandler.php");
require_once(realpath(dirname(__FILE__)) . "/PostgreSQLHandler.php");

class DatabaseHandlerFactory {

    public static function createDatabaseHandler($database, $user, $password, $database, $host, $port) {
        switch (strtolower($database)) {
            case 'mysql':
                return new MySQLHandler($user, $password, $database, $host, $port);
                break;
            case 'mssql':
            case 'sql server':
                return new MSSQLHandler($user, $password, $database, $host, $port);
                break;
            case 'postgresql':
                return new PostgreSQLHandler($user, $password, $database, $host, $port);
                break;
            case 'oracle':
                break;
        }
    }

}

?>
