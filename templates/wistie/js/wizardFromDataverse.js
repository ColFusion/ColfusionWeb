
/*Download file from Harvard Dataverse to server. */
  function downloadRequest() {
       

				$('#uploadTimestamp').val(new Date().getTime());
                $.ajax({
                    url:ColFusionServerUrl+"/HDataverse/DownLoad/"+$("input[name='fileid']:checked").val()+"/"+$("input[name='fileid']:checked").attr("data-value")+"/"+$("#uploadFormSid").val()+"/"+$("#uploadTimestamp").val(),
                    type: 'POST',
                    dataType: 'text',
                    contentType: "application/json",
                    crossDomain: true,
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
                        alert("Something went wrong while getting services' list. Please try again.");
                    }
                });

            
        }
		
/*Search files on the Harvard Dataverse*/
   function searchDataverse() {
					$('#searchField').hide();
					$('#searchResult').show();
					if($('#filenum').text().indexOf("no") > -1){
						$('#uploadbtn').hide();
					}
					if($('#filenum').text().indexOf("0") > -1){
						$('#uploadbtn').hide();
					}
					$('#downloadResult').show();
					
				// dataset name is not required
                 if($("#datasetName").val()==null||$("#datasetName").val().length<0){
                    $.ajax({
						url: ColFusionServerUrl+"/HDataverse/DataverseName/"+$("#dataverseFile").val()+"/"+$("#dataverseName").val(),
  
                        type: 'POST',
                        dataType: 'text',
                        contentType: "application/json",
                        crossDomain: true,
                        success: function(data) {

                            var json = JSON.parse(data);
                            $('#filenum').text("There are "+json.length+" files.");
                            $('<p> </p>' ).appendTo($('#filenum'));
                           
                            for(i=0;i<json.length;i++){
                                var obj=JSON.parse(json[i]);
                                var id=obj.file_id;
                                var name=obj.name;
                                var radioBtn = $('<input type="radio" name="fileid" value="' + id + '" data-value="'+name+'"/>');
                      
                                var s=" FILE NAME: "+obj.name+";    SIZE: "+obj.size_in_bytes+";    INFORMATION: "+obj.dataset_citation+"</br>";
                               
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
                 else{
    				$.ajax({
						url: ColFusionServerUrl+"/HDataverse/DataverseName/"+$("#dataverseFile").val()+"/"+$("#dataverseName").val()+"/"+$("#datasetName").val(),
    					
    					type: 'POST',
    					dataType: 'text',
    					contentType: "application/json",
    					crossDomain: true,
    					success: function(data) {
                            var json = JSON.parse(data);
                            $('#filenum').text("There are "+json.length+" files.");
                            $('<p>  </p>' ).appendTo($('#filenum'));
                            for(i=0;i<json.length;i++){
                                var obj=JSON.parse(json[i]);
                                var id=obj.file_id;
                                var name=obj.name;
                                var radioBtn = $('<input type="radio" name="fileid" value="' + id + '" data-value="'+name+'"/>');
          
                                var s=" FILE NAME: "+obj.name+";    SIZE: "+obj.size_in_bytes+";    INFORMATION: "+obj.dataset_citation+"</br>";
                                
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
				
			}

			