<?php

class ChunckFilter implements PHPExcel_Reader_IReadFilter {

    // $sheetsRange = ['sheetName' => [startRow, startColumn, rowNum]]
    private $previewPage;
    private $previewRowsPerPage;

    function __construct($previewPage, $previewRowsPerPage) {
        $this->previewPage = $previewPage;
        $this->previewRowsPerPage = $previewRowsPerPage;
    }

    public function readCell($column, $row, $worksheetName = '') {

        if ($row > ($this->previewPage - 1) * $this->previewRowsPerPage && $row <= $this->previewPage * $this->previewRowsPerPage) {
            return true;
        }
        return false;
    }

}

class PreviewExcelProcessor extends Process_excel {
    
    private $currentPage;
    private $rowsPerpPage;
    
    public function __construct($filePath, $previewPage = 1, $previewRowsPerPage = 20) {
        $this->currentPage = $previewPage;
        $this->rowsPerpPage = $previewRowsPerPage;
        $filter = new ChunckFilter($previewPage, $previewRowsPerPage);
        parent::__construct($filePath, $filter);
    }

    public function getCurrentPage(){
        return $this->currentPage;
    }
    
    public function getRowsPerPage(){
        return $this->rowsPerpPage;
    }
}

?>
