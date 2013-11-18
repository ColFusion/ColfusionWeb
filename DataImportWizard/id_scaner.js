    $(document).ready(function(){
       // $("#tfhover").find("tbody").eq(1).find("tr").each(function(index){$(this).find("td").each(function(index2){$(this).attr("id","row"+index+"-col"+index2);});});
       var $targetTable = $("#tfhover").find("tbody").eq(1).find("tr");
       for (var i=0;i<$targetTable.length;i++) {
            $targetRow = $targetTable.eq(i).find("td");
            for (var j=0;j<$targetRow.length;j++) {
                $targetRow.eq(j).attr("id","row"+i+"-col"+j);
            }
       }
    });