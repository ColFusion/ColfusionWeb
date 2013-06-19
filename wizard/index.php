<?php
include("classes/easy_upload/upload_class.php"); //classes is the map where the class file is stored

$error = '';
$image = '';
$copy_link = '';
		
if (isset($_POST['Submit'])) {
	$my_upload = new file_upload();
	$my_upload->upload_dir = 'uploads/';//$_SERVER['DOCUMENT_ROOT']."/modal-upload/files/";
	$my_upload->extensions = array(".xlsx"); // allowed extensions
	$my_upload->rename_file = true;
	$my_upload->the_temp_file = $_FILES['upload']['tmp_name'];
	$my_upload->the_file = $_FILES['upload']['name'];
	$my_upload->http_error = $_FILES['upload']['error'];
	if ($my_upload->upload()) {
		$image = $my_upload->file_copy;
		$copy_link = ' | <a id="closelink" href="#" onclick="self.parent.tb_remove();">Pass file name</a>';
	} 
	$error = $my_upload->show_error_string();
}
?>
<!DOCTYPE html>
<html>

	<head>
		<link href="bootstrap.min.css" rel="stylesheet" />
		<link href="bootstrap-wizard.css" rel="stylesheet" />
		<link href="chosen.css" rel="stylesheet" />

		<style type="text/css">
	        .wizard-modal p {
	        	margin: 0 0 10px;
	        	padding: 0;
	        }

			#wizard-ns-detail-servers, .wizard-additional-servers {
				font-size:12px;
				margin-top:10px;
				margin-left:15px;
			}
			#wizard-ns-detail-servers > li, .wizard-additional-servers li {
				line-height:20px;
				list-style-type:none;
			}
			#wizard-ns-detail-servers > li > img {
				padding-right:5px;
			}

			.wizard-modal .chzn-container .chzn-results {
				max-height:150px;
			}
			.wizard-addl-subsection {
				margin-bottom:40px;
			}
		</style>
		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="jquery.min.js"></script>
<link rel="stylesheet" href="style.css" type="text/css" media="screen" />
<script type="text/javascript">
$(document).ready(function() { 
	
	$("#closelink").click(function() {
		$("#myfile", top.document).val('<?php echo $image; ?>');
	});
	
});

$(function() {
	  $('#tohide').hide();
   });


$(document).ready(function(){
	$("#computer").click(function(){
	  $('#tohide').show();
   });
   });
   
   $(document).ready(function(){
	$("#internet").click(function(){
	  $('#tohide').hide();
   });
   });
   
   $(document).ready(function(){
	$("#search").click(function(){
	  $('#tohide').hide();
   });
   });
</script>
	</head>

	<body style="padding:30px;">

		<div style="margin-bottom:20px;">
			<!--<a href="http://panopta.com" target="_blank">
				<img style="width:220px;" src="https://my.panopta.com/static/images/Panopta-Logo.png">
			</a>-->
		</div>
		
		<button id="open-wizard" class="btn btn-primary">Launch wizard</button>


		<div class="wizard" id="wizard-demo">
			<h1>Importing wizard</h1>

			<div class="wizard-card" data-onValidated="setServerName" data-cardname="name">
				<h3>Step 1</h3>

				<div class="wizard-input-section">
					<p>
						To import your table, please choose one of the following sources:
					</p>

					<div class="control-group">
						<input id="computer" type="radio" name="place"
							placeholder="FQDN or IP"  /> From this computer <br/>
							
							<form   class="upload-form" name="upload_form" id="upload_form" action="index.php" method="post" enctype="multipart/form-data" target="upload_iframe">
								<input type="hidden" name="phase" value="1">
								<p id ="tohide">
				<label for="upload"><b>Select file:</b></label> <input name="upload" type="file" size="15" />
				<br />
				<input type="submit" name="Submit" value="Upload" />
			</p>
								<!--<b>Select your file: </b> <input type="file" class="upload-file" size="31" id="upload-file" name="upload_file" />
								<input type="text" class="upload-text" id="upload-text" />&nbsp <button id ="btn_browse">Browse..</button>
								<!--<input type="submit"  name="upload" value="Upload" onclick='submitUploadForm(this.form)' class="upload-sub" />
								<input type="submit" name="submit" value="Upload" />-->
							</form>
							<p><?php echo $error; ?></p>
							<!--<p><a href="#" onclick="self.parent.tb_remove();">Cancel</a><?php echo $copy_link; ?></p>-->
						<input id="internet" type="radio" name="place"
							placeholder="FQDN or IP"  /> Internet accessable resource <br/>
							
						<input id="search" type="radio" name="place"
							placeholder="FQDN or IP"  /> Search public data sets <br/>
					</div>
				</div>

			</div>


			<div class="wizard-card" data-cardname="group">
				<h3>Step 2</h3>

				<div class="wizard-input-section">
					<p>
						Where do you want the table header to start:
					</p>
					<select id="col">
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
						<option value="5">5</option>
						<option value="6">6</option>
						<option value="7">7</option>
						<option value="8">8</option>
						<option value="9">9</option>
						<option value="10">10</option>
					</select>
				</div>
			</div>


			<div class="wizard-card" data-cardname="services">
				<h3>Step 3</h3>

				<div class="wizard-input-section">
					<p>
						Raw normalizer
					</p>
				</div>
			</div>



			<div class="wizard-error">
				<div class="alert alert-error">
					<strong>There was a problem</strong> with your submission.
					Please correct the errors and re-submit.
				</div>
			</div>

			<div class="wizard-failure">
				<div class="alert alert-error">
					<strong>There was a problem</strong> submitting the form.
					Please try again in a minute.
				</div>
			</div>

			<div class="wizard-success">
				<div class="alert alert-success">
					<p> Your table has been imported successfully.</p>
				</div>
			</div>
			
				<a class="btn im-done">Done</a>

		</div>


		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
		<script src="chosen.jquery.js"></script>
		<script src="bootstrap.min.js"></script>
		<script src="bootstrap-wizard.js"></script>


<script type="text/javascript">

function setServerName(card) {
	var host = $("#new-server-fqdn").val();
	var name = $("#new-server-name").val();
	var displayName = host;

	if (name) {
		displayName = name + " ("+host+")";
	};

	card.wizard.setSubtitle(displayName);
	card.wizard.el.find(".create-server-name").text(displayName);
}

function validateIP(ipaddr) {
    //Remember, this function will validate only Class C IP.
    //change to other IP Classes as you need
    ipaddr = ipaddr.replace(/\s/g, "") //remove spaces for checking
    var re = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/; //regex. check for digits and in
                                          //all 4 quadrants of the IP
    if (re.test(ipaddr)) {
        //split into units with dots "."
        var parts = ipaddr.split(".");
        //if the first unit/quadrant of the IP is zero
        if (parseInt(parseFloat(parts[0])) == 0) {
            return false;
        }
        //if the fourth unit/quadrant of the IP is zero
        if (parseInt(parseFloat(parts[3])) == 0) {
            return false;
        }
        //if any part is greater than 255
        for (var i=0; i<parts.length; i++) {
            if (parseInt(parseFloat(parts[i])) > 255){
                return false;
            }
        }
        return true;
    }
    else {
        return false;
    }
}

function validateFQDN(val) {
	return /^[a-z0-9-_]+(\.[a-z0-9-_]+)*\.([a-z]{2,4})$/.test(val);
}

function fqdn_or_ip(el) {
	var val = el.val();
	ret = {
		status: true
	};
	if (!validateFQDN(val)) {
		if (!validateIP(val)) {
			ret.status = false;
			ret.msg = "Invalid IP address or FQDN";
		}
	}
	return ret;
}


$(function() {
	$.fn.wizard.logging = true;

	var wizard = $("#wizard-demo").wizard();

	$(".chzn-select").chosen();


	wizard.el.find(".wizard-ns-select").change(function() {
		wizard.el.find(".wizard-ns-detail").show();
	});

	wizard.el.find(".create-server-service-list").change(function() {
		var noOption = $(this).find("option:selected").length == 0;
		wizard.getCard(this).toggleAlert(null, noOption);
	});

	wizard.cards["name"].on("validated", function(card) {
		var hostname = card.el.find("#new-server-fqdn").val();
	});

	wizard.on("submit", function(wizard) {
		var submit = {
			"hostname": $("#new-server-fqdn").val()
		};

		setTimeout(function() {
			wizard.trigger("success");
			wizard.hideButtons();
			wizard._submitting = false;
			wizard.showSubmitCard("success");
			wizard._updateProgressBar(0);
		}, 2000);
	});

	wizard.on("reset", function(wizard) {
		wizard.setSubtitle("");
		wizard.el.find("#new-server-fqdn").val("");
		wizard.el.find("#new-server-name").val("");
	});

	wizard.el.find(".wizard-success .im-done").click(function() {
		wizard.reset().close();
	});

	wizard.el.find(".wizard-success .create-another-server").click(function() {
		wizard.reset();
	});

	$(".wizard-group-list").click(function() {
		alert("Disabled for demo.");
	});

	$("#open-wizard").click(function() {
		wizard.show();
	});

	//wizard.show();
});

</script>



	</body>
</html>
