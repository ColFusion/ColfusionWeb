ALTER TABLE `colfusion`.`colfusion_sourceinfo` 
ADD COLUMN `provenance` TEXT NULL DEFAULT NULL AFTER `source_type`;