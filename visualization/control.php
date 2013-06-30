<?php
include_once('../config.php');	
include_once('../'.mnminclude.'html1.php');
include_once('../'.mnminclude.'link.php');
include_once('../'.mnminclude.'tags.php');
include_once('../'.mnminclude.'user.php');
include_once('../'.mnminclude.'smartyvariables.php');
require_once("Chart.php");
require_once("Canvas.php");
require_once("charts/ColumnChart.php");
require_once("charts/PieChart.php");
require_once("charts/TableChart.php");
global $current_user;

if($current_user->authenticated != TRUE) {
        echo "not log in";
        echo $_SERVER['REQUEST_URI'];
        header("Location: " . $my_base_url . $my_pligg_base . "/login.php?return=" . $_SERVER['REQUEST_URI']);
}
$action = $_REQUEST['action'];
if (in_array($action, array('openCanvas','saveCanvas','createNewCanvas', 'addChart','deleteCanvas','shareCanvas'))){
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
    $rst = array();
    $vid = $_REQUEST['vid'];
    if($_SESSION['Canvases'][$vid] !=null){
        $canvas = unserialize($_SESSION['Canvases'][$_REQUEST['vid']]);
        $rst = $canvas->shareCanvas($_REQUEST['shareTo'],$_REQUEST['authorization']);
    }else{
        $canvas = Canvas::openCanvas($_REQUEST['vid']);
        if($canvas==null){$rst['status'] = 'fail';$rst['result'] = 'No permit or no file exist.'; return;}
        else{
            $canvas->shareCanvas($_REQUEST['shareTo'],$_REQUEST['authorization']);
        }
    }
}
