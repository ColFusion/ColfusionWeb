<h3>Notification Page</h3>

<!--{literal}
<div id="notification">
	<table>
		<tbody data-bind="foreach: ntfs()">
			<tr data-bind="click: $root.goToStory">
				<td data-bind="text: sender_id"></td>
				<td data-bind="text: action"></td>
				<td data-bind="text: target"></td>
			</tr>
		</tbody>
	</table>
</div>
<script type="text/javascript" src="../javascripts/jquery-1.9.1.js"></script>  
<script type="text/javascript" src="../javascripts/knockout-2.3.0.js"></script>
<script type="text/javascript" src="../javascripts/knockout_models/Notification_model.js">
</script>
<script type="text/javascript">
	$(function() {
		ko.cleanNode(document.getElementById('notification'));
		ko.applyBindings(new NotificationViewModel, document.getElementById('notification'));
	});
</script>
{/literal}-->