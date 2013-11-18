
function showSubNav(name){
 document.getElementByName('name').style.display='block';
 
}
 function hideSubNav(name){
  document.getElementByName('name').style.display='none';
}

 function Modify(id) {  
  var str=prompt("enter new value:");
  if(str)
    {
        alert("new value is: "+ str)
    }
  var p=document.getElementById(id);
  p.innerHTML=str;  
  Mark(id);
  Comment(id);
}

 function Delete(id) {
  alert("it is deleted");
  document.getElementById(id).innerHTML="null";
  Mark(id);
  Comment(id);
}

function Mark(id){
  document.getElementById(id).style.background="#FFD700";

}

function Comment(id){
var p=prompt("please write a comment here: ");
// record the comment by id
}

