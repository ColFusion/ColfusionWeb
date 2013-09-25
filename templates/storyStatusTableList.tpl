{literal}
<div data-bind="visible: isStatusShown" class="storyStatusTableListWrapper">
    <div class="storyStatusTableListHeader">
        <span class="statusHeader statusHeader-tableName">Table Name</span>
        <span class="statusHeader statusHeader-records">Record Processed</span>
        <span class="statusHeader statusHeader-status">Status</span>
        <span class="statusHeader statusHeader-timeStart">Time Start</span>
        <span class="statusHeader statusHeader-timeEnd">Time Elapse/Time End</span>
    </div>
    <ul data-bind="foreach: datasetStatus" class="storyStatusTableList" style="margin: 0;">
        <li data-bind="with: $data.statusObj" class="storyStatus">
            <span data-bind="text: tableName" class="statusTableName statusCol"></span>
            <span class="statusRecordsProcessed statusCol">
                <span data-bind="text: numberProcessRecords"></span>
            </span>
            <span data-bind="style: { 'color': $root.getStatusTextColor(status) }" class="statusStatus statusCol">
                <span style="padding-right: 3px;">
                    <i data-bind="attr: { 'class': $root.getStatusIcon(status) }"></i>
                </span>
                <span data-bind="visible: status != 'error', text: status"></span>
                <span data-bind="visible: ErrorMessage, text: ErrorMessage"
                      class="statusErrorMessage statusCol"
                      style="float: right;"></span>
            </span>
            <span data-bind="text: TimeStart" class="statusTimeStart statusCol"></span>
            <span data-bind="visible: $parent.isNeedRefreshing(), text: $parent.timeElapse" class="statusTimeEnd statusCol"></span>
            <span data-bind="visible: !$parent.isNeedRefreshing(), text: TimeEnd" class="statusTimeEnd statusCol"></span>
        </li>
    </ul>
</div>
{/literal}
