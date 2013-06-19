<?php /* Smarty version Smarty-3.1.13, created on 2013-06-10 14:04:11
         compiled from "C:\wamp\www\Colfusion\OriginalSmarty\templates\attachmentList.tpl" */ ?>
<?php /*%%SmartyHeaderCode:2555551864f000b6e25-52867561%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    '6461e525e448c244815d0d8ae19355e68bf292e9' => 
    array (
      0 => 'C:\\wamp\\www\\Colfusion\\OriginalSmarty\\templates\\attachmentList.tpl',
      1 => 1370872935,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '2555551864f000b6e25-52867561',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.13',
  'unifunc' => 'content_51864f00213668_96342864',
  'variables' => 
  array (
    'attachmentInfos' => 0,
    'appRootPath' => 0,
    'attachmentInfo' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_51864f00213668_96342864')) {function content_51864f00213668_96342864($_smarty_tpl) {?><?php  $_smarty_tpl->tpl_vars['attachmentInfo'] = new Smarty_Variable; $_smarty_tpl->tpl_vars['attachmentInfo']->_loop = false;
 $_from = $_smarty_tpl->tpl_vars['attachmentInfos']->value; if (!is_array($_from) && !is_object($_from)) { settype($_from, 'array');}
foreach ($_from as $_smarty_tpl->tpl_vars['attachmentInfo']->key => $_smarty_tpl->tpl_vars['attachmentInfo']->value){
$_smarty_tpl->tpl_vars['attachmentInfo']->_loop = true;
?> 
    <li class="fileListItem">
        <span class="fileIcon"><img src="<?php echo $_smarty_tpl->tpl_vars['appRootPath']->value;?>
<?php echo $_smarty_tpl->tpl_vars['attachmentInfo']->value->icon_url;?>
"/></span>
        <span class="fileInfo"><a href="<?php echo $_smarty_tpl->tpl_vars['appRootPath']->value;?>
/fileManagers/downloadSourceAttachment.php?fileId=<?php echo $_smarty_tpl->tpl_vars['attachmentInfo']->value->FileId;?>
"><?php echo $_smarty_tpl->tpl_vars['attachmentInfo']->value->Title;?>
</a></span>
        <?php if (strlen($_smarty_tpl->tpl_vars['attachmentInfo']->value->Description)>0){?>
            <span class="attachmentDescription"><?php echo $_smarty_tpl->tpl_vars['attachmentInfo']->value->Description;?>
</span>
        <?php }?>
        <span class="deleteFileBtnWrapper">
            <i class="deleteFileBtn icon-remove" title="remove this file" onclick="fileManager.deleteFile(this, '<?php echo $_smarty_tpl->tpl_vars['attachmentInfo']->value->Title;?>
', '<?php echo $_smarty_tpl->tpl_vars['appRootPath']->value;?>
/fileManagers/deleteSourceAttachment.php?fileId=<?php echo $_smarty_tpl->tpl_vars['attachmentInfo']->value->FileId;?>
')"></i>
        </span>
    </li>
<?php } ?><?php }} ?>