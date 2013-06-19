-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 06, 2013 at 02:08 AM
-- Server version: 5.6.10
-- PHP Version: 5.4.3

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `colfusion`
--

-- --------------------------------------------------------

--
-- Table structure for table `colfusion_canvases`
--

DROP TABLE IF EXISTS `colfusion_canvases`;
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
-- Table structure for table `colfusion_charts`
--

DROP TABLE IF EXISTS `colfusion_charts`;
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
-- Table structure for table `colfusion_shares`
--

DROP TABLE IF EXISTS `colfusion_shares`;
CREATE TABLE IF NOT EXISTS `colfusion_shares` (
  `vid` int(20) DEFAULT NULL,
  `user_id` int(20) DEFAULT NULL,
  `privilege` int(1) DEFAULT NULL,
  UNIQUE KEY `vid` (`vid`,`user_id`),
  KEY `fk_shares_userid` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
-- Constraints for table `colfusion_shares`
--
ALTER TABLE `colfusion_shares`
  ADD CONSTRAINT `fk_shares_vid` FOREIGN KEY (`vid`) REFERENCES `colfusion_canvases` (`vid`),
  ADD CONSTRAINT `fk_shares_userid` FOREIGN KEY (`user_id`) REFERENCES `colfusion_users` (`user_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
