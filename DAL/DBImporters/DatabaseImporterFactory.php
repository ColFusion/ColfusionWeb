<?php

require_once realpath(dirname(__FILE__)) . '/MySQLImporter.php';
require_once realpath(dirname(__FILE__)) . '/PostgreSQLImporter.php';

class DatabaseImporterFactory {

    public static $importSettings = array(
        "mysql" => array('user' => 'root', 'password' => '', 'port' => 3306),
        "mssql" => array('user' => 'ExternalConnTester', 'password' => 'gz3000gz3000', 'port' => 1433),
        "postgresql" => array('user' => 'ImportTester', 'password' => 'importtester', 'port' => 5432)
    );

    public static function createDatabaseImporter($engine, $sid) {
        
        $user = DatabaseImporterFactory::$importSettings[$engine]['user'];
        $password = DatabaseImporterFactory::$importSettings[$engine]['password'];
        $port = DatabaseImporterFactory::$importSettings[$engine]['port'];
        $host = 'localhost';
        $database = "colfusion_external_$sid";
        
        switch (strtolower($engine)) {
            case 'mysql':
                return new MySQLImporter($user, $password, $database, $host, $port);
                break;
            case 'mssql':
            case 'sql server':
                return new MSSQLImporter($user, $password, $database, $host, $port);
                break;
            case 'postgresql':
                return new PostgreSQLImporter($user, $password, $database, $host, $port);
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
