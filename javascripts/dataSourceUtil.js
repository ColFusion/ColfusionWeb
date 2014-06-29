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
    dataSourceUtil.getTableInfo = function(sid, tableName) {
        return $.ajax({
            type: 'POST',
            url: my_pligg_base + "/visualization/VisualizationAPI.php?action=GetTableInfo",
            data: {'sid': sid, 'table_name': tableName},
            dataType: 'json'
        });
    };

    dataSourceUtil.getTableDataBySidAndName = function(sid, tableName, perPage, pageNo) {
        return $.ajax({
            type: 'POST',
            url: my_pligg_base + "/visualization/VisualizationAPI.php?action=GetTableDataBySidAndName",
            data: {'sid': sid, 'table_name': tableName, 'perPage': perPage, 'pageNo': pageNo},
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

    dataSourceUtil.mineRelationship = function(sid, perPage, pageNo) {
        return $.ajax({
            type: 'POST',
            url: my_pligg_base + "/DataImportWizard/ImportWizardAPI.php?action=MineRelationships",
            data: {'sid': sid, 'perPage': perPage, 'pageNo': pageNo},
            dataType: 'json'
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

    dataSourceUtil.updateColumnMetaData = function(sid,oldname,name,variableValueType,originalName,description,variableMeasuringUnit,variableValueFormat,missingValue) {
      return  $.ajax({
            type: 'POST',
            url: my_pligg_base + "/visualization/VisualizationAPI.php?action=UpdateColumnMetaData",
            data: {'sid': sid, 'oldname': oldname, 'name': name, 'variableValueType': variableValueType, 'originalName': originalName, 'description': description, 'variableMeasuringUnit': variableMeasuringUnit, 'variableValueFormat': variableValueFormat, 'missingValue': missingValue},
            dataType: 'json'
           
        });
        
    }

    return dataSourceUtil;
})();
