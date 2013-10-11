
<div class="sidebar-headline">
	<div class="sidebartitle"><img src="{$my_pligg_base}/templates/{$the_template}/images/right_arrow.png"/>&nbsp;&nbsp;&nbsp;<a href="{$URL_tagcloud}">{#PLIGG_Visual_Global_Stat#}</a></div>
</div>



<div class="sidebar-content" id="globalStatistics">

<!--  show Statistics in side bar under Published data tab  -->
<p>Number of datasets: <strong data-bind="text: nDatasets"> </strong></p>
<p>Number of variables: <strong data-bind="text: nDvariables"> </strong></p>
<p>Number of relationships: <strong data-bind="text: nRelationships"> </strong></p>
<p>Number of records: <strong data-bind="text: nRecords"> </strong></p>
<p>Number of users: <strong data-bind="text: nUsers"> </strong></p>

</div>
<script>
    my_pligg_base = '{$my_pligg_base}';
</script>

<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout-2.3.0.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/Statistics.js"></script>





