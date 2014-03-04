CREATE TABLE `colfusion`.`colfusion_sourceinfo_table_ktr` (
  `sid` INT NOT NULL,
  `tableName` VARCHAR(255) NOT NULL,
  `pathToKTRFile` VARCHAR(400) NOT NULL,
  PRIMARY KEY (`sid`, `tableName`))
COMMENT = 'Table to store information about location of the KTR file for each table for stories from excel or csv files.';


ALTER TABLE `colfusion`.`colfusion_sourceinfo_table_ktr` 
ADD CONSTRAINT `ToSourceINfo`
  FOREIGN KEY (`sid`)
  REFERENCES `colfusion`.`colfusion_sourceinfo` (`Sid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;