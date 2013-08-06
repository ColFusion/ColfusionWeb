var table;
var JResult;
var JTitle;
var dataToSend;
/** Variables for sending **/
var search = new Array();
searchStr = "";
var variableArray;
var selectArray;
var conditionArray;

function showResult(){
	/***** Dnames for query - "Households,Married Couples,..." *****/
	document.getElementById("resultDiv").style.visibility = "visible";
	searchStr = document.getElementById("search").value;
	search = searchStr.split(","); selectArray = new Array(); conditionArray = new Array();
	/***** Condition variables - "variable[] select[] conditon[] (Location = 'Taipei')" *****/
	variableArray = new Array(); 
	$.each($("input[name='variable[]']"), function(){
		variableArray.push($(this).val());
	});
	$.each($("select[name='select[]']"), function(){
		selectArray.push($(this).val());
	});
	$.each($("input[name='condition[]']"), function(){
		conditionArray.push($(this).val());
	});
	/***** AJAX for querying, which returns a JSON object *****/
	if(variableArray[0] == ""){
		dataToSend = {'search[]': search};
	} else{
		dataToSend = {'search[]': search,'variable[]':variableArray,'select[]':selectArray,'condition[]':conditionArray};
	}
	// alert(JSON.stringify(dataToSend));
	$.ajax({type: 'POST',
		url: "searchResult.php",data: dataToSend,
		success: function(data){
			showSearchResutls(data);		
		},
    	dataType:'json',async:false});
}

var searchData;

function showSearchResutls(data){

	searchData = data;

	var list = document.getElementById("resultDiv");
	list.innerHTML = "";
	for(var i=0; i < data.length; i++){

		if (data[i].oneSid) {
			showSearchResutlsOneSource(list, data[i], i);	


			var st = "#searchResultVisSpan_" + i;
	 		$(st).click(function(){
	     	//	alert(this.getAttribute("data"));
	     		
	     		var f = document.getElementById("joinRequestToNewPage");
	
				var ind = this.getAttribute("i");

	     		f.dataset.value = JSON.stringify(searchData[ind]);

	     		//window.open('', 'visualizationWindow');
	     		f.submit();
	     	//	var w = window.open(my_pligg_base+"/visualization/dashboard.php"," _blank");
	     		//w.document.getElementById("hiddenJoinQuery").value =this.getAttribute("data") ;
	   		});
		}
		else {
			for (var j = 0; j < data[i].allPaths.length; j++) {
				showSearchResutlsSeveralSource(list, data[i].allPaths[j], i, j);

				var st = "#searchResultVisSpan_" + i + "_" + j;
		 		$(st).click(function(){
		     	//	alert(this.getAttribute("data"));
		     		
		     		var f = document.getElementById("joinRequestToNewPage");
		
					var ind = this.getAttribute("i");
					var jnd = this.getAttribute("j");

		     		f.dataset.value = JSON.stringify(searchData[ind].allPaths[jnd]);

		     		//window.open('', 'visualizationWindow');
		     		f.submit();
		     	//	var w = window.open(my_pligg_base+"/visualization/dashboard.php"," _blank");
		     		//w.document.getElementById("hiddenJoinQuery").value =this.getAttribute("data") ;
		   		});

			};
		}
	}



	
		

	return;
		

		var listItem = document.createElement("div"); 
		listItem.className = "stories";

		var hrefts = "";

		var listItemTitle = document.createElement("h2");

		if (data[i].oneSid) {
			hrefts += "<a id='title" + data[i].sid + "' href='../story.php?title=" + 
			data[i].sid + "'>" + data[i].sidTitle + "</a>";

			listItemTitle.innerHTML = "Dataset(s): " + hrefts;
		}
		else {
			listItemTitle.innerHTML = "Paths"
		}

		

		
		var listItemContent = document.createElement("p");
		listItemContent.innerHTML = "<br /> Matching Columns: " + data[i].searchColumns.join() + "<br/>";

		


		listItem.appendChild(listItemTitle);
		listItem.appendChild(listItemContent);
		// listItem.appendChild(listItemContentShoeMore);

		var str = '<br/><p><span style="cursor:pointer;" id="searchResultVisSpan_' + i + '" data="' + data[i].joinQuery + '"" sisToSearch="' + data[i].sisToSearch +'">Visualize</span></p>';

		$(listItem).append(str);

		str = '<br/><p><span style="cursor:pointer;" id="searchResultSpan_' + i + '">More...</span></p>';

		$(listItem).append(str);

		 str = '<div id="searchResultDiv_' + i + '" style="display: none;"></div>';

		$(listItem).append(str);


		// =""return $('#searchResultDiv_" + i + "').toggle();"">More...</span></p>";
		// str = str + "<div id=""searchResultDiv_" + i + """/>";

		//$(listItem).append(str);

		// var listItemContentShoeMore = document.createElement("p");
		// listItemContentShoeMore.innerHTML = "More... ";



		list.appendChild(listItem);

		var st = "#searchResultVisSpan_" + i;
 		$(st).click(function(){
     	//	alert(this.getAttribute("data"));
     		
     		var f = document.getElementById("joinRequestToNewPage");
     		f.joinQuery.value = this.getAttribute("data");
     		f.sidsWithColumns.value = this.getAttribute("sisToSearch");


     		//window.open('', 'visualizationWindow');
     		f.submit();
     	//	var w = window.open(my_pligg_base+"/visualization/dashboard.php"," _blank");
     		//w.document.getElementById("hiddenJoinQuery").value =this.getAttribute("data") ;
   		});

 		var st = "#searchResultSpan_" + i;
 		$(st).click(function(){
     		var divId = "#searchResultDiv_" + this.id.substring(this.id.indexOf('_') + 1);
     		$(divId).toggle();

     		if ($(divId).css("display") === "none")
     			this.innerText = "More...";
     		else
     			this.innerText = "Less...";
   		});



   		str = "<p>" + "All Columns: " + data[i].allColumns.join() + "</p><br/>";
   		str = str + "<p>" + "Common Columns: " + data[i].commonColumns.join() + "</p><br/>";

   		if (data[i].joinResults) {

   			str += "<p>First 10 rows of the joined dataset: </p> <div style='overflow-x: scroll;'>";

   			str += "<table class='tftable'>";

   			for (var k = 0; k < data[i].joinResults.length; k++) {
				

					if (k ==0) {

						str += "<tr>"

						for(each_name in data[i].joinResults[k]){
							if (each_name != "rnum")
	        					str += "<th>" +  each_name +"</th>";
	    				}	

	    				str += "</tr>"
    				}

				str += "<tr>"
					
					for(each_name in data[i].joinResults[k]){
						if (each_name != "rnum")
        					str += "<td>" +  data[i].joinResults[k][each_name] +"</td>";
    				}	

				str += "</tr>"			
			}

			str += "</table> </div>";
   		}
   		else {
   			str += "<p>No rows in joined dataset. </p>";
   		}

   		$("#searchResultDiv_" + i).append(str);
	
}

function showSearchResutlsOneSource(container, oneSearhResult, i) {
	var listItem = document.createElement("div"); 
		listItem.className = "stories";

		var hrefts = "";

		var listItemTitle = document.createElement("h2");

		hrefts += "<a id='title" + oneSearhResult.sid + "' href='../story.php?title=" + 
		oneSearhResult.sid + "'>" + oneSearhResult.title + "</a>";

		listItemTitle.innerHTML = "Dataset: " + hrefts;
		
		listItem.appendChild(listItemTitle);

		var pElement = document.createElement("p");
		pElement.innerHTML = "<p>" + "All Columns: " + oneSearhResult.allColumns.join() + "</p><br/>";

		listItem.appendChild(pElement);

		pElement = document.createElement("p");
		pElement.innerHTML = '<p><span style="cursor:pointer;" id="searchResultVisSpan_' + i + '" i="' + i + '" j="-1">Visualize</span></p>';

		listItem.appendChild(pElement);

		container.appendChild(listItem);
}

function showSearchResutlsSeveralSource(container, path, i, j){
	var listItem = document.createElement("div"); 
		listItem.className = "stories";

		var hrefts = "";

		var listItemTitle = document.createElement("h2");

		listItemTitle.innerHTML = "Datasets: " + path.sidTitles.join();
		
		listItem.appendChild(listItemTitle);

		var pElement = document.createElement("p");
		pElement.innerHTML = "<p>" + "Average confidence: " + path.avgConfidence + "</p><br/>";

		listItem.appendChild(pElement);

		pElement = document.createElement("p");
		pElement.innerHTML = '<p><span style="cursor:pointer;" id="searchResultVisSpan_' + i + '_' + j + '" i="' + i + '" j="' + j + '">Visualize</span></p>';

		listItem.appendChild(pElement);

		container.appendChild(listItem);
}

function resultDetail(titleNo){
	sid = titleNo.id.substring(5);
	url = "popUpResult.php?sid=" + sid;
	window.open(url,'_blank');
}

function searchData(){
	searchStr = $("input:hidden[name='search']").val();
	variableStr = $("input:hidden[name='variable']").val();
	selectStr = $("input:hidden[name='select']").val();
	conditionStr = $("input:hidden[name='condition']").val();
	// alert(searchStr + " " + variableStr + " " + selectStr + " " + conditionStr);
	search = searchStr.split(",");
	variableArray = variableStr.split(",");
	selectArray = selectStr.split(",");
	conditionArray = conditionStr.split(",");
	sid = $("input:hidden[name='sid']").val();

	if(variableArray[0] == ""){
		dataToSend = {'search[]': search,'sid':sid};
	} else{
		dataToSend = {'search[]': search,'sid':sid,'variable[]':variableArray,'select[]':selectArray,'condition[]':conditionArray};
	}

	$.ajax({type: 'POST',url: "searchTable.php",data: dataToSend,success: function(result){
			JResult = result;
			table = document.getElementById("searchResults");
			// Initial a empty table for use
			while(table.lastChild){
				table.lastChild.remove();
			}
			generableTable();
    },dataType:'json',async:false});
}

function generableTable(){
	table.border = "1px"; // Use CSS to change table style
	var row = table.insertRow(0); i = 0; columnNum = 0;
	for(each_name in JResult[0]){
        row.insertCell(i++).innerHTML = each_name;
        columnNum++;
    }
	for(i=1 ; JResult[i-1]!=null ; i++){
		row = table.insertRow(i);
		j = 0;
		for(each_name in JResult[i-1]){
        	row.insertCell(j++).innerHTML = JResult[i-1][each_name];
    	}
	}
}

function addCondition(){
	var table = document.getElementById("conditionTable");
	if(table.rows.length == 1){
		table.rows[0].cells[4].innerHTML = "";
	}
	if(table.rows.length > 1){
		table.rows[table.rows.length - 1].cells[4].innerHTML = "<input type='button' name='add' value='delete' onClick='deleteCondition(this);' />";
	}
	var row = table.insertRow(table.rows.length);
	row.insertCell(0).innerHTML = "And"
	row.insertCell(1).innerHTML = "<input type ='text' name='variable[]' size='25' />";
	row.insertCell(2).innerHTML = "<select name='select[]'>"
									+"<option value=\"\">---- condition ----</option>"
									+"<option value=\"like\">contains</option>"
									+"<option value=\"=\">equal</option>"
									+"<option value=\"<>\">not equal</option>"
									+"<option value=\"<\">less than</option>"
									+"<option value=\">\">greater than</option>"
									+"<option value=\"<=\">less or equal</option>"
									+"<option value=\">=\">greater or equal</option>"
								+ "</select>";
	row.insertCell(3).innerHTML = "<input type='text' name='condition[]' size='25' />";
	row.insertCell(4).innerHTML = "<input type='button' name='add' value='add' onClick='addCondition();' />"
									+ "<input type='button' name='add' value='delete' onClick='deleteCondition(this);' />";
}

function deleteCondition(row){
	index = row.parentNode.parentNode.rowIndex;
	var table = document.getElementById("conditionTable");
	table.rows[index].remove();
	if(table.rows.length == 1){
		table.rows[0].cells[4].innerHTML = "<input type='button' name='add' value='add' onClick='addCondition();' />";
	}
	if(table.rows.length > 1){
		table.rows[table.rows.length - 1].cells[4].innerHTML = "<input type='button' name='add' value='add' onClick='addCondition();' />"
																+ "<input type='button' name='add' value='delete' onClick='deleteCondition(this);' />";
	}
}