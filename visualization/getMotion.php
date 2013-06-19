<?php
	include('../config.php');

	include_once("../DAL/ExternalDBHandlers/ExternalMSSQL.php");

	$query =<<<EOQ
	SELECT disease, year, month, totalNumber as numberOfCases, [precip_10000.PRECIPITAT] as precipitation, state
FROM
(
    SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT 1)) AS rnum
    FROM (select * from deseaseNumberByYMSTD as rot0, (    select [OBJECTID] as 'precip_10000.OBJECTID',[FID_precip] as 'precip_10000.FID_precip',[YEAR] as 'precip_10000.YEAR',[MONTH] as 'precip_10000.MONTH',[COUNTRY] as 'precip_10000.COUNTRY',[LATITUDE] as 'precip_10000.LATITUDE',[LONGITUDE] as 'precip_10000.LONGITUDE',[PRECIPITAT] as 'precip_10000.PRECIPITAT',[STATE] as 'precip_10000.STATE'
		from
		(
			select *
			from
    			(select rownum, Dname, Value from [COLFUSIONDEV]...colfusion_temporary where sid = 711) as T
				 pivot
				(
					max(T.VALUE)
					for T.Dname in ([OBJECTID],[FID_precip],[YEAR],[MONTH],[COUNTRY],[LATITUDE],[LONGITUDE],[PRECIPITAT],[STATE])
				) as P
		) as rot ) as rot1 where  rot0.[year] = rot1.[precip_10000.YEAR] and  rot0.[month] = rot1.[precip_10000.MONTH] and  rot0.[state] = rot1.[precip_10000.STATE] ) as b
) a
WHERE rnum > 0 and [precip_10000.PRECIPITAT] <> -9999
order by year, month, disease
EOQ;

//	$titleNo = $_POST['titleNo'];
//	$firstColumn = $_POST['firstColumn'];
//	$dateColumn = $_POST['dateColumn'];
//	$otherColumns = $_POST['otherColumns'];
  //  $where = $_POST['where']; 
	
// $res = $db->query("call doJoin('" . $titleNo . "')");
	
//	$valueColumns = "";
//    if(empty($otherColumns)){
//    	echo("Please select the columns!");
//    }else{
//        for($i=0; $i < count($otherColumns); $i++){
//			$valueColumns .= "`" . $otherColumns[$i] . "` as 'valueColumn" . $i . "'";
//			if(!empty($otherColumns[$i+1])){
//				$valueColumns .= ", ";
//			}
  //      }
    //}
//	$sql = "SELECT `" . $firstColumn . "` as 'firstColumn', `" . $dateColumn . "` as 'dateColumn', ";
//	$sql .= $valueColumns;
//	$sql .= " FROM resultDoJoin ";
//	if (!empty($where))
  //      $sql .= $where;
		
	$rst = ExternalMSSQL::runQueryWithLinkedServers($query);

//	$rst = $db->get_results($sql);
	$rows = array();
	foreach ($rst as $r) {
		$rows[] = $r;
	}
	echo json_encode($rows);
	

/*
$titleNo = 0;
$firstColumn = "Location";
$dateColumn = "Spd";
$otherColumns = ['Households','Married Couples'];
*/
/*
$cols = "";
for($i=0; $i<count($otherColumns); $i++) {
	$cols .= "'" . $otherColumns[$i] . "'";
	if(!empty($otherColumns[$i+1])){
		$cols .= ",";
	}
}

if($firstColumn == "Location"){
	$sql = "SELECT " . $dateColumn . " as 'Date', " . $firstColumn . " as 'Category', Dname, AVG(value) as 'Value', columnnum, rownum ";
	$sql .= "FROM `colfusion_temporary` ";
	$sql .= "WHERE dname IN(" . $cols . ") ";
	$sql .= "AND value IS NOT NULL ";
	$sql .= "AND rownum IS NOT NULL AND columnnum IS NOT NULL ";
	if($titleNo!=0) {
		$sql .= "AND sid = " .$titleNo. " ";
	}
	$sql .= "GROUP BY dname, " . $firstColumn . ", rownum ";
	//$sql .= "ORDER BY " . $firstColumn . ", dname, rownum ";
	$sql .= "ORDER BY sid, rownum, dname ";
}
else{
	$sql = "SELECT " . $dateColumn . " as 'Date', Dname, AVG(value) as 'Value', columnnum, rownum ";
	$sql .= "FROM `colfusion_temporary` ";
	$sql .= "WHERE dname IN(" . $cols . ", '" . $firstColumn . "') ";
	$sql .= "AND value IS NOT NULL ";
	$sql .= "AND rownum IS NOT NULL AND columnnum IS NOT NULL ";
	if($titleNo!=0) {
		$sql .= "AND sid = " .$titleNo. " ";
	}
	$sql .= "GROUP BY dname, value, rownum ";
	$sql .= "ORDER BY sid, rownum, dname ";
}



$rst = $db->get_results($sql);
$rows = array();
foreach ($rst as $r) {
	$rows[] = $r;
}
echo json_encode($rows);
*/

/*
if($titleNo!=0){
	$sql = "SELECT  `Start` ,  `End` ,  `Dname` ,  `Location` , AVG(  `value` ) AS Value "
		. "FROM  `colfusion_temporary` "
		. "WHERE  `start` IS NOT NULL "
		. "AND  `end` IS NOT NULL "
		. "AND  `location` IS NOT NULL "
		. "AND sid = " .$titleNo. " "
		. "	GROUP BY  `Start` ,  `End` ,  `Dname` ,  `Location` ";

}
else {
	$sql = "SELECT  `Start` ,  `End` ,  `Dname` ,  `Location` , AVG(  `value` ) AS Value "
		. "FROM  `colfusion_temporary` "
		. "WHERE  `start` IS NOT NULL "
		. "AND  `end` IS NOT NULL "
		. "AND  `location` IS NOT NULL "
		. "	GROUP BY  `Start` ,  `End` ,  `Dname` ,  `Location` ";
}

$rst = $db->get_results($sql);
$rows = array();
foreach ($rst as $r) {
	$rows[] = $r;
}
echo json_encode($rows);
*/
?>