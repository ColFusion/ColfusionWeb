CREATE TABLE `colfusion_sourceinfo_metadata_edit_history` (
  `hid` VARCHAR(45) NOT NULL COMMENT 'id of history record',
  `sid` INT NOT NULL COMMENT 'source info id',
  `uid` INT NOT NULL COMMENT 'userid who made edit',
  `when` DATETIME NOT NULL COMMENT 'when the edit was done',
  `item` ENUM('title','description','tags') NOT NULL,
  `reason` VARCHAR(555) NULL,
  PRIMARY KEY (`hid`));


ALTER TABLE `colfusion_sourceinfo_metadata_edit_history` 
ADD INDEX `ToSourceInfo_idx` (`sid` ASC),
ADD INDEX `ToUser_idx` (`uid` ASC);
ALTER TABLE  `colfusion_sourceinfo_metadata_edit_history` ADD FOREIGN KEY (  `sid` ) REFERENCES  `colfusion_sourceinfo` (
`Sid`
) ON DELETE CASCADE ON UPDATE CASCADE ;

ALTER TABLE  `colfusion_sourceinfo_metadata_edit_history` ADD FOREIGN KEY (  `uid` ) REFERENCES  `colfusion_users` (
`user_id`
) ON DELETE CASCADE ON UPDATE CASCADE ;



ALTER TABLE `colfusion_sourceinfo_metadata_edit_history` 
ADD COLUMN `value` TEXT NOT NULL AFTER `reason`;


ALTER TABLE `colfusion_sourceinfo_metadata_edit_history` 
CHANGE COLUMN `hid` `hid` INT NOT NULL AUTO_INCREMENT COMMENT 'id of history record' ;


ALTER TABLE `colfusion_sourceinfo_metadata_edit_history` 
CHANGE COLUMN `item` `item` ENUM('title','description','tags', 'status') NOT NULL ;


ALTER TABLE `colfusion_sourceinfo_metadata_edit_history` 
CHANGE COLUMN `when` `whenSaved` DATETIME NOT NULL COMMENT 'when the edit was done' ,
CHANGE COLUMN `value` `itemValue` TEXT NOT NULL ;
