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

--
-- Constraints for dumped tables
--

--
-- Constraints for table `colfusion_synonyms_from`
--
ALTER TABLE `colfusion_synonyms_from`
  ADD CONSTRAINT `colfusion_synonyms_from_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `colfusion_users` (`user_id`),
  ADD CONSTRAINT `fk_synfrom_sid` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE;


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

--
-- Constraints for dumped tables
--

--
-- Constraints for table `colfusion_synonyms_from`
--
ALTER TABLE `colfusion_synonyms_to`
  ADD CONSTRAINT `colfusion_synonyms_to_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `colfusion_users` (`user_id`),
  ADD CONSTRAINT `fk_synto_sid` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE;