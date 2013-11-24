<?php

require_once(realpath(dirname(__FILE__)) . '/../Classes/PHPExcel.php');
require_once(realpath(dirname(__FILE__)) . '/ServerCredForExcelToDatabase.php');

class KTRManager {

    private $ktrTemplatePath;
    private $ktrFilePath;
    private $ktrXml;
    private $addedConstants;
    private $updatedColAndStreamNames;
    private $filePaths;
    private $sid;
    private $connectionInfo;
    private $tableName;
    private $fileURLs;

    public function __construct($ktrTemplatePath, $ktrFilePath, $filePaths, $sid, $fileURLs) {
        $this->ktrTemplatePath = $ktrTemplatePath;
        $this->ktrFilePath = $ktrFilePath;
        $this->filePaths = $filePaths;
        $this->sid = $sid;
        $this->fileURLs = $fileURLs;
    }

    public function createTemplate($sheetNamesRowsColumns, $baseHeader, $dataMatchingUserInputs) {

        copy($this->ktrTemplatePath, $this->ktrFilePath);
        $this->ktrXml = simplexml_load_file($this->ktrFilePath);

        
        $this->changeConnection();
        $this->changeSheetType();
        $this->addUrls($this->fileURLs);
        $this->addSheets($sheetNamesRowsColumns);
        $this->clearConstantAndTarget();

        $this->addExcelInputFields($baseHeader, $dataMatchingUserInputs);

        // $this->addSampleTarget();
        // foreach ($this->addedConstants as $constant) {
        //     $this->addConstantIntoFile($constant->name1, $constant->value, $constant->type, $constant->format);
        // }
        // foreach ($this->updatedColAndStreamNames as $colAndStmName) {
        //     $this->updateColumnAndStreamNameIntoFile($colAndStmName->name1, $colAndStmName->value1);
        // }
        // $this->addNormalizer($baseHeader, $dataMatchingUserInputs);
        // 
        
        $this->updatedColAndStreamNames = $dataMatchingUserInputs;
        $this->updateTargetSchemaStepColumnAndStreamName($dataMatchingUserInputs);

        $this->changeTranasformationName($this->sid);

        file_put_contents($this->ktrFilePath, $this->ktrXml->asXML());
        unset($this->ktrXml);
    }

    public function changeTranasformationName($name) {
 
        if (isset($this->ktrXml)) {
            $this->ktrXml->info[0]->name = $name;
        }
        else {
            $this->ktrXml = simplexml_load_file($this->ktrFilePath);

            $this->ktrXml->info[0]->name = $name;

            file_put_contents($this->ktrFilePath, $this->ktrXml->asXML());
            unset($this->ktrXml);
        }

        
    }

    private function changeConnection() {
 
        $connectionInfo = new stdClass();

        $connectionInfo->database = constant("FILETODB_DB_NAMEPREFIX") . $this->sid;
        $connectionInfo->username = constant("FILETODB_DB_USER");
        $connectionInfo->password = constant("FILETODB_DB_PASSWORD");
        $connectionInfo->server = constant("FILETODB_DB_HOST");
        $connectionInfo->port = constant("FILETODB_DB_PORT");
        $connectionInfo->engine = constant("FILETODB_DB_ENGINE");

        $this->ktrXml->connection[0]->database = $connectionInfo->database;
        $this->ktrXml->connection[0]->username = $connectionInfo->username;
        $this->ktrXml->connection[0]->password = $connectionInfo->password;
        $this->ktrXml->connection[0]->server = $connectionInfo->server;
        $this->ktrXml->connection[0]->port = $connectionInfo->port;
        $this->ktrXml->connection[0]->type = $connectionInfo->engine;

        $this->ktrXml->connection[1]->database = PENTAHO_LOG_DB;
        $this->ktrXml->connection[1]->username = PENTAHO_LOG_DB_USER;
        $this->ktrXml->connection[1]->password = PENTAHO_LOG_DB_PASSWORD;
        $this->ktrXml->connection[1]->server = PENTAHO_LOG_DB_HOST;
        $this->ktrXml->connection[1]->port = PENTAHO_LOG_DB_PORT;
        $this->ktrXml->connection[1]->type = PENTAHO_LOG_DB_ENGINE;

        $this->connectionInfo = $connectionInfo;
    }

    /**
     * Return connection information the target server from the ktr file.
     * @return stdClass Returned object has following fields:
     *         database - the name of the target database
     *         username - dbms user name which should have permissions to connect to the target database
     *         password - password to use for connection
     *         server - the url of the target server
     *         port - port number on which the dbms is listening
     *         engine - name of the dbms, e.g.: mysql, mssql,...
     */
    public function getConnectionInfo() {
        return $this->connectionInfo;
    }

    /**
     * Return table name from Target Schema step of the ktr file.
     * @return String table name - the name of the sql table in the target database.
     */
    public function getTableName() {
        return $this->tableName;
    }

    /**
     * Return the array of objects which describe columns from the file. TODO need to defince a class for that object
     * @return array columns info
     */
    public function getColumns()
    {
        return $this->updatedColAndStreamNames;
    }

    private function changeSheetType() {
        $sheetTypeNodes = $this->ktrXml->xpath('//step/spreadsheet_type[@id="sheet_type"]');
        $sheetTypeNodes[0] = "POI";
    }

    private function addUrls($filePaths) {

        $xmldoc = $this->ktrXml;
        $fileNodes = $xmldoc->xpath('//step/file');
        $fileNode = $fileNodes[0];

        foreach ($filePaths as $filePath) {
            $fileNode->addChild('name', $filePath);
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
                    $sheet->addChild('startrow', $sheetNamesRowsColumns[1][$i] - 1);
                    $sheet->addChild('startcol', PHPExcel_Cell::columnIndexFromString($sheetNamesRowsColumns[2][$i]) - 1);
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

                // $field = $fields->addChild('field');
                // $field->addChild('column_name', 'Dname');
                // $field->addChild('stream_name', 'Dname');

                // $field = $fields->addChild('field');
                // $field->addChild('column_name', 'Sid');
                // $field->addChild('stream_name', 'Sid');

                // $field = $fields->addChild('field');
                // $field->addChild('column_name', 'Eid');
                // $field->addChild('stream_name', 'Eid');

                // $field = $fields->addChild('field');
                // $field->addChild('column_name', 'value');
                // $field->addChild('stream_name', 'value');
            }
        }
    }

    private function addNormalizer($baseHeader, $dataMatchingUserInputs) {

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

    private function addExcelInputFields($baseHeader, $dataMatchingUserInputs) {
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
                    $field->addChild('trim_type', 'both');
                    $field->addChild('repeat', 'N');


                     foreach ($dataMatchingUserInputs as $key => $value) {
                        if ($item == $value["originalDname"]) {
                            if ($value["type"] == "INT") {
                                $field->addChild('format', '0.##############;-0.##############'); //TODO: This might need some testing on different data 
                            }
                            else {

                            }
                            break;
                        }
                        $field->addChild('stream_name', $value["originalDname"]);
                    }

//                    $field->addChild('format', '0.##############;-0.##############'); //TODO: This might need some testing on different data 
                    
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

    private function updateTargetSchemaStepColumnAndStreamName(array $columnNameAndStreamName) {

        $steps = $this->ktrXml->step;

        foreach ($steps as $step) {
            $name = $step->name;
            if ($name == 'Target Schema') {

                $step->table = $columnNameAndStreamName[0]["tableName"];
                $this->tableName = $columnNameAndStreamName[0]["tableName"];

                $fields = $step->fields;

                foreach ($columnNameAndStreamName as $key => $value) {
                    $field = $fields->addChild('field');
                    $field->addChild('column_name', $value["originalDname"]);
                    $field->addChild('stream_name', $value["originalDname"]);
                }
            }
        }
    }

    public function getFilePaths() {
        return $this->filePaths;
    }

    public function getFirstFilename() {
        return pathinfo($this->filePaths[0], PATHINFO_BASENAME);
    }
    
    public function getKtrFilePath(){
        return $this->ktrFilePath;
    }
}

?>
