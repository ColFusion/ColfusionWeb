<script type="text/javascript">

/*function showSubNav(title){
 $("td[title='"+title+"']").show();
 
}
 function hideSubNav(title){
 $("td[title='"+title+"']").hide;
}
*/
 function Modify(id) {  
  var str=prompt("enter new value:");
  if(str)
    {
        alert("new value is: "+ str)
    }
  var p=document.getElementById(id);
  p.innerHTML=str;  
  Mark(id);
  Comment(id);
}

 function Delete(id) {
  alert("it is deleted");
  document.getElementById(id).innerHTML="null";
  Mark(id);
  Comment(id);
}

function Mark(id){
  document.getElementById(id).style.background="#FFD700";

}

function Comment(id){
var p=prompt("please write a comment here: ");
// record the comment by id
}

</script>
<script>
    $(".preview-title").click(function(){
       // $("#tfhover").find("tbody").eq(1).find("tr").each(function(index){$(this).find("td").each(function(index2){$(this).attr("id","row"+index+"-col"+index2);});});
      // $(".preview-title").click(function(){
           var $targetTable = $("#tfhover").find("tbody").eq(1).find("tr");
           for (var i=0;i<$targetTable.length;i++) {
                $targetRow = $targetTable.eq(i).find("td");
                for (var j=0;j<$targetRow.length;j++) {


                    $targetRow.eq(j).attr({
                        "id":"row"+i+"-col"+j,    //cell id
                        "title":"row"+i+"col"+j,    //navi id
                        "ondblclick":"showSubNav(title)",
                        "onclick":"hideSubNav(title)"
                    });

                    var cid = $targetRow.eq(j).attr("id");
                    $targetRow.eq(j).css("position","relative");
                    var cell = $targetRow.eq(j).html();
                    var navTable = '<div name=table class="sub_nav" style="top:0px; height:100%; width:100%; position: absolute; z-index:1000;display:block;" onclick="try{window.event.cancelBubble = true;}catch(e){event.stopPropagation();}">';
                    navTable += '<img src="edit_pencil.jpg" style="margin-left: 20px; " height="15" width="15" id="image1" onclick="Modify(\''+cid+'\');Mark(\''+cid+'\');"/></tr>';
                    navTable += '<img src="delete_trashcan.jpg" height="15" width="15" id="image2" onclick="Delete(\''+cid+'\');Mark(\''+cid+'\');"/></tr>';
                    navTable += '</div>';
                    $targetRow.eq(j).html(cell+navTable);


                }
           }
       });
    //});
</script>
<div class="dataPreviewTableWrapper">
    <div class="preview-story">
        <button data-bind="visible: currentTable" id="visualizeBtn" class="btn visualizeBtn" onclick="openVisualizationPage()">
            <i class="icon-bar-chart" style="margin-right: 5px;"></i>
            Visualize
        </button>
        <h3 class="preview-title">Switch to edit mode</h3>
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
                            <tr class="datatr" data-bind="foreach: cells">
                                <td data-bind="text: $data"></td>
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
