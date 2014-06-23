CREATE TABLE `colfusion_dnameinfo_metadata_edit_history` (
  `hid` INT NOT NULL AUTO_INCREMENT COMMENT 'id of history record',
  `cid` INT NOT NULL COMMENT 'column id',
  `uid` INT NOT NULL COMMENT 'userid who made edit',
  `whenSaved` DATETIME NOT NULL COMMENT 'when the edit was done',
  `editedAttribute` ENUM('chosen name','original name','data type', 'value unit', 'description', 'format', 'missing value', 'isConstant', 'constant value' ) NOT NULL,
  `reason` VARCHAR(555) NULL,
  `value` TEXT NOT NULL,
  PRIMARY KEY (`hid`));

ALTER TABLE `colfusion_dnameinfo_metadata_edit_history` 
ADD INDEX `ToDnameInfo_idx` (`cid` ASC),
ADD INDEX `ToUsersTable_idx` (`uid` ASC);
ALTER TABLE `colfusion_dnameinfo_metadata_edit_history` 
ADD CONSTRAINT `ToDnameInfo`
  FOREIGN KEY (`cid`)
  REFERENCES `colfusion_dnameinfo` (`cid`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `ToUsersTable`
  FOREIGN KEY (`uid`)
  REFERENCES `colfusion_users` (`user_id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;





