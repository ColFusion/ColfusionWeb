<script>
    $(document).ready(function(){
       // $("#tfhover").find("tbody").eq(1).find("tr").each(function(index){$(this).find("td").each(function(index2){$(this).attr("id","row"+index+"-col"+index2);});});
       $(".preview-title").click(function(){
           var $targetTable = $("#tfhover").find("tbody").eq(1).find("tr");
           for (var i=0;i<$targetTable.length;i++) {
                $targetRow = $targetTable.eq(i).find("td");
                for (var j=0;j<$targetRow.length;j++) {
                    $targetRow.eq(j).attr("id","row"+i+"-col"+j);
                }
           }
       });
    });

</script>

<link href="Colfusion/css/style.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="/Colfusion/js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/Colfusion/js/popup_layer.js"></script>
<script type="text/javascript" src="/Colfusion/javascripts/editdata.js"></script>



<button onclick="location.href='http://localhost/Colfusion/DataImportWizard/dataPreviewMarkup.php'">Switch to reading mode</button>  
    <br>
    <br>

<div id="emample9" class="example" style="left:901px;position:absolute;">
        <div id="ele9" class="tigger" style="float:right">History</div>
        <div class="clr"></div>
        
        <div id="blk9" class="blk" style="display:none;">
            <div class="head"><div class="head-right"></div></div>
            <div class="main">
                <h2>User Editing History</h2>
                <a href="javascript:void(0)" id="close9" class="closeBtn">close</a>
                <ul>
                    <li><a href="#">item1</a></li>
                    <li><a href="#">item2</a></li>
                    <li><a href="#">item3</a></li>
                    <li><a href="#">item4</a></li>
                    <li><a href="#">item5</a></li>
                    <li><a href="#">item6</a></li>
                    <li><a href="#">item7</a></li>
                    <li><a href="#">item8</a></li>
                    <li><a href="#">item9</a></li>
                    <li><a href="#">item10</a></li>
                    <li><a href="#">item11</a></li>
                    <li><a href="#">item12</a></li>
                </ul>
            </div>
        </div>
    </div>    
    
<div class="dataPreviewTableWrapper">
    <div class="preview-story">
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
            <div data-bind="visible: isNoData" style="color: grey;">This table has no data or the data are being processed.</div>
            <div data-bind="visible: isError" style="color: red;">Some errors occur when trying to retrieve data. Please try again.</div>
            <div data-bind="with: currentTable">
                <div id="dataPreviewTableWrapper" data-bind="horizontalScrollable: $data, style: { width: $root.tableList().length > 1 ? '82%' : '100%' }">
                    <table id="tfhover" class="tftable" border="1" style="white-space: nowrap;">
                        <tr data-bind="foreach: headers">
                            <th data-bind="text: name"></th>
                        </tr>
                        <tbody class="dataPreviewTBody" data-bind="foreach: rows">
                            <tr class="datatr" data-bind="foreach: cells">
                                <td data-bind="text: $data" ></td>
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
    <script type="text/javascript" src="javascripts/editdata.js"></script>    
</div>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.0/jquery.min.js"></script>

