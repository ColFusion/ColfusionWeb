<script type="text/javascript">



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
                    navTable += '<i class="icon-pencil" id="'+cid+'" style="margin-left: 45px; margin-right: 5px;" onclick="Modify(\''+cid+'\');Mark(\''+cid+'\');"></i></tr>';
                    navTable += '<i class="icon-trash" onclick="Delete(\''+cid+'\');Mark(\''+cid+'\');"></i></tr>';
                    navTable += '<i class="icon-comment" style="margin-left:5px;" onclick="Comment(\''+cid+'\');"></i></tr>';
                    navTable += '</div>';
                    $targetRow.eq(j).html(cell+navTable);
                    }
           }

    }
            
       });
//reading mode function here
var indexControl2 = 0;
$("#switch_new").click(function()
{
    //to generate a new table with highlight cell and popout comment
    //window.location.reload();
if(indexControl2 == 0)
    {
        indexControl2++;
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

                    var cid = $targetRow.eq(j).attr("id");
                    $targetRow.eq(j).css("position","relative");

                }
           }
        
    }
    $(".sub_nav").hide();
    updateData();
    highlightComment();
    indexControl = 0;
});
//reading mode function ends


</script>

<!-- Button to trigger modal -->
<!--<a href="#myModal" role="button" class="btn" data-toggle="modal">Launch demo modal</a>-->
<!-- Modal -->
<div id="myModa" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
    <h3 id="myModalLabel">Modify History</h3></div>

    <?php
            echo '<div style="width:100%;height:360px;overflow:scroll;"><table style="width:100%;">';
                    $sql_select = "SELECT u.user_login, w.timestamp, w.value, w.notification, w.checked  
                               FROM record_history_92 AS w, colfusion_users AS u 
                               WHERE w.user_id=u.user_id AND field='tags' ORDER BY timestamp";
                    
                    //$sql = "SELECT value FROM record_history_92";

                    //$result = mysql_query($sql);
                    
                    while($row = mysql_fetch_array($result)) 
                    {
                        echo '<tr style="background-color:#fdfdee;">';
                        echo '<td style="padding: 0px;border:1px solid #999;width:10%;text-align:center;"><input type="radio" ';?>
                            <?php if($row['checked']) echo "checked ";?>
                            <?php echo 'name="tags_popup" value="tagsrollback-'.$tags_index.'"/></td>';
                            echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['timestamp'] . "</td>";
                            echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['value'] . "</td>";
                            echo '<td style="padding: 10px;border:1px solid #999;width:15%;">' . $row['user_login'] . "</td>";
                            echo '<td style="padding: 10px;border:1px solid #999;width:25%;">' . $row['notification'] . "</td>";
                            echo "</tr>";
                            $tags_index ++;
                    }
                        echo '</table></div></div>';
                        ?>
  <div class="modal-body">
    <div id="report">

    </div>
  </div>
</div>

<div class="dataPreviewTableWrapper">
    <div class="preview-story">
        <button data-bind="visible: currentTable" id="visualizeBtn" class="btn visualizeBtn" onclick="openVisualizationPage()">
            <i class="icon-bar-chart" style="margin-right: 5px;"></i>
            Visualize
        </button>
        <h3 class="preview-title">Origin data preview</h3>
        <button class="btn btn-primary" type="button"><i class="icon-edit"></i>Edit Mode</button> 
        <button class="btn btn-info" type="button" id="switch_new"><i class="icon-book"></i>Switch to new data</button> 
        <a href="#myModal" role="button" class="btn" data-toggle="modal">History</a>
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
                                <td data-bind="text: $data" onclick="comment_popup(this.id);"></td>                            </tr>
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
