<?php

class ChartFactory {
    //Open a chart with Id get data from database;
    static function openChartWithId($_cid){
        require_once('../config.php');
        require_once('charts/PieChart.php');
        require_once('charts/Column.php');
        global $db;
        $sql = "select * from colfusion_charts where id = ".$_cid;
        $rst = $db->get_result($sql);
        $obj = $rst[0];
        $datainfo = str_replace('\"','"',$obj->datainfo);
        include_once('Debug/Debugger.php');
        Debugger::var_dump_value('cid',$_cid,null);
        if($obj->type == "pie"){
            return new PieChart($_cid, $obj->name, $obj->canvas, $obj->type, $obj->left, $obj->top, $obj->depth, $obj->height, $obj->width, $obj->datainfo, $obj->note);
        }
        if($obj->type == "column"){
            return new ColumnChart($_cid, $obj->name, $obj->canvas, $obj->type, $obj->left, $obj->top, $obj->depth, $obj->height, $obj->width, $obj->datainfo, $obj->note);
        }
        if($_type == "table"){
        	return new TableChart($_cid, $obj->name, $obj->canvas, $obj->type, $obj->left, $obj->top, $obj->depth, $obj->height, $obj->width, $obj->datainfo, $obj->note);
        }
        if($_type == "combo"){
        	return new ComboChart($_cid, $obj->name, $obj->canvas, $obj->type, $obj->left, $obj->top, $obj->depth, $obj->height, $obj->width, $obj->datainfo, $obj->note);
        }
        if($_type == "map"){
        	return new MapChart($_cid, $obj->name, $obj->canvas, $obj->type, $obj->left, $obj->top, $obj->depth, $obj->height, $obj->width, $obj->datainfo, $obj->note);
        }
        if($_type == "motion"){
        	return new MotionChart($_cid, $obj->name, $obj->canvas, $obj->type, $obj->left, $obj->top, $obj->depth, $obj->height, $obj->width, $obj->datainfo, $obj->note);
        }
    }
    //To new a exist chart with parameters; 
    static function openChart($_cid ,$_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        require_once('charts/PieChart.php');
        require_once('charts/ColumnChart.php');
        if($_type == "pie"){
            return new PieChart($_cid ,$_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        }
        if($_type == "column"){
            return new ColumnChart($_cid ,$_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        }
        if($_type == "table"){
        	return new TableChart($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        }
        if($_type == "combo"){
        	return new ComboChart($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        }
        if($_type == "map"){
        	return new MapChart($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        }
        if($_type == "motion"){
        	return new MotionChart($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        }
    }
    //To create a temp chart, with a temp Id 
    static function createChart($_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        require_once('../config.php');
        require_once('charts/PieChart.php');
        require_once('charts/ColumnChart.php');
        $_cid = "TempChart".date("YmdHis").rand(0,100);
        if($_type == "pie"){
            return new PieChart($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        }
        if($_type == "column"){
            return new ColumnChart($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        }
        if($_type == "table"){
        	return new TableChart($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        }
        if($_type == "combo"){
        	return new ComboChart($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        }
        if($_type == "map"){
        	return new MapChart($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        }
        if($_type == "motion"){
        	return new MotionChart($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        }
    }
}
