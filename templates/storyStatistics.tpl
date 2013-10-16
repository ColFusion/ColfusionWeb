<div class="dataPreviewTableWrapper">
    <div class="preview-story" id="statisticTest">
        <h3 class="preview-title">Statistics</h3>

<!--  show Statistics in side bar under Published data tab --> 

<table class="tftable" border="1" style="white-space: nowrap;">
    <tr data-bind="foreach: table">
        <td data-bind="text: mean"></td>
        <td data-bind="text: stdev"></td>
        <td data-bind="text: count"></td>
    </tr>
</table>



<script>
    my_pligg_base = "{$my_pligg_base}";
</script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout-2.3.0.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/StatisticsViewModel.js"></script>


</div>
</div>    


