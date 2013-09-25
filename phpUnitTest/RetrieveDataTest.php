<?php

// PHPUnit is under pear folder and should be included in env path.
require 'PHPUnit/Autoload.php';
require_once 'PHPUnit/TextUI/TestRunner.php';
require_once realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php';
require_once realpath(dirname(__FILE__)) . '/../visualization/VisualizationAPI.php';

class RetrieveDataTest extends PHPUnit_Framework_TestCase {

    public function testGetTableDataBySidAndTableName(){
        $sid = 2122;
        $table_name = 's6.xlsx';
        $perPage = 10;
        $pageNo = 1;
        
        $expected = array();
        $expected['data'][] = array('rownum' => "1", "F" => "F1", "G" => "G1");
        $expected['data'][] = array('rownum' => "2", "F" => "F2", "G" => "G2");
        $expected['data'][] = array('rownum' => "3", "F" => "F3", "G" => "G3");
        $expected['Control'] = array('perPage' => $perPage, 'totalPage' => 1, 'pageNo' => $pageNo, 'cols' => "rownum,F,G");
        
        $result = GetTableData($sid, $table_name, $perPage, $pageNo);
        $this->assertEquals(json_encode($result), json_encode($expected));
    }
}

$suite = new PHPUnit_Framework_TestSuite('RetrieveDataTest');
PHPUnit_TextUI_TestRunner::run($suite);