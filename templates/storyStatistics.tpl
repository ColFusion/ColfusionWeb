<div class="dataPreviewTableWrapper">
    <div class="preview-story" id="statisticTest">
        <h3 class="preview-title">Statistics</h3>

<!--  show Statistics in side bar under Published data tab --> 

<div class="storycontent" id="dataPreviewContainer">


<table class="tftable" border="1" style="white-space: nowrap;">
    <thead><tr>
        <th>Mean</th>
        <th>Stdev</th>
        <th>Count</th>
    </tr></thead>
    <tbody data-bind="foreach: table">
    <tr>
        <td data-bind="text: mean"></td>
        <td data-bind="text: stdev"></td>
        <td data-bind="text: count"></td>
    </tr>
    </tbody>
</table>

<p>m is <strong data-bind = "text: m"></strong></p>

<div id="previewTableNavigations">
    <i class="icon-arrow-left" id="prevBtn" data-bind="visible: currentPage() > 1, click: $parent.goToPreviousPage" title="Previous Page"></i>
    <i class="icon-arrow-right" id="nextBtn" data-bind="visible: currentPage() < totalPage(), click: $parent.goToNextPage" title="Next Page"></i>
</div>
</div>



</div>
</div>    

<script>
    my_pligg_base = "{$my_pligg_base}";
</script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout-2.3.0.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/StatisticsViewModel.js"></script>

<script class="includeMouseWheelScript" type="text/javascript" src="javascripts/jquery.mousewheel.js"></script>
