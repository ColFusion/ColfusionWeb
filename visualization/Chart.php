<?php
abstract class Chart {
    public $cid;
    public $name;
    public $canvas;
    public $type;
    public $left;
    public $top;
    public $depth;
    public $height;
    public $width;
    public $datainfo;
    public $note;
    public $queryResult;
    
    function __construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        $this->cid = $_cid;
        $this->name = $_name;
        $this->canvas = $_canvas;
        $this->type = $_type;
        $this->left = $_left;
        $this->top = $_top;
        $this->depth = $_depth;
        $this->height = $_height;
        $this->width = $_width;
        $this->datainfo = $_datainfo;
        $this->note = $_note;
        $this->queryResult = $this->query();
    }
    function save($_name, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        require_once('../config.php');
        global $db;
        if(substr($this->cid,0,9)=='TempChart'){
            $sql = 'insert into colfusion_charts(`name`, `vid`, `type`, `left`, `top`, `depth`, `height`, `width`, `datainfo`, `note`) values("'.$_name.'",'.$this->canvas.',"'.$_type.'",'.$_left.','.$_top.','.$_depth.','.$_height.','.$_width.',"'.$_datainfo.'","'.$_note.'")';
            //echo $sql;
            $db->query($sql);
            $_cid = mysql_insert_id();
            $this->cid = $_cid;
        }else{
            global $db;
            $sql =  'update colfusion_charts set `name` = "'.$_name.'", `type` = "'.$_type.'", `left` = '.$_left.', `top` = '.$_top.', `depth` ='.$_depth.', `height` = '.$_height.', `width` = '.$_width.', `datainfo` = "'.$_datainfo.'", `note` = "'.$_note.'" where `cid` =  '.$this->cid;
            $db->query($sql);
        }
        $this->name = $_name;
        $this->type = $_type;
        $this->left = $_left;
        $this->top = $_top;
        $this->depth = $_depth;
        $this->height = $_height;
        $this->width = $_width;
        $this->datainfo = $_datainfo;
        $this->note = $_note;
    }
    // commit search, get chart data;
    abstract function query();
    function updateFromDB(){
        
    }
    function dropChart(){
        require_once('../config.php');
        global $db;
        $sql = "delete from colfusion_charts where cid = ".$this->cid;
        $db->query($sql);
    }
    function __destruct(){
    }
    function printToArray(){
        $rst = array();
        $rst['cid'] =$this->cid;
        $rst['name'] =$this->name;
        $rst['canvas'] =$this->canvas;
        $rst['type'] =$this->type;
        $rst['left'] =$this->left;
        $rst['top'] =$this->top;
        $rst['depth'] =$this->depth;
        $rst['height'] =$this->height;
        $rst['width'] =$this->width;
        $rst['queryResult'] =json_decode($this->queryResult);
        $rst['note'] =$this->note;
        return $rst;
    }
}
