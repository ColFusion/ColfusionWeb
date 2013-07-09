<?php
include('../config.php');

$content = explode(" ",$_GET['content']);
$lengt1 = strlen($content[0]);
if (count($content)==2)
	$lengt2=strlen($content[1]);

$privilege = array(
	'User-Owned','Readable','Modifiable'
);
$user_id = $current_user->user_id;
$columnNum = $_REQUEST['columnNum'];
$currentRow = $_REQUEST['currentRow'];
   

global $db;
if (count($content)==1)
$query = "select * from (select t2.privilege, U.user_login,t2.mdate,t2.name,t2.vid 
		        from colfusion_canvases C2,colfusion_users U,
		        (select t1.mdate ,t1.name,S.vid,S.privilege from colfusion_shares S ,
		          (select C.vid ,C.mdate,C.name from colfusion_canvases C where left(C.name,".$lengt1.")='".$content[0]."'
		          union select CT.vid ,CT.mdate,CT.name from colfusion_canvases CT,colfusion_users UT where UT.user_id = CT.user_id AND left(UT.user_login,".$lengt1.")='".$content[0]."')t1 
		          where S.vid = t1.vid AND S.user_id = ".$user_id.")t2 where t2.vid = C2.vid AND C2.user_id = U.user_id order by t2.mdate)final limit ".$currentRow.",".($columnNum+1);
else if (count($content)==2)
	$query = "select * from (select t2.privilege, U.user_login,t2.mdate,t2.name,t2.vid 
		        from colfusion_canvases C2,colfusion_users U,
		        (select t1.mdate ,t1.name,S.vid,S.privilege from colfusion_shares S ,
		          (select C.vid ,C.mdate,C.name from colfusion_canvases C where left(C.name,".$lengt2.")='".$content[1]."')t1 
		          where S.vid = t1.vid AND S.user_id = ".$user_id.")t2 where left(U.user_login,".$lengt1.")='".$content[0]."' AND t2.vid = C2.vid AND C2.user_id = U.user_id order by t2.mdate)final limit ".$currentRow.",".($columnNum+1);
else 
	$query = "";


$result = $db->get_results($query);
$hasNextPage = (count($result)>columnNum)?'true':'false';

echo '<table name="'.$hasNextPage.'" id = "result_table" class="table table-hover">';
echo '
<thead>
<tr>
<th>Canvas Name</th>
<th>Owner</th>
<th>Authorization</th>
<th>Last Modified</th>
<th id = "thadjust">

</th>
</tr>
</thead>
<tbody>
';

for ($id = 0;$id<count($result)-1;$id++){
	
	$row=$result[$id];
	$insertIcon = ($row->privilege == 0)?'&nbsp&nbsp&nbsp<a onclick="CurCanId('.$row->vid.')" href = "#shareWith" data-toggle="modal"><i class="icon-share"></i></a>':'';
	echo '<tr name = "'.$row->name.'" style="color:#0088CC" id = "'.$row->vid.'**'.$row->mdate.'" class = "turnBlue authorizationLevel'.$row->privilege.'"><td  class="tableadjust gridEffect" >'.$row->name.'</td><td class="tableadjust gridEffect">'.$row->user_login.'</td><td class="tableadjust gridEffect">'.$privilege[$row->privilege].$insertIcon.'</td><td class="tableadjust">'.$row->mdate.'</td><td><input name="deleteItem" type="checkbox"></td></tr>';
}
echo '</tbody></table>';

mysql_close($con);

?>