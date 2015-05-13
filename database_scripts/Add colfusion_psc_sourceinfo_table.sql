CREATE TABLE `colfusion_psc_sourceinfo_table` (
  `sid` int(11) NOT NULL,
  `tableName` varchar(255) NOT NULL,
  `pscDatabase` varchar(64) NOT NULL,
  `pscTableName` varchar(64) NOT NULL COMMENT 'THIS COMMENT SHOULD BE ON A TABLE LEVEL\n\nThe table that maps colfusion sid and table name to the database and table on psd server',
  `whenReplicationStarted` datetime DEFAULT NULL,
  `whenReplicationFinished` datetime DEFAULT NULL,
  `pid` int(11) DEFAULT NULL,
  PRIMARY KEY (`sid`,`tableName`),
  KEY `pid_idx` (`pid`),
  CONSTRAINT `sid` FOREIGN KEY (`sid`) REFERENCES `colfusion_sourceinfo` (`Sid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pid` FOREIGN KEY (`pid`) REFERENCES `colfusion_processes` (`pid`) ON DELETE SET NULL ON UPDATE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `colfusion`.`colfusion_psc_sourceinfo_table` 
DROP FOREIGN KEY `pid`;
ALTER TABLE `colfusion`.`colfusion_psc_sourceinfo_table` 
ADD CONSTRAINT `pid`
  FOREIGN KEY (`pid`)
  REFERENCES `colfusion`.`colfusion_processes` (`pid`)
  ON DELETE SET NULL
  ON UPDATE CASCADE;

ALTER TABLE `colfusion`.`colfusion_psc_sourceinfo_table` 
CHANGE COLUMN `pscDatabase` `pscDatabaseName` VARCHAR(64) NOT NULL ,
ADD COLUMN `pscHost` VARCHAR(255) NOT NULL AFTER `tableName`,
ADD COLUMN `pscDatabasePort` INT NOT NULL AFTER `pscHost`,
ADD COLUMN `pscDatabaseUser` VARCHAR(45) NOT NULL AFTER `pscTableName`,
ADD COLUMN `pscDatabasePassword` VARCHAR(45) NOT NULL AFTER `pscDatabaseUser`,
ADD COLUMN `pscDatabaseVendor` VARCHAR(45) NOT NULL COMMENT 'database vendor (e.g. mysql)' AFTER `pscDatabasePassword`;
