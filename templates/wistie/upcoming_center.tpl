<!DOCTYPE html>
<html>
<head>
	<title>Col*Fusion - List of drafts</title>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="css/bootstrap.min2.css" rel="stylesheet" media="screen">
</head>
<body>
			<div>
		    	<table class="table">		            
		            <tbody data-bind="foreach: drafts">
		                <tr data-bind="click: $root.editDraft" >    	
		                    <td data-bind="text: title"></td>
		                </tr>
		                	<tr data-bind="text: createdBy"></tr> 
							<tr data-bind="text: createdOn"></tr>						        
		            </tbody>
		        </table>
			</div>
		
    <script type="text/javascript" src="javascripts/jquery-2.1.3.min.js"></script>
    <script type="text/javascript" src="javascripts/bootstrap.min.js"></script>
    <script type="text/javascript" src="javascripts/knockout-2.3.0.js"></script>
    <script type="text/javascript" src="javascripts/knockout_models/draftViewModel.js"></script>
</body>
</html>



