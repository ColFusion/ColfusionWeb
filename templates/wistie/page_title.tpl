<!-- START BREADCRUMBS -->
    {if $pagename eq "submit_groups"}<h3>{#PLIGG_Visual_Submit_A_New_Group#}</h3>{/if}
    {if $pagename eq "groups"}<h3>{#PLIGG_Visual_Groups#}</h3>{/if}
    {if $pagename eq "group_story" }<h3>{$group_name}</h3>{/if}
    {if $pagename eq "login"}<h3>{#PLIGG_Visual_Login#}</h3>{/if}
    {if $pagename eq "register"}<h3>{#PLIGG_Visual_Register#}</h3>{/if}
    {if $pagename eq "editlink"}<h3>{#PLIGG_Visual_EditStory_Header#}: {$submit_url_title}</h3>{/if}
    {if $pagename eq "rssfeeds"}<h3>{#PLIGG_Visual_RSS_Feeds#}</h3>{/if}
    {if $pagename eq "topusers"}<h3>{#PLIGG_Visual_TopUsers_Statistics#}</h3>{/if}
    {if $pagename eq "cloud"}<h3>{#PLIGG_Visual_Tags_Tags#}</h3>{/if}
    {if $pagename eq "live" || $pagename eq "live_unpublished" || $pagename eq "live_published" || $pagename eq "live_comments"}<h3>{#PLIGG_Visual_Live#}</h3>{/if}
    {if $pagename eq "advancedsearch"}<h3>{#PLIGG_Visual_Search_Advanced#}</h3>{/if}
    {if $pagename eq "profile"}<h3>{#PLIGG_Visual_Profile_ModifyProfile#}</h3>{/if}
    {if $pagename eq "user"}<h3><a href="{$user_url_personal_data}"><span style="text-transform:capitalize">{$page_header}</span></a> <a href="{$user_rss, $view_href}" target="_blank"><img src="{$my_pligg_base}/templates/{$the_template}/images/rss.gif" style="margin-left:6px;border:0;"></a></h3>{/if}

    {if $pagename eq "published" || $pagename eq "index"}<h3>{#PLIGG_Visual_Published_News#}{/if}
    {if $pagename eq "upcoming"}<h3>{#PLIGG_Visual_Pligg_Queued#}{/if}
    {if $pagename eq "noresults"}<h3>{$posttitle}
    {elseif isset($get.search)}<h3>{#PLIGG_Visual_Search_SearchResults#}
        {if $get.search}{$get.search}{else}{$get.date}{/if}
    {/if}
    {if isset($get.q)}<h3>{#PLIGG_Visual_Search_SearchResults#} {$get.q}{/if} 
    {if $pagename eq "index" || $pagename eq "published" || $pagename eq "upcoming" || isset($get.search) || isset($get.q)}
        {if isset($navbar_where.link2) && $navbar_where.link2 neq ""} &#187; <a href="{$navbar_where.link2}">{$navbar_where.text2}</a>{elseif isset($navbar_where.text2) && $navbar_where.text2 neq ""} &#187; {$navbar_where.text2}{/if}
        {if isset($navbar_where.link3) && $navbar_where.link3 neq ""} &#187; <a href="{$navbar_where.link3}">{$navbar_where.text3}</a>{elseif isset($navbar_where.text3) && $navbar_where.text3 neq ""} &#187; {$navbar_where.text3}{/if}
        {if isset($navbar_where.link4) && $navbar_where.link4 neq ""} &#187; <a href="{$navbar_where.link4}">{$navbar_where.text4}</a>{elseif isset($navbar_where.text4) && $navbar_where.text4 neq ""} &#187; {$navbar_where.text4}{/if}
        </h3>
    {/if}
    {if $posttitle neq "" && $pagename eq "page"}<h3>{$posttitle}</h3>{/if}
<!-- END BREADCRUMBS -->

{checkActionsTpl location="tpl_pligg_breadcrumb_end"}