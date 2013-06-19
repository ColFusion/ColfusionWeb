ALTER TABLE `colfusion_relationships` DROP FOREIGN KEY `fk_colfusion_relationships_2` , DROP FOREIGN KEY `fk_colfusion_relationships_3` ;
ALTER TABLE `colfusion_relationships` 
  ADD CONSTRAINT `fk_colfusion_relationships_2`
  FOREIGN KEY (`sid1` )
  REFERENCES `colfusion_sourceinfo` (`Sid` )
  ON DELETE CASCADE
  ON UPDATE CASCADE, 
  ADD CONSTRAINT `fk_colfusion_relationships_3`
  FOREIGN KEY (`sid2` )
  REFERENCES `colfusion_sourceinfo` (`Sid` )
  ON DELETE CASCADE
  ON UPDATE CASCADE;

