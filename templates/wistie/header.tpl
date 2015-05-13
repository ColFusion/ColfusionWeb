<!-- Edited by Haoyu Wang to add a tag in the nav bar-->

<!-- START HEADER.TPL -->
<div id="header">

<!-- TOP MENU -->
<div id="login">

        {if $user_authenticated eq true} 
        <div>
            <ul>
            <li>{#PLIGG_Visual_Welcome_Back#} <a href="{$URL_userNoVar}">{$user_logged_in}</a></li>
            {if isset($isgod) && $isgod eq 1}<li><a class="topmenu" href="{$URL_admin}">{#PLIGG_Visual_Header_AdminPanel#}</a></li>{/if}
            <li><a class="topmenu" href="{$URL_logout}"><img src="{$my_pligg_base}/templates/{$the_template}/images/logout.png"/> {#PLIGG_Visual_Logout#}</a></li>
            </ul>
        </div>
        {/if}
	
        {if $user_authenticated neq true}
        <div>
            <ul>
            <li><a class="topmenu" href='{$URL_register}'>{#PLIGG_Visual_Register#}</a></li>
            <li><a class="topmenu" href='{$URL_login}'><img src="{$my_pligg_base}/templates/{$the_template}/images/login.png"/>{#PLIGG_Visual_Login_Title#}</a></li>
            </ul>
        </div>
        {/if}
        
	{checkActionsTpl location="tpl_pligg_login_link"}
</div>
<!-- END TOP MENU -->

<!-- BANNER -->
<div id="banner">
    <a id="webname" href="{$my_base_url}{$my_pligg_base}">{#PLIGG_Visual_Name#} </a>

    <script type="text/javascript">
        {if !isset($searchboxtext)}
            {assign var=searchboxtext value=#PLIGG_Visual_Search_SearchDefaultText#}			
        {/if}
            var some_search='{$searchboxtext}';
    </script>

    <!-- START SEARCH -->
    <div id="searchbox">
   
      
        <form action="{$my_pligg_base}/search.php" method="get" name="thisform-search" id="thisform-search" {if $urlmethod==2}onsubmit='document.location.href="{$my_base_url}{$my_pligg_base}/search/"+this.search.value.replace(/\//g,"|").replace(/\?/g,"%3F"); return false;'{/if}>

           
            <input type="text" size="25" class="searchfield" name="search" id="searchsite" value="{$searchboxtext}" onfocus="if(this.value == some_search) {ldelim}this.value = '';{rdelim}" onblur="if (this.value == '') {ldelim}this.value = some_search;{rdelim}"/>
             
            <input type="submit" value="{#PLIGG_Visual_Search_Go#}" class="searchbutton" style="width:30px;"/>
        </form>

           <div id="ajax_response" style=" font-size: 15px;font-style: verdana; "></div>


       
        <div id="advsearch">
            <a href="{$my_base_url}{$my_pligg_base}/advancedsearch/advanced.php"><img src="{$my_pligg_base}/templates/{$the_template}/images/searchimg.png"/>Advanced Search</a>
        </div>


    </div>
    
    <div class="clear"></div>
    <!-- END SEARCH -->

</div>


<!-- START NAVBAR -->
<div id="nav">
    <div id="padding">

        {checkActionsTpl location="tpl_pligg_navbar_start"}
        <ul>
            <li id="firstblock" {if $pagename eq "home"}class="current"{/if}><a href="{$my_base_url}{$my_pligg_base}">Home</a></li>
            <li  {if $pagename eq "upcoming"}class="current"{/if}><a href="{$URL_upcoming}">{#PLIGG_Visual_Published_News#}</a></li>

            <li {if $pagename eq "submit"}class="current"{/if}><a href="{$my_base_url}{$my_pligg_base}/submit1.php">{#PLIGG_Visual_Submit_A_New_Story#}</a></li>

	        <li ><a href="{$my_base_url}{$my_pligg_base}/phpBB3" target="_blank">Forum</a></li>
	        <li ><a href="{$my_base_url}{$my_pligg_base}/wiki/index.php/Welcome_to_Col*Fusion_Help" target="_blank">Help Wiki</a></li>
            <li ><a href="{$my_base_url}{$my_pligg_base}/advancedSearch/relationships.php" targer="_blank">Relationship Graph</a></li>

            {if $user_authenticated eq true}
             <li {if $pagename eq "user"}class="current"{/if}><a href="{$URL_userNoVar}">{#PLIGG_Visual_Profile#}</a></li>
            {/if}
        </ul>
    
    {checkActionsTpl location="tpl_pligg_navbar_end"}
    </div>
<!-- END NAVBAR -->
</div>
<!-- END HEADER.TPL -->
