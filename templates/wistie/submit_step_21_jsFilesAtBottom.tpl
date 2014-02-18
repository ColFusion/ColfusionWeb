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
        <link href="chosen.css" rel="stylesheet" />
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

        <style>
            #newRelationshipBtn{
                margin: 0 0 10px 0; 
                display: block;
            }
        </style>

        <script type="text/javascript">
            (function($) {
            $.widget("custom.combobox", {
            _create: function() {
            this.wrapper = $("<span>")
            .addClass("custom-combobox")
            .insertAfter(this.element);

            this.element.hide();
            this._createAutocomplete();
            this._createShowAllButton();
            },
            _createAutocomplete: function() {
            var selected = this.element.children(":selected"),
            value = selected.val() ? selected.text() : "";

            this.input = $("<input>")
            .appendTo(this.wrapper)
            .val(value)
            .attr("title", "")
            .addClass("custom-combobox-input ui-widget ui-widget-content ui-state-default ui-corner-left")
            .autocomplete({
            delay: 0,
            minLength: 0,
            source: $.proxy(this, "_source")
            })
            .tooltip({
            tooltipClass: "ui-state-highlight"
            });

            this._on(this.input, {
            autocompleteselect: function(event, ui) {
            ui.item.option.selected = true;
            this._trigger("select", event, {
            item: ui.item.option
            });
            },
            autocompletechange: "_removeIfInvalid"
            });
            },
            _createShowAllButton: function() {
            var input = this.input,
            wasOpen = false;

            $("<a>")
            .attr("tabIndex", -1)
            .attr("title", "Show All Items")
            .tooltip()
            .appendTo(this.wrapper)
            .button({
            icons: {
            primary: "ui-icon-triangle-1-s"
            },
            text: false
            })
            .removeClass("ui-corner-all")
            .addClass("custom-combobox-toggle ui-corner-right")
            .mousedown(function() {
            wasOpen = input.autocomplete("widget").is(":visible");
            })
            .click(function() {
            input.focus();

            // Close if already visible
            if (wasOpen) {
            return;
            }

            // Pass empty string as value to search for, displaying all results
            input.autocomplete("search", "");
            });
            },
            _source: function(request, response) {
            var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
            response(this.element.children("option").map(function() {
            var text = $(this).text();
            if (this.value && (!request.term || matcher.test(text)))
            return {
            label: text,
            value: text,
            option: this
            };
            }));
            },
            _removeIfInvalid: function(event, ui) {

            // Selected an item, nothing to do
            if (ui.item) {
            return;
            }

            // Search for a match (case-insensitive)
            var value = this.input.val(),
            valueLowerCase = value.toLowerCase(),
            valid = false;
            this.element.children("option").each(function() {
            if ($(this).text().toLowerCase() === valueLowerCase) {
            this.selected = valid = true;
            return false;
            }
            });

            // Found a match, nothing to do
            if (valid) {
            return;
            }

            // Remove invalid value
            this.input
            .val("")
            .attr("title", value + " didn't match any item")
            .tooltip("open");
            this.element.val("");
            this._delay(function() {
            this.input.tooltip("close").attr("title", "");
            }, 2500);
            this.input.data("ui-autocomplete").term = "";
            },
            _destroy: function() {
            this.wrapper.remove();
            this.element.show();
            }
            });
            })(jQuery);

            $.sheet.preLoad('jquery.sheet/');

            var sid;
            var dataPreviewViewModel;
            var relationshipViewModel;

            $(document).ready(function() {

            sid = $('#sid').val();
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

            // Open attachment upload page.
            $('#uploadAttachmentLink').click(function() {
            $('#uploadAttachmentLightBox').lightbox({resizeToFit: false});
            });

            // When lightbox is closed, refresh attachment list.
            $('#uploadAttachmentLightBox').bind('hidden', function(e) {
            // Refresh attachment list.
            fileManager.loadSourceAttachments(sid, $("#attachmentList"));
            var lightBoxContentDom = $('#uploadAttachmentLightBox').find('.lightbox-content');
            var iframeDom = $(lightBoxContentDom).find('iframe');
            $(iframeDom).remove();
            $(iframeDom).appendTo(lightBoxContentDom);
            });

            // Load attachment list.
            fileManager.loadSourceAttachments(sid, $("#attachmentList"));          
            });

            function submitDataSubmissionForm() {
                $('#submitNewDataForm').parsley({
                    'excluded': 'input[type=radio], input[type=checkbox]'
                });
                
                if($('#submitNewDataForm').parsley('validate')){
                    document.forms['submitNewDataForm'].submit();
                }
            }    

            $('#newRelContainer').css({
                'width': '102%',
                'margin-left': '-22px'
                }); 
        </script>

    {/literal}