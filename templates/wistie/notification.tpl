<div id="notification">
	<table data-bind="foreach: ntfs">
		<tr data-bind="click: $root.goToStory">
			<td data-bind="text: sender_id"></td>
			<td data-bind="text: action"></td>
			<td data-bind="text: target"></td>
		</tr>
	</table>
</div>