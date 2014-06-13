ALTER TABLE `colfusion`.`colfusion_sourceinfo_table_ktr` 
DROP FOREIGN KEY `asdg`;
ALTER TABLE `colfusion`.`colfusion_sourceinfo_table_ktr` 
ADD CONSTRAINT `asdg`
  FOREIGN KEY (`sid`)
  REFERENCES `colfusion`.`colfusion_sourceinfo` (`Sid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
