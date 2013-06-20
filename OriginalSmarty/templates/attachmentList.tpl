{foreach from=$attachmentInfos item=attachmentInfo} 
    <li class="fileListItem">
        <span class="fileIcon"><img src="{$appRootPath}/{$attachmentInfo->icon_url}"/></span>
        <span class="fileInfo"><a href="{$appRootPath}/fileManagers/downloadSourceAttachment.php?fileId={$attachmentInfo->FileId}">{$attachmentInfo->Title}</a></span>
        {if strlen($attachmentInfo->Description) > 0}
            <span class="attachmentDescription">{$attachmentInfo->Description}</span>
        {/if}
        <span class="deleteFileBtnWrapper">
            <i class="deleteFileBtn icon-remove" title="remove this file" onclick="fileManager.deleteFile(this, '{$attachmentInfo->Title}', '{$appRootPath}/fileManagers/deleteSourceAttachment.php?fileId={$attachmentInfo->FileId}')"></i>
        </span>
    </li>
{/foreach}