$(document).ready(function(){
$( "#visualizeBtn" ).click(function() {
 var  statisticsView= $(this).closest('#statisticsView') ;
   statisticsView.find('#storyStatisticsContainer').slideToggle();
});

//$('table th:first-child').css('visualizeBtn:','hidden');
//$('#statisticsIcon: first-child').css({'padding': '20px','color':'red'});
});