$(function() {
    var dataMatchCheckerViewModel = prepareDataMatchCheckerViewModel();
    ko.applyBindings(dataMatchCheckerViewModel);
    initNavListStyleEvent();
});

function prepareDataMatchCheckerViewModel() {
    var relationModel = getRelationshipInfo();
    return createDataMatchCheckerViewModel(relationModel);
}

function getRelationshipInfo() {  
    var relationModel = JSON.parse($('#relSerializedString').val()); 

    if (relationModel.isContainerShowned === undefined) {
        relationModel = makeNewRelationshipModelCompatibleToRelationshipModel(relationModel);
    } else {
        relationModel = makeRelationshipModelCompatibleToNewRelationshipModel(relationModel);
    }

    console.log(relationModel);
    return relationModel;
}

/*
Since Relstionship and NewRelationship use different model,
we need to transfer data between uncommon attributes.
*/
function makeRelationshipModelCompatibleToNewRelationshipModel(relationModel) {
    relationModel.fromDataSet.shownTableName = relationModel.shownTableName || 'empty';
    relationModel.toDataSet.shownTableName = relationModel.shownTableName || 'empty';
    
    return relationModel;
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
