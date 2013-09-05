ALTER TABLE `colfusion_sourceinfo_DB` 
ADD COLUMN `originla_DB_name` VARCHAR(255) NULL COMMENT 'Stores original name of the database. This value will be different only for remotely submitted databases because we give collusion internal name for them when create a linked server. However we still need to store what was original name (e.g. for provenance needs).' AFTER `is_local`;


ALTER TABLE `colfusion_sourceinfo_DB` 
CHANGE COLUMN `is_local` `is_local` INT(11) NULL DEFAULT '1' COMMENT '1 - means database was created from dump file and is stored on our server,\n0 - means that database was submitted as remote database and the data is stored somewhere not on our server' ;


ALTER TABLE `colfusion_sourceinfo_DB` 
CHANGE COLUMN `originla_DB_name` `linked_server_name` VARCHAR(255) NULL DEFAULT NULL COMMENT 'Stores linked server name of the database. This value will be different only for remotely submitted databases because we give collusion internal name for them when create a linked server. ' ;
