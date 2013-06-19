google.load('visualization', '1', {packages: ['table']});

function showUser(){
    $.post("getData.php","",function(JSONResponse){
        document.getElementById('theResult').innerHTML = JSON.stringify(JSONResponse) + "<br />";
        var dataTable = new google.visualization.DataTable();
        for(each_name in JSONResponse[0]){
            dataTable.addColumn('string',each_name);
        }
        for(i=0 ; JSONResponse[i]!=null ; i++){
            dataTable.addRow();
            j = 0;
            for(each_name in JSONResponse[i]){
                dataTable.setCell(i,j,String(JSONResponse[i][each_name]));
                j++;
            }
        }
        var table_data = new google.visualization.Table(document.getElementById('theResult'));
        table_data.draw(dataTable, null);
    },'json');
}