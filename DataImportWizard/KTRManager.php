<?php

class KTRManager {

    private $ktrTemplatePath;
    private $ktrFilePath;
    private $ktrXml;
    private $addedConstants;
    private $updatedColAndStreamNames;

    public function __construct($ktrTemplatePath, $ktrFilePath) {
        $this->ktrTemplatePath = $ktrTemplatePath;
        $this->ktrFilePath = $ktrFilePath;
    }

    public function createTemplate($fileURLs, $sheetNamesRowsColumns, $baseHeader, $dataMatchingUserInputs) {

        copy($this->ktrTemplatePath, $this->ktrFilePath);
        $this->ktrXml = simplexml_load_file($this->ktrFilePath);

        $this->changeConnection();
        $this->changeSheetType();
        $this->addUrls($fileURLs);
        $this->addSheets($sheetNamesRowsColumns);
        $this->clearConstantAndTarget();
        $this->addSampleTarget();
        foreach ($this->addedConstants as $constant) {
            $this->addConstantIntoFile($constant->name1, $constant->value, $constant->type, $constant->format);
        }
        foreach ($this->updatedColAndStreamNames as $colAndStmName) {
            $this->updateColumnAndStreamNameIntoFile($colAndStmName->name1, $colAndStmName->value1);
        }
        $this->addNormalizer($baseHeader, $dataMatchingUserInputs);

        file_put_contents($this->ktrFilePath, $this->ktrXml->asXML());
    }

    private function changeConnection() {

        $connectdatabase = constant("EZSQL_DB_NAME");
        $connectusername = constant("EZSQL_DB_USER");
        $connectpassword = constant("EZSQL_DB_PASSWORD");

        $this->ktrXml->connection[0]->database = $connectdatabase;
        $this->ktrXml->connection[0]->username = $connectusername;
        $this->ktrXml->connection[0]->password = $connectpassword;
    }

    private function changeSheetType() {
        $sheetTypeNodes = $this->ktrXml->xpath('//step/spreadsheet_type[@id="sheet_type"]');
        $sheetTypeNodes[0] = "POI";
    }

    private function addUrls($fileURLs) {

        $xmldoc = $this->ktrXml;
        $fileNodes = $xmldoc->xpath('//step/file');
        $fileNode = $fileNodes[0];

        foreach ($fileURLs as $fileURL) {
            $fileNode->addChild('name', $fileURL);
            $fileNode->addChild('filemask');
            $fileNode->addChild('exclude_filemask');
            $fileNode->addChild('file_required', 'N');
            $fileNode->addChild('include_subfolders', 'N');
        }

        // Delete template nodes.  
        unset($fileNode->name[0]);
        unset($fileNode->filemask[0]);
        unset($fileNode->exclude_filemask[0]);
        unset($fileNode->file_required[0]);
        unset($fileNode->include_subfolders[0]);
    }

    private function addSheets($sheetNamesRowsColumns) {

        $steps = $this->ktrXml->step;

        foreach ($steps as $step) {
            $name = $step->name;
            if ($name == 'Excel Input File') {

                $sheets = $step->sheets;
                while (count($sheets->sheet) > 0) {
                    unset($sheets->sheet[0]);
                }

                for ($i = 0; $i < count($sheetNamesRowsColumns[0]); $i++) {
                    $sheet = $sheets->addChild('sheet');
                    $sheet->addChild('name', $sheetNamesRowsColumns[0][$i]);
                    $sheet->addChild('startrow', $sheetNamesRowsColumns[1][$i]);
                    $sheet->addChild('startcol', $sheetNamesRowsColumns[2][$i]);
                }
            }
        }
    }

    private function clearConstantAndTarget() {

        $steps = $this->ktrXml->step;

        foreach ($steps as $step) {
            $name = $step->name;
            if ($name == 'Add Constants' || $name == 'Target Schema') {
                $fields = $step->fields;
                while (count($fields->field) > 0) {
                    $fields->field[0];
                    unset($fields->field[0]);
                }
            }
        }
    }

    private function addSampleTarget() {
        $steps = $this->ktrXml->step;
        foreach ($steps as $step) {
            $name = $step->name;
            if ($name == 'Target Schema') {
                $fields = $step->fields;

                $field = $fields->addChild('field');
                $field->addChild('column_name', 'Dname');
                $field->addChild('stream_name', 'Dname');

                $field = $fields->addChild('field');
                $field->addChild('column_name', 'Sid');
                $field->addChild('stream_name', 'Sid');

                $field = $fields->addChild('field');
                $field->addChild('column_name', 'Eid');
                $field->addChild('stream_name', 'Eid');

                $field = $fields->addChild('field');
                $field->addChild('column_name', 'value');
                $field->addChild('stream_name', 'value');
            }
        }
    }

    private function addNormalizer($baseHeader, $dataMatchingUserInputs) {

        $this->addExcelInputFields(reset($baseHeader));

        $steps = $this->ktrXml->xpath('//step[name = "Row Normalizer"]');
        $step = $steps[0];

        foreach ($dataMatchingUserInputs as $value) {
            $fields = $step->fields;
            $field = $fields->addChild('field');
            $field->addChild('name', $value["originalDname"]);
            $field->addChild('value', $value["newDname"]);
            $field->addChild('norm', 'value');
        }
    }

    private function addExcelInputFields($baseHeader) {
        var_dump($baseHeader);
        $steps = $this->ktrXml->step;

        foreach ($steps as $step) {
            $name = $step->name;
            if ($name == 'Excel Input File') {
                foreach ($baseHeader as $item) {
                    $fields = $step->fields;

                    $field = $fields->addChild('field');
                    $field->addChild('name', $item);
                    $field->addChild('type', 'String');
                    $field->addChild('length', '-1');
                    $field->addChild('precision', '-1');
                    $field->addChild('trim_type', 'none');
                    $field->addChild('repeat', 'N');
                    $field->addChild('format');
                    $field->addChild('currency');
                    $field->addChild('decimal');
                    $field->addChild('group');
                }
            }
        }
    }

    public function addConstants($name1, $value, $type, $format) {
        $constant = new stdClass();
        $constant->name1 = $name1;
        $constant->value = $value;
        $constant->type = $type;
        $constant->format = $format;
        $this->addedConstants[] = $constant;
    }

    private function addConstantIntoFile($name1, $value, $type, $format) {
        $steps = $this->ktrXml->step;

        foreach ($steps as $step) {
            $name = $step->name;
            if ($name == 'Add Constants') {
                $fields = $step->fields;

                $field = $fields->addChild('field');
                $field->addChild('name', $name1);
                $field->addChild('type', $type);
                $field->addChild('format', $format);
                $field->addChild('currency');
                $field->addChild('decimal');
                $field->addChild('group');
                $field->addChild('nullif', $value);
                $field->addChild('length', '-1');
                $field->addChild('precision', '-1');
            }
        }
    }

    // Update target
    public function updateColumnAndStreamName($name1, $value1) {
        $colStmName = new stdClass();
        $colStmName->name1 = $name1;
        $colStmName->value1 = $value1;
        $this->updatedColAndStreamNames[] = $colStmName;
    }

    private function updateColumnAndStreamNameIntoFile($name1, $value1) {
        $steps = $this->ktrXml->step;

        foreach ($steps as $step) {
            $name = $step->name;
            if ($name == 'Target Schema') {
                $fields = $step->fields;

                $field = $fields->addChild('field');
                $field->addChild('column_name', $name1);
                $field->addChild('stream_name', $value1);
            }
        }
    }

}

?>
