<?php

require 'PHPUnit/Autoload.php';
require_once 'PHPUnit/TextUI/TestRunner.php';
require_once '../DAL/DatasetFinder.php';

class DatasetFinderTest extends PHPUnit_Framework_TestCase {

    public function testFindBySid() {
        $finder = new DatasetFinder();
        $sid = 752;
        $dataset = $finder->findDatasetInfoBySid($sid);

        $this->assertEquals($sid, $dataset->sid);
        $this->assertEquals('dataverse', $dataset->userName);
        $this->assertEquals('State list', $dataset->title);
    }

    public function testFindByName() {
        $finder = new DatasetFinder();
        $dsName = 'State';
        $dataset = $finder->findDatasetInfoByName($dsName);

        $this->assertEquals(752, $dataset[0]->sid);
        $this->assertEquals('dataverse', $dataset[0]->userName);
        $this->assertEquals('State list', $dataset[0]->title);
    }

    public function testFindBySidOrName_hasDataset() {
        $finder = new DatasetFinder();
        $searchTerm = 'State';
        $datasetsInfo = $finder->findDatasetInfoBySidOrName($searchTerm);

        $this->assertEquals(2, count($datasetsInfo));
        $this->assertEquals(752, $datasetsInfo[0]->sid);
        $this->assertEquals(753, $datasetsInfo[1]->sid);
    }

    public function testFindBySidOrName_noDataset() {
        $finder = new DatasetFinder();
        $searchTerm = '112   ';
        $datasetsInfo = $finder->findDatasetInfoBySidOrName($searchTerm);

        $this->assertEquals(0, count($datasetsInfo));
    }

}

// run the test
$suite = new PHPUnit_Framework_TestSuite('DatasetFinderTest');
PHPUnit_TextUI_TestRunner::run($suite);
?>
