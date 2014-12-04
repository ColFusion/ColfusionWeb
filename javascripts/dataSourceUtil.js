var dataSourceUtil = (function() {
    var dataSourceUtil = {};
    var dataSourceCache = new Persist.Store('colfusion_datasource');

    // NOTICE: This function caches table list.
    // If data source is changed manually, make sure the cache is also cleaned.
    dataSourceUtil.getTablesList = function(sid) {
        
        var tableListCache = dataSourceCache.get('tableList_' + sid);
        if (tableListCache) {
            return $.Deferred().resolve(JSON.parse(tableListCache));
        } else {
            return $.ajax({
                type: 'POST',
                url: my_pligg_base + "/visualization/VisualizationAPI.php?action=GetTablesList",
                data: {'sid': sid},
                dataType: 'json'
            }).pipe(function(data) {
                dataSourceCache.set('tableList_' + sid, JSON.stringify(data));
                return data;
            });
        }
    };

    // Get colmuns and their metadata of a table.
     // dataSourceUtil.getTableInfo = function(sid, tableName) {
        // return $.ajax({
            // type: 'POST',
           // url: my_pligg_base + "/visualization/VisualizationAPI.php?action=GetTableInfo",
             // data: {'sid': sid, 'table_name': tableName},
             // dataType: 'json'
         // });
    // }; 

	dataSourceUtil.getTableInfo = function(sid, tableName){
	  return $.ajax({
			// url: ColFusionServerUrl + "/Story/" + sid + "/" + tableName + "/tableInfo",
			// type: 'GET',
			// dataType: 'json',
            // contentType: "application/json",
			url: ColFusionServerUrl + "/Story/" + sid + "/" + tableName + "/metadata/columns",
                type: 'GET',
                dataType: 'json',
                contentType: "application/json",
	  });
	}
	
    // dataSourceUtil.getTableDataBySidAndName = function(sid, tableName, perPage, pageNo) {
        // return $.ajax({
            // type: 'POST',
            // url: my_pligg_base + "/visualization/VisualizationAPI.php?action=GetTableDataBySidAndName",
            // data: {'sid': sid, 'table_name': tableName, 'perPage': perPage, 'pageNo': pageNo},
            // dataType: 'json'
        // });
    // };
	
	dataSourceUtil.getTableDataBySidAndName = function(sid, tableName, perPage, pageNo) {
	  // return $.ajax({
             // type: 'POST',
             // url: my_pligg_base + "/visualization/VisualizationAPI.php?action=GetTableDataBySidAndName",
             // data: {'sid': sid, 'table_name': tableName, 'perPage': perPage, 'pageNo': pageNo},
             // dataType: 'json'
         // });
     // };
	
		 return $.ajax({
             type: 'GET',
             url: ColFusionServerUrl + "/Story/" + sid + "/" + tableName + "/tableData/" + perPage + "/" +pageNo,
             dataType: 'json'
         });
	 };
    
    dataSourceUtil.getTableDataByObject = function (object, perPage, pageNo) {
        return $.ajax({
            type: 'POST',
            url: my_pligg_base + "/visualization/VisualizationAPI.php?action=GetTableDataBySidAndName",
            data: { 'sid': JSON.stringify(object), 'table_name': 'object', 'perPage': perPage, 'pageNo': pageNo },
            dataType: 'json'
        });
    };

    dataSourceUtil.getTableDataByRelIds = function (relIds, simThreshold, perPage, pageNo) {

//TODO: add perPage and pageNo
        var data = {relationshipIds: relIds, similarityThreshold: simThreshold};

        return $.ajax({
            url: ColFusionServerUrl + "/SimilarityJoin/joinByRelationships",
            type: 'POST',
            dataType: 'json',
            contentType: "application/json",
            crossDomain: true,
            data: JSON.stringify(data),
        });
    };

    dataSourceUtil.mineRelationship = function(sid, perPage, pageNo) {
       // This mining relationships funcitonality is not yet implmented in java. The ajax query below just return the 
       // existing relationships from db, it doesn't trigger mining the relationships.
        // $.ajax({
        //     type: 'POST',
        //     url: my_pligg_base + "/DataImportWizard/ImportWizardAPI.php?action=MineRelationships",
        //     data: {'sid': sid, 'perPage': perPage, 'pageNo': pageNo},
        //     dataType: 'json',
        //     success: function(data) {
        //         console.log("Finished mining relationshps");
        //     },
        //     error: function(data) {
        //         console.log("error while mining relationshps");
        //     }
        // });

        return $.ajax({
            url: ColFusionServerUrl + "/Story/" + sid + "/MineRelationships/" + perPage + "/" + pageNo, //my_pligg_base + '/DataImportWizard/ImportWizardAPI.php?action=GetStoryStatus',
            type: 'GET',
            dataType: 'json',
            contentType: "application/json",
        });
    };

    dataSourceUtil.checkDataMatching = function(fromData, toData) {
        return $.ajax({
            type: 'POST',
            url: my_pligg_base + "/visualization/VisualizationAPI.php?action=CheckDataMatching",
            data: {
                "from": fromData,
                "to": toData,
            },
            dataType: 'json'
        });
    };

    // Process data from Visualization API to headers and rows for data table.
    // Return an object with columns and rows.
    // columns: [1, 2, 3]
    // rows: [[r1, r1, r1], [r2, r2, r2]]
    dataSourceUtil.transformRawDataToColsAndRows = function(rawData) {
        var obj = {};

        //  var colsChosenName = rawData.Control.colChosenName.split(',');
        // for (var i = 0; i < colsChosenName.length; i++) {
        //     colsChosenName[i] = colsChosenName[i].replace(/\`/g, '');
        // }

        //TODO: comma is not good as column name separator, what if variable name has comma in it
        var cols = rawData.Control.cols.split(',');
        for (var i = 0; i < cols.length; i++) {
            cols[i] = cols[i].replace(/\`/g, '');
        }

        var rows = [];
        for (var i = 0; i < rawData.data.length && i < 10; i++) {
            var rowObj = rawData.data[i];
            var row = [];
            for (var j = 0; j < cols.length; j++) {
                row.push(rowObj[cols[j]]);
            }
            rows.push(row);
        }

        obj.columns = cols;
        obj.rows = rows;
        return obj;
    };

    dataSourceUtil.loadRelationshipInfo = function(relId, simThreshold) {
        return $.ajax({
            url: my_pligg_base + '/datasetController/relationshipInfo.php',
            data: { relId: relId, simThreshold: simThreshold },
            type: 'POST',
            dataType: 'json'           
        });
    };

    dataSourceUtil.updateColumnMetaData = function(sid,oldname,name,variableValueType,description,variableMeasuringUnit,variableValueFormat,missingValue) {
      return  $.ajax({
            type: 'POST',
            url: my_pligg_base + "/visualization/VisualizationAPI.php?action=UpdateColumnMetaData",
            data: {'sid': sid, 'oldname': oldname, 'name': name, 'variableValueType': variableValueType, 'description': description, 'variableMeasuringUnit': variableMeasuringUnit, 'variableValueFormat': variableValueFormat, 'missingValue': missingValue},
            dataType: 'json'
           
        });
        
    };

    dataSourceUtil.mapSertverTableToDataPreviewTable = function(serverTable) {

        //TODO: read page information from passed object
        //
       
debugger;
        var result = {"data":[], "Control": {"cols": "", "perPage":"10", "totalPage":1, "pageNo": 1}};

        if (typeof serverTable.payload.jointTable === 'undefined' ||
            serverTable.payload.jointTable === null) {
            return result;
        }

        var serverTableRows = serverTable.payload.jointTable.rows;

        var columnNames = [];
        var rows = [];

        for (var k = 0; k < serverTableRows.length; k++) {
            var serverTableRow = serverTableRows[k];
            var rowToAdd = {};
            for (var i = 0; i < serverTableRow.columnGroups.length; i++) {
                var columnGroup = serverTableRow.columnGroups[i];
                var columns = columnGroup.columns;

                for (var j = 0; j < columns.length; j++) {
                    var column = columns[j];

                    var columnName = columnGroup.tableName + "." + column.originalName;
                    if (k === 0) {
                        columnNames.push(columnName);
                    }

                    rowToAdd[columnName] = column.cell.value;

                }
            }

            rows.push(rowToAdd);
        }

        result.data = rows;
        result.Control.cols = columnNames.join(",");
		result.Control.perPage = serverTable.payload.perPage;
		result.Control.totalPage = serverTable.payload.totalPage;
		result.Control.pageNo =	serverTable.payload.pageNo;

        return result;
    };



    return dataSourceUtil;
})();
