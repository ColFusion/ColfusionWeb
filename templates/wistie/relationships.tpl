<!-- Edited by Haoyu Wang, create a tpl for relationships(to view relationship based on the whole database)-->
<!-- Just parse from advanced.tpl ,, may need to  modify-->

{literal}
<div id="relationshipGraphContainer">
    <img data-bind="visible: isSearching" style="margin-left: 5px;" src="{/literal}{$my_pligg_base}{literal}/images/ajax-loader.gif" />                   
    <div data-bind="visible:isNoResultTextShown() && searchResults().length == 0" style="display: none; margin: -5px 0 0 20px;">
        No Results Found.
    </div>
    <div data-bind="visible:isSearchError()" style="display: none; margin: -5px 0 0 20px; color: red">
        Some errors occur when searching dataset.
    </div>
  
    <div class="graphTitle">Relationship Graph:</div>
    <div data-bind="relationshipGraph: graphData"></div>
           
</div>



{/literal}