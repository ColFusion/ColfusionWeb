var wiz = "<span id='open-wizard' class='btn btn-primary'>Import data</span>"+"<div class='wizard' id='wizard-demo'>"+
			"<h1>Data Submission Wizard</h1>"+
			"<div class='wizard-card' data-onValidated='setServerName' data-cardname='name'>"+
				"<h3>Upload your dataset</h3>"+"<div class='wizard-input-section'>"+
					"<p>To import a new dataset, please choose one of the following sources:<img src='help.png' width='15' height='15' title='When the upload process completed successfully, you can go forward (next button will be actived)'/></p>"+"<div class='control-group'>"+
						"<input id='computer' type='radio' name='place' placeholder='FQDN or IP'  /> From this computer <img src='help.png' width='15' height='15' title='Select a valid file (.xls,.xlsx, .csv)'/><br/>"+
							"<div id='div1'></div>"+"<p><?php echo $error; ?></p>"+
						"<input id='internet' type='radio' name='place' placeholder='FQDN or IP' /> Internet accessable resource <img src='help.png' width='15' height='15' title='Type in a valid url'/><br/><br/><div id='div2'><input type='text' id='in_url'/><br/><input type='button' name='checkAv' value='check availability' id='checkAv' class='btn btn-primary' onClick='validate_url();'/></div>"+"</div><div id='result'></div>"+
						"<a href='#' id='help1'>Click here for help</a><div id='h1'>Step 1 help:<br/><p class='hlp'>Select from this computer option, if you have the dataset locally in your machine. Be sure that you upload only valid files (.xls, .xlsx). Otherwise, Type a valid url when choosing the second option.<br/>When the upload process completed successfully, you can go forward (next button will be actived) <br/><a href='#' id='hd1' style='color:green;'>hide help</a></div>"+
						"</div></div>" + 
						"<div class='wizard-card' data-cardname='group' style='overflow: hidden;'>"+"<h3>Display options</h3>"+
						"<a href='#' id='help2'>Click here for help</a><div id='h2'>Step 2 help:<br/><p class='hlp'> Select the number of sheets you need to get their headers.<br/> Then, for each sheet, provide the sheet name, the row and column where the header starts.</p><a href='#' id='hd2' style='color:green;'>hide help</a></div>"+
"<div class='wizard-input-section' style='position: relative; width: 100%; height: 100%; overflow: auto;'>"+"<p>How many table sheets you want?<span id='star'>*</span>"+"<select id ='tables' name='customers' onchange='showTable(this.value)'>"+"<option value='0'></option><option value='1'>1</option>"+"<option value='2'>2</option>"+"<option value='3'>3</option>"+"<option value='4'>4</option>"+"<option value='5'>5</option>"+"</select>"+"</p>"+"<div id='result2'></div>"+
//"<script>$.sheet.preLoad('jquery.sheet/'); $(function() { $('#sheetParent').sheet();});</script>"+
"<div id='sheetParent'><script></script></div>"+"<br/><br/><br/>"+"<input id='sid' type='hidden' value=''/>"+
"</div>"+"</div>"
+"<div class='wizard-card' data-cardname='group3'>"+"<h3>Schema Matching<img src='help.png' width='15' height='15' title='Either choose a value from the option box or select other to put your own input'/></h3>"+"<div id='result3'></div>"+ 
"<a href='#' id='help3'>Click here for help</a><div id='h3'>Step 3 help:<br/><p class='hlp'> Either choose a value from the option box or select other to put your own input.<br/>Fields with (*) must have values, so you can go to the next step.</p><a href='#' id='hd3' style='color:green;'>hide help</a></div>"+
"</div>"+
"<div class='wizard-card' data-cardname='services' style=' overflow: hidden; '>"+//style='width: 720px; overflow: hidden; '>"+
				"<h3>Data Matching<img src='help.png' width='15' height='15' title='Verify the dname or type yours in the proper type box if not correct and then click submit. You can remove undesired dnames by checking the boxes in fornt of them.'/></h3>"+
				"<div class='wizard-input-section' style='position: relative; width: 600px; height: 100%; overflow: auto;'>"+//style='position: relative; width: 780px; height: 100%; overflow: auto;'>"+
				"<table><tr><td><div><img src='help.png' width='15' height='15' title='Type your own name here if you want to redefine the dname and then click the ... button to complete your new definition.'/><input type='text' id='fromDB' value='something from data'/><input type='button' value='...' id='more' />"+
				"<div id='inDiv' style='display:none;'><label for='Dtype'>Type:</label><input type='text' name='Dtype'/><label>Unit:</label><input type='text' name='unit'/><label>Description:</label> <input type='text' name='descr'/></div></div></td>"+
				"<td><div ><img src='help.png' width='15' height='15' title='Click inside this box to suggest some mathces to the data name.'/><input type='text' value='suggested matches' id='suggestmatch'/>"+
				"<div id='suggested'><img src='help.png' width='15' height='15' title='If the name contains a country, plase type it here and check the front box.'/><input type='checkbox' name='country' value='country'>Country&nbsp;&nbsp; <input type='text' id='cntry'/><br/><img src='help.png' width='15' height='15' title='If the name contains a city, plase type it here and check the front box.'/><input type='checkbox' name='city' value='city'>City &nbsp;&nbsp;&nbsp;<input type='text' id='cty'/><br/>"+
				"<img src='help.png' width='15' height='15' title='If the name contains a province, plase type it here and check the front box.'/><input type='checkbox' name='province' value='province'>Province&nbsp;<input type='text' id='prov'/><br/>"+
			"<img src='help.png' width='15' height='15' title='If the name contains an aggrType, plase type it here and check the front box.'/><input type='checkbox' name='aggr' value='aggr'>Aggr Type <input type='text' id='agtype'/><br/>"+
				"<img src='help.png' width='15' height='15' title='If you suggest a new match, plase check here and type the filed name to be matched and complete its information.'/><input type='checkbox' name='other' value='other'>New field:<input type='button' value='...' id='smore' /><div id='sugmoreDiv'><label>Name:</label><input type='text' name='Dtype1'/><br/><label>Value:</label><input type='text' name='unit1'/><br/><label>Description: </label><input type='text' name='descr1'/></div><br/>"+
				"<img src='help.png' width='15' height='15' title='Click this button to allow us to add your entries to the system.'/><input type='button' value='add suggestion' id='addsug'/></div></div></td>"+
				"</tr></table>"+
				"<a href='#' id='help4' >Show help</a><div id='h4'>Step 4 help:<br/><p class='hlp'> In this step, for each Dname, you can match your its name and the related information either by accepting the default match or by giving your own definition (the left column). Also, you can help our system by providing you suggestions to some fileds (the right column)."+
			" <br/>The left part, Type your own name in box if you want to redefine the dnanme and then click the ... button to complete your new definition like the type, unit, etc...<br/> "+
			"The right section, Click inside this box to suggest some mathces to the data name.<br/>"+
			"If the name contains any of the given fields, plase type it box and check the front of it. Also, you can add a new suggestions by choosing other and complete that section.</br/>"+
			"After you are done completing the suggested matches part, click the add suggestion button to allow us to add your entries to the system.<br/>"+
			"You can remove undesired dnames by checking the boxes in fornt of them.</p><a href='#' id='hd4' style='color:green;'>hide help</a></div>"+ "<br/>"+
				"<div id='result4'></div><br/><br/><br/><br/>"+
				//"<a href='#' id='help4' >Show help</a><div id='h4'>Step 4 help:<br/><p class='hlp'> Verify the dname or type yours in the proper type box if not correct and then click submit.<br/> You can remove undesired dnames by checking the boxes in fornt of them.</p><a href='#' id='hd4' style='color:green;'>hide help</a></div>"+ "<br/>"+
				"</div>"+"</div>"+
			"<div class='wizard-error'>"+"<div class='alert alert-error'>"+"<strong>There was a problem</strong> with your completing your submission. Please report this to <a href='mailto:radwanfatima@gmail.com?subject=ErrorReported from Colfusion importing wizard'>Colfusion</a> and restart the wizard again from the main page.<p id='exe'></p></div>"+
			"</div>"+
			"<div class='wizard-failure'>"+"<div class='alert alert-error'>"+"<strong>There was a problem</strong> submitting the form.Please try again in a minute.</div></div>"+
"<div class='wizard-success'>"+"<div class='alert alert-success'>"+"<p id='exe' value=''> Your dataset has been imported successfully. Please click on the finish button to close the wizard and go to the original submit new data page to finish up your submission.</p>"+"<p id='exe'></p>"+"</div>"+"<a id='done' class='btn im-done'>Finish</a> "+"</div>"+"</div>";








				