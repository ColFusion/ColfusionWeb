<script type="text/javascript">



</script>
<script>
    $(document).ready(function(){
       // $("#tfhover").find("tbody").eq(1).find("tr").each(function(index){$(this).find("td").each(function(index2){$(this).attr("id","row"+index+"-col"+index2);});});
      // $(".preview-title").click(function(){
           var $targetTable = $("#tfhover").find("tbody").eq(1).find("tr");
           for (var i=0;i<$targetTable.length;i++) {
                $targetRow = $targetTable.eq(i).find("td");
                for (var j=0;j<$targetRow.length;j++) {


                    $targetRow.eq(j).attr({
                        "id":"row"+i+"-col"+j,    //cell id
                        "name":"row"+i+"col"+j,    //navi id
                        "ondblclick":"showSubNav(this.name)",
                        "onclick":"hideSubNav(this.name)"
                    });

                    var cid = $targetRow.eq(j).attr("id");
                    $targetRow.eq(j).css("position","relative");
                    var cell = $targetRow.eq(j).html();
                    var navTable = '<div name=?? class="sub_nav" style="height:100%; width:100%; position: relative; z-index:1000;display:block;" onclick="try{window.event.cancelBubble = true;}catch(e){event.stopPropagation();}">';
                    navTable += '<table boarder="1" width="3"><td>';
                    navTable += '<tr><img src="edit_pencil.jpg" height="30" width="30" id="image1" onclick="Modify(\''+cid+'\');Mark(\''+cid+'\');"/></tr>';
                    navTable += '<tr><img src="delete_trashcan.jpg" height="30" width="30" id="image2" onclick="Delete(\''+cid+'\');Mark(\''+cid+'\');"/></tr>';
                    navTable += '</td></table></div>';
                    $targetRow.eq(j).html(cell+navTable);


                }
           }
       });
    //});
</script>
<div class="dataPreviewTableWrapper">
    <div class="preview-story">
        <button onclick="location.href='http://localhost/Colfusion/JisenCai_reading_list.php'" style="margin-right: 50px;">Switch to reading mode</button>  
        <button data-bind="visible: currentTable" id="visualizeBtn" class="btn visualizeBtn" onclick="openVisualizationPage()">
            <i class="icon-bar-chart" style="margin-right: 5px;"></i>
            Visualize
        </button>
        <h3 class="preview-title">Data Preview</h3>
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
