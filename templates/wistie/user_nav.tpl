<div id="navcontainer">
    <ul id="navlist">
        {checkActionsTpl location="tpl_pligg_profile_sort_start"}
        <li id="person_info" class="navbut{$nav_pd}"><a href="{$user_url_personal_data}"><span>{#PLIGG_Visual_User_PersonalData#}</span></a></li>
        {if $user_login eq $user_logged_in}
            <li class="navbut{$nav_set}"><a href="{$user_url_setting}"><span>{#PLIGG_Visual_User_Setting#}</span></a></li>
        {/if}
        <li class="navbut{$nav_ns}"><a href="{$user_url_news_sent}"><span>{#PLIGG_Visual_User_NewsSent#}</span></a></li>
        <!--li class="navbut{$nav_np}"><a href="{$user_url_news_published}"><span>{#PLIGG_Visual_User_NewsPublished#}</span></a></li-->
        <li class="navbut{$nav_nu}"><a href="{$user_url_news_unpublished}"><span>{#PLIGG_Visual_User_NewsUnPublished#}</span></a></li>
        <li class="navbut{$nav_c}"><a href="{$user_url_commented}"><span>{#PLIGG_Visual_User_NewsCommented#}</span></a></li>
        <li class="navbut{$nav_nv}"><a href="{$user_url_news_voted}"><span>{#PLIGG_Visual_User_NewsVoted#}</span></a></li>
        <li class="navbut{$nav_s}"><a href="{$user_url_saved}"><span>{#PLIGG_Visual_User_NewsSaved#}</span></a></li>
        <li class="navbut{$nav_ntf}"><a href="{$user_url_notification}"><span>{#PLIGG_Visual_User_Notification#}</span></a></li>
        {checkActionsTpl location="tpl_pligg_profile_sort_end"}
    </ul>
</div>