
<div id="storiesContainer" class="stories">
	<dl data-bind="foreach: stories" class="list-group">
		<div class="summaryline" style="padding-left: 20px;">
		<table>
		<tr>
		<th>
			<a href="#" data-bind="click: $root.editStory">
				<!-- ko if: title -->
				<h2 data-bind="text: title" class="title"></h2>
				<!-- /ko -->
				<!-- ko ifnot: title -->
				&lt;No title&gt;
				<!-- /ko -->
			</a>
			</th>
			</tr>
			<tr>
			<td>
			<span class="storycontent">
				<!-- ko if: description -->
				<span data-bind="text: description"></span>
				<!-- /ko -->
				<!-- ko ifnot: description -->
				&lt;No description&gt;
				<!-- /ko -->
			</span><br />
			</td>
			</tr>
			<tr>
			<td></td>
			<td>
			<span class="subtext" style="float:left;"  >
				Created By <span data-bind="text: createdBy"></span>
				On <span data-bind="text: createdOn"></span><br />
				Last Updated On <span data-bind="text: lastUpdated"></span><br/>
				Status is <span data-bind="text: status" style="color:blue; font-weight:bold"></span> </span><br />
			</span>
			</td>
			</tr>
			</table>

		</div><br />
	</dl>
</div>

<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<script type="text/javascript" src="javascripts/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="javascripts/bootstrap.min.js"></script>
<script type="text/javascript" src="javascripts/knockout-2.3.0.js"></script>
<script type="text/javascript" src="javascripts/knockout_models/StoryMetadataViewModel.js"></script>

<!--{$link_summary_output}
{checkActionsTpl location="tpl_pligg_pagination_start"}
{$link_pagination}
{checkActionsTpl location="tpl_pligg_pagination_end"}-->