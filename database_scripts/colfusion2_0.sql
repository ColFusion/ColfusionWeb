-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 16, 2015 at 02:19 PM
-- Server version: 5.5.43-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `colfusion2_0`
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `doRelationshipMining`(IN `param1` VARCHAR(200))
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

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_additional_categories`
--

CREATE TABLE IF NOT EXISTS `colfusion_additional_categories` (
  `ac_link_id` int(11) NOT NULL,
  `ac_cat_id` int(11) NOT NULL,
  PRIMARY KEY (`ac_link_id`,`ac_cat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_cached_queries_info`
--

CREATE TABLE IF NOT EXISTS `colfusion_cached_queries_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `query` longtext CHARACTER SET utf8 NOT NULL,
  `server_address` longtext CHARACTER SET utf8 NOT NULL,
  `port` varchar(45) CHARACTER SET utf8 NOT NULL,
  `driver` varchar(45) CHARACTER SET utf8 NOT NULL,
  `user_name` varchar(245) CHARACTER SET utf8 NOT NULL,
  `password` longtext CHARACTER SET utf8 NOT NULL,
  `database` longtext CHARACTER SET utf8 NOT NULL,
  `tableName` longtext CHARACTER SET utf8 NOT NULL,
  `expiration_date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_canvases`
--

CREATE TABLE IF NOT EXISTS `colfusion_canvases` (
  `vid` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `note` longtext CHARACTER SET utf8,
  `mdate` datetime NOT NULL,
  `cdate` datetime NOT NULL,
  `privilege` int(11) DEFAULT NULL,
  PRIMARY KEY (`vid`),
  KEY `FK_rrd90u4au11k7m0y7ys7wasw1` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_categories`
--

CREATE TABLE IF NOT EXISTS `colfusion_categories` (
  `category__auto_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_lang` varchar(2) CHARACTER SET utf8 DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `category_parent` int(11) NOT NULL,
  `category_name` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `category_safe_name` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `rgt` int(11) NOT NULL,
  `lft` int(11) NOT NULL,
  `category_enabled` int(11) NOT NULL,
  `category_order` int(11) NOT NULL,
  `category_desc` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `category_keywords` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `category_author_level` varchar(7) CHARACTER SET utf8 NOT NULL,
  `category_author_group` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `category_votes` varchar(4) CHARACTER SET utf8 NOT NULL,
  `category_karma` varchar(4) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`category__auto_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

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
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `vid` int(11) DEFAULT NULL,
  `name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `type` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `left` int(11) DEFAULT NULL,
  `top` int(11) DEFAULT NULL,
  `depth` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `datainfo` longtext CHARACTER SET utf8,
  `note` longtext CHARACTER SET utf8,
  PRIMARY KEY (`cid`),
  KEY `FK_lym1jififkghqs6a4q15gwq5p` (`vid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_columnTableInfo`
--

CREATE TABLE IF NOT EXISTS `colfusion_columnTableInfo` (
  `cid` int(11) NOT NULL,
  `tableName` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT 'tables from the source database to which this column belongs',
  PRIMARY KEY (`cid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `colfusion_columnTableInfo`
--

INSERT INTO `colfusion_columnTableInfo` (`cid`, `tableName`) VALUES
(10, 'Sheet1'),
(11, 'Sheet1'),
(12, 'Sheet1'),
(13, 'Sheet1'),
(14, 'Sheet1'),
(15, 'Sheet1');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_comments`
--

CREATE TABLE IF NOT EXISTS `colfusion_comments` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `comment_randkey` int(11) NOT NULL,
  `comment_parent` int(11) DEFAULT NULL,
  `comment_link_id` int(11) NOT NULL,
  `comment_user_id` int(11) NOT NULL,
  `comment_date` datetime NOT NULL,
  `comment_karma` smallint(6) NOT NULL,
  `comment_content` longtext CHARACTER SET utf8,
  `comment_votes` int(11) NOT NULL,
  `comment_status` varchar(9) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`comment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_config`
--

CREATE TABLE IF NOT EXISTS `colfusion_config` (
  `var_id` int(11) NOT NULL AUTO_INCREMENT,
  `var_page` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `var_name` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `var_value` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `var_defaultvalue` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `var_optiontext` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `var_title` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `var_desc` longtext CHARACTER SET utf8,
  `var_method` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `var_enclosein` varchar(5) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`var_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=108 ;

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
  `Title` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT 'Filename shown at webpage.',
  `Filename` varchar(255) CHARACTER SET utf8 NOT NULL COMMENT 'Real filename (to avoid overwriting existing files.)',
  `Description` longtext CHARACTER SET utf8,
  `Size` int(11) DEFAULT NULL,
  `Upload_time` datetime DEFAULT NULL,
  PRIMARY KEY (`FileId`),
  KEY `FK_5mhqsvq21yu9gh58ugt9y5uo8` (`Sid`),
  KEY `FK_oh83r9dat33w96070dew57c5i` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_dnameinfo`
--

CREATE TABLE IF NOT EXISTS `colfusion_dnameinfo` (
  `cid` int(11) NOT NULL AUTO_INCREMENT,
  `sid` int(11) NOT NULL,
  `dname_chosen` varchar(100) CHARACTER SET utf8 NOT NULL,
  `dname_value_type` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `dname_value_unit` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `dname_value_format` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  `dname_value_description` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `dname_original_name` varchar(200) CHARACTER SET utf8 NOT NULL COMMENT 'This table stores information about each column in any submitted dataset',
  `isConstant` bit(1) NOT NULL COMMENT 'if user is submitting database and on matching chema they provide input value, this flagg will be set',
  `constant_value` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT 'if user is submitting database and on matching chema they provide input value, the value will be stored here',
  `missing_value` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`cid`),
  KEY `FK_ry8xyg3e3a0hi225q8k0195q6` (`sid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=16 ;

--
-- Dumping data for table `colfusion_dnameinfo`
--

INSERT INTO `colfusion_dnameinfo` (`cid`, `sid`, `dname_chosen`, `dname_value_type`, `dname_value_unit`, `dname_value_format`, `dname_value_description`, `dname_original_name`, `isConstant`, `constant_value`, `missing_value`) VALUES
(1, 5, 'A', 'String', NULL, NULL, NULL, 'A', b'0', NULL, NULL),
(2, 5, 'B', 'String', NULL, NULL, NULL, 'B', b'0', NULL, NULL),
(3, 5, 'C', 'String', NULL, NULL, NULL, 'C', b'0', NULL, NULL),
(4, 6, 'A', 'String', NULL, NULL, NULL, 'A', b'0', NULL, NULL),
(5, 6, 'B', 'String', NULL, NULL, NULL, 'B', b'0', NULL, NULL),
(6, 6, 'C', 'String', NULL, NULL, NULL, 'C', b'0', NULL, NULL),
(7, 10, 'A', 'String', NULL, NULL, NULL, 'A', b'0', NULL, NULL),
(8, 10, 'B', 'String', NULL, NULL, NULL, 'B', b'0', NULL, NULL),
(9, 10, 'C', 'String', NULL, NULL, NULL, 'C', b'0', NULL, NULL),
(10, 11, 'A', 'String', NULL, NULL, NULL, 'A', b'0', NULL, NULL),
(11, 11, 'B', 'String', NULL, NULL, NULL, 'B', b'0', NULL, NULL),
(12, 11, 'C', 'String', NULL, NULL, NULL, 'C', b'0', NULL, NULL),
(13, 13, 'A', 'String', NULL, NULL, NULL, 'A', b'0', NULL, NULL),
(14, 13, 'B', 'String', NULL, NULL, NULL, 'B', b'0', NULL, NULL),
(15, 13, 'C', 'String', NULL, NULL, NULL, 'C', b'0', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_dnameinfo_metadata_edit_history`
--

CREATE TABLE IF NOT EXISTS `colfusion_dnameinfo_metadata_edit_history` (
  `hid` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) NOT NULL COMMENT 'column id',
  `uid` int(11) NOT NULL COMMENT 'userid who made edit',
  `whenSaved` datetime NOT NULL COMMENT 'when the edit was done',
  `editedAttribute` varchar(14) CHARACTER SET utf8 NOT NULL,
  `reason` longtext CHARACTER SET utf8,
  `value` longtext CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`hid`),
  KEY `FK_tknft8ptxphm2bnwca6g2di6k` (`cid`),
  KEY `FK_6qtapop8o9y3asb5d3ma7ngw4` (`uid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=91 ;

--
-- Dumping data for table `colfusion_dnameinfo_metadata_edit_history`
--

INSERT INTO `colfusion_dnameinfo_metadata_edit_history` (`hid`, `cid`, `uid`, `whenSaved`, `editedAttribute`, `reason`, `value`) VALUES
(1, 1, 26, '2015-06-14 23:53:18', 'chosen name', '', 'A'),
(2, 1, 26, '2015-06-14 23:53:18', 'data type', '', 'String'),
(3, 1, 26, '2015-06-14 23:53:18', 'description', '', ''),
(4, 1, 26, '2015-06-14 23:53:18', 'value unit', '', ''),
(5, 1, 26, '2015-06-14 23:53:18', 'format', '', ''),
(6, 1, 26, '2015-06-14 23:53:18', 'missing value', '', ''),
(7, 2, 26, '2015-06-14 23:53:18', 'chosen name', '', 'B'),
(8, 2, 26, '2015-06-14 23:53:18', 'data type', '', 'String'),
(9, 2, 26, '2015-06-14 23:53:18', 'description', '', ''),
(10, 2, 26, '2015-06-14 23:53:18', 'value unit', '', ''),
(11, 2, 26, '2015-06-14 23:53:18', 'format', '', ''),
(12, 2, 26, '2015-06-14 23:53:18', 'missing value', '', ''),
(13, 3, 26, '2015-06-14 23:53:18', 'chosen name', '', 'C'),
(14, 3, 26, '2015-06-14 23:53:18', 'data type', '', 'String'),
(15, 3, 26, '2015-06-14 23:53:18', 'description', '', ''),
(16, 3, 26, '2015-06-14 23:53:18', 'value unit', '', ''),
(17, 3, 26, '2015-06-14 23:53:18', 'format', '', ''),
(18, 3, 26, '2015-06-14 23:53:18', 'missing value', '', ''),
(19, 4, 26, '2015-06-15 00:16:32', 'chosen name', '', 'A'),
(20, 4, 26, '2015-06-15 00:16:32', 'data type', '', 'String'),
(21, 4, 26, '2015-06-15 00:16:32', 'description', '', ''),
(22, 4, 26, '2015-06-15 00:16:32', 'value unit', '', ''),
(23, 4, 26, '2015-06-15 00:16:32', 'format', '', ''),
(24, 4, 26, '2015-06-15 00:16:32', 'missing value', '', ''),
(25, 5, 26, '2015-06-15 00:16:32', 'chosen name', '', 'B'),
(26, 5, 26, '2015-06-15 00:16:32', 'data type', '', 'String'),
(27, 5, 26, '2015-06-15 00:16:32', 'description', '', ''),
(28, 5, 26, '2015-06-15 00:16:32', 'value unit', '', ''),
(29, 5, 26, '2015-06-15 00:16:32', 'format', '', ''),
(30, 5, 26, '2015-06-15 00:16:32', 'missing value', '', ''),
(31, 6, 26, '2015-06-15 00:16:32', 'chosen name', '', 'C'),
(32, 6, 26, '2015-06-15 00:16:32', 'data type', '', 'String'),
(33, 6, 26, '2015-06-15 00:16:32', 'description', '', ''),
(34, 6, 26, '2015-06-15 00:16:32', 'value unit', '', ''),
(35, 6, 26, '2015-06-15 00:16:32', 'format', '', ''),
(36, 6, 26, '2015-06-15 00:16:32', 'missing value', '', ''),
(37, 7, 26, '2015-06-15 00:38:19', 'chosen name', '', 'A'),
(38, 7, 26, '2015-06-15 00:38:19', 'data type', '', 'String'),
(39, 7, 26, '2015-06-15 00:38:19', 'description', '', ''),
(40, 7, 26, '2015-06-15 00:38:19', 'value unit', '', ''),
(41, 7, 26, '2015-06-15 00:38:19', 'format', '', ''),
(42, 7, 26, '2015-06-15 00:38:19', 'missing value', '', ''),
(43, 8, 26, '2015-06-15 00:38:19', 'chosen name', '', 'B'),
(44, 8, 26, '2015-06-15 00:38:19', 'data type', '', 'String'),
(45, 8, 26, '2015-06-15 00:38:19', 'description', '', ''),
(46, 8, 26, '2015-06-15 00:38:19', 'value unit', '', ''),
(47, 8, 26, '2015-06-15 00:38:19', 'format', '', ''),
(48, 8, 26, '2015-06-15 00:38:19', 'missing value', '', ''),
(49, 9, 26, '2015-06-15 00:38:19', 'chosen name', '', 'C'),
(50, 9, 26, '2015-06-15 00:38:19', 'data type', '', 'String'),
(51, 9, 26, '2015-06-15 00:38:19', 'description', '', ''),
(52, 9, 26, '2015-06-15 00:38:19', 'value unit', '', ''),
(53, 9, 26, '2015-06-15 00:38:19', 'format', '', ''),
(54, 9, 26, '2015-06-15 00:38:19', 'missing value', '', ''),
(55, 10, 26, '2015-06-15 00:52:42', 'chosen name', '', 'A'),
(56, 10, 26, '2015-06-15 00:52:42', 'data type', '', 'String'),
(57, 10, 26, '2015-06-15 00:52:42', 'description', '', ''),
(58, 10, 26, '2015-06-15 00:52:42', 'value unit', '', ''),
(59, 10, 26, '2015-06-15 00:52:42', 'format', '', ''),
(60, 10, 26, '2015-06-15 00:52:42', 'missing value', '', ''),
(61, 11, 26, '2015-06-15 00:52:42', 'chosen name', '', 'B'),
(62, 11, 26, '2015-06-15 00:52:42', 'data type', '', 'String'),
(63, 11, 26, '2015-06-15 00:52:42', 'description', '', ''),
(64, 11, 26, '2015-06-15 00:52:42', 'value unit', '', ''),
(65, 11, 26, '2015-06-15 00:52:42', 'format', '', ''),
(66, 11, 26, '2015-06-15 00:52:42', 'missing value', '', ''),
(67, 12, 26, '2015-06-15 00:52:43', 'chosen name', '', 'C'),
(68, 12, 26, '2015-06-15 00:52:43', 'data type', '', 'String'),
(69, 12, 26, '2015-06-15 00:52:43', 'description', '', ''),
(70, 12, 26, '2015-06-15 00:52:43', 'value unit', '', ''),
(71, 12, 26, '2015-06-15 00:52:43', 'format', '', ''),
(72, 12, 26, '2015-06-15 00:52:43', 'missing value', '', ''),
(73, 13, 26, '2015-06-15 18:14:45', 'chosen name', '', 'A'),
(74, 13, 26, '2015-06-15 18:14:45', 'data type', '', 'String'),
(75, 13, 26, '2015-06-15 18:14:45', 'description', '', ''),
(76, 13, 26, '2015-06-15 18:14:45', 'value unit', '', ''),
(77, 13, 26, '2015-06-15 18:14:45', 'format', '', ''),
(78, 13, 26, '2015-06-15 18:14:45', 'missing value', '', ''),
(79, 14, 26, '2015-06-15 18:14:45', 'chosen name', '', 'B'),
(80, 14, 26, '2015-06-15 18:14:45', 'data type', '', 'String'),
(81, 14, 26, '2015-06-15 18:14:45', 'description', '', ''),
(82, 14, 26, '2015-06-15 18:14:45', 'value unit', '', ''),
(83, 14, 26, '2015-06-15 18:14:45', 'format', '', ''),
(84, 14, 26, '2015-06-15 18:14:45', 'missing value', '', ''),
(85, 15, 26, '2015-06-15 18:14:45', 'chosen name', '', 'C'),
(86, 15, 26, '2015-06-15 18:14:45', 'data type', '', 'String'),
(87, 15, 26, '2015-06-15 18:14:45', 'description', '', ''),
(88, 15, 26, '2015-06-15 18:14:45', 'value unit', '', ''),
(89, 15, 26, '2015-06-15 18:14:45', 'format', '', ''),
(90, 15, 26, '2015-06-15 18:14:45', 'missing value', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_executeinfo`
--

CREATE TABLE IF NOT EXISTS `colfusion_executeinfo` (
  `Eid` int(11) NOT NULL AUTO_INCREMENT,
  `Sid` int(11) NOT NULL,
  `UserId` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `TimeStart` datetime DEFAULT NULL,
  `TimeEnd` datetime DEFAULT NULL,
  `ExitStatus` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `ErrorMessage` longtext CHARACTER SET utf8,
  `RecordsProcessed` int(11) DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `pan_command` longtext CHARACTER SET utf8,
  `tableName` longtext CHARACTER SET utf8 NOT NULL,
  `log` text CHARACTER SET utf8,
  PRIMARY KEY (`Eid`),
  KEY `FK_ok0jbkcb90fa4r6jla4akpn9e` (`Sid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `colfusion_executeinfo`
--

INSERT INTO `colfusion_executeinfo` (`Eid`, `Sid`, `UserId`, `TimeStart`, `TimeEnd`, `ExitStatus`, `ErrorMessage`, `RecordsProcessed`, `status`, `pan_command`, `tableName`, `log`) VALUES
(1, 5, NULL, '2015-06-14 23:53:19', NULL, NULL, NULL, 3, 'success', NULL, 'Sheet1', '\n at Sun Jun 14 23:53:20 EDT 2015: \n 	 Starting to change the name for the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\5\\Sheet1.ktr. The new name is: 1 \n\n at Sun Jun 14 23:53:20 EDT 2015: \n 	 Finished to change the name for the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\5\\Sheet1.ktr \n\n at Sun Jun 14 23:53:20 EDT 2015: \n 	 Starting to read traget database info from the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\5\\Sheet1.ktr \n\n at Sun Jun 14 23:53:20 EDT 2015: \n 	 Finished reading traget database info from the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\5\\Sheet1.ktr \n\n at Sun Jun 14 23:53:20 EDT 2015: \n 	 Starting to update sourceintoDB record with target database conneciton info : \n sid: 5,\n severAddress: 130.49.135.94,\n port: 3306,\n userName: ImportTester,\n password: importtester,\n databaseName: colfusion2_0_fileToDB_5,\n driver: mysql,\n isLocal:1,\n linkedServerName:colfusion2_0_fileToDB_5  \n\n at Sun Jun 14 23:53:20 EDT 2015: \n 	 Finished update sourceintoDB record with target database conneciton info \n\n at Sun Jun 14 23:53:20 EDT 2015: \n 	 Starting to create target database \n\n at Sun Jun 14 23:53:20 EDT 2015: \n 	 Finished to create target database \n\n at Sun Jun 14 23:53:20 EDT 2015: \n 	 Starting to create target table Sheet1 \n\n at Sun Jun 14 23:53:20 EDT 2015: \n 	 Finished to create target table Sheet1 \n\n at Sun Jun 14 23:53:20 EDT 2015: \n 	 Started to prepare Carte Server Url for the C:\\wamp\\www\\Colfusion2.0\\temp\\5\\Sheet1.ktr \n\n at Sun Jun 14 23:53:20 EDT 2015: \n 	 Finished to prepare Carte Server Url for the C:\\wamp\\www\\Colfusion2.0\\temp\\5\\Sheet1.ktr file. KtrFileURL is http%3A%2F%2F130.49.135.94%3A8080%2FColfusion2.0%2Ftemp%2F5%2FSheet1.ktr \n\n at Sun Jun 14 23:53:20 EDT 2015: \n 	 Starting HTTP call to Carte Server http://130.49.135.94:8081/kettle/executeTrans/?trans=http%3A%2F%2F130.49.135.94%3A8080%2FColfusion2.0%2Ftemp%2F5%2FSheet1.ktr&Sid=5&Eid=1 \n\n at Sun Jun 14 23:53:25 EDT 2015: \n 	 Got the following status code in response 200:  \n\n at Sun Jun 14 23:53:25 EDT 2015: \n 	 Got This contect as the result of the call to carte :  \n\n at Sun Jun 14 23:53:25 EDT 2015: \n 	 Finished HTTP call to Carte Server http://130.49.135.94:8081/kettle/executeTrans/?trans=http%3A%2F%2F130.49.135.94%3A8080%2FColfusion2.0%2Ftemp%2F5%2FSheet1.ktr&Sid=5&Eid=1 \n\n at Sun Jun 14 23:53:25 EDT 2015: \n 	 Finished Execute method, not the ktr is probably being execution by the carte server. The DataLoadExecutorKTRImpl proces is however done. \n'),
(2, 6, NULL, '2015-06-15 00:16:33', NULL, NULL, NULL, 3, 'success', NULL, 'Sheet1', '\n at Mon Jun 15 00:16:33 EDT 2015: \n 	 Starting to change the name for the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\6\\Sheet1.ktr. The new name is: 2 \n\n at Mon Jun 15 00:16:33 EDT 2015: \n 	 Finished to change the name for the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\6\\Sheet1.ktr \n\n at Mon Jun 15 00:16:33 EDT 2015: \n 	 Starting to read traget database info from the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\6\\Sheet1.ktr \n\n at Mon Jun 15 00:16:33 EDT 2015: \n 	 Finished reading traget database info from the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\6\\Sheet1.ktr \n\n at Mon Jun 15 00:16:33 EDT 2015: \n 	 Starting to update sourceintoDB record with target database conneciton info : \n sid: 6,\n severAddress: 130.49.135.94,\n port: 3306,\n userName: ImportTester,\n password: importtester,\n databaseName: colfusion2_0_fileToDB_6,\n driver: mysql,\n isLocal:1,\n linkedServerName:colfusion2_0_fileToDB_6  \n\n at Mon Jun 15 00:16:33 EDT 2015: \n 	 Finished update sourceintoDB record with target database conneciton info \n\n at Mon Jun 15 00:16:33 EDT 2015: \n 	 Starting to create target database \n\n at Mon Jun 15 00:16:33 EDT 2015: \n 	 Finished to create target database \n\n at Mon Jun 15 00:16:33 EDT 2015: \n 	 Starting to create target table Sheet1 \n\n at Mon Jun 15 00:16:33 EDT 2015: \n 	 Finished to create target table Sheet1 \n\n at Mon Jun 15 00:16:33 EDT 2015: \n 	 Started to prepare Carte Server Url for the C:\\wamp\\www\\Colfusion2.0\\temp\\6\\Sheet1.ktr \n\n at Mon Jun 15 00:16:33 EDT 2015: \n 	 Finished to prepare Carte Server Url for the C:\\wamp\\www\\Colfusion2.0\\temp\\6\\Sheet1.ktr file. KtrFileURL is http%3A%2F%2F130.49.135.94%3A8080%2FColfusion2.0%2Ftemp%2F6%2FSheet1.ktr \n\n at Mon Jun 15 00:16:33 EDT 2015: \n 	 Starting HTTP call to Carte Server http://130.49.135.94:8081/kettle/executeTrans/?trans=http%3A%2F%2F130.49.135.94%3A8080%2FColfusion2.0%2Ftemp%2F6%2FSheet1.ktr&Sid=6&Eid=2 \n\n at Mon Jun 15 00:16:34 EDT 2015: \n 	 Got the following status code in response 200:  \n\n at Mon Jun 15 00:16:34 EDT 2015: \n 	 Got This contect as the result of the call to carte :  \n\n at Mon Jun 15 00:16:34 EDT 2015: \n 	 Finished HTTP call to Carte Server http://130.49.135.94:8081/kettle/executeTrans/?trans=http%3A%2F%2F130.49.135.94%3A8080%2FColfusion2.0%2Ftemp%2F6%2FSheet1.ktr&Sid=6&Eid=2 \n\n at Mon Jun 15 00:16:34 EDT 2015: \n 	 Finished Execute method, not the ktr is probably being execution by the carte server. The DataLoadExecutorKTRImpl proces is however done. \n'),
(3, 10, NULL, '2015-06-15 00:38:20', NULL, NULL, NULL, 3, 'success', NULL, 'Sheet1', '\n at Mon Jun 15 00:38:20 EDT 2015: \n 	 Starting to change the name for the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\10\\Sheet1.ktr. The new name is: 3 \n\n at Mon Jun 15 00:38:20 EDT 2015: \n 	 Finished to change the name for the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\10\\Sheet1.ktr \n\n at Mon Jun 15 00:38:20 EDT 2015: \n 	 Starting to read traget database info from the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\10\\Sheet1.ktr \n\n at Mon Jun 15 00:38:20 EDT 2015: \n 	 Finished reading traget database info from the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\10\\Sheet1.ktr \n\n at Mon Jun 15 00:38:20 EDT 2015: \n 	 Starting to update sourceintoDB record with target database conneciton info : \n sid: 10,\n severAddress: 130.49.135.94,\n port: 3306,\n userName: ImportTester,\n password: importtester,\n databaseName: colfusion2_0_fileToDB_10,\n driver: mysql,\n isLocal:1,\n linkedServerName:colfusion2_0_fileToDB_10  \n\n at Mon Jun 15 00:38:20 EDT 2015: \n 	 Finished update sourceintoDB record with target database conneciton info \n\n at Mon Jun 15 00:38:20 EDT 2015: \n 	 Starting to create target database \n\n at Mon Jun 15 00:38:21 EDT 2015: \n 	 Finished to create target database \n\n at Mon Jun 15 00:38:21 EDT 2015: \n 	 Starting to create target table Sheet1 \n\n at Mon Jun 15 00:38:21 EDT 2015: \n 	 Finished to create target table Sheet1 \n\n at Mon Jun 15 00:38:21 EDT 2015: \n 	 Started to prepare Carte Server Url for the C:\\wamp\\www\\Colfusion2.0\\temp\\10\\Sheet1.ktr \n\n at Mon Jun 15 00:38:21 EDT 2015: \n 	 Finished to prepare Carte Server Url for the C:\\wamp\\www\\Colfusion2.0\\temp\\10\\Sheet1.ktr file. KtrFileURL is http%3A%2F%2F130.49.135.94%3A8080%2FColfusion2.0%2Ftemp%2F10%2FSheet1.ktr \n\n at Mon Jun 15 00:38:21 EDT 2015: \n 	 Starting HTTP call to Carte Server http://130.49.135.94:8081/kettle/executeTrans/?trans=http%3A%2F%2F130.49.135.94%3A8080%2FColfusion2.0%2Ftemp%2F10%2FSheet1.ktr&Sid=10&Eid=3 \n\n at Mon Jun 15 00:38:22 EDT 2015: \n 	 Got the following status code in response 200:  \n\n at Mon Jun 15 00:38:22 EDT 2015: \n 	 Got This contect as the result of the call to carte :  \n\n at Mon Jun 15 00:38:22 EDT 2015: \n 	 Finished HTTP call to Carte Server http://130.49.135.94:8081/kettle/executeTrans/?trans=http%3A%2F%2F130.49.135.94%3A8080%2FColfusion2.0%2Ftemp%2F10%2FSheet1.ktr&Sid=10&Eid=3 \n\n at Mon Jun 15 00:38:22 EDT 2015: \n 	 Finished Execute method, not the ktr is probably being execution by the carte server. The DataLoadExecutorKTRImpl proces is however done. \n'),
(4, 11, NULL, '2015-06-15 00:52:44', NULL, NULL, NULL, 3, 'success', NULL, 'Sheet1', '\n at Mon Jun 15 00:52:44 EDT 2015: \n 	 Starting to change the name for the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\11\\Sheet1.ktr. The new name is: 4 \n\n at Mon Jun 15 00:52:44 EDT 2015: \n 	 Finished to change the name for the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\11\\Sheet1.ktr \n\n at Mon Jun 15 00:52:44 EDT 2015: \n 	 Starting to read traget database info from the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\11\\Sheet1.ktr \n\n at Mon Jun 15 00:52:44 EDT 2015: \n 	 Finished reading traget database info from the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\11\\Sheet1.ktr \n\n at Mon Jun 15 00:52:44 EDT 2015: \n 	 Starting to update sourceintoDB record with target database conneciton info : \n sid: 11,\n severAddress: 130.49.135.94,\n port: 3306,\n userName: ImportTester,\n password: importtester,\n databaseName: colfusion2_0_fileToDB_11,\n driver: mysql,\n isLocal:1,\n linkedServerName:colfusion2_0_fileToDB_11  \n\n at Mon Jun 15 00:52:44 EDT 2015: \n 	 Finished update sourceintoDB record with target database conneciton info \n\n at Mon Jun 15 00:52:44 EDT 2015: \n 	 Starting to create target database \n\n at Mon Jun 15 00:52:44 EDT 2015: \n 	 Finished to create target database \n\n at Mon Jun 15 00:52:44 EDT 2015: \n 	 Starting to create target table Sheet1 \n\n at Mon Jun 15 00:52:44 EDT 2015: \n 	 Finished to create target table Sheet1 \n\n at Mon Jun 15 00:52:45 EDT 2015: \n 	 Started to prepare Carte Server Url for the C:\\wamp\\www\\Colfusion2.0\\temp\\11\\Sheet1.ktr \n\n at Mon Jun 15 00:52:45 EDT 2015: \n 	 Finished to prepare Carte Server Url for the C:\\wamp\\www\\Colfusion2.0\\temp\\11\\Sheet1.ktr file. KtrFileURL is http%3A%2F%2F130.49.135.94%3A8080%2FColfusion2.0%2Ftemp%2F11%2FSheet1.ktr \n\n at Mon Jun 15 00:52:45 EDT 2015: \n 	 Starting HTTP call to Carte Server http://130.49.135.94:8081/kettle/executeTrans/?trans=http%3A%2F%2F130.49.135.94%3A8080%2FColfusion2.0%2Ftemp%2F11%2FSheet1.ktr&Sid=11&Eid=4 \n\n at Mon Jun 15 00:52:46 EDT 2015: \n 	 Got the following status code in response 200:  \n\n at Mon Jun 15 00:52:46 EDT 2015: \n 	 Got This contect as the result of the call to carte :  \n\n at Mon Jun 15 00:52:46 EDT 2015: \n 	 Finished HTTP call to Carte Server http://130.49.135.94:8081/kettle/executeTrans/?trans=http%3A%2F%2F130.49.135.94%3A8080%2FColfusion2.0%2Ftemp%2F11%2FSheet1.ktr&Sid=11&Eid=4 \n\n at Mon Jun 15 00:52:46 EDT 2015: \n 	 Finished Execute method, not the ktr is probably being execution by the carte server. The DataLoadExecutorKTRImpl proces is however done. \n'),
(5, 13, NULL, '2015-06-15 18:14:46', NULL, NULL, NULL, 3, 'success', NULL, 'Sheet1', '\n at Mon Jun 15 18:14:46 EDT 2015: \n 	 Starting to change the name for the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\13\\Sheet1.ktr. The new name is: 5 \n\n at Mon Jun 15 18:14:46 EDT 2015: \n 	 Finished to change the name for the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\13\\Sheet1.ktr \n\n at Mon Jun 15 18:14:46 EDT 2015: \n 	 Starting to read traget database info from the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\13\\Sheet1.ktr \n\n at Mon Jun 15 18:14:46 EDT 2015: \n 	 Finished reading traget database info from the KTR file located at C:\\wamp\\www\\Colfusion2.0\\temp\\13\\Sheet1.ktr \n\n at Mon Jun 15 18:14:46 EDT 2015: \n 	 Starting to update sourceintoDB record with target database conneciton info : \n sid: 13,\n severAddress: 130.49.135.94,\n port: 3306,\n userName: ImportTester,\n password: importtester,\n databaseName: colfusion2_0_fileToDB_13,\n driver: mysql,\n isLocal:1,\n linkedServerName:colfusion2_0_fileToDB_13  \n\n at Mon Jun 15 18:14:46 EDT 2015: \n 	 Finished update sourceintoDB record with target database conneciton info \n\n at Mon Jun 15 18:14:46 EDT 2015: \n 	 Starting to create target database \n\n at Mon Jun 15 18:14:46 EDT 2015: \n 	 Finished to create target database \n\n at Mon Jun 15 18:14:46 EDT 2015: \n 	 Starting to create target table Sheet1 \n\n at Mon Jun 15 18:14:47 EDT 2015: \n 	 Finished to create target table Sheet1 \n\n at Mon Jun 15 18:14:47 EDT 2015: \n 	 Started to prepare Carte Server Url for the C:\\wamp\\www\\Colfusion2.0\\temp\\13\\Sheet1.ktr \n\n at Mon Jun 15 18:14:47 EDT 2015: \n 	 Finished to prepare Carte Server Url for the C:\\wamp\\www\\Colfusion2.0\\temp\\13\\Sheet1.ktr file. KtrFileURL is http%3A%2F%2F130.49.135.94%3A8080%2FColfusion2.0%2Ftemp%2F13%2FSheet1.ktr \n\n at Mon Jun 15 18:14:47 EDT 2015: \n 	 Starting HTTP call to Carte Server http://130.49.135.94:8081/kettle/executeTrans/?trans=http%3A%2F%2F130.49.135.94%3A8080%2FColfusion2.0%2Ftemp%2F13%2FSheet1.ktr&Sid=13&Eid=5 \n\n at Mon Jun 15 18:14:47 EDT 2015: \n 	 Got the following status code in response 200:  \n\n at Mon Jun 15 18:14:48 EDT 2015: \n 	 Got This contect as the result of the call to carte :  \n\n at Mon Jun 15 18:14:48 EDT 2015: \n 	 Finished HTTP call to Carte Server http://130.49.135.94:8081/kettle/executeTrans/?trans=http%3A%2F%2F130.49.135.94%3A8080%2FColfusion2.0%2Ftemp%2F13%2FSheet1.ktr&Sid=13&Eid=5 \n\n at Mon Jun 15 18:14:48 EDT 2015: \n 	 Finished Execute method, not the ktr is probably being execution by the carte server. The DataLoadExecutorKTRImpl proces is however done. \n');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_formulas`
--

CREATE TABLE IF NOT EXISTS `colfusion_formulas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `enabled` bit(1) NOT NULL,
  `title` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `formula` longtext CHARACTER SET utf8,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `colfusion_formulas`
--

INSERT INTO `colfusion_formulas` (`id`, `type`, `enabled`, `title`, `formula`) VALUES
(1, 'report', b'1', 'Simple Story Reporting', '$reports > $votes * 3');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_friends`
--

CREATE TABLE IF NOT EXISTS `colfusion_friends` (
  `friend_id` int(11) NOT NULL AUTO_INCREMENT,
  `friend_from` bigint(20) NOT NULL,
  `friend_to` bigint(20) NOT NULL,
  PRIMARY KEY (`friend_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_groups`
--

CREATE TABLE IF NOT EXISTS `colfusion_groups` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_creator` int(11) NOT NULL,
  `group_status` varchar(7) CHARACTER SET utf8 NOT NULL,
  `group_members` int(11) NOT NULL,
  `group_date` datetime NOT NULL,
  `group_safename` longtext CHARACTER SET utf8,
  `group_name` longtext CHARACTER SET utf8,
  `group_description` longtext CHARACTER SET utf8,
  `group_privacy` varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  `group_avatar` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `group_vote_to_publish` int(11) NOT NULL,
  `group_field1` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `group_field2` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `group_field3` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `group_field4` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `group_field5` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `group_field6` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `group_notify_email` bit(1) NOT NULL,
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_group_member`
--

CREATE TABLE IF NOT EXISTS `colfusion_group_member` (
  `member_id` int(11) NOT NULL AUTO_INCREMENT,
  `member_user_id` int(11) NOT NULL,
  `member_group_id` int(11) NOT NULL,
  `member_role` varchar(9) CHARACTER SET utf8 NOT NULL,
  `member_status` varchar(8) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_group_shared`
--

CREATE TABLE IF NOT EXISTS `colfusion_group_shared` (
  `share_id` int(11) NOT NULL AUTO_INCREMENT,
  `share_link_id` int(11) NOT NULL,
  `share_group_id` int(11) NOT NULL,
  `share_user_id` int(11) NOT NULL,
  PRIMARY KEY (`share_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_license`
--

CREATE TABLE IF NOT EXISTS `colfusion_license` (
  `license_ID` int(11) NOT NULL AUTO_INCREMENT,
  `license_Name` varchar(250) CHARACTER SET utf8 NOT NULL,
  `license_Des` text CHARACTER SET utf8,
  `license_URL` text CHARACTER SET utf8,
  PRIMARY KEY (`license_ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `colfusion_license`
--

INSERT INTO `colfusion_license` (`license_ID`, `license_Name`, `license_Des`, `license_URL`) VALUES
(6, 'Creative Commons Attribution ShareAlike 4.0', 'Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)', 'https://creativecommons.org/licenses/by-sa/4.0/'),
(7, 'Creative Commons Attribution ShareAlike 3.0', 'Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)', 'https://creativecommons.org/licenses/by-sa/3.0/'),
(8, 'Creative Commons Attribution 4.0', 'Attribution 4.0 International (CC BY 4.0)', 'https://creativecommons.org/licenses/by/4.0/'),
(9, 'Creative Commons Attribution 3.0 ', 'Attribution 3.0 Unported (CC BY 3.0)', 'https://creativecommons.org/licenses/by/3.0/'),
(10, 'Creative Commons CC0 Waiver(release all rights, like public domain)', 'CC0 1.0 Universal (CC0 1.0) Public Domain Dedication', 'https://creativecommons.org/publicdomain/zero/1.0/');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_likes`
--

CREATE TABLE IF NOT EXISTS `colfusion_likes` (
  `like_update_id` int(11) NOT NULL,
  `like_user_id` int(11) NOT NULL,
  PRIMARY KEY (`like_update_id`,`like_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_links`
--

CREATE TABLE IF NOT EXISTS `colfusion_links` (
  `link_id` int(11) NOT NULL,
  `link_author` int(11) NOT NULL,
  `link_status` varchar(9) CHARACTER SET utf8 DEFAULT NULL,
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
  `link_url` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `link_url_title` longtext CHARACTER SET utf8,
  `link_title` longtext CHARACTER SET utf8,
  `link_title_url` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_content` longtext CHARACTER SET utf8,
  `link_summary` longtext CHARACTER SET utf8,
  `link_tags` longtext CHARACTER SET utf8,
  `link_field1` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_field2` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_field3` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_field4` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_field5` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_field6` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_field7` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_field8` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_field9` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_field10` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_field11` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_field12` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_field13` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_field14` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_field15` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `link_group_id` int(11) NOT NULL,
  `link_group_status` varchar(9) CHARACTER SET utf8 NOT NULL,
  `link_out` int(11) NOT NULL,
  PRIMARY KEY (`link_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `colfusion_links`
--

INSERT INTO `colfusion_links` (`link_id`, `link_author`, `link_status`, `link_randkey`, `link_votes`, `link_reports`, `link_comments`, `link_karma`, `link_modified`, `link_date`, `link_published_date`, `link_category`, `link_lang`, `link_url`, `link_url_title`, `link_title`, `link_title_url`, `link_content`, `link_summary`, `link_tags`, `link_field1`, `link_field2`, `link_field3`, `link_field4`, `link_field5`, `link_field6`, `link_field7`, `link_field8`, `link_field9`, `link_field10`, `link_field11`, `link_field12`, `link_field13`, `link_field14`, `link_field15`, `link_group_id`, `link_group_status`, `link_out`) VALUES
(5, 26, 'queued', 0, 0, 0, 0, 0.00, '2015-06-14 19:51:56', '2015-06-14 19:51:56', '2015-06-14 19:51:56', 0, 1, NULL, NULL, 'very first test', '5', 'test', 'test', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'queued', 0),
(6, 26, 'queued', 0, 0, 0, 0, 0.00, '2015-06-14 20:16:01', '2015-06-14 20:16:01', '2015-06-14 20:16:01', 0, 1, NULL, NULL, 'second', '6', 'test', 'test', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'queued', 0),
(10, 26, 'queued', 0, 0, 0, 0, 0.00, '2015-06-14 20:36:05', '2015-06-14 20:36:05', '2015-06-14 20:36:05', 0, 1, NULL, NULL, 'third', '10', 'test', 'test', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'queued', 0),
(11, 26, 'queued', 0, 0, 0, 0, 0.00, '2015-06-14 20:52:15', '2015-06-14 20:52:15', '2015-06-14 20:52:15', 0, 1, NULL, NULL, 'fourth', '11', 'test', 'test', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'queued', 0),
(13, 26, 'queued', 0, 0, 0, 0, 0.00, '2015-06-15 14:14:19', '2015-06-15 14:14:19', '2015-06-15 14:14:19', 0, 1, NULL, NULL, 'fifth', '13', 'test', 'test', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 'queued', 0);

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_login_attempts`
--

CREATE TABLE IF NOT EXISTS `colfusion_login_attempts` (
  `login_id` int(11) NOT NULL AUTO_INCREMENT,
  `login_username` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `login_time` datetime NOT NULL,
  `login_ip` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `login_count` int(11) NOT NULL,
  PRIMARY KEY (`login_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `colfusion_login_attempts`
--

INSERT INTO `colfusion_login_attempts` (`login_id`, `login_username`, `login_time`, `login_ip`, `login_count`) VALUES
(2, 'druvolo', '2015-06-15 14:00:40', '136.142.149.58', 4);

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_messages`
--

CREATE TABLE IF NOT EXISTS `colfusion_messages` (
  `idMsg` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `body` longtext CHARACTER SET utf8,
  `sender` int(11) NOT NULL,
  `receiver` int(11) NOT NULL,
  `senderLevel` int(11) NOT NULL,
  `readed` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`idMsg`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_misc_data`
--

CREATE TABLE IF NOT EXISTS `colfusion_misc_data` (
  `name` varchar(20) CHARACTER SET utf8 NOT NULL,
  `data` longtext CHARACTER SET utf8,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `colfusion_misc_data`
--

INSERT INTO `colfusion_misc_data` (`name`, `data`) VALUES
('captcha_method', 'reCaptcha'),
('hash', 'z^vpnZokFB39`cl7Oy7adS_pAxPpFhl'),
('karma_comment_delete', '-50'),
('karma_comment_vote', '0'),
('karma_story_discard', '-250'),
('karma_story_publish', '+50'),
('karma_story_spam', '-10000'),
('karma_story_vote', '+1'),
('karma_submit_comment', '+10'),
('karma_submit_story', '+15'),
('pagesize', '50'),
('pligg_version', '1.2.2'),
('raw_data_directory', '/upload_raw_data/'),
('reCaptcha_prikey', '6LfwKQQAAAAAALQosKUrE4MepD0_kW7dgDZLR5P1'),
('reCaptcha_pubkey', '6LfwKQQAAAAAAPFCNozXDIaf8GobTb7LCKQw54EA'),
('spam_trigger_light', 'arsehole\r\nass-pirate\r\nass pirate\r\nassbandit\r\nassbanger\r\nassfucker\r\nasshat\r\nasshole\r\nasspirate\r\nassshole\r\nasswipe\r\nbastard\r\nbeaner\r\nbeastiality\r\nbitch\r\nblow job\r\nblowjob\r\nbutt plug\r\nbutt-pirate\r\nbutt pirate\r\nbuttpirate\r\ncarpet muncher\r\ncarpetmuncher\r\nclit\r\ncock smoker\r\ncocksmoker\r\ncock sucker\r\ncocksucker\r\ncum dumpster\r\ncumdumpster\r\ncum slut\r\ncumslut\r\ncunnilingus\r\ncunt\r\ndick head\r\ndickhead\r\ndickwad\r\ndickweed\r\ndickwod\r\ndike\r\ndildo\r\ndouche bag\r\ndouche-bag\r\ndouchebag\r\ndyke\r\nejaculat\r\nerection\r\nfaggit\r\nfaggot\r\nfagtard\r\nfarm sex\r\nfuck\r\nfudge packer\r\nfudge-packer\r\nfudgepacker\r\ngayass\r\ngay wad\r\ngaywad\r\ngod damn\r\ngod-damn\r\ngoddamn\r\nhandjob\r\njerk off\r\njizz\r\njungle bunny\r\njungle-bunny\r\njunglebunny\r\nkike\r\nkunt\r\nnigga\r\nnigger\r\norgasm\r\npenis\r\nporch monkey\r\nporch-monkey\r\nporchmonkey\r\nprostitute\r\nqueef\r\nrimjob\r\nsexual\r\nshit\r\nspick\r\nsplooge\r\ntesticle\r\ntitty\r\ntwat\r\nvagina\r\nwank\r\nxxx\r\nabilify\r\nadderall\r\nadipex\r\nadvair diskus\r\nambien\r\naranesp\r\nbotox\r\ncelebrex\r\ncialis\r\ncrestor\r\ncyclen\r\ncyclobenzaprine\r\ncymbalta\r\ndieting\r\neffexor\r\nepogen\r\nfioricet\r\nhydrocodone\r\nionamin\r\nlamictal\r\nlevaquin\r\nlevitra\r\nlexapro\r\nlipitor\r\nmeridia\r\nnexium\r\noxycontin\r\npaxil\r\nphendimetrazine\r\nphentamine\r\nphentermine\r\npheramones\r\npherimones\r\nplavix\r\nprevacid\r\nprocrit\r\nprotonix\r\nrisperdal\r\nseroquel\r\nsingulair\r\ntopamax\r\ntramadol\r\ntrim-spa\r\nultram\r\nvalium\r\nvaltrex\r\nviagra\r\nvicodin\r\nvioxx\r\nvytorin\r\nxanax\r\nzetia\r\nzocor\r\nzoloft\r\nzyprexa\r\nzyrtec\r\n18+\r\nacai berry\r\nacai pill\r\nadults only\r\nadult web\r\napply online\r\nauto loan\r\nbest rates\r\nbulk email\r\nbuy direct\r\nbuy drugs\r\nbuy now\r\nbuy online\r\ncasino\r\ncell phone\r\nchild porn\r\ncredit card\r\ndating site\r\nday-trading\r\ndebt free\r\ndegree program\r\ndescramble\r\ndiet pill\r\ndigital cble\r\ndirect tv\r\ndoctor approved\r\ndoctor prescribed\r\ndownload full\r\ndvd and bluray\r\ndvd bluray\r\ndvd storage\r\nearn a college degree\r\nearn a degree\r\nearn extra money\r\neasy money\r\nebay secret\r\nebay shop\r\nerotic\r\nescorts\r\nexplicit\r\nfind online\r\nfire your boss\r\nfree cable\r\nfree cell phone\r\nfree dating\r\nfree degree\r\nfree diploma\r\nfree dvd\r\nfree games\r\nfree gift\r\nfree money\r\nfree offer\r\nfree phone\r\nfree reading\r\ngambling\r\nget rich quick\r\ngingivitis\r\nhealth products\r\nheartburn\r\nhormone\r\nhorny\r\nincest\r\ninsurance\r\ninvestment\r\ninvestor\r\nloan quote\r\nloose weight\r\nlow interest\r\nmake money\r\nmedical exam\r\nmedications\r\nmoney at home\r\nmortgage\r\nm0rtgage\r\nmovies online\r\nmust be 18\r\nno purchase\r\nnudist\r\nonline free\r\nonline marketing\r\nonline movies\r\nonline order\r\nonline poker\r\norder now\r\norder online\r\nover 18\r\nover 21\r\npain relief\r\npharmacy\r\nprescription\r\nproduction management\r\nrefinance\r\nremoves wrinkles\r\nrolex\r\nsatellite tv\r\nsavings on\r\nsearch engine\r\nsexcapades\r\nstop snoring\r\nstop spam\r\nvacation offers\r\nvideo recorder\r\nvirgin\r\nweight reduction\r\nwork at home'),
('status_avatar', 'small'),
('status_clock', '12'),
('status_inputonother', '1'),
('status_level', 'god,admin,normal'),
('status_max_chars', '1200'),
('status_permalinks', '1'),
('status_place', 'tpl_pligg_profile_info_end'),
('status_profile_level', 'god,admin,normal'),
('status_results', '10'),
('status_show_permalin', '1'),
('status_switch', '0'),
('status_user_comment', '1'),
('status_user_email', '1'),
('status_user_friends', '1'),
('status_user_story', '1'),
('status_user_switch', '1'),
('temp_directory', '/temp/'),
('upload_alternates', 'YToxOntpOjE7czowOiIiO30='),
('upload_defsize', '200x200'),
('upload_directory', '/modules/upload/attachments'),
('upload_display', 'a:1:{s:7:"150x150";s:1:"1";}'),
('upload_extensions', 'jpg jpeg png gif'),
('upload_external', 'file,url'),
('upload_fields', 'YTowOnt9'),
('upload_fileplace', 'tpl_pligg_story_who_voted_start'),
('upload_filesize', '200'),
('upload_link', 'orig'),
('upload_mandatory', 'a:0:{}'),
('upload_maxnumber', '1'),
('upload_place', 'tpl_link_summary_pre_story_content'),
('upload_quality', '80'),
('upload_sizes', 'a:1:{i:0;s:7:"200x200";}'),
('upload_thdirectory', '/modules/upload/attachments/thumbs'),
('upload_thumb', '1'),
('validate', '0'),
('wrapper_directory', 'register-wrapper/');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_modules`
--

CREATE TABLE IF NOT EXISTS `colfusion_modules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` float NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `latest_version` float NOT NULL,
  `folder` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `enabled` bit(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_notifications`
--

CREATE TABLE IF NOT EXISTS `colfusion_notifications` (
  `ntf_id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `action` varchar(100) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`ntf_id`),
  KEY `FK_t1oenxdm5eync7fotfy18461t` (`sender_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_notifications_unread`
--

CREATE TABLE IF NOT EXISTS `colfusion_notifications_unread` (
  `ntf_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  PRIMARY KEY (`ntf_id`,`receiver_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_old_urls`
--

CREATE TABLE IF NOT EXISTS `colfusion_old_urls` (
  `old_id` int(11) NOT NULL AUTO_INCREMENT,
  `old_link_id` int(11) NOT NULL,
  `old_title_url` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`old_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_openrefine_history_helper`
--

CREATE TABLE IF NOT EXISTS `colfusion_openrefine_history_helper` (
  `sid` int(255) NOT NULL,
  `tableName` varchar(255) CHARACTER SET utf8 NOT NULL,
  `count` int(255) NOT NULL,
  `isSaved` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `colfusion_openrefine_history_helper`
--

INSERT INTO `colfusion_openrefine_history_helper` (`sid`, `tableName`, `count`, `isSaved`) VALUES
(11, 'Sheet1', 2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_openrefine_project_map`
--

CREATE TABLE IF NOT EXISTS `colfusion_openrefine_project_map` (
  `sid` int(11) NOT NULL,
  `tableName` varchar(255) CHARACTER SET utf8 NOT NULL,
  `projectId` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`sid`,`tableName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `colfusion_openrefine_project_map`
--

INSERT INTO `colfusion_openrefine_project_map` (`sid`, `tableName`, `projectId`) VALUES
(11, 'Sheet1', '1863785884276');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_pentaho_log_logging_channels`
--

CREATE TABLE IF NOT EXISTS `colfusion_pentaho_log_logging_channels` (
  `ID_BATCH` int(11) DEFAULT NULL,
  `CHANNEL_ID` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `LOG_DATE` datetime DEFAULT NULL,
  `LOGGING_OBJECT_TYPE` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `OBJECT_NAME` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `OBJECT_COPY` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `REPOSITORY_DIRECTORY` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `FILENAME` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `OBJECT_ID` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `OBJECT_REVISION` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `PARENT_CHANNEL_ID` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `ROOT_CHANNEL_ID` varchar(255) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `colfusion_pentaho_log_logging_channels`
--

INSERT INTO `colfusion_pentaho_log_logging_channels` (`ID_BATCH`, `CHANNEL_ID`, `LOG_DATE`, `LOGGING_OBJECT_TYPE`, `OBJECT_NAME`, `OBJECT_COPY`, `REPOSITORY_DIRECTORY`, `FILENAME`, `OBJECT_ID`, `OBJECT_REVISION`, `PARENT_CHANNEL_ID`, `ROOT_CHANNEL_ID`) VALUES
(0, '47dab9df-ff22-429e-a479-94d9b0597ae2', '2015-06-14 23:53:24', 'STEP', 'Get Variables (Do Not Modify)', '0', NULL, NULL, NULL, NULL, '2f40a23f-cd95-41e9-af44-cd4c8c227ac3', '2f40a23f-cd95-41e9-af44-cd4c8c227ac3'),
(0, '47dab9df-ff22-429e-a479-94d9b0597ae2', '2015-06-14 23:53:24', 'STEP', 'Get Variables (Do Not Modify)', '0', NULL, NULL, NULL, NULL, '2f40a23f-cd95-41e9-af44-cd4c8c227ac3', '2f40a23f-cd95-41e9-af44-cd4c8c227ac3'),
(0, 'ea94ccb4-2309-448f-91f1-d1b6f2bb6a85', '2015-06-14 23:53:24', 'DATABASE', 'colfusion.exp.sis.pitt.edu', NULL, NULL, NULL, NULL, NULL, 'd077019c-50b4-411e-abc6-2196223b0b8a', '2f40a23f-cd95-41e9-af44-cd4c8c227ac3'),
(0, 'ea94ccb4-2309-448f-91f1-d1b6f2bb6a85', '2015-06-14 23:53:25', 'DATABASE', 'colfusion.exp.sis.pitt.edu', NULL, NULL, NULL, NULL, NULL, 'd077019c-50b4-411e-abc6-2196223b0b8a', '2f40a23f-cd95-41e9-af44-cd4c8c227ac3'),
(0, 'd077019c-50b4-411e-abc6-2196223b0b8a', '2015-06-14 23:53:25', 'STEP', 'Target Schema', '0', NULL, NULL, NULL, NULL, '2f40a23f-cd95-41e9-af44-cd4c8c227ac3', '2f40a23f-cd95-41e9-af44-cd4c8c227ac3'),
(0, '599079b2-da94-4419-870a-a08468985c0d', '2015-06-14 23:53:25', 'STEP', 'Excel Input File', '0', NULL, NULL, NULL, NULL, '2f40a23f-cd95-41e9-af44-cd4c8c227ac3', '2f40a23f-cd95-41e9-af44-cd4c8c227ac3'),
(0, '599079b2-da94-4419-870a-a08468985c0d', '2015-06-14 23:53:25', 'STEP', 'Excel Input File', '0', NULL, NULL, NULL, NULL, '2f40a23f-cd95-41e9-af44-cd4c8c227ac3', '2f40a23f-cd95-41e9-af44-cd4c8c227ac3'),
(0, 'a47c1cd6-60ed-4bd0-8ca3-bdb9d5157cec', '2015-06-14 23:53:25', 'DATABASE', 'connection_for_logging', NULL, NULL, NULL, NULL, NULL, '2f40a23f-cd95-41e9-af44-cd4c8c227ac3', '2f40a23f-cd95-41e9-af44-cd4c8c227ac3'),
(0, 'a47c1cd6-60ed-4bd0-8ca3-bdb9d5157cec', '2015-06-14 23:53:25', 'DATABASE', 'connection_for_logging', NULL, NULL, NULL, NULL, NULL, '2f40a23f-cd95-41e9-af44-cd4c8c227ac3', '2f40a23f-cd95-41e9-af44-cd4c8c227ac3'),
(0, '2f40a23f-cd95-41e9-af44-cd4c8c227ac3', '2015-06-14 23:53:25', 'TRANS', '1', NULL, '/', 'http://130.49.135.94:8080/Colfusion2.0/temp/5/Sheet1.ktr', NULL, NULL, NULL, '2f40a23f-cd95-41e9-af44-cd4c8c227ac3'),
(1, 'e8eeddfc-981a-492d-8b5b-4a5413585d6f', '2015-06-15 00:16:34', 'STEP', 'Get Variables (Do Not Modify)', '0', NULL, NULL, NULL, NULL, '6a051903-ca67-4834-8516-40c5bcad4441', '6a051903-ca67-4834-8516-40c5bcad4441'),
(1, 'e8eeddfc-981a-492d-8b5b-4a5413585d6f', '2015-06-15 00:16:34', 'STEP', 'Get Variables (Do Not Modify)', '0', NULL, NULL, NULL, NULL, '6a051903-ca67-4834-8516-40c5bcad4441', '6a051903-ca67-4834-8516-40c5bcad4441'),
(1, '07961e85-1e99-493b-abdc-e7c56ce86b7a', '2015-06-15 00:16:34', 'DATABASE', 'colfusion.exp.sis.pitt.edu', NULL, NULL, NULL, NULL, NULL, '9d43c1c9-e34a-42b1-897f-d48e139828c3', '6a051903-ca67-4834-8516-40c5bcad4441'),
(1, '07961e85-1e99-493b-abdc-e7c56ce86b7a', '2015-06-15 00:16:34', 'DATABASE', 'colfusion.exp.sis.pitt.edu', NULL, NULL, NULL, NULL, NULL, '9d43c1c9-e34a-42b1-897f-d48e139828c3', '6a051903-ca67-4834-8516-40c5bcad4441'),
(1, '9d43c1c9-e34a-42b1-897f-d48e139828c3', '2015-06-15 00:16:34', 'STEP', 'Target Schema', '0', NULL, NULL, NULL, NULL, '6a051903-ca67-4834-8516-40c5bcad4441', '6a051903-ca67-4834-8516-40c5bcad4441'),
(1, 'e2b937eb-ead0-4ff0-ac1c-9dca464e50b2', '2015-06-15 00:16:34', 'STEP', 'Excel Input File', '0', NULL, NULL, NULL, NULL, '6a051903-ca67-4834-8516-40c5bcad4441', '6a051903-ca67-4834-8516-40c5bcad4441'),
(1, 'e2b937eb-ead0-4ff0-ac1c-9dca464e50b2', '2015-06-15 00:16:34', 'STEP', 'Excel Input File', '0', NULL, NULL, NULL, NULL, '6a051903-ca67-4834-8516-40c5bcad4441', '6a051903-ca67-4834-8516-40c5bcad4441'),
(1, '472bbae6-adf7-4813-87cb-ce820d3fd39d', '2015-06-15 00:16:34', 'DATABASE', 'connection_for_logging', NULL, NULL, NULL, NULL, NULL, '6a051903-ca67-4834-8516-40c5bcad4441', '6a051903-ca67-4834-8516-40c5bcad4441'),
(1, '472bbae6-adf7-4813-87cb-ce820d3fd39d', '2015-06-15 00:16:34', 'DATABASE', 'connection_for_logging', NULL, NULL, NULL, NULL, NULL, '6a051903-ca67-4834-8516-40c5bcad4441', '6a051903-ca67-4834-8516-40c5bcad4441'),
(1, '6a051903-ca67-4834-8516-40c5bcad4441', '2015-06-15 00:16:34', 'TRANS', '2', NULL, '/', 'http://130.49.135.94:8080/Colfusion2.0/temp/6/Sheet1.ktr', NULL, NULL, NULL, '6a051903-ca67-4834-8516-40c5bcad4441'),
(2, 'a9017ffd-aa0b-45b7-a0c5-f76da92f2516', '2015-06-15 00:38:22', 'STEP', 'Get Variables (Do Not Modify)', '0', NULL, NULL, NULL, NULL, '42ba255a-8fd7-433e-bb8e-50c36de4b735', '42ba255a-8fd7-433e-bb8e-50c36de4b735'),
(2, 'a9017ffd-aa0b-45b7-a0c5-f76da92f2516', '2015-06-15 00:38:22', 'STEP', 'Get Variables (Do Not Modify)', '0', NULL, NULL, NULL, NULL, '42ba255a-8fd7-433e-bb8e-50c36de4b735', '42ba255a-8fd7-433e-bb8e-50c36de4b735'),
(2, 'ea3369f8-ae10-4f31-aebb-86d70fe3f32d', '2015-06-15 00:38:22', 'DATABASE', 'colfusion.exp.sis.pitt.edu', NULL, NULL, NULL, NULL, NULL, '3e71df5f-c797-4e41-9fd1-6d2faf67299a', '42ba255a-8fd7-433e-bb8e-50c36de4b735'),
(2, 'ea3369f8-ae10-4f31-aebb-86d70fe3f32d', '2015-06-15 00:38:22', 'DATABASE', 'colfusion.exp.sis.pitt.edu', NULL, NULL, NULL, NULL, NULL, '3e71df5f-c797-4e41-9fd1-6d2faf67299a', '42ba255a-8fd7-433e-bb8e-50c36de4b735'),
(2, '3e71df5f-c797-4e41-9fd1-6d2faf67299a', '2015-06-15 00:38:22', 'STEP', 'Target Schema', '0', NULL, NULL, NULL, NULL, '42ba255a-8fd7-433e-bb8e-50c36de4b735', '42ba255a-8fd7-433e-bb8e-50c36de4b735'),
(2, '967c1964-9c1a-4033-8e9b-238b4f4e83f4', '2015-06-15 00:38:22', 'STEP', 'Excel Input File', '0', NULL, NULL, NULL, NULL, '42ba255a-8fd7-433e-bb8e-50c36de4b735', '42ba255a-8fd7-433e-bb8e-50c36de4b735'),
(2, '967c1964-9c1a-4033-8e9b-238b4f4e83f4', '2015-06-15 00:38:22', 'STEP', 'Excel Input File', '0', NULL, NULL, NULL, NULL, '42ba255a-8fd7-433e-bb8e-50c36de4b735', '42ba255a-8fd7-433e-bb8e-50c36de4b735'),
(2, '5140cc4d-5dd7-441e-bd00-790fe65a49ae', '2015-06-15 00:38:22', 'DATABASE', 'connection_for_logging', NULL, NULL, NULL, NULL, NULL, '42ba255a-8fd7-433e-bb8e-50c36de4b735', '42ba255a-8fd7-433e-bb8e-50c36de4b735'),
(2, '5140cc4d-5dd7-441e-bd00-790fe65a49ae', '2015-06-15 00:38:22', 'DATABASE', 'connection_for_logging', NULL, NULL, NULL, NULL, NULL, '42ba255a-8fd7-433e-bb8e-50c36de4b735', '42ba255a-8fd7-433e-bb8e-50c36de4b735'),
(2, '42ba255a-8fd7-433e-bb8e-50c36de4b735', '2015-06-15 00:38:22', 'TRANS', '3', NULL, '/', 'http://130.49.135.94:8080/Colfusion2.0/temp/10/Sheet1.ktr', NULL, NULL, NULL, '42ba255a-8fd7-433e-bb8e-50c36de4b735'),
(3, 'f4479fd9-a198-4609-90f1-d7e62b942c18', '2015-06-15 00:52:46', 'STEP', 'Get Variables (Do Not Modify)', '0', NULL, NULL, NULL, NULL, 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9', 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9'),
(3, 'f4479fd9-a198-4609-90f1-d7e62b942c18', '2015-06-15 00:52:46', 'STEP', 'Get Variables (Do Not Modify)', '0', NULL, NULL, NULL, NULL, 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9', 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9'),
(3, 'b6f4ebf0-3efe-4657-9875-7a1484a02dc3', '2015-06-15 00:52:46', 'DATABASE', 'colfusion.exp.sis.pitt.edu', NULL, NULL, NULL, NULL, NULL, '2fd018d2-e8d9-4dc8-a8f6-46405ac00af5', 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9'),
(3, 'b6f4ebf0-3efe-4657-9875-7a1484a02dc3', '2015-06-15 00:52:46', 'DATABASE', 'colfusion.exp.sis.pitt.edu', NULL, NULL, NULL, NULL, NULL, '2fd018d2-e8d9-4dc8-a8f6-46405ac00af5', 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9'),
(3, '2fd018d2-e8d9-4dc8-a8f6-46405ac00af5', '2015-06-15 00:52:46', 'STEP', 'Target Schema', '0', NULL, NULL, NULL, NULL, 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9', 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9'),
(3, '1e09e4ed-028a-47d6-b39a-2e30c7ace45d', '2015-06-15 00:52:46', 'STEP', 'Excel Input File', '0', NULL, NULL, NULL, NULL, 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9', 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9'),
(3, '1e09e4ed-028a-47d6-b39a-2e30c7ace45d', '2015-06-15 00:52:46', 'STEP', 'Excel Input File', '0', NULL, NULL, NULL, NULL, 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9', 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9'),
(3, 'a77d41f1-c773-4e39-83cc-5dc92473d72f', '2015-06-15 00:52:46', 'DATABASE', 'connection_for_logging', NULL, NULL, NULL, NULL, NULL, 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9', 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9'),
(3, 'a77d41f1-c773-4e39-83cc-5dc92473d72f', '2015-06-15 00:52:46', 'DATABASE', 'connection_for_logging', NULL, NULL, NULL, NULL, NULL, 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9', 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9'),
(3, 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9', '2015-06-15 00:52:46', 'TRANS', '4', NULL, '/', 'http://130.49.135.94:8080/Colfusion2.0/temp/11/Sheet1.ktr', NULL, NULL, NULL, 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9'),
(4, '6dcc1f68-99c7-49f7-bccb-5f4f8ab65983', '2015-06-15 18:14:47', 'STEP', 'Get Variables (Do Not Modify)', '0', NULL, NULL, NULL, NULL, 'bf5599c3-df47-4f06-a6eb-e86c4f620584', 'bf5599c3-df47-4f06-a6eb-e86c4f620584'),
(4, '6dcc1f68-99c7-49f7-bccb-5f4f8ab65983', '2015-06-15 18:14:47', 'STEP', 'Get Variables (Do Not Modify)', '0', NULL, NULL, NULL, NULL, 'bf5599c3-df47-4f06-a6eb-e86c4f620584', 'bf5599c3-df47-4f06-a6eb-e86c4f620584'),
(4, '1bf7931e-9cd6-437e-8df9-67ad4dae8b7c', '2015-06-15 18:14:47', 'DATABASE', 'colfusion.exp.sis.pitt.edu', NULL, NULL, NULL, NULL, NULL, '401f8b68-456b-42bb-b510-6a2cfaa2f329', 'bf5599c3-df47-4f06-a6eb-e86c4f620584'),
(4, '1bf7931e-9cd6-437e-8df9-67ad4dae8b7c', '2015-06-15 18:14:47', 'DATABASE', 'colfusion.exp.sis.pitt.edu', NULL, NULL, NULL, NULL, NULL, '401f8b68-456b-42bb-b510-6a2cfaa2f329', 'bf5599c3-df47-4f06-a6eb-e86c4f620584'),
(4, '401f8b68-456b-42bb-b510-6a2cfaa2f329', '2015-06-15 18:14:47', 'STEP', 'Target Schema', '0', NULL, NULL, NULL, NULL, 'bf5599c3-df47-4f06-a6eb-e86c4f620584', 'bf5599c3-df47-4f06-a6eb-e86c4f620584'),
(4, '0ef1966e-82a8-45ac-8529-e6373d168faa', '2015-06-15 18:14:47', 'STEP', 'Excel Input File', '0', NULL, NULL, NULL, NULL, 'bf5599c3-df47-4f06-a6eb-e86c4f620584', 'bf5599c3-df47-4f06-a6eb-e86c4f620584'),
(4, '0ef1966e-82a8-45ac-8529-e6373d168faa', '2015-06-15 18:14:47', 'STEP', 'Excel Input File', '0', NULL, NULL, NULL, NULL, 'bf5599c3-df47-4f06-a6eb-e86c4f620584', 'bf5599c3-df47-4f06-a6eb-e86c4f620584'),
(4, '77f6ed88-361b-48cc-a56d-0d8a3d117d12', '2015-06-15 18:14:47', 'DATABASE', 'connection_for_logging', NULL, NULL, NULL, NULL, NULL, 'bf5599c3-df47-4f06-a6eb-e86c4f620584', 'bf5599c3-df47-4f06-a6eb-e86c4f620584'),
(4, '77f6ed88-361b-48cc-a56d-0d8a3d117d12', '2015-06-15 18:14:47', 'DATABASE', 'connection_for_logging', NULL, NULL, NULL, NULL, NULL, 'bf5599c3-df47-4f06-a6eb-e86c4f620584', 'bf5599c3-df47-4f06-a6eb-e86c4f620584'),
(4, 'bf5599c3-df47-4f06-a6eb-e86c4f620584', '2015-06-15 18:14:47', 'TRANS', '5', NULL, '/', 'http://130.49.135.94:8080/Colfusion2.0/temp/13/Sheet1.ktr', NULL, NULL, NULL, 'bf5599c3-df47-4f06-a6eb-e86c4f620584');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_pentaho_log_performance`
--

CREATE TABLE IF NOT EXISTS `colfusion_pentaho_log_performance` (
  `ID_BATCH` int(11) DEFAULT NULL,
  `SEQ_NR` int(11) DEFAULT NULL,
  `LOGDATE` datetime DEFAULT NULL,
  `TRANSNAME` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `STEPNAME` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
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

--
-- Dumping data for table `colfusion_pentaho_log_performance`
--

INSERT INTO `colfusion_pentaho_log_performance` (`ID_BATCH`, `SEQ_NR`, `LOGDATE`, `TRANSNAME`, `STEPNAME`, `STEP_COPY`, `LINES_READ`, `LINES_WRITTEN`, `LINES_UPDATED`, `LINES_INPUT`, `LINES_OUTPUT`, `LINES_REJECTED`, `ERRORS`, `INPUT_BUFFER_ROWS`, `OUTPUT_BUFFER_ROWS`) VALUES
(0, 1, '2015-06-14 23:53:23', '1', 'Get Variables (Do Not Modify)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 2, '2015-06-14 23:53:24', '1', 'Get Variables (Do Not Modify)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 3, '2015-06-14 23:53:24', '1', 'Get Variables (Do Not Modify)', 0, 3, 3, 0, 0, 0, 0, 0, 0, 0),
(0, 1, '2015-06-14 23:53:23', '1', 'Target Schema', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 2, '2015-06-14 23:53:24', '1', 'Target Schema', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 3, '2015-06-14 23:53:24', '1', 'Target Schema', 0, 3, 3, 0, 0, 3, 0, 0, 0, 0),
(0, 1, '2015-06-14 23:53:23', '1', 'Excel Input File', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 2, '2015-06-14 23:53:24', '1', 'Excel Input File', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(0, 3, '2015-06-14 23:53:24', '1', 'Excel Input File', 0, 0, 3, 0, 3, 0, 0, 0, 0, 0),
(1, 1, '2015-06-15 00:16:34', '2', 'Get Variables (Do Not Modify)', 0, 3, 3, 0, 0, 0, 0, 0, 0, 0),
(1, 2, '2015-06-15 00:16:34', '2', 'Get Variables (Do Not Modify)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 1, '2015-06-15 00:16:34', '2', 'Target Schema', 0, 3, 0, 0, 0, 0, 0, 0, 0, 0),
(1, 2, '2015-06-15 00:16:34', '2', 'Target Schema', 0, 0, 3, 0, 0, 3, 0, 0, 0, 0),
(1, 1, '2015-06-15 00:16:34', '2', 'Excel Input File', 0, 0, 3, 0, 3, 0, 0, 0, 0, 0),
(1, 2, '2015-06-15 00:16:34', '2', 'Excel Input File', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 1, '2015-06-15 00:38:21', '3', 'Get Variables (Do Not Modify)', 0, 3, 3, 0, 0, 0, 0, 0, 0, 0),
(2, 2, '2015-06-15 00:38:21', '3', 'Get Variables (Do Not Modify)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 1, '2015-06-15 00:38:21', '3', 'Target Schema', 0, 3, 0, 0, 0, 0, 0, 0, 0, 0),
(2, 2, '2015-06-15 00:38:21', '3', 'Target Schema', 0, 0, 3, 0, 0, 3, 0, 0, 0, 0),
(2, 1, '2015-06-15 00:38:21', '3', 'Excel Input File', 0, 0, 3, 0, 3, 0, 0, 0, 0, 0),
(2, 2, '2015-06-15 00:38:21', '3', 'Excel Input File', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 1, '2015-06-15 00:52:46', '4', 'Get Variables (Do Not Modify)', 0, 3, 3, 0, 0, 0, 0, 0, 0, 0),
(3, 2, '2015-06-15 00:52:46', '4', 'Get Variables (Do Not Modify)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 1, '2015-06-15 00:52:46', '4', 'Target Schema', 0, 3, 0, 0, 0, 0, 0, 0, 0, 0),
(3, 2, '2015-06-15 00:52:46', '4', 'Target Schema', 0, 0, 3, 0, 0, 3, 0, 0, 0, 0),
(3, 1, '2015-06-15 00:52:46', '4', 'Excel Input File', 0, 0, 3, 0, 3, 0, 0, 0, 0, 0),
(3, 2, '2015-06-15 00:52:46', '4', 'Excel Input File', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 1, '2015-06-15 18:14:47', '5', 'Get Variables (Do Not Modify)', 0, 3, 3, 0, 0, 0, 0, 0, 0, 0),
(4, 2, '2015-06-15 18:14:47', '5', 'Get Variables (Do Not Modify)', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 1, '2015-06-15 18:14:47', '5', 'Target Schema', 0, 3, 0, 0, 0, 0, 0, 0, 0, 0),
(4, 2, '2015-06-15 18:14:47', '5', 'Target Schema', 0, 0, 3, 0, 0, 3, 0, 0, 0, 0),
(4, 1, '2015-06-15 18:14:47', '5', 'Excel Input File', 0, 0, 3, 0, 3, 0, 0, 0, 0, 0),
(4, 2, '2015-06-15 18:14:47', '5', 'Excel Input File', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_pentaho_log_step`
--

CREATE TABLE IF NOT EXISTS `colfusion_pentaho_log_step` (
  `ID_BATCH` int(11) DEFAULT NULL,
  `CHANNEL_ID` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `LOG_DATE` datetime DEFAULT NULL,
  `TRANSNAME` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `STEPNAME` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `STEP_COPY` int(11) DEFAULT NULL,
  `LINES_READ` bigint(20) DEFAULT NULL,
  `LINES_WRITTEN` bigint(20) DEFAULT NULL,
  `LINES_UPDATED` bigint(20) DEFAULT NULL,
  `LINES_INPUT` bigint(20) DEFAULT NULL,
  `LINES_OUTPUT` bigint(20) DEFAULT NULL,
  `LINES_REJECTED` bigint(20) DEFAULT NULL,
  `ERRORS` bigint(20) DEFAULT NULL,
  `LOG_FIELD` mediumtext CHARACTER SET utf8
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `colfusion_pentaho_log_step`
--

INSERT INTO `colfusion_pentaho_log_step` (`ID_BATCH`, `CHANNEL_ID`, `LOG_DATE`, `TRANSNAME`, `STEPNAME`, `STEP_COPY`, `LINES_READ`, `LINES_WRITTEN`, `LINES_UPDATED`, `LINES_INPUT`, `LINES_OUTPUT`, `LINES_REJECTED`, `ERRORS`, `LOG_FIELD`) VALUES
(0, '47dab9df-ff22-429e-a479-94d9b0597ae2', '2015-06-14 23:53:24', '1', 'Get Variables (Do Not Modify)', 0, 3, 3, 0, 0, 0, 0, 0, '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/14 23:53:24 - Get Variables (Do Not Modify).0 - Finished processing (I=0, O=0, R=3, W=3, U=0, E=0)\r\n\r\nSTART\r\n'),
(0, 'd077019c-50b4-411e-abc6-2196223b0b8a', '2015-06-14 23:53:24', '1', 'Target Schema', 0, 3, 3, 0, 0, 3, 0, 0, '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/14 23:53:22 - Target Schema.0 - Connected to database [colfusion.exp.sis.pitt.edu] (commit=1000)\r\n2015/06/14 23:53:24 - Target Schema.0 - Finished processing (I=0, O=3, R=3, W=3, U=0, E=0)\r\n\r\nSTART\r\n'),
(0, '599079b2-da94-4419-870a-a08468985c0d', '2015-06-14 23:53:24', '1', 'Excel Input File', 0, 0, 3, 0, 3, 0, 0, 0, '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/14 23:53:24 - Excel Input File.0 - Finished processing (I=3, O=0, R=0, W=3, U=0, E=0)\r\n\r\nSTART\r\n'),
(1, 'e8eeddfc-981a-492d-8b5b-4a5413585d6f', '2015-06-15 00:16:34', '2', 'Get Variables (Do Not Modify)', 0, 3, 3, 0, 0, 0, 0, 0, '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 00:16:34 - Get Variables (Do Not Modify).0 - Finished processing (I=0, O=0, R=3, W=3, U=0, E=0)\r\n\r\nSTART\r\n'),
(1, '9d43c1c9-e34a-42b1-897f-d48e139828c3', '2015-06-15 00:16:34', '2', 'Target Schema', 0, 3, 3, 0, 0, 3, 0, 0, '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 00:16:34 - Target Schema.0 - Connected to database [colfusion.exp.sis.pitt.edu] (commit=1000)\r\n2015/06/15 00:16:34 - Target Schema.0 - Finished processing (I=0, O=3, R=3, W=3, U=0, E=0)\r\n\r\nSTART\r\n'),
(1, 'e2b937eb-ead0-4ff0-ac1c-9dca464e50b2', '2015-06-15 00:16:34', '2', 'Excel Input File', 0, 0, 3, 0, 3, 0, 0, 0, '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 00:16:34 - Excel Input File.0 - Finished processing (I=3, O=0, R=0, W=3, U=0, E=0)\r\n\r\nSTART\r\n'),
(2, 'a9017ffd-aa0b-45b7-a0c5-f76da92f2516', '2015-06-15 00:38:22', '3', 'Get Variables (Do Not Modify)', 0, 3, 3, 0, 0, 0, 0, 0, '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 00:38:21 - Get Variables (Do Not Modify).0 - Finished processing (I=0, O=0, R=3, W=3, U=0, E=0)\r\n\r\nSTART\r\n'),
(2, '3e71df5f-c797-4e41-9fd1-6d2faf67299a', '2015-06-15 00:38:22', '3', 'Target Schema', 0, 3, 3, 0, 0, 3, 0, 0, '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 00:38:21 - Target Schema.0 - Connected to database [colfusion.exp.sis.pitt.edu] (commit=1000)\r\n2015/06/15 00:38:21 - Target Schema.0 - Finished processing (I=0, O=3, R=3, W=3, U=0, E=0)\r\n\r\nSTART\r\n'),
(2, '967c1964-9c1a-4033-8e9b-238b4f4e83f4', '2015-06-15 00:38:22', '3', 'Excel Input File', 0, 0, 3, 0, 3, 0, 0, 0, '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 00:38:21 - Excel Input File.0 - Finished processing (I=3, O=0, R=0, W=3, U=0, E=0)\r\n\r\nSTART\r\n'),
(3, 'f4479fd9-a198-4609-90f1-d7e62b942c18', '2015-06-15 00:52:46', '4', 'Get Variables (Do Not Modify)', 0, 3, 3, 0, 0, 0, 0, 0, '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 00:52:45 - Get Variables (Do Not Modify).0 - Finished processing (I=0, O=0, R=3, W=3, U=0, E=0)\r\n\r\nSTART\r\n'),
(3, '2fd018d2-e8d9-4dc8-a8f6-46405ac00af5', '2015-06-15 00:52:46', '4', 'Target Schema', 0, 3, 3, 0, 0, 3, 0, 0, '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 00:52:45 - Target Schema.0 - Connected to database [colfusion.exp.sis.pitt.edu] (commit=1000)\r\n2015/06/15 00:52:46 - Target Schema.0 - Finished processing (I=0, O=3, R=3, W=3, U=0, E=0)\r\n\r\nSTART\r\n'),
(3, '1e09e4ed-028a-47d6-b39a-2e30c7ace45d', '2015-06-15 00:52:46', '4', 'Excel Input File', 0, 0, 3, 0, 3, 0, 0, 0, '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 00:52:45 - Excel Input File.0 - Finished processing (I=3, O=0, R=0, W=3, U=0, E=0)\r\n\r\nSTART\r\n'),
(4, '6dcc1f68-99c7-49f7-bccb-5f4f8ab65983', '2015-06-15 18:14:47', '5', 'Get Variables (Do Not Modify)', 0, 3, 3, 0, 0, 0, 0, 0, '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 18:14:47 - Get Variables (Do Not Modify).0 - Finished processing (I=0, O=0, R=3, W=3, U=0, E=0)\r\n\r\nSTART\r\n'),
(4, '401f8b68-456b-42bb-b510-6a2cfaa2f329', '2015-06-15 18:14:47', '5', 'Target Schema', 0, 3, 3, 0, 0, 3, 0, 0, '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 18:14:47 - Target Schema.0 - Connected to database [colfusion.exp.sis.pitt.edu] (commit=1000)\r\n2015/06/15 18:14:47 - Target Schema.0 - Finished processing (I=0, O=3, R=3, W=3, U=0, E=0)\r\n\r\nSTART\r\n'),
(4, '0ef1966e-82a8-45ac-8529-e6373d168faa', '2015-06-15 18:14:47', '5', 'Excel Input File', 0, 0, 3, 0, 3, 0, 0, 0, '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 18:14:47 - Excel Input File.0 - Finished processing (I=3, O=0, R=0, W=3, U=0, E=0)\r\n\r\nSTART\r\n');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_pentaho_log_transformaion`
--

CREATE TABLE IF NOT EXISTS `colfusion_pentaho_log_transformaion` (
  `ID_BATCH` int(11) DEFAULT NULL,
  `CHANNEL_ID` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `TRANSNAME` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `STATUS` varchar(15) CHARACTER SET utf8 DEFAULT NULL,
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
  `LOG_FIELD` mediumtext CHARACTER SET utf8,
  KEY `IDX_colfusion_pentaho_log_transformaion_1` (`ID_BATCH`),
  KEY `IDX_colfusion_pentaho_log_transformaion_2` (`ERRORS`,`STATUS`,`TRANSNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `colfusion_pentaho_log_transformaion`
--

INSERT INTO `colfusion_pentaho_log_transformaion` (`ID_BATCH`, `CHANNEL_ID`, `TRANSNAME`, `STATUS`, `LINES_READ`, `LINES_WRITTEN`, `LINES_UPDATED`, `LINES_INPUT`, `LINES_OUTPUT`, `LINES_REJECTED`, `ERRORS`, `STARTDATE`, `ENDDATE`, `LOGDATE`, `DEPDATE`, `REPLAYDATE`, `LOG_FIELD`) VALUES
(0, '2f40a23f-cd95-41e9-af44-cd4c8c227ac3', '1', 'end', 0, 3, 0, 0, 0, 0, 0, '1899-12-31 18:00:00', '2015-06-14 23:53:21', '2015-06-14 23:53:24', '2015-06-14 23:53:21', '2015-06-14 23:53:21', '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/14 23:53:21 - 1 - Dispatching started for transformation [1]\r\n2015/06/14 23:53:22 - Target Schema.0 - Connected to database [colfusion.exp.sis.pitt.edu] (commit=1000)\r\n2015/06/14 23:53:24 - Excel Input File.0 - Finished processing (I=3, O=0, R=0, W=3, U=0, E=0)\r\n2015/06/14 23:53:24 - Get Variables (Do Not Modify).0 - Finished processing (I=0, O=0, R=3, W=3, U=0, E=0)\r\n2015/06/14 23:53:24 - Target Schema.0 - Finished processing (I=0, O=3, R=3, W=3, U=0, E=0)\r\n\r\nEND\r\n'),
(1, '6a051903-ca67-4834-8516-40c5bcad4441', '2', 'end', 0, 3, 0, 0, 0, 0, 0, '1899-12-31 18:00:00', '2015-06-15 00:16:34', '2015-06-15 00:16:34', '2015-06-15 00:16:34', '2015-06-15 00:16:34', '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 00:16:34 - 2 - Dispatching started for transformation [2]\r\n2015/06/15 00:16:34 - Target Schema.0 - Connected to database [colfusion.exp.sis.pitt.edu] (commit=1000)\r\n2015/06/15 00:16:34 - Excel Input File.0 - Finished processing (I=3, O=0, R=0, W=3, U=0, E=0)\r\n2015/06/15 00:16:34 - Get Variables (Do Not Modify).0 - Finished processing (I=0, O=0, R=3, W=3, U=0, E=0)\r\n2015/06/15 00:16:34 - Target Schema.0 - Finished processing (I=0, O=3, R=3, W=3, U=0, E=0)\r\n\r\nEND\r\n'),
(2, '42ba255a-8fd7-433e-bb8e-50c36de4b735', '3', 'end', 0, 3, 0, 0, 0, 0, 0, '1899-12-31 18:00:00', '2015-06-15 00:38:21', '2015-06-15 00:38:21', '2015-06-15 00:38:21', '2015-06-15 00:38:21', '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 00:38:21 - 3 - Dispatching started for transformation [3]\r\n2015/06/15 00:38:21 - Target Schema.0 - Connected to database [colfusion.exp.sis.pitt.edu] (commit=1000)\r\n2015/06/15 00:38:21 - Excel Input File.0 - Finished processing (I=3, O=0, R=0, W=3, U=0, E=0)\r\n2015/06/15 00:38:21 - Get Variables (Do Not Modify).0 - Finished processing (I=0, O=0, R=3, W=3, U=0, E=0)\r\n2015/06/15 00:38:21 - Target Schema.0 - Finished processing (I=0, O=3, R=3, W=3, U=0, E=0)\r\n\r\nEND\r\n'),
(3, 'd9eb8cd0-59d5-427a-9e0a-14f1c9bf36a9', '4', 'end', 0, 3, 0, 0, 0, 0, 0, '1899-12-31 18:00:00', '2015-06-15 00:52:45', '2015-06-15 00:52:46', '2015-06-15 00:52:45', '2015-06-15 00:52:45', '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 00:52:45 - 4 - Dispatching started for transformation [4]\r\n2015/06/15 00:52:45 - Target Schema.0 - Connected to database [colfusion.exp.sis.pitt.edu] (commit=1000)\r\n2015/06/15 00:52:45 - Excel Input File.0 - Finished processing (I=3, O=0, R=0, W=3, U=0, E=0)\r\n2015/06/15 00:52:45 - Get Variables (Do Not Modify).0 - Finished processing (I=0, O=0, R=3, W=3, U=0, E=0)\r\n2015/06/15 00:52:46 - Target Schema.0 - Finished processing (I=0, O=3, R=3, W=3, U=0, E=0)\r\n\r\nEND\r\n'),
(4, 'bf5599c3-df47-4f06-a6eb-e86c4f620584', '5', 'end', 0, 3, 0, 0, 0, 0, 0, '1899-12-31 18:00:00', '2015-06-15 18:14:47', '2015-06-15 18:14:47', '2015-06-15 18:14:47', '2015-06-15 18:14:47', '2015/06/14 23:53:21 - Carte - Installing timer to purge stale objects after 1440 minutes.\r\n2015/06/15 18:14:47 - 5 - Dispatching started for transformation [5]\r\n2015/06/15 18:14:47 - Target Schema.0 - Connected to database [colfusion.exp.sis.pitt.edu] (commit=1000)\r\n2015/06/15 18:14:47 - Excel Input File.0 - Finished processing (I=3, O=0, R=0, W=3, U=0, E=0)\r\n2015/06/15 18:14:47 - Get Variables (Do Not Modify).0 - Finished processing (I=0, O=0, R=3, W=3, U=0, E=0)\r\n2015/06/15 18:14:47 - Target Schema.0 - Finished processing (I=0, O=3, R=3, W=3, U=0, E=0)\r\n\r\nEND\r\n');

--
-- Triggers `colfusion_pentaho_log_transformaion`
--
DROP TRIGGER IF EXISTS `transformation_after_insert`;
DELIMITER //
CREATE TRIGGER `transformation_after_insert` AFTER INSERT ON `colfusion_pentaho_log_transformaion`
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
    END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `transformation_after_update`;
DELIMITER //
CREATE TRIGGER `transformation_after_update` AFTER UPDATE ON `colfusion_pentaho_log_transformaion`
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
    END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_processes`
--

CREATE TABLE IF NOT EXISTS `colfusion_processes` (
  `pid` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(7) CHARACTER SET utf8 DEFAULT NULL,
  `processSer` longtext CHARACTER SET utf8 COMMENT 'JSON serialization of the process',
  `processClass` longtext CHARACTER SET utf8,
  `reasonForStatus` longtext CHARACTER SET utf8,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `colfusion_processes`
--

INSERT INTO `colfusion_processes` (`pid`, `status`, `processSer`, `processClass`, `reasonForStatus`) VALUES
(1, 'done', '{"sid":5,"_id":1,"_description":"","creationsTime":"Jun 14, 2015 11:53:18 PM","runStartTime":"Jun 14, 2015 11:53:19 PM","runEndTime":"Jun 14, 2015 11:53:25 PM","_exceptions":[]}', 'edu.pitt.sis.exp.colfusion.dataLoadExecutors.DataLoadExecutorKTRImpl', 'process succesfully finished'),
(2, 'done', '{"sid":6,"_id":2,"_description":"","creationsTime":"Jun 15, 2015 12:16:32 AM","runStartTime":"Jun 15, 2015 12:16:32 AM","runEndTime":"Jun 15, 2015 12:16:34 AM","_exceptions":[]}', 'edu.pitt.sis.exp.colfusion.dataLoadExecutors.DataLoadExecutorKTRImpl', 'process succesfully finished'),
(3, 'done', '{"sid":10,"_id":3,"_description":"","creationsTime":"Jun 15, 2015 12:38:20 AM","runStartTime":"Jun 15, 2015 12:38:20 AM","runEndTime":"Jun 15, 2015 12:38:22 AM","_exceptions":[]}', 'edu.pitt.sis.exp.colfusion.dataLoadExecutors.DataLoadExecutorKTRImpl', 'process succesfully finished'),
(4, 'done', '{"sid":11,"_id":4,"_description":"","creationsTime":"Jun 15, 2015 12:52:43 AM","runStartTime":"Jun 15, 2015 12:52:44 AM","runEndTime":"Jun 15, 2015 12:52:46 AM","_exceptions":[]}', 'edu.pitt.sis.exp.colfusion.dataLoadExecutors.DataLoadExecutorKTRImpl', 'process succesfully finished'),
(5, 'done', '{"sid":13,"_id":5,"_description":"","creationsTime":"Jun 15, 2015 6:14:46 PM","runStartTime":"Jun 15, 2015 6:14:46 PM","runEndTime":"Jun 15, 2015 6:14:48 PM","_exceptions":[]}', 'edu.pitt.sis.exp.colfusion.dataLoadExecutors.DataLoadExecutorKTRImpl', 'process succesfully finished');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_psc_sourceinfo_table`
--

CREATE TABLE IF NOT EXISTS `colfusion_psc_sourceinfo_table` (
  `sid` int(11) NOT NULL,
  `tableName` varchar(255) CHARACTER SET utf8 NOT NULL,
  `pid` int(11) DEFAULT NULL,
  `pscDatabaseName` varchar(64) CHARACTER SET utf8 NOT NULL,
  `pscTableName` varchar(64) CHARACTER SET utf8 NOT NULL COMMENT 'THIS COMMENT SHOULD BE ON A TABLE LEVEL The table that maps colfusion sid and table name to the database and table on psd server',
  `pscHost` varchar(255) CHARACTER SET utf8 NOT NULL,
  `pscDatabasePort` int(11) NOT NULL,
  `pscDatabaseUser` varchar(255) CHARACTER SET utf8 NOT NULL,
  `pscDatabasePassword` varchar(255) CHARACTER SET utf8 NOT NULL,
  `pscDatabaseVendor` varchar(255) CHARACTER SET utf8 NOT NULL,
  `whenReplicationStarted` datetime DEFAULT NULL,
  `whenReplicationFinished` datetime DEFAULT NULL,
  PRIMARY KEY (`sid`,`tableName`),
  KEY `FK_k74kljav616dstg1qf6pt5d6i` (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_redirects`
--

CREATE TABLE IF NOT EXISTS `colfusion_redirects` (
  `redirect_id` int(11) NOT NULL AUTO_INCREMENT,
  `redirect_old` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `redirect_new` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`redirect_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_relationships`
--

CREATE TABLE IF NOT EXISTS `colfusion_relationships` (
  `rel_id` int(11) NOT NULL AUTO_INCREMENT,
  `sid1` int(11) NOT NULL,
  `creator` int(11) NOT NULL,
  `sid2` int(11) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `description` longtext CHARACTER SET utf8,
  `creation_time` datetime NOT NULL,
  `tableName1` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `tableName2` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `status` int(11) NOT NULL COMMENT '0->valid, 1->deleted, 2->new, indexes on the columns are not created yet.',
  PRIMARY KEY (`rel_id`),
  KEY `FK_jgq89ds8g9jluu07jwjuv92jk` (`sid1`),
  KEY `FK_p2pwoqg4uc0ccmubaaaldmoqo` (`creator`),
  KEY `FK_1qm11x24s30iv7m83uu7gqs7b` (`sid2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_relationships_columns`
--

CREATE TABLE IF NOT EXISTS `colfusion_relationships_columns` (
  `rel_id` int(11) NOT NULL,
  `cl_from` varchar(255) CHARACTER SET utf8 NOT NULL,
  `cl_to` varchar(255) CHARACTER SET utf8 NOT NULL,
  `dataMatchingFromRatio` decimal(4,2) DEFAULT NULL,
  `dataMatchingToRatio` decimal(4,2) DEFAULT NULL,
  PRIMARY KEY (`rel_id`,`cl_from`,`cl_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_relationships_columns_cachingexecutioninfo`
--

CREATE TABLE IF NOT EXISTS `colfusion_relationships_columns_cachingexecutioninfo` (
  `transformation` varchar(255) CHARACTER SET utf8 NOT NULL,
  `status` longtext CHARACTER SET utf8,
  `timeStart` datetime DEFAULT NULL,
  `timeEnd` datetime DEFAULT NULL,
  `errorMessage` longtext CHARACTER SET utf8,
  `query` longtext CHARACTER SET utf8,
  PRIMARY KEY (`transformation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_relationships_columns_dataMathing_ratios`
--

CREATE TABLE IF NOT EXISTS `colfusion_relationships_columns_dataMathing_ratios` (
  `cl_from` varchar(255) CHARACTER SET utf8 NOT NULL,
  `cl_to` varchar(255) CHARACTER SET utf8 NOT NULL,
  `similarity_threshold` decimal(4,3) NOT NULL,
  `pid` int(11) NOT NULL,
  `dataMatchingFromRatio` decimal(4,3) DEFAULT NULL,
  `dataMatchingToRatio` decimal(4,3) DEFAULT NULL,
  PRIMARY KEY (`cl_from`,`cl_to`,`similarity_threshold`),
  KEY `FK_outwl9bbsr7rwqf2y4o5ktdvw` (`pid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_saved_links`
--

CREATE TABLE IF NOT EXISTS `colfusion_saved_links` (
  `saved_id` int(11) NOT NULL AUTO_INCREMENT,
  `saved_user_id` int(11) NOT NULL,
  `saved_link_id` int(11) NOT NULL,
  `saved_privacy` varchar(8) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`saved_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_services`
--

CREATE TABLE IF NOT EXISTS `colfusion_services` (
  `service_id` int(11) NOT NULL AUTO_INCREMENT,
  `service_name` varchar(20) CHARACTER SET utf8 NOT NULL,
  `service_address` varchar(30) CHARACTER SET utf8 NOT NULL,
  `port_number` int(11) NOT NULL,
  `service_dir` varchar(100) CHARACTER SET utf8 NOT NULL,
  `service_command` varchar(100) CHARACTER SET utf8 NOT NULL,
  `service_status` varchar(20) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`service_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_shares`
--

CREATE TABLE IF NOT EXISTS `colfusion_shares` (
  `vid` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `privilege` int(11) NOT NULL,
  PRIMARY KEY (`vid`,`user_id`,`privilege`),
  KEY `FK_mvoxkkf0u1q0c16g4r0351tds` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_sourceinfo`
--

CREATE TABLE IF NOT EXISTS `colfusion_sourceinfo` (
  `Sid` int(11) NOT NULL AUTO_INCREMENT,
  `license_ID` int(11) DEFAULT NULL,
  `UserId` int(11) NOT NULL,
  `Title` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `Path` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `EntryDate` datetime NOT NULL,
  `LastUpdated` datetime DEFAULT NULL,
  `Status` varchar(30) CHARACTER SET utf8 DEFAULT NULL,
  `raw_data_path` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `source_type` varchar(45) CHARACTER SET utf8 NOT NULL COMMENT 'type of the source: whether it was submitted as file or as database',
  `provenance` longtext CHARACTER SET utf8,
  PRIMARY KEY (`Sid`),
  KEY `FK_hrcfg5c3u36rphe7yqh391u3h` (`license_ID`),
  KEY `FK_mrbc8gx8a89v6ge8jsx0ld8of` (`UserId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=14 ;

--
-- Dumping data for table `colfusion_sourceinfo`
--

INSERT INTO `colfusion_sourceinfo` (`Sid`, `license_ID`, `UserId`, `Title`, `Path`, `EntryDate`, `LastUpdated`, `Status`, `raw_data_path`, `source_type`, `provenance`) VALUES
(1, NULL, 26, NULL, NULL, '2015-06-14 23:40:16', NULL, 'draft', NULL, 'data file', NULL),
(2, NULL, 26, NULL, NULL, '2015-06-14 23:42:58', NULL, 'draft', NULL, 'data file', NULL),
(3, NULL, 26, NULL, NULL, '2015-06-14 23:44:27', NULL, 'draft', NULL, 'data file', NULL),
(4, NULL, 26, NULL, NULL, '2015-06-14 23:50:25', NULL, 'draft', NULL, 'data file', NULL),
(5, NULL, 26, 'very first test', NULL, '2015-06-14 19:51:56', NULL, 'queued', NULL, 'data file', NULL),
(6, NULL, 26, 'second', NULL, '2015-06-14 20:16:01', NULL, 'queued', NULL, 'data file', NULL),
(7, NULL, 26, NULL, NULL, '2015-06-15 00:34:00', NULL, 'draft', NULL, 'data file', NULL),
(8, NULL, 26, NULL, NULL, '2015-06-15 00:34:09', NULL, 'draft', NULL, 'data file', NULL),
(9, NULL, 26, NULL, NULL, '2015-06-15 00:35:42', NULL, 'draft', NULL, 'data file', NULL),
(10, NULL, 26, 'third', NULL, '2015-06-14 20:36:05', NULL, 'queued', NULL, 'data file', NULL),
(11, NULL, 26, 'fourth', NULL, '2015-06-14 20:52:15', NULL, 'queued', NULL, 'data file', NULL),
(12, NULL, 26, NULL, NULL, '2015-06-15 11:15:10', NULL, 'draft', NULL, 'data file', NULL),
(13, NULL, 26, 'fifth', NULL, '2015-06-15 14:14:19', NULL, 'queued', NULL, 'data file', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_sourceinfo_DB`
--

CREATE TABLE IF NOT EXISTS `colfusion_sourceinfo_DB` (
  `sid` int(11) NOT NULL,
  `server_address` varchar(255) CHARACTER SET utf8 NOT NULL,
  `port` int(11) NOT NULL,
  `user_name` varchar(255) CHARACTER SET utf8 NOT NULL,
  `password` varchar(255) CHARACTER SET utf8 NOT NULL,
  `source_database` varchar(255) CHARACTER SET utf8 NOT NULL,
  `driver` varchar(255) CHARACTER SET utf8 NOT NULL,
  `is_local` int(11) DEFAULT NULL COMMENT '1 - means database was created from dump file and is stored on our server, 0 - means that database was submitted as remote database and the data is stored somewhere not on our server',
  `linked_server_name` varchar(255) CHARACTER SET utf8 DEFAULT NULL COMMENT 'Stores linked server name of the database. This value will be different only for remotely submitted databases because we give collusion internal name for them when create a linked server.',
  PRIMARY KEY (`sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `colfusion_sourceinfo_DB`
--

INSERT INTO `colfusion_sourceinfo_DB` (`sid`, `server_address`, `port`, `user_name`, `password`, `source_database`, `driver`, `is_local`, `linked_server_name`) VALUES
(5, '130.49.135.94', 3306, 'ImportTester', 'importtester', 'colfusion2_0_fileToDB_5', 'mysql', 1, 'colfusion2_0_fileToDB_5'),
(6, '130.49.135.94', 3306, 'ImportTester', 'importtester', 'colfusion2_0_fileToDB_6', 'mysql', 1, 'colfusion2_0_fileToDB_6'),
(10, '130.49.135.94', 3306, 'ImportTester', 'importtester', 'colfusion2_0_fileToDB_10', 'mysql', 1, 'colfusion2_0_fileToDB_10'),
(11, '130.49.135.94', 3306, 'ImportTester', 'importtester', 'colfusion2_0_fileToDB_11', 'mysql', 1, 'colfusion2_0_fileToDB_11'),
(13, '130.49.135.94', 3306, 'ImportTester', 'importtester', 'colfusion2_0_fileToDB_13', 'mysql', 1, 'colfusion2_0_fileToDB_13');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_sourceinfo_metadata_edit_history`
--

CREATE TABLE IF NOT EXISTS `colfusion_sourceinfo_metadata_edit_history` (
  `hid` int(11) NOT NULL AUTO_INCREMENT,
  `sid` int(11) NOT NULL COMMENT 'source info id',
  `uid` int(11) NOT NULL COMMENT 'userid who made edit',
  `whenSaved` datetime NOT NULL COMMENT 'when the edit was done',
  `item` varchar(11) CHARACTER SET utf8 NOT NULL,
  `reason` longtext CHARACTER SET utf8,
  `itemValue` longtext CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`hid`),
  KEY `FK_gsq54ere2j3yyaeoisbw9p508` (`sid`),
  KEY `FK_k5ms6go5yg2ly8gty3q2sxso6` (`uid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=21 ;

--
-- Dumping data for table `colfusion_sourceinfo_metadata_edit_history`
--

INSERT INTO `colfusion_sourceinfo_metadata_edit_history` (`hid`, `sid`, `uid`, `whenSaved`, `item`, `reason`, `itemValue`) VALUES
(1, 5, 26, '2015-06-14 23:53:43', 'title', NULL, 'very first test'),
(2, 5, 26, '2015-06-14 23:53:43', 'status', NULL, 'queued'),
(3, 5, 26, '2015-06-14 23:53:43', 'description', NULL, 'test'),
(4, 5, 26, '2015-06-14 23:53:43', 'tags', NULL, ''),
(5, 6, 26, '2015-06-15 00:31:43', 'title', NULL, 'second'),
(6, 6, 26, '2015-06-15 00:31:43', 'status', NULL, 'queued'),
(7, 6, 26, '2015-06-15 00:31:43', 'description', NULL, 'test'),
(8, 6, 26, '2015-06-15 00:31:43', 'tags', NULL, ''),
(9, 10, 26, '2015-06-15 00:52:00', 'title', NULL, 'third'),
(10, 10, 26, '2015-06-15 00:52:00', 'status', NULL, 'queued'),
(11, 10, 26, '2015-06-15 00:52:00', 'description', NULL, 'test'),
(12, 10, 26, '2015-06-15 00:52:00', 'tags', NULL, ''),
(13, 11, 26, '2015-06-15 00:53:08', 'title', NULL, 'fourth'),
(14, 11, 26, '2015-06-15 00:53:08', 'status', NULL, 'queued'),
(15, 11, 26, '2015-06-15 00:53:08', 'description', NULL, 'test'),
(16, 11, 26, '2015-06-15 00:53:08', 'tags', NULL, ''),
(17, 13, 26, '2015-06-15 18:14:53', 'title', NULL, 'fifth'),
(18, 13, 26, '2015-06-15 18:14:53', 'status', NULL, 'queued'),
(19, 13, 26, '2015-06-15 18:14:53', 'description', NULL, 'test'),
(20, 13, 26, '2015-06-15 18:14:53', 'tags', NULL, '');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_sourceinfo_table_ktr`
--

CREATE TABLE IF NOT EXISTS `colfusion_sourceinfo_table_ktr` (
  `sid` int(11) NOT NULL,
  `tableName` varchar(255) CHARACTER SET utf8 NOT NULL,
  `pathToKTRFile` longtext CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`sid`,`tableName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `colfusion_sourceinfo_table_ktr`
--

INSERT INTO `colfusion_sourceinfo_table_ktr` (`sid`, `tableName`, `pathToKTRFile`) VALUES
(5, 'Sheet1', 'C:\\wamp\\www\\Colfusion2.0\\temp\\5\\Sheet1.ktr'),
(6, 'Sheet1', 'C:\\wamp\\www\\Colfusion2.0\\temp\\6\\Sheet1.ktr'),
(10, 'Sheet1', 'C:\\wamp\\www\\Colfusion2.0\\temp\\10\\Sheet1.ktr'),
(11, 'Sheet1', 'C:\\wamp\\www\\Colfusion2.0\\temp\\11\\Sheet1.ktr'),
(13, 'Sheet1', 'C:\\wamp\\www\\Colfusion2.0\\temp\\13\\Sheet1.ktr');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_sourceinfo_user`
--

CREATE TABLE IF NOT EXISTS `colfusion_sourceinfo_user` (
  `sid` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `rid` int(11) NOT NULL,
  PRIMARY KEY (`sid`,`uid`,`rid`),
  KEY `FK_kvymtcpvongyfrk5mq44dumrg` (`rid`),
  KEY `FK_n7pcs7ldlq4smu87xlnjalsg7` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `colfusion_sourceinfo_user`
--

INSERT INTO `colfusion_sourceinfo_user` (`sid`, `uid`, `rid`) VALUES
(1, 26, 1),
(2, 26, 1),
(3, 26, 1),
(4, 26, 1),
(5, 26, 1),
(6, 26, 1),
(7, 26, 1),
(8, 26, 1),
(9, 26, 1),
(10, 26, 1),
(11, 26, 1),
(12, 26, 1),
(13, 26, 1);

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_synonyms_from`
--

CREATE TABLE IF NOT EXISTS `colfusion_synonyms_from` (
  `syn_id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `tableName` varchar(255) CHARACTER SET utf8 NOT NULL,
  `transInput` varchar(255) CHARACTER SET utf8 NOT NULL,
  `value` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`syn_id`,`userId`,`sid`,`tableName`,`transInput`,`value`),
  KEY `FK_hwaafrhxx1oxfq5bqvexub87f` (`sid`),
  KEY `FK_anrqb561xlvudlccfcubno765` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_synonyms_to`
--

CREATE TABLE IF NOT EXISTS `colfusion_synonyms_to` (
  `syn_id` int(11) NOT NULL,
  `userId` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `tableName` varchar(255) CHARACTER SET utf8 NOT NULL,
  `transInput` varchar(255) CHARACTER SET utf8 NOT NULL,
  `value` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`syn_id`,`userId`,`sid`,`tableName`,`transInput`,`value`),
  KEY `FK_7dw4w6lncy1u5fp68whu2l583` (`sid`),
  KEY `FK_iy15ri9da0iwp3tvrk7wiox5` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_table_change_log`
--

CREATE TABLE IF NOT EXISTS `colfusion_table_change_log` (
  `sid` int(255) NOT NULL,
  `tableName` varchar(255) CHARACTER SET utf8 NOT NULL,
  `startChangeTime` datetime NOT NULL,
  `endChangeTime` datetime DEFAULT NULL,
  `operatedUser` varchar(32) CHARACTER SET utf8 NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `colfusion_table_change_log`
--

INSERT INTO `colfusion_table_change_log` (`sid`, `tableName`, `startChangeTime`, `endChangeTime`, `operatedUser`) VALUES
(11, 'Sheet1', '2015-06-15 09:24:18', '2015-06-15 09:35:21', '26'),
(11, 'Sheet1', '2015-06-15 09:36:18', '2015-06-15 09:40:29', '26'),
(11, 'Sheet1', '2015-06-15 09:40:39', '2015-06-15 09:48:17', '26'),
(11, 'Sheet1', '2015-06-15 09:48:24', '2015-06-15 10:22:07', '26'),
(11, 'Sheet1', '2015-06-15 10:22:24', '2015-06-15 10:43:17', '26');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_tags`
--

CREATE TABLE IF NOT EXISTS `colfusion_tags` (
  `tag_link_id` int(11) NOT NULL,
  `tag_lang` varchar(4) CHARACTER SET utf8 NOT NULL,
  `tag_date` datetime NOT NULL,
  `tag_words` varchar(64) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`tag_link_id`,`tag_lang`,`tag_date`,`tag_words`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_tag_cache`
--

CREATE TABLE IF NOT EXISTS `colfusion_tag_cache` (
  `tag_words` varchar(64) CHARACTER SET utf8 NOT NULL,
  `count` int(11) NOT NULL,
  PRIMARY KEY (`tag_words`,`count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_target`
--

CREATE TABLE IF NOT EXISTS `colfusion_target` (
  `Tid` int(11) NOT NULL AUTO_INCREMENT,
  `Sid` int(11) NOT NULL,
  `Spd` date DEFAULT NULL,
  `Drd` date DEFAULT NULL,
  `Dname` varchar(80) CHARACTER SET utf8 DEFAULT NULL,
  `Location` varchar(40) CHARACTER SET utf8 DEFAULT NULL,
  `AggrType` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `Start` date DEFAULT NULL,
  `End` date DEFAULT NULL,
  `Value` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `Eid` int(11) NOT NULL,
  `Country` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `CountrySubDiv` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `Locality` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
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
  `Dname` varchar(80) CHARACTER SET utf8 DEFAULT NULL,
  `Location` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `AggrType` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `Start` date DEFAULT NULL,
  `End` date DEFAULT NULL,
  `Value` longtext CHARACTER SET utf8,
  `Eid` int(11) NOT NULL,
  `rownum` int(11) DEFAULT NULL,
  `columnnum` int(11) DEFAULT NULL,
  `cid` varchar(45) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`Tid`),
  KEY `FK_2bj6a8na5tiq0a98j6uxw2xr9` (`Sid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_totals`
--

CREATE TABLE IF NOT EXISTS `colfusion_totals` (
  `name` varchar(10) CHARACTER SET utf8 NOT NULL,
  `total` int(11) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `colfusion_totals`
--

INSERT INTO `colfusion_totals` (`name`, `total`) VALUES
('discard', 0),
('published', 0),
('queued', 0);

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_trackbacks`
--

CREATE TABLE IF NOT EXISTS `colfusion_trackbacks` (
  `trackback_id` int(11) NOT NULL AUTO_INCREMENT,
  `trackback_link_id` int(11) NOT NULL,
  `trackback_user_id` int(11) NOT NULL,
  `trackback_type` varchar(3) CHARACTER SET utf8 DEFAULT NULL,
  `trackback_status` varchar(7) CHARACTER SET utf8 DEFAULT NULL,
  `trackback_modified` datetime NOT NULL,
  `trackback_date` datetime DEFAULT NULL,
  `trackback_url` varchar(200) CHARACTER SET utf8 DEFAULT NULL,
  `trackback_title` longtext CHARACTER SET utf8,
  `trackback_content` longtext CHARACTER SET utf8,
  PRIMARY KEY (`trackback_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_updates`
--

CREATE TABLE IF NOT EXISTS `colfusion_updates` (
  `update_id` int(11) NOT NULL AUTO_INCREMENT,
  `update_time` int(11) DEFAULT NULL,
  `update_type` char(1) CHARACTER SET utf8 NOT NULL,
  `update_link_id` int(11) NOT NULL,
  `update_user_id` int(11) NOT NULL,
  `update_group_id` int(11) NOT NULL,
  `update_likes` int(11) NOT NULL,
  `update_level` varchar(25) CHARACTER SET utf8 DEFAULT NULL,
  `update_text` longtext CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`update_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_userroles`
--

CREATE TABLE IF NOT EXISTS `colfusion_userroles` (
  `role_id` int(11) NOT NULL,
  `role` varchar(45) CHARACTER SET utf8 NOT NULL,
  `description` longtext CHARACTER SET utf8,
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `colfusion_userroles`
--

INSERT INTO `colfusion_userroles` (`role_id`, `role`, `description`) VALUES
(1, 'owner', 'owner'),
(2, 'collector', 'collector');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_users`
--

CREATE TABLE IF NOT EXISTS `colfusion_users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_login` varchar(32) CHARACTER SET utf8 DEFAULT NULL,
  `user_level` varchar(7) CHARACTER SET utf8 DEFAULT 'normal',
  `user_modification` datetime NOT NULL,
  `user_date` datetime NOT NULL,
  `user_pass` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `user_email` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  `user_names` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  `user_karma` decimal(10,2) DEFAULT NULL,
  `user_url` varchar(128) CHARACTER SET utf8 DEFAULT NULL,
  `user_lastlogin` datetime NOT NULL,
  `user_aim` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `user_msn` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `user_yahoo` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `user_gtalk` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `user_skype` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `user_irc` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `public_email` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  `user_avatar_source` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `user_ip` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `user_lastip` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `last_reset_request` datetime NOT NULL,
  `last_email_friend` datetime NOT NULL,
  `last_reset_code` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `user_location` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `user_occupation` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `user_categories` longtext CHARACTER SET utf8,
  `user_enabled` bit(1) NOT NULL,
  `user_language` varchar(32) CHARACTER SET utf8 DEFAULT NULL,
  `status_switch` bit(1) DEFAULT NULL,
  `status_friends` bit(1) DEFAULT NULL,
  `status_story` bit(1) DEFAULT NULL,
  `status_comment` bit(1) DEFAULT NULL,
  `status_email` bit(1) DEFAULT NULL,
  `status_group` bit(1) DEFAULT NULL,
  `status_all_friends` bit(1) DEFAULT NULL,
  `status_friend_list` longtext CHARACTER SET utf8,
  `status_excludes` longtext CHARACTER SET utf8,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UK_25iqgtemiawp5w6njsj9c5efu` (`user_login`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=33 ;

--
-- Dumping data for table `colfusion_users`
--

INSERT INTO `colfusion_users` (`user_id`, `user_login`, `user_level`, `user_modification`, `user_date`, `user_pass`, `user_email`, `user_names`, `user_karma`, `user_url`, `user_lastlogin`, `user_aim`, `user_msn`, `user_yahoo`, `user_gtalk`, `user_skype`, `user_irc`, `public_email`, `user_avatar_source`, `user_ip`, `user_lastip`, `last_reset_request`, `last_email_friend`, `last_reset_code`, `user_location`, `user_occupation`, `user_categories`, `user_enabled`, `user_language`, `status_switch`, `status_friends`, `status_story`, `status_comment`, `status_email`, `status_group`, `status_all_friends`, `status_friend_list`, `status_excludes`) VALUES
(26, 'Evgeny', 'god', '2013-10-04 01:53:55', '2013-06-21 14:02:57', '4e7838f51bd8680fbfaee8e2ba2f54d9987c0779d3f1a9c84', 'karataev.evgeny@gmail.com', '', 0.00, '', '2013-10-04 01:53:55', '', '', '', '', '', 'admin', '', 'useruploaded', '10.228.65.112', '10.228.65.115', '2013-06-24 12:47:29', '0000-00-00 00:00:00', '11fd1796e9abc344ea287d3488628a3c9c993bdc1f7c56bf7', '', '', '', b'1', 'english', b'1', b'1', b'1', b'1', b'1', b'1', b'1', NULL, NULL),
(27, 'Colfusion_AI', 'normal', '2013-06-24 15:15:20', '2013-06-24 15:15:20', '19ad8bddc15c95a0f84e4e317b0c617258c9675ab4a782aca', 'colfusionia@colfusion.com', NULL, 0.00, NULL, '2013-06-24 15:15:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '10.228.65.112', '10.228.65.112', '0000-00-00 00:00:00', '0000-00-00 00:00:00', NULL, NULL, NULL, '', b'1', NULL, b'1', b'1', b'1', b'1', b'1', b'1', b'1', NULL, NULL),
(31, 'dataverse', 'normal', '2013-09-30 02:04:17', '2013-09-25 19:05:26', 'fb5a0b7950b27484840b4580c26ea654a52abe725effa65fd', 'dataverse@dataverse.com', NULL, 0.00, NULL, '2015-06-14 23:28:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '10.228.65.115', '207.181.251.132', '2014-12-22 18:16:00', '0000-00-00 00:00:00', 'b70186f40d10c70d1088a620e141dc9ce066f43b9aaa6f73d', NULL, NULL, '', b'1', NULL, b'1', b'1', b'1', b'1', b'1', b'1', b'1', NULL, NULL),
(32, 'testReg', 'normal', '0000-00-00 00:00:00', '2015-06-15 13:47:34', '21a86dc5745a76d265c3cd893203ccf6b398d64fd1c623daa', 'kzheka@hotmail.com', NULL, NULL, NULL, '2015-06-15 16:12:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '207.181.251.132', '207.181.251.132', '2015-06-15 16:36:49', '0000-00-00 00:00:00', 'ad070d9e836b38843d8fc3cd9e5c2cc952a17241b2d4ff6a0', NULL, NULL, '', b'0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_user_relationship_verdict`
--

CREATE TABLE IF NOT EXISTS `colfusion_user_relationship_verdict` (
  `rel_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `confidence` decimal(3,2) NOT NULL,
  `comment` longtext CHARACTER SET utf8,
  `when` datetime NOT NULL,
  PRIMARY KEY (`rel_id`,`user_id`),
  KEY `FK_jwjbdowtd69g097tu6kke59ov` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_validation_code`
--

CREATE TABLE IF NOT EXISTS `colfusion_validation_code` (
  `email` varchar(100) CHARACTER SET utf8 NOT NULL,
  `vcode` varchar(20) CHARACTER SET utf8 NOT NULL,
  `isUsed` bit(1) NOT NULL,
  PRIMARY KEY (`email`,`vcode`,`isUsed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `colfusion_validation_code`
--

INSERT INTO `colfusion_validation_code` (`email`, `vcode`, `isUsed`) VALUES
('kzheka@hotmail.com', '0bufPX6XL50YM7m', b'1'),
('kzheka@hotmail.com', 'JMvncxAoCEDNzHn', b'0'),
('kzheka@hotmail.com', 'YWNyWsCMrwtsdFP', b'0');

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_visualization`
--

CREATE TABLE IF NOT EXISTS `colfusion_visualization` (
  `vid` varchar(20) CHARACTER SET utf8 NOT NULL,
  `titleno` int(11) NOT NULL,
  `type` varchar(50) CHARACTER SET utf8 NOT NULL,
  `userid` int(11) NOT NULL,
  `top` int(11) NOT NULL,
  `left` int(11) NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `setting` longtext CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`vid`),
  KEY `FK_4ya8fi7501pdiwl7688k39m3o` (`titleno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_votes`
--

CREATE TABLE IF NOT EXISTS `colfusion_votes` (
  `vote_id` int(11) NOT NULL AUTO_INCREMENT,
  `vote_type` varchar(8) CHARACTER SET utf8 NOT NULL,
  `vote_date` datetime NOT NULL,
  `vote_link_id` int(11) NOT NULL,
  `vote_user_id` int(11) NOT NULL,
  `vote_value` smallint(6) NOT NULL,
  `vote_karma` int(11) DEFAULT NULL,
  `vote_ip` varchar(64) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`vote_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_widgets`
--

CREATE TABLE IF NOT EXISTS `colfusion_widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` float NOT NULL,
  `name` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `latest_version` float NOT NULL,
  `folder` varchar(50) CHARACTER SET utf8 DEFAULT NULL,
  `enabled` bit(1) NOT NULL,
  `column` varchar(5) CHARACTER SET utf8 NOT NULL,
  `position` int(11) NOT NULL,
  `display` varchar(5) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_c094lydovql5fij4x3ygtu837` (`folder`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `colfusion_widgets`
--

INSERT INTO `colfusion_widgets` (`id`, `version`, `name`, `latest_version`, `folder`, `enabled`, `column`, `position`, `display`) VALUES
(1, 0.1, 'Admin Panel Tools', 0, 'panel_tools', b'1', 'left', 4, ''),
(2, 0.1, 'Module Settings', 0, 'module_settings', b'1', 'left', 3, ''),
(3, 0.1, 'Statistics', 0, 'statistics', b'1', 'left', 1, ''),
(4, 0.1, 'Pligg CMS', 0, 'pligg_cms', b'1', 'right', 5, ''),
(5, 0.1, 'Pligg News', 0, 'pligg_news', b'1', 'right', 6, ''),
(6, 0.1, 'New products', 0, 'new_products', b'1', 'left', 2, '');

-- --------------------------------------------------------

--
-- Stand-in structure for view `statonverdicts`
--
CREATE TABLE IF NOT EXISTS `statonverdicts` (
`rel_id` int(11)
,`numberOfVerdicts` bigint(21)
,`numberOfApproved` decimal(23,0)
,`numberOfReject` decimal(23,0)
,`numberOfNotSure` decimal(23,0)
,`avgConfidence` decimal(7,6)
);
-- --------------------------------------------------------

--
-- Structure for view `statonverdicts`
--
DROP TABLE IF EXISTS `statonverdicts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `statonverdicts` AS select `colfusion_user_relationship_verdict`.`rel_id` AS `rel_id`,count(0) AS `numberOfVerdicts`,sum(if((`colfusion_user_relationship_verdict`.`confidence` > 0),1,0)) AS `numberOfApproved`,sum(if((`colfusion_user_relationship_verdict`.`confidence` < 0),1,0)) AS `numberOfReject`,sum(if((`colfusion_user_relationship_verdict`.`confidence` = 0),1,0)) AS `numberOfNotSure`,avg(`colfusion_user_relationship_verdict`.`confidence`) AS `avgConfidence` from `colfusion_user_relationship_verdict` group by `colfusion_user_relationship_verdict`.`rel_id`;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `colfusion_canvases`
--
ALTER TABLE `colfusion_canvases`
  ADD CONSTRAINT `FK_rrd90u4au11k7m0y7ys7wasw1` FOREIGN KEY (`user_id`) REFERENCES `colfusion_users` (`user_id`);

--
-- Constraints for table `colfusion_charts`
--
ALTER TABLE `colfusion_charts`
  ADD CONSTRAINT `FK_lym1jififkghqs6a4q15gwq5p` FOREIGN KEY (`vid`) REFERENCES `colfusion_canvases` (`vid`);

--
-- Constraints for table `colfusion_columnTableInfo`
--
ALTER TABLE `colfusion_columnTableInfo`
  ADD CONSTRAINT `FK_fvy2f733w7jrq4drk1445o4nd` FOREIGN KEY (`cid`) REFERENCES `colfusion_dnameinfo` (`cid`);

--
-- Constraints for table `colfusion_des_attachments`
--
ALTER TABLE `colfusion_des_attachments`
  ADD CONSTRAINT `FK_5mhqsvq21yu9gh58ugt9y5uo8` FOREIGN KEY (`Sid`) REFERENCES `colfusion_sourceinfo` (`Sid`),
  ADD CONSTRAINT `FK_oh83r9dat33w96070dew57c5i` FOREIGN KEY (`UserId`) REFERENCES `colfusion_users` (`user_id`);

--
-- Constraints for table `colfusion_dnameinfo`
--
ALTER TABLE `colfusion_dnameinfo`
  ADD CONSTRAINT `FK_ry8xyg3e3a0hi225q8k0195q6` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`);

--
-- Constraints for table `colfusion_dnameinfo_metadata_edit_history`
--
ALTER TABLE `colfusion_dnameinfo_metadata_edit_history`
  ADD CONSTRAINT `FK_6qtapop8o9y3asb5d3ma7ngw4` FOREIGN KEY (`uid`) REFERENCES `colfusion_users` (`user_id`),
  ADD CONSTRAINT `FK_tknft8ptxphm2bnwca6g2di6k` FOREIGN KEY (`cid`) REFERENCES `colfusion_dnameinfo` (`cid`);

--
-- Constraints for table `colfusion_executeinfo`
--
ALTER TABLE `colfusion_executeinfo`
  ADD CONSTRAINT `FK_ok0jbkcb90fa4r6jla4akpn9e` FOREIGN KEY (`Sid`) REFERENCES `colfusion_sourceinfo` (`Sid`);

--
-- Constraints for table `colfusion_notifications`
--
ALTER TABLE `colfusion_notifications`
  ADD CONSTRAINT `FK_t1oenxdm5eync7fotfy18461t` FOREIGN KEY (`sender_id`) REFERENCES `colfusion_users` (`user_id`);

--
-- Constraints for table `colfusion_notifications_unread`
--
ALTER TABLE `colfusion_notifications_unread`
  ADD CONSTRAINT `FK_puw1y1olw9etquspep1k2fbjk` FOREIGN KEY (`ntf_id`) REFERENCES `colfusion_notifications` (`ntf_id`);

--
-- Constraints for table `colfusion_psc_sourceinfo_table`
--
ALTER TABLE `colfusion_psc_sourceinfo_table`
  ADD CONSTRAINT `FK_544gide45tq0p4uajsq5ly39x` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`),
  ADD CONSTRAINT `FK_k74kljav616dstg1qf6pt5d6i` FOREIGN KEY (`pid`) REFERENCES `colfusion_processes` (`pid`);

--
-- Constraints for table `colfusion_relationships`
--
ALTER TABLE `colfusion_relationships`
  ADD CONSTRAINT `FK_1qm11x24s30iv7m83uu7gqs7b` FOREIGN KEY (`sid2`) REFERENCES `colfusion_sourceinfo` (`Sid`),
  ADD CONSTRAINT `FK_jgq89ds8g9jluu07jwjuv92jk` FOREIGN KEY (`sid1`) REFERENCES `colfusion_sourceinfo` (`Sid`),
  ADD CONSTRAINT `FK_p2pwoqg4uc0ccmubaaaldmoqo` FOREIGN KEY (`creator`) REFERENCES `colfusion_users` (`user_id`);

--
-- Constraints for table `colfusion_relationships_columns`
--
ALTER TABLE `colfusion_relationships_columns`
  ADD CONSTRAINT `FK_q148qm7xyc1wk0dvcl9x7nsm2` FOREIGN KEY (`rel_id`) REFERENCES `colfusion_relationships` (`rel_id`);

--
-- Constraints for table `colfusion_relationships_columns_dataMathing_ratios`
--
ALTER TABLE `colfusion_relationships_columns_dataMathing_ratios`
  ADD CONSTRAINT `FK_outwl9bbsr7rwqf2y4o5ktdvw` FOREIGN KEY (`pid`) REFERENCES `colfusion_processes` (`pid`);

--
-- Constraints for table `colfusion_shares`
--
ALTER TABLE `colfusion_shares`
  ADD CONSTRAINT `FK_le1hbfj3cobun8oicmetgqs0f` FOREIGN KEY (`vid`) REFERENCES `colfusion_canvases` (`vid`),
  ADD CONSTRAINT `FK_mvoxkkf0u1q0c16g4r0351tds` FOREIGN KEY (`user_id`) REFERENCES `colfusion_users` (`user_id`);

--
-- Constraints for table `colfusion_sourceinfo`
--
ALTER TABLE `colfusion_sourceinfo`
  ADD CONSTRAINT `FK_hrcfg5c3u36rphe7yqh391u3h` FOREIGN KEY (`license_ID`) REFERENCES `colfusion_license` (`license_ID`),
  ADD CONSTRAINT `FK_mrbc8gx8a89v6ge8jsx0ld8of` FOREIGN KEY (`UserId`) REFERENCES `colfusion_users` (`user_id`);

--
-- Constraints for table `colfusion_sourceinfo_DB`
--
ALTER TABLE `colfusion_sourceinfo_DB`
  ADD CONSTRAINT `FK_o1xn9y04rc6syxpop1fhk0ebr` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`);

--
-- Constraints for table `colfusion_sourceinfo_metadata_edit_history`
--
ALTER TABLE `colfusion_sourceinfo_metadata_edit_history`
  ADD CONSTRAINT `FK_gsq54ere2j3yyaeoisbw9p508` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`),
  ADD CONSTRAINT `FK_k5ms6go5yg2ly8gty3q2sxso6` FOREIGN KEY (`uid`) REFERENCES `colfusion_users` (`user_id`);

--
-- Constraints for table `colfusion_sourceinfo_table_ktr`
--
ALTER TABLE `colfusion_sourceinfo_table_ktr`
  ADD CONSTRAINT `FK_ncgqkrengjpwm2pp9c24ekthj` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`);

--
-- Constraints for table `colfusion_sourceinfo_user`
--
ALTER TABLE `colfusion_sourceinfo_user`
  ADD CONSTRAINT `FK_kvymtcpvongyfrk5mq44dumrg` FOREIGN KEY (`rid`) REFERENCES `colfusion_userroles` (`role_id`),
  ADD CONSTRAINT `FK_n7pcs7ldlq4smu87xlnjalsg7` FOREIGN KEY (`uid`) REFERENCES `colfusion_users` (`user_id`),
  ADD CONSTRAINT `FK_t8ec1amh37pv1vxuavws55t6s` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`);

--
-- Constraints for table `colfusion_synonyms_from`
--
ALTER TABLE `colfusion_synonyms_from`
  ADD CONSTRAINT `FK_anrqb561xlvudlccfcubno765` FOREIGN KEY (`userId`) REFERENCES `colfusion_users` (`user_id`),
  ADD CONSTRAINT `FK_hwaafrhxx1oxfq5bqvexub87f` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`);

--
-- Constraints for table `colfusion_synonyms_to`
--
ALTER TABLE `colfusion_synonyms_to`
  ADD CONSTRAINT `FK_7dw4w6lncy1u5fp68whu2l583` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`),
  ADD CONSTRAINT `FK_iy15ri9da0iwp3tvrk7wiox5` FOREIGN KEY (`userId`) REFERENCES `colfusion_users` (`user_id`);

--
-- Constraints for table `colfusion_temporary`
--
ALTER TABLE `colfusion_temporary`
  ADD CONSTRAINT `FK_2bj6a8na5tiq0a98j6uxw2xr9` FOREIGN KEY (`Sid`) REFERENCES `colfusion_sourceinfo` (`Sid`);

--
-- Constraints for table `colfusion_user_relationship_verdict`
--
ALTER TABLE `colfusion_user_relationship_verdict`
  ADD CONSTRAINT `FK_hxtbjyt1nlmgc9bp234eqot0m` FOREIGN KEY (`rel_id`) REFERENCES `colfusion_relationships` (`rel_id`),
  ADD CONSTRAINT `FK_jwjbdowtd69g097tu6kke59ov` FOREIGN KEY (`user_id`) REFERENCES `colfusion_users` (`user_id`);

--
-- Constraints for table `colfusion_visualization`
--
ALTER TABLE `colfusion_visualization`
  ADD CONSTRAINT `FK_4ya8fi7501pdiwl7688k39m3o` FOREIGN KEY (`titleno`) REFERENCES `colfusion_sourceinfo` (`Sid`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
