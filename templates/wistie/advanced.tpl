{literal}
<div id="advanced" class="advanced">
    <form id="advancedsearch" style="border: none; margin: 20px; padding: 0px;">
        <h2>Advanced Search</h2>
        <br />
        <table style="width: 100%">
            <tr style="width: 100%">
                <td style="width: 80px !important;">Search for: </td>
                <td>
                    <input data-bind="value: searchTerm, event: {keyup: function(model, e){if(e.keyCode == 13)model.search();}}"
                        data-required="true" type="text" id="search" style="width: 100%" />
                </td>
            </tr>
        </table>
        <table data-bind="foreach: whereConditions" id="conditionTable" style="width: 100%; display: none;">
            <tr style="width: 100%">
                <td data-bind="text: $index() == 0? 'Where' : 'And'" style="width: 80px !important;">Where</td>
                <td>
                    <input data-bind="value: variable" type="text" name="variable[]" style="width: 100%" />
                </td>
                <td width="50">
                    <select data-bind="value: condition"
                        name="select[]">
                        <option>---- condition ----</option>
                        <option value="like">contains</option>
                        <option value="=">equal</option>
                        <option value="&lt;&gt;">not equal</option>
                        <option value="&lt;">less than</option>
                        <option value="&gt;">greater than</option>
                        <option value="&lt;=">less or equal</option>
                        <option value="&gt;=">greater or equal</option>
                    </select>
                </td>
                <td>
                    <input data-bind="value: value" type="text" name="condition[]" style="width: 100%" />
                </td>
                <td style="text-align: right;">
                    <!-- ko if: $index() == 0 -->
                    <i data-bind="click: $parent.addWhereCondition" class="icon-plus addFilterBtn"></i>
                    <!-- /ko -->
                    <!-- ko ifnot: $index() == 0 -->
                    <i data-bind="click: $parent.removeWhereCondition" class="icon-remove-sign removeFilterBtn"></i>
                    <!-- /ko -->
                </td>
            </tr>
        </table>

        <table style="width: 100%;">
            <tr style="width: 100%; display: none;">
                <td style="width: 80px !important;">Category: </td>
                <td>
                    <input data-bind="value: category" type="text" style="width: 100%" />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input data-bind="click: search" type="button" value="Search" />
                    <img data-bind="visible: isSearching" style="margin-left: 5px;" src="{/literal}{$my_pligg_base}{literal}/images/ajax-loader.gif" />                   
                </td>
            </tr>
        </table>
    </form>

    <form id="joinRequestToNewPage" method="post" action="../visualization/dashboard.php" targe="visualizationWindow">
        <input type="hidden" name="joinQuery" />
        <input type="hidden" name="sidsWithColumns" />
    </form>

    <div data-bind="visible:isNoResultTextShown() && searchResults().length == 0" style="display: none; margin: -5px 0 0 20px;">
        No Results Found.
    </div>
    <div data-bind="visible:isSearchError()" style="display: none; margin: -5px 0 0 20px; color: red">
        Some errors occur when searching dataset.
    </div>

    <!-- advanced search result -->
    <div data-bind="foreach: searchResults" id="resultDiv" style="border: none; margin: 0px; padding: 0px;">

        <!-- ko if: resultObj.oneSid -->
        <div class="stories datasetResult">

            <div data-bind="with: resultObj" class="searchResultFooter">
                <p data-bind="foreach: foundSearchKeys">
                    <!-- ko if: $index() == 0 -->
                    <span class="searchKeyText">
                        <i class="icon-key" title="Matched Keywords" style="margin-right: 5px;"></i>
                    </span>
                    <!-- /ko -->
                    <span data-bind="template: { name: 'columnTooltip-template', data: $data}" class="searchKeyText"></span>
                    <!-- ko if: $index() < $parent.foundSearchKeys.length - 1 -->
                    ,
                    <!-- /ko -->
                </p>
            </div>

            <div class="buttonPanel" style="float: right;">
                <button data-bind="click: openVisualizationPage" class="btn" title="Visualization">
                    <i class="icon-bar-chart"></i>
                </button>
                <button data-bind="click: togglePreviewTable" class="btn" title="Preview Data" data-toggle="button">
                    <i class="icon-table"></i>
                </button>
            </div>

            <div data-bind="with: resultObj" class="searchResultBody" style="overflow: auto;">
                <div class="searchResultProfile" style="float: left;">
                    <div style="font-weight: bold; color: black;">
                        Dataset: <a data-bind="attr: {'id': 'title' + sid, 'href': '../story.php?title=' + sid}, text: title" class="title">undefined</a>
                    </div>
                    <div class="tableName" style="font-size: 12px;">
                        <sapn>Table Name: </sapn>
                        <span data-bind="text: tableName" class="tableNameText"></span>
                    </div>
                    <div data-bind="foreach: allColumns" class="columns" style="font-size: 12px;">
                        <!-- ko if: $index() == 0 -->
                        <span>Columns:
                        </span>
                        <!-- /ko -->
                        <span data-bind="template: { name: 'columnTooltip-template', data: $data}" class="columnText"></span>
                        <!-- ko if: $index() < $parent.allColumns.length - 1 -->
                        ,
                        <!-- /ko -->
                    </div>
                </div>
            </div>

            <div data-bind="visible: isDataPreviewTableShown" class="dataPreviewContainer">               
                <div data-bind="visible: !dataPreviewViewModel() || dataPreviewViewModel().isLoading()" style="padding-top: 10px; padding-left: 30px;">Loading...</div>
                <!-- ko if: dataPreviewViewModel() -->
                <div data-bind="template: { name: 'dataPreviewViewModel-template', data: dataPreviewViewModel}">
                </div>
                <!-- /ko -->
            </div>

        </div>
        <!-- /ko -->

        <!-- ko ifnot: resultObj.oneSid -->
        <div class="stories pathResult">
            <div class="searchResultBody" style="overflow: auto;">
                <div class="searchResultProfile">
                    
                    <div class="sliderFilterContainer">
                        <div class="sliderFilterLabelContainer">                          
                            <table id="sliderFilterLabelTable">
                                <tr>
                                    <td class="labelTitle">Avg Confidence</td>
                                    <td class="gtMark">&gt;=</td>
                                    <td data-bind="text: confidenceFilter()"></td>
                                </tr>
                                <tr>
                                    <td class="labelTitle">Path Length</td>
                                    <td class="gtMark" style="color: red">&lt;=</td>
                                    <td data-bind="text: pathFilter()"></td>
                                </tr>
                                <tr>
                                    <td class="labelTitle">Data Matching</td>
                                    <td class="gtMark">&gt;=</td>
                                    <td data-bind="text: dataMatchFilter() + '%'"></td>
                                </tr>
                            </table>
                        </div>
                        <div class="sliderFilterSliderContainer">
                            <div data-bind="slider: confidenceFilter, sliderOptions: {min: 0, max: 1, step: 0.1}" id="confidenceSliderFilter" class="sliderFilter"></div>
                            <div data-bind="slider: pathFilter, sliderOptions: {value: 10, min: 0, max: 10, step: 1}" id="pathSliderFilter" class="sliderFilter"></div>
                            <div data-bind="slider: dataMatchFilter, sliderOptions: {min: 0, max: 100, step: 10}" id="dataMatchSliderFilter" class="sliderFilter"></div>
                        </div>
                        <button data-bind="click: filterSearchResults" style="margin-top: 5px;">Refresh</button>
                    </div>

                    <div data-bind="foreach: paths" class="paths">
                        <div data-bind="visible: isFilterSatisfied" class="path">
                            <div data-bind="with: pathObj" class="pathBody">

                                <div class="buttonPanel" style="float: right;">
                                    <button data-bind="click: $parent.openVisualizationPage" class="btn" title="Visualization">
                                        <i class="icon-bar-chart"></i>
                                    </button>
                                    <button data-bind="click: $parent.togglePreview" class="btn" data-toggle="button">
                                        <i class="icon-table"></i>
                                    </button>
                                    <button data-bind="click: function() { $parent.isMoreShown(!$parent.isMoreShown()); }" class="btn" data-toggle="button">
                                        <i data-bind="visible: !$parent.isMoreShown()" class="icon-plus"></i>
                                        <i data-bind="visible: $parent.isMoreShown()" class="icon-minus"></i>
                                    </button>
                                </div>

                                <div style="float: left;">

                                    <div class="searchResultFooter">
                                        <p data-bind="foreach: foundSearchKeys">
                                            <!-- ko if: $index() == 0 -->
                                            <span class="searchKeyText">
                                                <i class="icon-key" title="Matched Keywords" style="margin-right: 5px;"></i>
                                            </span>
                                            <!-- /ko -->
                                            <span data-bind="template: { name: 'columnTooltip-template', data: $data}" class="searchKeyText">
                                                <span data-bind="text: $data.dname_chosen" class="searchKeyText"></span>
                                                <!-- ko if: $index() < $parent.foundSearchKeys.length - 1 -->
                                                ,
                                                <!-- /ko -->
                                            </span>
                                        </p>
                                    </div>

                                    <div class="pathTitle">
                                        <span style="color: black; font-weight: bold;">Path: </span>
                                        <span data-bind="text: title" class="pathTitleText"></span>
                                    </div>
                                    <div data-bind="foreach: sidTitles" class="sources">
                                        <span data-bind="if: $index() == 0" class="sourcesTitle" style="color: black;">Datasets: </span>
                                        <a data-bind="text: $data, attr: {href: '../story.php?title=' + $parent.sids[$index()]}" class="sourceText"></a>
                                    </div>
                                    <div>
                                        <span style="color: black;">Average Confidence: </span>
                                        <span data-bind="text: Number($parent.avgConfidence()).toFixed(2)" class="pathTitleText"></span>
                                    </div>
                                    <div>
                                        <span style="color: black;">Average Data overlap: </span>
                                        <span data-bind="text: Number($parent.avgDataMatchingRatio()).toFixed(2)" class="pathTitleText"></span>
                                    </div>                                    
                                </div>
                            </div>

                            <div data-bind="visible: isPreviewShown()" class="pathDataPreview dataPreviewContainer">
                                <div data-bind="visible: dataPreviewViewModel() && !dataPreviewViewModel().isLoading()" style="margin-top: 5px;">
                                    <button data-bind="click: refreshPreview" class="btn" title="Refresh Preview Data">
                                        <i class="icon-refresh"></i>
                                    </button>                                 
                                </div>
                                <div data-bind="visible: !dataPreviewViewModel() || dataPreviewViewModel().isLoading()" style="padding-top: 10px; padding-left: 30px;">Loading...</div>
                                <!-- ko if: dataPreviewViewModel() -->
                                <div data-bind="template: { name: 'dataPreviewViewModel-template', data: dataPreviewViewModel}">
                                </div>
                                <!-- /ko -->
                            </div>

                            <div data-bind="visible: isMoreShown()" class="pathDetail" style="margin-top: 10px; width: 99%;">
                                <div style="color: black;">Relationships: </div>
                                <table class="pathRelTable tftable">
                                    <tr>
                                        <th>From</th>
                                        <th>To</th>
                                        <th>Confidence</th>
                                    </tr>
                                    <tbody data-bind="foreach: pathObj.relationships">
                                        <tr>
                                            <td data-bind="template: { name: 'relInfo-template', data: sidFrom }"></td>
                                            <td data-bind="template: { name: 'relInfo-template', data: sidTo }"></td>
                                            <td data-bind="text: confidence, attr: { id:  'relConfidence_' + relId, 'class': 'relConfidence_' + relId }"></td>
                                            <td>
                                                <span data-bind="click: $parent.showMoreClicked.bind($data, relId), attr: { id:  'mineRelRecSpan_' + relId, 'class': 'mineRelRecSpan_' + relId }" style="cursor: pointer;">More...</span>
                                            </td>
                                        </tr>
                                        <tr data-bind="attr: { id:  'mineRelRec_' + relId }" style="display: none;">
                                            <td class="relationshipInfo" colspan="5">
                                                <div data-bind="attr: { id: 'relInfoLoadingIcon_' + relId }, visible: !$parent.isError[relId]()" class="relInfoLoadingIcon" style="text-align: center;">
                                                    <img src="{/literal}{$my_pligg_base}{literal}/images/ajax-loader.gif" />
                                                </div>
                                                <div data-bind="attr: { id: 'relInfoErrorMessage_' + relId }, visible: $parent.isError[relId]()" style="text-align: center;">
                                                    <span style="color: red;">Failed to load relationship information.</span>
                                                </div>
                                                <div data-bind="if: $parent.isRelationshipInfoLoaded[relId]() && !$parent.isError[relId]()">
                                                    <div data-bind="with: $parent.relationshipInfos[relId]">{/literal}{include file='relationshipInfo.html'}{literal}</div>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>

                        </div>
                    </div>
                </div>

                <div class="graphTitle">Relationship Graph:</div>
                <div data-bind="relationshipGraph: paths"></div>
            </div>
        </div>
        <!-- /ko -->

    </div>
</div>

<form id="visualizationDatasetSerializeForm" style="display: none;" target="_blank" method="post" action="../visualization/dashboard.php">
    <input type="hidden" name="dataset" id="visualizationDatasetSerializeInput"></input>
</form>

<script type="text/html" id="columnTooltip-template">
    <span data-bind="bootstrapTooltip: $data.dname_chosen, 
    tooltipOptions: {placement: 'bottom'}, 
    tooltipDynamicValues: {
        dname_orginal_name: $data.dname_orginal_name, 
        dname_value_description: $data.dname_value_description, 
        dname_value_type: $data.dname_value_type, 
        dname_value_unit: $data.dname_value_unit
    }">
        <table class="tooltipContent">
            <tr>
                <td class="tooltipColTitle" style="color: white !important">Original Name: </td>
                <td data-bind="text: $data.dname_orginal_name" id="dname_orginal_name" style="color: white !important"></td>
            </tr>
            <tr>
                <td class="tooltipColTitle" style="color: white !important">Description: </td>
                <td data-bind="text: $data.dname_value_description" id="dname_value_description" style="color: white !important"></td>
            </tr>
            <tr>
                <td class="tooltipColTitle" style="color: white !important">Data Type: </td>
                <td data-bind="text: $data.dname_value_type" id="dname_value_type" style="color: white !important"></td>
            </tr>
            <tr>
                <td class="tooltipColTitle" style="color: white !important">Unit: </td>
                <td data-bind="text: $data.dname_value_unit" id="dname_value_unit" style="color: white !important"></td>
            </tr>
        </table>
    </span>
</script>

<script type="text/html" id="dataPreviewViewModel-template">
    <div class="storycontent" id="dataPreviewContainer">
        <div data-bind="visible: isNoData" style="color: grey;">This table has no data</div>
        <div data-bind="visible: isError" style="color: red;">Some errors occur when trying to retrieve data. Please try again.</div>
        <div data-bind="with: currentTable">
            <div id="dataPreviewTableWrapper" data-bind="horizontalScrollable: $data">
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
            <div id="previewTableNavigations" style="margin-top: -15px;">
                <div style="display: inline-block; margin-right: 4px;" id="dataPreviewLoadingIcon" class="dataPreviewLoadingIcon">
                    <img data-bind="visible: $parent.isLoading" src="../images/ajax-loader.gif" />
                </div>
                <i class="icon-arrow-left" id="prevBtn" data-bind="visible: currentPage() > 1, click: $parent.goToPreviousPage" title="Previous Page"></i>
                <i class="icon-arrow-right" id="nextBtn" data-bind="visible: currentPage() &lt; totalPage(), click: $parent.goToNextPage" title="Next Page"></i>
            </div>
        </div>
    </div>
</script>

<script type="text/html" id="relInfo-template">
    <a data-bind="text: $data.sidTitle, attr: {href: '../story.php?title=' + $data.sid}"></a>
    .<span data-bind="text:  $data.tableName"></span>
</script>

<form id="dataMatchCheckingForm" target="_blank" method="post" action="{/literal}{$my_pligg_base}{literal}/dataMatchChecker/dataMatchChecker.php" style="display: none;">
    <input type="hidden" name="fromSid" value="2122">
    <input type="hidden" name="toSid" value="2121">
    <input type="hidden" name="fromTable" value="s6.xlsx">
    <input type="hidden" name="toTable" value="s5.xlsx">
    <input typle="hidden" name="relSerializedString">
</form>

{/literal}