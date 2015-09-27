var myprotocol = window.location.protocol;
var myhost = window.location.host;

var ColFusionDomain = myprotocol + '//' + myhost; 

//e.g., "/" or "/Colfusion/"
var ColFusionAppPath = "/colfusion/";

var ColFusionServerUrl = "/REST"; // for prod on poirot: "http://colfusion.exp.sis.pitt.edu/REST";  //"http://localhost:8080/ColFusionServer/rest"; 
var OpenRefineUrl = "/OpenRefine";
var ColFusionServiceMonitorUrl = myprotocol + '//' + myhost + ':7473/rest';

// The following describtes REST API endpoints

var restApis = (function() {
	var restApis = {};

	var harvardDataverse = "HarvardDataverse";

	restApis.postGetDataFile = function() {
		var url = ColFusionServerUrl + "/" + harvardDataverse + "/getDataFile";

		console.log(url);

		return url;
	};

	restApis.getDataverseSearch = function(fileName, dataverseName, datasetName) {
		var url = ColFusionServerUrl + "/" + harvardDataverse + "/searchForFile?dataverseName=" + dataverseName + 
						"&fileName=" + fileName + "&datasetName=" + datasetName;

		console.log(url);

		return url;
	};

	return restApis;
})();
