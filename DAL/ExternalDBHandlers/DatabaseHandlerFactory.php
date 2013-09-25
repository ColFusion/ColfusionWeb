<?php

//require_once(realpath(dirname(__FILE__)) . "/DatabaseHandler.php");
require_once(realpath(dirname(__FILE__)) . "/MySQLHandler.php");
require_once(realpath(dirname(__FILE__)) . "/MSSQLHandler.php");
require_once(realpath(dirname(__FILE__)) . "/PostgreSQLHandler.php");

class DatabaseHandlerFactory {
       
    public static function createDatabaseHandler($engine, $user, $password, $database, $host, $port, $isImported, $linkedServerName) {
        //var_dump($engine);
        switch (strtolower($engine)) {
            case 'mysql':
                return new MySQLHandler($user, $password, $database, $host, $port, $isImported, $linkedServerName);
                break;
            case 'mssql':
            case 'sql server':
                return new MSSQLHandler($user, $password, $database, $host, $port, $isImported, $linkedServerName);
                break;
            case 'postgresql':
                return new PostgreSQLHandler($user, $password, $database, $host, $port, $isImported, $linkedServerName);
                break;
            case 'oracle':
                break;
            default:
                throw new Exception('Invalid DBMS');
                break;
        }
    }

}

?>
