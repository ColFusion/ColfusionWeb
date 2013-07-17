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
$currentPage = $_REQUEST['currentPage'];

$authorizationStr = ($_REQUEST['authorizationLevel']==-1)?"":" privilege = ".$_REQUEST['authorizationLevel']." AND ";


global $db;


	$totalStr = "select count(*) as sum from (select t2.privilege, U.user_login,t2.mdate,t2.name,t2.vid 
		        from colfusion_canvases C2,colfusion_users U,
		        (select t1.mdate ,t1.name,S.vid,S.privilege from colfusion_shares S ,
		          (select C.vid ,C.mdate,C.name from colfusion_canvases C where left(C.name,".$lengt1.")='".$content[0]."'
		          union select CT.vid ,CT.mdate,CT.name from colfusion_canvases CT,colfusion_users UT where UT.user_id = CT.user_id AND left(UT.user_login,".$lengt1.")='".$content[0]."')t1 
		          where S.vid = t1.vid AND ".$authorizationStr." S.user_id = ".$user_id.")t2 where t2.vid = C2.vid AND C2.user_id = U.user_id order by t2.mdate)final";
	
	$totalResult = $db->get_results($totalStr);
	$_SESSION['totalRow'] =  $totalResult[0]->sum;



if (count($content)==1)
$query = "select t2.privilege, U.user_login,t2.mdate,t2.name,t2.vid 
		        from colfusion_canvases C2,colfusion_users U,
		        (select t1.mdate ,t1.name,S.vid,S.privilege from colfusion_shares S ,
		          (select C.vid ,C.mdate,C.name from colfusion_canvases C where left(C.name,".$lengt1.")='".$content[0]."'
		          union select CT.vid ,CT.mdate,CT.name from colfusion_canvases CT,colfusion_users UT where UT.user_id = CT.user_id AND left(UT.user_login,".$lengt1.")='".$content[0]."')t1 
		          where S.vid = t1.vid AND ".$authorizationStr." S.user_id = ".$user_id.")t2 where t2.vid = C2.vid AND C2.user_id = U.user_id order by t2.mdate limit ".($currentPage-1)*$columnNum.",".$columnNum;
else if (count($content)==2)
	$query = "select t2.privilege, U.user_login,t2.mdate,t2.name,t2.vid
		        from colfusion_canvases C2,colfusion_users U,
		        (select t1.mdate ,t1.name,S.vid,S.privilege from colfusion_shares S ,
		          (select C.vid ,C.mdate,C.name from colfusion_canvases C where left(C.name,".$lengt2.")='".$content[1]."')t1 
		          where S.vid = t1.vid AND ".$authorizationStr." S.user_id = ".$user_id.")t2 where left(U.user_login,".$lengt1.")='".$content[0]."' AND t2.vid = C2.vid AND C2.user_id = U.user_id group by t2.privilege, U.user_login,t2.mdate,t2.name,t2.vid order by t2.mdate limit ".($currentPage-1)*$columnNum.",".$columnNum;
else 
	$query = "";

$result = $db->get_results($query);

$PagingStr=($currentPage==1)?"":'<li><a href="#" onclick = "showHint(\''.$_GET['content'].'\','.(($currentPage-1)*-1).')"><<</a></li>';

for($num = $currentPage;($num-1)*$columnNum<$_SESSION['totalRow'];$num++){
	
	if ($num>$currentPage+2){
		$PagingStr .=  '<li><a href="#" onclick = "showHint(\''.$_GET['content'].'\','.(-1*$num).')">>></a></li>';
		break;
	}
	$PagingStr .=  '<li><a href="#" onclick = "showHint(\''.$_GET['content'].'\','.(-1*$num).')">'.$num.'</a></li>';
};

echo '<table id = "result_table" class="table table-hover">';
echo '
<thead>
<tr>
<th>Canvas Name</th>
<th>Owner</th>
<th>Authorization</th>
<th>Last Modified</th>
<th id = "thadjust">
<div id = "pagbut" class="pagination pagination-mini">
  <ul>
  '.$PagingStr.'
  </ul>
</div>
</th>
</tr>
</thead>
<tbody>
';

for ($id = 0;$id<count($result);$id++){
	
	$row=$result[$id];
	echo '<tr name = "'.$row->name.'" style="color:#0088CC" id = "'.$row->vid.'**'.$row->mdate.'" class = "turnBlue authorizationLevel'.$row->privilege.'"><td  class="tableadjust gridEffect" >'.$row->name.'</td><td class="tableadjust gridEffect">'.$row->user_login.'</td><td class="tableadjust gridEffect">'.$privilege[$row->privilege].$insertIcon.'</td><td class="tableadjust">'.$row->mdate.'</td><td><input name="deleteItem" type="checkbox"></td></tr>';
}
echo '</tbody></table>';
mysql_close($con);

?>