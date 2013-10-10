
<div class="sidebar-headline">
	<div class="sidebartitle"><img src="{$my_pligg_base}/templates/{$the_template}/images/right_arrow.png"/>&nbsp;&nbsp;&nbsp;<a href="{$URL_tagcloud}">{#PLIGG_Visual_Global_Stat#}</a></div>
</div>



<div class="sidebar-content">

<!--	//put (query).php in DAL  -->
<p>Number of datasets: <strong data-bind="text: nDatasets"> </strong></p>

</div>
<script>
    my_pligg_base = '<?php echo $my_pligg_base; ?>';
</script>

<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout-2.3.0.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/Statistics.js"></script>





