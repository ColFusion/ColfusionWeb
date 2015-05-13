CREATE TABLE `colfusion_webchat_users` (
  `id` int(20) unsigned NOT NULL,
  `last_activity` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  KEY `last_activity` (`last_activity`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;

CREATE TABLE `colfusion_webchat_lines` (
  `id` int(10) unsigned NOT NULL auto_increment,
  `aid` int(20) NOT NULL,
  `text` varchar(255) NOT NULL,
  `ts` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  KEY `ts` (`ts`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;


