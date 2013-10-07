-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 05, 2013 at 08:25 PM
-- Server version: 5.5.31
-- PHP Version: 5.3.10-1ubuntu3.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `colfusion`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteSource`(IN param1 varchar(200))
    READS SQL DATA
BEGIN
		
	delete from colfusion_sourceinfo where sid = param1;
	delete from colfusion_links where link_id = param1;

END$$

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



END$$

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

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `doRelationshipMining`(IN param1 varchar(200))
    READS SQL DATA
BEGIN
	SET @currTime := CURRENT_TIMESTAMP;
	SET @user := 27;

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

	insert ignore into colfusion_relationships(name, description, creator, creation_time, sid1, sid2, tableName1, tableName2) 
	select name, description, creator, creation_time, sid1, sid2,tableName1, tableName2 
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

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_additional_categories`
--

CREATE TABLE IF NOT EXISTS `colfusion_additional_categories` (
  `ac_link_id` int(11) NOT NULL,
  `ac_cat_id` int(11) NOT NULL,
  UNIQUE KEY `ac_link_id` (`ac_link_id`,`ac_cat_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_cached_queries_info`
--

CREATE TABLE IF NOT EXISTS `colfusion_cached_queries_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `query` text NOT NULL,
  `server_address` varchar(345) NOT NULL,
  `port` varchar(45) NOT NULL,
  `driver` varchar(45) NOT NULL,
  `user_name` varchar(245) NOT NULL,
  `password` varchar(345) NOT NULL,
  `database` varchar(345) NOT NULL,
  `tableName` varchar(345) NOT NULL,
  `expiration_date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_canvases`
--

CREATE TABLE IF NOT EXISTS `colfusion_canvases` (
  `vid` int(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `user_id` int(20) DEFAULT NULL,
  `note` varchar(500) DEFAULT NULL,
  `mdate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `cdate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `privilege` int(1) DEFAULT NULL,
  PRIMARY KEY (`vid`),
  KEY `fk_canvases_userid` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Triggers `colfusion_canvases`
--
DROP TRIGGER IF EXISTS `canvas_insert`;
DELIMITER //
CREATE TRIGGER `canvas_insert` BEFORE INSERT ON `colfusion_canvases`
 FOR EACH ROW begin 
set new.`cdate` = now();
set new.`mdate` = now();
end
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_categories`
--

CREATE TABLE IF NOT EXISTS `colfusion_categories` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=4 ;

--
-- Dumping data for table `colfusion_categories`
--

INSERT INTO `colfusion_categories` (`category__auto_id`, `category_lang`, `category_id`, `category_parent`, `category_name`, `category_safe_name`, `rgt`, `lft`, `category_enabled`, `category_order`, `category_desc`, `category_keywords`, `category_author_level`, `category_author_group`, `category_votes`, `category_karma`) VALUES
(0, 'en', 0, 0, 'all', 'all', 7, 0, 2, 0, '', '', 'normal', '', '', ''),
(1, 'en', 1, 0, 'News', 'News', 4, 3, 1, 1, '', '', 'normal', '', '', ''),
(2, 'en', 2, 0, 'Business', 'Business', 6, 5, 1, 2, '', '', 'normal', '', '', ''),
(3, 'en', 3, 0, 'History', 'History', 2, 1, 1, 0, '', '', 'normal', '', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_charts`
--

CREATE TABLE IF NOT EXISTS `colfusion_charts` (
  `cid` int(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `vid` int(20) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `left` int(4) DEFAULT NULL,
  `top` int(4) DEFAULT NULL,
  `depth` int(4) DEFAULT NULL,
  `height` int(4) DEFAULT NULL,
  `width` int(4) DEFAULT NULL,
  `datainfo` varchar(10000) DEFAULT NULL,
  `note` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`cid`),
  KEY `fk_charts_vid` (`vid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_columnTableInfo`
--

CREATE TABLE IF NOT EXISTS `colfusion_columnTableInfo` (
  `cid` int(11) NOT NULL COMMENT 'referenced column, by this we can also reach source info',
  `tableName` varchar(255) NOT NULL COMMENT 'tables from the source database to which this column belongs',
  PRIMARY KEY (`cid`),
  KEY `fk_colfusion_columnTableInfo_1_idx` (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_comments`
--

CREATE TABLE IF NOT EXISTS `colfusion_comments` (
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
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_config`
--

CREATE TABLE IF NOT EXISTS `colfusion_config` (
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
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=108 ;

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

CREATE TABLE IF NOT EXISTS `colfusion_des_attachments` (
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
  KEY `UserId` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_dnameinfo`
--

CREATE TABLE IF NOT EXISTS `colfusion_dnameinfo` (
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
  KEY `fk_colfusion_dnameinfo_1_idx` (`sid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=66 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_dname_meta_data`
--

CREATE TABLE IF NOT EXISTS `colfusion_dname_meta_data` (
  `meta_id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) NOT NULL,
  `type` varchar(50) NOT NULL,
  `value` varchar(100) NOT NULL,
  `sid` int(11) NOT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `fk_colfusion_dname_meta_data_1_idx` (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_executeinfo`
--

CREATE TABLE IF NOT EXISTS `colfusion_executeinfo` (
  `Eid` int(11) NOT NULL AUTO_INCREMENT,
  `Sid` int(11) NOT NULL,
  `UserId` varchar(30) DEFAULT NULL,
  `TimeStart` timestamp NULL DEFAULT NULL,
  `TimeEnd` timestamp NULL DEFAULT NULL,
  `ExitStatus` varchar(20) DEFAULT NULL,
  `ErrorMessage` mediumtext,
  `RecordsProcessed` int(20) DEFAULT NULL,
  `status` text,
  `pan_command` varchar(555) DEFAULT NULL,
  `tableName` varchar(300) NOT NULL,
  PRIMARY KEY (`Eid`),
  KEY `fk_colfusion_executeinfo_1_idx` (`Sid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=13 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_formulas`
--

CREATE TABLE IF NOT EXISTS `colfusion_formulas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  `title` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `formula` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=2 ;

--
-- Dumping data for table `colfusion_formulas`
--

INSERT INTO `colfusion_formulas` (`id`, `type`, `enabled`, `title`, `formula`) VALUES
(1, 'report', 1, 'Simple Story Reporting', '$reports > $votes * 3');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_friends`
--

CREATE TABLE IF NOT EXISTS `colfusion_friends` (
  `friend_id` int(11) NOT NULL AUTO_INCREMENT,
  `friend_from` bigint(20) NOT NULL DEFAULT '0',
  `friend_to` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`friend_id`),
  UNIQUE KEY `friends_from_to` (`friend_from`,`friend_to`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_groups`
--

CREATE TABLE IF NOT EXISTS `colfusion_groups` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_group_member`
--

CREATE TABLE IF NOT EXISTS `colfusion_group_member` (
  `member_id` int(20) NOT NULL AUTO_INCREMENT,
  `member_user_id` int(20) NOT NULL,
  `member_group_id` int(20) NOT NULL,
  `member_role` enum('admin','normal','moderator','flagged','banned') CHARACTER SET utf8 NOT NULL,
  `member_status` enum('active','inactive') CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`member_id`),
  KEY `user_group` (`member_group_id`,`member_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_group_shared`
--

CREATE TABLE IF NOT EXISTS `colfusion_group_shared` (
  `share_id` int(20) NOT NULL AUTO_INCREMENT,
  `share_link_id` int(20) NOT NULL,
  `share_group_id` int(20) NOT NULL,
  `share_user_id` int(20) NOT NULL,
  PRIMARY KEY (`share_id`),
  UNIQUE KEY `share_group_id` (`share_group_id`,`share_link_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_likes`
--

CREATE TABLE IF NOT EXISTS `colfusion_likes` (
  `like_update_id` int(11) NOT NULL,
  `like_user_id` int(11) NOT NULL,
  PRIMARY KEY (`like_update_id`,`like_user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_links`
--

CREATE TABLE IF NOT EXISTS `colfusion_links` (
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

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_login_attempts`
--

CREATE TABLE IF NOT EXISTS `colfusion_login_attempts` (
  `login_id` int(11) NOT NULL AUTO_INCREMENT,
  `login_username` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `login_time` datetime NOT NULL,
  `login_ip` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `login_count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`login_id`),
  UNIQUE KEY `login_username` (`login_ip`,`login_username`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=17 ;

--
-- Dumping data for table `colfusion_login_attempts`
--

INSERT INTO `colfusion_login_attempts` (`login_id`, `login_username`, `login_time`, `login_ip`, `login_count`) VALUES
(6, 'pmanning@pitt.edu', '2013-06-26 15:53:57', '150.212.69.120', 1),
(7, 'irule', '2013-07-02 15:38:31', '24.3.21.128', 2),
(8, 'caokaisqtv', '2013-07-02 16:57:58', '150.212.46.129', 4),
(10, 'williamlion', '2013-08-04 15:31:44', '50.156.118.122', 1),
(11, 'ZhengGao', '2013-09-21 17:13:00', '24.131.86.247', 2),
(13, 'JunYin', '2013-10-02 12:07:12', '71.61.181.254', 4);

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_messages`
--

CREATE TABLE IF NOT EXISTS `colfusion_messages` (
  `idMsg` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `sender` int(11) NOT NULL DEFAULT '0',
  `receiver` int(11) NOT NULL DEFAULT '0',
  `senderLevel` int(11) NOT NULL DEFAULT '0',
  `readed` int(11) NOT NULL DEFAULT '0',
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`idMsg`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_misc_data`
--

CREATE TABLE IF NOT EXISTS `colfusion_misc_data` (
  `name` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `data` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `colfusion_misc_data`
--

INSERT INTO `colfusion_misc_data` (`name`, `data`) VALUES
('pligg_version', '1.2.2'),
('captcha_method', 'reCaptcha'),
('reCaptcha_pubkey', '6LfwKQQAAAAAAPFCNozXDIaf8GobTb7LCKQw54EA'),
('reCaptcha_prikey', '6LfwKQQAAAAAALQosKUrE4MepD0_kW7dgDZLR5P1'),
('hash', 'z^vpnZokFB39`cl7Oy7adS_pAxPpFhl'),
('validate', '0'),
('karma_submit_story', '+15'),
('karma_submit_comment', '+10'),
('karma_story_publish', '+50'),
('karma_story_vote', '+1'),
('karma_comment_vote', '0'),
('karma_story_discard', '-250'),
('karma_story_spam', '-10000'),
('karma_comment_delete', '-50'),
('status_switch', '0'),
('status_show_permalin', '1'),
('status_permalinks', '1'),
('status_inputonother', '1'),
('status_place', 'tpl_pligg_profile_info_end'),
('status_clock', '12'),
('status_results', '10'),
('status_max_chars', '1200'),
('status_avatar', 'small'),
('status_profile_level', 'god,admin,normal'),
('status_level', 'god,admin,normal'),
('status_user_email', '1'),
('status_user_comment', '1'),
('status_user_story', '1'),
('status_user_friends', '1'),
('status_user_switch', '1'),
('wrapper_directory', 'register-wrapper/'),
('temp_directory', '/temp/'),
('raw_data_directory', '/upload_raw_data/'),
('spam_trigger_light', 'arsehole\r\nass-pirate\r\nass pirate\r\nassbandit\r\nassbanger\r\nassfucker\r\nasshat\r\nasshole\r\nasspirate\r\nassshole\r\nasswipe\r\nbastard\r\nbeaner\r\nbeastiality\r\nbitch\r\nblow job\r\nblowjob\r\nbutt plug\r\nbutt-pirate\r\nbutt pirate\r\nbuttpirate\r\ncarpet muncher\r\ncarpetmuncher\r\nclit\r\ncock smoker\r\ncocksmoker\r\ncock sucker\r\ncocksucker\r\ncum dumpster\r\ncumdumpster\r\ncum slut\r\ncumslut\r\ncunnilingus\r\ncunt\r\ndick head\r\ndickhead\r\ndickwad\r\ndickweed\r\ndickwod\r\ndike\r\ndildo\r\ndouche bag\r\ndouche-bag\r\ndouchebag\r\ndyke\r\nejaculat\r\nerection\r\nfaggit\r\nfaggot\r\nfagtard\r\nfarm sex\r\nfuck\r\nfudge packer\r\nfudge-packer\r\nfudgepacker\r\ngayass\r\ngay wad\r\ngaywad\r\ngod damn\r\ngod-damn\r\ngoddamn\r\nhandjob\r\njerk off\r\njizz\r\njungle bunny\r\njungle-bunny\r\njunglebunny\r\nkike\r\nkunt\r\nnigga\r\nnigger\r\norgasm\r\npenis\r\nporch monkey\r\nporch-monkey\r\nporchmonkey\r\nprostitute\r\nqueef\r\nrimjob\r\nsexual\r\nshit\r\nspick\r\nsplooge\r\ntesticle\r\ntitty\r\ntwat\r\nvagina\r\nwank\r\nxxx\r\nabilify\r\nadderall\r\nadipex\r\nadvair diskus\r\nambien\r\naranesp\r\nbotox\r\ncelebrex\r\ncialis\r\ncrestor\r\ncyclen\r\ncyclobenzaprine\r\ncymbalta\r\ndieting\r\neffexor\r\nepogen\r\nfioricet\r\nhydrocodone\r\nionamin\r\nlamictal\r\nlevaquin\r\nlevitra\r\nlexapro\r\nlipitor\r\nmeridia\r\nnexium\r\noxycontin\r\npaxil\r\nphendimetrazine\r\nphentamine\r\nphentermine\r\npheramones\r\npherimones\r\nplavix\r\nprevacid\r\nprocrit\r\nprotonix\r\nrisperdal\r\nseroquel\r\nsingulair\r\ntopamax\r\ntramadol\r\ntrim-spa\r\nultram\r\nvalium\r\nvaltrex\r\nviagra\r\nvicodin\r\nvioxx\r\nvytorin\r\nxanax\r\nzetia\r\nzocor\r\nzoloft\r\nzyprexa\r\nzyrtec\r\n18+\r\nacai berry\r\nacai pill\r\nadults only\r\nadult web\r\napply online\r\nauto loan\r\nbest rates\r\nbulk email\r\nbuy direct\r\nbuy drugs\r\nbuy now\r\nbuy online\r\ncasino\r\ncell phone\r\nchild porn\r\ncredit card\r\ndating site\r\nday-trading\r\ndebt free\r\ndegree program\r\ndescramble\r\ndiet pill\r\ndigital cble\r\ndirect tv\r\ndoctor approved\r\ndoctor prescribed\r\ndownload full\r\ndvd and bluray\r\ndvd bluray\r\ndvd storage\r\nearn a college degree\r\nearn a degree\r\nearn extra money\r\neasy money\r\nebay secret\r\nebay shop\r\nerotic\r\nescorts\r\nexplicit\r\nfind online\r\nfire your boss\r\nfree cable\r\nfree cell phone\r\nfree dating\r\nfree degree\r\nfree diploma\r\nfree dvd\r\nfree games\r\nfree gift\r\nfree money\r\nfree offer\r\nfree phone\r\nfree reading\r\ngambling\r\nget rich quick\r\ngingivitis\r\nhealth products\r\nheartburn\r\nhormone\r\nhorny\r\nincest\r\ninsurance\r\ninvestment\r\ninvestor\r\nloan quote\r\nloose weight\r\nlow interest\r\nmake money\r\nmedical exam\r\nmedications\r\nmoney at home\r\nmortgage\r\nm0rtgage\r\nmovies online\r\nmust be 18\r\nno purchase\r\nnudist\r\nonline free\r\nonline marketing\r\nonline movies\r\nonline order\r\nonline poker\r\norder now\r\norder online\r\nover 18\r\nover 21\r\npain relief\r\npharmacy\r\nprescription\r\nproduction management\r\nrefinance\r\nremoves wrinkles\r\nrolex\r\nsatellite tv\r\nsavings on\r\nsearch engine\r\nsexcapades\r\nstop snoring\r\nstop spam\r\nvacation offers\r\nvideo recorder\r\nvirgin\r\nweight reduction\r\nwork at home'),
('upload_thumb', '1'),
('upload_sizes', 'a:1:{i:0;s:7:"200x200";}'),
('upload_display', 'a:1:{s:7:"150x150";s:1:"1";}'),
('upload_fields', 'YTowOnt9'),
('upload_alternates', 'YToxOntpOjE7czowOiIiO30='),
('upload_mandatory', 'a:0:{}'),
('upload_place', 'tpl_link_summary_pre_story_content'),
('upload_external', 'file,url'),
('upload_link', 'orig'),
('upload_quality', '80'),
('upload_directory', '/modules/upload/attachments'),
('upload_thdirectory', '/modules/upload/attachments/thumbs'),
('upload_filesize', '200'),
('upload_maxnumber', '1'),
('upload_extensions', 'jpg jpeg png gif'),
('upload_defsize', '200x200'),
('upload_fileplace', 'tpl_pligg_story_who_voted_start'),
('pagesize', '50');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_modules`
--

CREATE TABLE IF NOT EXISTS `colfusion_modules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `version` float NOT NULL,
  `latest_version` float NOT NULL,
  `folder` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_old_urls`
--

CREATE TABLE IF NOT EXISTS `colfusion_old_urls` (
  `old_id` int(11) NOT NULL AUTO_INCREMENT,
  `old_link_id` int(11) NOT NULL,
  `old_title_url` varchar(255) NOT NULL,
  PRIMARY KEY (`old_id`),
  KEY `old_title_url` (`old_title_url`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_redirects`
--

CREATE TABLE IF NOT EXISTS `colfusion_redirects` (
  `redirect_id` int(11) NOT NULL AUTO_INCREMENT,
  `redirect_old` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `redirect_new` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`redirect_id`),
  KEY `redirect_old` (`redirect_old`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_relationships`
--

CREATE TABLE IF NOT EXISTS `colfusion_relationships` (
  `rel_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` text,
  `creator` int(11) NOT NULL,
  `creation_time` datetime NOT NULL,
  `sid1` int(11) NOT NULL,
  `sid2` int(11) NOT NULL,
  `tableName1` varchar(255) DEFAULT NULL,
  `tableName2` varchar(255) DEFAULT NULL,
  `status` int(1) NOT NULL DEFAULT '0' COMMENT '0->valid, 1->deleted',
  PRIMARY KEY (`rel_id`),
  KEY `fk_colfusion_relationships_1_idx` (`creator`),
  KEY `fk_colfusion_relationships_2_idx` (`sid1`),
  KEY `fk_colfusion_relationships_3_idx` (`sid2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_relationships_columns`
--

CREATE TABLE IF NOT EXISTS `colfusion_relationships_columns` (
  `rel_id` int(11) NOT NULL,
  `cl_from` varchar(255) NOT NULL,
  `cl_to` varchar(255) NOT NULL,
  `dataMatchingFromRatio` decimal(4,2) DEFAULT NULL,
  `dataMatchingToRatio` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`rel_id`,`cl_from`,`cl_to`),
  KEY `fk_new_table_1_idx` (`rel_id`),
  KEY `fk_new_table_2_idx` (`cl_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_relationships_columns_cachingExecutionInfo`
--

CREATE TABLE IF NOT EXISTS `colfusion_relationships_columns_cachingExecutionInfo` (
  `transformation` varchar(255) NOT NULL,
  `status` text,
  `timeStart` timestamp NULL DEFAULT NULL,
  `timeEnd` timestamp NULL DEFAULT NULL,
  `errorMessage` text,
  `query` text,
  PRIMARY KEY (`transformation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_saved_links`
--

CREATE TABLE IF NOT EXISTS `colfusion_saved_links` (
  `saved_id` int(11) NOT NULL AUTO_INCREMENT,
  `saved_user_id` int(11) NOT NULL,
  `saved_link_id` int(11) NOT NULL,
  `saved_privacy` enum('private','public') CHARACTER SET utf8 NOT NULL DEFAULT 'public',
  PRIMARY KEY (`saved_id`),
  KEY `saved_user_id` (`saved_user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_shares`
--

CREATE TABLE IF NOT EXISTS `colfusion_shares` (
  `vid` int(20) DEFAULT NULL,
  `user_id` int(20) DEFAULT NULL,
  `privilege` int(1) DEFAULT NULL,
  UNIQUE KEY `vid` (`vid`,`user_id`),
  KEY `fk_shares_userid` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_sourceinfo`
--

CREATE TABLE IF NOT EXISTS `colfusion_sourceinfo` (
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
  KEY `UserId` (`UserId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=830 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_sourceinfo_DB`
--

CREATE TABLE IF NOT EXISTS `colfusion_sourceinfo_DB` (
  `sid` int(11) NOT NULL,
  `server_address` varchar(255) NOT NULL,
  `port` int(11) NOT NULL,
  `user_name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `source_database` varchar(255) NOT NULL,
  `driver` varchar(255) NOT NULL,
  `is_local` int(11) DEFAULT '1' COMMENT '1 - means database was created from dump file and is stored on our server,\n0 - means that database was submitted as remote database and the data is stored somewhere not on our server',
  `linked_server_name` varchar(255) DEFAULT NULL COMMENT 'Stores linked server name of the database. This value will be different only for remotely submitted databases because we give collusion internal name for them when create a linked server. ',
  PRIMARY KEY (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Stores information about the dataset which was submitted as database';

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_synonyms_from`
--

CREATE TABLE IF NOT EXISTS `colfusion_synonyms_from` (
  `syn_id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `tableName` varchar(255) NOT NULL,
  `transInput` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  KEY `syn_id` (`syn_id`,`transInput`),
  KEY `fk_synfrom_sid` (`sid`),
  KEY `userId` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_synonyms_to`
--

CREATE TABLE IF NOT EXISTS `colfusion_synonyms_to` (
  `syn_id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `tableName` varchar(255) NOT NULL,
  `transInput` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  KEY `syn_id` (`syn_id`,`transInput`),
  KEY `fk_synfrom_sid` (`sid`),
  KEY `userId` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_tags`
--

CREATE TABLE IF NOT EXISTS `colfusion_tags` (
  `tag_link_id` int(11) NOT NULL DEFAULT '0',
  `tag_lang` varchar(4) COLLATE utf8_unicode_ci DEFAULT 'en',
  `tag_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `tag_words` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY `tag_link_id` (`tag_link_id`,`tag_lang`,`tag_words`),
  KEY `tag_lang` (`tag_lang`,`tag_date`),
  KEY `tag_words` (`tag_words`,`tag_link_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_tag_cache`
--

CREATE TABLE IF NOT EXISTS `colfusion_tag_cache` (
  `tag_words` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `count` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_target`
--

CREATE TABLE IF NOT EXISTS `colfusion_target` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_temporary`
--

CREATE TABLE IF NOT EXISTS `colfusion_temporary` (
  `Tid` int(11) NOT NULL AUTO_INCREMENT,
  `Sid` int(11) NOT NULL,
  `Spd` date DEFAULT NULL,
  `Drd` date DEFAULT NULL,
  `Dname` varchar(80) DEFAULT NULL,
  `Location` varchar(255) DEFAULT NULL,
  `AggrType` varchar(255) DEFAULT NULL,
  `Start` date DEFAULT NULL,
  `End` date DEFAULT NULL,
  `Value` varchar(500) DEFAULT NULL,
  `Eid` int(11) NOT NULL,
  `rownum` int(11) DEFAULT NULL,
  `columnnum` int(11) DEFAULT NULL,
  `cid` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`Tid`),
  KEY `fk_colfusion_temporary_1_idx` (`Sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_totals`
--

CREATE TABLE IF NOT EXISTS `colfusion_totals` (
  `name` varchar(10) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `total` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `colfusion_totals`
--

INSERT INTO `colfusion_totals` (`name`, `total`) VALUES
('published', 0),
('queued', 0),
('discard', 0);

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_trackbacks`
--

CREATE TABLE IF NOT EXISTS `colfusion_trackbacks` (
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
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_updates`
--

CREATE TABLE IF NOT EXISTS `colfusion_updates` (
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
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_users`
--

CREATE TABLE IF NOT EXISTS `colfusion_users` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=32 ;

--
-- Dumping data for table `colfusion_users`
--

INSERT INTO `colfusion_users` (`user_id`, `user_login`, `user_level`, `user_modification`, `user_date`, `user_pass`, `user_email`, `user_names`, `user_karma`, `user_url`, `user_lastlogin`, `user_aim`, `user_msn`, `user_yahoo`, `user_gtalk`, `user_skype`, `user_irc`, `public_email`, `user_avatar_source`, `user_ip`, `user_lastip`, `last_reset_request`, `last_email_friend`, `last_reset_code`, `user_location`, `user_occupation`, `user_categories`, `user_enabled`, `user_language`, `status_switch`, `status_friends`, `status_story`, `status_comment`, `status_email`, `status_group`, `status_all_friends`, `status_friend_list`, `status_excludes`) VALUES
(26, 'Evgeny', 'god', '2013-10-04 01:53:55', '2013-06-21 14:02:57', '4e7838f51bd8680fbfaee8e2ba2f54d9987c0779d3f1a9c84', 'karataev.evgeny@gmail.com', '', 0.00, '', '2013-10-04 01:53:55', '', '', '', '', '', 'admin', '', 'useruploaded', '10.228.65.112', '10.228.65.115', '2013-06-24 12:47:29', '0000-00-00 00:00:00', '11fd1796e9abc344ea287d3488628a3c9c993bdc1f7c56bf7', '', '', '', 1, 'english', 1, 1, 1, 1, 1, 1, 1, NULL, NULL),
(27, 'Colfusion_AI', 'normal', '2013-06-24 15:15:20', '2013-06-24 15:15:20', '19ad8bddc15c95a0f84e4e317b0c617258c9675ab4a782aca', 'kzheka@hotmail.com', NULL, 0.00, NULL, '2013-06-24 15:15:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '10.228.65.112', '10.228.65.112', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, NULL, '', 1, NULL, 1, 1, 1, 1, 1, 1, 1, NULL, NULL),
(28, 'gintau', 'normal', '2013-06-26 14:39:02', '2013-06-26 14:39:02', 'ee7272a32ced851337dd42fb38003b48a73ce6e50d0149c7c', 'gintau2000@gmail.com', NULL, 0.00, NULL, '2013-06-26 14:39:02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '67.172.17.136', '67.172.17.136', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, NULL, '', 1, NULL, 1, 1, 1, 1, 1, 1, 1, NULL, NULL),
(29, 'PatManning', 'normal', '2013-06-26 19:58:20', '2013-06-26 19:58:20', 'dbae0c3e2a7a2923055c5dc47d1ee11197a5007f89aaeb100', 'pmanning@pitt.edu', NULL, 0.00, NULL, '2013-06-26 19:58:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '150.212.69.120', '150.212.69.120', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, NULL, '', 1, NULL, 1, 1, 1, 1, 1, 1, 1, NULL, NULL),
(30, 'caokaisqtv', 'normal', '2013-07-02 20:59:01', '2013-07-02 20:59:01', '14ff86ecff14a705fc0cba609c97c901ba8e31c8007275919', 'caokaisqtv@gmail.com', NULL, 0.00, NULL, '2013-07-02 20:59:01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '150.212.46.129', '150.212.46.129', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, NULL, '', 1, NULL, 1, 1, 1, 1, 1, 1, 1, NULL, NULL),
(31, 'dataverse', 'normal', '2013-09-30 02:04:17', '2013-09-25 19:05:26', 'fb5a0b7950b27484840b4580c26ea654a52abe725effa65fd', 'dataverse@dataverse.com', NULL, 0.00, NULL, '2013-09-30 02:04:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '10.228.65.115', '67.186.56.85', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, NULL, '', 1, NULL, 1, 1, 1, 1, 1, 1, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_user_relationship_verdict`
--

CREATE TABLE IF NOT EXISTS `colfusion_user_relationship_verdict` (
  `rel_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `confidence` decimal(3,2) NOT NULL,
  `comment` text,
  `when` datetime NOT NULL,
  PRIMARY KEY (`rel_id`,`user_id`),
  KEY `fk_colfusion_user_relationship_verdict_1_idx` (`rel_id`),
  KEY `fk_colfusion_user_relationship_verdict_2_idx` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_validation_code`
--

CREATE TABLE IF NOT EXISTS `colfusion_validation_code` (
  `email` varchar(100) NOT NULL,
  `vcode` varchar(20) NOT NULL,
  `isUsed` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `colfusion_validation_code`
--

INSERT INTO `colfusion_validation_code` (`email`, `vcode`, `isUsed`) VALUES
('karataev.evgeny@gmail.com', 'mdGcixC7BIP08v7', 1),
('kzheka@hotmail.com', '5R5GxtnMxQVuOrZ', 1),
('gintau2000@gmail.com', 'KFqgmeR1QEpcaWA', 1),
('kzheka@hotmail.com', 'XUd3NKWWhWSSJci', 0),
('vladimir@sis.pitt.edu', '3biOZ6bgsScc1wq', 0),
('pmanning@pitt.edu', 'y59TFMv5zjbukoP', 1),
('caokaisqtv@gmail.com', 'Hr0Zf06rgyjtLl0', 1),
('hanmorgan88@gmail.com', 'N85k3qEzN9RBsAX', 0),
('dataverse@dataverse.com', 'g4ixRV8MzNp4gPh', 1);

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_visualization`
--

CREATE TABLE IF NOT EXISTS `colfusion_visualization` (
  `vid` varchar(20) NOT NULL,
  `type` varchar(50) NOT NULL,
  `userid` int(11) NOT NULL,
  `titleno` int(11) NOT NULL DEFAULT '0',
  `top` int(11) NOT NULL DEFAULT '80',
  `left` int(11) NOT NULL DEFAULT '0',
  `width` int(11) NOT NULL DEFAULT '500',
  `height` int(11) NOT NULL DEFAULT '400',
  `setting` varchar(500) NOT NULL,
  PRIMARY KEY (`vid`),
  KEY `fk_colfusion_visualization_1_idx` (`titleno`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_votes`
--

CREATE TABLE IF NOT EXISTS `colfusion_votes` (
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
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_widgets`
--

CREATE TABLE IF NOT EXISTS `colfusion_widgets` (
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
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=7 ;

--
-- Dumping data for table `colfusion_widgets`
--

INSERT INTO `colfusion_widgets` (`id`, `name`, `version`, `latest_version`, `folder`, `enabled`, `column`, `position`, `display`) VALUES
(1, 'Admin Panel Tools', 0.1, 0, 'panel_tools', 1, 'left', 4, ''),
(2, 'Module Settings', 0.1, 0, 'module_settings', 1, 'left', 3, ''),
(3, 'Statistics', 0.1, 0, 'statistics', 1, 'left', 1, ''),
(4, 'Pligg CMS', 0.1, 0, 'pligg_cms', 1, 'right', 5, ''),
(5, 'Pligg News', 0.1, 0, 'pligg_news', 1, 'right', 6, ''),
(6, 'New products', 0.1, 0, 'new_products', 1, 'left', 2, '');

-- --------------------------------------------------------

--
-- Stand-in structure for view `statOnVerdicts`
--
CREATE TABLE IF NOT EXISTS `statOnVerdicts` (
`rel_id` int(11)
,`numberOfVerdicts` bigint(21)
,`numberOfApproved` decimal(23,0)
,`numberOfReject` decimal(23,0)
,`numberOfNotSure` decimal(23,0)
,`avgConfidence` decimal(7,6)
);
-- --------------------------------------------------------

--
-- Structure for view `statOnVerdicts`
--
DROP TABLE IF EXISTS `statOnVerdicts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `statOnVerdicts` AS select `colfusion_user_relationship_verdict`.`rel_id` AS `rel_id`,count(0) AS `numberOfVerdicts`,sum(if((`colfusion_user_relationship_verdict`.`confidence` > 0),1,0)) AS `numberOfApproved`,sum(if((`colfusion_user_relationship_verdict`.`confidence` < 0),1,0)) AS `numberOfReject`,sum(if((`colfusion_user_relationship_verdict`.`confidence` = 0),1,0)) AS `numberOfNotSure`,avg(`colfusion_user_relationship_verdict`.`confidence`) AS `avgConfidence` from `colfusion_user_relationship_verdict` group by `colfusion_user_relationship_verdict`.`rel_id`;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `colfusion_canvases`
--
ALTER TABLE `colfusion_canvases`
  ADD CONSTRAINT `fk_canvases_userid` FOREIGN KEY (`user_id`) REFERENCES `colfusion_users` (`user_id`);

--
-- Constraints for table `colfusion_charts`
--
ALTER TABLE `colfusion_charts`
  ADD CONSTRAINT `fk_charts_vid` FOREIGN KEY (`vid`) REFERENCES `colfusion_canvases` (`vid`);

--
-- Constraints for table `colfusion_columnTableInfo`
--
ALTER TABLE `colfusion_columnTableInfo`
  ADD CONSTRAINT `fk_colfusion_columnTableInfo_1` FOREIGN KEY (`cid`) REFERENCES `colfusion_dnameinfo` (`cid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `colfusion_des_attachments`
--
ALTER TABLE `colfusion_des_attachments`
  ADD CONSTRAINT `colfusion_des_attachments_ibfk_1` FOREIGN KEY (`Sid`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `colfusion_des_attachments_ibfk_2` FOREIGN KEY (`UserId`) REFERENCES `colfusion_users` (`user_id`);

--
-- Constraints for table `colfusion_dnameinfo`
--
ALTER TABLE `colfusion_dnameinfo`
  ADD CONSTRAINT `fk_colfusion_dnameinfo_1` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `colfusion_dname_meta_data`
--
ALTER TABLE `colfusion_dname_meta_data`
  ADD CONSTRAINT `fk_colfusion_dname_meta_data_1` FOREIGN KEY (`cid`) REFERENCES `colfusion_dnameinfo` (`cid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `colfusion_executeinfo`
--
ALTER TABLE `colfusion_executeinfo`
  ADD CONSTRAINT `fk_colfusion_executeinfo_1` FOREIGN KEY (`Sid`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `colfusion_relationships`
--
ALTER TABLE `colfusion_relationships`
  ADD CONSTRAINT `fk_colfusion_relationships_1` FOREIGN KEY (`creator`) REFERENCES `colfusion_users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_colfusion_relationships_2` FOREIGN KEY (`sid1`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_colfusion_relationships_3` FOREIGN KEY (`sid2`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `colfusion_relationships_columns`
--
ALTER TABLE `colfusion_relationships_columns`
  ADD CONSTRAINT `fk_new_table_1` FOREIGN KEY (`rel_id`) REFERENCES `colfusion_relationships` (`rel_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `colfusion_shares`
--
ALTER TABLE `colfusion_shares`
  ADD CONSTRAINT `fk_shares_userid` FOREIGN KEY (`user_id`) REFERENCES `colfusion_users` (`user_id`),
  ADD CONSTRAINT `fk_shares_vid` FOREIGN KEY (`vid`) REFERENCES `colfusion_canvases` (`vid`);

--
-- Constraints for table `colfusion_sourceinfo`
--
ALTER TABLE `colfusion_sourceinfo`
  ADD CONSTRAINT `colfusion_sourceinfo_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `colfusion_users` (`user_id`),
  ADD CONSTRAINT `colfusion_sourceinfo_ibfk_2` FOREIGN KEY (`UserId`) REFERENCES `colfusion_users` (`user_id`);

--
-- Constraints for table `colfusion_sourceinfo_DB`
--
ALTER TABLE `colfusion_sourceinfo_DB`
  ADD CONSTRAINT `colfusion_sourceinfo_DB_ibfk_1` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `colfusion_synonyms_from`
--
ALTER TABLE `colfusion_synonyms_from`
  ADD CONSTRAINT `colfusion_synonyms_from_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `colfusion_users` (`user_id`),
  ADD CONSTRAINT `fk_synfrom_sid` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `colfusion_synonyms_to`
--
ALTER TABLE `colfusion_synonyms_to`
  ADD CONSTRAINT `colfusion_synonyms_to_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `colfusion_users` (`user_id`),
  ADD CONSTRAINT `fk_synto_sid` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `colfusion_temporary`
--
ALTER TABLE `colfusion_temporary`
  ADD CONSTRAINT `fk_colfusion_temporary_1` FOREIGN KEY (`Sid`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `colfusion_user_relationship_verdict`
--
ALTER TABLE `colfusion_user_relationship_verdict`
  ADD CONSTRAINT `fk_colfusion_user_relationship_verdict_1` FOREIGN KEY (`rel_id`) REFERENCES `colfusion_relationships` (`rel_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_colfusion_user_relationship_verdict_2` FOREIGN KEY (`user_id`) REFERENCES `colfusion_users` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `colfusion_visualization`
--
ALTER TABLE `colfusion_visualization`
  ADD CONSTRAINT `fk_colfusion_visualization_1` FOREIGN KEY (`titleno`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
