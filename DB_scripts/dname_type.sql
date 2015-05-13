CREATE TABLE `colfusion_dname_type` (
  `type_id` int(11) NOT NULL AUTO_INCREMENT,
  `dname_value_type` varchar(20) CHARACTER SET utf8 DEFAULT NULL,
  `dname_value_unit` varchar(40) CHARACTER SET utf8mb4 DEFAULT NULL,
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `colfusion_dname_type`
--

INSERT INTO `colfusion_dname_type` (`type_id`, `dname_value_type`, `dname_value_unit`) VALUES
(1, 'string', NULL),
(2, 'number', 'km'),
(3, 'number', 'kg'),
(4, 'date', 'dd/mm/yy'),
(5, 'date', 'mm/dd/yy'),
(6, 'date', 'yy/mm/dd');