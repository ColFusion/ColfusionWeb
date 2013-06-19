<link rel="stylesheet" type="text/css" href="{$my_pligg_base}/templates/{$the_template}/js/jquery.sheet/jquery-ui/theme/jquery-ui.min.css" />
<link rel="stylesheet" type="text/css" href="jquery.sheet.css" />
<script type="text/javascript" src="{$my_pligg_base}/templates/{$the_template}/js/jquery.sheet/jquery-1.8.3.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/templates/{$the_template}/js/jquery.sheet/jquery-ui/ui/jquery-ui.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/templates/{$the_template}/js/jquery.sheet/jquery.sheet.js"></script>

{literal}

	 <script type="text/javascript">
   
	    var xmlhttp; 
 
	    if (window.XMLHttpRequest)	       
		    xmlhttp = new XMLHttpRequest();
	    else if (window.ActiveXObject)
		    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	    else
		    alert("Your browser does not support XMLHTTP!");
  			
		window.onload = function showData()
		{	
			xmlhttp.open("GET", my_pligg_base+"/process_excel.php?id=10", false);
			xmlhttp.send(null);
			
			if(xmlhttp.responseText != "")
			{			
				//if(xmlhttp.responseText.indexOf("submitted") > -1){
					
					//document.getElementById('sheetParent').innerHTML=xmlhttp.responseText;

				//}else{		
					
					//document.getElementById('sheetParent').innerHTML=xmlhttp.responseText;
					//document.getElementById('btn_all').style.display='block';
					//document.getElementById('btn_hide').style.display='none';
					//document.getElementById('hint').style.display='block';
				//}
						
			}else{
				//document.getElementById('sheetParent').innerHTML="nothing";
			}													
		}

		function ajax_step_1(){
	var xmlhttp; 
 
	    if (window.XMLHttpRequest)	       
		    xmlhttp = new XMLHttpRequest();
	    else if (window.ActiveXObject)
		    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	    else
		    alert("Your browser does not support XMLHTTP!");

	xmlhttp.open("POST",my_pligg_base+'/generate_ktr.php',true);
	xmlhttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlhttp.send("phase=0");
	
	
	xmlhttp.onreadystatechange=function(){
			if (xmlhttp.readyState==4 && xmlhttp.status==200){
					if (xmlhttp.responseText != ""){
						document.getElementById('sheetParent').innerHTML=xmlhttp.responseText;
					}else{
						alert("No response!");
					}
			}
	}
}

function show(){ 

	var xmlhttp; 
 
	    if (window.XMLHttpRequest)	       
		    xmlhttp = new XMLHttpRequest();
	    else if (window.ActiveXObject)
		    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
	    else
		    alert("Your browser does not support XMLHTTP!");
  		//var fp ='';
		//xmlhttp.open("GET", "process_ecxelV3.php", false);
		xmlhttp.open("GET", "generate_ktr.php?phase=0", false);
			xmlhttp.send(null);
			
			if(xmlhttp.responseText != "")
			{	
					document.getElementById('sheetParent').innerHTML=xmlhttp.responseText;	
			}else{
				document.getElementById('sheetParent').innerHTML="nothing";
			}								
} 

	 </script>

	<script type="text/javascript">

		$.sheet.preLoad('jquery.sheet/');
        $(function() {        	
            $('#sheetParent').sheet();
        });
    </script>

    



{/literal}

<div id="sheetParent" title="excel"> <script>show();</script>


</div>