<?php

class MatchSchemaFilter implements PHPExcel_Reader_IReadFilter {

    // $sheetsRange = ['sheetName' => [startRow, startColumn, rowNum]]
    private $sheetsRange;

    public function __construct($sheetsRange) {
        $this->sheetsRange = $sheetsRange;
    }

    public function readCell($column, $row, $worksheetName = '') {
        if (isset($this->sheetsRange["$worksheetName"]) 
                && $row == $this->sheetsRange["$worksheetName"]['startRow'] 
                && $column >= $this->sheetsRange["$worksheetName"]['startColumn']) {
            return true;
        }
        return false;
    }

}

class MatchSchemaExcelProcessor extends Process_excel {

    public function __construct($filePath, $sheetsRange) {
        $filter = new MatchSchemaFilter($sheetsRange);
        parent::__construct($filePath, $filter);
    }

}

?>
