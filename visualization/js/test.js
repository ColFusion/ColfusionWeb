function saveTest() {
    var obj = [
        {
            "name" : "changehart1",
            'cid' : 20,
            "type" : "pie",
            "top" : 300,
            "left" : 100,
            "height" : 200,
            "width" : 300,
            "note" : "nothing",
            "datainfo" : "dsafasfdsa",
            "depth" : 3
        },
        {
            "name" : "nothing is good",
            "type" : "pie",
            "top" : 300,
            "left" : 100,
            "height" : 200,
            "width" : 300,
            "note" : "nothing",
            "datainfo" : "dsafasfdsa",
            "depth" : 3
        }
    ]
    $.ajax({
        type: 'post',
        url: 'control.php',
        data:{
            action : "saveCanvas",
            vid : 1,
            name : "newCanvas1",
            note : "haha",
            privilege : 0,
            charts : JSON.stringify(obj)
            },
        success: function(data){
            alert(data);
        }
        })
}
function createNewCanvas(_name) {
    $("#file_manager").hide();
    if (_name==null) {
        _name = $("#createCanvasName").val();
    }
    
    $.ajax({
        type: 'POST',
		//url: "getPie.php",
        url: "control.php",
        data: {
            action: 'createNewCanvas',
            name: _name,
            note: 'dfdf'
        },
        async:false,
        success:function(JSON_Response){
            clearScreen();
            var JSONResponse = jQuery.parseJSON(JSON_Response);
            maxDepth = -1;
            $('#newCanvas').modal('hide');
            $('#vid').val(JSONResponse['vid']);
            $('#canvasName').val(JSONResponse['name']);
            $('#privilege').val(JSONResponse['privilege']);
            $('#authorization').val(JSONResponse['authorization']);
            $('#mdate').val(JSONResponse['mdate']);
            $('#cdate').val(JSONResponse['cdate']);
            $('#note').val(JSONResponse['note']);
            $('#testSave').show();
            $("#viewChartsNote").show();
            $('#file-dropdown').show();
            $('#chart-dropdown').hide();
            $('#view-dropdown').show();
            $('#brand').text(JSONResponse['name']);
            CANVAS = new Canvas(JSONResponse['vid'],JSONResponse['name'],JSONResponse['privilege'],JSONResponse['authorization'],JSONResponse['mdate'],JSONResponse['cdate'],JSONResponse['note']);
        }
        
    })
}
function saveCanvas() {
    var _vid = $('#vid').val();
    var canvasName = $('#canvasName').val();
    var privilege = $('#privilege').val();
    var authorization = $('#authorization').val();
    var charts = new Array();
    $('.gadget').each(function(){ //get informaton about each chart from browser;
        var cid = $(this).find('.chartID').val();
        var datainfo = CHARTS[cid].datainfo;
        var obj = {
            cid :$('.chartID ', this).val(),
            name: $(this).find('.chartName').val(),
            type: $('.type',this).val(),
            left: Math.round($(this).position().left),
            top:  Math.round($(this).position().top),
            height:  Math.round($(this).height()),
            width:  Math.round($(this).width()),
            depth: 0,
            datainfo: datainfo,
            note: $('.chartNote', this).val()
        }
        charts.push(obj);
        });
    $.ajax({
        type:'POST',
        url: 'control.php',
        data: {
            action: 'saveCanvas',
            vid: _vid,
            name: canvasName,
            privilege: privilege,
            authorization: authorization,
            charts: charts
        },
        success:function(JSON_Response){
            var JSONResponse = jQuery.parseJSON(JSON_Response);
            $('.gadget').each(function(){
                var oldId = $('.chartID ', this).val();
                for(var i = 0; i<JSONResponse['newOldChartId'].length;i++) {
                    if (JSONResponse['newOldChartId'][i]['oldId'] == oldId) {
                        $('.chartID ', this).val(JSONResponse['newOldChartId'][i]['newId']);
                        CHARTS[JSONResponse['newOldChartId'][i]['newId']] = CHARTS[oldId];
                        CHARTS[oldId] = null;
                    }
                }
            })
            }
        })
}

function testDelete() {
    $.ajax({
        type: 'POST',
        url: 'control.php',
        data:{
            action:'deleteCanvas',
            vids:[3,4]
        },
        success:function(JSON_Response){
            var JSONResponse = jQuery.parseJSON(JSON_Response);
            if (JSONResponse['status']=='success') {
                openAlert("You successfully delete the canvas.","success");
            }
        }
        
        
        })
}
function testShare() {
    var vid = $('#vid').val(); 
    $.ajax({
        type: 'POST',
        url: 'control.php',
        data:{
            action:'shareCanvas',
            vid: vid,
            authorization: 2,
            shareTo: 21
        },
        success:function(JSON_Response){
            //var JSONResponse = jQuery.parseJSON(JSON_Response);
        }
        
        
        })
}
function openAlert(str,type) {
    if (type=="success") {
        $('#success-alert').show();
        $("#success-alert").html(str);
    }
    if (type=="error") {
        $('#error-alert').show();
        $("#error-alert").html(str);
    }
}
function closeCanvas(){
    clearScreen();
    CHARTS = new Array();
    $('#chart-dropdown').hide();
    $('#view-dropdown').hide();
    $('#testSave').hide();
    $('#viewChartsNote').hide();
    $('#vid').val('');
    $('#canvasName').val('');
    $('#privilege').val('');
    $('#authorization').val('');
    $('#mdate').val('');
    $('#cdate').val('');
    $('#note').val('');
}
function openCanvasManager() {
	var s = confirm("Save The Current Canvas????");
	if (s)saveCanvas();
	
    $('#file-dropdown').hide();
    $('#viewChartsNote').hide();
    $("#note_section").css({
		marginLeft:"-100%"
	});
    showHint("");
    $('#brand').text('Col*Fusion Canvas Manager');
    closeCanvas();
    $('#file_manager').show();
}