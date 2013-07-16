var typeahead_template = '<div class="dataColumnSuggestion">' +
        '<div style="overflow: auto; margin-bottom: 5px;">' +
        '<p class="dataColumnSuggestion-Name">' +
        '{{dname_chosen}}' +
        '</p>' +
        '<p class="dataColumnSuggestion-dataSetName"><span class="byText">by</span>' +
        '{{dataset_name}}' +
        '</p>' +
        '</div>' +
        '<div class="dataColumnSuggestion-Description">' +
        '{{dname_value_description}}' +
        '</div>' +
        '</div>';

var search_typeahead_tpl = typeahead_template
        .replace("{{dname_chosen}}", "{{title}}")
        .replace("{{dataset_name}}", "{{userName}}")
        .replace("{{dname_value_description}}", "{{content}}");

function DatasetSearcher(inputDom) {
    var self = this;
    self.element = inputDom;
    self.sid;
    self.datasetName;

    $(self.element).typeahead({
        name: 'datasets',
        prefetch: {
            url: '/colfusion/datasetController/findDataset.php',
            ttl: 10 * 60 * 1000 // cache 10 mins
        },
        valueKey: 'source_key',
        template: search_typeahead_tpl,
        engine: Hogan
    }).bind('typeahead:selected', function(event, datum) {
        self.sid = datum.sid;
        self.datasetName = datum.title;
    });
}

var datasetSearcher;

$(function() {
    datasetSearcher = new DatasetSearcher($('#search-sid'));
});