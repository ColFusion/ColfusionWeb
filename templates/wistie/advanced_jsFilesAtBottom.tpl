<script type="text/javascript" src="{$my_pligg_base}/javascripts/classify.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-1.9.1.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-ui-1.10.3.custom.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery.mousewheel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/bootstrap.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/parsley.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/persist-min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/cytoscape.js-2.0.2/cytoscape.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout-2.3.0.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout.mapping.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/Utils.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/AdvancedSearchViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/DataPreviewViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/RelationshipViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/RelationshipModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/dataSourceUtil.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/generalUtils.js"></script>

{literal}
<script type="text/javascript">
        $(function() {
            var advancedSearchViewModel = new AdvancedSearchViewModel();
            ko.applyBindings(advancedSearchViewModel, document.getElementById('advanced'));
        });
</script>
{/literal}