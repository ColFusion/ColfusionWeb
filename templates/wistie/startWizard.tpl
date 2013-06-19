{literal}
<script type="text/javascript" src="{$my_pligg_base}/templates/{$the_template}/js/jquery/jquery.js"></script>
<script type="text/javascript">
	function step2(){
		document.getElementById("f1").style.display="none";
	   document.getElementById("f2").style.display="block";

		}
	function step3(){
		document.getElementById("f1").style.display="none";
		document.getElementById("f2").style.display="none";
	   document.getElementById("f3").style.display="block";
		}

	function step4(){
		document.getElementById("f1").style.display="none";
		document.getElementById("f2").style.display="none";
	   document.getElementById("f3").style.display="none";
	   document.getElementById("f4").style.display="block";
	   document.getElementById("last_submit").style.display="block";
		}
</script>

</head>
{/literal}

<div id="dialog" title="Basic dialog">
    <div id="main">
		
       <form id="SignupForm" name="upload_form" action="{$my_pligg_base}/startWizard.php" method="post" enctype="multipart/form-data">
		<!--- Step 1 -->
        <fieldset id="f1" style="display:block">
            <legend>Import your Table</legend>
			
			<h2>Save your file to generate adress for Pentaho</h2>
			<div id="upload_content">  
					<b>Select your file: </b> <input type="file" class="upload-file" size="31" id="upload-file" name="upload_file" />
					<input type="text" class="upload-text" id="upload-text" />&nbsp<button id ="btn_browse">Browse..</button>
					<input type="button" name="submit" value="Submit" onclick="step2()"><br/><br/>	
			</div>
        </fieldset>


		<!--- Step 2 -->
        <fieldset id="f2" style="display:none">
            <legend>Table information</legend>
            <label for="Columns">The table header starts in row </label>
				Sheet:<input type="text" class="upload-text" name="sheet"/>
				Row:<input type="text" class="upload-text" name="row"/>
				column:<input type="text" class="upload-text" name="col"/>
             <input type="button" name="submit" value="Submit" onclick="step3()"><br/><br/>	
        </fieldset>



		<!--- Step 3 -->
        <fieldset id="f3" style="display:none">
            <legend>step3</legend>
					Spd:<input type="text" class="upload-text" name="spd"/><br/>
					Drd:<input type="text" class="upload-text" name="drd"/><br/>
					Start:<input type="text" class="upload-text" name="start"/><input type="text" class="upload-text" name="start2"/><br/>
					End:<input type="text" class="upload-text" name="end"/><input type="text" class="upload-text" name="end2"/><br/>
					Location from excel:<input type="text" class="upload-text" name="location"/><br/>
					
					Location from imput<input type="text" class="upload-text" name="location2"/><br/>
					AggrType from excel:<input type="text" class="upload-text" name="aggrtype"/><br/>
					AggrType from input:
					<input type="text" class="upload-text" name="aggrtype2"/>
            <input type="button" name="submit" value="Submit" onclick="step4()"><br/><br/>	
        </fieldset>



		<!--- Step 4 -->
        <fieldset id="f4" style="display:none">
            <legend>Row nomalizer</legend>
            <label >Fields:</label>
 
        </fieldset>
		
		
        <p id="last_submit" style="display:none">
				<input type="hidden" name="phase" value=1>
            <input id="SaveAccount" type="submit" value="Save and Submit" />
        </p>
        </form>
    </div>
	</div>

