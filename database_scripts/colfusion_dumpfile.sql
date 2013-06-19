CREATE DATABASE  IF NOT EXISTS `colfusion` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `colfusion`;
-- MySQL dump 10.13  Distrib 5.5.31, for debian-linux-gnu (i686)
--
-- Host: localhost    Database: colfusion
-- ------------------------------------------------------
-- Server version	5.5.31-0ubuntu0.12.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `colfusion_additional_categories`
--

DROP TABLE IF EXISTS `colfusion_additional_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_additional_categories` (
  `ac_link_id` int(11) NOT NULL,
  `ac_cat_id` int(11) NOT NULL,
  UNIQUE KEY `ac_link_id` (`ac_link_id`,`ac_cat_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_additional_categories`
--

LOCK TABLES `colfusion_additional_categories` WRITE;
/*!40000 ALTER TABLE `colfusion_additional_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `colfusion_additional_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_categories`
--

DROP TABLE IF EXISTS `colfusion_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_categories` (
  `category__auto_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_lang` varchar(2) COLLATE utf8_unicode_ci DEFAULT 'en',
  `category_id` int(11) NOT NULL DEFAULT '0',
  `category_parent` int(11) NOT NULL DEFAULT '0',
  `category_name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `category_safe_name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rgt` int(11) NOT NULL DEFAULT '0',
  `lft` int(11) NOT NULL DEFAULT '0',
  `category_enabled` int(11) NOT NULL DEFAULT '1',
  `category_order` int(11) NOT NULL DEFAULT '0',
  `category_desc` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `category_keywords` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `category_author_level` enum('normal','admin','god') CHARACTER SET utf8 NOT NULL DEFAULT 'normal',
  `category_author_group` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `category_votes` varchar(4) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `category_karma` varchar(4) CHARACTER SET utf8 NOT NULL DEFAULT '',
  PRIMARY KEY (`category__auto_id`),
  KEY `category_id` (`category_id`),
  KEY `category_parent` (`category_parent`),
  KEY `category_safe_name` (`category_safe_name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_categories`
--

LOCK TABLES `colfusion_categories` WRITE;
/*!40000 ALTER TABLE `colfusion_categories` DISABLE KEYS */;
INSERT INTO `colfusion_categories` VALUES (0,'en',0,0,'all','all',7,0,2,0,'','','normal','','',''),(1,'en',1,0,'News','News',4,3,1,1,'','','normal','','',''),(2,'en',2,0,'Business','Business',6,5,1,2,'','','normal','','',''),(3,'en',3,0,'History','History',2,1,1,0,'','','normal','','','');
/*!40000 ALTER TABLE `colfusion_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_columnTableInfo`
--

DROP TABLE IF EXISTS `colfusion_columnTableInfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_columnTableInfo` (
  `cid` int(11) NOT NULL COMMENT 'referenced column, by this we can also reach source info',
  `tableName` varchar(255) NOT NULL COMMENT 'tables from the source database to which this column belongs',
  PRIMARY KEY (`cid`),
  KEY `fk_colfusion_columnTableInfo_1_idx` (`cid`),
  CONSTRAINT `fk_colfusion_columnTableInfo_1` FOREIGN KEY (`cid`) REFERENCES `colfusion_dnameinfo` (`cid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_columnTableInfo`
--

LOCK TABLES `colfusion_columnTableInfo` WRITE;
/*!40000 ALTER TABLE `colfusion_columnTableInfo` DISABLE KEYS */;
INSERT INTO `colfusion_columnTableInfo` VALUES (592,'Extra-State War Participants (V'),(593,'Extra-State War Participants (V'),(594,'Extra-State War Participants (V'),(595,'Extra-State War Participants (V'),(596,'Extra-State War Participants (V'),(597,'Extra-State War Participants (V'),(598,'Extra-State War Participants (V'),(599,'Extra-State War Participants (V'),(600,'Extra-State War Participants (V'),(601,'Extra-State War Participants (V'),(608,'Sheet1'),(609,'Sheet1'),(616,'Sheet1'),(617,'Sheet1');
/*!40000 ALTER TABLE `colfusion_columnTableInfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_comments`
--

DROP TABLE IF EXISTS `colfusion_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_comments` (
  `comment_id` int(20) NOT NULL AUTO_INCREMENT,
  `comment_randkey` int(11) NOT NULL DEFAULT '0',
  `comment_parent` int(20) DEFAULT '0',
  `comment_link_id` int(20) NOT NULL DEFAULT '0',
  `comment_user_id` int(20) NOT NULL DEFAULT '0',
  `comment_date` datetime NOT NULL,
  `comment_karma` smallint(6) NOT NULL DEFAULT '0',
  `comment_content` text COLLATE utf8_unicode_ci,
  `comment_votes` int(20) NOT NULL DEFAULT '0',
  `comment_status` enum('discard','moderated','published','spam') CHARACTER SET utf8 NOT NULL DEFAULT 'published',
  PRIMARY KEY (`comment_id`),
  UNIQUE KEY `comments_randkey` (`comment_randkey`,`comment_link_id`,`comment_user_id`,`comment_parent`),
  KEY `comment_link_id` (`comment_link_id`,`comment_parent`,`comment_date`),
  KEY `comment_link_id_2` (`comment_link_id`,`comment_date`),
  KEY `comment_date` (`comment_date`),
  KEY `comment_parent` (`comment_parent`,`comment_date`)
) ENGINE=MyISAM AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_comments`
--

LOCK TABLES `colfusion_comments` WRITE;
/*!40000 ALTER TABLE `colfusion_comments` DISABLE KEYS */;
INSERT INTO `colfusion_comments` VALUES (1,61059235,0,15,1,'2012-10-26 17:26:10',0,'123 great',0,'spam'),(12,66195719,0,203,1,'2012-12-02 23:11:16',0,'unbelievable',0,'spam'),(10,58691646,0,203,1,'2012-12-02 23:10:56',0,'this is so cool',0,'spam'),(11,17785057,0,203,1,'2012-12-02 23:11:05',0,'awesome',0,'spam'),(13,22263221,0,203,7,'2012-12-03 03:50:04',0,'this is so cool',0,'published'),(14,17446407,0,203,1,'2012-12-03 03:58:28',0,'ha ha ',0,'published'),(15,65954003,0,207,6,'2012-12-03 05:05:57',0,'Love it!!!',0,'published'),(16,58633619,0,203,6,'2012-12-03 05:06:22',0,'wow',0,'published'),(17,38576521,0,203,6,'2012-12-03 05:06:37',0,'this is very good',0,'published'),(18,49548386,0,213,9,'2013-01-28 13:49:44',0,'good',0,'published'),(19,93745892,0,235,4,'2013-01-28 16:08:08',0,'I don\'t believe it\'s real data',0,'published'),(20,58412817,0,242,4,'2013-02-06 15:04:51',0,'I don\'t believe it is true!!',0,'published'),(21,86261654,0,259,11,'2013-02-13 10:32:39',0,'test',0,'published'),(22,55641593,0,259,11,'2013-02-13 10:32:48',0,'test3',0,'published');
/*!40000 ALTER TABLE `colfusion_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_config`
--

DROP TABLE IF EXISTS `colfusion_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_config` (
  `var_id` int(11) NOT NULL AUTO_INCREMENT,
  `var_page` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `var_name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `var_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `var_defaultvalue` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `var_optiontext` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `var_title` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `var_desc` text COLLATE utf8_unicode_ci,
  `var_method` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `var_enclosein` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`var_id`)
) ENGINE=MyISAM AUTO_INCREMENT=108 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_config`
--

LOCK TABLES `colfusion_config` WRITE;
/*!40000 ALTER TABLE `colfusion_config` DISABLE KEYS */;
INSERT INTO `colfusion_config` VALUES (1,'SEO','$URLMethod','1','1','1 or 2','URL method','Search engine friendly URLs<br><b>1</b> = Non-SEO Links. Example: /story.php?title=Example-Title<br><b>2</b> SEO Method. Example: /category/example-title/ method.<br /><strong>Note:</strong> You must rename htaccess.default to .htaccess AND add code found at the bottom of the Admin > Manage > Categories page to the .htaccess file','normal',NULL),(2,'SEO','enable_friendly_urls','true','true','true / false','Friendly URL\'s for stories','Use the story title in the url by setting this value to true. Example: /story/(story title)/<br />Keep this setting as TRUE if using URL Method 1','define',NULL),(4,'Voting','votes_to_publish','5','5','number','Votes to publish','Number of votes before story is sent to the front page.','define',NULL),(5,'Voting','days_to_publish','1000000000000000000000','10','number','Days to publish','After this many days posts will not be eligible to move from upcoming to published pages','define',NULL),(6,'Misc','$trackbackURL','colfusion.exp.sis.pitt.edu/colfusion','pligg.com','pligg.com','Trackback URL','The url to be used in <a href=\"http://en.wikipedia.org/wiki/Trackback\">trackbacks</a>.','normal','\"'),(7,'Location Installed','$my_base_url','http://colfusion.exp.sis.pitt.edu','http://localhost','http://(your site name)(no trailing /)','Base URL','<br>\r\n<b>Examples</b>\r\n<br>\r\nhttp://demo.pligg.com<br>\r\nhttp://localhost<br>\r\nhttp://www.pligg.com','normal','\''),(8,'Location Installed','$my_pligg_base','/colfusion','','/(folder name)','Pligg Base Folder','<br>\r\n<b>Examples</b>\r\n<br>\r\n/pligg -- if installed in the /pligg subfolder<br>\r\nLeave blank if installed in the site root folder.','normal','\''),(9,'Tags','Enable_Tags','true','true','true / false','Enable Tags','Enable the use of tags and the tag cloud.','define',NULL),(10,'Tags','$tags_min_pts','8','8','number (should be at least 8)','Tag Minimum Font Size','<b>Only used if Tags are enabled.</b> How small should the text for the smallest tags be.','normal',NULL),(11,'Tags','$tags_max_pts','36','36','number','Tags Maximum Font Size','<b>Only used if Tags are enabled.</b> How large should the text for the largest tags be.','normal',NULL),(12,'Tags','$tags_words_limit','100','100','number','Tag Cloud Word Limit','<b>Only used if Tags are enabled.</b> The most tags to show in the cloud.','normal',NULL),(13,'AntiSpam','CHECK_SPAM','false','false','true / false','Enable spam checking','Checks submitted domains to see if they\'re on a blacklist.','define',NULL),(14,'AntiSpam','$MAIN_SPAM_RULESET','antispam.txt','antispam.txt','text file','Main Spam Ruleset','What file should be used to check for spam domains?','normal','\"'),(15,'AntiSpam','$USER_SPAM_RULESET','local-antispam.txt','local-antispam.txt','text file','Local Spam Ruleset','What file should Pligg write to if you mark items as spam?','normal','\"'),(16,'AntiSpam','$SPAM_LOG_BOOK','spamlog.log','spamlog.log','text file','Spam Log','File to log spam blocks to.','normal','\"'),(17,'Live','Enable_Live','true','true','true / false','Enable Live','Enable the live page.','define',NULL),(18,'Live','items_to_show','20','20','number','Live Items to Show','Number of items to show on the live page.','define',NULL),(19,'Live','how_often_refresh','20','20','number','How often to refresh','How many seconds between refreshes - not recommended to set it less than 5.','define',NULL),(20,'Submit','Story_Content_Tags_To_Allow_Normal','','','HTML tags','HTML tags to allow to Normal users','leave blank to not allow tags. Examples are \"&lt;strong&gt;&lt;br&gt;&lt;font&gt;&lt;img&gt;&lt;p&gt;\"','define','\"'),(21,'Submit','Submit_Require_A_URL','true','true','true / false','Require a URL when Submitting','Require a URL when submitting.','define',NULL),(22,'Submit','Submit_Show_URL_Input','true','true','true / false','Show the URL Input Box','Show the URL input box in submit step 1.','define',NULL),(23,'Submit','No_URL_Name','Editorial','Editorial','text','No URL text','Label to show when there is no URL provided in submit step 1.','define','\''),(27,'Avatars','Default_Gravatar_Large','/avatars/Gravatar_30.gif','/avatars/Gravatar_30.gif','Path to image','Default  avatar (large)','Default location of large gravatar.','define','\''),(28,'Avatars','Default_Gravatar_Small','/avatars/Gravatar_15.gif','/avatars/Gravatar_15.gif','Path to image','Default avatar (small)','Default location of small gravatar.','define','\''),(29,'Misc','Enable_Extra_Fields','false','false','true / false','Enable extra fields','Enable extra fields when submittng stories?','define',NULL),(30,'Comments','Enable_Comment_Voting','true','true','true / false','Comment Voting','Allow users to vote on comments?','define',NULL),(31,'Comments','$CommentOrder','4','4','1 - 4','Comment Sort Order','<br><b>1</b> = Top rated comments first, newest on top\r\n<br><b>2</b> = Newest comments first	\r\n<br><b>3</b> = Top rated comments first, oldest on top\r\n<br><b>4</b> = Oldest comments first','normal',NULL),(33,'Misc','Allow_Friends','true','true','true / false','Allow friends','Allow adding, removing, and viewing friends.','define',NULL),(34,'Voting','Voting_Method','2','1','1-3','Voting method','<b>1</b> = the digg method. <b>2</b> = 5 star rating method. <b>3</b> = Karma method','define',NULL),(36,'Tell-a-Friend','Enable_Recommend','true','true','true / false','Enable tell-a-friend','Enable or disable the tell-a-friend link for each story.','define',NULL),(37,'Tell-a-Friend','Email_Subject','Colfusion data: ','Pligg.com story: ','text','Email Subject Prefix','The prefix added to the email title. The story title will be added to the subject of the email.','define','\"'),(38,'Tell-a-Friend','Default_Message','I thought you might like to see this.','I thought you might like to see this.','text','Default message','Message sent along with story description in email.','define','\"'),(39,'Tell-a-Friend','Included_Text_Part1','Colfusion user ','Pligg.com user ','text file','Who Sent','The text used before displaying the username who sent the article.','define','\"'),(40,'Tell-a-Friend','Included_Text_Part2',' would like to share this story with you: ',' would like to share this story with you: ','Text','Who Sent 2','What appears after the user name. <b>Keep a space in the beginning and end.</b>','define','\"'),(41,'Tell-a-Friend','Send_From_Email','noreply@colfusion.org','noreply@pligg.com','email address','Sent from email','Email address email is sent from.','define','\"'),(43,'Misc','SearchMethod','3','3','1 - 3','Search method','<br><b>1</b> = uses MySQL MATCH for FULLTEXT indexes (or something). <b>Problems are MySQL STOP words and words less than 4 characters. Note: these limitations do not affect clicking on a TAG to search by it.</b>\r\n<br><b>2</b> = uses MySQL LIKE and is much slower, but returns better results. Also supports \"*\" and \"-\"\r\n<br><b>3</b> = is a hybrid, using method 1 if possible, but method 2 if needed.','define',NULL),(45,'Anonymous','anonymous_vote','false','false','true / false','Anonymous vote','Allow anonymous users to vote on articles.','define','\"'),(46,'Anonymous','$anon_karma','1','1','number','Anonymous Karma','Karma is an experimental feature that measures user activity and reputation.','normal',NULL),(47,'Hidden','SALT_LENGTH','9','9','number','SALT_LENGTH','SALT_LENGTH','define',NULL),(48,'Misc','$dblang','en','en','text','Database Language','Database language.','normal','\''),(49,'Misc','$page_size','8','8','number','Page Size','How many stories to show on a page.','normal',NULL),(50,'Misc','$top_users_size','25','25','number','Top Users Size','How many users to display in top users.','normal',NULL),(51,'Template','Allow_User_Change_Templates','false','false','true / false','Allow User to Change Templates','Allow user to change the template. They can do this from the user settings page.','define',''),(52,'Template','$thetemp','wistie','wistie','text','Template','Default Template','normal','\''),(53,'OutGoing','track_outgoing','false','false','true / false','Enable Outgoing Links','Out.php is used to track each click to the external story url. Do you want to enable this click tracking?','define',''),(54,'OutGoing','track_outgoing_method','title','title','url, title or id','Outgoing Links Placement','What information should the out.php link use?','define','\''),(55,'Submit','auto_vote','true','true','true / false','Auto vote','Automatically vote for the story you submitted.','define',NULL),(56,'Submit','Validate_URL','true','true','true / false','Validate URL','Check to see if the page exists, gets the title from it, and checks if it is a blog that uses trackbacks. This should only be set to false for sites who have hosts that don\'t allow fsockopen or for sites that want to link to media (mp3s, videos, etc.)','define',NULL),(57,'Misc','Spell_Checker','1','1','1 = on / 0 = off','Spell Check','Settings this to 1 will enable a Spellcheck button for stories and comments','define',NULL),(59,'Submit','SubmitSummary_Allow_Edit','0','0','1 = yes / 0 = no','Allow Edit of Summary','Allow users to edit the summary? Setting to yes will add an additional field to the submit page where users can write a brief description for the front page version of the article. Setting this to no the site will just truncate the full story content.','define',NULL),(60,'Avatars','Enable_User_Upload_Avatar','true','true','true / false','Allow User to Uploaded Avatars','Should users be able to upload their own avatars?','define',NULL),(61,'Avatars','User_Upload_Avatar_Folder','/avatars/user_uploaded','/avatars/user_uploaded','path','Avatar Storage Directory','This is the directory relative to your Pligg install where you want to store avatars.<br />Ex: if you installed in a subfolder named pligg, you only put /avatars/user_uploaded and NOT /pligg/avatarsuser_uploaded.','define','\"'),(62,'Avatars','Avatar_Large','30','30','number','Large Avatar Size','Size of the large avatars in pixels (both width and height). Commonly used on the profile page.','define',NULL),(63,'Avatars','Avatar_Small','15','15','number','Small Avatar Size','Size of the small avatar in pixels (both width and height). Commonly used in the comments page.','define',NULL),(64,'Story','use_title_as_link','false','false','true / false','Use Story Title as External Link','Use the story title as link to story\'s website.','define',NULL),(65,'Story','open_in_new_window','false','false','true / false','Open Story Link in New Window','If \"Use story title as link\" is set to true, setting this to true will open the link in a new window.','define',NULL),(67,'Misc','table_prefix','colfusion_','pligg_','text','MySQL Table Prefix','Table prefix. Ex: pligg_ makes the users table become pligg_users. Note: changing this will not automatically rename your tables!','define','\''),(68,'Voting','rating_to_publish','3','3','number','Rating To Publish','How many star rating votes will publish a story? For use with Voting Method 2.','define',NULL),(70,'Misc','enable_gzip_files','false','false','true / false','Enable Gzip File Compression','Should the server check for gzipped javascript files? This is used to decrease the load time for pages.','define',NULL),(71,'Submit','minTitleLength','3','10','number','Minimum Title Length','Minimum number of characters for the story title.','define',NULL),(72,'Submit','minStoryLength','10','10','number','Minimum Story Length','Minimum number of characters for the story description.','define',NULL),(73,'Tags','tags_min_pts_s','6','6','number (should be at least 6)','Tag minimum points (sidebar)','<b>Only used if Tags are enabled.</b> How small should the text for the smallest tags in the sidebar cloud?','define',NULL),(74,'Tags','tags_max_pts_s','15','15','number','Tag Maximum Points (sidebar)','<b>Only used if Tags are enabled.</b> How big should the text for the largest tags be in the sidebar cloud?','define',NULL),(75,'Tags','tags_words_limit_s','5','5','number','Tag Cloud Word Limit (sidebar)','<b>Only used if Tags are enabled.</b> How many tags to show in the sidebar cloud?','define',NULL),(76,'Comments','comments_length_sidebar','75','75','number','Sidebar Comment Length','The maximum number of characters shown for a comment in the sidebar','define',NULL),(77,'Comments','comments_size_sidebar','5','5','number','Sidebar Number of Comments','How many comments to show in the Latest Comments sidebar module.','define',NULL),(79,'Submit','Recommend_Time_Limit','30','30','number','Email Time Limit.','How many seconds a user must wait before sending another \"tell a friend\" email.','define',NULL),(81,'Groups','enable_group','true','true','true/false','Groups','Activate the Group Feature?','define','NULL'),(82,'Groups','max_user_groups_allowed','10','10','number','Max Groups User Create','Maximum number of groups a user is allowed to create','define','NULL'),(83,'Groups','max_groups_to_join','10','10','number','Max Joinable Groups','Maxiumum number of groups a user is allowed to join','define','NULL'),(84,'Groups','auto_approve_group','true','true','true/false','Auto Approve New Groups','Should new groups be auto-approved? Set to false if you want to moderate all new groups being created.','define','NULL'),(85,'Groups','group_avatar_size_width','90','90','number','Width of Group Avatar','Width in pixels for the group avatar','define','NULL'),(86,'Groups','group_avatar_size_height','90','90','number','Height of Group Avatar','Height in pixels for the group avatar','define','NULL'),(87,'Voting','votes_per_ip','0','1','number','Votes Allowed from one IP','This feature is turned on by default to prevent users from voting from multiple registered accounts from the same computer network. <b>0</b> = disable feature.','define',NULL),(88,'Submit','limit_time_to_edit','0','0','1 = on / 0 = off','Limit time to edit stories','This feature allows you to limit the amount of time a user has before they can no longer edit a submitted story.<br /><b>0</b> = Unlimited amount of time to edit<br><b>1</b> = specified amount of time','define',NULL),(89,'Submit','edit_time_limit','0','0','number','Minutes before a user is no longer allowed to edit a story','<b>0</b> = Disable the users ability to ever edit the story. Requires that you enable Limit Time To Edit Stories (set to 1).','define',NULL),(90,'Groups','group_submit_level','normal','normal','normal,admin,god','Group Create User Level','Minimum user level to create new groups','define','NULL'),(91,'Submit','Story_Content_Tags_To_Allow_Admin','','','HTML tags','HTML tags to allow to Admin users','leave blank to not allow tags. Examples are \"&lt;strong>&lt;br>&lt;font>&lt;img>&lt;p>\"','define','\"'),(92,'Submit','Story_Content_Tags_To_Allow_God','','','HTML tags','HTML tags to allow to God','leave blank to not allow tags. Examples are \"&lt;strong>&lt;br>&lt;font>&lt;img>&lt;p>\"','define','\"'),(93,'Misc','misc_validate','false','false','true / false','Validate user email','Require users to validate their email address?','define',''),(94,'Misc','misc_timezone','0','0','number','Timezone offset','Should be a number between -12 and 12 for GMT -1200 through GMT +1200 timezone','define',''),(95,'Submit','maxTitleLength','120','120','number','Maximum Title Length','Maximum number of characters for the story title.','define',NULL),(96,'Submit','maxTagsLength','40','40','number','Maximum Tag Line Length','Maximum number of characters for the story tags.','define',NULL),(97,'Submit','maxStoryLength','1000','1000','number','Maximum Story Length','Maximum number of characters for the story description.','define',NULL),(98,'Submit','maxSummaryLength','400','400','number','Maximum Summary Length','Maximum number of characters for the story summary.','define',NULL),(99,'Comments','maxCommentLength','1200','1200','number','Maximum Comment Length','Maximum number of characters for the comment.','define',NULL),(100,'Voting','buries_to_spam','0','0','number','Buries to Mark as Spam','Number of buries before story is sent to spam state. <b>0</b> = disable feature.','define',NULL),(101,'Comments','comment_buries_spam','0','0','number','Buries to Mark Comment as Spam','Number of buries before comment is sent to spam state. <b>0</b> = disable feature.','define',NULL),(102,'Voting','karma_to_publish','100','100','number','Karma to publish','Minimum karma value before story is sent to the front page.','define',NULL),(103,'Submit','Submit_Complete_Step2','true','true','true / false','Complete submission on Submit Step 2?','Skip step 3 (preview) or not','define',NULL),(104,'Misc','Independent_Subcategories','false','false','true / false','Show subcategories','Top level categories remain independent from subcategory content','define',NULL),(105,'Submit','Multiple_Categories','false','false','true / false','Allow multiple categories','User may choose more than one category for each story','define',NULL),(106,'Misc','$language','english','english','text','Site Language','Site Language','normal','\''),(107,'Misc','user_language','0','0','1 = yes / 0 = no','Select Language','Allow users to change Pligg language','normal','\'');
/*!40000 ALTER TABLE `colfusion_config` ENABLE KEYS */;
UNLOCK TABLES;

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
  `Description` text,
  `Size` int(11) DEFAULT NULL,
  `Upload_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`FileId`),
  KEY `Sid` (`Sid`),
  KEY `UserId` (`UserId`),
  CONSTRAINT `colfusion_des_attachments_ibfk_1` FOREIGN KEY (`Sid`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `colfusion_des_attachments_ibfk_2` FOREIGN KEY (`UserId`) REFERENCES `colfusion_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_des_attachments`
--

LOCK TABLES `colfusion_des_attachments` WRITE;
/*!40000 ALTER TABLE `colfusion_des_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `colfusion_des_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_dname_meta_data`
--

DROP TABLE IF EXISTS `colfusion_dname_meta_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_dname_meta_data` (
  `meta_id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `value` varchar(100) NOT NULL,
  `sid` int(11) NOT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `fk_colfusion_dname_meta_data_1_idx` (`cid`),
  CONSTRAINT `fk_colfusion_dname_meta_data_1` FOREIGN KEY (`cid`) REFERENCES `colfusion_dnameinfo` (`cid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_dname_meta_data`
--

LOCK TABLES `colfusion_dname_meta_data` WRITE;
/*!40000 ALTER TABLE `colfusion_dname_meta_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `colfusion_dname_meta_data` ENABLE KEYS */;
UNLOCK TABLES;

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
  `dname_value_description` varchar(100) DEFAULT NULL,
  `dname_original_name` varchar(200) NOT NULL COMMENT 'This table stores information about each column in any submitted dataset',
  `isConstant` bit(1) NOT NULL DEFAULT b'0' COMMENT 'if user is submitting database and on matching chema they provide input value, this flagg will be set',
  `constant_value` varchar(255) DEFAULT NULL COMMENT 'if user is submitting database and on matching chema they provide input value, the value will be stored here',
  PRIMARY KEY (`cid`),
  KEY `fk_colfusion_dnameinfo_1_idx` (`sid`),
  CONSTRAINT `fk_colfusion_dnameinfo_1` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=618 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_dnameinfo`
--

LOCK TABLES `colfusion_dnameinfo` WRITE;
/*!40000 ALTER TABLE `colfusion_dnameinfo` DISABLE KEYS */;
INSERT INTO `colfusion_dnameinfo` VALUES (586,751,'Spd','date','yyyy/mm/dd','source publication date','user input constant','','2013/05/09'),(587,751,'Drd','date','yyyy/mm/dd','date record date','user input constant','','2013/05/09'),(588,751,'Start','date','yyyy/mm/dd','start time of the data','user input constant','','2013/05/09'),(589,751,'End','date','yyyy/mm/dd','end time of the data','user input constant','','2013/05/09'),(590,751,'Location','String','','location of the event','user input constant','',''),(591,751,'Aggrtype','String','','Type of aggregation appplied to values','user input constant','',''),(592,751,'ID','STRING','','','ID','\0',NULL),(593,751,'WarNum','STRING','','','WarNum','\0',NULL),(594,751,'Ccode','STRING','','','Ccode','\0',NULL),(595,751,'StateAbb','STRING','','','StateAbb','\0',NULL),(596,751,'StartYear1','STRING','','','StartYear1','\0',NULL),(597,751,'StartMonth1','STRING','','','StartMonth1','\0',NULL),(598,751,'StartDay1','STRING','','','StartDay1','\0',NULL),(599,751,'EndYear1','STRING','','','EndYear1','\0',NULL),(600,751,'EndMonth1','STRING','','','EndMonth1','\0',NULL),(601,751,'EndDay1','STRING','','','EndDay1','\0',NULL),(602,752,'Spd','date','yyyy/mm/dd','source publication date','user input constant','','2013/05/09'),(603,752,'Drd','date','yyyy/mm/dd','date record date','user input constant','','2013/05/09'),(604,752,'Start','date','yyyy/mm/dd','start time of the data','user input constant','','2013/05/09'),(605,752,'End','date','yyyy/mm/dd','end time of the data','user input constant','','2013/05/09'),(606,752,'Location','String','','location of the event','user input constant','',''),(607,752,'Aggrtype','String','','Type of aggregation appplied to values','user input constant','',''),(608,752,'Ccode','STRING','','','Ccode','\0',NULL),(609,752,'StateNme','STRING','','','StateNme','\0',NULL),(610,753,'Spd','date','yyyy/mm/dd','source publication date','user input constant','','2013/05/09'),(611,753,'Drd','date','yyyy/mm/dd','date record date','user input constant','','2013/05/09'),(612,753,'Start','date','yyyy/mm/dd','start time of the data','user input constant','','2013/05/09'),(613,753,'End','date','yyyy/mm/dd','end time of the data','user input constant','','2013/05/09'),(614,753,'Location','String','','location of the event','user input constant','',''),(615,753,'Aggrtype','String','','Type of aggregation appplied to values','user input constant','',''),(616,753,'Ccode','STRING','','','Ccode','\0',NULL),(617,753,'StateNme','STRING','','','StateNme','\0',NULL);
/*!40000 ALTER TABLE `colfusion_dnameinfo` ENABLE KEYS */;
UNLOCK TABLES;

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
  `TimeStart` timestamp NULL DEFAULT NULL,
  `TimeEnd` timestamp NULL DEFAULT NULL,
  `ExitStatus` varchar(20) DEFAULT NULL,
  `ErrorMessage` mediumtext,
  `RecordsProcessed` int(20) DEFAULT NULL,
  PRIMARY KEY (`Eid`),
  KEY `fk_colfusion_executeinfo_1_idx` (`Sid`),
  CONSTRAINT `fk_colfusion_executeinfo_1` FOREIGN KEY (`Sid`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=435 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_executeinfo`
--

LOCK TABLES `colfusion_executeinfo` WRITE;
/*!40000 ALTER TABLE `colfusion_executeinfo` DISABLE KEYS */;
INSERT INTO `colfusion_executeinfo` VALUES (432,751,'1','2013-05-10 02:13:09','2013-05-10 02:13:36','1',NULL,1200),(433,752,'1','2013-05-10 02:15:30','2013-05-10 02:15:43','1',NULL,432),(434,753,'1','2013-05-10 02:49:17','2013-05-10 02:49:28','1',NULL,432);
/*!40000 ALTER TABLE `colfusion_executeinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_formulas`
--

DROP TABLE IF EXISTS `colfusion_formulas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_formulas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `title` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `formula` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_formulas`
--

LOCK TABLES `colfusion_formulas` WRITE;
/*!40000 ALTER TABLE `colfusion_formulas` DISABLE KEYS */;
INSERT INTO `colfusion_formulas` VALUES (1,'report',1,'Simple Story Reporting','$reports > $votes * 3');
/*!40000 ALTER TABLE `colfusion_formulas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_friends`
--

DROP TABLE IF EXISTS `colfusion_friends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_friends` (
  `friend_id` int(11) NOT NULL AUTO_INCREMENT,
  `friend_from` bigint(20) NOT NULL DEFAULT '0',
  `friend_to` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`friend_id`),
  UNIQUE KEY `friends_from_to` (`friend_from`,`friend_to`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_friends`
--

LOCK TABLES `colfusion_friends` WRITE;
/*!40000 ALTER TABLE `colfusion_friends` DISABLE KEYS */;
INSERT INTO `colfusion_friends` VALUES (1,7,1);
/*!40000 ALTER TABLE `colfusion_friends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_group_member`
--

DROP TABLE IF EXISTS `colfusion_group_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_group_member` (
  `member_id` int(20) NOT NULL AUTO_INCREMENT,
  `member_user_id` int(20) NOT NULL,
  `member_group_id` int(20) NOT NULL,
  `member_role` enum('admin','normal','moderator','flagged','banned') CHARACTER SET utf8 NOT NULL,
  `member_status` enum('active','inactive') CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`member_id`),
  KEY `user_group` (`member_group_id`,`member_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_group_member`
--

LOCK TABLES `colfusion_group_member` WRITE;
/*!40000 ALTER TABLE `colfusion_group_member` DISABLE KEYS */;
INSERT INTO `colfusion_group_member` VALUES (2,6,2,'admin','active'),(4,1,3,'admin','active'),(5,6,4,'admin','active'),(6,1,4,'moderator','active'),(9,1,2,'banned','active'),(10,7,2,'banned','active'),(11,4,2,'normal','inactive'),(12,4,3,'normal','active'),(13,9,3,'normal','active'),(14,9,4,'normal','active'),(15,4,4,'normal','active');
/*!40000 ALTER TABLE `colfusion_group_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_group_shared`
--

DROP TABLE IF EXISTS `colfusion_group_shared`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_group_shared` (
  `share_id` int(20) NOT NULL AUTO_INCREMENT,
  `share_link_id` int(20) NOT NULL,
  `share_group_id` int(20) NOT NULL,
  `share_user_id` int(20) NOT NULL,
  PRIMARY KEY (`share_id`),
  UNIQUE KEY `share_group_id` (`share_group_id`,`share_link_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_group_shared`
--

LOCK TABLES `colfusion_group_shared` WRITE;
/*!40000 ALTER TABLE `colfusion_group_shared` DISABLE KEYS */;
INSERT INTO `colfusion_group_shared` VALUES (4,207,2,6),(6,207,4,6),(7,250,3,4);
/*!40000 ALTER TABLE `colfusion_group_shared` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_groups`
--

DROP TABLE IF EXISTS `colfusion_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_groups` (
  `group_id` int(20) NOT NULL AUTO_INCREMENT,
  `group_creator` int(20) NOT NULL,
  `group_status` enum('Enable','disable') COLLATE utf8_unicode_ci NOT NULL,
  `group_members` int(20) NOT NULL,
  `group_date` datetime NOT NULL,
  `group_safename` text COLLATE utf8_unicode_ci,
  `group_name` text COLLATE utf8_unicode_ci,
  `group_description` text COLLATE utf8_unicode_ci,
  `group_privacy` enum('private','public','restricted') COLLATE utf8_unicode_ci DEFAULT NULL,
  `group_avatar` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `group_vote_to_publish` int(20) NOT NULL,
  `group_field1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `group_field2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `group_field3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `group_field4` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `group_field5` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `group_field6` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `group_notify_email` tinyint(1) NOT NULL,
  PRIMARY KEY (`group_id`),
  KEY `group_name` (`group_name`(100)),
  KEY `group_creator` (`group_creator`,`group_status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_groups`
--

LOCK TABLES `colfusion_groups` WRITE;
/*!40000 ALTER TABLE `colfusion_groups` DISABLE KEYS */;
INSERT INTO `colfusion_groups` VALUES (2,6,'Enable',3,'2012-12-03 00:44:34','information-science','Information Science','University of Pittsburgh','private','uploaded',3,NULL,NULL,NULL,NULL,NULL,NULL,1),(3,1,'Enable',3,'2012-12-03 01:08:10','movie','movie','share information','private','uploaded',1,NULL,NULL,NULL,NULL,NULL,NULL,1),(4,6,'Enable',4,'2012-12-03 02:00:52','taipei-medical-university','Taipei Medical University','Respiratory Therapy','public','uploaded',0,NULL,NULL,NULL,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `colfusion_groups` ENABLE KEYS */;
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
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_likes`
--

LOCK TABLES `colfusion_likes` WRITE;
/*!40000 ALTER TABLE `colfusion_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `colfusion_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_links`
--

DROP TABLE IF EXISTS `colfusion_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_links` (
  `link_id` int(20) NOT NULL,
  `link_author` int(20) NOT NULL DEFAULT '0',
  `link_status` enum('queued','private','discard','moderated') COLLATE utf8_unicode_ci DEFAULT 'discard',
  `link_randkey` int(20) NOT NULL DEFAULT '0',
  `link_votes` int(20) NOT NULL DEFAULT '0',
  `link_reports` int(20) NOT NULL DEFAULT '0',
  `link_comments` int(20) NOT NULL DEFAULT '0',
  `link_karma` decimal(10,2) NOT NULL DEFAULT '0.00',
  `link_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `link_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `link_published_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `link_category` int(11) NOT NULL DEFAULT '0',
  `link_lang` int(11) NOT NULL DEFAULT '1',
  `link_url` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_url_title` text COLLATE utf8_unicode_ci,
  `link_title` text COLLATE utf8_unicode_ci,
  `link_title_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_content` mediumtext COLLATE utf8_unicode_ci,
  `link_summary` text COLLATE utf8_unicode_ci,
  `link_tags` text COLLATE utf8_unicode_ci,
  `link_field1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_field2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_field3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_field4` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_field5` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_field6` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_field7` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_field8` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_field9` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_field10` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_field11` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_field12` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_field13` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_field14` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_field15` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_group_id` int(20) NOT NULL DEFAULT '0',
  `link_group_status` enum('queued','published','discard') CHARACTER SET utf8 NOT NULL DEFAULT 'queued',
  `link_out` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`link_id`),
  KEY `link_author` (`link_author`),
  KEY `link_url` (`link_url`),
  KEY `link_status` (`link_status`),
  KEY `link_title_url` (`link_title_url`),
  KEY `link_date` (`link_date`),
  KEY `link_published_date` (`link_published_date`),
  FULLTEXT KEY `link_url_2` (`link_url`,`link_url_title`,`link_title`,`link_content`,`link_tags`),
  FULLTEXT KEY `link_tags` (`link_tags`),
  FULLTEXT KEY `link_search` (`link_title`,`link_content`,`link_tags`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_links`
--

LOCK TABLES `colfusion_links` WRITE;
/*!40000 ALTER TABLE `colfusion_links` DISABLE KEYS */;
INSERT INTO `colfusion_links` VALUES (751,1,'queued',0,0,0,0,0.00,'2013-05-10 02:13:58','2013-05-10 02:13:58','0000-00-00 00:00:00',3,1,'register-wrapper/751.ktr',NULL,'test','751','sdg','sdg','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'queued',0),(752,1,'queued',0,0,0,0,0.00,'2013-05-10 02:15:50','2013-05-10 02:15:50','0000-00-00 00:00:00',3,1,'register-wrapper/752.ktr',NULL,'State list','752','asgasdg','asgasdg','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'queued',0),(753,1,'queued',0,0,0,0,0.00,'2013-05-10 02:49:35','2013-05-10 02:49:35','0000-00-00 00:00:00',3,1,'register-wrapper/753.ktr',NULL,'statelist 2','753','asg','asg','',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,'queued',0);
/*!40000 ALTER TABLE `colfusion_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_login_attempts`
--

DROP TABLE IF EXISTS `colfusion_login_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_login_attempts` (
  `login_id` int(11) NOT NULL AUTO_INCREMENT,
  `login_username` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `login_time` datetime NOT NULL,
  `login_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `login_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`login_id`),
  UNIQUE KEY `login_username` (`login_ip`,`login_username`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_login_attempts`
--

LOCK TABLES `colfusion_login_attempts` WRITE;
/*!40000 ALTER TABLE `colfusion_login_attempts` DISABLE KEYS */;
INSERT INTO `colfusion_login_attempts` VALUES (5,'dataverse','2012-11-02 16:41:23','150.212.2.155',1),(20,'vladimir','2012-11-09 10:14:06','150.212.31.23',2),(33,'ting','2012-12-17 00:04:08','10.228.65.93',3),(39,'CIRM','2013-01-09 11:08:44','150.212.31.254',1),(54,'dataverse','2013-01-28 15:22:55','150.212.31.175',2),(57,'Fatima','2013-02-06 14:57:01','150.212.31.206',1),(61,'Fatima','2013-02-16 12:56:09','98.236.187.182',6),(62,'Zhiqiao','2013-02-12 15:40:38','150.212.30.202',1),(66,'zhangzhang','2013-02-15 19:24:13','150.212.63.127',3),(72,'Sijia','2013-02-17 15:57:54','150.212.62.140',1),(74,'mengqian','2013-02-17 18:56:00','150.212.44.133',3),(77,'mengqian','2013-02-18 17:23:16','150.212.31.14',3),(78,'dataverse','2013-02-20 22:28:07','24.2.125.153',2);
/*!40000 ALTER TABLE `colfusion_login_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_messages`
--

DROP TABLE IF EXISTS `colfusion_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_messages` (
  `idMsg` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `sender` int(11) NOT NULL DEFAULT '0',
  `receiver` int(11) NOT NULL DEFAULT '0',
  `senderLevel` int(11) NOT NULL DEFAULT '0',
  `readed` int(11) NOT NULL DEFAULT '0',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idMsg`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_messages`
--

LOCK TABLES `colfusion_messages` WRITE;
/*!40000 ALTER TABLE `colfusion_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `colfusion_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_misc_data`
--

DROP TABLE IF EXISTS `colfusion_misc_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_misc_data` (
  `name` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `data` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_misc_data`
--

LOCK TABLES `colfusion_misc_data` WRITE;
/*!40000 ALTER TABLE `colfusion_misc_data` DISABLE KEYS */;
INSERT INTO `colfusion_misc_data` VALUES ('pligg_version','1.2.2'),('captcha_method','reCaptcha'),('reCaptcha_pubkey','6LfwKQQAAAAAAPFCNozXDIaf8GobTb7LCKQw54EA'),('reCaptcha_prikey','6LfwKQQAAAAAALQosKUrE4MepD0_kW7dgDZLR5P1'),('hash','z^vpnZokFB39`cl7Oy7adS_pAxPpFhl'),('validate','0'),('karma_submit_story','+15'),('karma_submit_comment','+10'),('karma_story_publish','+50'),('karma_story_vote','+1'),('karma_comment_vote','0'),('karma_story_discard','-250'),('karma_story_spam','-10000'),('karma_comment_delete','-50'),('status_switch','0'),('status_show_permalin','1'),('status_permalinks','1'),('status_inputonother','1'),('status_place','tpl_pligg_profile_info_end'),('status_clock','12'),('status_results','10'),('status_max_chars','1200'),('status_avatar','small'),('status_profile_level','god,admin,normal'),('status_level','god,admin,normal'),('status_user_email','1'),('status_user_comment','1'),('status_user_story','1'),('status_user_friends','1'),('status_user_switch','1'),('wrapper_directory','register-wrapper/'),('temp_directory','/temp/'),('raw_data_directory','/upload_raw_data/'),('spam_trigger_light','arsehole\r\nass-pirate\r\nass pirate\r\nassbandit\r\nassbanger\r\nassfucker\r\nasshat\r\nasshole\r\nasspirate\r\nassshole\r\nasswipe\r\nbastard\r\nbeaner\r\nbeastiality\r\nbitch\r\nblow job\r\nblowjob\r\nbutt plug\r\nbutt-pirate\r\nbutt pirate\r\nbuttpirate\r\ncarpet muncher\r\ncarpetmuncher\r\nclit\r\ncock smoker\r\ncocksmoker\r\ncock sucker\r\ncocksucker\r\ncum dumpster\r\ncumdumpster\r\ncum slut\r\ncumslut\r\ncunnilingus\r\ncunt\r\ndick head\r\ndickhead\r\ndickwad\r\ndickweed\r\ndickwod\r\ndike\r\ndildo\r\ndouche bag\r\ndouche-bag\r\ndouchebag\r\ndyke\r\nejaculat\r\nerection\r\nfaggit\r\nfaggot\r\nfagtard\r\nfarm sex\r\nfuck\r\nfudge packer\r\nfudge-packer\r\nfudgepacker\r\ngayass\r\ngay wad\r\ngaywad\r\ngod damn\r\ngod-damn\r\ngoddamn\r\nhandjob\r\njerk off\r\njizz\r\njungle bunny\r\njungle-bunny\r\njunglebunny\r\nkike\r\nkunt\r\nnigga\r\nnigger\r\norgasm\r\npenis\r\nporch monkey\r\nporch-monkey\r\nporchmonkey\r\nprostitute\r\nqueef\r\nrimjob\r\nsexual\r\nshit\r\nspick\r\nsplooge\r\ntesticle\r\ntitty\r\ntwat\r\nvagina\r\nwank\r\nxxx\r\nabilify\r\nadderall\r\nadipex\r\nadvair diskus\r\nambien\r\naranesp\r\nbotox\r\ncelebrex\r\ncialis\r\ncrestor\r\ncyclen\r\ncyclobenzaprine\r\ncymbalta\r\ndieting\r\neffexor\r\nepogen\r\nfioricet\r\nhydrocodone\r\nionamin\r\nlamictal\r\nlevaquin\r\nlevitra\r\nlexapro\r\nlipitor\r\nmeridia\r\nnexium\r\noxycontin\r\npaxil\r\nphendimetrazine\r\nphentamine\r\nphentermine\r\npheramones\r\npherimones\r\nplavix\r\nprevacid\r\nprocrit\r\nprotonix\r\nrisperdal\r\nseroquel\r\nsingulair\r\ntopamax\r\ntramadol\r\ntrim-spa\r\nultram\r\nvalium\r\nvaltrex\r\nviagra\r\nvicodin\r\nvioxx\r\nvytorin\r\nxanax\r\nzetia\r\nzocor\r\nzoloft\r\nzyprexa\r\nzyrtec\r\n18+\r\nacai berry\r\nacai pill\r\nadults only\r\nadult web\r\napply online\r\nauto loan\r\nbest rates\r\nbulk email\r\nbuy direct\r\nbuy drugs\r\nbuy now\r\nbuy online\r\ncasino\r\ncell phone\r\nchild porn\r\ncredit card\r\ndating site\r\nday-trading\r\ndebt free\r\ndegree program\r\ndescramble\r\ndiet pill\r\ndigital cble\r\ndirect tv\r\ndoctor approved\r\ndoctor prescribed\r\ndownload full\r\ndvd and bluray\r\ndvd bluray\r\ndvd storage\r\nearn a college degree\r\nearn a degree\r\nearn extra money\r\neasy money\r\nebay secret\r\nebay shop\r\nerotic\r\nescorts\r\nexplicit\r\nfind online\r\nfire your boss\r\nfree cable\r\nfree cell phone\r\nfree dating\r\nfree degree\r\nfree diploma\r\nfree dvd\r\nfree games\r\nfree gift\r\nfree money\r\nfree offer\r\nfree phone\r\nfree reading\r\ngambling\r\nget rich quick\r\ngingivitis\r\nhealth products\r\nheartburn\r\nhormone\r\nhorny\r\nincest\r\ninsurance\r\ninvestment\r\ninvestor\r\nloan quote\r\nloose weight\r\nlow interest\r\nmake money\r\nmedical exam\r\nmedications\r\nmoney at home\r\nmortgage\r\nm0rtgage\r\nmovies online\r\nmust be 18\r\nno purchase\r\nnudist\r\nonline free\r\nonline marketing\r\nonline movies\r\nonline order\r\nonline poker\r\norder now\r\norder online\r\nover 18\r\nover 21\r\npain relief\r\npharmacy\r\nprescription\r\nproduction management\r\nrefinance\r\nremoves wrinkles\r\nrolex\r\nsatellite tv\r\nsavings on\r\nsearch engine\r\nsexcapades\r\nstop snoring\r\nstop spam\r\nvacation offers\r\nvideo recorder\r\nvirgin\r\nweight reduction\r\nwork at home'),('upload_thumb','1'),('upload_sizes','a:1:{i:0;s:7:\"200x200\";}'),('upload_display','a:1:{s:7:\"150x150\";s:1:\"1\";}'),('upload_fields','YTowOnt9'),('upload_alternates','YToxOntpOjE7czowOiIiO30='),('upload_mandatory','a:0:{}'),('upload_place','tpl_link_summary_pre_story_content'),('upload_external','file,url'),('upload_link','orig'),('upload_quality','80'),('upload_directory','/modules/upload/attachments'),('upload_thdirectory','/modules/upload/attachments/thumbs'),('upload_filesize','200'),('upload_maxnumber','1'),('upload_extensions','jpg jpeg png gif'),('upload_defsize','200x200'),('upload_fileplace','tpl_pligg_story_who_voted_start'),('pagesize','50');
/*!40000 ALTER TABLE `colfusion_misc_data` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_modules`
--

DROP TABLE IF EXISTS `colfusion_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_modules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `version` float NOT NULL,
  `latest_version` float NOT NULL,
  `folder` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_modules`
--

LOCK TABLES `colfusion_modules` WRITE;
/*!40000 ALTER TABLE `colfusion_modules` DISABLE KEYS */;
/*!40000 ALTER TABLE `colfusion_modules` ENABLE KEYS */;
UNLOCK TABLES;

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
  PRIMARY KEY (`old_id`),
  KEY `old_title_url` (`old_title_url`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_old_urls`
--

LOCK TABLES `colfusion_old_urls` WRITE;
/*!40000 ALTER TABLE `colfusion_old_urls` DISABLE KEYS */;
/*!40000 ALTER TABLE `colfusion_old_urls` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_redirects`
--

DROP TABLE IF EXISTS `colfusion_redirects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_redirects` (
  `redirect_id` int(11) NOT NULL AUTO_INCREMENT,
  `redirect_old` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `redirect_new` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`redirect_id`),
  KEY `redirect_old` (`redirect_old`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_redirects`
--

LOCK TABLES `colfusion_redirects` WRITE;
/*!40000 ALTER TABLE `colfusion_redirects` DISABLE KEYS */;
/*!40000 ALTER TABLE `colfusion_redirects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_relationships`
--

DROP TABLE IF EXISTS `colfusion_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_relationships` (
  `rel_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `creator` int(11) NOT NULL,
  `creation_time` datetime NOT NULL,
  `sid1` int(11) NOT NULL,
  `sid2` int(11) NOT NULL,
  PRIMARY KEY (`rel_id`),
  KEY `fk_colfusion_relationships_1_idx` (`creator`),
  KEY `fk_colfusion_relationships_2_idx` (`sid1`),
  KEY `fk_colfusion_relationships_3_idx` (`sid2`),
  CONSTRAINT `fk_colfusion_relationships_1` FOREIGN KEY (`creator`) REFERENCES `colfusion_users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_colfusion_relationships_2` FOREIGN KEY (`sid1`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_colfusion_relationships_3` FOREIGN KEY (`sid2`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_relationships`
--

LOCK TABLES `colfusion_relationships` WRITE;
/*!40000 ALTER TABLE `colfusion_relationships` DISABLE KEYS */;
INSERT INTO `colfusion_relationships` VALUES (4,'autogenerated','based on complete match in dnames',19,'2013-05-09 23:25:23',752,751),(5,'autogenerated','based on complete match in dnames',19,'2013-05-09 23:25:23',752,753),(7,'autogenerated','based on complete match in dnames',19,'2013-05-09 23:39:28',751,753);
/*!40000 ALTER TABLE `colfusion_relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_relationships_columns`
--

DROP TABLE IF EXISTS `colfusion_relationships_columns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_relationships_columns` (
  `rel_id` int(11) NOT NULL,
  `cl_from` int(11) NOT NULL,
  `cl_to` int(11) NOT NULL,
  `trans_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`rel_id`,`cl_from`,`cl_to`),
  KEY `fk_new_table_1_idx` (`rel_id`),
  KEY `fk_new_table_2_idx` (`cl_from`),
  KEY `fk_new_table_3_idx` (`cl_to`),
  KEY `fk_new_table_4_idx` (`trans_id`),
  CONSTRAINT `fk_new_table_1` FOREIGN KEY (`rel_id`) REFERENCES `colfusion_relationships` (`rel_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_new_table_2` FOREIGN KEY (`cl_from`) REFERENCES `colfusion_dnameinfo` (`cid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_new_table_3` FOREIGN KEY (`cl_to`) REFERENCES `colfusion_dnameinfo` (`cid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_new_table_4` FOREIGN KEY (`trans_id`) REFERENCES `colfusion_relationships_transformations` (`trans_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_relationships_columns`
--

LOCK TABLES `colfusion_relationships_columns` WRITE;
/*!40000 ALTER TABLE `colfusion_relationships_columns` DISABLE KEYS */;
INSERT INTO `colfusion_relationships_columns` VALUES (4,608,594,NULL),(5,608,616,NULL),(5,609,617,NULL),(7,594,616,NULL);
/*!40000 ALTER TABLE `colfusion_relationships_columns` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_relationships_transformations`
--

DROP TABLE IF EXISTS `colfusion_relationships_transformations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_relationships_transformations` (
  `trans_id` int(11) NOT NULL AUTO_INCREMENT,
  `from` varchar(255) NOT NULL,
  `to` varchar(255) NOT NULL,
  PRIMARY KEY (`trans_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_relationships_transformations`
--

LOCK TABLES `colfusion_relationships_transformations` WRITE;
/*!40000 ALTER TABLE `colfusion_relationships_transformations` DISABLE KEYS */;
/*!40000 ALTER TABLE `colfusion_relationships_transformations` ENABLE KEYS */;
UNLOCK TABLES;

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
  `saved_privacy` enum('private','public') CHARACTER SET utf8 NOT NULL DEFAULT 'public',
  PRIMARY KEY (`saved_id`),
  KEY `saved_user_id` (`saved_user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_saved_links`
--

LOCK TABLES `colfusion_saved_links` WRITE;
/*!40000 ALTER TABLE `colfusion_saved_links` DISABLE KEYS */;
INSERT INTO `colfusion_saved_links` VALUES (7,4,213,'public'),(6,6,24,'public'),(8,4,250,'public'),(9,11,259,'public');
/*!40000 ALTER TABLE `colfusion_saved_links` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_sourceinfo`
--

DROP TABLE IF EXISTS `colfusion_sourceinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_sourceinfo` (
  `Sid` int(11) NOT NULL AUTO_INCREMENT,
  `Title` varchar(40) DEFAULT NULL,
  `UserId` int(11) NOT NULL,
  `Path` varchar(200) DEFAULT NULL,
  `EntryDate` datetime NOT NULL,
  `LastUpdated` datetime DEFAULT NULL,
  `Status` varchar(30) DEFAULT NULL,
  `raw_data_path` varchar(100) DEFAULT NULL,
  `source_type` varchar(45) NOT NULL DEFAULT 'file' COMMENT 'type of the source: whether it was submitted as file or as database',
  PRIMARY KEY (`Sid`),
  KEY `UserId` (`UserId`),
  CONSTRAINT `colfusion_sourceinfo_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `colfusion_users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=754 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_sourceinfo`
--

LOCK TABLES `colfusion_sourceinfo` WRITE;
/*!40000 ALTER TABLE `colfusion_sourceinfo` DISABLE KEYS */;
INSERT INTO `colfusion_sourceinfo` VALUES (751,'test',1,'register-wrapper/751.ktr','2013-05-09 22:11:08',NULL,'queued','WarParticipants --dv1.xlsx','file'),(752,'State list',1,'register-wrapper/752.ktr','2013-05-09 22:14:03',NULL,'queued','State list -- dv1.xls','file'),(753,'statelist 2',1,'register-wrapper/753.ktr','2013-05-09 22:48:38',NULL,'queued','State list -- dv1.xls','file');
/*!40000 ALTER TABLE `colfusion_sourceinfo` ENABLE KEYS */;
UNLOCK TABLES;

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
  PRIMARY KEY (`sid`),
  CONSTRAINT `colfusion_sourceinfo_DB_ibfk_1` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Stores information about the dataset which was submitted as database';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_sourceinfo_DB`
--

LOCK TABLES `colfusion_sourceinfo_DB` WRITE;
/*!40000 ALTER TABLE `colfusion_sourceinfo_DB` DISABLE KEYS */;
/*!40000 ALTER TABLE `colfusion_sourceinfo_DB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_tag_cache`
--

DROP TABLE IF EXISTS `colfusion_tag_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_tag_cache` (
  `tag_words` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `count` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_tag_cache`
--

LOCK TABLES `colfusion_tag_cache` WRITE;
/*!40000 ALTER TABLE `colfusion_tag_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `colfusion_tag_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_tags`
--

DROP TABLE IF EXISTS `colfusion_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_tags` (
  `tag_link_id` int(11) NOT NULL DEFAULT '0',
  `tag_lang` varchar(4) COLLATE utf8_unicode_ci DEFAULT 'en',
  `tag_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `tag_words` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY `tag_link_id` (`tag_link_id`,`tag_lang`,`tag_words`),
  KEY `tag_lang` (`tag_lang`,`tag_date`),
  KEY `tag_words` (`tag_words`,`tag_link_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_tags`
--

LOCK TABLES `colfusion_tags` WRITE;
/*!40000 ALTER TABLE `colfusion_tags` DISABLE KEYS */;
INSERT INTO `colfusion_tags` VALUES (15,'en','2012-10-26 21:00:10','history'),(17,'en','2012-11-05 09:57:36','history'),(24,'en','2012-11-05 15:47:18','history'),(29,'en','2012-11-07 05:36:51','history'),(31,'en','2012-11-07 05:38:01','colfusion'),(202,'en','2012-12-03 02:29:31','books'),(203,'en','2012-12-03 02:50:58','groups'),(206,'en','2012-12-03 05:46:54','math'),(207,'en','2012-12-03 09:22:11','information'),(209,'en','2012-12-14 16:52:15','web'),(209,'en','2012-12-14 16:52:15','design'),(209,'en','2012-12-14 16:52:15','whatever'),(211,'en','2012-12-17 14:55:14','web'),(213,'en','2012-12-17 16:22:34','web'),(221,'en','2012-12-17 16:52:50','programming'),(222,'en','2012-12-17 17:01:02','web'),(235,'en','2013-01-28 20:48:58','history'),(238,'en','2013-01-30 23:56:25','starbucks'),(239,'en','2013-01-31 03:29:09','pot'),(242,'en','2013-01-31 22:32:30','trade'),(250,'en','2013-02-06 19:49:30','google'),(260,'en','2013-02-13 19:35:23','pittsburgh'),(291,'en','2013-03-20 14:11:16','trade');
/*!40000 ALTER TABLE `colfusion_tags` ENABLE KEYS */;
UNLOCK TABLES;

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
-- Dumping data for table `colfusion_target`
--

LOCK TABLES `colfusion_target` WRITE;
/*!40000 ALTER TABLE `colfusion_target` DISABLE KEYS */;
/*!40000 ALTER TABLE `colfusion_target` ENABLE KEYS */;
UNLOCK TABLES;

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
  `Location` varchar(40) DEFAULT NULL,
  `AggrType` varchar(20) DEFAULT NULL,
  `Start` date DEFAULT NULL,
  `End` date DEFAULT NULL,
  `Value` varchar(100) DEFAULT NULL,
  `Eid` int(11) NOT NULL,
  `rownum` int(11) DEFAULT NULL,
  `columnnum` int(11) DEFAULT NULL,
  PRIMARY KEY (`Tid`),
  KEY `fk_colfusion_temporary_1_idx` (`Sid`),
  CONSTRAINT `fk_colfusion_temporary_1` FOREIGN KEY (`Sid`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=22445 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_temporary`
--

LOCK TABLES `colfusion_temporary` WRITE;
/*!40000 ALTER TABLE `colfusion_temporary` DISABLE KEYS */;
INSERT INTO `colfusion_temporary` VALUES (20381,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,1,1),(20382,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 302.0',432,1,2),(20383,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,1,3),(20384,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,1,4),(20385,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1817.0',432,1,5),(20386,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,1,6),(20387,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,1,7),(20388,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1818.0',432,1,8),(20389,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 8.0',432,1,9),(20390,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,1,10),(20391,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,2,1),(20392,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 303.0',432,2,2),(20393,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 640.0',432,2,3),(20394,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','TUR',432,2,4),(20395,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1821.0',432,2,5),(20396,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 8.0',432,2,6),(20397,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,2,7),(20398,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1823.0',432,2,8),(20399,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,2,9),(20400,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,2,10),(20401,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,3,1),(20402,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 305.0',432,3,2),(20403,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,3,3),(20404,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,3,4),(20405,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1823.0',432,3,5),(20406,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,3,6),(20407,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 24.0',432,3,7),(20408,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1826.0',432,3,8),(20409,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,3,9),(20410,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 24.0',432,3,10),(20411,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,4,1),(20412,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 306.0',432,4,2),(20413,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,4,3),(20414,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,4,4),(20415,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1824.0',432,4,5),(20416,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,4,6),(20417,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,4,7),(20418,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1826.0',432,4,8),(20419,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,4,9),(20420,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,4,10),(20421,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 6.0',432,5,1),(20422,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 307.0',432,5,2),(20423,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 210.0',432,5,3),(20424,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','NTH',432,5,4),(20425,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1825.0',432,5,5),(20426,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,5,6),(20427,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 23.0',432,5,7),(20428,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1830.0',432,5,8),(20429,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,5,9),(20430,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 28.0',432,5,10),(20431,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,6,1),(20432,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 309.0',432,6,2),(20433,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,6,3),(20434,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,6,4),(20435,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1825.0',432,6,5),(20436,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,6,6),(20437,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,6,7),(20438,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1826.0',432,6,8),(20439,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,6,9),(20440,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,6,10),(20441,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 8.0',432,7,1),(20442,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 310.0',432,7,2),(20443,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 365.0',432,7,3),(20444,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','USR',432,7,4),(20445,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1826.0',432,7,5),(20446,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,7,6),(20447,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 28.0',432,7,7),(20448,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1828.0',432,7,8),(20449,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,7,9),(20450,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 28.0',432,7,10),(20451,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,8,1),(20452,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 311.0',432,8,2),(20453,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,8,3),(20454,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,8,4),(20455,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1838.0',432,8,5),(20456,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,8,6),(20457,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,8,7),(20458,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1840.0',432,8,8),(20459,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,8,9),(20460,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,8,10),(20461,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,9,1),(20462,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 313.0',432,9,2),(20463,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,9,3),(20464,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,9,4),(20465,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1838.0',432,9,5),(20466,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,9,6),(20467,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,9,7),(20468,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1842.0',432,9,8),(20469,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,9,9),(20470,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,9,10),(20471,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,10,1),(20472,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 314.0',432,10,2),(20473,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 365.0',432,10,3),(20474,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','USR',432,10,4),(20475,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1839.0',432,10,5),(20476,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,10,6),(20477,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,10,7),(20478,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1839.0',432,10,8),(20479,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,10,9),(20480,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,10,10),(20481,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,11,1),(20482,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 315.0',432,11,2),(20483,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,11,3),(20484,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,11,4),(20485,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1839.0',432,11,5),(20486,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,11,6),(20487,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,11,7),(20488,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1842.0',432,11,8),(20489,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,11,9),(20490,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,11,10),(20491,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 13.0',432,12,1),(20492,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 317.0',432,12,2),(20493,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,12,3),(20494,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,12,4),(20495,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1839.0',432,12,5),(20496,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,12,6),(20497,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,12,7),(20498,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1847.0',432,12,8),(20499,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,12,9),(20500,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 23.0',432,12,10),(20501,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 14.0',432,13,1),(20502,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 318.0',432,13,2),(20503,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 135.0',432,13,3),(20504,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','PER',432,13,4),(20505,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1841.0',432,13,5),(20506,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,13,6),(20507,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 19.0',432,13,7),(20508,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1841.0',432,13,8),(20509,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,13,9),(20510,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 18.0',432,13,10),(20511,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 15.0',432,14,1),(20512,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 319.0',432,14,2),(20513,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,14,3),(20514,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,14,4),(20515,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1843.0',432,14,5),(20516,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,14,6),(20517,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 6.0',432,14,7),(20518,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1843.0',432,14,8),(20519,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,14,9),(20520,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,14,10),(20521,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 16.0',432,15,1),(20522,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 320.0',432,15,2),(20523,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,15,3),(20524,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,15,4),(20525,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1845.0',432,15,5),(20526,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,15,6),(20527,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,15,7),(20528,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1847.0',432,15,8),(20529,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,15,9),(20530,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,15,10),(20531,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 17.0',432,16,1),(20532,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 320.0',432,16,2),(20533,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 140.0',432,16,3),(20534,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','BRA',432,16,4),(20535,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1851.0',432,16,5),(20536,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 8.0',432,16,6),(20537,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 21.0',432,16,7),(20538,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1852.0',432,16,8),(20539,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,16,9),(20540,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,16,10),(20541,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 18.0',432,17,1),(20542,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 320.0',432,17,2),(20543,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,17,3),(20544,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,17,4),(20545,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1845.0',432,17,5),(20546,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,17,6),(20547,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,17,7),(20548,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1850.0',432,17,8),(20549,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 8.0',432,17,9),(20550,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,17,10),(20551,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 19.0',432,18,1),(20552,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 320.0',432,18,2),(20553,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 160.0',432,18,3),(20554,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','ARG',432,18,4),(20555,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1845.0',432,18,5),(20556,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,18,6),(20557,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,18,7),(20558,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1852.0',432,18,8),(20559,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,18,9),(20560,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,18,10),(20561,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 20.0',432,19,1),(20562,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 321.0',432,19,2),(20563,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,19,3),(20564,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,19,4),(20565,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1844.0',432,19,5),(20566,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 8.0',432,19,6),(20567,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 6.0',432,19,7),(20568,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1844.0',432,19,8),(20569,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,19,9),(20570,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,19,10),(20571,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 21.0',432,20,1),(20572,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 322.0',432,20,2),(20573,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,20,3),(20574,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,20,4),(20575,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1845.0',432,20,5),(20576,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,20,6),(20577,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 13.0',432,20,7),(20578,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1846.0',432,20,8),(20579,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,20,9),(20580,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,20,10),(20581,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 22.0',432,21,1),(20582,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 323.0',432,21,2),(20583,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,21,3),(20584,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,21,4),(20585,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1846.0',432,21,5),(20586,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,21,6),(20587,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,21,7),(20588,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1847.0',432,21,8),(20589,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,21,9),(20590,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,21,10),(20591,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 23.0',432,22,1),(20592,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 325.0',432,22,2),(20593,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 300.0',432,22,3),(20594,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','AUH',432,22,4),(20595,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1846.0',432,22,5),(20596,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,22,6),(20597,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 15.0',432,22,7),(20598,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1846.0',432,22,8),(20599,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,22,9),(20600,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,22,10),(20601,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 24.0',432,23,1),(20602,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 326.0',432,23,2),(20603,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,23,3),(20604,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,23,4),(20605,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1848.0',432,23,5),(20606,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,23,6),(20607,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,23,7),(20608,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1849.0',432,23,8),(20609,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,23,9),(20610,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,23,10),(20611,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 25.0',432,24,1),(20612,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 327.0',432,24,2),(20613,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,24,3),(20614,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,24,4),(20615,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1850.0',432,24,5),(20616,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,24,6),(20617,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,24,7),(20618,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1853.0',432,24,8),(20619,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,24,9),(20620,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,24,10),(20621,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 26.0',432,25,1),(20622,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 329.0',432,25,2),(20623,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,25,3),(20624,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,25,4),(20625,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1852.0',432,25,5),(20626,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,25,6),(20627,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,25,7),(20628,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1853.0',432,25,8),(20629,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,25,9),(20630,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,25,10),(20631,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 27.0',432,26,1),(20632,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 330.0',432,26,2),(20633,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,26,3),(20634,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,26,4),(20635,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1855.0',432,26,5),(20636,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,26,6),(20637,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,26,7),(20638,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1856.0',432,26,8),(20639,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,26,9),(20640,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,26,10),(20641,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 28.0',432,27,1),(20642,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 331.0',432,27,2),(20643,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,27,3),(20644,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,27,4),(20645,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1856.0',432,27,5),(20646,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,27,6),(20647,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 22.0',432,27,7),(20648,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1860.0',432,27,8),(20649,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,27,9),(20650,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 24.0',432,27,10),(20651,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 29.0',432,28,1),(20652,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 331.0',432,28,2),(20653,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,28,3),(20654,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,28,4),(20655,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1856.0',432,28,5),(20656,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,28,6),(20657,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 22.0',432,28,7),(20658,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1860.0',432,28,8),(20659,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,28,9),(20660,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 24.0',432,28,10),(20661,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 30.0',432,29,1),(20662,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 333.0',432,29,2),(20663,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,29,3),(20664,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,29,4),(20665,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1856.0',432,29,5),(20666,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,29,6),(20667,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,29,7),(20668,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1857.0',432,29,8),(20669,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,29,9),(20670,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,29,10),(20671,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 31.0',432,30,1),(20672,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 334.0',432,30,2),(20673,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,30,3),(20674,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,30,4),(20675,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1857.0',432,30,5),(20676,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,30,6),(20677,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,30,7),(20678,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1857.0',432,30,8),(20679,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,30,9),(20680,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,30,10),(20681,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 32.0',432,31,1),(20682,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 335.0',432,31,2),(20683,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,31,3),(20684,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,31,4),(20685,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1857.0',432,31,5),(20686,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,31,6),(20687,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,31,7),(20688,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1859.0',432,31,8),(20689,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,31,9),(20690,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,31,10),(20691,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 33.0',432,32,1),(20692,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 337.0',432,32,2),(20693,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,32,3),(20694,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,32,4),(20695,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1858.0',432,32,5),(20696,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 8.0',432,32,6),(20697,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 31.0',432,32,7),(20698,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1862.0',432,32,8),(20699,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 6.0',432,32,9),(20700,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,32,10),(20701,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 34.0',432,33,1),(20702,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 338.0',432,33,2),(20703,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 160.0',432,33,3),(20704,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','ARG',432,33,4),(20705,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1859.0',432,33,5),(20706,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,33,6),(20707,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,33,7),(20708,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1859.0',432,33,8),(20709,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,33,9),(20710,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 23.0',432,33,10),(20711,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 35.0',432,34,1),(20712,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 339.0',432,34,2),(20713,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,34,3),(20714,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,34,4),(20715,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1860.0',432,34,5),(20716,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,34,6),(20717,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,34,7),(20718,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1870.0',432,34,8),(20719,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,34,9),(20720,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 23.0',432,34,10),(20721,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 36.0',432,35,1),(20722,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 341.0',432,35,2),(20723,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 230.0',432,35,3),(20724,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','SPN',432,35,4),(20725,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1863.0',432,35,5),(20726,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,35,6),(20727,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,35,7),(20728,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1865.0',432,35,8),(20729,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,35,9),(20730,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 27.0',432,35,10),(20731,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 37.0',432,36,1),(20732,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 342.0',432,36,2),(20733,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,36,3),(20734,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,36,4),(20735,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1865.0',432,36,5),(20736,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,36,6),(20737,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,36,7),(20738,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1865.0',432,36,8),(20739,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,36,9),(20740,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,36,10),(20741,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 38.0',432,37,1),(20742,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 343.0',432,37,2),(20743,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,37,3),(20744,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,37,4),(20745,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1867.0',432,37,5),(20746,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,37,6),(20747,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,37,7),(20748,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1868.0',432,37,8),(20749,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,37,9),(20750,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 13.0',432,37,10),(20751,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 39.0',432,38,1),(20752,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 345.0',432,38,2),(20753,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 230.0',432,38,3),(20754,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','SPN',432,38,4),(20755,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1868.0',432,38,5),(20756,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,38,6),(20757,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,38,7),(20758,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1878.0',432,38,8),(20759,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,38,9),(20760,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,38,10),(20761,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 40.0',432,39,1),(20762,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 346.0',432,39,2),(20763,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,39,3),(20764,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,39,4),(20765,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1871.0',432,39,5),(20766,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,39,6),(20767,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,39,7),(20768,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1872.0',432,39,8),(20769,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,39,9),(20770,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,39,10),(20771,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 41.0',432,40,1),(20772,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 347.0',432,40,2),(20773,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,40,3),(20774,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,40,4),(20775,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1873.0',432,40,5),(20776,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,40,6),(20777,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,40,7),(20778,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1874.0',432,40,8),(20779,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,40,9),(20780,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,40,10),(20781,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 42.0',432,41,1),(20782,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 349.0',432,41,2),(20783,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,41,3),(20784,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,41,4),(20785,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1873.0',432,41,5),(20786,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,41,6),(20787,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,41,7),(20788,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1885.0',432,41,8),(20789,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,41,9),(20790,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,41,10),(20791,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 43.0',432,42,1),(20792,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 350.0',432,42,2),(20793,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 210.0',432,42,3),(20794,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','NTH',432,42,4),(20795,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1873.0',432,42,5),(20796,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,42,6),(20797,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 26.0',432,42,7),(20798,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1878.0',432,42,8),(20799,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,42,9),(20800,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,42,10),(20801,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 44.0',432,43,1),(20802,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 351.0',432,43,2),(20803,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 651.0',432,43,3),(20804,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','EGY',432,43,4),(20805,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1875.0',432,43,5),(20806,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,43,6),(20807,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,43,7),(20808,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1876.0',432,43,8),(20809,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,43,9),(20810,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,43,10),(20811,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 45.0',432,44,1),(20812,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 353.0',432,44,2),(20813,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,44,3),(20814,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,44,4),(20815,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1877.0',432,44,5),(20816,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 8.0',432,44,6),(20817,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,44,7),(20818,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1878.0',432,44,8),(20819,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,44,9),(20820,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,44,10),(20821,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 46.0',432,45,1),(20822,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 354.0',432,45,2),(20823,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 365.0',432,45,3),(20824,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','USR',432,45,4),(20825,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1878.0',432,45,5),(20826,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,45,6),(20827,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,45,7),(20828,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1881.0',432,45,8),(20829,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,45,9),(20830,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,45,10),(20831,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 47.0',432,46,1),(20832,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 355.0',432,46,2),(20833,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 300.0',432,46,3),(20834,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','AUH',432,46,4),(20835,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1878.0',432,46,5),(20836,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,46,6),(20837,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 29.0',432,46,7),(20838,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1878.0',432,46,8),(20839,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,46,9),(20840,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,46,10),(20841,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 48.0',432,47,1),(20842,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 356.0',432,47,2),(20843,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,47,3),(20844,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,47,4),(20845,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1878.0',432,47,5),(20846,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,47,6),(20847,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 20.0',432,47,7),(20848,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1879.0',432,47,8),(20849,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,47,9),(20850,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 26.0',432,47,10),(20851,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 49.0',432,48,1),(20852,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 358.0',432,48,2),(20853,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,48,3),(20854,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,48,4),(20855,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1879.0',432,48,5),(20856,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,48,6),(20857,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,48,7),(20858,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1879.0',432,48,8),(20859,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,48,9),(20860,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,48,10),(20861,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 50.0',432,49,1),(20862,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 359.0',432,49,2),(20863,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,49,3),(20864,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,49,4),(20865,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1880.0',432,49,5),(20866,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,49,6),(20867,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,49,7),(20868,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1881.0',432,49,8),(20869,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,49,9),(20870,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,49,10),(20871,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 51.0',432,50,1),(20872,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 360.0',432,50,2),(20873,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,50,3),(20874,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,50,4),(20875,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1880.0',432,50,5),(20876,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,50,6),(20877,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 30.0',432,50,7),(20878,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1881.0',432,50,8),(20879,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,50,9),(20880,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,50,10),(20881,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 52.0',432,51,1),(20882,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 362.0',432,51,2),(20883,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,51,3),(20884,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,51,4),(20885,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1881.0',432,51,5),(20886,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,51,6),(20887,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 31.0',432,51,7),(20888,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1882.0',432,51,8),(20889,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,51,9),(20890,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,51,10),(20891,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 53.0',432,52,1),(20892,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 363.0',432,52,2),(20893,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,52,3),(20894,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,52,4),(20895,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1882.0',432,52,5),(20896,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,52,6),(20897,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 25.0',432,52,7),(20898,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1884.0',432,52,8),(20899,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 6.0',432,52,9),(20900,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 14.0',432,52,10),(20901,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 54.0',432,53,1),(20902,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 364.0',432,53,2),(20903,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,53,3),(20904,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,53,4),(20905,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1882.0',432,53,5),(20906,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,53,6),(20907,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 13.0',432,53,7),(20908,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1885.0',432,53,8),(20909,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,53,9),(20910,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 30.0',432,53,10),(20911,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 55.0',432,54,1),(20912,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 366.0',432,54,2),(20913,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,54,3),(20914,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,54,4),(20915,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1883.0',432,54,5),(20916,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 6.0',432,54,6),(20917,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,54,7),(20918,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1885.0',432,54,8),(20919,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,54,9),(20920,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 17.0',432,54,10),(20921,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 56.0',432,55,1),(20922,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 367.0',432,55,2),(20923,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,55,3),(20924,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,55,4),(20925,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1885.0',432,55,5),(20926,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,55,6),(20927,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,55,7),(20928,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1886.0',432,55,8),(20929,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,55,9),(20930,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,55,10),(20931,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 57.0',432,56,1),(20932,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 368.0',432,56,2),(20933,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,56,3),(20934,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,56,4),(20935,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1885.0',432,56,5),(20936,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,56,6),(20937,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,56,7),(20938,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1886.0',432,56,8),(20939,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,56,9),(20940,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,56,10),(20941,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 58.0',432,57,1),(20942,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 370.0',432,57,2),(20943,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 365.0',432,57,3),(20944,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','USR',432,57,4),(20945,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1885.0',432,57,5),(20946,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,57,6),(20947,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 30.0',432,57,7),(20948,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1885.0',432,57,8),(20949,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,57,9),(20950,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,57,10),(20951,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 59.0',432,58,1),(20952,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 371.0',432,58,2),(20953,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 345.0',432,58,3),(20954,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','YUG',432,58,4),(20955,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1885.0',432,58,5),(20956,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,58,6),(20957,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,58,7),(20958,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1885.0',432,58,8),(20959,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,58,9),(20960,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,58,10),(20961,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 60.0',432,59,1),(20962,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 372.0',432,59,2),(20963,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 325.0',432,59,3),(20964,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','ITA',432,59,4),(20965,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1887.0',432,59,5),(20966,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,59,6),(20967,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,59,7),(20968,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1887.0',432,59,8),(20969,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,59,9),(20970,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,59,10),(20971,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 61.0',432,60,1),(20972,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 373.0',432,60,2),(20973,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,60,3),(20974,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,60,4),(20975,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1889.0',432,60,5),(20976,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,60,6),(20977,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,60,7),(20978,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1892.0',432,60,8),(20979,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,60,9),(20980,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,60,10),(20981,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 62.0',432,61,1),(20982,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 375.0',432,61,2),(20983,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,61,3),(20984,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,61,4),(20985,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1890.0',432,61,5),(20986,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,61,6),(20987,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,61,7),(20988,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1891.0',432,61,8),(20989,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,61,9),(20990,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,61,10),(20991,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 63.0',432,62,1),(20992,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 376.0',432,62,2),(20993,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 211.0',432,62,3),(20994,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','BEL',432,62,4),(20995,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1892.0',432,62,5),(20996,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,62,6),(20997,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,62,7),(20998,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1892.0',432,62,8),(20999,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,62,9),(21000,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,62,10),(21001,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 64.0',432,63,1),(21002,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 377.0',432,63,2),(21003,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,63,3),(21004,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,63,4),(21005,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1893.0',432,63,5),(21006,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,63,6),(21007,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,63,7),(21008,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1894.0',432,63,8),(21009,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,63,9),(21010,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,63,10),(21011,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 65.0',432,64,1),(21012,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 379.0',432,64,2),(21013,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 210.0',432,64,3),(21014,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','NTH',432,64,4),(21015,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1894.0',432,64,5),(21016,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,64,6),(21017,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,64,7),(21018,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1894.0',432,64,8),(21019,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,64,9),(21020,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,64,10),(21021,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 66.0',432,65,1),(21022,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 380.0',432,65,2),(21023,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,65,3),(21024,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,65,4),(21025,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1894.0',432,65,5),(21026,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,65,6),(21027,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,65,7),(21028,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1895.0',432,65,8),(21029,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,65,9),(21030,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,65,10),(21031,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 67.0',432,66,1),(21032,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 381.0',432,66,2),(21033,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 230.0',432,66,3),(21034,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','SPN',432,66,4),(21035,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1895.0',432,66,5),(21036,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,66,6),(21037,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 24.0',432,66,7),(21038,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1898.0',432,66,8),(21039,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,66,9),(21040,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 20.0',432,66,10),(21041,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 68.0',432,67,1),(21042,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 383.0',432,67,2),(21043,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 740.0',432,67,3),(21044,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','JPN',432,67,4),(21045,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1895.0',432,67,5),(21046,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,67,6),(21047,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 29.0',432,67,7),(21048,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1895.0',432,67,8),(21049,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,67,9),(21050,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 21.0',432,67,10),(21051,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 69.0',432,68,1),(21052,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 384.0',432,68,2),(21053,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 325.0',432,68,3),(21054,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','ITA',432,68,4),(21055,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1895.0',432,68,5),(21056,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,68,6),(21057,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,68,7),(21058,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1896.0',432,68,8),(21059,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,68,9),(21060,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 21.0',432,68,10),(21061,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 70.0',432,69,1),(21062,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 385.0',432,69,2),(21063,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 230.0',432,69,3),(21064,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','SPN',432,69,4),(21065,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1896.0',432,69,5),(21066,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,69,6),(21067,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 30.0',432,69,7),(21068,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1898.0',432,69,8),(21069,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,69,9),(21070,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,69,10),(21071,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 71.0',432,70,1),(21072,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 387.0',432,70,2),(21073,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,70,3),(21074,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,70,4),(21075,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1896.0',432,70,5),(21076,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,70,6),(21077,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,70,7),(21078,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1899.0',432,70,8),(21079,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,70,9),(21080,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,70,10),(21081,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 72.0',432,71,1),(21082,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 387.0',432,71,2),(21083,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,71,3),(21084,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,71,4),(21085,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1896.0',432,71,5),(21086,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,71,6),(21087,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,71,7),(21088,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1899.0',432,71,8),(21089,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,71,9),(21090,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,71,10),(21091,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 73.0',432,72,1),(21092,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 388.0',432,72,2),(21093,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,72,3),(21094,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,72,4),(21095,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1897.0',432,72,5),(21096,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,72,6),(21097,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,72,7),(21098,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1897.0',432,72,8),(21099,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,72,9),(21100,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,72,10),(21101,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 74.0',432,73,1),(21102,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 389.0',432,73,2),(21103,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,73,3),(21104,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,73,4),(21105,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1897.0',432,73,5),(21106,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 8.0',432,73,6),(21107,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,73,7),(21108,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1898.0',432,73,8),(21109,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,73,9),(21110,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,73,10),(21111,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 75.0',432,74,1),(21112,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 391.0',432,74,2),(21113,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,74,3),(21114,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,74,4),(21115,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1898.0',432,74,5),(21116,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,74,6),(21117,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,74,7),(21118,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1898.0',432,74,8),(21119,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,74,9),(21120,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,74,10),(21121,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 76.0',432,75,1),(21122,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 392.0',432,75,2),(21123,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,75,3),(21124,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','USA',432,75,4),(21125,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1899.0',432,75,5),(21126,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,75,6),(21127,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,75,7),(21128,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1902.0',432,75,8),(21129,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,75,9),(21130,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,75,10),(21131,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 77.0',432,76,1),(21132,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 393.0',432,76,2),(21133,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,76,3),(21134,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,76,4),(21135,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1899.0',432,76,5),(21136,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,76,6),(21137,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,76,7),(21138,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1905.0',432,76,8),(21139,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,76,9),(21140,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,76,10),(21141,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 78.0',432,77,1),(21142,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 395.0',432,77,2),(21143,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,77,3),(21144,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,77,4),(21145,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1899.0',432,77,5),(21146,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,77,6),(21147,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,77,7),(21148,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1902.0',432,77,8),(21149,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,77,9),(21150,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 31.0',432,77,10),(21151,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 79.0',432,78,1),(21152,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 396.0',432,78,2),(21153,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,78,3),(21154,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,78,4),(21155,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1903.0',432,78,5),(21156,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,78,6),(21157,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 29.0',432,78,7),(21158,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1903.0',432,78,8),(21159,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,78,9),(21160,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 27.0',432,78,10),(21161,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 80.0',432,79,1),(21162,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 397.0',432,79,2),(21163,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 255.0',432,79,3),(21164,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','GMY',432,79,4),(21165,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1904.0',432,79,5),(21166,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,79,6),(21167,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,79,7),(21168,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1905.0',432,79,8),(21169,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,79,9),(21170,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,79,10),(21171,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 81.0',432,80,1),(21172,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 399.0',432,80,2),(21173,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 255.0',432,80,3),(21174,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','GMY',432,80,4),(21175,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1905.0',432,80,5),(21176,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,80,6),(21177,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,80,7),(21178,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1906.0',432,80,8),(21179,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 6.0',432,80,9),(21180,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,80,10),(21181,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 82.0',432,81,1),(21182,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 400.0',432,81,2),(21183,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,81,3),(21184,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,81,4),(21185,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1906.0',432,81,5),(21186,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,81,6),(21187,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,81,7),(21188,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1906.0',432,81,8),(21189,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,81,9),(21190,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,81,10),(21191,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 83.0',432,82,1),(21192,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 401.0',432,82,2),(21193,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 230.0',432,82,3),(21194,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','SPN',432,82,4),(21195,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1911.0',432,82,5),(21196,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,82,6),(21197,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,82,7),(21198,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1912.0',432,82,8),(21199,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,82,9),(21200,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 30.0',432,82,10),(21201,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 84.0',432,83,1),(21202,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 401.0',432,83,2),(21203,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,83,3),(21204,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,83,4),(21205,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1911.0',432,83,5),(21206,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,83,6),(21207,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,83,7),(21208,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1912.0',432,83,8),(21209,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,83,9),(21210,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 30.0',432,83,10),(21211,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 85.0',432,84,1),(21212,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 402.0',432,84,2),(21213,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 710.0',432,84,3),(21214,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','CHN',432,84,4),(21215,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1912.0',432,84,5),(21216,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,84,6),(21217,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,84,7),(21218,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1913.0',432,84,8),(21219,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,84,9),(21220,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,84,10),(21221,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 86.0',432,85,1),(21222,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 404.0',432,85,2),(21223,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,85,3),(21224,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,85,4),(21225,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1916.0',432,85,5),(21226,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,85,6),(21227,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,85,7),(21228,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1917.0',432,85,8),(21229,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,85,9),(21230,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,85,10),(21231,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 87.0',432,86,1),(21232,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 404.0',432,86,2),(21233,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 230.0',432,86,3),(21234,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','SPN',432,86,4),(21235,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1916.0',432,86,5),(21236,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,86,6),(21237,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,86,7),(21238,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1917.0',432,86,8),(21239,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,86,9),(21240,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,86,10),(21241,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 88.0',432,87,1),(21242,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 405.0',432,87,2),(21243,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 710.0',432,87,3),(21244,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','CHN',432,87,4),(21245,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1918.0',432,87,5),(21246,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,87,6),(21247,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,87,7),(21248,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1918.0',432,87,8),(21249,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 8.0',432,87,9),(21250,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,87,10),(21251,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 89.0',432,88,1),(21252,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 406.0',432,88,2),(21253,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,88,3),(21254,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','USA',432,88,4),(21255,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1918.0',432,88,5),(21256,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,88,6),(21257,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 17.0',432,88,7),(21258,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1920.0',432,88,8),(21259,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,88,9),(21260,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 19.0',432,88,10),(21261,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 90.0',432,89,1),(21262,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 408.0',432,89,2),(21263,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,89,3),(21264,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,89,4),(21265,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1919.0',432,89,5),(21266,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,89,6),(21267,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,89,7),(21268,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1919.0',432,89,8),(21269,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 8.0',432,89,9),(21270,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 8.0',432,89,10),(21271,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 91.0',432,90,1),(21272,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 409.0',432,90,2),(21273,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,90,3),(21274,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,90,4),(21275,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1920.0',432,90,5),(21276,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,90,6),(21277,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,90,7),(21278,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1920.0',432,90,8),(21279,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,90,9),(21280,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,90,10),(21281,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 92.0',432,91,1),(21282,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 410.0',432,91,2),(21283,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,91,3),(21284,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,91,4),(21285,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1920.0',432,91,5),(21286,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 6.0',432,91,6),(21287,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,91,7),(21288,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1921.0',432,91,8),(21289,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,91,9),(21290,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,91,10),(21291,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 93.0',432,92,1),(21292,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 412.0',432,92,2),(21293,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 325.0',432,92,3),(21294,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','ITA',432,92,4),(21295,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1920.0',432,92,5),(21296,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 6.0',432,92,6),(21297,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,92,7),(21298,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1932.0',432,92,8),(21299,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,92,9),(21300,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,92,10),(21301,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 94.0',432,93,1),(21302,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 413.0',432,93,2),(21303,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 230.0',432,93,3),(21304,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','SPN',432,93,4),(21305,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1921.0',432,93,5),(21306,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,93,6),(21307,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 18.0',432,93,7),(21308,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1926.0',432,93,8),(21309,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,93,9),(21310,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 27.0',432,93,10),(21311,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 95.0',432,94,1),(21312,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 413.0',432,94,2),(21313,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,94,3),(21314,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,94,4),(21315,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1925.0',432,94,5),(21316,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,94,6),(21317,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,94,7),(21318,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1926.0',432,94,8),(21319,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,94,9),(21320,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 27.0',432,94,10),(21321,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 96.0',432,95,1),(21322,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 414.0',432,95,2),(21323,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,95,3),(21324,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,95,4),(21325,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1921.0',432,95,5),(21326,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,95,6),(21327,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,95,7),(21328,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1922.0',432,95,8),(21329,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,95,9),(21330,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,95,10),(21331,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 97.0',432,96,1),(21332,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 416.0',432,96,2),(21333,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,96,3),(21334,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,96,4),(21335,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1925.0',432,96,5),(21336,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,96,6),(21337,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 18.0',432,96,7),(21338,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1927.0',432,96,8),(21339,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 6.0',432,96,9),(21340,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,96,10),(21341,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 98.0',432,97,1),(21342,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 417.0',432,97,2),(21343,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,97,3),(21344,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,97,4),(21345,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1930.0',432,97,5),(21346,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,97,6),(21347,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,97,7),(21348,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1932.0',432,97,8),(21349,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 6.0',432,97,9),(21350,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,97,10),(21351,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 99.0',432,98,1),(21352,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 418.0',432,98,2),(21353,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,98,3),(21354,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,98,4),(21355,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1936.0',432,98,5),(21356,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,98,6),(21357,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 20.0',432,98,7),(21358,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1939.0',432,98,8),(21359,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,98,9),(21360,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 17.0',432,98,10),(21361,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 100.0',432,99,1),(21362,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 420.0',432,99,2),(21363,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,99,3),(21364,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,99,4),(21365,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1945.0',432,99,5),(21366,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,99,6),(21367,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,99,7),(21368,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1946.0',432,99,8),(21369,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,99,9),(21370,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 15.0',432,99,10),(21371,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 101.0',432,100,1),(21372,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 420.0',432,100,2),(21373,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 210.0',432,100,3),(21374,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','NTH',432,100,4),(21375,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1945.0',432,100,5),(21376,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,100,6),(21377,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,100,7),(21378,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1946.0',432,100,8),(21379,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,100,9),(21380,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 15.0',432,100,10),(21381,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 102.0',432,101,1),(21382,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 421.0',432,101,2),(21383,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,101,3),(21384,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,101,4),(21385,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1945.0',432,101,5),(21386,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,101,6),(21387,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,101,7),(21388,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1954.0',432,101,8),(21389,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 6.0',432,101,9),(21390,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,101,10),(21391,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 103.0',432,102,1),(21392,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 422.0',432,102,2),(21393,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,102,3),(21394,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,102,4),(21395,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1947.0',432,102,5),(21396,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,102,6),(21397,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 29.0',432,102,7),(21398,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1948.0',432,102,8),(21399,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,102,9),(21400,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,102,10),(21401,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 104.0',432,103,1),(21402,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 424.0',432,103,2),(21403,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,103,3),(21404,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,103,4),(21405,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1948.0',432,103,5),(21406,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 6.0',432,103,6),(21407,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 18.0',432,103,7),(21408,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1957.0',432,103,8),(21409,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 8.0',432,103,9),(21410,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 31.0',432,103,10),(21411,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 105.0',432,104,1),(21412,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 425.0',432,104,2),(21413,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 750.0',432,104,3),(21414,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','IND',432,104,4),(21415,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1948.0',432,104,5),(21416,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,104,6),(21417,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 13.0',432,104,7),(21418,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1948.0',432,104,8),(21419,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 9.0',432,104,9),(21420,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 17.0',432,104,10),(21421,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 106.0',432,105,1),(21422,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 426.0',432,105,2),(21423,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 710.0',432,105,3),(21424,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','CHN',432,105,4),(21425,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1950.0',432,105,5),(21426,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,105,6),(21427,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,105,7),(21428,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1951.0',432,105,8),(21429,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,105,9),(21430,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,105,10),(21431,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 107.0',432,106,1),(21432,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 428.0',432,106,2),(21433,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,106,3),(21434,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,106,4),(21435,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1952.0',432,106,5),(21436,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,106,6),(21437,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,106,7),(21438,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1954.0',432,106,8),(21439,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,106,9),(21440,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,106,10),(21441,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 108.0',432,107,1),(21442,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 429.0',432,107,2),(21443,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,107,3),(21444,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,107,4),(21445,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1952.0',432,107,5),(21446,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,107,6),(21447,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 20.0',432,107,7),(21448,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1956.0',432,107,8),(21449,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,107,9),(21450,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,107,10),(21451,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 109.0',432,108,1),(21452,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 430.0',432,108,2),(21453,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,108,3),(21454,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,108,4),(21455,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1953.0',432,108,5),(21456,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,108,6),(21457,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,108,7),(21458,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1956.0',432,108,8),(21459,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,108,9),(21460,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,108,10),(21461,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 110.0',432,109,1),(21462,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 430.0',432,109,2),(21463,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 230.0',432,109,3),(21464,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','SPN',432,109,4),(21465,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1953.0',432,109,5),(21466,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,109,6),(21467,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,109,7),(21468,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1956.0',432,109,8),(21469,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,109,9),(21470,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,109,10),(21471,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 111.0',432,110,1),(21472,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 432.0',432,110,2),(21473,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,110,3),(21474,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,110,4),(21475,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1954.0',432,110,5),(21476,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,110,6),(21477,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 1.0',432,110,7),(21478,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1962.0',432,110,8),(21479,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,110,9),(21480,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 17.0',432,110,10),(21481,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 112.0',432,111,1),(21482,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 433.0',432,111,2),(21483,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',432,111,3),(21484,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','UKG',432,111,4),(21485,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1955.0',432,111,5),(21486,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,111,6),(21487,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,111,7),(21488,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1960.0',432,111,8),(21489,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,111,9),(21490,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,111,10),(21491,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 113.0',432,112,1),(21492,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 433.0',432,112,2),(21493,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',432,112,3),(21494,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','FRN',432,112,4),(21495,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1955.0',432,112,5),(21496,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,112,6),(21497,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,112,7),(21498,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1960.0',432,112,8),(21499,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,112,9),(21500,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,112,10),(21501,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 114.0',432,113,1),(21502,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 434.0',432,113,2),(21503,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 235.0',432,113,3),(21504,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','POR',432,113,4),(21505,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1961.0',432,113,5),(21506,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 2.0',432,113,6),(21507,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 3.0',432,113,7),(21508,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1975.0',432,113,8),(21509,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,113,9),(21510,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,113,10),(21511,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 115.0',432,114,1),(21512,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 436.0',432,114,2),(21513,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 235.0',432,114,3),(21514,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','POR',432,114,4),(21515,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1962.0',432,114,5),(21516,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,114,6),(21517,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,114,7),(21518,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1974.0',432,114,8),(21519,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,114,9),(21520,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,114,10),(21521,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 116.0',432,115,1),(21522,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 437.0',432,115,2),(21523,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 235.0',432,115,3),(21524,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','POR',432,115,4),(21525,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1964.0',432,115,5),(21526,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,115,6),(21527,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,115,7),(21528,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1975.0',432,115,8),(21529,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,115,9),(21530,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09','-999.0',432,115,10),(21531,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 117.0',432,116,1),(21532,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 439.0',432,116,2),(21533,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 850.0',432,116,3),(21534,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','INS',432,116,4),(21535,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1975.0',432,116,5),(21536,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,116,6),(21537,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,116,7),(21538,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1977.0',432,116,8),(21539,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 7.0',432,116,9),(21540,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 4.0',432,116,10),(21541,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 118.0',432,117,1),(21542,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 440.0',432,117,2),(21543,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 560.0',432,117,3),(21544,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','SAF',432,117,4),(21545,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1975.0',432,117,5),(21546,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 10.0',432,117,6),(21547,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 17.0',432,117,7),(21548,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1988.0',432,117,8),(21549,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,117,9),(21550,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 13.0',432,117,10),(21551,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 119.0',432,118,1),(21552,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 441.0',432,118,2),(21553,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 600.0',432,118,3),(21554,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','MOR',432,118,4),(21555,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1975.0',432,118,5),(21556,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,118,6),(21557,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,118,7),(21558,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1983.0',432,118,8),(21559,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,118,9),(21560,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 23.0',432,118,10),(21561,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 120.0',432,119,1),(21562,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 441.0',432,119,2),(21563,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 435.0',432,119,3),(21564,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','MAA',432,119,4),(21565,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1975.0',432,119,5),(21566,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,119,6),(21567,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,119,7),(21568,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1979.0',432,119,8),(21569,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 8.0',432,119,9),(21570,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,119,10),(21571,751,'2013-05-09','2013-05-09','ID',NULL,NULL,'2013-05-09','2013-05-09',' 121.0',432,120,1),(21572,751,'2013-05-09','2013-05-09','WarNum',NULL,NULL,'2013-05-09','2013-05-09',' 441.0',432,120,2),(21573,751,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 615.0',432,120,3),(21574,751,'2013-05-09','2013-05-09','StateAbb',NULL,NULL,'2013-05-09','2013-05-09','ALG',432,120,4),(21575,751,'2013-05-09','2013-05-09','StartYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1975.0',432,120,5),(21576,751,'2013-05-09','2013-05-09','StartMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 12.0',432,120,6),(21577,751,'2013-05-09','2013-05-09','StartDay1',NULL,NULL,'2013-05-09','2013-05-09',' 11.0',432,120,7),(21578,751,'2013-05-09','2013-05-09','EndYear1',NULL,NULL,'2013-05-09','2013-05-09',' 1979.0',432,120,8),(21579,751,'2013-05-09','2013-05-09','EndMonth1',NULL,NULL,'2013-05-09','2013-05-09',' 8.0',432,120,9),(21580,751,'2013-05-09','2013-05-09','EndDay1',NULL,NULL,'2013-05-09','2013-05-09',' 5.0',432,120,10),(21581,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 20.0',433,1,1),(21582,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Canada',433,1,2),(21583,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 31.0',433,2,1),(21584,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bahamas',433,2,2),(21585,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 40.0',433,3,1),(21586,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Cuba',433,3,2),(21587,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 41.0',433,4,1),(21588,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Haiti',433,4,2),(21589,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 42.0',433,5,1),(21590,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Dominican Republic',433,5,2),(21591,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 51.0',433,6,1),(21592,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Jamaica',433,6,2),(21593,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 52.0',433,7,1),(21594,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Trinidad and Tobago',433,7,2),(21595,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 53.0',433,8,1),(21596,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Barbados',433,8,2),(21597,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 54.0',433,9,1),(21598,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Dominica',433,9,2),(21599,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 55.0',433,10,1),(21600,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Grenada',433,10,2),(21601,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 56.0',433,11,1),(21602,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','St. Lucia',433,11,2),(21603,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 57.0',433,12,1),(21604,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','St. Vincent and the Grenadines',433,12,2),(21605,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 58.0',433,13,1),(21606,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Antigua & Barbuda',433,13,2),(21607,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 60.0',433,14,1),(21608,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','St. Kitts and Nevis',433,14,2),(21609,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 70.0',433,15,1),(21610,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Mexico',433,15,2),(21611,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 80.0',433,16,1),(21612,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Belize',433,16,2),(21613,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 90.0',433,17,1),(21614,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Guatemala',433,17,2),(21615,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 91.0',433,18,1),(21616,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Honduras',433,18,2),(21617,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 92.0',433,19,1),(21618,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','El Salvador',433,19,2),(21619,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 93.0',433,20,1),(21620,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Nicaragua',433,20,2),(21621,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 94.0',433,21,1),(21622,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Costa Rica',433,21,2),(21623,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 95.0',433,22,1),(21624,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Panama',433,22,2),(21625,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 100.0',433,23,1),(21626,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Colombia',433,23,2),(21627,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 101.0',433,24,1),(21628,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Venezuela',433,24,2),(21629,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 110.0',433,25,1),(21630,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Guyana',433,25,2),(21631,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 115.0',433,26,1),(21632,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Suriname',433,26,2),(21633,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 130.0',433,27,1),(21634,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Ecuador',433,27,2),(21635,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 135.0',433,28,1),(21636,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Peru',433,28,2),(21637,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 140.0',433,29,1),(21638,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Brazil',433,29,2),(21639,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 145.0',433,30,1),(21640,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bolivia',433,30,2),(21641,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 150.0',433,31,1),(21642,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Paraguay',433,31,2),(21643,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 155.0',433,32,1),(21644,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Chile',433,32,2),(21645,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 160.0',433,33,1),(21646,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Argentina',433,33,2),(21647,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 165.0',433,34,1),(21648,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Uruguay',433,34,2),(21649,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',433,35,1),(21650,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','United Kingdom',433,35,2),(21651,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 205.0',433,36,1),(21652,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Ireland',433,36,2),(21653,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 210.0',433,37,1),(21654,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Netherlands',433,37,2),(21655,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 211.0',433,38,1),(21656,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Belgium',433,38,2),(21657,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 212.0',433,39,1),(21658,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Luxembourg',433,39,2),(21659,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',433,40,1),(21660,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','France',433,40,2),(21661,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 221.0',433,41,1),(21662,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Monaco',433,41,2),(21663,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 223.0',433,42,1),(21664,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Liechtenstein',433,42,2),(21665,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 225.0',433,43,1),(21666,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Switzerland',433,43,2),(21667,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 230.0',433,44,1),(21668,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Spain',433,44,2),(21669,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 232.0',433,45,1),(21670,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Andorra',433,45,2),(21671,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 235.0',433,46,1),(21672,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Portugal',433,46,2),(21673,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 240.0',433,47,1),(21674,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Hanover',433,47,2),(21675,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 245.0',433,48,1),(21676,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bavaria',433,48,2),(21677,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 255.0',433,49,1),(21678,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Germany',433,49,2),(21679,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 260.0',433,50,1),(21680,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','German Federal Republic',433,50,2),(21681,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 265.0',433,51,1),(21682,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','German Democratic Republic',433,51,2),(21683,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 267.0',433,52,1),(21684,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Baden',433,52,2),(21685,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 269.0',433,53,1),(21686,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Saxony',433,53,2),(21687,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 271.0',433,54,1),(21688,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Wuerttemburg',433,54,2),(21689,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 273.0',433,55,1),(21690,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Hesse Electoral',433,55,2),(21691,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 275.0',433,56,1),(21692,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Hesse Grand Ducal',433,56,2),(21693,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 280.0',433,57,1),(21694,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Mecklenburg Schwerin',433,57,2),(21695,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 290.0',433,58,1),(21696,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Poland',433,58,2),(21697,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 300.0',433,59,1),(21698,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Austria-Hungary',433,59,2),(21699,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 305.0',433,60,1),(21700,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Austria',433,60,2),(21701,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 310.0',433,61,1),(21702,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Hungary',433,61,2),(21703,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 315.0',433,62,1),(21704,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Czechoslovakia',433,62,2),(21705,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 316.0',433,63,1),(21706,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Czech Republic',433,63,2),(21707,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 317.0',433,64,1),(21708,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Slovakia',433,64,2),(21709,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 325.0',433,65,1),(21710,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Italy',433,65,2),(21711,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 327.0',433,66,1),(21712,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Papal States',433,66,2),(21713,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 329.0',433,67,1),(21714,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Two Sicilies',433,67,2),(21715,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 331.0',433,68,1),(21716,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','San Marino',433,68,2),(21717,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 332.0',433,69,1),(21718,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Modena',433,69,2),(21719,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 335.0',433,70,1),(21720,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Parma',433,70,2),(21721,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 337.0',433,71,1),(21722,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Tuscany',433,71,2),(21723,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 338.0',433,72,1),(21724,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Malta',433,72,2),(21725,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 339.0',433,73,1),(21726,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Albania',433,73,2),(21727,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 341.0',433,74,1),(21728,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Montenegro',433,74,2),(21729,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 343.0',433,75,1),(21730,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Macedonia',433,75,2),(21731,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 344.0',433,76,1),(21732,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Croatia',433,76,2),(21733,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 345.0',433,77,1),(21734,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Yugoslavia',433,77,2),(21735,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 346.0',433,78,1),(21736,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bosnia and Herzegovina',433,78,2),(21737,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 347.0',433,79,1),(21738,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Kosovo',433,79,2),(21739,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 349.0',433,80,1),(21740,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Slovenia',433,80,2),(21741,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 350.0',433,81,1),(21742,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Greece',433,81,2),(21743,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 352.0',433,82,1),(21744,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Cyprus',433,82,2),(21745,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 355.0',433,83,1),(21746,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bulgaria',433,83,2),(21747,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 359.0',433,84,1),(21748,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Moldova',433,84,2),(21749,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 360.0',433,85,1),(21750,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Romania',433,85,2),(21751,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 365.0',433,86,1),(21752,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Russia',433,86,2),(21753,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 366.0',433,87,1),(21754,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Estonia',433,87,2),(21755,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 367.0',433,88,1),(21756,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Latvia',433,88,2),(21757,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 368.0',433,89,1),(21758,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Lithuania',433,89,2),(21759,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 369.0',433,90,1),(21760,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Ukraine',433,90,2),(21761,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 370.0',433,91,1),(21762,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Belarus',433,91,2),(21763,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 371.0',433,92,1),(21764,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Armenia',433,92,2),(21765,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 372.0',433,93,1),(21766,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Georgia',433,93,2),(21767,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 373.0',433,94,1),(21768,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Azerbaijan',433,94,2),(21769,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 375.0',433,95,1),(21770,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Finland',433,95,2),(21771,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 380.0',433,96,1),(21772,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Sweden',433,96,2),(21773,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 385.0',433,97,1),(21774,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Norway',433,97,2),(21775,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 390.0',433,98,1),(21776,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Denmark',433,98,2),(21777,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 395.0',433,99,1),(21778,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Iceland',433,99,2),(21779,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 402.0',433,100,1),(21780,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Cape Verde',433,100,2),(21781,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 403.0',433,101,1),(21782,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Sao Tome and Principe',433,101,2),(21783,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 404.0',433,102,1),(21784,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Guinea-Bissau',433,102,2),(21785,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 411.0',433,103,1),(21786,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Equatorial Guinea',433,103,2),(21787,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 420.0',433,104,1),(21788,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Gambia',433,104,2),(21789,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 432.0',433,105,1),(21790,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Mali',433,105,2),(21791,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 433.0',433,106,1),(21792,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Senegal',433,106,2),(21793,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 434.0',433,107,1),(21794,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Benin',433,107,2),(21795,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 435.0',433,108,1),(21796,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Mauritania',433,108,2),(21797,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 436.0',433,109,1),(21798,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Niger',433,109,2),(21799,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 437.0',433,110,1),(21800,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Ivory Coast',433,110,2),(21801,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 438.0',433,111,1),(21802,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Guinea',433,111,2),(21803,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 439.0',433,112,1),(21804,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Burkina Faso',433,112,2),(21805,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 450.0',433,113,1),(21806,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Liberia',433,113,2),(21807,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 451.0',433,114,1),(21808,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Sierra Leone',433,114,2),(21809,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 452.0',433,115,1),(21810,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Ghana',433,115,2),(21811,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 461.0',433,116,1),(21812,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Togo',433,116,2),(21813,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 471.0',433,117,1),(21814,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Cameroon',433,117,2),(21815,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 475.0',433,118,1),(21816,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Nigeria',433,118,2),(21817,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 481.0',433,119,1),(21818,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Gabon',433,119,2),(21819,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 482.0',433,120,1),(21820,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Central African Republic',433,120,2),(21821,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 483.0',433,121,1),(21822,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Chad',433,121,2),(21823,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 484.0',433,122,1),(21824,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Congo',433,122,2),(21825,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 490.0',433,123,1),(21826,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Democratic Republic of the Congo',433,123,2),(21827,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 500.0',433,124,1),(21828,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Uganda',433,124,2),(21829,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 501.0',433,125,1),(21830,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Kenya',433,125,2),(21831,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 510.0',433,126,1),(21832,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Tanzania',433,126,2),(21833,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 511.0',433,127,1),(21834,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Zanzibar',433,127,2),(21835,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 516.0',433,128,1),(21836,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Burundi',433,128,2),(21837,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 517.0',433,129,1),(21838,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Rwanda',433,129,2),(21839,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 520.0',433,130,1),(21840,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Somalia',433,130,2),(21841,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 522.0',433,131,1),(21842,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Djibouti',433,131,2),(21843,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 530.0',433,132,1),(21844,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Ethiopia',433,132,2),(21845,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 531.0',433,133,1),(21846,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Eritrea',433,133,2),(21847,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 540.0',433,134,1),(21848,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Angola',433,134,2),(21849,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 541.0',433,135,1),(21850,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Mozambique',433,135,2),(21851,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 551.0',433,136,1),(21852,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Zambia',433,136,2),(21853,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 552.0',433,137,1),(21854,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Zimbabwe',433,137,2),(21855,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 553.0',433,138,1),(21856,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Malawi',433,138,2),(21857,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 560.0',433,139,1),(21858,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','South Africa',433,139,2),(21859,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 565.0',433,140,1),(21860,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Namibia',433,140,2),(21861,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 570.0',433,141,1),(21862,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Lesotho',433,141,2),(21863,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 571.0',433,142,1),(21864,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Botswana',433,142,2),(21865,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 572.0',433,143,1),(21866,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Swaziland',433,143,2),(21867,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 580.0',433,144,1),(21868,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Madagascar',433,144,2),(21869,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 581.0',433,145,1),(21870,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Comoros',433,145,2),(21871,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 590.0',433,146,1),(21872,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Mauritius',433,146,2),(21873,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 591.0',433,147,1),(21874,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Seychelles',433,147,2),(21875,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 600.0',433,148,1),(21876,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Morocco',433,148,2),(21877,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 615.0',433,149,1),(21878,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Algeria',433,149,2),(21879,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 616.0',433,150,1),(21880,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Tunisia',433,150,2),(21881,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 620.0',433,151,1),(21882,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Libya',433,151,2),(21883,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 625.0',433,152,1),(21884,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Sudan',433,152,2),(21885,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 626.0',433,153,1),(21886,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','South Sudan',433,153,2),(21887,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 630.0',433,154,1),(21888,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Iran',433,154,2),(21889,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 640.0',433,155,1),(21890,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Turkey',433,155,2),(21891,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 645.0',433,156,1),(21892,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Iraq',433,156,2),(21893,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 651.0',433,157,1),(21894,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Egypt',433,157,2),(21895,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 652.0',433,158,1),(21896,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Syria',433,158,2),(21897,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 660.0',433,159,1),(21898,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Lebanon',433,159,2),(21899,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 663.0',433,160,1),(21900,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Jordan',433,160,2),(21901,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 666.0',433,161,1),(21902,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Israel',433,161,2),(21903,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 670.0',433,162,1),(21904,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Saudi Arabia',433,162,2),(21905,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 678.0',433,163,1),(21906,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Yemen Arab Republic',433,163,2),(21907,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 679.0',433,164,1),(21908,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Yemen',433,164,2),(21909,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 680.0',433,165,1),(21910,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Yemen People\'s Republic',433,165,2),(21911,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 690.0',433,166,1),(21912,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Kuwait',433,166,2),(21913,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 692.0',433,167,1),(21914,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bahrain',433,167,2),(21915,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 694.0',433,168,1),(21916,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Qatar',433,168,2),(21917,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 696.0',433,169,1),(21918,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','United Arab Emirates',433,169,2),(21919,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 698.0',433,170,1),(21920,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Oman',433,170,2),(21921,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 700.0',433,171,1),(21922,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Afghanistan',433,171,2),(21923,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 701.0',433,172,1),(21924,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Turkmenistan',433,172,2),(21925,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 702.0',433,173,1),(21926,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Tajikistan',433,173,2),(21927,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 703.0',433,174,1),(21928,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Kyrgyzstan',433,174,2),(21929,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 704.0',433,175,1),(21930,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Uzbekistan',433,175,2),(21931,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 705.0',433,176,1),(21932,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Kazakhstan',433,176,2),(21933,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 710.0',433,177,1),(21934,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','China',433,177,2),(21935,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 712.0',433,178,1),(21936,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Mongolia',433,178,2),(21937,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 713.0',433,179,1),(21938,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Taiwan',433,179,2),(21939,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 730.0',433,180,1),(21940,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Korea',433,180,2),(21941,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 731.0',433,181,1),(21942,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','North Korea',433,181,2),(21943,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 732.0',433,182,1),(21944,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','South Korea',433,182,2),(21945,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 740.0',433,183,1),(21946,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Japan',433,183,2),(21947,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 750.0',433,184,1),(21948,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','India',433,184,2),(21949,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 760.0',433,185,1),(21950,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bhutan',433,185,2),(21951,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 770.0',433,186,1),(21952,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Pakistan',433,186,2),(21953,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 771.0',433,187,1),(21954,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bangladesh',433,187,2),(21955,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 775.0',433,188,1),(21956,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Myanmar',433,188,2),(21957,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 780.0',433,189,1),(21958,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Sri Lanka',433,189,2),(21959,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 781.0',433,190,1),(21960,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Maldives',433,190,2),(21961,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 790.0',433,191,1),(21962,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Nepal',433,191,2),(21963,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 800.0',433,192,1),(21964,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Thailand',433,192,2),(21965,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 811.0',433,193,1),(21966,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Cambodia',433,193,2),(21967,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 812.0',433,194,1),(21968,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Laos',433,194,2),(21969,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 816.0',433,195,1),(21970,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Vietnam',433,195,2),(21971,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 817.0',433,196,1),(21972,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Republic of Vietnam',433,196,2),(21973,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 820.0',433,197,1),(21974,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Malaysia',433,197,2),(21975,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 830.0',433,198,1),(21976,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Singapore',433,198,2),(21977,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 835.0',433,199,1),(21978,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Brunei',433,199,2),(21979,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 840.0',433,200,1),(21980,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Philippines',433,200,2),(21981,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 850.0',433,201,1),(21982,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Indonesia',433,201,2),(21983,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 860.0',433,202,1),(21984,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','East Timor',433,202,2),(21985,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 900.0',433,203,1),(21986,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Australia',433,203,2),(21987,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 910.0',433,204,1),(21988,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Papua New Guinea',433,204,2),(21989,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 920.0',433,205,1),(21990,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','New Zealand',433,205,2),(21991,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 935.0',433,206,1),(21992,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Vanuatu',433,206,2),(21993,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 940.0',433,207,1),(21994,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Solomon Islands',433,207,2),(21995,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 946.0',433,208,1),(21996,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Kiribati',433,208,2),(21997,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 947.0',433,209,1),(21998,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Tuvalu',433,209,2),(21999,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 950.0',433,210,1),(22000,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Fiji',433,210,2),(22001,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 955.0',433,211,1),(22002,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Tonga',433,211,2),(22003,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 970.0',433,212,1),(22004,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Nauru',433,212,2),(22005,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 983.0',433,213,1),(22006,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Marshall Islands',433,213,2),(22007,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 986.0',433,214,1),(22008,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Palau',433,214,2),(22009,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 987.0',433,215,1),(22010,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Federated States of Micronesia',433,215,2),(22011,752,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 990.0',433,216,1),(22012,752,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Samoa',433,216,2),(22013,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 20.0',434,1,1),(22014,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Canada',434,1,2),(22015,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 31.0',434,2,1),(22016,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bahamas',434,2,2),(22017,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 40.0',434,3,1),(22018,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Cuba',434,3,2),(22019,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 41.0',434,4,1),(22020,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Haiti',434,4,2),(22021,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 42.0',434,5,1),(22022,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Dominican Republic',434,5,2),(22023,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 51.0',434,6,1),(22024,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Jamaica',434,6,2),(22025,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 52.0',434,7,1),(22026,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Trinidad and Tobago',434,7,2),(22027,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 53.0',434,8,1),(22028,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Barbados',434,8,2),(22029,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 54.0',434,9,1),(22030,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Dominica',434,9,2),(22031,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 55.0',434,10,1),(22032,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Grenada',434,10,2),(22033,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 56.0',434,11,1),(22034,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','St. Lucia',434,11,2),(22035,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 57.0',434,12,1),(22036,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','St. Vincent and the Grenadines',434,12,2),(22037,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 58.0',434,13,1),(22038,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Antigua & Barbuda',434,13,2),(22039,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 60.0',434,14,1),(22040,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','St. Kitts and Nevis',434,14,2),(22041,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 70.0',434,15,1),(22042,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Mexico',434,15,2),(22043,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 80.0',434,16,1),(22044,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Belize',434,16,2),(22045,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 90.0',434,17,1),(22046,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Guatemala',434,17,2),(22047,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 91.0',434,18,1),(22048,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Honduras',434,18,2),(22049,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 92.0',434,19,1),(22050,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','El Salvador',434,19,2),(22051,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 93.0',434,20,1),(22052,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Nicaragua',434,20,2),(22053,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 94.0',434,21,1),(22054,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Costa Rica',434,21,2),(22055,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 95.0',434,22,1),(22056,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Panama',434,22,2),(22057,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 100.0',434,23,1),(22058,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Colombia',434,23,2),(22059,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 101.0',434,24,1),(22060,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Venezuela',434,24,2),(22061,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 110.0',434,25,1),(22062,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Guyana',434,25,2),(22063,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 115.0',434,26,1),(22064,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Suriname',434,26,2),(22065,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 130.0',434,27,1),(22066,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Ecuador',434,27,2),(22067,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 135.0',434,28,1),(22068,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Peru',434,28,2),(22069,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 140.0',434,29,1),(22070,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Brazil',434,29,2),(22071,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 145.0',434,30,1),(22072,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bolivia',434,30,2),(22073,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 150.0',434,31,1),(22074,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Paraguay',434,31,2),(22075,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 155.0',434,32,1),(22076,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Chile',434,32,2),(22077,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 160.0',434,33,1),(22078,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Argentina',434,33,2),(22079,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 165.0',434,34,1),(22080,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Uruguay',434,34,2),(22081,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 200.0',434,35,1),(22082,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','United Kingdom',434,35,2),(22083,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 205.0',434,36,1),(22084,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Ireland',434,36,2),(22085,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 210.0',434,37,1),(22086,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Netherlands',434,37,2),(22087,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 211.0',434,38,1),(22088,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Belgium',434,38,2),(22089,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 212.0',434,39,1),(22090,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Luxembourg',434,39,2),(22091,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 220.0',434,40,1),(22092,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','France',434,40,2),(22093,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 221.0',434,41,1),(22094,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Monaco',434,41,2),(22095,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 223.0',434,42,1),(22096,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Liechtenstein',434,42,2),(22097,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 225.0',434,43,1),(22098,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Switzerland',434,43,2),(22099,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 230.0',434,44,1),(22100,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Spain',434,44,2),(22101,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 232.0',434,45,1),(22102,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Andorra',434,45,2),(22103,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 235.0',434,46,1),(22104,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Portugal',434,46,2),(22105,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 240.0',434,47,1),(22106,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Hanover',434,47,2),(22107,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 245.0',434,48,1),(22108,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bavaria',434,48,2),(22109,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 255.0',434,49,1),(22110,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Germany',434,49,2),(22111,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 260.0',434,50,1),(22112,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','German Federal Republic',434,50,2),(22113,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 265.0',434,51,1),(22114,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','German Democratic Republic',434,51,2),(22115,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 267.0',434,52,1),(22116,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Baden',434,52,2),(22117,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 269.0',434,53,1),(22118,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Saxony',434,53,2),(22119,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 271.0',434,54,1),(22120,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Wuerttemburg',434,54,2),(22121,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 273.0',434,55,1),(22122,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Hesse Electoral',434,55,2),(22123,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 275.0',434,56,1),(22124,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Hesse Grand Ducal',434,56,2),(22125,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 280.0',434,57,1),(22126,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Mecklenburg Schwerin',434,57,2),(22127,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 290.0',434,58,1),(22128,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Poland',434,58,2),(22129,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 300.0',434,59,1),(22130,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Austria-Hungary',434,59,2),(22131,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 305.0',434,60,1),(22132,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Austria',434,60,2),(22133,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 310.0',434,61,1),(22134,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Hungary',434,61,2),(22135,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 315.0',434,62,1),(22136,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Czechoslovakia',434,62,2),(22137,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 316.0',434,63,1),(22138,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Czech Republic',434,63,2),(22139,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 317.0',434,64,1),(22140,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Slovakia',434,64,2),(22141,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 325.0',434,65,1),(22142,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Italy',434,65,2),(22143,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 327.0',434,66,1),(22144,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Papal States',434,66,2),(22145,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 329.0',434,67,1),(22146,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Two Sicilies',434,67,2),(22147,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 331.0',434,68,1),(22148,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','San Marino',434,68,2),(22149,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 332.0',434,69,1),(22150,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Modena',434,69,2),(22151,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 335.0',434,70,1),(22152,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Parma',434,70,2),(22153,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 337.0',434,71,1),(22154,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Tuscany',434,71,2),(22155,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 338.0',434,72,1),(22156,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Malta',434,72,2),(22157,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 339.0',434,73,1),(22158,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Albania',434,73,2),(22159,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 341.0',434,74,1),(22160,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Montenegro',434,74,2),(22161,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 343.0',434,75,1),(22162,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Macedonia',434,75,2),(22163,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 344.0',434,76,1),(22164,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Croatia',434,76,2),(22165,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 345.0',434,77,1),(22166,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Yugoslavia',434,77,2),(22167,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 346.0',434,78,1),(22168,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bosnia and Herzegovina',434,78,2),(22169,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 347.0',434,79,1),(22170,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Kosovo',434,79,2),(22171,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 349.0',434,80,1),(22172,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Slovenia',434,80,2),(22173,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 350.0',434,81,1),(22174,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Greece',434,81,2),(22175,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 352.0',434,82,1),(22176,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Cyprus',434,82,2),(22177,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 355.0',434,83,1),(22178,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bulgaria',434,83,2),(22179,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 359.0',434,84,1),(22180,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Moldova',434,84,2),(22181,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 360.0',434,85,1),(22182,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Romania',434,85,2),(22183,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 365.0',434,86,1),(22184,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Russia',434,86,2),(22185,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 366.0',434,87,1),(22186,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Estonia',434,87,2),(22187,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 367.0',434,88,1),(22188,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Latvia',434,88,2),(22189,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 368.0',434,89,1),(22190,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Lithuania',434,89,2),(22191,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 369.0',434,90,1),(22192,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Ukraine',434,90,2),(22193,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 370.0',434,91,1),(22194,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Belarus',434,91,2),(22195,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 371.0',434,92,1),(22196,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Armenia',434,92,2),(22197,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 372.0',434,93,1),(22198,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Georgia',434,93,2),(22199,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 373.0',434,94,1),(22200,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Azerbaijan',434,94,2),(22201,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 375.0',434,95,1),(22202,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Finland',434,95,2),(22203,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 380.0',434,96,1),(22204,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Sweden',434,96,2),(22205,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 385.0',434,97,1),(22206,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Norway',434,97,2),(22207,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 390.0',434,98,1),(22208,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Denmark',434,98,2),(22209,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 395.0',434,99,1),(22210,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Iceland',434,99,2),(22211,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 402.0',434,100,1),(22212,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Cape Verde',434,100,2),(22213,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 403.0',434,101,1),(22214,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Sao Tome and Principe',434,101,2),(22215,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 404.0',434,102,1),(22216,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Guinea-Bissau',434,102,2),(22217,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 411.0',434,103,1),(22218,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Equatorial Guinea',434,103,2),(22219,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 420.0',434,104,1),(22220,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Gambia',434,104,2),(22221,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 432.0',434,105,1),(22222,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Mali',434,105,2),(22223,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 433.0',434,106,1),(22224,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Senegal',434,106,2),(22225,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 434.0',434,107,1),(22226,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Benin',434,107,2),(22227,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 435.0',434,108,1),(22228,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Mauritania',434,108,2),(22229,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 436.0',434,109,1),(22230,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Niger',434,109,2),(22231,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 437.0',434,110,1),(22232,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Ivory Coast',434,110,2),(22233,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 438.0',434,111,1),(22234,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Guinea',434,111,2),(22235,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 439.0',434,112,1),(22236,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Burkina Faso',434,112,2),(22237,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 450.0',434,113,1),(22238,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Liberia',434,113,2),(22239,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 451.0',434,114,1),(22240,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Sierra Leone',434,114,2),(22241,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 452.0',434,115,1),(22242,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Ghana',434,115,2),(22243,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 461.0',434,116,1),(22244,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Togo',434,116,2),(22245,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 471.0',434,117,1),(22246,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Cameroon',434,117,2),(22247,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 475.0',434,118,1),(22248,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Nigeria',434,118,2),(22249,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 481.0',434,119,1),(22250,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Gabon',434,119,2),(22251,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 482.0',434,120,1),(22252,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Central African Republic',434,120,2),(22253,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 483.0',434,121,1),(22254,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Chad',434,121,2),(22255,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 484.0',434,122,1),(22256,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Congo',434,122,2),(22257,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 490.0',434,123,1),(22258,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Democratic Republic of the Congo',434,123,2),(22259,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 500.0',434,124,1),(22260,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Uganda',434,124,2),(22261,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 501.0',434,125,1),(22262,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Kenya',434,125,2),(22263,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 510.0',434,126,1),(22264,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Tanzania',434,126,2),(22265,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 511.0',434,127,1),(22266,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Zanzibar',434,127,2),(22267,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 516.0',434,128,1),(22268,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Burundi',434,128,2),(22269,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 517.0',434,129,1),(22270,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Rwanda',434,129,2),(22271,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 520.0',434,130,1),(22272,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Somalia',434,130,2),(22273,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 522.0',434,131,1),(22274,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Djibouti',434,131,2),(22275,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 530.0',434,132,1),(22276,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Ethiopia',434,132,2),(22277,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 531.0',434,133,1),(22278,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Eritrea',434,133,2),(22279,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 540.0',434,134,1),(22280,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Angola',434,134,2),(22281,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 541.0',434,135,1),(22282,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Mozambique',434,135,2),(22283,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 551.0',434,136,1),(22284,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Zambia',434,136,2),(22285,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 552.0',434,137,1),(22286,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Zimbabwe',434,137,2),(22287,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 553.0',434,138,1),(22288,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Malawi',434,138,2),(22289,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 560.0',434,139,1),(22290,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','South Africa',434,139,2),(22291,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 565.0',434,140,1),(22292,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Namibia',434,140,2),(22293,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 570.0',434,141,1),(22294,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Lesotho',434,141,2),(22295,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 571.0',434,142,1),(22296,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Botswana',434,142,2),(22297,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 572.0',434,143,1),(22298,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Swaziland',434,143,2),(22299,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 580.0',434,144,1),(22300,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Madagascar',434,144,2),(22301,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 581.0',434,145,1),(22302,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Comoros',434,145,2),(22303,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 590.0',434,146,1),(22304,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Mauritius',434,146,2),(22305,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 591.0',434,147,1),(22306,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Seychelles',434,147,2),(22307,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 600.0',434,148,1),(22308,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Morocco',434,148,2),(22309,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 615.0',434,149,1),(22310,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Algeria',434,149,2),(22311,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 616.0',434,150,1),(22312,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Tunisia',434,150,2),(22313,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 620.0',434,151,1),(22314,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Libya',434,151,2),(22315,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 625.0',434,152,1),(22316,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Sudan',434,152,2),(22317,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 626.0',434,153,1),(22318,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','South Sudan',434,153,2),(22319,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 630.0',434,154,1),(22320,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Iran',434,154,2),(22321,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 640.0',434,155,1),(22322,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Turkey',434,155,2),(22323,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 645.0',434,156,1),(22324,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Iraq',434,156,2),(22325,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 651.0',434,157,1),(22326,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Egypt',434,157,2),(22327,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 652.0',434,158,1),(22328,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Syria',434,158,2),(22329,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 660.0',434,159,1),(22330,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Lebanon',434,159,2),(22331,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 663.0',434,160,1),(22332,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Jordan',434,160,2),(22333,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 666.0',434,161,1),(22334,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Israel',434,161,2),(22335,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 670.0',434,162,1),(22336,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Saudi Arabia',434,162,2),(22337,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 678.0',434,163,1),(22338,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Yemen Arab Republic',434,163,2),(22339,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 679.0',434,164,1),(22340,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Yemen',434,164,2),(22341,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 680.0',434,165,1),(22342,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Yemen People\'s Republic',434,165,2),(22343,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 690.0',434,166,1),(22344,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Kuwait',434,166,2),(22345,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 692.0',434,167,1),(22346,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bahrain',434,167,2),(22347,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 694.0',434,168,1),(22348,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Qatar',434,168,2),(22349,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 696.0',434,169,1),(22350,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','United Arab Emirates',434,169,2),(22351,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 698.0',434,170,1),(22352,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Oman',434,170,2),(22353,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 700.0',434,171,1),(22354,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Afghanistan',434,171,2),(22355,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 701.0',434,172,1),(22356,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Turkmenistan',434,172,2),(22357,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 702.0',434,173,1),(22358,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Tajikistan',434,173,2),(22359,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 703.0',434,174,1),(22360,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Kyrgyzstan',434,174,2),(22361,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 704.0',434,175,1),(22362,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Uzbekistan',434,175,2),(22363,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 705.0',434,176,1),(22364,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Kazakhstan',434,176,2),(22365,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 710.0',434,177,1),(22366,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','China',434,177,2),(22367,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 712.0',434,178,1),(22368,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Mongolia',434,178,2),(22369,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 713.0',434,179,1),(22370,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Taiwan',434,179,2),(22371,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 730.0',434,180,1),(22372,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Korea',434,180,2),(22373,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 731.0',434,181,1),(22374,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','North Korea',434,181,2),(22375,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 732.0',434,182,1),(22376,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','South Korea',434,182,2),(22377,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 740.0',434,183,1),(22378,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Japan',434,183,2),(22379,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 750.0',434,184,1),(22380,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','India',434,184,2),(22381,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 760.0',434,185,1),(22382,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bhutan',434,185,2),(22383,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 770.0',434,186,1),(22384,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Pakistan',434,186,2),(22385,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 771.0',434,187,1),(22386,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Bangladesh',434,187,2),(22387,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 775.0',434,188,1),(22388,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Myanmar',434,188,2),(22389,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 780.0',434,189,1),(22390,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Sri Lanka',434,189,2),(22391,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 781.0',434,190,1),(22392,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Maldives',434,190,2),(22393,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 790.0',434,191,1),(22394,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Nepal',434,191,2),(22395,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 800.0',434,192,1),(22396,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Thailand',434,192,2),(22397,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 811.0',434,193,1),(22398,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Cambodia',434,193,2),(22399,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 812.0',434,194,1),(22400,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Laos',434,194,2),(22401,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 816.0',434,195,1),(22402,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Vietnam',434,195,2),(22403,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 817.0',434,196,1),(22404,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Republic of Vietnam',434,196,2),(22405,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 820.0',434,197,1),(22406,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Malaysia',434,197,2),(22407,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 830.0',434,198,1),(22408,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Singapore',434,198,2),(22409,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 835.0',434,199,1),(22410,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Brunei',434,199,2),(22411,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 840.0',434,200,1),(22412,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Philippines',434,200,2),(22413,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 850.0',434,201,1),(22414,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Indonesia',434,201,2),(22415,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 860.0',434,202,1),(22416,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','East Timor',434,202,2),(22417,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 900.0',434,203,1),(22418,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Australia',434,203,2),(22419,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 910.0',434,204,1),(22420,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Papua New Guinea',434,204,2),(22421,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 920.0',434,205,1),(22422,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','New Zealand',434,205,2),(22423,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 935.0',434,206,1),(22424,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Vanuatu',434,206,2),(22425,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 940.0',434,207,1),(22426,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Solomon Islands',434,207,2),(22427,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 946.0',434,208,1),(22428,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Kiribati',434,208,2),(22429,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 947.0',434,209,1),(22430,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Tuvalu',434,209,2),(22431,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 950.0',434,210,1),(22432,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Fiji',434,210,2),(22433,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 955.0',434,211,1),(22434,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Tonga',434,211,2),(22435,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 970.0',434,212,1),(22436,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Nauru',434,212,2),(22437,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 983.0',434,213,1),(22438,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Marshall Islands',434,213,2),(22439,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 986.0',434,214,1),(22440,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Palau',434,214,2),(22441,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 987.0',434,215,1),(22442,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Federated States of Micronesia',434,215,2),(22443,753,'2013-05-09','2013-05-09','Ccode',NULL,NULL,'2013-05-09','2013-05-09',' 990.0',434,216,1),(22444,753,'2013-05-09','2013-05-09','StateNme',NULL,NULL,'2013-05-09','2013-05-09','Samoa',434,216,2);
/*!40000 ALTER TABLE `colfusion_temporary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_totals`
--

DROP TABLE IF EXISTS `colfusion_totals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_totals` (
  `name` varchar(10) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `total` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_totals`
--

LOCK TABLES `colfusion_totals` WRITE;
/*!40000 ALTER TABLE `colfusion_totals` DISABLE KEYS */;
INSERT INTO `colfusion_totals` VALUES ('published',0),('queued',6),('discard',0);
/*!40000 ALTER TABLE `colfusion_totals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_trackbacks`
--

DROP TABLE IF EXISTS `colfusion_trackbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_trackbacks` (
  `trackback_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `trackback_link_id` int(11) NOT NULL DEFAULT '0',
  `trackback_user_id` int(11) NOT NULL DEFAULT '0',
  `trackback_type` enum('in','out') COLLATE utf8_unicode_ci DEFAULT 'in',
  `trackback_status` enum('ok','pendent','error') COLLATE utf8_unicode_ci DEFAULT 'pendent',
  `trackback_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `trackback_date` timestamp NULL DEFAULT NULL,
  `trackback_url` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `trackback_title` text COLLATE utf8_unicode_ci,
  `trackback_content` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`trackback_id`),
  UNIQUE KEY `trackback_link_id_2` (`trackback_link_id`,`trackback_type`,`trackback_url`),
  KEY `trackback_link_id` (`trackback_link_id`),
  KEY `trackback_url` (`trackback_url`),
  KEY `trackback_date` (`trackback_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_trackbacks`
--

LOCK TABLES `colfusion_trackbacks` WRITE;
/*!40000 ALTER TABLE `colfusion_trackbacks` DISABLE KEYS */;
/*!40000 ALTER TABLE `colfusion_trackbacks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_updates`
--

DROP TABLE IF EXISTS `colfusion_updates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_updates` (
  `update_id` int(11) NOT NULL AUTO_INCREMENT,
  `update_time` int(11) DEFAULT NULL,
  `update_type` char(1) COLLATE utf8_unicode_ci NOT NULL,
  `update_link_id` int(11) NOT NULL,
  `update_user_id` int(11) NOT NULL,
  `update_group_id` int(11) NOT NULL,
  `update_likes` int(11) NOT NULL,
  `update_level` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `update_text` text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`update_id`),
  FULLTEXT KEY `update_text` (`update_text`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_updates`
--

LOCK TABLES `colfusion_updates` WRITE;
/*!40000 ALTER TABLE `colfusion_updates` DISABLE KEYS */;
/*!40000 ALTER TABLE `colfusion_updates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_user_relationship_verdict`
--

DROP TABLE IF EXISTS `colfusion_user_relationship_verdict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_user_relationship_verdict` (
  `rel_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `confidence` decimal(10,0) NOT NULL,
  `comment` text,
  `when` datetime NOT NULL,
  PRIMARY KEY (`rel_id`,`user_id`),
  KEY `fk_colfusion_user_relationship_verdict_1_idx` (`rel_id`),
  KEY `fk_colfusion_user_relationship_verdict_2_idx` (`user_id`),
  CONSTRAINT `fk_colfusion_user_relationship_verdict_1` FOREIGN KEY (`rel_id`) REFERENCES `colfusion_relationships` (`rel_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_colfusion_user_relationship_verdict_2` FOREIGN KEY (`user_id`) REFERENCES `colfusion_users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_user_relationship_verdict`
--

LOCK TABLES `colfusion_user_relationship_verdict` WRITE;
/*!40000 ALTER TABLE `colfusion_user_relationship_verdict` DISABLE KEYS */;
INSERT INTO `colfusion_user_relationship_verdict` VALUES (4,19,1,'complete match in dnames','2013-05-09 23:25:23'),(5,19,1,'complete match in dnames','2013-05-09 23:25:23'),(7,19,1,'complete match in dnames','2013-05-09 23:39:28');
/*!40000 ALTER TABLE `colfusion_user_relationship_verdict` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_users`
--

DROP TABLE IF EXISTS `colfusion_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_users` (
  `user_id` int(20) NOT NULL AUTO_INCREMENT,
  `user_login` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_level` enum('normal','admin','god','Spammer') COLLATE utf8_unicode_ci DEFAULT 'normal',
  `user_modification` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_pass` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_email` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_names` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_karma` decimal(10,2) DEFAULT '0.00',
  `user_url` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_lastlogin` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_aim` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_msn` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_yahoo` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_gtalk` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_skype` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_irc` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `public_email` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_avatar_source` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_ip` varchar(20) COLLATE utf8_unicode_ci DEFAULT '0',
  `user_lastip` varchar(20) COLLATE utf8_unicode_ci DEFAULT '0',
  `last_reset_request` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_email_friend` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `last_reset_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_occupation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_categories` varchar(1024) COLLATE utf8_unicode_ci DEFAULT '',
  `user_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `user_language` varchar(32) CHARACTER SET utf8 DEFAULT NULL,
  `status_switch` tinyint(1) DEFAULT '1',
  `status_friends` tinyint(1) DEFAULT '1',
  `status_story` tinyint(1) DEFAULT '1',
  `status_comment` tinyint(1) DEFAULT '1',
  `status_email` tinyint(1) DEFAULT '1',
  `status_group` tinyint(1) DEFAULT '1',
  `status_all_friends` tinyint(1) DEFAULT '1',
  `status_friend_list` text CHARACTER SET utf8,
  `status_excludes` text CHARACTER SET utf8,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_login` (`user_login`),
  KEY `user_email` (`user_email`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_users`
--

LOCK TABLES `colfusion_users` WRITE;
/*!40000 ALTER TABLE `colfusion_users` DISABLE KEYS */;
INSERT INTO `colfusion_users` VALUES (1,'dataverse','god','2013-05-08 13:21:46','2012-10-22 12:14:18','eec9c89145b6ec0f01957db55d6e35a6cedc9c66c3d3e0763','yang23567@gmail.com','',10.00,'colfusion.exp.sis.pitt.edu/colfusion/user.php?login=dataverse','2013-05-08 13:21:46','','','','','','dataverse','','useruploaded','0','127.0.0.1','2012-12-17 15:33:11','2012-12-03 05:16:45','2ff9bb85e018e3ab400505051c3ec8eaf5dc944bf716d17c7','','','',1,'english',1,1,1,1,1,1,1,NULL,NULL),(2,'vladimir','normal','2012-11-27 21:51:56','2012-10-26 21:42:19','7f9f5f43f6c4452256988eb53fe63cb9ae89a666f8f013956','vladimirz@gmail.com',NULL,0.00,NULL,'2012-11-27 21:51:56',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'::1','10.228.65.85','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL,NULL,'',1,NULL,1,1,1,1,1,1,1,NULL,NULL),(3,'test','normal','2012-11-07 03:21:43','2012-11-07 03:04:03','a0ed95e9aec3311db769a63b8ca4e439141c342148c95c686','test@googl.com',NULL,0.00,NULL,'2012-11-07 03:21:43',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'10.228.65.75','150.212.67.33','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL,NULL,'',1,NULL,1,1,1,1,1,1,1,NULL,NULL),(4,'williamlion','normal','2013-02-13 22:01:12','2012-11-07 04:29:48','babc38192cd61577176e7f098064e693b20be23db9a6907b8','what@q.com',NULL,0.00,NULL,'2013-02-13 22:01:12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'0','150.212.31.210','0000-00-00 00:00:00','2013-02-06 19:59:57',NULL,NULL,NULL,'',1,NULL,1,1,1,1,1,1,1,NULL,NULL),(5,'williamlion1','normal','2012-11-09 18:14:47','2012-11-09 18:14:47','4f5dcb5be1cb3ae45e1de51400668e7cff5cbe97ba227ad4a','liaohan@gmail.com',NULL,0.00,NULL,'2012-11-09 18:14:47',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'150.212.31.23','150.212.31.23','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL,NULL,'',1,NULL,1,1,1,1,1,1,1,NULL,NULL),(6,'irule','god','2013-02-15 05:48:37','2012-12-03 04:29:09','71f9dd1bea7e2e57269fed66d6255f6780a069c9f426a0b3b','yang23567@hotmail.com','',0.00,'','2013-02-15 05:48:37','','','','','','','','useruploaded','10.228.65.90','67.171.73.160','0000-00-00 00:00:00','2012-12-03 21:54:28',NULL,'','','',1,'english',1,1,1,1,1,1,1,NULL,NULL),(7,'ting','normal','2012-12-03 08:53:47','2012-12-03 04:32:52','24d9bbf8db75ca100b9f94d7db07e3df14c65a08de2c07ec2','hsy8@pitt.edu','',0.00,'','2012-12-03 08:53:47','','','','','','','','useruploaded','10.228.65.90','67.171.73.160','2012-12-03 04:34:14','0000-00-00 00:00:00','c09b84a74b11e9c2a95b4359fff478de96bfeff3827a778df','','','',1,'english',1,1,1,1,1,1,1,NULL,NULL),(8,'Hua','normal','2013-02-06 01:31:38','2013-01-22 19:23:20','473555ffaa963c4ec127c52da92d4eac9d6ca8bc91e9610a1','yanjiahua922@gmail.com',NULL,0.00,NULL,'2013-02-06 01:31:38',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'67.186.7.38','67.186.7.154','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL,NULL,'',1,NULL,1,1,1,1,1,1,1,NULL,NULL),(9,'Lingyun','normal','2013-01-28 19:14:17','2013-01-28 18:38:27','5e16e85430c5bee7b9f6aff0d24c36fb163f014d95ea9d7ce','mifansly1989@gmail.com','',0.00,'','2013-01-28 19:14:17','','','','','','','','','150.212.47.247','150.212.47.247','2013-01-28 19:06:20','0000-00-00 00:00:00','cbb48caa44b88cef630f5df18deb02ef9df908027ee35897e','','','',1,'english',1,1,1,1,1,1,1,NULL,NULL),(10,'sly','normal','2013-01-28 19:17:12','2013-01-28 19:12:30','91b8694eb074edd5e9610eae1de8ad3f6d25930101681b3e7','lis68@pitt.edu',NULL,0.00,NULL,'2013-01-28 19:17:12',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'150.212.47.247','150.212.47.247','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL,NULL,'',1,NULL,1,1,1,1,1,1,1,NULL,NULL),(11,'Evgeny','normal','2013-02-21 19:12:20','2013-01-30 14:36:23','d2ef216042b44fb0d134081037c3b3f16a5fcd73effde75ad','karataev.evgeny@gmail.com',NULL,0.00,NULL,'2013-01-30 14:36:23',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'150.212.31.141','150.212.31.141','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL,NULL,'',1,NULL,1,1,1,1,1,1,1,NULL,NULL),(12,'xiangyu','normal','2013-02-06 17:59:34','2013-02-06 17:59:34','2d2345faa4decbe9289465e9ec84c3d9e8e6f820ce5d5853d','mmmxxy1988@163.com',NULL,0.00,NULL,'2013-02-06 17:59:34',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'150.212.44.143','150.212.44.143','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL,NULL,'',1,NULL,1,1,1,1,1,1,1,NULL,NULL),(13,'Fatiam','normal','2013-02-06 20:02:25','2013-02-06 20:02:25','3d486fe3637ce043cdba22c7dd582411c97798f9a64c2daf8','fhr4@pitt.edu',NULL,0.00,NULL,'2013-02-06 20:02:25',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'150.212.31.206','150.212.31.206','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL,NULL,'',1,NULL,1,1,1,1,1,1,1,NULL,NULL),(14,'Zhiqiao','normal','2013-02-17 19:35:39','2013-02-12 20:41:16','1d68958a4629fe7e4ffb8afe86764e404a32f7d3b58070c4a','zhd10@pitt.edu',NULL,0.00,NULL,'2013-02-17 19:35:39',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'150.212.30.202','150.212.67.70','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL,NULL,'',1,NULL,1,1,1,1,1,1,1,NULL,NULL),(15,'Fatima','normal','2013-02-13 00:26:51','2013-02-13 00:26:51','7b68f7b69c211cbe2fd687800f24ba40ce570f76b19675aa3','radwanfatima@gmail.com',NULL,0.00,NULL,'2013-02-13 00:26:51',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'98.236.187.182','98.236.187.182','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL,NULL,'',1,NULL,1,1,1,1,1,1,1,NULL,NULL),(16,'FRadwan','normal','2013-02-16 17:57:57','2013-02-16 17:57:57','880b12a5f46e46a796c01b9423722ca425916f3e1700c3c28','buny202@hotmail.com',NULL,0.00,NULL,'2013-02-16 17:57:57',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'98.236.187.182','98.236.187.182','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL,NULL,'',1,NULL,1,1,1,1,1,1,1,NULL,NULL),(17,'Feng','normal','2013-02-18 21:27:34','2013-02-17 03:41:01','49afbf7d631ea4f4f2abd79be180681abd83bf7c1056d7934','feg20@pitt.edu',NULL,0.00,NULL,'2013-02-18 21:27:34',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'67.172.17.130','150.212.31.81','2013-02-17 03:52:07','0000-00-00 00:00:00','6c3b6b6c8a08b67155ef286c7d8da55a5f1de9f7c9506e986',NULL,NULL,'',1,NULL,1,1,1,1,1,1,1,NULL,NULL),(18,'Sijia','normal','2013-02-18 15:39:31','2013-02-17 20:58:31','08755f802e94e3ae5bfe9d527c798e6724f735ebbece6e4ff','siz10@pitt.edu',NULL,0.00,NULL,'2013-02-18 15:39:31',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'150.212.62.140','150.212.67.141','2013-02-18 15:38:45','0000-00-00 00:00:00','bbd8cca7010c46af9d7dcf68788ded98db570660c2deb8401',NULL,NULL,'',1,NULL,1,1,1,1,1,1,1,NULL,NULL),(19,'Colfusion_AI','normal','2013-05-08 00:24:02','2013-05-08 00:24:02','bffea7655362d720d853b9c1050b4e2478f7265c8c09329f8','kzheka@hotmail.com',NULL,0.00,NULL,'2013-05-08 00:24:02',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'127.0.0.1','127.0.0.1','0000-00-00 00:00:00','0000-00-00 00:00:00',NULL,NULL,NULL,'',1,NULL,1,1,1,1,1,1,1,NULL,NULL);
/*!40000 ALTER TABLE `colfusion_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_visualization`
--

DROP TABLE IF EXISTS `colfusion_visualization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_visualization` (
  `vid` varchar(20) NOT NULL,
  `type` varchar(50) NOT NULL,
  `userid` int(11) NOT NULL,
  `top` int(11) NOT NULL DEFAULT '80',
  `left` int(11) NOT NULL DEFAULT '0',
  `width` int(11) NOT NULL DEFAULT '500',
  `height` int(11) NOT NULL DEFAULT '400',
  `setting` varchar(500) NOT NULL,
  `titleno` int(11) NOT NULL,
  PRIMARY KEY (`vid`),
  KEY `fk_colfusion_visualization_1_idx` (`titleno`),
  CONSTRAINT `fk_colfusion_visualization_1` FOREIGN KEY (`titleno`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_visualization`
--

LOCK TABLES `colfusion_visualization` WRITE;
/*!40000 ALTER TABLE `colfusion_visualization` DISABLE KEYS */;
/*!40000 ALTER TABLE `colfusion_visualization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_votes`
--

DROP TABLE IF EXISTS `colfusion_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_votes` (
  `vote_id` int(20) NOT NULL AUTO_INCREMENT,
  `vote_type` enum('links','comments') CHARACTER SET utf8 NOT NULL DEFAULT 'links',
  `vote_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `vote_link_id` int(20) NOT NULL DEFAULT '0',
  `vote_user_id` int(20) NOT NULL DEFAULT '0',
  `vote_value` smallint(11) NOT NULL DEFAULT '1',
  `vote_karma` int(11) DEFAULT '0',
  `vote_ip` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`vote_id`),
  KEY `user_id` (`vote_user_id`),
  KEY `link_id` (`vote_link_id`),
  KEY `vote_type` (`vote_type`,`vote_link_id`,`vote_user_id`,`vote_ip`)
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_votes`
--

LOCK TABLES `colfusion_votes` WRITE;
/*!40000 ALTER TABLE `colfusion_votes` DISABLE KEYS */;
INSERT INTO `colfusion_votes` VALUES (1,'links','2012-12-16 04:47:05',209,1,2,10,'10.228.65.91'),(2,'links','2012-12-16 04:56:18',209,6,10,0,'67.171.73.160'),(3,'links','2012-12-16 05:17:41',203,6,6,0,'10.228.65.91'),(4,'links','2012-12-16 05:20:03',207,6,4,0,'10.228.65.91'),(5,'links','2012-12-16 05:21:43',207,1,10,10,'10.228.65.91'),(6,'links','2012-12-16 05:33:58',31,6,4,0,'67.171.73.160'),(7,'links','2012-12-16 05:34:25',31,1,10,10,'10.228.65.91'),(8,'links','2012-12-16 06:22:15',203,1,2,10,'10.228.65.91'),(9,'links','2012-12-16 06:22:32',15,1,2,10,'10.228.65.91'),(10,'links','2012-12-16 06:22:43',17,1,10,10,'10.228.65.91'),(11,'links','2012-12-16 07:35:13',24,1,8,10,'10.228.65.91'),(12,'links','2012-12-16 07:43:18',29,1,2,10,'10.228.65.91'),(13,'links','2012-12-16 07:52:48',29,6,10,0,'10.228.65.91'),(14,'links','2012-12-16 07:54:02',24,6,2,0,'10.228.65.91'),(15,'links','2012-12-17 04:37:52',203,4,10,0,'10.228.65.94'),(16,'links','2012-12-17 04:38:14',31,4,10,0,'10.228.65.94'),(17,'links','2012-12-17 04:38:23',24,4,10,0,'10.228.65.94'),(18,'links','2012-12-17 04:43:39',15,4,4,0,'10.228.65.94'),(19,'links','2012-12-17 15:46:45',211,1,6,10,'150.212.31.246'),(20,'links','2012-12-17 17:03:15',222,4,6,0,'150.212.31.71'),(21,'links','2012-12-17 17:03:26',222,1,10,10,'150.212.31.246'),(22,'links','2013-01-28 20:50:53',235,4,6,0,'150.212.31.175'),(23,'links','2013-02-06 19:51:48',250,4,8,0,'150.212.31.69'),(24,'links','2013-02-13 13:33:01',15,11,10,0,'150.212.30.136'),(25,'links','2013-02-13 19:36:32',260,4,10,0,'150.212.31.210'),(26,'links','2013-02-13 19:36:39',259,4,2,0,'150.212.31.210');
/*!40000 ALTER TABLE `colfusion_votes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `colfusion_widgets`
--

DROP TABLE IF EXISTS `colfusion_widgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `colfusion_widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `version` float NOT NULL,
  `latest_version` float NOT NULL,
  `folder` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `column` enum('left','right') COLLATE utf8_unicode_ci NOT NULL,
  `position` int(11) NOT NULL,
  `display` char(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `folder` (`folder`)
) ENGINE=MyISAM AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `colfusion_widgets`
--

LOCK TABLES `colfusion_widgets` WRITE;
/*!40000 ALTER TABLE `colfusion_widgets` DISABLE KEYS */;
INSERT INTO `colfusion_widgets` VALUES (1,'Admin Panel Tools',0.1,0,'panel_tools',1,'left',4,''),(2,'Module Settings',0.1,0,'module_settings',1,'left',3,''),(3,'Statistics',0.1,0,'statistics',1,'left',1,''),(4,'Pligg CMS',0.1,0,'pligg_cms',1,'right',5,''),(5,'Pligg News',0.1,0,'pligg_news',1,'right',6,''),(6,'New products',0.1,0,'new_products',1,'left',2,'');
/*!40000 ALTER TABLE `colfusion_widgets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `statOnVerdicts`
--

DROP TABLE IF EXISTS `statOnVerdicts`;
/*!50001 DROP VIEW IF EXISTS `statOnVerdicts`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `statOnVerdicts` (
  `rel_id` tinyint NOT NULL,
  `numberOfVerdicts` tinyint NOT NULL,
  `numberOfApproved` tinyint NOT NULL,
  `numberOfReject` tinyint NOT NULL,
  `numberOfNotSure` tinyint NOT NULL,
  `avgConfidence` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

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
/*!50003 SET sql_mode              = '' */ ;
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
/*!50003 SET sql_mode              = '' */ ;
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
		--	SET @sql = CONCAT('select * from tmpTableJoined', @joinTableIndex-1, ' LIMIT ', lim);
		--	PREPARE stmt FROM @sql;
		--	EXECUTE stmt;
		--	DEALLOCATE PREPARE stmt;


			SET @sql = CONCAT('CREATE TEMPORARY TABLE resultDoJoin SELECT * FROM tmpTableJoined', @joinTableIndex-1);
			PREPARE stmt FROM @sql;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;



			SET @sql = CONCAT('drop temporary table if exists tmpTableJoined', @joinTableIndex - 1);
			PREPARE stmt FROM @sql;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;
		else
		--	SET @sql = CONCAT('select * from tmpTable', @i, ' LIMIT ', lim);
			
		--	PREPARE stmt FROM @sql;
		--	EXECUTE stmt;
		--	DEALLOCATE PREPARE stmt;

			
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
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `doJoinWithTime`(IN param1 varchar(200))
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
				
			SET @sql = CONCAT('CREATE TEMPORARY TABLE tmpTable', @i, ' SELECT * FROM (SELECT rownum, ', @sql, ' FROM colfusion_temporary where sid = ', @sid,' GROUP BY rownum) as t1 natural join (select distinct Spd, Drd, Location, AggrType, Start, End, rownum from colfusion_temporary where sid = ', @sid, ') as t2');

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
			

					SET @sql = CONCAT('CREATE TEMPORARY TABLE tmpTable', @i, ' SELECT * FROM (SELECT rownum, ', @sql, ' FROM colfusion_temporary where sid = ', @sid,' GROUP BY rownum) as t1 natural join (select distinct Spd, Drd, Location, AggrType, Start, End, rownum from colfusion_temporary where sid = ', @sid, ') as t2');

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
		--	SET @sql = CONCAT('select * from tmpTableJoined', @joinTableIndex-1, ' LIMIT ', lim);
		--	PREPARE stmt FROM @sql;
		--	EXECUTE stmt;
		--	DEALLOCATE PREPARE stmt;


			SET @sql = CONCAT('CREATE TEMPORARY TABLE resultDoJoin SELECT * FROM tmpTableJoined', @joinTableIndex-1);
			PREPARE stmt FROM @sql;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;



			SET @sql = CONCAT('drop temporary table if exists tmpTableJoined', @joinTableIndex - 1);
			PREPARE stmt FROM @sql;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;
		else
		--	SET @sql = CONCAT('select * from tmpTable', @i, ' LIMIT ', lim);
			
		--	PREPARE stmt FROM @sql;
		--	EXECUTE stmt;
		--	DEALLOCATE PREPARE stmt;

			
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
/*!50003 DROP PROCEDURE IF EXISTS `doRelationshipMining` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `doRelationshipMining`(IN param1 varchar(200))
    READS SQL DATA
BEGIN
	SET @currTime := CURRENT_TIMESTAMP;
	SET @user := 19;

	drop temporary table if exists temporaryRelationshipsTable;

	CREATE TEMPORARY TABLE temporaryRelationshipsTable
	select * 
	from (
			select distinct newDataset.sid as sid1, newDataset.cid as cl1, newDataset.tableName as tableName1, 
					theRest.sid as sid2, theRest.cid as cl2, theRest.tableName as tableName2, 
					'autogenerated' as name, 'based on complete match in dnames' as description, @user as creator, @currTime as creation_time
			
			from 
				(SELECT sid, colfusion_dnameinfo.cid, tableName, dname_chosen as nd_newDname, dname_original_name as nd_originalDname 
				FROM colfusion_dnameinfo, colfusion_columnTableInfo
				where sid = 751
				and colfusion_dnameinfo.cid = colfusion_columnTableInfo.cid
				and dname_chosen not in ('Spd', 'Drd','Start','End', 'Location', 'Aggrtype')) as newDataset,

				(SELECT sid, colfusion_dnameinfo.cid, tableName, dname_chosen as newDname, dname_original_name as original_name 
				FROM colfusion_dnameinfo, colfusion_columnTableInfo
				where sid <> 751
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

	insert ignore into colfusion_relationships(name, description, creator, creation_time, sid1, sid2) 
	select name, description, creator, creation_time, sid1, sid2 
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
-- Final view structure for view `statOnVerdicts`
--

/*!50001 DROP TABLE IF EXISTS `statOnVerdicts`*/;
/*!50001 DROP VIEW IF EXISTS `statOnVerdicts`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `statOnVerdicts` AS select `colfusion_user_relationship_verdict`.`rel_id` AS `rel_id`,count(0) AS `numberOfVerdicts`,sum(if((`colfusion_user_relationship_verdict`.`confidence` > 0),1,0)) AS `numberOfApproved`,sum(if((`colfusion_user_relationship_verdict`.`confidence` < 0),1,0)) AS `numberOfReject`,sum(if((`colfusion_user_relationship_verdict`.`confidence` = 0),1,0)) AS `numberOfNotSure`,avg(`colfusion_user_relationship_verdict`.`confidence`) AS `avgConfidence` from `colfusion_user_relationship_verdict` group by `colfusion_user_relationship_verdict`.`rel_id` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-05-10 21:03:16
