<?php

require_once '../Classes/PHPExcel.php';

class NothingFilter implements PHPExcel_Reader_IReadFilter {

    public function readCell($column, $row, $worksheetName = '') {
        return false;
    }
}

?>
