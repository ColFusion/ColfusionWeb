function Canvas(vid,name,privilege,authorization,mdate,cdate,note) {
	this.vid = vid;
	this.name = name;
	this.privilege = privilege;
	this.authorization = authorization;
	this.mdate = mdate;
	this.cdate = cdate;
	this.note = note;
	this.selectedChart = null;
	this.stories = new Array();
	this.isSave = false;
}
//use sid to get story name and tables in the story
Canvas.prototype.addStory = function(obj,callback) {
	if (CANVAS.stories[obj.sid]!=null) {
		return;
	}
	$.ajax({
		type: 'POST',
		url: 'control.php',
		data: {
			action: 'getStory',
			obj: JSON.stringify(obj)
			},
		async:false,
		success: function(JSON_Response) {
			JSON_Response = jQuery.parseJSON(JSON_Response);
			if(JSON_Response['status'] == 'success'){
				/*var sid = JSON_Response['sid'];
				var sname = JSON_Response['sname'];
				var tables = JSON_Response['tables'];*/
				$('#chart-dropdown').show();
				$("#view-dropdown").show();
				var story = JSON_Response['story'];
				var sid = story.sid;
				CANVAS.stories[sid] = story;
				showSuccess("Successfully add story "+ story['sname']);
			}else{
				
			}
			if (callback!=null) {
				callback(JSON_Response);
			}
			
		}
		
		})
}
//get the story name and tables in the a story
Canvas.prototype.getStory = function(sid) {
	return CANVAS.stories[sid];
}
Canvas.prototype.getColumnType = function(sid,table,column){
	return CANVAS.stories[sid].tables[table].columns[column];
}
//get all the story names and tables 
Canvas.prototype.getStories = function() {
	return CANVAS.stories;
}

//get related charts to sid in 'charts'
Canvas.prototype.getStoryRelatedCharts = function(sid) {
	var rst = new Array();
	var chart;
	for (chart in CHARTS) {
		if (CHARTS[chart].getSid() == sid) {
			rst.push(CHARTS[chart]);
		}
	}
	return rst;
}
//get table related charts
Canvas.prototype.getTableRelatedCharts = function(sid,table) {
	var rst = new Array();
	var chart;
	for (chart in CHARTS) {
		if (CHARTS[chart].getSid() == sid && CHARTS[chart].getTable() == table) {
			rst.push(CHARTS[chart]);
		}
	}
	return rst;
}
//get the columns in one table in one story
Canvas.prototype.getColumns = function(sid,table){
	
}
Canvas.prototype.save = function(name, privilege, note){
	this.name = name;
	this.privilege = privilege;
	this.note = note;
	$('#canvasName').val(name);
	$('#privilege').val(privilege);
	$('#note').val(note);
	if (CANVAS.authorization == 2) {
                this.setCanvasName(name+" (Read-Write)");
	}else if(CANVAS.authorization == 0){
                this.setCanvasName(name);
		
	}else{
                this.setCanvasName(name+" (Read-Only)");
	}
	
	this.isSave = true;
}
Canvas.prototype.setVid = function(vid){
	this.vid = vid;
	$('#vid').val(vid);
}
Canvas.prototype.setCanvasName = function(name) {
        this.name = name;
        if (name.length > 27) {
            name = name.substr(0,26)+"...";
        }
        $('#brand').text(name);
}