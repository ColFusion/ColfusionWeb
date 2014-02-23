<script type="text/javascript" src="{$my_pligg_base}/templates/{$the_template}/js/story_preview.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-1.9.1.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-ui-1.10.3.custom.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/chosen.jquery.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/bootstrap.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/bootstrap-wizard.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/bootstrap-lightbox.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/hogan.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/typeahead.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery.sheet.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/templates/{$the_template}/js/jquery.form.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-file-upload/jquery.fileupload.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-file-upload/jquery.fileupload-ui.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-file-upload/jquery.iframe-transport.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-file-upload/vendor/jquery.ui.widget.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/parsley.min.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/persist-min.js"></script>

<script type="text/javascript" src="{$my_pligg_base}/javascripts/dataSourceUtil.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/fileManager.js"></script>

<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout-2.3.0.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout.mapping.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/Utils.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/RelationshipModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/DataPreviewViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/RelationshipViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/NewRelationshipViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/WizardExcelPreviewViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/WizardUploadDatasetViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/SourceWorksheetSettingsViewModel.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/ProgressBarViewModel.js"></script>

<script type="text/javascript" src="{$my_pligg_base}/templates/{$the_template}/js/importWizard.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/templates/{$the_template}/js/wizardFromFile.js"></script>
<script type="text/javascript" src="{$my_pligg_base}/templates/{$the_template}/js/wizardFromDB.js"></script>
   


    {literal}
       
        <script type="text/javascript">
            
            $.sheet.preLoad('jquery.sheet/');

            var sid;
            var dataPreviewViewModel;
            var relationshipViewModel;

            var initNewStoryPage = function(sid) {
                sid = sid;
                dataPreviewViewModel = new DataPreviewViewModel(sid);
                relationshipViewModel = new RelationshipViewModel(sid);
                ko.applyBindings(relationshipViewModel, document.getElementById("mineRelationshipsContainer"));
            
                importWizard.Init(sid);
            
                $.ajax({
                    type: 'POST',
                    url: "DataImportWizard/dataPreviewMarkup.php",
                    data: {},
                    success: function(data) {
                        $("#dataPreviewContainer").append(data);
                        ko.applyBindings(dataPreviewViewModel, document.getElementById("dataPreviewContainer"));
                    },
                    dataType: 'html',
                    async: false
                });
            }

            
            $('#newRelContainer').css({
                'width': '102%',
                'margin-left': '-22px'
                }); 
        </script>

    {/literal}