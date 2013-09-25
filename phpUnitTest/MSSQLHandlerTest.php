<?php

require 'PHPUnit/Autoload.php';
require_once 'PHPUnit/TextUI/TestRunner.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/ExternalDBHandlers/MSSQLHandler.php';

class MSSQLHandlerTest extends PHPUnit_Framework_TestCase {

    private $host = 'localhost';
    private $port = 1433;
    private $user = 'ExternalConnTester';
    private $password = 'gz3000gz3000';
    private $database = 'learnSystemDev';

    public function testLoadTables() {
        $mysqlHandler = new MSSQLHandler($this->user, $this->password, $this->database, $this->host, $this->port);
        $this->assertGreaterThan(10, $mysqlHandler->LoadTables());
    }
  
    public function testGetColumnsForSelectedTables() {
        $mysqlHandler = new MSSQLHandler($this->user, $this->password, $this->database, $this->host, $this->port);
        $cols = $mysqlHandler->GetColumnsForSelectedTables(['Category', 'LM']);
        $this->assertGreaterThan(5, count($cols['Category']));
        $this->assertGreaterThan(5, count($cols['LM']));
    }
   
    public function testGetTableData() {
        $mysqlHandler = new MSSQLHandler($this->user, $this->password, $this->database, $this->host, $this->port);
        $rows = $mysqlHandler->GetTableData('Category');
        $this->assertEquals(10, count($rows));
    }

    public function testTotalNumberTuplesInTable() {
        $mysqlHandler = new MSSQLHandler($this->user, $this->password, $this->database, $this->host, $this->port);
        $rows = $mysqlHandler->GetTotalNumberTuplesInTable('LM');
        $this->assertGreaterThan(10, $rows);
    }
}

?>

