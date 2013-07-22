$(function() {
    var dataMatchCheckerViewModel = prepareDataMatchCheckerViewModel();
    ko.applyBindings(dataMatchCheckerViewModel);
    initNavListStyleEvent();
});

function prepareDataMatchCheckerViewModel() {
    var newRelationModel = getRelationshipInfo();
    return createDataMatchCheckerViewModel(newRelationModel);
}

function getRelationshipInfo() {
    var fromSid = $('#fromSidInput').val();
    var toSid = $('#toSidInput').val();
    var fromTable = $('#fromTableInput').val();
    var toTable = $('#toTableInput').val();
    var store = new Persist.Store('NewRelationshipViewModel');
    var newRelationModel = JSON.parse(store.get('checkDataMatching_' + fromSid + '_' + fromTable + '_' + toSid + '_' + toTable));
    console.log(newRelationModel);
    return newRelationModel;
}

function createDataMatchCheckerViewModel(newRelationModel) {
    var dataMatchCheckerViewModel = new DataMatchCheckerViewModel();
    dataMatchCheckerViewModel.name (newRelationModel.name);
    dataMatchCheckerViewModel.description (newRelationModel.content);
    dataMatchCheckerViewModel.fromDataset(newRelationModel.fromDataSet);
    dataMatchCheckerViewModel.toDataset(newRelationModel.toDataSet);
    dataMatchCheckerViewModel.links(newRelationModel.links);
    return dataMatchCheckerViewModel;
}

function initNavListStyleEvent() {
    $('#navListContainer').find('a').click(function() {
        $('#navListContainer').find('li').removeClass('selected');
        $(this).parent().addClass('selected');
    });
}
