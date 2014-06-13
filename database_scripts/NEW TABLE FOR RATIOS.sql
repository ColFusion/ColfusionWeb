CREATE TABLE `colfusion`.`colfusion_relationships_columns_dataMathing_ratios` (
  `cl_from` VARCHAR(255) NOT NULL,
  `cl_to` VARCHAR(255) NOT NULL,
  `similarity_threshold` DECIMAL(4,3) NOT NULL,
  `dataMatchingFromRatio` DECIMAL(4,3) NULL,
  `dataMatchingToRatio` DECIMAL(4,3) NULL,
  `pid` INT NOT NULL,
  PRIMARY KEY (`cl_from`, `cl_to`, `similarity_threshold`));


ALTER TABLE `colfusion`.`colfusion_relationships_columns_dataMathing_ratios` 
ADD INDEX `toProcesses_idx` (`pid` ASC);
ALTER TABLE `colfusion`.`colfusion_relationships_columns_dataMathing_ratios` 
ADD CONSTRAINT `toProcesses`
  FOREIGN KEY (`pid`)
  REFERENCES `colfusion`.`colfusion_processes` (`pid`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
