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

function DatasetSearcher(inputDom, selectedCallback) {
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
        console.log(datum);
        if (selectedCallback) {
            selectedCallback(datum);
        }
        self.sid = datum.sid;
        self.datasetName = datum.title;
    });
}

function showDescriptionInPopup(datum) {
    var table = $("<table id='addStoryDesTable'></table>");
    var datasetTitle = $('<tr><td class="desTitle">Dataset Title:</td><td>' + datum.title + '</td></tr>');
    var description = $('<tr><td class="desTitle">Description:</td><td>' + datum.content + '</td></tr>');
    var creator = $('<tr><td class="desTitle">Submit by:</td><td>' + datum.userName + '</td></tr>');
    var dateSubmitted = $('<tr><td class="desTitle">Date Submitted:</td><td>' + datum.entryDate + '</td></tr>');
    var lastUpdated = datum.lastUpdated ? datum.lastUpdated : datum.entryDate;
    var lastReferenced = $('<tr><td class="desTitle">Date Last Updated:</td><td>' + lastUpdated + '</td></tr>');   
    $(table).append(datasetTitle).append(description).append(creator).append(dateSubmitted).append(lastReferenced); 
    $('#story-search-result').html(table);
}

var datasetSearcher;

$(function() {
    datasetSearcher = new DatasetSearcher($('#search-sid'), showDescriptionInPopup);
});