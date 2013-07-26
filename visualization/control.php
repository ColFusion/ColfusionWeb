<?php
include_once('../config.php');	
include_once('../'.mnminclude.'html1.php');
include_once('../'.mnminclude.'link.php');
include_once('../'.mnminclude.'tags.php');
include_once('../'.mnminclude.'user.php');
include_once('../'.mnminclude.'smartyvariables.php');
//error_reporting(E_ALL);
//ini_set('display_errors', 1);
require_once("Chart.php");
require_once("Canvas.php");

//error_reporting(E_ALL);

require_once('charts/ColumnChart.php');

//error_reporting(E_ALL);
//ini_set('display_errors', 1);

require_once("charts/PieChart.php");
require_once("charts/TableChart.php");
require_once("charts/ComboChart.php");
require_once("charts/MotionChart.php");
require_once("charts/MapChart.php");


include_once(realpath(dirname(__FILE__)) . '/../DAL/QueryEngine.php');

//error_reporting(E_ALL);

global $current_user;



if($current_user->authenticated != TRUE) {
        echo "not log in";
        echo $_SERVER['REQUEST_URI'];
        header("Location: " . $my_base_url . $my_pligg_base . "/login.php?return=" . $_SERVER['REQUEST_URI']);
}
$action = $_REQUEST['action'];
if (in_array($action, array('openCanvas','saveCanvas','createNewCanvas', 'addChart','deleteCanvas','shareCanvas','updateChartResult','getStory','GetTableInfo'))){
    //header('Content-type: text/plain');
    $action();
}elseif (in_array($action, array(''))){
    header('Content-type: text/html');
    $action();
}else{
    header('Content-type: text/xml');
    echo '<?xml version="1.0" encoding="UTF-8"?' . ">\n";
    echo "<AJAXResponse>\n";
    if (is_callable(array($this, $action))) {
            $action();
    } else {
            echo '<Error>Invalid Method</Error>';
    }
    echo '</AJAXResponse>';
}

/*
 *  Add chart, every type of chart. Get query result to display chart. This function will not store the new created chart in the database Colfusion_charts.
 *  Request Data:
 *      action:addChart
        name:bdfdfd
        vid:1
        type:pie
        width:400
        height:300
        depth:2
        top:50
        left:0
        note:dfdff
        datainfo: //Here is the query data to form the result data, it is json object string.
 */
function addChart(){
    $canvas = unserialize($_SESSION['Canvases'][$_REQUEST['vid']]);
    $chart = $canvas->addChart($_REQUEST['name'], $_REQUEST['type'], $_REQUEST['left'], $_REQUEST['top'], $_REQUEST['depth'], $_REQUEST['height'], $_REQUEST['width'], $_REQUEST['datainfo'], $_REQUEST['note']);
    $rst = array();
    $rst = $chart->printToArray();
    echo json_encode($rst);
    $_SESSION['Canvases'][$_REQUEST['vid']] = serialize($canvas);
}
/* Open canvas, request data type:
 * {
        vid: 10,
        action: openCanvas
    }
 */
function openCanvas(){
    require_once ('Canvas.php');
    require_once ('Chart.php');
    $canvas = Canvas::openCanvas($_REQUEST['vid']);
    if($canvas==null){echo 'not permit to open.';return;}
    $_SESSION['Canvases'][$_REQUEST['vid']] = serialize($canvas);
    $rst = array();
    $rst['charts'] = array();
    foreach($canvas->charts as $chart){
        array_push($rst['charts'],$chart->printToArray());
    }
    $rst['vid'] = $canvas->vid;
    $rst['name'] = $canvas->name;
    $rst['privilige'] = $canvas->privilege;
    $rst['authorization'] = $canvas->authorization;
    $rst['mdate'] = $canvas->mdate;
    $rst['cdate'] = $canvas->cdate;
    $rst['note'] = $canvas->note;
    $rst['isSave'] = $canvas->getIsSave();
    echo json_encode($rst);
    //var_dump($canvas);
    
}

/*
 *  Save Canvas, commit every thing in canvas, and save;
 *  Request Data:
       action:saveCanvas
       vid:28
       name:A
       privilege:
       authorization:0
       charts[0][cid]:118
       charts[0][name]:peichart
       charts[0][type]:pie
       charts[0][left]:46
       charts[0][top]:114
       charts[0][height]:301
       charts[0][width]:401
       charts[0][depth]:0
       charts[0][datainfo]:datainfo
       charts[0][note]:note
       charts[1][cid]:119
       charts[1][name]:peichart
       charts[1][type]:pie
       charts[1][left]:618
       charts[1][top]:341
       charts[1][height]:301
       charts[1][width]:401
       charts[1][depth]:0
       charts[1][datainfo]:datainfo
       charts[1][note]:note
       charts[2][cid]:120
       charts[2][name]:peichart
       charts[2][type]:pie
       charts[2][left]:606
       charts[2][top]:79
       charts[2][height]:301
       charts[2][width]:401
       charts[2][depth]:0
       charts[2][datainfo]:datainfo
       charts[2][note]:note
 */
function saveCanvas(){
    require_once('Canvas.php');
    require_once('Chart.php');
    require_once('charts/PieChart.php');
    require_once('charts/ColumnChart.php');    
    $canvas = unserialize($_SESSION['Canvases'][$_REQUEST['vid']]);
    $name = $_REQUEST['canvasName'];
    $note = $_REQUEST['note'];
    $privilege = $_REQUEST['privilege'];
    $charts = $_REQUEST['charts'];
    $newOldChartId = $canvas->save($name, $note, $privilege, $charts);
    $rst = array();
    $rst['newOldChartId'] = $newOldChartId;
    echo(json_encode($rst));
    $_SESSION['Canvases'][$_REQUEST['vid']] = serialize($canvas);
}

/*
 *  Create a new blank Canvas;
 *  Request data:
 *      action:createNewCanvas
        name:dudu
        note:dfdf
 */
function createNewCanvas(){  
    require_once('../config.php'); 
    require_once("Canvas.php");
    require_once("Chart.php");
    global $current_user;
    
    $canvas = Canvas::createNewCanvas($_REQUEST['name'], $userid = $current_user->user_id, $_REQUEST['note'] ,0);
    $_SESSION['Canvases'][$canvas->vid] = serialize($canvas);
    $rst = array();
    $rst['charts'] = array();

    //var_dump($canvas->charts );

    if (isset($canvas->charts)) {

        foreach($canvas->charts as $chart){
            array_push($rst['charts'],$chart->printToArray());
        }

    }

    $rst['vid'] = $canvas->vid;
    $rst['name'] = $canvas->name;
    $rst['privilige'] = $canvas->privilege;
    $rst['authorization'] = $canvas->authorization;
    $rst['mdate'] = $canvas->mdate;
    $rst['cdate'] = $canvas->cdate;
    $rst['note'] = $canvas->note;
    $rst['isSave'] = $canvas->getIsSave();
    echo json_encode($rst);
}
function deleteCanvas(){
    $vids = $_REQUEST['vids'];
    $rst = array();
    foreach($vids as $vid){
        if($_SESSION['Canvases'][$vid]!=null){
            unset($_SESSION['Canvases'][$vid]);
        }
        global $db;
        $sql = "delete from colfusion_shares where vid =".$vid;
        $db->query($sql);
        $sql = "delete from colfusion_charts where vid =".$vid;
        $db->query($sql);
        $sql = "delete from colfusion_canvases where vid =".$vid;
        $r = $db->query($sql);
        if($r==0){
            $rst['result'] = 'No Canvas Delete';
        }else{
            $rst['result'] = 'One Canvas Delete';
        }
    }
    $rst['status'] = 'success';
    echo json_encode($rst);
}
function shareCanvas(){
    global $db;
    $rst = array();
    $vid = $_REQUEST['vid'];
    $shareTo = $_REQUEST['shareTo'];
    $sql = "";
    if(substr_count($shareTo,"@")==0){
        $sql = "select user_id from colfusion_users where user_login ='".$shareTo."'";
    }else{
        $sql = "select user_id from colfusion_users where user_email ='".$shareTo."'";
    }
    $r = $db->get_row($sql);
    $user_id;
    if(is_null($r)){
        $rst['status'] = 0;
        $rst['msg'] = "Can't find the user.";
    }else{
        $user_id = $r->user_id;
        $canvas;
        if($_SESSION['Canvases'][$vid] !=null){
            $canvas = unserialize($_SESSION['Canvases'][$_REQUEST['vid']]);
            //$rst = $canvas->shareCanvas($user_id,$_REQUEST['authorization']);
        }else{
            $canvas = Canvas::openCanvas($_REQUEST['vid']);
            
        }
        if($canvas==null){$rst['status'] = '0';$rst['msg'] = 'No permit or no canvas exists.';}
        else{
            if(is_null($canvas->shareCanvas($user_id,$_REQUEST['authorization']))){
                $rst['status'] = 0;
                $rst['msg'] = 'Unable to share this canvas to '.$shareTo;
            }
            else{
                $rst['status'] = 1;
            }
        }
    }
    echo json_encode($rst);
}
//share multiple canvases at one time.
function shareCanvases(){

}
function updateChartResult(){
    $canvas = unserialize($_SESSION['Canvases'][$_REQUEST['vid']]);
    $queryResult = $canvas->updateChartResult($_REQUEST['cid'],$_REQUEST['datainfo']);
    $rst['queryResult'] = $queryResult;
    $rst['cid'] = $_REQUEST['cid'];
    echo json_encode($rst);
    $_SESSION['Canvases'][$canvas->vid] = serialize($canvas);
}
//use sid to get story name and related tables
function getStory(){
    
    $queryEngine = new QueryEngine();
    $sid = $_REQUEST['sid'];
    $sname = $_REQUEST['sname'];
    $result = $queryEngine->GetTablesInfo($sid);
    $rst = array();
    if($result!=null){
        $rst['status'] = 'success';
        $tables = array();
        foreach($result as $tname => $table){
            $columns = array();
            foreach($table as $column){
                array_push($columns,$column->dname_chosen);
            }
            $tables[$tname]['table'] = $tname;
            $tables[$tname]['columns'] = $columns;
        }
        $rst['story']['sid'] = $_REQUEST['sid'];
        $rst['story']['sname'] = $sname;
        $rst['story']['tables'] = $tables;
    }else{
        $rst['status'] = 'failed';
        $rst['message'] = 'Cannot find story '.$sid.'.';
    }

    echo json_encode($rst);/*
    $rst = array();
    if($sid == '100'){
        $rst['status'] = 'success';
        $rst['story'] = array();
        $rst['story']['sid'] = 100;
        $rst['story']['sname'] = 'story100';
        $table1 = array();
        $table2 = array();
        $table3 = array();
        $table4 = array();
        $table1['table'] = 'table1001';
        $table1['columns'] = ['1001ID','1001Name','1001Date','1001Where'];
        $table2['table'] = 'table1002';
        $table2['columns'] = ['1002ID','1002Name','1002Date','1002Where'];
        $table3['table'] = 'table1003';
        $table3['columns'] = ['1003ID','1003Name','1003Where'];
        $table4['table'] = 'table1004';
        $table4['columns'] = ['1004ID'];
        $tables['table1001'] = $table1;
        $tables['table1002'] = $table2;
        $tables['table1003'] = $table3;
        $tables['table1004'] = $table4;
        $rst['story']['tables'] = $tables;
    }else if($sid == '200'){
        $rst['status'] = 'success';
        $rst['story']['sid'] = 200;
        $rst['story']['sname'] = 'story200';
                $table1 = array();
        $table1 = array();
        $table2 = array();
        $table3 = array();
        $table4 = array();
        $table1['table'] = 'table2001';
        $table1['columns'] = ['2001ID','2001Name','2001Date','2001Where'];
        $table2['table'] = 'table2002';
        $table2['columns'] = ['2002ID','2002Name','2002Date','2002Where'];
        $table3['table'] = 'table2003';
        $table3['columns'] = ['2003ID','2003Name','2003Where'];
        $table4['table'] = 'table2004';
        $table4['columns'] = ['2004ID'];
        $tables['table2001'] = $table1;
        $tables['table2002'] = $table2;
        $tables['table2003'] = $table3;
        $tables['table2004'] = $table4;
        $rst['story']['tables'] = $tables;
    }else if($sid == '300'){
        $rst['status'] = 'success';
        $rst['story']['sid'] = 300;
        $rst['story']['sname'] = 'story300';
        $table1 = array();
        $table2 = array();
        $table3 = array();
        $table4 = array();
        $table1['table'] = 'table3001';
        $table1['columns'] = ['3001ID','3001Name','3001Date','3001Where'];
        $table2['table'] = 'table3002';
        $table2['columns'] = ['3002ID','3002Name','3002Date','3002Where'];
        $table3['table'] = 'table3003';
        $table3['columns'] = ['3003ID','3003Name','3003Where'];
        $table4['table'] = 'table3004';
        $table4['columns'] = ['3004ID'];
        $tables['table3001'] = $table1;
        $tables['table3002'] = $table2;
        $tables['table3003'] = $table3;
        $tables['table3004'] = $table4;
        $rst['story']['tables'] = $tables;
    }else{
        $rst['status'] = 'failed';
        $rst['message'] = 'Cannot find story '.$sid.'.';
    }
    echo json_encode($rst);*/
}
function GetTablesList() {
    $queryEngine = new QueryEngine();
    echo json_encode($queryEngine->GetTablesList($_REQUEST["sid"]));
}
function GetTableDataBySidAndName() {
    $queryEngine = new QueryEngine();

    $sid = $_POST["sid"];
    $table_name = $_POST["table_name"];
    $perPage = $_POST["perPage"];
    $pageNo = $_POST["pageNo"];

    $result = $queryEngine->GetTableDataBySidAndName($sid, $table_name, $perPage, $pageNo);

    $columns = NULL;

    foreach ($result as $r) {
        $json_array["data"][] = $r;

        if ($columns === NULL) {
            if (is_array($r))
                $columns = implode(",", array_keys($r));
            else
                $columns = implode(",", array_keys(get_object_vars($r)));
        }
    }

    $totalTuple = $queryEngine->GetTotalNumberTuplesInTableBySidAndName($sid, $table_name);
    $totalPage = ceil($totalTuple / $perPage);

    $json_array["Control"]["perPage"] = $perPage;
    $json_array["Control"]["totalPage"] = $totalPage;
    $json_array["Control"]["pageNo"] = $pageNo;
    $json_array["Control"]["cols"] = $columns;

    echo json_encode($json_array);
}
function GetTableInfo(){
	
	
    $queryEngine = new QueryEngine();
    $sid = $_REQUEST["sid"];
    $tableName = $_REQUEST["table_name"];
    
    $result = $queryEngine->GetTablesInfo($sid);
   
    echo json_encode($result[$tableName]);
}
function GetTablesInfo(){
    $queryEngine = new QueryEngine();
    $sid = $_POST["sid"];
    
    $result = $queryEngine->GetTablesInfo($sid);
    echo json_encode($result);
}
function AddRelationship() {
	global $current_user;

	$name = $_POST["name"];
	$description = $_POST["description"];
	$from = $_POST["from"];
	$to = $_POST["to"];

	$confidence = $_POST["confidence"];
	$comment = $_POST["comment"];

	$queryEngine = new QueryEngine();

	echo json_encode($queryEngine->AddRelationship($current_user->user_id, $name, $description, $from, $to, $confidence, $comment));
}
function CheckDataMatching() {
	$from = $_POST["from"];
	$to = $_POST["to"];
	
	$queryEngine = new QueryEngine();
	
	echo json_encode($queryEngine->CheckDataMatching($from, $to));
}