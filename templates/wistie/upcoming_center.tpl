<div id="storiesContainer" class="stories">

	<!-- ko if:isLoading -->
	<img src="images/ajax-loader-wt.gif" style="padding-left: 220px;"/>
	<!-- /ko -->
	
	<!-- ko ifnot:isLoading -->

		

		<table class="table table-striped table-hover">
			<tbody>
				<!-- ko foreach: stories -->
					<tr>
						<td>
							<div>							
								<p>
									<a href="#" data-bind="click: $root.editStory">
										<!-- ko if: title -->
										<span data-bind="text: title()"></span>
										<!-- /ko -->

										<!-- ko ifnot: title -->
										&lt;No title&gt;
										<!-- /ko -->
									</a>
								</p>
								<div>
									<span>
										<!-- ko if: description -->
										<span data-bind="text: shortDescription()"></span>
										<!-- /ko -->
										<!-- ko ifnot: description -->
										&lt;No description&gt;
										<!-- /ko -->
									</span><br />
									<div class="pull-right">
										Created By <span data-bind="text: createdBy()"></span>
										<br/>
										<span data-bind="text: createdOn()"></span>
										<!-- ko if: status() == 'private' -->
										<p style="background-color: #FFCCCC; font-weight: bold;">Status is <span data-bind="text: status()"></span></p>
										<!-- /ko -->
									</div>
								</div>
							</div>
						</td>
					</tr>
				<!-- /ko -->
			</tbody>
		</table>

	<!-- /ko -->
</div>
<?php
global $current_user;
include_once(mnminclude.'login.php');
if($current_user != null)
	$user_id = $current_user->user_id;
else
	$user_id = null;
echo "<input type=\"hidden\" name=\"user_id\" id=\"user_id\" value=\"$user_id\" />";
?>

<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<script type="text/javascript" src="javascripts/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="javascripts/bootstrap.min.js"></script>
<script type="text/javascript" src="javascripts/knockout-2.3.0.js"></script>
<script type="text/javascript" src="javascripts/knockout_models/StoryMetadataViewModel.js"></script>
<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">

<script>
	ko.applyBindings(new StoriesViewModel(), $("#storiesContainer")[0]);
</script>

<!--{$link_summary_output}
{checkActionsTpl location="tpl_pligg_pagination_start"}
{$link_pagination}
{checkActionsTpl location="tpl_pligg_pagination_end"}-->