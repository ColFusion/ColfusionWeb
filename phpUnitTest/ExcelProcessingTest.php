<?php

require 'PHPUnit/Autoload.php';
require_once 'PHPUnit/TextUI/TestRunner.php';
require_once '../Classes/PHPExcel.php';
require_once '../DataImportWizard/process_excelV2.php';
require_once '../Classes/CSVToExcelConverter.php';

class ExcelProcessingTest extends PHPUnit_Framework_TestCase {

    public function testLoadExcelFile() {
        $filePath = realpath('./file/State_list.xls');
        $this->assertFileExists($filePath);

        $excelProcessor = new Process_excel($filePath);
        return $excelProcessor;
    }

    /**
     * @depends testLoadExcelFile
     */
    public function testSheetsName($excelProcessor) {
        $testSheets = array("Sheet1", "Sheet2", "Sheet3");
        $excelSheets = Process_excel::getSheetName($excelProcessor->getFilePath());
        $this->assertEquals(count(array_diff($testSheets, $excelSheets)), 0);
    }

    public function testGuessDelimiter() {
        $csv_file = realpath('./file/State list -- dv1.csv');
        $tsv_file = realpath('./file/State list_tsv -- dv1.csv');
        $this->assertEquals(CSVToExcelConverter::guessDelimiter($csv_file), ',');
        $this->assertEquals(CSVToExcelConverter::guessDelimiter($tsv_file), '	');
    }

}

// run the test
$suite = new PHPUnit_Framework_TestSuite('ExcelProcessingTest');
PHPUnit_TextUI_TestRunner::run($suite);
?>