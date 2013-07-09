<?php ?>
<div class="preview-story">
    <h3 class="preview-title">Data Preview</h3>

    <div class="storycontent" id="dataPreviewContainer">
        <ul data-bind="visible: tableList().length > 1, foreach: tableList" class="tableList" id="previewTableList">
            <li data-bind="click: $root.chooseTable" class="tableListItem">
                <span class="chosenTableBullet"><i data-bind="visible: isChoosen" class="chosenIcon icon-caret-right"></i></span>
                <span class="tableText" data-bind="text: tableName"></span>
            </li>
        </ul>         
        <div data-bind="visible: isNoData" style="color: grey;">This table has no data</div>
        <div data-bind="with: currentTable">
            <div id="dataPreviewTableWrapper" data-bind="makeHorizontalScrollable: $data, style: { width: $root.tableList().length > 1 ? '82%' : '100%' }">
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
                <div style="display: inline-block;margin-right: 4px;" id="dataPreviewLoadingIcon">
                    <img data-bind="visible: $root.isLoading" src="images/ajax-loader.gif"/>
                </div>
                <i class="icon-arrow-left" id="prevBtn" data-bind="visible: currentPage() > 1, click: $root.goToPreviousPage" title="Previous Page"></i>
                <i class="icon-arrow-right" id="nextBtn" data-bind="visible: currentPage() < totalPage(), click: $root.goToNextPage" title="Next Page"></i>              
            </div>            
        </div>    
    </div>	
</div>
<script type="text/javascript" src="javascripts/jquery.mousewheel.js"></script>
<script>
    function bindHorizontalScrollToPreviewTable(element) {      
        $(element).bind('mousewheel', function(event, delta) {
            val = this.scrollLeft - (delta * 100);
            jQuery(this).stop().animate({scrollLeft: val});
            event.preventDefault();
        });
    }
</script>