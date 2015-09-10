CREATE DATABASE  IF NOT EXISTS `colfusion` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `colfusion`;

SET FOREIGN_KEY_CHECKS=0;

--
-- Table structure for table `colfusion_additional_categories`
--

DROP TABLE IF EXISTS `colfusion_additional_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_additional_categories` (
  `ac_link_id` int(11) NOT NULL,
  `ac_cat_id` int(11) NOT NULL,
  PRIMARY KEY (`ac_link_id`,`ac_cat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_cached_queries_info`
--

DROP TABLE IF EXISTS `colfusion_cached_queries_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_cached_queries_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `query` longtext NOT NULL,
  `server_address` longtext NOT NULL,
  `port` varchar(45) NOT NULL,
  `driver` varchar(45) NOT NULL,
  `user_name` varchar(245) NOT NULL,
  `password` longtext NOT NULL,
  `database` longtext NOT NULL,
  `tableName` longtext NOT NULL,
  `expiration_date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_canvases`
--

DROP TABLE IF EXISTS `colfusion_canvases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_canvases` (
  `vid` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `note` longtext,
  `mdate` datetime NOT NULL,
  `cdate` datetime NOT NULL,
  `privilege` int(11) DEFAULT NULL,
  PRIMARY KEY (`vid`),
  KEY `FK_rrd90u4au11k7m0y7ys7wasw1` (`user_id`),
  CONSTRAINT `FK_rrd90u4au11k7m0y7ys7wasw1` FOREIGN KEY (`user_id`) REFERENCES `colfusion_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_categories`
--

DROP TABLE IF EXISTS `colfusion_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_categories` (
  `category__auto_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_lang` varchar(2) DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `category_parent` int(11) NOT NULL,
  `category_name` varchar(64) DEFAULT NULL,
  `category_safe_name` varchar(64) DEFAULT NULL,
  `rgt` int(11) NOT NULL,
  `lft` int(11) NOT NULL,
  `category_enabled` int(11) NOT NULL,
  `category_order` int(11) NOT NULL,
  `category_desc` varchar(255) DEFAULT NULL,
  `category_keywords` varchar(255) DEFAULT NULL,
  `category_author_level` varchar(7) NOT NULL,
  `category_author_group` varchar(255) DEFAULT NULL,
  `category_votes` varchar(4) NOT NULL,
  `category_karma` varchar(4) NOT NULL,
  PRIMARY KEY (`category__auto_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

INSERT INTO `colfusion_categories` (`category_lang`, `category_id`, `category_parent`, `category_name`, `category_safe_name`, `rgt`, `lft`, `category_enabled`, `category_order`, `category_desc`, `category_keywords`, `category_author_level`, `category_author_group`, `category_votes`, `category_karma`) VALUES
('en', 0, 0, 'all', 'all', 7, 0, 2, 0, '', '', 'normal', '', '', ''),
('en', 1, 0, 'News', 'News', 4, 3, 1, 1, '', '', 'normal', '', '', ''),
('en', 2, 0, 'Business', 'Business', 6, 5, 1, 2, '', '', 'normal', '', '', ''),
('en', 3, 0, 'History', 'History', 2, 1, 1, 0, '', '', 'normal', '', '', '');

--
-- Table structure for table `colfusion_charts`
--

DROP TABLE IF EXISTS `colfusion_charts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_charts` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `vid` int(11) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `left` int(11) DEFAULT NULL,
  `top` int(11) DEFAULT NULL,
  `depth` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `datainfo` longtext,
  `note` longtext,
  PRIMARY KEY (`cid`),
  KEY `FK_lym1jififkghqs6a4q15gwq5p` (`vid`),
  CONSTRAINT `FK_lym1jififkghqs6a4q15gwq5p` FOREIGN KEY (`vid`) REFERENCES `colfusion_canvases` (`vid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_columnTableInfo`
--

DROP TABLE IF EXISTS `colfusion_columnTableInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_columnTableInfo` (
  `cid` int(11) NOT NULL,
  `tableName` varchar(255) NOT NULL COMMENT 'tables from the source database to which this column belongs',
  `dbTableName` varchar(255) NOT NULL COMMENT 'The name of the database table where the data is stored in colfusion data databases. THIS WHOLE TABLE IS THE WORST DESGIN EVERY. NEED TO FIX IT. DUPLICATIONS.',
  PRIMARY KEY (`cid`),
  CONSTRAINT `FK_fvy2f733w7jrq4drk1445o4nd` FOREIGN KEY (`cid`) REFERENCES `colfusion_dnameinfo` (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_comments`
--

DROP TABLE IF EXISTS `colfusion_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_comments` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `comment_randkey` int(11) NOT NULL,
  `comment_parent` int(11) DEFAULT NULL,
  `comment_link_id` int(11) NOT NULL,
  `comment_user_id` int(11) NOT NULL,
  `comment_date` datetime NOT NULL,
  `comment_karma` smallint(6) NOT NULL,
  `comment_content` longtext,
  `comment_votes` int(11) NOT NULL,
  `comment_status` varchar(9) NOT NULL,
  PRIMARY KEY (`comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_config`
--

DROP TABLE IF EXISTS `colfusion_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_config` (
  `var_id` int(11) NOT NULL AUTO_INCREMENT,
  `var_page` varchar(50) DEFAULT NULL,
  `var_name` varchar(100) DEFAULT NULL,
  `var_value` varchar(255) DEFAULT NULL,
  `var_defaultvalue` varchar(50) DEFAULT NULL,
  `var_optiontext` varchar(200) DEFAULT NULL,
  `var_title` varchar(200) DEFAULT NULL,
  `var_desc` longtext,
  `var_method` varchar(10) DEFAULT NULL,
  `var_enclosein` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`var_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_config`
--

INSERT INTO `colfusion_config` (`var_id`, `var_page`, `var_name`, `var_value`, `var_defaultvalue`, `var_optiontext`, `var_title`, `var_desc`, `var_method`, `var_enclosein`) VALUES
(1, 'SEO', '$URLMethod', '1', '1', '1 or 2', 'URL method', 'Search engine friendly URLs<br><b>1</b> = Non-SEO Links. Example: /story.php?title=Example-Title<br><b>2</b> SEO Method. Example: /category/example-title/ method.<br /><strong>Note:</strong> You must rename htaccess.default to .htaccess AND add code found at the bottom of the Admin > Manage > Categories page to the .htaccess file', 'normal', NULL),
(2, 'SEO', 'enable_friendly_urls', 'true', 'true', 'true / false', 'Friendly URL''s for stories', 'Use the story title in the url by setting this value to true. Example: /story/(story title)/<br />Keep this setting as TRUE if using URL Method 1', 'define', NULL),
(4, 'Voting', 'votes_to_publish', '5', '5', 'number', 'Votes to publish', 'Number of votes before story is sent to the front page.', 'define', NULL),
(5, 'Voting', 'days_to_publish', '1000000000000000000000', '10', 'number', 'Days to publish', 'After this many days posts will not be eligible to move from upcoming to published pages', 'define', NULL),
(6, 'Misc', '$trackbackURL', 'colfusion.exp.sis.pitt.edu/colfusionDev', 'pligg.com', 'pligg.com', 'Trackback URL', 'The url to be used in <a href="http://en.wikipedia.org/wiki/Trackback">trackbacks</a>.', 'normal', '"'),
(7, 'Location Installed', '$my_base_url', 'http://colfusion.exp.sis.pitt.edu', 'http://localhost', 'http://(your site name)(no trailing /)', 'Base URL', '<br>\r\n<b>Examples</b>\r\n<br>\r\nhttp://demo.pligg.com<br>\r\nhttp://localhost<br>\r\nhttp://www.pligg.com', 'normal', ''''),
(8, 'Location Installed', '$my_pligg_base', '/colfusion', '', '/(folder name)', 'Pligg Base Folder', '<br>\r\n<b>Examples</b>\r\n<br>\r\n/pligg -- if installed in the /pligg subfolder<br>\r\nLeave blank if installed in the site root folder.', 'normal', ''''),
(9, 'Tags', 'Enable_Tags', 'true', 'true', 'true / false', 'Enable Tags', 'Enable the use of tags and the tag cloud.', 'define', NULL),
(10, 'Tags', '$tags_min_pts', '8', '8', 'number (should be at least 8)', 'Tag Minimum Font Size', '<b>Only used if Tags are enabled.</b> How small should the text for the smallest tags be.', 'normal', NULL),
(11, 'Tags', '$tags_max_pts', '36', '36', 'number', 'Tags Maximum Font Size', '<b>Only used if Tags are enabled.</b> How large should the text for the largest tags be.', 'normal', NULL),
(12, 'Tags', '$tags_words_limit', '100', '100', 'number', 'Tag Cloud Word Limit', '<b>Only used if Tags are enabled.</b> The most tags to show in the cloud.', 'normal', NULL),
(13, 'AntiSpam', 'CHECK_SPAM', 'false', 'false', 'true / false', 'Enable spam checking', 'Checks submitted domains to see if they''re on a blacklist.', 'define', NULL),
(14, 'AntiSpam', '$MAIN_SPAM_RULESET', 'antispam.txt', 'antispam.txt', 'text file', 'Main Spam Ruleset', 'What file should be used to check for spam domains?', 'normal', '"'),
(15, 'AntiSpam', '$USER_SPAM_RULESET', 'local-antispam.txt', 'local-antispam.txt', 'text file', 'Local Spam Ruleset', 'What file should Pligg write to if you mark items as spam?', 'normal', '"'),
(16, 'AntiSpam', '$SPAM_LOG_BOOK', 'spamlog.log', 'spamlog.log', 'text file', 'Spam Log', 'File to log spam blocks to.', 'normal', '"'),
(17, 'Live', 'Enable_Live', 'true', 'true', 'true / false', 'Enable Live', 'Enable the live page.', 'define', NULL),
(18, 'Live', 'items_to_show', '20', '20', 'number', 'Live Items to Show', 'Number of items to show on the live page.', 'define', NULL),
(19, 'Live', 'how_often_refresh', '20', '20', 'number', 'How often to refresh', 'How many seconds between refreshes - not recommended to set it less than 5.', 'define', NULL),
(20, 'Submit', 'Story_Content_Tags_To_Allow_Normal', '', '', 'HTML tags', 'HTML tags to allow to Normal users', 'leave blank to not allow tags. Examples are "&lt;strong&gt;&lt;br&gt;&lt;font&gt;&lt;img&gt;&lt;p&gt;"', 'define', '"'),
(21, 'Submit', 'Submit_Require_A_URL', 'true', 'true', 'true / false', 'Require a URL when Submitting', 'Require a URL when submitting.', 'define', NULL),
(22, 'Submit', 'Submit_Show_URL_Input', 'true', 'true', 'true / false', 'Show the URL Input Box', 'Show the URL input box in submit step 1.', 'define', NULL),
(23, 'Submit', 'No_URL_Name', 'Editorial', 'Editorial', 'text', 'No URL text', 'Label to show when there is no URL provided in submit step 1.', 'define', ''''),
(27, 'Avatars', 'Default_Gravatar_Large', '/avatars/Gravatar_30.gif', '/avatars/Gravatar_30.gif', 'Path to image', 'Default  avatar (large)', 'Default location of large gravatar.', 'define', ''''),
(28, 'Avatars', 'Default_Gravatar_Small', '/avatars/Gravatar_15.gif', '/avatars/Gravatar_15.gif', 'Path to image', 'Default avatar (small)', 'Default location of small gravatar.', 'define', ''''),
(29, 'Misc', 'Enable_Extra_Fields', 'false', 'false', 'true / false', 'Enable extra fields', 'Enable extra fields when submittng stories?', 'define', NULL),
(30, 'Comments', 'Enable_Comment_Voting', 'true', 'true', 'true / false', 'Comment Voting', 'Allow users to vote on comments?', 'define', NULL),
(31, 'Comments', '$CommentOrder', '4', '4', '1 - 4', 'Comment Sort Order', '<br><b>1</b> = Top rated comments first, newest on top\r\n<br><b>2</b> = Newest comments first	\r\n<br><b>3</b> = Top rated comments first, oldest on top\r\n<br><b>4</b> = Oldest comments first', 'normal', NULL),
(33, 'Misc', 'Allow_Friends', 'true', 'true', 'true / false', 'Allow friends', 'Allow adding, removing, and viewing friends.', 'define', NULL),
(34, 'Voting', 'Voting_Method', '2', '1', '1-3', 'Voting method', '<b>1</b> = the digg method. <b>2</b> = 5 star rating method. <b>3</b> = Karma method', 'define', NULL),
(36, 'Tell-a-Friend', 'Enable_Recommend', 'true', 'true', 'true / false', 'Enable tell-a-friend', 'Enable or disable the tell-a-friend link for each story.', 'define', NULL),
(37, 'Tell-a-Friend', 'Email_Subject', 'Colfusion data: ', 'Pligg.com story: ', 'text', 'Email Subject Prefix', 'The prefix added to the email title. The story title will be added to the subject of the email.', 'define', '"'),
(38, 'Tell-a-Friend', 'Default_Message', 'I thought you might like to see this.', 'I thought you might like to see this.', 'text', 'Default message', 'Message sent along with story description in email.', 'define', '"'),
(39, 'Tell-a-Friend', 'Included_Text_Part1', 'Colfusion user ', 'Pligg.com user ', 'text file', 'Who Sent', 'The text used before displaying the username who sent the article.', 'define', '"'),
(40, 'Tell-a-Friend', 'Included_Text_Part2', ' would like to share this story with you: ', ' would like to share this story with you: ', 'Text', 'Who Sent 2', 'What appears after the user name. <b>Keep a space in the beginning and end.</b>', 'define', '"'),
(41, 'Tell-a-Friend', 'Send_From_Email', 'noreply@colfusion.org', 'noreply@pligg.com', 'email address', 'Sent from email', 'Email address email is sent from.', 'define', '"'),
(43, 'Misc', 'SearchMethod', '3', '3', '1 - 3', 'Search method', '<br><b>1</b> = uses MySQL MATCH for FULLTEXT indexes (or something). <b>Problems are MySQL STOP words and words less than 4 characters. Note: these limitations do not affect clicking on a TAG to search by it.</b>\r\n<br><b>2</b> = uses MySQL LIKE and is much slower, but returns better results. Also supports "*" and "-"\r\n<br><b>3</b> = is a hybrid, using method 1 if possible, but method 2 if needed.', 'define', NULL),
(45, 'Anonymous', 'anonymous_vote', 'false', 'false', 'true / false', 'Anonymous vote', 'Allow anonymous users to vote on articles.', 'define', '"'),
(46, 'Anonymous', '$anon_karma', '1', '1', 'number', 'Anonymous Karma', 'Karma is an experimental feature that measures user activity and reputation.', 'normal', NULL),
(47, 'Hidden', 'SALT_LENGTH', '9', '9', 'number', 'SALT_LENGTH', 'SALT_LENGTH', 'define', NULL),
(48, 'Misc', '$dblang', 'en', 'en', 'text', 'Database Language', 'Database language.', 'normal', ''''),
(49, 'Misc', '$page_size', '8', '8', 'number', 'Page Size', 'How many stories to show on a page.', 'normal', NULL),
(50, 'Misc', '$top_users_size', '25', '25', 'number', 'Top Users Size', 'How many users to display in top users.', 'normal', NULL),
(51, 'Template', 'Allow_User_Change_Templates', 'false', 'false', 'true / false', 'Allow User to Change Templates', 'Allow user to change the template. They can do this from the user settings page.', 'define', ''),
(52, 'Template', '$thetemp', 'wistie', 'wistie', 'text', 'Template', 'Default Template', 'normal', ''''),
(53, 'OutGoing', 'track_outgoing', 'false', 'false', 'true / false', 'Enable Outgoing Links', 'Out.php is used to track each click to the external story url. Do you want to enable this click tracking?', 'define', ''),
(54, 'OutGoing', 'track_outgoing_method', 'title', 'title', 'url, title or id', 'Outgoing Links Placement', 'What information should the out.php link use?', 'define', ''''),
(55, 'Submit', 'auto_vote', 'true', 'true', 'true / false', 'Auto vote', 'Automatically vote for the story you submitted.', 'define', NULL),
(56, 'Submit', 'Validate_URL', 'true', 'true', 'true / false', 'Validate URL', 'Check to see if the page exists, gets the title from it, and checks if it is a blog that uses trackbacks. This should only be set to false for sites who have hosts that don''t allow fsockopen or for sites that want to link to media (mp3s, videos, etc.)', 'define', NULL),
(57, 'Misc', 'Spell_Checker', '1', '1', '1 = on / 0 = off', 'Spell Check', 'Settings this to 1 will enable a Spellcheck button for stories and comments', 'define', NULL),
(59, 'Submit', 'SubmitSummary_Allow_Edit', '0', '0', '1 = yes / 0 = no', 'Allow Edit of Summary', 'Allow users to edit the summary? Setting to yes will add an additional field to the submit page where users can write a brief description for the front page version of the article. Setting this to no the site will just truncate the full story content.', 'define', NULL),
(60, 'Avatars', 'Enable_User_Upload_Avatar', 'true', 'true', 'true / false', 'Allow User to Uploaded Avatars', 'Should users be able to upload their own avatars?', 'define', NULL),
(61, 'Avatars', 'User_Upload_Avatar_Folder', '/avatars/user_uploaded', '/avatars/user_uploaded', 'path', 'Avatar Storage Directory', 'This is the directory relative to your Pligg install where you want to store avatars.<br />Ex: if you installed in a subfolder named pligg, you only put /avatars/user_uploaded and NOT /pligg/avatarsuser_uploaded.', 'define', '"'),
(62, 'Avatars', 'Avatar_Large', '30', '30', 'number', 'Large Avatar Size', 'Size of the large avatars in pixels (both width and height). Commonly used on the profile page.', 'define', NULL),
(63, 'Avatars', 'Avatar_Small', '15', '15', 'number', 'Small Avatar Size', 'Size of the small avatar in pixels (both width and height). Commonly used in the comments page.', 'define', NULL),
(64, 'Story', 'use_title_as_link', 'false', 'false', 'true / false', 'Use Story Title as External Link', 'Use the story title as link to story''s website.', 'define', NULL),
(65, 'Story', 'open_in_new_window', 'false', 'false', 'true / false', 'Open Story Link in New Window', 'If "Use story title as link" is set to true, setting this to true will open the link in a new window.', 'define', NULL),
(67, 'Misc', 'table_prefix', 'colfusion_', 'pligg_', 'text', 'MySQL Table Prefix', 'Table prefix. Ex: pligg_ makes the users table become pligg_users. Note: changing this will not automatically rename your tables!', 'define', ''''),
(68, 'Voting', 'rating_to_publish', '3', '3', 'number', 'Rating To Publish', 'How many star rating votes will publish a story? For use with Voting Method 2.', 'define', NULL),
(70, 'Misc', 'enable_gzip_files', 'false', 'false', 'true / false', 'Enable Gzip File Compression', 'Should the server check for gzipped javascript files? This is used to decrease the load time for pages.', 'define', NULL),
(71, 'Submit', 'minTitleLength', '3', '10', 'number', 'Minimum Title Length', 'Minimum number of characters for the story title.', 'define', NULL),
(72, 'Submit', 'minStoryLength', '10', '10', 'number', 'Minimum Story Length', 'Minimum number of characters for the story description.', 'define', NULL),
(73, 'Tags', 'tags_min_pts_s', '6', '6', 'number (should be at least 6)', 'Tag minimum points (sidebar)', '<b>Only used if Tags are enabled.</b> How small should the text for the smallest tags in the sidebar cloud?', 'define', NULL),
(74, 'Tags', 'tags_max_pts_s', '15', '15', 'number', 'Tag Maximum Points (sidebar)', '<b>Only used if Tags are enabled.</b> How big should the text for the largest tags be in the sidebar cloud?', 'define', NULL),
(75, 'Tags', 'tags_words_limit_s', '5', '5', 'number', 'Tag Cloud Word Limit (sidebar)', '<b>Only used if Tags are enabled.</b> How many tags to show in the sidebar cloud?', 'define', NULL),
(76, 'Comments', 'comments_length_sidebar', '75', '75', 'number', 'Sidebar Comment Length', 'The maximum number of characters shown for a comment in the sidebar', 'define', NULL),
(77, 'Comments', 'comments_size_sidebar', '5', '5', 'number', 'Sidebar Number of Comments', 'How many comments to show in the Latest Comments sidebar module.', 'define', NULL),
(79, 'Submit', 'Recommend_Time_Limit', '30', '30', 'number', 'Email Time Limit.', 'How many seconds a user must wait before sending another "tell a friend" email.', 'define', NULL),
(81, 'Groups', 'enable_group', 'true', 'true', 'true/false', 'Groups', 'Activate the Group Feature?', 'define', 'NULL'),
(82, 'Groups', 'max_user_groups_allowed', '10', '10', 'number', 'Max Groups User Create', 'Maximum number of groups a user is allowed to create', 'define', 'NULL'),
(83, 'Groups', 'max_groups_to_join', '10', '10', 'number', 'Max Joinable Groups', 'Maxiumum number of groups a user is allowed to join', 'define', 'NULL'),
(84, 'Groups', 'auto_approve_group', 'true', 'true', 'true/false', 'Auto Approve New Groups', 'Should new groups be auto-approved? Set to false if you want to moderate all new groups being created.', 'define', 'NULL'),
(85, 'Groups', 'group_avatar_size_width', '90', '90', 'number', 'Width of Group Avatar', 'Width in pixels for the group avatar', 'define', 'NULL'),
(86, 'Groups', 'group_avatar_size_height', '90', '90', 'number', 'Height of Group Avatar', 'Height in pixels for the group avatar', 'define', 'NULL'),
(87, 'Voting', 'votes_per_ip', '0', '1', 'number', 'Votes Allowed from one IP', 'This feature is turned on by default to prevent users from voting from multiple registered accounts from the same computer network. <b>0</b> = disable feature.', 'define', NULL),
(88, 'Submit', 'limit_time_to_edit', '0', '0', '1 = on / 0 = off', 'Limit time to edit stories', 'This feature allows you to limit the amount of time a user has before they can no longer edit a submitted story.<br /><b>0</b> = Unlimited amount of time to edit<br><b>1</b> = specified amount of time', 'define', NULL),
(89, 'Submit', 'edit_time_limit', '0', '0', 'number', 'Minutes before a user is no longer allowed to edit a story', '<b>0</b> = Disable the users ability to ever edit the story. Requires that you enable Limit Time To Edit Stories (set to 1).', 'define', NULL),
(90, 'Groups', 'group_submit_level', 'normal', 'normal', 'normal,admin,god', 'Group Create User Level', 'Minimum user level to create new groups', 'define', 'NULL'),
(91, 'Submit', 'Story_Content_Tags_To_Allow_Admin', '', '', 'HTML tags', 'HTML tags to allow to Admin users', 'leave blank to not allow tags. Examples are "&lt;strong>&lt;br>&lt;font>&lt;img>&lt;p>"', 'define', '"'),
(92, 'Submit', 'Story_Content_Tags_To_Allow_God', '', '', 'HTML tags', 'HTML tags to allow to God', 'leave blank to not allow tags. Examples are "&lt;strong>&lt;br>&lt;font>&lt;img>&lt;p>"', 'define', '"'),
(93, 'Misc', 'misc_validate', 'false', 'false', 'true / false', 'Validate user email', 'Require users to validate their email address?', 'define', ''),
(94, 'Misc', 'misc_timezone', '0', '0', 'number', 'Timezone offset', 'Should be a number between -12 and 12 for GMT -1200 through GMT +1200 timezone', 'define', ''),
(95, 'Submit', 'maxTitleLength', '120', '120', 'number', 'Maximum Title Length', 'Maximum number of characters for the story title.', 'define', NULL),
(96, 'Submit', 'maxTagsLength', '40', '40', 'number', 'Maximum Tag Line Length', 'Maximum number of characters for the story tags.', 'define', NULL),
(97, 'Submit', 'maxStoryLength', '1000', '1000', 'number', 'Maximum Story Length', 'Maximum number of characters for the story description.', 'define', NULL),
(98, 'Submit', 'maxSummaryLength', '400', '400', 'number', 'Maximum Summary Length', 'Maximum number of characters for the story summary.', 'define', NULL),
(99, 'Comments', 'maxCommentLength', '1200', '1200', 'number', 'Maximum Comment Length', 'Maximum number of characters for the comment.', 'define', NULL),
(100, 'Voting', 'buries_to_spam', '0', '0', 'number', 'Buries to Mark as Spam', 'Number of buries before story is sent to spam state. <b>0</b> = disable feature.', 'define', NULL),
(101, 'Comments', 'comment_buries_spam', '0', '0', 'number', 'Buries to Mark Comment as Spam', 'Number of buries before comment is sent to spam state. <b>0</b> = disable feature.', 'define', NULL),
(102, 'Voting', 'karma_to_publish', '100', '100', 'number', 'Karma to publish', 'Minimum karma value before story is sent to the front page.', 'define', NULL),
(103, 'Submit', 'Submit_Complete_Step2', 'true', 'true', 'true / false', 'Complete submission on Submit Step 2?', 'Skip step 3 (preview) or not', 'define', NULL),
(104, 'Misc', 'Independent_Subcategories', 'false', 'false', 'true / false', 'Show subcategories', 'Top level categories remain independent from subcategory content', 'define', NULL),
(105, 'Submit', 'Multiple_Categories', 'false', 'false', 'true / false', 'Allow multiple categories', 'User may choose more than one category for each story', 'define', NULL),
(106, 'Misc', '$language', 'english', 'english', 'text', 'Site Language', 'Site Language', 'normal', ''''),
(107, 'Misc', 'user_language', '0', '0', '1 = yes / 0 = no', 'Select Language', 'Allow users to change Pligg language', 'normal', '''');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_des_attachments`
--

DROP TABLE IF EXISTS `colfusion_des_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_des_attachments` (
  `FileId` int(11) NOT NULL AUTO_INCREMENT,
  `Sid` int(11) NOT NULL,
  `UserId` int(11) NOT NULL,
  `Title` varchar(255) NOT NULL COMMENT 'Filename shown at webpage.',
  `Filename` varchar(255) NOT NULL COMMENT 'Real filename (to avoid overwriting existing files.)',
  `Description` longtext,
  `Size` int(11) DEFAULT NULL,
  `Upload_time` datetime DEFAULT NULL,
  PRIMARY KEY (`FileId`),
  KEY `FK_5mhqsvq21yu9gh58ugt9y5uo8` (`Sid`),
  KEY `FK_oh83r9dat33w96070dew57c5i` (`UserId`),
  CONSTRAINT `FK_oh83r9dat33w96070dew57c5i` FOREIGN KEY (`UserId`) REFERENCES `colfusion_users` (`user_id`),
  CONSTRAINT `FK_5mhqsvq21yu9gh58ugt9y5uo8` FOREIGN KEY (`Sid`) REFERENCES `colfusion_sourceinfo` (`Sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_dnameinfo`
--

DROP TABLE IF EXISTS `colfusion_dnameinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_dnameinfo` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `sid` int(11) NOT NULL,
  `dname_chosen` varchar(100) NOT NULL,
  `dname_value_type` varchar(20) DEFAULT NULL,
  `dname_value_unit` varchar(40) DEFAULT NULL,
  `dname_value_format` varchar(45) DEFAULT NULL,
  `dname_value_description` varchar(100) DEFAULT NULL,
  `dname_original_name` varchar(200) NOT NULL COMMENT 'This table stores information about each column in any submitted dataset',
  `isConstant` bit(1) NOT NULL COMMENT 'if user is submitting database and on matching chema they provide input value, this flagg will be set',
  `constant_value` varchar(255) DEFAULT NULL COMMENT 'if user is submitting database and on matching chema they provide input value, the value will be stored here',
  `missing_value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`cid`),
  KEY `FK_ry8xyg3e3a0hi225q8k0195q6` (`sid`),
  CONSTRAINT `FK_ry8xyg3e3a0hi225q8k0195q6` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_dnameinfo_metadata_edit_history`
--

DROP TABLE IF EXISTS `colfusion_dnameinfo_metadata_edit_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_dnameinfo_metadata_edit_history` (
  `hid` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) NOT NULL COMMENT 'column id',
  `uid` int(11) NOT NULL COMMENT 'userid who made edit',
  `whenSaved` datetime NOT NULL COMMENT 'when the edit was done',
  `editedAttribute` varchar(14) NOT NULL,
  `reason` longtext,
  `value` longtext NOT NULL,
  PRIMARY KEY (`hid`),
  KEY `FK_tknft8ptxphm2bnwca6g2di6k` (`cid`),
  KEY `FK_6qtapop8o9y3asb5d3ma7ngw4` (`uid`),
  CONSTRAINT `FK_6qtapop8o9y3asb5d3ma7ngw4` FOREIGN KEY (`uid`) REFERENCES `colfusion_users` (`user_id`),
  CONSTRAINT `FK_tknft8ptxphm2bnwca6g2di6k` FOREIGN KEY (`cid`) REFERENCES `colfusion_dnameinfo` (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_executeinfo`
--

DROP TABLE IF EXISTS `colfusion_executeinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_executeinfo` (
  `Eid` int(11) NOT NULL AUTO_INCREMENT,
  `Sid` int(11) NOT NULL,
  `UserId` varchar(30) DEFAULT NULL,
  `TimeStart` datetime DEFAULT NULL,
  `TimeEnd` datetime DEFAULT NULL,
  `ExitStatus` varchar(20) DEFAULT NULL,
  `ErrorMessage` longtext,
  `RecordsProcessed` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `pan_command` longtext,
  `tableName` longtext NOT NULL,
  `log` TEXT DEFAULT NULL,
  PRIMARY KEY (`Eid`),
  KEY `FK_ok0jbkcb90fa4r6jla4akpn9e` (`Sid`),
  CONSTRAINT `FK_ok0jbkcb90fa4r6jla4akpn9e` FOREIGN KEY (`Sid`) REFERENCES `colfusion_sourceinfo` (`Sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_formulas`
--

DROP TABLE IF EXISTS `colfusion_formulas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_formulas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(10) DEFAULT NULL,
  `enabled` bit(1) NOT NULL,
  `title` varchar(50) DEFAULT NULL,
  `formula` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_friends`
--

DROP TABLE IF EXISTS `colfusion_friends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_friends` (
  `friend_id` int(11) NOT NULL AUTO_INCREMENT,
  `friend_from` bigint(20) NOT NULL,
  `friend_to` bigint(20) NOT NULL,
  PRIMARY KEY (`friend_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_group_member`
--

DROP TABLE IF EXISTS `colfusion_group_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_group_member` (
  `member_id` int(11) NOT NULL AUTO_INCREMENT,
  `member_user_id` int(11) NOT NULL,
  `member_group_id` int(11) NOT NULL,
  `member_role` varchar(9) NOT NULL,
  `member_status` varchar(8) NOT NULL,
  PRIMARY KEY (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_group_shared`
--

DROP TABLE IF EXISTS `colfusion_group_shared`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_group_shared` (
  `share_id` int(11) NOT NULL AUTO_INCREMENT,
  `share_link_id` int(11) NOT NULL,
  `share_group_id` int(11) NOT NULL,
  `share_user_id` int(11) NOT NULL,
  PRIMARY KEY (`share_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_groups`
--

DROP TABLE IF EXISTS `colfusion_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_groups` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_creator` int(11) NOT NULL,
  `group_status` varchar(7) NOT NULL,
  `group_members` int(11) NOT NULL,
  `group_date` datetime NOT NULL,
  `group_safename` longtext,
  `group_name` longtext,
  `group_description` longtext,
  `group_privacy` varchar(10) DEFAULT NULL,
  `group_avatar` varchar(255) DEFAULT NULL,
  `group_vote_to_publish` int(11) NOT NULL,
  `group_field1` varchar(255) DEFAULT NULL,
  `group_field2` varchar(255) DEFAULT NULL,
  `group_field3` varchar(255) DEFAULT NULL,
  `group_field4` varchar(255) DEFAULT NULL,
  `group_field5` varchar(255) DEFAULT NULL,
  `group_field6` varchar(255) DEFAULT NULL,
  `group_notify_email` bit(1) NOT NULL,
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_index_location`
--

DROP TABLE IF EXISTS `colfusion_index_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_index_location` (
  `lid` int(11) NOT NULL AUTO_INCREMENT,
  `location_search_key` varchar(255) DEFAULT NULL,
  `cid` int(11) DEFAULT NULL,
  `sid` int(11) DEFAULT NULL,
  PRIMARY KEY (`lid`),
  KEY `FK_5kuymbhhbe0doe96se9msab15` (`cid`),
  CONSTRAINT `FK_5kuymbhhbe0doe96se9msab15` FOREIGN KEY (`cid`) REFERENCES `colfusion_dnameinfo` (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_license`
--

DROP TABLE IF EXISTS `colfusion_license`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_license` (
  `license_ID` int(11) NOT NULL AUTO_INCREMENT,
  `license_Name` varchar(250) NOT NULL,
  `license_Des` longtext,
  `license_URL` longtext,
  PRIMARY KEY (`license_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_license`
--

LOCK TABLES `colfusion_license` WRITE;
/*!40000 ALTER TABLE `colfusion_license` DISABLE KEYS */;
INSERT INTO `colfusion_license` VALUES (1,'Creative Commons Attribution ShareAlike 4.0','Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)','https://creativecommons.org/licenses/by-sa/4.0/'),(2,'Creative Commons Attribution ShareAlike 3.0','Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)','https://creativecommons.org/licenses/by-sa/3.0/'),(3,'Creative Commons Attribution 4.0','Attribution 4.0 International (CC BY 4.0)','https://creativecommons.org/licenses/by/4.0/'),(4,'Creative Commons Attribution 3.0 ','Attribution 3.0 Unported (CC BY 3.0)','https://creativecommons.org/licenses/by/3.0/'),(5,'Creative Commons CC0 Waiver(release all rights, like public domain)','CC0 1.0 Universal (CC0 1.0) Public Domain Dedication','https://creativecommons.org/publicdomain/zero/1.0/');
/*!40000 ALTER TABLE `colfusion_license` ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `colfusion_likes`
--

DROP TABLE IF EXISTS `colfusion_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_likes` (
  `like_update_id` int(11) NOT NULL,
  `like_user_id` int(11) NOT NULL,
  PRIMARY KEY (`like_update_id`,`like_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_links`
--

DROP TABLE IF EXISTS `colfusion_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_links` (
  `link_id` int(11) NOT NULL,
  `link_author` int(11) NOT NULL,
  `link_status` varchar(9) DEFAULT NULL,
  `link_randkey` int(11) NOT NULL,
  `link_votes` int(11) NOT NULL,
  `link_reports` int(11) NOT NULL,
  `link_comments` int(11) NOT NULL,
  `link_karma` decimal(10,2) NOT NULL,
  `link_modified` datetime NOT NULL,
  `link_date` datetime NOT NULL,
  `link_published_date` datetime NOT NULL,
  `link_category` int(11) NOT NULL,
  `link_lang` int(11) NOT NULL,
  `link_url` varchar(200) DEFAULT NULL,
  `link_url_title` longtext,
  `link_title` longtext,
  `link_title_url` varchar(255) DEFAULT NULL,
  `link_content` longtext,
  `link_summary` longtext,
  `link_tags` longtext,
  `link_field1` varchar(255) DEFAULT NULL,
  `link_field2` varchar(255) DEFAULT NULL,
  `link_field3` varchar(255) DEFAULT NULL,
  `link_field4` varchar(255) DEFAULT NULL,
  `link_field5` varchar(255) DEFAULT NULL,
  `link_field6` varchar(255) DEFAULT NULL,
  `link_field7` varchar(255) DEFAULT NULL,
  `link_field8` varchar(255) DEFAULT NULL,
  `link_field9` varchar(255) DEFAULT NULL,
  `link_field10` varchar(255) DEFAULT NULL,
  `link_field11` varchar(255) DEFAULT NULL,
  `link_field12` varchar(255) DEFAULT NULL,
  `link_field13` varchar(255) DEFAULT NULL,
  `link_field14` varchar(255) DEFAULT NULL,
  `link_field15` varchar(255) DEFAULT NULL,
  `link_group_id` int(11) NOT NULL,
  `link_group_status` varchar(9) NOT NULL,
  `link_out` int(11) NOT NULL,
  PRIMARY KEY (`link_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_login_attempts`
--

DROP TABLE IF EXISTS `colfusion_login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_login_attempts` (
  `login_id` int(11) NOT NULL AUTO_INCREMENT,
  `login_username` varchar(100) DEFAULT NULL,
  `login_time` datetime NOT NULL,
  `login_ip` varchar(100) DEFAULT NULL,
  `login_count` int(11) NOT NULL,
  PRIMARY KEY (`login_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_messages`
--

DROP TABLE IF EXISTS `colfusion_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_messages` (
  `idMsg` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `body` longtext,
  `sender` int(11) NOT NULL,
  `receiver` int(11) NOT NULL,
  `senderLevel` int(11) NOT NULL,
  `readed` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`idMsg`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_misc_data`
--

DROP TABLE IF EXISTS `colfusion_misc_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_misc_data` (
  `name` varchar(20) NOT NULL,
  `data` longtext,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_modules`
--

DROP TABLE IF EXISTS `colfusion_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_modules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` float NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `latest_version` float NOT NULL,
  `folder` varchar(50) DEFAULT NULL,
  `enabled` bit(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_notifications`
--

DROP TABLE IF EXISTS `colfusion_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_notifications` (
  `ntf_id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  PRIMARY KEY (`ntf_id`),
  KEY `FK_t1oenxdm5eync7fotfy18461t` (`sender_id`),
  CONSTRAINT `FK_t1oenxdm5eync7fotfy18461t` FOREIGN KEY (`sender_id`) REFERENCES `colfusion_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_notifications_unread`
--

DROP TABLE IF EXISTS `colfusion_notifications_unread`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_notifications_unread` (
  `ntf_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  PRIMARY KEY (`ntf_id`,`receiver_id`),
  CONSTRAINT `FK_puw1y1olw9etquspep1k2fbjk` FOREIGN KEY (`ntf_id`) REFERENCES `colfusion_notifications` (`ntf_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_old_urls`
--

DROP TABLE IF EXISTS `colfusion_old_urls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_old_urls` (
  `old_id` int(11) NOT NULL AUTO_INCREMENT,
  `old_link_id` int(11) NOT NULL,
  `old_title_url` varchar(255) NOT NULL,
  PRIMARY KEY (`old_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_openrefine_history_helper`
--

DROP TABLE IF EXISTS `colfusion_openrefine_history_helper`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_openrefine_history_helper` (
  `sid` int(11) NOT NULL,
  `tableName` varchar(255) NOT NULL,
  `count` int(11) NOT NULL,
  `isSaved` int(11) NOT NULL,
  PRIMARY KEY (`sid`,`tableName`,`count`,`isSaved`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_openrefine_project_map`
--

DROP TABLE IF EXISTS `colfusion_openrefine_project_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_openrefine_project_map` (
  `sid` int(11) NOT NULL,
  `tableName` varchar(255) NOT NULL,
  `projectId` varchar(255) NOT NULL,
  PRIMARY KEY (`sid`,`tableName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_pentaho_log_logging_channels`
--

DROP TABLE IF EXISTS `colfusion_pentaho_log_logging_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_pentaho_log_logging_channels` (
  `ID_BATCH` int(11) DEFAULT NULL,
  `CHANNEL_ID` varchar(255) DEFAULT NULL,
  `LOG_DATE` datetime DEFAULT NULL,
  `LOGGING_OBJECT_TYPE` varchar(255) DEFAULT NULL,
  `OBJECT_NAME` varchar(255) DEFAULT NULL,
  `OBJECT_COPY` varchar(255) DEFAULT NULL,
  `REPOSITORY_DIRECTORY` varchar(255) DEFAULT NULL,
  `FILENAME` varchar(255) DEFAULT NULL,
  `OBJECT_ID` varchar(255) DEFAULT NULL,
  `OBJECT_REVISION` varchar(255) DEFAULT NULL,
  `PARENT_CHANNEL_ID` varchar(255) DEFAULT NULL,
  `ROOT_CHANNEL_ID` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_pentaho_log_performance`
--

DROP TABLE IF EXISTS `colfusion_pentaho_log_performance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_pentaho_log_performance` (
  `ID_BATCH` int(11) DEFAULT NULL,
  `SEQ_NR` int(11) DEFAULT NULL,
  `LOGDATE` datetime DEFAULT NULL,
  `TRANSNAME` varchar(255) DEFAULT NULL,
  `STEPNAME` varchar(255) DEFAULT NULL,
  `STEP_COPY` int(11) DEFAULT NULL,
  `LINES_READ` bigint(20) DEFAULT NULL,
  `LINES_WRITTEN` bigint(20) DEFAULT NULL,
  `LINES_UPDATED` bigint(20) DEFAULT NULL,
  `LINES_INPUT` bigint(20) DEFAULT NULL,
  `LINES_OUTPUT` bigint(20) DEFAULT NULL,
  `LINES_REJECTED` bigint(20) DEFAULT NULL,
  `ERRORS` bigint(20) DEFAULT NULL,
  `INPUT_BUFFER_ROWS` bigint(20) DEFAULT NULL,
  `OUTPUT_BUFFER_ROWS` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_pentaho_log_step`
--

DROP TABLE IF EXISTS `colfusion_pentaho_log_step`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_pentaho_log_step` (
  `ID_BATCH` int(11) DEFAULT NULL,
  `CHANNEL_ID` varchar(255) DEFAULT NULL,
  `LOG_DATE` datetime DEFAULT NULL,
  `TRANSNAME` varchar(255) DEFAULT NULL,
  `STEPNAME` varchar(255) DEFAULT NULL,
  `STEP_COPY` int(11) DEFAULT NULL,
  `LINES_READ` bigint(20) DEFAULT NULL,
  `LINES_WRITTEN` bigint(20) DEFAULT NULL,
  `LINES_UPDATED` bigint(20) DEFAULT NULL,
  `LINES_INPUT` bigint(20) DEFAULT NULL,
  `LINES_OUTPUT` bigint(20) DEFAULT NULL,
  `LINES_REJECTED` bigint(20) DEFAULT NULL,
  `ERRORS` bigint(20) DEFAULT NULL,
  `LOG_FIELD` mediumtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_pentaho_log_transformaion`
--

DROP TABLE IF EXISTS `colfusion_pentaho_log_transformaion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_pentaho_log_transformaion` (
  `ID_BATCH` int(11) DEFAULT NULL,
  `CHANNEL_ID` varchar(255) DEFAULT NULL,
  `TRANSNAME` varchar(255) DEFAULT NULL,
  `STATUS` varchar(15) DEFAULT NULL,
  `LINES_READ` bigint(20) DEFAULT NULL,
  `LINES_WRITTEN` bigint(20) DEFAULT NULL,
  `LINES_UPDATED` bigint(20) DEFAULT NULL,
  `LINES_INPUT` bigint(20) DEFAULT NULL,
  `LINES_OUTPUT` bigint(20) DEFAULT NULL,
  `LINES_REJECTED` bigint(20) DEFAULT NULL,
  `ERRORS` bigint(20) DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `ENDDATE` datetime DEFAULT NULL,
  `LOGDATE` datetime DEFAULT NULL,
  `DEPDATE` datetime DEFAULT NULL,
  `REPLAYDATE` datetime DEFAULT NULL,
  `LOG_FIELD` mediumtext,
  KEY `IDX_colfusion_pentaho_log_transformaion_1` (`ID_BATCH`),
  KEY `IDX_colfusion_pentaho_log_transformaion_2` (`ERRORS`,`STATUS`,`TRANSNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dataverse`@`localhost`*/ /*!50003 TRIGGER `transformation_after_insert` AFTER INSERT ON `colfusion_pentaho_log_transformaion`
 FOR EACH ROW BEGIN
          IF NEW.status like '%end%' THEN
            UPDATE `colfusion_executeinfo`
            SET status = 'success', RecordsProcessed = NEW.LINES_WRITTEN
            WHERE Eid = NEW.TRANSNAME;
        ELSE
            UPDATE `colfusion_executeinfo`
            SET status = NEW.status
            WHERE Eid = NEW.TRANSNAME;
        END IF;
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`dataverse`@`localhost`*/ /*!50003 TRIGGER `transformation_after_update` AFTER UPDATE ON `colfusion_pentaho_log_transformaion`
 FOR EACH ROW BEGIN
        IF NEW.status like '%end%' THEN
            UPDATE `colfusion_executeinfo`
            SET status = 'success', RecordsProcessed = NEW.LINES_WRITTEN
            WHERE Eid = NEW.TRANSNAME;
        ELSE
            UPDATE `colfusion_executeinfo`
            SET status = NEW.status
            WHERE Eid = NEW.TRANSNAME;
        END IF;
    END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `colfusion_processes`
--

DROP TABLE IF EXISTS `colfusion_processes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_processes` (
  `pid` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(7) DEFAULT NULL,
  `processSer` longtext COMMENT 'JSON serialization of the process',
  `processClass` longtext,
  `reasonForStatus` longtext,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_psc_sourceinfo_table`
--

DROP TABLE IF EXISTS `colfusion_psc_sourceinfo_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_psc_sourceinfo_table` (
  `sid` int(11) NOT NULL,
  `tableName` varchar(255) NOT NULL,
  `pid` int(11) DEFAULT NULL,
  `pscDatabaseName` varchar(64) NOT NULL,
  `pscTableName` varchar(64) NOT NULL COMMENT 'THIS COMMENT SHOULD BE ON A TABLE LEVEL The table that maps colfusion sid and table name to the database and table on psd server',
  `pscHost` varchar(255) NOT NULL,
  `pscDatabasePort` int(11) NOT NULL,
  `pscDatabaseUser` varchar(255) NOT NULL,
  `pscDatabasePassword` varchar(255) NOT NULL,
  `pscDatabaseVendor` varchar(255) NOT NULL,
  `whenReplicationStarted` datetime DEFAULT NULL,
  `whenReplicationFinished` datetime DEFAULT NULL,
  PRIMARY KEY (`sid`,`tableName`),
  KEY `FK_k74kljav616dstg1qf6pt5d6i` (`pid`),
  CONSTRAINT `FK_k74kljav616dstg1qf6pt5d6i` FOREIGN KEY (`pid`) REFERENCES `colfusion_processes` (`pid`),
  CONSTRAINT `FK_544gide45tq0p4uajsq5ly39x` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_redirects`
--

DROP TABLE IF EXISTS `colfusion_redirects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_redirects` (
  `redirect_id` int(11) NOT NULL AUTO_INCREMENT,
  `redirect_old` varchar(255) DEFAULT NULL,
  `redirect_new` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`redirect_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_relationships`
--

DROP TABLE IF EXISTS `colfusion_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_relationships` (
  `rel_id` int(11) NOT NULL AUTO_INCREMENT,
  `sid1` int(11) NOT NULL,
  `creator` int(11) NOT NULL,
  `sid2` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` longtext,
  `creation_time` datetime NOT NULL,
  `tableName1` varchar(255) DEFAULT NULL,
  `tableName2` varchar(255) DEFAULT NULL,
  `status` int(11) NOT NULL COMMENT '0->valid, 1->deleted, 2->new, indexes on the columns are not created yet.',
  PRIMARY KEY (`rel_id`),
  KEY `FK_jgq89ds8g9jluu07jwjuv92jk` (`sid1`),
  KEY `FK_p2pwoqg4uc0ccmubaaaldmoqo` (`creator`),
  KEY `FK_1qm11x24s30iv7m83uu7gqs7b` (`sid2`),
  CONSTRAINT `FK_1qm11x24s30iv7m83uu7gqs7b` FOREIGN KEY (`sid2`) REFERENCES `colfusion_sourceinfo` (`Sid`),
  CONSTRAINT `FK_jgq89ds8g9jluu07jwjuv92jk` FOREIGN KEY (`sid1`) REFERENCES `colfusion_sourceinfo` (`Sid`),
  CONSTRAINT `FK_p2pwoqg4uc0ccmubaaaldmoqo` FOREIGN KEY (`creator`) REFERENCES `colfusion_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_relationships_columns`
--

DROP TABLE IF EXISTS `colfusion_relationships_columns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_relationships_columns` (
  `rel_id` int(11) NOT NULL,
  `cl_from` varchar(255) NOT NULL,
  `cl_to` varchar(255) NOT NULL,
  `dataMatchingFromRatio` decimal(4,2) DEFAULT NULL,
  `dataMatchingToRatio` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`rel_id`,`cl_from`,`cl_to`),
  CONSTRAINT `FK_q148qm7xyc1wk0dvcl9x7nsm2` FOREIGN KEY (`rel_id`) REFERENCES `colfusion_relationships` (`rel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_relationships_columns_cachingexecutioninfo`
--

DROP TABLE IF EXISTS `colfusion_relationships_columns_cachingexecutioninfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_relationships_columns_cachingexecutioninfo` (
  `transformation` varchar(255) NOT NULL,
  `status` longtext,
  `timeStart` datetime DEFAULT NULL,
  `timeEnd` datetime DEFAULT NULL,
  `errorMessage` longtext,
  `query` longtext,
  PRIMARY KEY (`transformation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_relationships_columns_dataMathing_ratios`
--

DROP TABLE IF EXISTS `colfusion_relationships_columns_dataMathing_ratios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_relationships_columns_dataMathing_ratios` (
  `cl_from` varchar(255) NOT NULL,
  `cl_to` varchar(255) NOT NULL,
  `similarity_threshold` decimal(4,3) NOT NULL,
  `pid` int(11) NOT NULL,
  `dataMatchingFromRatio` decimal(4,3) DEFAULT NULL,
  `dataMatchingToRatio` decimal(4,3) DEFAULT NULL,
  PRIMARY KEY (`cl_from`,`cl_to`,`similarity_threshold`),
  KEY `FK_outwl9bbsr7rwqf2y4o5ktdvw` (`pid`),
  CONSTRAINT `FK_outwl9bbsr7rwqf2y4o5ktdvw` FOREIGN KEY (`pid`) REFERENCES `colfusion_processes` (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_saved_links`
--

DROP TABLE IF EXISTS `colfusion_saved_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_saved_links` (
  `saved_id` int(11) NOT NULL AUTO_INCREMENT,
  `saved_user_id` int(11) NOT NULL,
  `saved_link_id` int(11) NOT NULL,
  `saved_privacy` varchar(8) NOT NULL,
  PRIMARY KEY (`saved_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_services`
--

DROP TABLE IF EXISTS `colfusion_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_services` (
  `service_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_name` varchar(20) NOT NULL,
  `service_address` varchar(30) NOT NULL,
  `port_number` int(11) NOT NULL,
  `service_dir` varchar(100) NOT NULL,
  `service_command` varchar(100) NOT NULL,
  `service_status` varchar(20) NOT NULL,
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_shares`
--

DROP TABLE IF EXISTS `colfusion_shares`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_shares` (
  `vid` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `privilege` int(11) NOT NULL,
  PRIMARY KEY (`vid`,`user_id`,`privilege`),
  KEY `FK_mvoxkkf0u1q0c16g4r0351tds` (`user_id`),
  CONSTRAINT `FK_le1hbfj3cobun8oicmetgqs0f` FOREIGN KEY (`vid`) REFERENCES `colfusion_canvases` (`vid`),
  CONSTRAINT `FK_mvoxkkf0u1q0c16g4r0351tds` FOREIGN KEY (`user_id`) REFERENCES `colfusion_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_sourceinfo`
--

DROP TABLE IF EXISTS `colfusion_sourceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_sourceinfo` (
  `Sid` int(11) NOT NULL AUTO_INCREMENT,
  `license_ID` int(11) DEFAULT NULL,
  `UserId` int(11) NOT NULL,
  `Title` varchar(40) DEFAULT NULL,
  `Description` TEXT DEFAULT NULL,
  `Path` varchar(200) DEFAULT NULL,
  `EntryDate` datetime NOT NULL,
  `LastUpdated` datetime DEFAULT NULL,
  `Status` varchar(30) DEFAULT NULL,
  `raw_data_path` varchar(100) DEFAULT NULL,
  `source_type` varchar(45) NOT NULL COMMENT 'type of the source: whether it was submitted as file or as database',
  `provenance` longtext,
  PRIMARY KEY (`Sid`),
  KEY `FK_hrcfg5c3u36rphe7yqh391u3h` (`license_ID`),
  KEY `FK_mrbc8gx8a89v6ge8jsx0ld8of` (`UserId`),
  CONSTRAINT `FK_mrbc8gx8a89v6ge8jsx0ld8of` FOREIGN KEY (`UserId`) REFERENCES `colfusion_users` (`user_id`),
  CONSTRAINT `FK_hrcfg5c3u36rphe7yqh391u3h` FOREIGN KEY (`license_ID`) REFERENCES `colfusion_license` (`license_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_sourceinfo_DB`
--

DROP TABLE IF EXISTS `colfusion_sourceinfo_DB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_sourceinfo_DB` (
  `sid` int(11) NOT NULL,
  `server_address` varchar(255) NOT NULL,
  `port` int(11) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `source_database` varchar(255) NOT NULL,
  `driver` varchar(255) NOT NULL,
  `is_local` int(11) DEFAULT NULL COMMENT '1 - means database was created from dump file and is stored on our server, 0 - means that database was submitted as remote database and the data is stored somewhere not on our server',
  `linked_server_name` varchar(255) DEFAULT NULL COMMENT 'Stores linked server name of the database. This value will be different only for remotely submitted databases because we give collusion internal name for them when create a linked server.',
  PRIMARY KEY (`sid`),
  CONSTRAINT `FK_o1xn9y04rc6syxpop1fhk0ebr` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_sourceinfo_metadata_edit_history`
--

DROP TABLE IF EXISTS `colfusion_sourceinfo_metadata_edit_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_sourceinfo_metadata_edit_history` (
  `hid` int(11) NOT NULL AUTO_INCREMENT,
  `sid` int(11) NOT NULL COMMENT 'source info id',
  `uid` int(11) NOT NULL COMMENT 'userid who made edit',
  `whenSaved` datetime NOT NULL COMMENT 'when the edit was done',
  `item` varchar(11) NOT NULL,
  `reason` longtext,
  `itemValue` longtext NOT NULL,
  PRIMARY KEY (`hid`),
  KEY `FK_gsq54ere2j3yyaeoisbw9p508` (`sid`),
  KEY `FK_k5ms6go5yg2ly8gty3q2sxso6` (`uid`),
  CONSTRAINT `FK_k5ms6go5yg2ly8gty3q2sxso6` FOREIGN KEY (`uid`) REFERENCES `colfusion_users` (`user_id`),
  CONSTRAINT `FK_gsq54ere2j3yyaeoisbw9p508` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_sourceinfo_table_ktr`
--

DROP TABLE IF EXISTS `colfusion_sourceinfo_table_ktr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_sourceinfo_table_ktr` (
  `sid` int(11) NOT NULL,
  `tableName` varchar(255) NOT NULL,
  `pathToKTRFile` longtext NOT NULL,
  PRIMARY KEY (`sid`,`tableName`),
  CONSTRAINT `FK_ncgqkrengjpwm2pp9c24ekthj` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_sourceinfo_user`
--

DROP TABLE IF EXISTS `colfusion_sourceinfo_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_sourceinfo_user` (
  `sid` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `rid` int(11) NOT NULL,
  PRIMARY KEY (`sid`,`uid`),
  KEY `FK_kvymtcpvongyfrk5mq44dumrg` (`rid`),
  KEY `FK_n7pcs7ldlq4smu87xlnjalsg7` (`uid`),
  CONSTRAINT `FK_n7pcs7ldlq4smu87xlnjalsg7` FOREIGN KEY (`uid`) REFERENCES `colfusion_users` (`user_id`),
  CONSTRAINT `FK_kvymtcpvongyfrk5mq44dumrg` FOREIGN KEY (`rid`) REFERENCES `colfusion_userroles` (`role_id`),
  CONSTRAINT `FK_t8ec1amh37pv1vxuavws55t6s` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_synonyms_from`
--

DROP TABLE IF EXISTS `colfusion_synonyms_from`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_synonyms_from` (
  `syn_id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `tableName` varchar(255) NOT NULL,
  `transInput` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`syn_id`,`userId`,`sid`,`tableName`,`transInput`,`value`),
  KEY `FK_hwaafrhxx1oxfq5bqvexub87f` (`sid`),
  KEY `FK_anrqb561xlvudlccfcubno765` (`userId`),
  CONSTRAINT `FK_anrqb561xlvudlccfcubno765` FOREIGN KEY (`userId`) REFERENCES `colfusion_users` (`user_id`),
  CONSTRAINT `FK_hwaafrhxx1oxfq5bqvexub87f` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_synonyms_to`
--

DROP TABLE IF EXISTS `colfusion_synonyms_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_synonyms_to` (
  `syn_id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `tableName` varchar(255) NOT NULL,
  `transInput` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  PRIMARY KEY (`syn_id`,`userId`,`sid`,`tableName`,`transInput`,`value`),
  KEY `FK_7dw4w6lncy1u5fp68whu2l583` (`sid`),
  KEY `FK_iy15ri9da0iwp3tvrk7wiox5` (`userId`),
  CONSTRAINT `FK_iy15ri9da0iwp3tvrk7wiox5` FOREIGN KEY (`userId`) REFERENCES `colfusion_users` (`user_id`),
  CONSTRAINT `FK_7dw4w6lncy1u5fp68whu2l583` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_table_change_log`
--

DROP TABLE IF EXISTS `colfusion_table_change_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_table_change_log` (
  `sid` int(11) NOT NULL,
  `tableName` varchar(255) NOT NULL,
  `startChangeTime` datetime NOT NULL,
  `endChangeTime` datetime NOT NULL,
  `operatedUser` varchar(32) NOT NULL,
  PRIMARY KEY (`sid`,`tableName`,`startChangeTime`,`endChangeTime`,`operatedUser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_tag_cache`
--

DROP TABLE IF EXISTS `colfusion_tag_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_tag_cache` (
  `tag_words` varchar(64) NOT NULL,
  `count` int(11) NOT NULL,
  PRIMARY KEY (`tag_words`,`count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_tags`
--

DROP TABLE IF EXISTS `colfusion_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_tags` (
  `tag_link_id` int(11) NOT NULL,
  `tag_lang` varchar(4) NOT NULL,
  `tag_date` datetime NOT NULL,
  `tag_words` varchar(64) NOT NULL,
  PRIMARY KEY (`tag_link_id`,`tag_lang`,`tag_date`,`tag_words`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_target`
--

DROP TABLE IF EXISTS `colfusion_target`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_target` (
  `Tid` int(11) NOT NULL AUTO_INCREMENT,
  `Sid` int(11) NOT NULL,
  `Spd` date DEFAULT NULL,
  `Drd` date DEFAULT NULL,
  `Dname` varchar(80) DEFAULT NULL,
  `Location` varchar(40) DEFAULT NULL,
  `AggrType` varchar(20) DEFAULT NULL,
  `Start` date DEFAULT NULL,
  `End` date DEFAULT NULL,
  `Value` varchar(100) DEFAULT NULL,
  `Eid` int(11) NOT NULL,
  `Country` varchar(50) DEFAULT NULL,
  `CountrySubDiv` varchar(50) DEFAULT NULL,
  `Locality` varchar(50) DEFAULT NULL,
  `rownum` int(11) DEFAULT NULL,
  `columnnum` int(11) DEFAULT NULL,
  PRIMARY KEY (`Tid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_temporary`
--

DROP TABLE IF EXISTS `colfusion_temporary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_temporary` (
  `Tid` int(11) NOT NULL AUTO_INCREMENT,
  `Sid` int(11) NOT NULL,
  `Spd` date DEFAULT NULL,
  `Drd` date DEFAULT NULL,
  `Dname` varchar(80) DEFAULT NULL,
  `Location` varchar(255) DEFAULT NULL,
  `AggrType` varchar(255) DEFAULT NULL,
  `Start` date DEFAULT NULL,
  `End` date DEFAULT NULL,
  `Value` longtext,
  `Eid` int(11) NOT NULL,
  `rownum` int(11) DEFAULT NULL,
  `columnnum` int(11) DEFAULT NULL,
  `cid` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Tid`),
  KEY `FK_2bj6a8na5tiq0a98j6uxw2xr9` (`Sid`),
  CONSTRAINT `FK_2bj6a8na5tiq0a98j6uxw2xr9` FOREIGN KEY (`Sid`) REFERENCES `colfusion_sourceinfo` (`Sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_totals`
--

DROP TABLE IF EXISTS `colfusion_totals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_totals` (
  `name` varchar(10) NOT NULL,
  `total` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_trackbacks`
--

DROP TABLE IF EXISTS `colfusion_trackbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_trackbacks` (
  `trackback_id` int(11) NOT NULL AUTO_INCREMENT,
  `trackback_link_id` int(11) NOT NULL,
  `trackback_user_id` int(11) NOT NULL,
  `trackback_type` varchar(3) DEFAULT NULL,
  `trackback_status` varchar(7) DEFAULT NULL,
  `trackback_modified` datetime NOT NULL,
  `trackback_date` datetime DEFAULT NULL,
  `trackback_url` varchar(200) DEFAULT NULL,
  `trackback_title` longtext,
  `trackback_content` longtext,
  PRIMARY KEY (`trackback_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_updates`
--

DROP TABLE IF EXISTS `colfusion_updates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_updates` (
  `update_id` int(11) NOT NULL AUTO_INCREMENT,
  `update_time` int(11) DEFAULT NULL,
  `update_type` char(1) NOT NULL,
  `update_link_id` int(11) NOT NULL,
  `update_user_id` int(11) NOT NULL,
  `update_group_id` int(11) NOT NULL,
  `update_likes` int(11) NOT NULL,
  `update_level` varchar(25) DEFAULT NULL,
  `update_text` longtext NOT NULL,
  PRIMARY KEY (`update_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_user_relationship_verdict`
--

DROP TABLE IF EXISTS `colfusion_user_relationship_verdict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_user_relationship_verdict` (
  `rel_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `confidence` decimal(3,2) NOT NULL,
  `comment` longtext,
  `when` datetime NOT NULL,
  PRIMARY KEY (`rel_id`,`user_id`),
  KEY `FK_jwjbdowtd69g097tu6kke59ov` (`user_id`),
  CONSTRAINT `FK_hxtbjyt1nlmgc9bp234eqot0m` FOREIGN KEY (`rel_id`) REFERENCES `colfusion_relationships` (`rel_id`),
  CONSTRAINT `FK_jwjbdowtd69g097tu6kke59ov` FOREIGN KEY (`user_id`) REFERENCES `colfusion_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_userroles`
--

DROP TABLE IF EXISTS `colfusion_userroles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_userroles` (
  `role_id` int(11) NOT NULL,
  `role` varchar(45) NOT NULL,
  `description` longtext,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_userroles`
--

INSERT INTO `colfusion_userroles` (`role_id`, `role`, `description`) VALUES
(1, 'owner', 'owner'),
(2, 'collector', 'collector');

--
-- Table structure for table `colfusion_users`
--

DROP TABLE IF EXISTS `colfusion_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_login` varchar(32) DEFAULT NULL,
  `user_level` varchar(7) DEFAULT NULL,
  `user_modification` datetime NOT NULL,
  `user_date` datetime NOT NULL,
  `user_pass` varchar(64) DEFAULT NULL,
  `user_email` varchar(128) DEFAULT NULL,
  `user_names` varchar(128) DEFAULT NULL,
  `user_karma` decimal(10,2) DEFAULT NULL,
  `user_url` varchar(128) DEFAULT NULL,
  `user_lastlogin` datetime NOT NULL,
  `user_aim` varchar(64) DEFAULT NULL,
  `user_msn` varchar(64) DEFAULT NULL,
  `user_yahoo` varchar(64) DEFAULT NULL,
  `user_gtalk` varchar(64) DEFAULT NULL,
  `user_skype` varchar(64) DEFAULT NULL,
  `user_irc` varchar(64) DEFAULT NULL,
  `public_email` varchar(64) DEFAULT NULL,
  `user_avatar_source` varchar(255) DEFAULT NULL,
  `user_ip` varchar(20) DEFAULT NULL,
  `user_lastip` varchar(20) DEFAULT NULL,
  `last_reset_request` datetime NOT NULL,
  `last_email_friend` datetime NOT NULL,
  `last_reset_code` varchar(255) DEFAULT NULL,
  `user_location` varchar(255) DEFAULT NULL,
  `user_occupation` varchar(255) DEFAULT NULL,
  `user_categories` longtext,
  `user_enabled` bit(1) NOT NULL,
  `user_language` varchar(32) DEFAULT NULL,
  `status_switch` bit(1) DEFAULT NULL,
  `status_friends` bit(1) DEFAULT NULL,
  `status_story` bit(1) DEFAULT NULL,
  `status_comment` bit(1) DEFAULT NULL,
  `status_email` bit(1) DEFAULT NULL,
  `status_group` bit(1) DEFAULT NULL,
  `status_all_friends` bit(1) DEFAULT NULL,
  `status_friend_list` longtext,
  `status_excludes` longtext,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UK_25iqgtemiawp5w6njsj9c5efu` (`user_login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_users`
--

LOCK TABLES `colfusion_users` WRITE;
/*!40000 ALTER TABLE `colfusion_users` DISABLE KEYS */;
INSERT INTO `colfusion_users` VALUES (1,'Colfusion_AI','normal','2013-06-24 15:15:20','2013-06-24 15:15:20','19ad8bddc15c95a0f84e4e317b0c617258c9675ab4a782aca','kzheka@hotmail.com',NULL,0.00,NULL,'2013-06-24 15:15:20',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'10.228.65.112','10.228.65.112','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL,NULL,'','',NULL,'','','','','','','',NULL,NULL),(2,'dataverse','normal','2013-09-30 02:04:17','2013-09-25 19:05:26','fb5a0b7950b27484840b4580c26ea654a52abe725effa65fd','dataverse@dataverse.com',NULL,0.00,NULL,'2014-12-22 18:30:57',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'10.228.65.115','::1','2014-12-22 18:16:00','0000-00-00 00:00:00','b70186f40d10c70d1088a620e141dc9ce066f43b9aaa6f73d',NULL,NULL,'','',NULL,'','','','','','','',NULL,NULL);
/*!40000 ALTER TABLE `colfusion_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_validation_code`
--

DROP TABLE IF EXISTS `colfusion_validation_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_validation_code` (
  `email` varchar(100) NOT NULL,
  `vcode` varchar(20) NOT NULL,
  `isUsed` bit(1) NOT NULL,
  PRIMARY KEY (`email`,`vcode`,`isUsed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_visualization`
--

DROP TABLE IF EXISTS `colfusion_visualization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_visualization` (
  `vid` varchar(20) NOT NULL,
  `titleno` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `userid` int(11) NOT NULL,
  `top` int(11) NOT NULL,
  `left` int(11) NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `setting` longtext NOT NULL,
  PRIMARY KEY (`vid`),
  KEY `FK_4ya8fi7501pdiwl7688k39m3o` (`titleno`),
  CONSTRAINT `FK_4ya8fi7501pdiwl7688k39m3o` FOREIGN KEY (`titleno`) REFERENCES `colfusion_sourceinfo` (`Sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_votes`
--

DROP TABLE IF EXISTS `colfusion_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_votes` (
  `vote_id` int(11) NOT NULL AUTO_INCREMENT,
  `vote_type` varchar(8) NOT NULL,
  `vote_date` datetime NOT NULL,
  `vote_link_id` int(11) NOT NULL,
  `vote_user_id` int(11) NOT NULL,
  `vote_value` smallint(6) NOT NULL,
  `vote_karma` int(11) DEFAULT NULL,
  `vote_ip` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`vote_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `colfusion_widgets`
--

DROP TABLE IF EXISTS `colfusion_widgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` float NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `latest_version` float NOT NULL,
  `folder` varchar(50) DEFAULT NULL,
  `enabled` bit(1) NOT NULL,
  `column` varchar(5) NOT NULL,
  `position` int(11) NOT NULL,
  `display` varchar(5) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_c094lydovql5fij4x3ygtu837` (`folder`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `statonverdicts`
--

DROP TABLE IF EXISTS `statonverdicts`;
/*!50001 DROP VIEW IF EXISTS `statonverdicts`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `statonverdicts` (
  `rel_id` tinyint NOT NULL,
  `numberOfVerdicts` tinyint NOT NULL,
  `numberOfApproved` tinyint NOT NULL,
  `numberOfReject` tinyint NOT NULL,
  `numberOfNotSure` tinyint NOT NULL,
  `avgConfidence` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'colfusion'
--

--
-- Dumping routines for database 'colfusion'
--
/*!50003 DROP PROCEDURE IF EXISTS `deleteSource` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteSource`(IN param1 varchar(200))
    READS SQL DATA
BEGIN
    
  delete from colfusion_sourceinfo where sid = param1;
  delete from colfusion_links where link_id = param1;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `doJoin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `doJoin`(IN param1 varchar(200))
    READS SQL DATA
BEGIN

  SET @text := TRIM(BOTH ',' FROM param1);
  SET @strLen := 0;
  SET @i := 1;

  SET @sid := SUBSTRING_INDEX(@text, ',', @i);
    SET @strLen := LENGTH(@sid);
    SET @i := @i + 1;
  set @sid := SUBSTRING_INDEX(@sid, ',', -1);

  SET @joinTableIndex := 0;
  
  SET @sql = CONCAT('drop temporary table if exists resultDoJoin');
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  IF @sid <> "" THEN

      SET @sql = CONCAT('drop temporary table if exists tmpTable', @i);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;

      SET @sql = NULL;

      SELECT
        GROUP_CONCAT(DISTINCT
        CONCAT(
          'MAX(IF(dname = ''',
          TRIM(dname),
          ''', value, NULL)) AS `',
          TRIM(dname),'`'
        )
        ) INTO @sql
      FROM
        colfusion_temporary
      where 
      sid = @sid;
        
      SET @sql = CONCAT('CREATE TEMPORARY TABLE tmpTable', @i, ' SELECT rownum, ', @sql, ' FROM colfusion_temporary where sid = ', @sid,' GROUP BY rownum');

      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;


    WHILE @strLen < LENGTH(@text)  DO
      SET @sid := SUBSTRING_INDEX(@text, ',', @i);
      SET @strLen := LENGTH(@sid);
      SET @i := @i + 1;
      set @sid := SUBSTRING_INDEX(@sid, ',', -1);

        SET @sql = CONCAT('drop temporary table if exists tmpTable', @i);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

          SET @sql = NULL;

          SELECT
            GROUP_CONCAT(DISTINCT
            CONCAT(
              'MAX(IF(dname = ''',
              TRIM(dname),
              ''', value, NULL)) AS `',
              TRIM(dname),'`'
            )
            ) INTO @sql
          FROM
            colfusion_temporary
          where 
          sid = @sid;
      

          SET @sql = CONCAT('CREATE TEMPORARY TABLE tmpTable', @i, ' SELECT rownum, ', @sql, ' FROM colfusion_temporary where sid = ', @sid,' GROUP BY rownum');

          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

        if @joinTableIndex = 0 then
          
          SET @sql = CONCAT('drop temporary table if exists tmpTableJoined', @joinTableIndex);
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET @sql = CONCAT('alter table ', 'tmpTable',@i, ' drop column rownum');
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET @sql = CONCAT('CREATE TEMPORARY TABLE tmpTableJoined', @joinTableIndex, ' SELECT * FROM tmpTable', @i-1,' NATURAL JOIN ', 'tmpTable',@i);

          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET @sql = CONCAT('drop temporary table if exists tmpTable', @i-1);
          
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET @sql = CONCAT('drop temporary table if exists tmpTable', @i);
          
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
        else

          SET @sql = CONCAT('drop temporary table if exists tmpTableJoined', @joinTableIndex);
          
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;
        
          SET @sql = CONCAT('alter table ', 'tmpTable',@i, ' drop column rownum');
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET @sql = CONCAT('CREATE TEMPORARY TABLE tmpTableJoined', @joinTableIndex, ' SELECT * FROM tmpTableJoined', @joinTableIndex-1,' NATURAL JOIN ', 'tmpTable',@i);  

          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET @sql = CONCAT('drop temporary table if exists tmpTableJoined', @joinTableIndex-1);
          
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

          SET @sql = CONCAT('drop temporary table if exists tmpTable', @i);
          
          PREPARE stmt FROM @sql;
          EXECUTE stmt;
          DEALLOCATE PREPARE stmt;

        end if;

        

      SET @joinTableIndex := @joinTableIndex + 1;
    END WHILE;

    IF @joinTableIndex > 0 THEN
    --  SET @sql = CONCAT('select * from tmpTableJoined', @joinTableIndex-1, ' LIMIT ', lim);
    --  PREPARE stmt FROM @sql;
    --  EXECUTE stmt;
    --  DEALLOCATE PREPARE stmt;


      SET @sql = CONCAT('CREATE TEMPORARY TABLE resultDoJoin SELECT * FROM tmpTableJoined', @joinTableIndex-1);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;



      SET @sql = CONCAT('drop temporary table if exists tmpTableJoined', @joinTableIndex - 1);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
    else
    --  SET @sql = CONCAT('select * from tmpTable', @i, ' LIMIT ', lim);
      
    --  PREPARE stmt FROM @sql;
    --  EXECUTE stmt;
    --  DEALLOCATE PREPARE stmt;

      
      SET @sql = CONCAT('CREATE TEMPORARY TABLE resultDoJoin SELECT * FROM tmpTable', @i);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;


      SET @sql = CONCAT('drop temporary table if exists tmpTable', @i);
      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;
    END IF;

  END IF;



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `doJoinWithTime` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `doJoinWithTime`(IN `sidParam` VARCHAR(200), IN `tableNameParam` VARCHAR(200))
    READS SQL DATA
BEGIN

  SET @sid := TRIM(BOTH ',' FROM sidParam);
  SET @tableName := TRIM(BOTH ',' FROM tableNameParam);

  SET @sql = CONCAT('drop temporary table if exists resultDoJoin');
  PREPARE stmt FROM @sql;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;

  IF @sid <> "" THEN
      
      SET @sql = NULL;

      SELECT
        GROUP_CONCAT(DISTINCT
        CONCAT(
          'MAX(IF(dname = ''',
          TRIM(dname),
          ''', value, NULL)) AS `',
          TRIM(dname),'`'
        )
        ) INTO @sql
      FROM
        colfusion_temporary, colfusion_columnTableInfo
      where 
        colfusion_temporary.cid = colfusion_columnTableInfo.cid
        and colfusion_columnTableInfo.tableName = @tableName 
        and sid = @sid;
        
      SET @sql = CONCAT('CREATE TEMPORARY TABLE resultDoJoin SELECT * FROM (SELECT rownum, ', @sql, ' FROM colfusion_temporary, colfusion_columnTableInfo where colfusion_temporary.cid = colfusion_columnTableInfo.cid and colfusion_columnTableInfo.tableName =\'', @tableName, '\' and sid = ', @sid,' GROUP BY rownum) as t1' );

      PREPARE stmt FROM @sql;
      EXECUTE stmt;
      DEALLOCATE PREPARE stmt;

  END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `doRelationshipMining` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `doRelationshipMining`(IN param1 varchar(200))
    READS SQL DATA
BEGIN
  SET @currTime := CURRENT_TIMESTAMP;
  SET @user := 1;

  drop temporary table if exists temporaryRelationshipsTable;

  CREATE TEMPORARY TABLE temporaryRelationshipsTable
  select * 
  from (
      select distinct newDataset.sid as sid1, CONCAT('cid(', newDataset.cid, ')') as cl1, newDataset.tableName as tableName1, 
          theRest.sid as sid2, CONCAT('cid(', theRest.cid, ')') as cl2, theRest.tableName as tableName2, 
          'autogenerated' as name, 'based on complete match in dnames' as description, @user as creator, @currTime as creation_time
      
      from 
        (SELECT sid, colfusion_dnameinfo.cid, tableName, dname_chosen as nd_newDname, dname_original_name as nd_originalDname 
        FROM colfusion_dnameinfo, colfusion_columnTableInfo
        where sid = param1
        and colfusion_dnameinfo.cid = colfusion_columnTableInfo.cid
        and dname_chosen not in ('Spd', 'Drd','Start','End', 'Location', 'Aggrtype')) as newDataset,

        (SELECT colfusion_dnameinfo.sid, colfusion_dnameinfo.cid, tableName, dname_chosen as newDname, dname_original_name as original_name 
        FROM colfusion_dnameinfo, colfusion_columnTableInfo, colfusion_sourceinfo
        where colfusion_dnameinfo.sid <> param1 
        and colfusion_dnameinfo.sid = colfusion_sourceinfo.sid and colfusion_sourceinfo.Status = 'queued'
        and colfusion_dnameinfo.cid = colfusion_columnTableInfo.cid
        and dname_chosen not in ('Spd', 'Drd','Start','End', 'Location', 'Aggrtype')) as theRest

      where (newDataset.nd_newDname = theRest.newDname or newDataset.nd_newDname = theRest.original_name)
         or (newDataset.nd_originalDname = theRest.newDname or newDataset.nd_originalDname = theRest.original_name)
    ) as t
  where not exists (select *
            from colfusion_relationships natural join colfusion_relationships_columns 
            where (t.sid1 = sid1 and t.sid2 = sid2 and t.cl1 = cl_from and t.cl2 = cl_to) or
                (t.sid1 = sid2 and t.sid2 = sid1 and t.cl1 = cl_to and t.cl2 = cl_from)
           )
  ;

  insert ignore into colfusion_relationships(name, description, creator, creation_time, sid1, sid2, tableName1, tableName2, status) 
  select name, description, creator, creation_time, sid1, sid2,tableName1, tableName2, 2 
  from
  (
  select distinct sid1, sid2, tableName1, tableName2, name,  description, creator, creation_time
  from temporaryRelationshipsTable) as t;


  insert ignore into colfusion_relationships_columns(rel_id, cl_from, cl_to) 
  select rel_id, cl1, cl2
  from colfusion_relationships natural join temporaryRelationshipsTable;


  insert ignore into colfusion_user_relationship_verdict 
  select rel_id, creator, 1, 'complete match in dnames', @currTime 
  from colfusion_relationships natural join temporaryRelationshipsTable;

  drop temporary table if exists temporaryRelationshipsTable;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `statonverdicts`
--

/*!50001 DROP TABLE IF EXISTS `statonverdicts`*/;
/*!50001 DROP VIEW IF EXISTS `statonverdicts`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `statonverdicts` AS select `colfusion_user_relationship_verdict`.`rel_id` AS `rel_id`,count(0) AS `numberOfVerdicts`,sum(if((`colfusion_user_relationship_verdict`.`confidence` > 0),1,0)) AS `numberOfApproved`,sum(if((`colfusion_user_relationship_verdict`.`confidence` < 0),1,0)) AS `numberOfReject`,sum(if((`colfusion_user_relationship_verdict`.`confidence` = 0),1,0)) AS `numberOfNotSure`,avg(`colfusion_user_relationship_verdict`.`confidence`) AS `avgConfidence` from `colfusion_user_relationship_verdict` group by `colfusion_user_relationship_verdict`.`rel_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

-- Dump completed on 2015-06-05 14:45:05

SET FOREIGN_KEY_CHECKS=1;
