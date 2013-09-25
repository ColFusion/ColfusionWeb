<?php

include_once('../config.php');
require_once '../DataImportWizard/KTRManager.php';

$ktrManager = new KTRManager('../DataImportWizard/excel-to-target_schema.ktr', '../temp/testManager.ktr');

$fileUrls = ['file1.xls', 'file2.xls', 'file3.xls'];
$sheetNamesRowsColumns = [['Sheet1', 'Sheet2'], [1, 2], ['A', 'B']];
$ktrManager->createTemplate($fileUrls, $sheetNamesRowsColumns);

?>
