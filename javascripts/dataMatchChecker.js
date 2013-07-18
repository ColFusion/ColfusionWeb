$(function(){
     initEditable();
     initNavListStyleEvent();
});

function initEditable(){
    $('.linkDataTable').dataTable().makeEditable();
}

function initNavListStyleEvent(){
    $('#navListContainer').find('a').click(function(){
        $('#navListContainer').find('li').removeClass('selected');
        $(this).parent().addClass('selected');
    });
}
