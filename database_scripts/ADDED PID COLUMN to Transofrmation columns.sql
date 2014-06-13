ALTER TABLE `colfusion`.`colfusion_relationships_columns` 
ADD COLUMN `pid` INT NULL COMMENT 'id of the JAVA process which is responsible for data matching computations. MAYBE IT IS JUST A HACK FOR NOW.' AFTER `dataMatchingToRatio`;


ALTER TABLE `colfusion`.`colfusion_relationships_columns` 
ADD INDEX `fk_pid_idx` (`pid` ASC);
ALTER TABLE `colfusion`.`colfusion_relationships_columns` 
ADD CONSTRAINT `fk_pid`
  FOREIGN KEY (`pid`)
  REFERENCES `colfusion`.`colfusion_processes` (`pid`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


ALTER TABLE `colfusion`.`colfusion_relationships_columns` 
DROP FOREIGN KEY `fk_pid`;
ALTER TABLE `colfusion`.`colfusion_relationships_columns` 
DROP COLUMN `pid`,
DROP INDEX `fk_pid_idx` ;
