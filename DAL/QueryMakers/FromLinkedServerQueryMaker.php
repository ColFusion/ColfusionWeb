<?php

include_once(realpath(dirname(__FILE__)) . "/../../config.php");

error_reporting(E_ALL ^ E_STRICT ^ E_NOTICE);
ini_set('display_errors', 1);


class FromLinkedServerQueryMaker {
   
    // columnsToSelect - array of following objects {cid: cid,columnName: columnName, columnAlias: columnAlias}
    public static function MakeQueryOneTable($source, $columnsToSelect) {

        global $db;

        $query = "select * from colfusion_sourceinfo_DB where sid = " . $source->sid;

        $linkedServerName = $db->get_row($sql)->source_database;

        $cids = $columnsToSelect->cids;
        $columnNameAndAlias = $columnsToSelect->columnNameAndAlias;
        $columnNames = $columnsToSelect->columnNames;

        $linkedServerName = my_pligg_base_no_slash;
        $tableName = $source->tableName;

        $query = <<<EOQ
        select distinct $columnNameAndAlias
		from [$linkedServerName]...$tableName
		
EOQ;

        return $query;
    }
    
    private static function wrapInLimit($startPoint, $perPage, $table) {
        $startPoint = $startPoint - 1;
        $top = $startPoint + $perPage;

        $query = <<<EOQ
SELECT * FROM
(
    SELECT TOP $top *, ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rnum
    FROM $table
) a
WHERE rnum > $startPoint
EOQ;
        return $query;
    }




}

?>