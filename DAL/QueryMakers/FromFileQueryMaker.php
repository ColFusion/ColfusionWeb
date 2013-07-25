<?php

include_once(realpath(dirname(__FILE__)) . "/../../config.php");

error_reporting(E_ALL ^ E_STRICT ^ E_NOTICE);
ini_set('display_errors', 1);


class FromFileQueryMaker {

    
    private static function getAllTableNameDotColumnsBySid($sid, $table_name) {
        global $db;


        //	if ($dnamesToInclude == "*")
        $query = "select dname_chosen from colfusion_dnameinfo where sid = $sid and dname_chosen not in ('Spd', 'Drd', 'Location', 'AggrType', 'Start', 'End')";
        //	else {
        //		$query = "select dname_chosen from colfusion_dnameinfo where sid = $sid and dname_chosen in ($dnamesToInclude)";
        //	}
        $rst = $db->get_results($query);
        foreach ($rst as $key => $row)
            $colsArray[] = "[" .  $row->dname_chosen . "]";

        foreach ($rst as $key => $row)
            $colsArrayRenamed[] = "[" . $row->dname_chosen . "] as '" . $table_name . "." . $row->dname_chosen . "'";


        $cols = implode(",", array_values($colsArray));
        $colsRenamed = implode(",", array_values($colsArrayRenamed));

        $result->originalCols = $cols;
        $result->colsRenamed = $colsRenamed;

        return $result;
    }

    // columnsToSelect - array of following objects {cid: cid,columnName: columnName, columnAlias: columnAlias}
    public static function MakeQueryToRotateTable($columnsToSelect) {

        $cids = $columnsToSelect->cids;
        $columnNameAndAlias = $columnsToSelect->columnNameAndAlias;
        $columnNames = $columnsToSelect->columnNames;

        $linkedServerName = my_pligg_base_no_slash;

        $query = <<<EOQ
    select $columnNameAndAlias
		from
		(
			select *
			from
    			(select rownum, Dname, Value from [$linkedServerName]...colfusion_temporary where cid in ($cids)) as T
				 pivot
				(
					max(T.VALUE)
					for T.Dname in ($columnNames)
				) as P
		) as rot 
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