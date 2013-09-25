<?php

require 'PHPUnit/Autoload.php';
require_once 'PHPUnit/TextUI/TestRunner.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/ExternalDBHandlers/PostgreSQLHandler.php';

class PostgreSQLHandlerTest extends PHPUnit_Framework_TestCase {

    private $host = 'localhost';
    private $port = 5432;
    private $user = 'ExternalConnTester';
    private $password = 'gz3000gz3000';
    private $database = 'colfusion_test';
   
    public function testLoadTables() {
        $mysqlHandler = new PostgreSQLHandler($this->user, $this->password, $this->database, $this->host, $this->port);
        $this->assertGreaterThan(10, $mysqlHandler->LoadTables());
    }
  
    public function testGetColumnsForSelectedTables() {
        $mysqlHandler = new PostgreSQLHandler($this->user, $this->password, $this->database, $this->host, $this->port);
        $cols = $mysqlHandler->GetColumnsForSelectedTables(['colfusion_dnameinfo', 'colfusion_temporary']);
        $this->assertGreaterThan(5, count($cols['colfusion_dnameinfo']));
        $this->assertGreaterThan(5, count($cols['colfusion_temporary']));
    }
   
    public function testGetTableData() {
        $mysqlHandler = new PostgreSQLHandler($this->user, $this->password, $this->database, $this->host, $this->port);
        $rows = $mysqlHandler->GetTableData('colfusion_dnameinfo');
        $this->assertEquals(0, count($rows));
    }

    public function testTotalNumberTuplesInTable() {
        $mysqlHandler = new PostgreSQLHandler($this->user, $this->password, $this->database, $this->host, $this->port);
        $rows = $mysqlHandler->GetTotalNumberTuplesInTable('colfusion_temporary');
        $this->assertEquals(0, $rows);
    }
}

// run the test
// $suite = new PHPUnit_Framework_TestSuite('PostgreSQLHandlerTest');
// PHPUnit_TextUI_TestRunner::run($suite);
?>

