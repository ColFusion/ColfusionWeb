{literal}
<div id="advanced" class="advanced">
  <div id="advancedsearch" style="border: none; margin: 20px; padding: 0px;">
    <h2>Advanced Search</h2>
    <br />
    <table style="width: 100%">
      <tr style="width: 100%">
        <td style="width: 80px !important;">Search for: </td>
        <td >
          <input data-bind="value: searchTerm" type="text" id="search" style="width:100%" />
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
                  data-required="true"
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
        <td>
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
  </div>

  <form id="joinRequestToNewPage" method="post" action="../visualization/dashboard.php" targe="visualizationWindow">
    <input type="hidden" name="joinQuery" />
    <input type="hidden" name="sidsWithColumns" />
  </form>

  <!-- advanced search result -->
  <div data-bind="foreach: searchResults" id="resultDiv" style="border: none; margin: 0px; padding: 0px;">
    
    <!-- ko if: resultObj.oneSid -->
    <div data-bind="with: resultObj" class="stories datasetResult">
 
      <div class="searchResultBody" style="overflow: auto;">
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
            <span data-bind="text: $data" class="columnText"></span>
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

      <div class="dataPreviewContainer">
        
      </div>

      <div class="searchResultFooter">
        <p data-bind="foreach: foundSearchKeys" style="margin-top: 10px;">
          <!-- ko if: $index() == 0 -->
          <span class="searchKeyText">
            <i class="icon-key" title="Matched Keywords" style="margin-right: 5px;"></i>
          </span>
          <!-- /ko -->
          <span data-bind="text: $data" class="searchKeyText"></span>
          <!-- ko if: $index() < $parent.foundSearchKeys.length - 1 -->, <!-- /ko -->
        </p>
      </div>

    </div>
    <!-- /ko -->

    <!-- ko ifnot: resultObj.oneSid -->
    <div class="stories pathResult">

    </div>
    <!-- /ko -->

  </div>
</div>
{/literal}