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

    newRelationModel = makeNewRelationshipModelCompatibleToRelationshipModel(newRelationModel);
    console.log(newRelationModel);
    return newRelationModel;
}

function makeNewRelationshipModelCompatibleToRelationshipModel(newRelationModel) {
    newRelationModel.fromDataSet = newRelationModel.fromDataSet || newRelationModel.fromDataset;
    newRelationModel.toDataSet = newRelationModel.toDataSet || newRelationModel.toDataset;
    
    
    
    return newRelationModel;
}

function createDataMatchCheckerViewModel(newRelationModel) {
    var dataMatchCheckerViewModel = new DataMatchCheckerViewModel();
    dataMatchCheckerViewModel.name(newRelationModel.name);
    dataMatchCheckerViewModel.description(newRelationModel.content);
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
