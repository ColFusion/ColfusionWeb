<?php

require_once realpath(dirname(__FILE__)) . '/MySQLImporter.php';
require_once realpath(dirname(__FILE__)) . '/PostgreSQLImporter.php';
require_once realpath(dirname(__FILE__)) . '/OracleImporter.php';

class DatabaseImporterFactory {

    public static $importSettings = array(
        "mysql" => array('user' => 'ImportTester', 'password' => 'importtester', 'port' => 3306),
        "mssql" => array('user' => 'ExternalConnTester', 'password' => 'gz3000gz3000', 'port' => 1433),
        "postgresql" => array('user' => 'ImportTester', 'password' => 'importtester', 'port' => 5432),
        "oracle" => array('user' => 'Colfusion1', 'password' => 'Colfusion1', 'port' => 1521)
    );

    public static function createDatabaseImporter($engine, $sid, $prefix = "colfusion") {

        $user = DatabaseImporterFactory::$importSettings[$engine]['user'];
        $password = DatabaseImporterFactory::$importSettings[$engine]['password'];
        $port = DatabaseImporterFactory::$importSettings[$engine]['port'];
        $host = 'localhost';
        $database = "$prefix" . "_external_$sid";

        switch (strtolower($engine)) {
            case 'mysql':
                return new MySQLImporter($user, $password, $database, $host, $port, strtolower($engine));
                break;
            case 'mssql':
            case 'sql server':
                return new MSSQLImporter($user, $password, $database, $host, $port, strtolower($engine));
                break;
            case 'postgresql':
                return new PostgreSQLImporter($user, $password, $database, $host, $port, strtolower($engine));
                break;
            case 'oracle':
                return new OracleImporter($user, $password, $database, $host, $port, strtolower($engine));
                break;
            default:
                throw new Exception('Invalid DBMS');
                break;
        }
    }

}

?>
