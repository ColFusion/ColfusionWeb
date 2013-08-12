function Chart(cid,name,type,top,left,height,width,depth,note,datainfo,queryResult,gadgetID) {
	this.cid = cid;
	this.name = name;
	this.type = top;
	this.left = left;
	this.height = height;
	this.width = width;
	this.depth = depth;
	this.note = note;
	this.datainfo = datainfo;
	this.queryResult = queryResult;
	this.gadgetID = gadgetID;
	CANVAS.addStory(datainfo.inputObj);
}
//get the sid from the chart datainfo
Chart.prototype.getSid = function() {
	return this.datainfo.sid;
}
//get the table from the chart datainfo
Chart.prototype.getTable = function() {
	return this.datainfo.table;
}
//get the story name of the chart
Chart.prototype.getSname = function() {
	return this.datainfo.sname;
}