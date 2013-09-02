ALTER TABLE `colfusion_relationships_columns` 
ADD COLUMN `dataMatchingRatio` DECIMAL(4,2) NULL AFTER `cl_to`;


ALTER TABLE `colfusion`.`colfusion_relationships_columns` 
CHANGE COLUMN `dataMatchingRatio` `dataMatchingFromRatio` DECIMAL(4,2) NULL DEFAULT NULL ,
ADD COLUMN `dataMatchingToRatio` DECIMAL(4,2) NULL AFTER `dataMatchingFromRatio`;
