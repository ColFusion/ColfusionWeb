-- phpMyAdmin SQL Dump
-- version 4.0.4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 31, 2013 at 06:12 PM
-- Server version: 5.6.12-log
-- PHP Version: 5.4.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
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
-- Table structure for table `colfusion_statistics`
--

CREATE TABLE IF NOT EXISTS `colfusion_statistics` (
  `cid` int(11) NOT NULL,
  `sid` int(11) NOT NULL,
  `stats` varchar(40) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `val` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`cid`,`stats`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `colfusion_statistics`
--

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
