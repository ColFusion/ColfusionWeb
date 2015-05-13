12335665656
<div id="draftsContainer" class="stories" data-bind="with: dm">
	<dl data-bind="foreach: drafts" class="list-group">
		<div class="summaryline" style="padding-left: 20px;">

				<!-- ko if: title -->
				<a data-bind="href: url">

			    	<h2 data-bind="text: title" class="title"></h2>
			    </a>
			    <!-- /ko -->
				<!-- ko ifnot: title -->
				<a data-bind="href: url">
					<h2 class="title">&lt;No title&gt;</h2>
				</a>
				<!-- /ko -->
			<dd>
			<span class="storycontent">
				<!-- ko if: description -->
				<span data-bind="text: description"></span>
				<!-- /ko -->
				<!-- ko ifnot: description -->
				&lt;No description&gt;
				<!-- /ko -->
			</span><br />
			<span class="subtext" style="float:left;">
				Created By <span data-bind="text: createdBy"></span>
				On <span data-bind="text: createdOn"></span><br />
				Last Updated On <span data-bind="text: lastUpdated"></span><br/>
				Status is <span data-bind="text: status"></span><br />
			</span>
		</dd>
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