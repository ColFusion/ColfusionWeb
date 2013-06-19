<script type="text/javascript" src="{$my_pligg_base}/templates/{$the_template}/js/jquery/jquery.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/templates/{$the_template}/js/jquery/jquery.blockUI.js"></script>
{literal}
<script type="text/javascript">
	var intervals = new Array();
	var xmlhttp; 
	var text_content;
	
	
//AJAX checking the response from upload_file.php 
	if (window.XMLHttpRequest)	       
		xmlhttp = new XMLHttpRequest();
	else (window.ActiveXObject)
		xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");

		//Upload a file
		function submitUploadForm(form)
		{
			//Setup timer to check file status
			intervals[0] = setInterval("getResult()", 1000);
			intervals[1] = 0;
			//block UI
			$('div#leftcol-wide').block({ message: '' });
			$('div#leftcol-wide').block({ css: { 
			backgroundColor: '#00f', color: '#fff'
			} });
			document.getElementById('upload_form').style.display='none';
			form.submit();
			$('div#leftcol-wide').unblock();
		}
		
		
		function getResult()
		{		
				xmlhttp.open("GET", my_pligg_base+"/upload_file.php?phase=2", false);
				xmlhttp.send(null);

				if (xmlhttp.responseText != "")
				{					
					clearInterval(intervals[0]);
					
					if (!(xmlhttp.responseText.indexOf('ERROR:') == 0))
					{
						document.getElementById('upload_result').innerHTML="<font color=blue>Your upload is successful.</br>Copy this address and add to step of Excel Input File in application of Pentaho.</font></br></br>";
						document.getElementById('url-textArea').value = xmlhttp.responseText; 
						document.getElementById('url-textArea').style.display='block';
						text_content = document.getElementById('url-textArea').value
						document.getElementById('clipboard').style.display='block';
						document.getElementById('return').style.display='block';
					} 
				   else	{
						document.getElementById('upload_result').innerHTML="<font color=red>"+"</br>"+"&nbsp;" +"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+"&nbsp;"+xmlhttp.responseText+"</font>";
						document.getElementById('upload_form').style.display='block';
					}						
				}				
				else (++intervals[1] > 30)
				{
					document.getElementById('upload_result').innerHTML="<font color=red>"+"</br>"+"</br>"+failed+"</font>";
					clearInterval(intervals[0]);
					document.getElementById('upload_form').style.display='block';
				}			
		}
// direct the file name to text box
</script>
<script type="text/javascript">
    window.onload = function(){
        var _file = document.getElementById('upload-file');
        var _text = document.getElementById('upload-text');
         
        _file.onchange = function(){
			var path = _file.value;
		var fileName = path.substring(path.lastIndexOf('\\')+1,path.lastIndexOf(''));
            _text.value = fileName;     
        }
	}

	function f1() {
    		var s = document.getElementById('url-textArea').value;
    		
    		var div = document.createElement('div');
    		document.body.appendChild(div);
    		
    		if (window.clipboardData)
    			window.clipboardData.setData('text', s);
    		else
    			return (s);
    	}
    function goBack()
        {
            window.history.back()
        }			
</script>
{/literal}

<div id="upload">
	<h2>Save your file to generate adress for Pentaho</h2>
		<div id="upload_content">
			<p>Pentaho is a application which can help you transfer your file to ktr format.<p/>     
			<form class="upload-form" name="upload_form" id="upload_form" action="{$my_pligg_base}/upload_file.php" method="post" enctype="multipart/form-data" target="upload_iframe">
				<input type="hidden" name="phase" value="1">
				<b>Select your file: </b> <input type="file" class="upload-file" size="31" id="upload-file" name="upload_file" />
				<input type="text" class="upload-text" id="upload-text" />&nbsp<button id ="btn_browse">Browse..</button>
				<input type="submit"  name="upload" value="Upload" onclick='submitUploadForm(this.form)' class="upload-sub" />
			</form>
            			
			<div name="upload_result" id="upload_result"></div>
			
            <table>			
			<tr><td><input style="display:none;" type="text" class="url-text" id="url-textArea"></td>
			<tr><object style="display:none;" id='clipboard' codebase='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0' width='16' height='16' align='middle'>
				<embed src='{$my_pligg_base}/templates/{$the_template}/js/clipboard.swf' flashvars='callback=f1' quality='high' bgcolor='#ffffff' width='16' height='16' wmode='transparent' name='clipboard' align='middle' allowscriptaccess='always' allowfullscreen='false' type='application/x-shockwave-flash' pluginspage='http://www.adobe.com/go/getflashplayer' />
			</object></tr>
			</table>
			<button style="display:none" type="button" id="return" onClick="location.href='http://colfusion.exp.sis.pitt.edu/colfusion/submit.php'">Return</button>
			<iframe name="upload_iframe" id="upload_iframe" style="display:none;"></iframe>
		</div>
	
</div>
</br></br>
<center><input type="button" value="Back" onclick="goBack()"></center>







	
