<!-- START NOTIFICATION_ALL.TPL -->
<head>
    <script type="text/javascript" src="{$my_pligg_base}/templates/wistie/js/script.js"></script>
    <script type="text/javascript" src="{$my_pligg_base}/javascripts/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout-2.3.0.js"></script>
    <script type="text/javascript" src="{$my_pligg_base}/javascripts/knockout_models/Notification_model.js"></script>
</head>

{literal}
<style type="text/css">
	.notification_all_block {
		border-top: 1px solid #AAA; margin: 0 20px; padding: 10px;
	}
	.notification_all_block_row {
		border-bottom: 1px solid #E9DDAB; margin-top: 8px; padding-bottom: 3px;
		font-size: 12px;
	}
	.notification_all_icon {
		height: 15px; vertical-align: text-bottom;
	}
</style>
{/literal}

<legend style="margin: 20px 20px;">Your Notifications</legend>

<div class="notification_all_block" data-bind="foreach: ntfs">
	<div class="notification_all_block_row">
		<img class="notification_all_icon" src="{$my_pligg_base}/templates/{$the_template}/images/notification_item.png"/>
		<a style="cursor: pointer;" data-bind="click: $root.goToUser, text: sender"></a>
		<span style="cursor: pointer;" data-bind="click: $root.goToStory, text: seeAllMsg"></span>
	</div>
</div>

<script type="text/javascript">
	applyBseeall();
</script>