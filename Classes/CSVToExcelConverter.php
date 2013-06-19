<?php

require_once('PHPExcel.php');

class CSVToExcelConverter {

    /**
     * Read given csv file and write all rows to given xls file 
     *  
     * @param string $csv_file Resource path of the csv file 
     * @param string $xls_file Resource path of the excel file 
     * @param string $csv_enc Encoding of the csv file, use utf8 if null 
     * @throws Exception 
     */
    public static function convert($csv_file, $xls_file, $csv_enc = null) {
        //set cache 
        $cacheMethod = PHPExcel_CachedObjectStorageFactory::cache_to_phpTemp;
        PHPExcel_Settings::setCacheStorageMethod($cacheMethod);

        //open csv file 
        $objReader = new PHPExcel_Reader_CSV();
        $objReader->setDelimiter(CSVToExcelConverter::guessDelimiter($csv_file));
        if ($csv_enc != null)
            $objReader->setInputEncoding($csv_enc);
        $objPHPExcel_CSV = $objReader->load($csv_file);
        $in_sheet = $objPHPExcel_CSV->getActiveSheet();

        //open excel file 
        $objPHPExcel_XLSX = new PHPExcel();
        $out_sheet = $objPHPExcel_XLSX->getActiveSheet();
        $out_sheet->setTitle('File Content');

        //row index start from 1 
        $row_index = 0;
        foreach ($in_sheet->getRowIterator() as $row) {
            $row_index++;
            $cellIterator = $row->getCellIterator();
            $cellIterator->setIterateOnlyExistingCells(false);

            //column index start from 0 
            $column_index = -1;
            foreach ($cellIterator as $cell) {
                $column_index++;
                $out_sheet->setCellValueByColumnAndRow($column_index, $row_index, $cell->getValue());
            }
        }

        //write excel file 
        $objWriter = new PHPExcel_Writer_Excel2007($objPHPExcel_XLSX);
        $objWriter->save($xls_file);
    }

    public static function guessDelimiter($csv_filePath) {
        $csv_file = fopen($csv_filePath, "r");

        $commaCount = $tabCount = 0;
        $i = 0;
        while (!feof($csv_file) && $i < 5) {
            $i++;
            $currentLine = fgets($csv_file, 0xff);
            $tabCount += substr_count($currentLine, '	');
            $commaCount += substr_count($currentLine, ',');
        }

        fclose($csv_file);
        return ($commaCount <= $tabCount) ? '	' : ',';
    }

}