<?php

require 'PHPUnit/Autoload.php';
require_once 'PHPUnit/TextUI/TestRunner.php';
require_once realpath(dirname(__FILE__)) . '/../../DAL/DBImporters/DatabaseImporterFactory.php';
require_once realpath(dirname(__FILE__)) . '/../../DAL/DBImporters/MySQLImporter.php';
require_once realpath(dirname(__FILE__)) . '/../../DAL/DBImporters/PostgreSQLImporter.php';
require_once realpath(dirname(__FILE__)) . '/../../DAL/DBImporters/MSSQLImporter.php';

class ImporterTest extends PHPUnit_Framework_TestCase {
    /*
      public function testMySQLImport() {
      $sid = 12345;
      $filePath = 'E:/colfusion_test_files/mysql.sql';
      $mysqlHandler = DatabaseImporterFactory::createDatabaseImporter('mysql', $sid);
      $mysqlHandler->importSqlFile($filePath);
      //$dbh = new PDO("mysql:host=localhost", 'root', '');
      //$db = $mysqlHandler->getDatabase();
      //$dbh->exec("drop database $db");
      }
        */
      public function testPostgreSQLImport() {
      $sid = 12345;
      $filePath = 'E:/colfusion_test_files/postgre.sql';
      $pgHandler = DatabaseImporterFactory::createDatabaseImporter('postgresql', $sid);
      $pgHandler->importSqlFile($filePath);
      $dbh = new PDO("pgsql:host=localhost;dbname=postgres", 'ImportTester', 'importtester');
      $db = $pgHandler->getDatabase();
      $dbh->exec("drop database $db");
      }
     
/*
    public function testMSSQLImport() {
        $sid = 12345;
        $filePath = 'E:/colfusion_test_files/mssql_schema.sql';
        $mssqlImporter = DatabaseImporterFactory::createDatabaseImporter('mssql', $sid);
        $mssqlImporter->importSqlFile($filePath);
        //$dbh = new PDO("sqlsrv:Server=localhost;Database=master", 'ExternalConnTester', 'gz3000gz3000');
        //$db = $mssqlImporter->getDatabase();
        //$dbh->exec("drop database $db");
    }
*/
}
?>

