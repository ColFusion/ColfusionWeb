<script type="text/javascript">

/*function showSubNav(title){
 $("td[title='"+title+"']").show();
 
}
 function hideSubNav(title){
 $("td[title='"+title+"']").hide;
}
*/
 function Modify(id) {  
  var str=window.open(www.baidu.com,name,"enter new value:");
  if(str!=="")
    {
       // $(".alert").alert("new value is: "+ str)
        //save it to database
        // need to modeify
        var p=document.getElementById(id);
        p.innerHTML=str; 
        Mark(id);
        Comment(id); 
    }
    else if(str==""){
      Delete(id);
    }
  
}

 function Delete(id) {
  alert("it is deleted!");
  document.getElementById(id).innerHTML="null";//need to be null instead of a String
  Mark(id);
  Comment(id);
}

function Mark(id){
  document.getElementById(id).style.background="#FFD700";

}

function Comment(id){
var p=prompt("please write a comment here: ");
var counter=0;
// record the comment by id and insert it into db
}

//表单栏目右侧弹出评论popout；点击对话框可以直接添加自己的评论；
//function commentpopout(id){
//    if(document.getElementById(id).style.background=="#FFD700")
//    {
//        onclick="$('#td'+id).popover('show');"
//        onclick="$('#td'+id).popover('hide');" 
//    }
       
//}

</script>
<!--ajax edit function begins(not implemented yet)>
<script>
$.ajax({
        url: 'localhost/Colfusion/story.php?title=73', 
        type: 'post',
        dataType: 'json',
        success: function (data) {
            if (data.notifications!=null){
                for (var i = data.notifications.length-1; i>=0; i--) {
                    var tmpntf = new newNotification(
                        data.notifications[i].ntf_id,
                        data.notifications[i].sender,
                        data.notifications[i].action,
                        data.notifications[i].receiver_id,
                        data.notifications[i].target,
                        data.notifications[i].target_id, 
                        " ", " ");
                    self.ntfs.push(tmpntf);
                }
            }//end if
            self.ntfs.push(new newNotification("all ntf","******","See All","all receiver","******", "all", data.receiver, " "));
        }
    });
<! ajax edit function ends(not implemented yet) -->

</script>
<script>
//add editing function here
    var indexControl = 0;
        $(".btn-primary").click(function()
    {   if(indexControl == 0){
        indexControl++;
           var $targetTable = $("#tfhover").find("tbody").eq(1).find("tr");
           for (var i=0;i<$targetTable.length;i++) 
           {
                $targetRow = $targetTable.eq(i).find("td");
                for (var j=0;j<$targetRow.length;j++) 
                {


                    $targetRow.eq(j).attr({
                        "id":"row"+i+"-col"+j,    //cell id
                        "title":"row"+i+"col"+j   //navi id
                    });

                    //allocate editng icons to each cell
                    var cid = $targetRow.eq(j).attr("id");
                    $targetRow.eq(j).css("position","relative");
                    var cell = $targetRow.eq(j).html();
                    var navTable = '<div name=table class="sub_nav" style="top:0px; height:100%; width:100%; position: absolute; z-index:1000;display:block;" onclick="try{window.event.cancelBubble = true;}catch(e){event.stopPropagation();}">';
                    navTable += '<i class="icon-pencil" style="margin-left: 45px; margin-right: 5px;" onclick="Modify(\''+cid+'\');Mark(\''+cid+'\');"></i></tr>';
                    navTable += '<i class="icon-trash" onclick="Delete(\''+cid+'\');Mark(\''+cid+'\');"></i></tr>';
                    navTable += '</div>';
                    $targetRow.eq(j).html(cell+navTable);
                    //添加comment栏
                    if(j == $targetRow.length-1)
                      //$('#element').popover('show')
                    var comment = '<div><i class="icon-comment" style="margin-left: 250px" onlick="Comment()"></i></div>';
                     //$targetRow.eq(j).html(cell+navTable);

                }
           }

    }
            
       });
$(".btn-info").click(function()
{
    //to generate a new table with highlight cell and popout comment
    window.location.reload();
}
);
</script>
<div class="dataPreviewTableWrapper">
    <div class="preview-story">
        <button data-bind="visible: currentTable" id="visualizeBtn" class="btn visualizeBtn" onclick="openVisualizationPage()">
            <i class="icon-bar-chart" style="margin-right: 5px;"></i>
            Visualize
        </button>
        <h3 class="preview-title">Data Preview</h3>
        <button class="btn btn-primary" type="button"><i class="icon-edit"></i>Edit Mode</button> <!--需要将响应事件转移到该按钮 -->
        <button class="btn btn-info" type="button"><i class="icon-book"></i>Read Mode</button> <!--需要添加响应事件 -->
        <div class="storycontent" id="dataPreviewContainer">
            <ul data-bind="visible: tableList().length > 1, foreach: tableList" class="tableList" id="previewTableList">
                <li data-bind="click: $root.chooseTable" class="tableListItem">
                    <span class="chosenTableBullet">
                        <i data-bind="visible: isChoosen" class="chosenIcon icon-caret-right"></i>
                    </span>
                    <span class="tableText" data-bind="text: tableName"></span>
                </li>
            </ul>
            <!-- ko if: $data.hasOwnProperty("isRefreshingUpdateStatus") -->
            <div data-bind="visible: isRefreshingUpdateStatus() && !isNoData() && !currentTable()" style="color: grey;">
                Processing Data...
            </div>
            <!-- /ko -->
            <div data-bind="visible: isNoData" style="color: grey;">This table has no data</div>
            <div data-bind="visible: isError" style="color: red;">Some errors occur when trying to retrieve data. Please try again.</div>
            <div data-bind="with: currentTable">
                <div id="dataPreviewTableWrapper" data-bind="horizontalScrollable: $data, style: { width: $root.tableList().length > 1 ? '82%' : '100%' }">
                    <table id="tfhover" class="tftable" border="1" style="white-space: nowrap;">
                        <tr data-bind="foreach: headers">
                            <th data-bind="text: name"></th>
                        </tr>
                        <tbody class="dataPreviewTBody" data-bind="foreach: rows">
                            <tr class="datatr" onmouseover="commentpopout();" data-bind="foreach: cells">
                                <td onclick="alert('Need to change the bgcolor for the modified data here')" data-bind="text: $data"></td>
                            
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div id="previewTableNavigations">
                    <div style="display: inline-block;margin-right: 4px;" id="dataPreviewLoadingIcon" class="dataPreviewLoadingIcon">
                        <img data-bind="visible: $parent.isLoading" src="images/ajax-loader.gif" />
                    </div>
                    <i class="icon-arrow-left" id="prevBtn" data-bind="visible: currentPage() > 1, click: $parent.goToPreviousPage" title="Previous Page"></i>
                    <i class="icon-arrow-right" id="nextBtn" data-bind="visible: currentPage() < totalPage(), click: $parent.goToNextPage" title="Next Page"></i>
                </div>
            </div>
        </div>
    </div>
    <script class="includeMouseWheelScript" type="text/javascript" src="javascripts/jquery.mousewheel.js"></script>    
</div>
