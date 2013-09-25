<?php

require 'PHPUnit/Autoload.php';
require_once 'PHPUnit/TextUI/TestRunner.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/ExternalDBHandlers/MySQLHandler.php';

mysqli_report(MYSQLI_REPORT_ALL);

class MySQLHandlerTest extends PHPUnit_Framework_TestCase {

    private $host = 'localhost';
    private $port = 3306;
    private $user = 'root';
    private $password = '';
    private $database = 'colfusion';
  
    public function testConnectionExcpetion() {
        $isCatched = false;
        try {
            $mysqlHandler = new MySQLHandler('', '', '', 'a fail host');
            $mysqlHandler->getConnection();
        } catch (PDOException $e) {
            echo $e->getMessage();
            $isCatched = true;
        }
        $this->assertTrue($isCatched);
    }

    public function testLoadTables() {
        $mysqlHandler = new MySQLHandler($this->user, $this->password, $this->database, $this->host, $this->port);
        $this->assertGreaterThan(10, $mysqlHandler->LoadTables());
    }

    public function testGetColumnsForSelectedTables() {
        $mysqlHandler = new MySQLHandler($this->user, $this->password, $this->database, $this->host, $this->port);
        $cols = $mysqlHandler->GetColumnsForSelectedTables(['colfusion_dnameinfo', 'colfusion_temporary']);
        $this->assertGreaterThan(5, count($cols['colfusion_dnameinfo']));
        $this->assertGreaterThan(5, count($cols['colfusion_temporary']));
    }

    public function testGetTableData() {
        $mysqlHandler = new MySQLHandler($this->user, $this->password, $this->database, $this->host, $this->port);
        $rows = $mysqlHandler->GetTableData('colfusion_dnameinfo');
        $this->assertEquals(10, count($rows));
    }

    public function testTotalNumberTuplesInTable() {
        $mysqlHandler = new MySQLHandler($this->user, $this->password, $this->database, $this->host, $this->port);
        $rows = $mysqlHandler->GetTotalNumberTuplesInTable('colfusion_dnameinfo');
        $this->assertGreaterThan(10, $rows);
    }

}

// run the test
//$suite = new PHPUnit_Framework_TestSuite('MySQLHandlerTest');
//PHPUnit_TextUI_TestRunner::run($suite);
?>

