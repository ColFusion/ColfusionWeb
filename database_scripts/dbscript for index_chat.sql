SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

CREATE DATABASE IF NOT EXISTS `colfusion_chat`;

CREATE TABLE IF NOT EXISTS `index_chat` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `from_id` varchar(255) NOT NULL DEFAULT '',
  `to_id` varchar(255) NOT NULL DEFAULT '',
  `message` text NOT NULL,
  `sent` bigint(19) NOT NULL,
  `recd` int(10) unsigned NOT NULL DEFAULT '0',
  `system_message` varchar(3) DEFAULT 'no',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS `index_typing` (
  `typing_from` int(11) NOT NULL,
  `typing_to` int(11) NOT NULL,
  `typing_ornot` int(11) NOT NULL,
  UNIQUE KEY `typing_from` (`typing_from`,`typing_to`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `index_users` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `chat_status` varchar(255) DEFAULT 'offline',
  `offlineshift` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;