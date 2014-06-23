CREATE TABLE `colfusion_processes` (
  `pid` INT NOT NULL AUTO_INCREMENT COMMENT 'Process id automatically increasing.',
  `status` ENUM('new', 'running', 'puased', 'failed') NULL DEFAULT 'new',
  `processSer` TEXT NULL COMMENT 'JSON serialization of the process',
  PRIMARY KEY (`pid`),
  UNIQUE INDEX `pid_UNIQUE` (`pid` ASC));

ALTER TABLE `colfusion_processes` 
CHANGE COLUMN `status` `status` ENUM('new','running','puased','failed', 'done') NULL DEFAULT 'new' ;


ALTER TABLE `colfusion_processes` 
ADD COLUMN `processClass` VARCHAR(1000) NULL AFTER `processSer`;


ALTER TABLE `colfusion_processes` 
ADD COLUMN `reasonForStatus` TEXT NULL AFTER `processClass`;