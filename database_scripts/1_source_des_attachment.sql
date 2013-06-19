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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=60 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `colfusion_des_attachments`
--
ALTER TABLE `colfusion_des_attachments`
  ADD CONSTRAINT `colfusion_des_attachments_ibfk_1` FOREIGN KEY (`Sid`) REFERENCES `colfusion_sourceinfo` (`Sid`),
  ADD CONSTRAINT `colfusion_des_attachments_ibfk_2` FOREIGN KEY (`UserId`) REFERENCES `colfusion_users` (`user_id`);