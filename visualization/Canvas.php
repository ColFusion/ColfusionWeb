<?php
class Canvas{
    public $vid;
    public $name;
    public $owner; //Owner of the canvas, not the current user;
    public $note;
    public $mdate;
    public $cdate;
    public $privilege; //Canvas accessibility of the chart itself to anyone that shareed with this canvas, 0: read-only, 1: read & write
    public $authorization; //Accessibility to this special current user, 0: owner, 1: read-only, 2: read & write
    //public $version;
    public $charts = array();
    public $statusCode;
    
    function __construct($_vid, $_name, $_owner, $_note, $_mdate, $_cdate, $_privilege, $_authorization, $_charts){
        $this->vid = $_vid;
        $this->name = $_name;
        $this->owner = $_owner;
        $this->note = $_note;
        $this->mdate = $_mdate;
        $this->cdate = $_cdate;
        $this->privilege = $_privilege;
        $this->authorization = $_authorization;
        $this->charts = $_charts;
    }
    public static function createNewCanvas($_name, $_owner, $_note, $_privilege){
        require_once('../config.php');
        global $db;
        $vid = 'TempCanvas'.rand(0,100).date("YmdHis");
        $time=date("Y-m-d H:i:s");
        return new Canvas($vid, $_name, $_owner, $_note, $time, $time, $_privilege, 0, null);
    }
    
    public static function openCanvas($id){
        require_once('../config.php');
        require_once('ChartFactory.php');
        global $db;
        global $current_user;
       
        //Authorize the current user, if current user has the accesibility then get the canvas, else return null;
        $sql = "select * from colfusion_shares where vid = ".$id." and user_id = ".$current_user->user_id;
        $rst = $db->get_row($sql);
        if($rst == null){
            return null;
        }
        $_authorization = $rst->privilege;
        //select the canvas
        $sql = "Select * from colfusion_canvases where vid =".$id;
        $rst = $db->get_results($sql);
        $rows = array();
        foreach ($rst as $r) {
            $rows[] = $r;
        }
        $_canvas = $rows[0];
        
        //select chart in the canvas
        $sql = "select * from colfusion_charts where vid = ".$id;
        $rst = $db->get_results($sql);
        $chartArr = array();
        
        foreach($rst as $obj){
            $datainfo = str_replace('\"','"',$obj->datainfo);
            $da = json_decode($datainfo);
            $chartArr[$obj->cid] = ChartFactory::openChart($obj->cid,$obj->name,$obj->vid,$obj->type,$obj->left, $obj->top,$obj->depth,$obj->height,$obj->width,$da,$obj->note);
        }
        return new Canvas($id, $_canvas->name, $_canvas->user_id, $_canvas->note, $_canvas->mdate, $_canvas->cdate, $_canvas->privilege, $_authorization, $chartArr);
    }
    function _createFromDbStr($dbStr){
        
    }
    function updateFromDB(){
        
    }
    /*
     * $_charts is array of all the chart information sumbmit by the browser
     * format like:
     *  [
           {
                'name': 'chart1',
                'cid' : 1,
                'type': 'pie',
                'left': '200',
                'top': '300',
                'depth': '3',
                'height': '400',
                'width': '300',
                'datainfo': '!@#$%^&*()*',
                'note': '#$%^&',
            }
            {
                'name': 'chart2',
                'vid': '3',
                'type': 'column',
                'left': '200',
                'top': '300',
                'depth': '3',
                'height': '400',
                'width': '300',
                'datainfo': '!@#$%^&*()*',
                'note': '#$%^&',
            }
        ]
     */
    function save($_name, $_note, $_privilege, $_charts){
        require_once ('Chart.php');
        require_once ('charts/PieChart.php');
        require_once ('charts/ColumnChart.php');
        require_once ('ChartFactory.php');
        require_once('../config.php');
        global $current_user;
        global $db;
        if($this->authorization==1){
            echo 'can not access to save.';
            return;
        }
        if(substr($this->vid,0,10)=='TempCanvas'){
            $sql = "insert into colfusion_canvases(`name`,`user_id`,`note`,`privilege`) values('".$this->name."',".$current_user->user_id.",'".$this->note."',".$this->privilege.")";
            $db->query($sql);
            $_vid = mysql_insert_id();
            $this->vid = $_vid;
            $sql = "insert into colfusion_shares(`vid`,`user_id`,`privilege`)values(".$this->vid.",".$current_user->user_id.",0)";
            $db->query($sql);
           
        }
        $sql = "udpate 'colfusion_canvas' set 'name' = ".$_name." 'note' = ".$_note." 'privilege' = ".$_privilege." 'mdate' = ".time();
        $charts = $_charts;
        foreach($this->charts as $cid => $chart){
            $flag = true;
            foreach($charts as $chart1){
                if($chart1['cid'] == $cid)$flag = false;
            }
            if($flag)$this->dropChart($cid);
        }
        $rst = array();
        foreach($charts as $chart){
            $cid = $chart['cid'];
            if($cid!=null){
                if(in_array($cid, array_keys($this->charts))){
                    $this->charts[$cid]->save($chart['name'],$chart['type'],$chart['left'],$chart['top'],$chart['depth'],$chart['height'], $chart['width'], $chart['datainfo'], $chart['note']);
                }else{
                    //$chart1 = $this->addChart($chart['name'],$chart['type'],$chart['left'],$chart['top'],$chart['depth'],$chart['height'], $chart['width'], $chart['datainfo'], $chart['note']);
                    $chart1 = ChartFactory::createChart($chart['name'],$this->vid,$chart['type'],$chart['left'],$chart['top'],$chart['depth'],$chart['height'], $chart['width'], $chart['datainfo'], $chart['note']);
                    $chart1->save($chart['name'],$chart['type'],$chart['left'],$chart['top'],$chart['depth'],$chart['height'], $chart['width'], $chart['datainfo'], $chart['note']);
                    $this->charts[$chart1->cid] = $chart1;
                    $temp['newId'] = $chart1->cid;
                    $temp['oldId'] = $chart['cid'];
                    array_push($rst,$temp);
                }
            }
        }
        return $rst;
    }
    function dropCanvas(){
        
    }
    function addChart($_name, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        require_once('ChartFactory.php');
        $chart = ChartFactory::createChart($_name, $this->vid, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        $this->charts[$chart->cid] = $chart;
        //var_dump($this->charts);
        return $chart;
    }
   
    function dropChart($cid){
        $this->charts[$cid]->dropChart();
        unset($this->charts[$cid]);
    }
    function __destruct(){
        
    }
    function _saveNewCanvasInDB(){
        
    }
    function shareCanvas($shareTo,$authorization){
        if($this->authorization!=0){
            return null;
        }else{
            require_once('../config.php');
            global $db;
            $sql = "select * from cofulsion_shares where vid =".$this->vid." user_id = ".$shareTo;
            $rst = $db->get_row($sql);
            if($rst == null){
                $sql = 'insert into colfusion_shares(vid, user_id,) values('.$this->vid.','.$shareTo.','.$authorization.')';
                $db->query($sql);
            }else{
                if($rst->privilege == 0){
                    return 'You cannot share ownnership';
                }else{
                    $sql = 'update colfusion_shares where vid ='.$this->vid.' user_id = '.$shareTo.' set privilege = '.$authorization;
                    $db->query($sql);
                }
            }
        }
    }
    function updateChartResult($_cid,$_datainfo){
        $chart = $this->charts[$_cid];
        return $chart->query($_datainfo);
    }
}
