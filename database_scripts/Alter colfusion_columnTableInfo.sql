ALTER TABLE `colfusion_columnTableInfo` 
ADD COLUMN `dbTableName` VARCHAR(255) NULL COMMENT 'THIS IS YET ANOTHER WORK AROUND. WE NEED TO REDESIGN THIS PART' AFTER `tableName`;

update colfusion_columnTableInfo
set dbTableName = tableName;

ALTER TABLE `colfusion_columnTableInfo` 
CHANGE COLUMN `dbTableName` `dbTableName` VARCHAR(255) NOT NULL COMMENT 'THIS IS YET ANOTHER WORK AROUND. WE NEED TO REDESIGN THIS PART' ;

