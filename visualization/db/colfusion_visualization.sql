-- phpMyAdmin SQL Dump
-- version 3.5.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Apr 15, 2013 at 01:01 AM
-- Server version: 5.5.24-log
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
  PRIMARY KEY (`vid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `colfusion_visualization`
--

INSERT INTO `colfusion_visualization` (`vid`, `type`, `userid`, `titleno`, `top`, `left`, `width`, `height`, `setting`) VALUES
('1365737520103', 'map', 2, 15, -12, 346, 476, 314, 'Location;Value;Spd,Drd,Dname;'),
('1365750885347', 'pie', 2, 15, -12, 832, 404, 309, 'Households;Avg;'),
('1365754613750', 'combo', 2, 15, -11, -80, 418, 310, 'Married Couples'),
('1365790833954', 'column', 2, 13, 308, -82, 420, 273, 'Family Male Households;Count;'),
('1365792039913', 'table', 2, 15, 306, 347, 475, 290, 'Households,Family Households,Married Couples;50;purple;excelStyle;'),
('1365792056652', 'motion', 1, 15, 304, 830, 408, 291, 'Married Couples'),
('1365987651752', 'column', 2, 15, 315, -66, 378, 279, 'Family Female Households;Count;');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
