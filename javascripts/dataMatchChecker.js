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
    var newRelationModel = JSON.parse($('#relSerializedString').val());
    
    if (newRelationModel.isContainerShowned === undefined) {
        newRelationModel = makeNewRelationshipModelCompatibleToRelationshipModel(newRelationModel);
    }
    console.log(newRelationModel);
    return newRelationModel;
}

function makeNewRelationshipModelCompatibleToRelationshipModel(relationModel) {
    relationModel.fromDataSet = relationModel.fromDataSet || relationModel.fromDataset;
    relationModel.toDataSet = relationModel.toDataSet || relationModel.toDataset;

    var newLinks = [];
    $.each(relationModel.links, function(i, link) {
        var newLink = {
            fromLinkPart: {
                transInput: link.fromPart
            },
            toLinkPart: {
                transInput: link.toPart
            }
        };
        newLinks.push(newLink);
    });

    relationModel.links = newLinks;
    return relationModel;
}

function createDataMatchCheckerViewModel(newRelationModel) {
    var dataMatchCheckerViewModel = new DataMatchCheckerViewModel();
    dataMatchCheckerViewModel.name(newRelationModel.name);
    dataMatchCheckerViewModel.description(newRelationModel.content);
    dataMatchCheckerViewModel.fromDataset(newRelationModel.fromDataSet);
    dataMatchCheckerViewModel.toDataset(newRelationModel.toDataSet);
    dataMatchCheckerViewModel.links(newRelationModel.links);

    dataMatchCheckerViewModel.links($.map(newRelationModel.links, function(link, i) {
        console.log(link);
        if (link.fromLinkPart.transInput && link.toLinkPart.transInput) {
            return link;
        }
    }));

    return dataMatchCheckerViewModel;
}

function initNavListStyleEvent() {
    $('#navListContainer').find('a').click(function() {
        $('#navListContainer').find('li').removeClass('selected');
        $(this).parent().addClass('selected');
    });
}
