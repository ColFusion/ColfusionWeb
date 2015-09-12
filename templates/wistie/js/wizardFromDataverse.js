/**
 * Download file from Harvard Dataverse to server.
 * @return {[type]} [description]
 */
function downloadRequest() {
    debugger;
    $('#uploadTimestamp').val(new Date().getTime()); // Why do we need it?

    //TODO figure exactly what it is and give it a better name
    var ids = $("input[name='fileid']:checked").val();
    var name = $("input[name='fileid']:checked").attr("data-value");
    var sid = $("#uploadFormSid").val();
    var uploadTimestamp = $("#uploadTimestamp").val(); // Why do we need it?
	
    $.ajax({
        url: restApis.getDataverseDownload(ids, name, sid, uploadTimestamp),
        type: 'GET',
        dataType: 'application/json',
        contentType: 'application/json',
        success: function(data) {
			//console.log(data);
			$('#downloadMessage').text("Upload Successfully!");
			wizard.enableNextButton();
			var resultJson = JSON.parse(data);
            wizardFromFile.fromComputerUploadFileViewModel.uploadedFileInfos.push(resultJson.payload[0]);
			wizardFromFile.fromComputerUploadFileViewModel.isUploadSuccessful(resultJson.isSuccessful);
			wizardFromFile.fromComputerUploadFileViewModel.uploadMessage(resultJson.message);
        },
        error: function(data) {
            alert("Something went wrong while getting files list. Please try again.");
        }
    });
}
		
/**
 * Search files on the Harvard Dataverse
 * @return {[type]} [description]
 */
function searchDataverse() {
    debugger;
	$('#searchField').hide();
	$('#searchResult').show();
	
    if($('#filenum').text().indexOf("no") > -1){
		$('#uploadbtn').hide();
	}

	if($('#filenum').text().indexOf("0") > -1){
		$('#uploadbtn').hide();
	}

	$('#downloadResult').show();

    var fileName = $("#dataverseFile").val();
    var dataverseName = $("#dataverseName").val();
    var datasetName = $("#datasetName").val();

	$.ajax({
		url: restApis.getDataverseSearch(fileName, dataverseName, datasetName),	
		type: 'GET',
		dataType: 'application/json',
		success: function(data) {
            var json = JSON.parse(data);
            $('#filenum').text("There are " + json.length + " files.");
            $('<p>  </p>' ).appendTo($('#filenum'));
            for (i = 0; i < json.length; i++){
                var obj = JSON.parse(json[i]);
                var id = obj.file_id;
                var name = obj.name;
                var radioBtn = $('<input type="radio" name="fileid" value="' + id + '" data-value="' + name + '"/>');

                var s = " FILE NAME: " + obj.name + ";    SIZE: " + obj.size_in_bytes + ";    INFORMATION: " + obj.dataset_citation + "</br>";
                
                radioBtn.appendTo($('#filenum'));
                $('#filenum').append(s);            
           }

		   $('#uploadbtn').show();    
		},
		error: function(data) {
			alert("Something went wrong while getting services' list. Please try again.");
		}
	});
}			