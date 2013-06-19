<div class="pagewrap">
            {literal}
				<style content="text/css">
					.commoncss
					{
						border: 3px solid #4169E1;
						padding: 10px;
						text-align : justify;
						font-weight:bold;
					}
					.row
					{
						border: 3px solid #4169E1;
						padding: 10px;
						text-align : justify;
						font-weight: bold;
					}
					.tbl
					{
					border='1';
					cellspacing='0';
					align = center;
					}
				</style>
                <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js" type="text/javascript"></script>
			{/literal}
	<h3 style="align:center">Colfusion Tables</h3>
   <h2>Colfusion Modules</h2>
   <table class= "tbl" >
	<tr class= "row">
		<td>Name</td>
		<td>Folder</td>
	</tr>
	{$mod}
    </table>

<br/>
<br/>
<h2>Colfusion Totals</h2>
   <table class = "tbl" >
	<tr class= "row">
		<td>Name</td>
		<td>Total</td>
	</tr>
	{$total}
   </table>



</div>