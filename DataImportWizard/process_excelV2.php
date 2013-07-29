<?php

/** Error reporting */
error_reporting(E_ALL ^ E_STRICT ^ E_NOTICE);

define('EOL', (PHP_SAPI == 'cli') ? PHP_EOL : '<br />');

/** Include PHPExcel */
require_once '../Classes/PHPExcel.php';

// cannot work.
/*
  $cacheMethod = PHPExcel_CachedObjectStorageFactory::cache_to_phpTemp;
  $cacheSettings = array('memoryCacheSize' => '16MB');
  PHPExcel_Settings::setCacheStorageMethod($cacheMethod, $cacheSettings);
 */

class Process_excel {

    protected $filePath;
    protected $PHPExcel;
    protected $PHPExcelReader;

    function __construct($filePath, $filter = null) {
        $this->filePath = str_replace('\\', '/', $filePath);
        $this->PHPExcelReader = Process_excel::createExcelReader($this->filePath);
        $this->PHPExcelReader->setReadDataOnly(true);
        if (isset($filter)) {
            $this->PHPExcelReader->setReadFilter($filter);
        }
        $this->PHPExcel = $this->PHPExcelReader->load($filePath);
    }

    public static function createExcelReader($filePath) {
        $readerType = PHPExcel_IOFactory::identify($filePath);
        return PHPExcel_IOFactory::createReader($readerType);
    }

    public static function getSheetName($filePath) {
        $reader = Process_excel::createExcelReader($filePath);
        $infos = $reader->listWorksheetInfo($filePath);
        foreach ($infos as $info) {
            if ($info['totalRows'] > 0) {
                $sheetAllName[] = $info['worksheetName'];
            }
        }
        return $sheetAllName;
    }

    public static function getSheetNameIndex($filePath, $sheetName) {
        $reader = Process_excel::createExcelReader($filePath);
        $infos = $reader->listWorksheetInfo($filePath);

        for ($i = 0; $i < count($infos); $i++) {
            if ($infos[$i]['worksheetName'] == $sheetName) {
                return $i;
            }
        }
    }

    //Get header after user choose start row and start column
    public function getHeader($currentSheetNum, $startRow, $startColumn) {

        $this->isFilepathReadable();
        $headerArray = array();

        $startColumn = PHPExcel_Cell::columnIndexFromString($startColumn) - 1;
        $currentSheet = $this->PHPExcel->getSheet($currentSheetNum);
        $lastColumn = $currentSheet->getHighestColumn();
        $lastColumn = PHPExcel_Cell::columnIndexFromString($lastColumn) - 1;

        for ($column = $startColumn; $column <= $lastColumn; $column++) {
            $cell = $currentSheet->getCellByColumnAndRow($column, $startRow)->getCalculatedValue();
            if (!is_null($cell)) {
                $headerArray[PHPExcel_Cell::stringFromColumnIndex($column)] = $cell;
            }
        }

        return $headerArray;
    }

    // ['sheetName' => [[], []]]
    public function getCellData() {
        $worksheetsName = $this->getSheetName($this->filePath);

        $worksheetsCells = array();
        foreach ($worksheetsName as $worksheetName) {
            $worksheet = $this->PHPExcel->getSheetByName($worksheetName);

            foreach ($worksheet->getRowIterator() as $row) {
                $cellIterator = $row->getCellIterator();

                $rowValue = array();
                foreach ($cellIterator as $cell) {
                    $cellValue = trim($cell->getValue());
                    if ($cellValue != '') {
                        $rowValue[] = $cellValue;
                    }
                }

                if (count($rowValue) > 0) {
                    $worksheetsCells[$worksheetName][] = $rowValue;
                }
            }
        }

        return $worksheetsCells;
    }

    public function getFilePath() {
        return $this->filePath;
    }

    public function unloadPHPExcelObj() {
        if (isset($this->PHPExcel)) {
            $this->PHPExcel->disconnectWorksheets();
        }
        unset($this->PHPExcel);
    }

    private function isFilepathReadable() {
        if (!$this->PHPExcelReader->canRead($this->filePath)) {
            throw new Exception('File is invalid.');
        }
    }

}

?>