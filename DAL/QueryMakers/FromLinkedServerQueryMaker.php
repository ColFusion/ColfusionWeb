<?php

include_once(realpath(dirname(__FILE__)) . "/../../config.php");

class FromLinkedServerQueryMaker {
   
    // columnsToSelect - array of following objects {cid: cid,columnName: columnName, columnAlias: columnAlias}
    public static function MakeQueryOneTable($source, $columnsToSelect) {

        global $db;

        $query = "select * from colfusion_sourceinfo_DB where sid = " . $source->sid;

        $result = $db->get_row($query);

        $linkedServerName = $result->source_database;

        $cids = $columnsToSelect->cids;
        $columnNameAndAlias = $columnsToSelect->columnNameAndAlias;
        $columnNames = $columnsToSelect->columnNames;
        
        $tableName = $source->tableName;

        $selectPart = " select distinct $columnNameAndAlias ";
        $fromParm = " from ";

        if ($result->server_address === "tycho.exp.sis.pitt.edu") {
            $fromParm .= " [$linkedServerName].[dbo].[{$tableName}] as [{$tableName}{$source->sid}] ";
        }
        else {
            switch ($result->driver) {
                case 'mysql':
                    $fromParm .= " (select * from OPENQUERY([$linkedServerName], 'select * from `{$tableName}`')) as [{$tableName}{$source->sid}] ";
                    break;

                case 'postgresql':
                    $fromParm .= " (select * from OPENQUERY([$linkedServerName], 'select * from \"{$tableName}\"')) as [{$tableName}{$source->sid}] ";
                    break;

                case 'mssql':
                    $fromParm .= " [$linkedServerName]...[{$tableName}] as [{$tableName}{$source->sid}] ";
                    break;
                    
                default:
                    throw new Exception("Error Processing Request. DBMS engine is not recognized", 1);
                    
                    break;
            }
            
        }

        return $selectPart . $fromParm;
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