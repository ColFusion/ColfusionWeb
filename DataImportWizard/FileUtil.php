<?php

class FileUtil {

    public static function convertCSVtoXLSX($csvFilePath) {
        $xlsxFileName = pathinfo($csvFilePath, PATHINFO_FILENAME) . ".xlsx";
        $xlsxFilePath = pathinfo($csvFilePath, PATHINFO_DIRNAME) . "/$xlsxFileName";
        CSVToExcelConverter::convert(str_replace("\\", "/", $csvFilePath), $xlsxFilePath);
        return $xlsxFilePath;
    }

    public static function isCSVFile($filename) {
        $ext = pathinfo($filename, PATHINFO_EXTENSION);
        return stripos($ext, 'csv') !== false;
    }

    public static function isXLSFile($filename) {
        $ext = pathinfo($filename, PATHINFO_EXTENSION);
        return stripos($ext, 'xls') !== false;
    }

    public static function isXLSXFile($filename) {
        $ext = pathinfo($filename, PATHINFO_EXTENSION);
        return stripos($ext, 'xlsx') !== false;
    }

}

?>
