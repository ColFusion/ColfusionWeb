// function saveOpenRefineChanges(openRefinProjectId) {
// 	$.ajax({
//             url: ColFusionServerUrl + "/OpenRefine/saveChanges/" + openRefinProjectId, 
//             type: 'GET',
//             dataType: 'json',
//             contentType: "application/json",
//             crossDomain: true,
//             success: function(data) {                
//                 if (data.successful) {                   
//                     var testMsg = data.payload;
//                     alert(testMsg);                  
//                 }
//             }
//         });
// }