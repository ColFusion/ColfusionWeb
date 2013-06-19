var dataSourceUtil = (function() {
    var dataSourceUtil = {};
    var dataSourceCache = new Persist.Store('colfusion_datasource');

    dataSourceUtil.getTablesList = function(sid) {
        
        var tableListCache = dataSourceCache.get('tableList_' + sid);
        if (tableListCache) {
            return $.Deferred().resolve(JSON.parse(tableListCache));
        } else {
            return $.ajax({
                type: 'POST',
                url: "visualization/VisualizationAPI.php?action=GetTablesList",
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
            url: "visualization/VisualizationAPI.php?action=GetTableInfo",
            data: {'sid': sid, 'table_name': tableName},
            dataType: 'json'
        });
    };

    dataSourceUtil.getTableDataBySidAndName = function(sid, tableName, perPage, pageNo) {
        return $.ajax({
            type: 'POST',
            url: "visualization/VisualizationAPI.php?action=GetTableDataBySidAndName",
            data: {'sid': sid, 'table_name': tableName, 'perPage': perPage, 'pageNo': pageNo},
            dataType: 'json'
        });
    };

    dataSourceUtil.mineRelationship = function(sid, perPage, pageNo) {
        return $.ajax({
            type: 'POST',
            url: "DataImportWizard/ImportWizardAPI.php?action=MineRelationships",
            data: {'sid': sid, 'perPage': perPage, 'pageNo': pageNo},
            dataType: 'json'
        });
    };

    dataSourceUtil.checkDataMatching = function(fromData, toData) {
        return $.ajax({
            type: 'POST',
            url: "visualization/VisualizationAPI.php?action=CheckDataMatching",
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

    return dataSourceUtil;
})();