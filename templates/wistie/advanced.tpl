{literal}
<div id="advanced" class="advanced">
  <form id="advancedsearch" style="border: none; margin: 20px; padding: 0px;">
    <h2>Advanced Search</h2>
    <br />
    <table style="width: 100%">
      <tr style="width: 100%">
        <td style="width: 80px !important;">Search for: </td>
        <td >
          <input data-bind="value: searchTerm" data-required="true" type="text" id="search" style="width:100%" />
        </td>
      </tr>
    </table>
    <table data-bind="foreach: filters" id="conditionTable" style="width: 100%">
      <tr style="width: 100%">
        <td data-bind="text: $index() == 0? 'Where' : 'And'" style="width: 80px !important;">Where</td>
        <td>
          <input data-bind="value: variable" type ="text" name="variable[]" style="width: 100%" />
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
          <i data-bind="click: $parent.addFilter" class="icon-plus addFilterBtn"></i>
          <!-- /ko -->
          <!-- ko ifnot: $index() == 0 -->
          <i data-bind="click: $parent.removeFilter" class="icon-remove-sign removeFilterBtn"></i>
          <!-- /ko -->
        </td>
      </tr>
    </table>

    <table style="width: 100%">
      <tr style="width: 100%">
        <td style="width: 80px !important;">Category: </td>
        <td>
          <input data-bind="value: category" type="text" style="width:100%" />
        </td>
      </tr>
      <tr>
        <td colspan="2">
          <input data-bind="click: search" type="button" value="Search"/>
        </td>
      </tr>
    </table>
  </form>

  <form id="joinRequestToNewPage" method="post" action="../visualization/dashboard.php" targe="visualizationWindow">
    <input type="hidden" name="joinQuery" />
    <input type="hidden" name="sidsWithColumns" />
  </form>

  <!-- advanced search result -->
  <div data-bind="foreach: searchResults" id="resultDiv" style="border: none; margin: 0px; padding: 0px;">

    <!-- ko if: resultObj.oneSid -->
    <div class="stories datasetResult">

      <div data-bind="with: resultObj" class="searchResultBody" style="overflow: auto;">
        <div class="searchResultProfile" style="float: left;">
          <h2>
            Dataset: <a data-bind="attr: {'id': 'title' + sid, 'href': '../story.php?title=' + sid}, text: title" class="title">undefined</a>
          </h2>
          <div class="tableName" style="font-size: 12px;">
            <sapn>Table Name: </sapn>
            <span data-bind="text: tableName" class="tableNameText"></span>
          </div>
          <div data-bind="foreach: allColumns" class="columns" style="font-size: 12px;">
            <!-- ko if: $index() == 0 -->
            <span>
              Columns:
            </span>
            <!-- /ko -->
            <span data-bind="template: { name: 'columnTooltip-template', data: $data}" class="columnText"></span>
            <!-- ko if: $index() < $parent.allColumns.length - 1 -->, <!-- /ko -->
          </div>
        </div>

        <div class="buttonPanel" style="float: right;">
          <button data-bind="click: $parent.openVisualizationPage" class="btn" title="Visualization">
            <i class="icon-bar-chart"></i>
          </button>
          <button data-bind="click: $parent.togglePreviewTable" class="btn" title="Preview Data" data-toggle="button">
            <i class="icon-table"></i>
          </button>
        </div>
      </div>

      <div data-bind="visible: isDataPreviewTableShown" class="dataPreviewContainer">

        <div data-bind="visible: !dataPreviewViewModel()" style="padding-top: 10px;padding-left: 30px;">Loading...</div>

        <div  data-bind="with: dataPreviewViewModel">
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
                <div style="display: inline-block;margin-right: 4px;" id="dataPreviewLoadingIcon" class="dataPreviewLoadingIcon">
                  <img data-bind="visible: $parent.isLoading" src="../images/ajax-loader.gif" />
                </div>
                <i class="icon-arrow-left" id="prevBtn" data-bind="visible: currentPage() > 1, click: $parent.goToPreviousPage" title="Previous Page"></i>
                <i class="icon-arrow-right" id="nextBtn" data-bind="visible: currentPage() &lt; totalPage(), click: $parent.goToNextPage" title="Next Page"></i>
              </div>
            </div>
          </div>
        </div>

      </div>

      <div data-bind="with: resultObj" class="searchResultFooter">
        <p data-bind="foreach: foundSearchKeys" style="margin-top: 10px;">
          <!-- ko if: $index() == 0 -->
          <span class="searchKeyText">
            <i class="icon-key" title="Matched Keywords" style="margin-right: 5px;"></i>
          </span>
          <!-- /ko -->
          <span data-bind="template: { name: 'columnTooltip-template', data: $data}" class="searchKeyText">
          </span>
          <!-- ko if: $index() < $parent.foundSearchKeys.length - 1 -->, <!-- /ko -->
        </p>
      </div>

    </div>
    <!-- /ko -->

    <!-- ko ifnot: resultObj.oneSid -->
    <div class="stories pathResult">
      <div class="searchResultBody" style="overflow: auto;">
        <div class="searchResultProfile">
          <h2>
            Relationships: <a data-bind="text: resultObj.title" class="title"></a>
          </h2>
          <div data-bind="foreach: paths" class="paths">

            <div data-bind="with: pathObj" class="path">

              <div class="pathBody">
                <div style="float:left;">
                  <div class="pathTitle">
                    <span  style="color: black;">Path: </span>
                    <span data-bind="text: title" class="pathTitleText"></span>
                  </div>
                  <div data-bind="foreach: sidTitles" class="sources">
                    <span data-bind="if: $index() == 0" class="sourcesTitle" style="color: black;">Datasets: </span>
                    <span data-bind="text: $data" class="sourceText"></span>
                  </div>
                </div>

                <div class="buttonPanel" style="float: right;">
                  <button data-bind="click: $parent.toggleMore" class="btn" data-toggle="button">
                    <i data-bind="visible: !$parent.isMoreShown()" class="icon-plus"></i>
                    <i data-bind="visible: $parent.isMoreShown()" class="icon-minus"></i>
                  </button>
                </div>
              </div>

              <div data-bind="visible: $parent.isMoreShown()" class="pathDetail" style="margin-top: 10px;">
                <div style="color:black;">Relationships: </div>
                <table class="pathRelTable tftable">
                  <tr>
                    <th>From</th>
                    <th>To</th>
                    <th>Confidence</th>
                  </tr>
                  <tbody data-bind="foreach: relationships">
                    <tr>
                      <td data-bind="template: { name: 'relInfo-template', data: sidFrom }">
                      </td>
                      <td data-bind="template: { name: 'relInfo-template', data: sidTo }">
                      </td>
                      <td data-bind="text: confidence">
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>



              <div class="searchResultFooter">
                <p data-bind="foreach: foundSearchKeys" style="margin-top: 10px;">
                  <!-- ko if: $index() == 0 -->
                  <span class="searchKeyText">
                    <i class="icon-key" title="Matched Keywords" style="margin-right: 5px;"></i>
                  </span>
                  <!-- /ko -->
                  <span data-bind="template: { name: 'columnTooltip-template', data: $data}" class="searchKeyText">
                    <span data-bind="text: $data.dname_chosen" class="searchKeyText"></span>
                    <!-- ko if: $index() < $parent.foundSearchKeys.length - 1 -->, <!-- /ko -->
                  </p>
              </div>

            </div>

          </div>
        </div>
      </div>
    </div>
    <!-- /ko -->

  </div>
</div>

<form id="visualizationDatasetSerializeForm" style="display:none;" target="_blank" method="post" action="../visualization/dashboard.php">
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

<script type="text/html" id="relInfo-template">
  <a  data-bind="text: $data.sidTitle, attr: {href: '../story.php?title=' + $data.sid}"></a>
  .<span data-bind="text:  $data.tableName"></span>
</script>

{/literal}