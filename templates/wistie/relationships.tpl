<!-- Edited by Haoyu Wang, create a tpl for relationships(to view relationship based on the whole database)-->
<!-- Just parse from advanced.tpl ,, may need to  modify-->

{literal}
<div id="advanced" class="advanced1">
    <form id="advancedsearch" style="border: none; margin: 20px; padding: 0px;">
        <h2>Relationship graph</h2>
        <table style="width: 100%;">
            <tr>
                <td colspan="1">
                    <img data-bind="visible: isSearching" style="margin-left: 5px;" src="{/literal}{$my_pligg_base}{literal}/images/ajax-loader.gif" />                   
                </td>
            </tr>
        </table>
    </form>


    <div data-bind="visible:isNoResultTextShown() && searchResults().length == 0" style="display: none; margin: -5px 0 0 20px;">
        No Results Found.
    </div>
    <div data-bind="visible:isSearchError()" style="display: none; margin: -5px 0 0 20px; color: red">
        Some errors occur when searching dataset.
    </div>
    <!-- advanced search result -->
    <div data-bind="foreach: searchResults" id="resultDiv" style="border: none; margin: 0px; padding: 0px;">

        <!-- ko ifnot: resultObj.oneSid -->
        <div class="stories pathResult">
            <div class="searchResultBody" style="overflow: auto;">
                <div class="graphTitle">Relationship Graph:</div>
                <div data-bind="relationshipGraph: paths"></div>
            </div>
        </div>
        <!-- /ko -->
    </div>
</div>



{/literal}