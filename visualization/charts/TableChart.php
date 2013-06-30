
<?php
require_once('Chart.php');
class TableChart extends Chart{
    function __construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note){
        parent::__construct($_cid, $_name, $_canvas, $_type, $_left, $_top, $_depth, $_height, $_width, $_datainfo, $_note);
        $this->query();
    }
    function query(){
        /*
         * Here implement the query code;
         */
        
    	return '{"column":["ID","la","rownum","long","dvalue"],"data":[{"rownum":"1","ID":" 2.0","la":" 35.273637","long":" 108.0","dvalue":" 2.0"},{"rownum":"2","ID":" 3.0","la":" 40.234","long":" 119.0","dvalue":" 3.0"},{"rownum":"3","ID":" 4.0","la":" 29.873","long":" 125.0","dvalue":" 4.0"}],"Control":{"perPage":"50","totalPage":1,"pageNo":"1","cols":["ID","la","long","dvalue"],"color":"blue"}}';
    	 
    }
}
