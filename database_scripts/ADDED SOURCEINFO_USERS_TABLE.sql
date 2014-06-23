CREATE TABLE `colfusion_sourceinfo_user` (
  `sid` INT NOT NULL,
  `uid` INT NOT NULL,
  PRIMARY KEY (`sid`, `uid`));

ALTER TABLE `colfusion_sourceinfo_user` 
ADD INDEX `UserFK_idx` (`uid` ASC);
ALTER TABLE `colfusion_sourceinfo_user` 
ADD CONSTRAINT `SourceInfoFK`
  FOREIGN KEY (`sid`)
  REFERENCES `colfusion_sourceinfo` (`Sid`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `UserFK`
  FOREIGN KEY (`uid`)
  REFERENCES `colfusion_users` (`user_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;


CREATE TABLE `colfusion_userroles` (
  `uid` INT NOT NULL,
  `role` VARCHAR(45) NOT NULL,
  `description` VARCHAR(545) NULL,
  PRIMARY KEY (`uid`));


ALTER TABLE `colfusion_userroles` 
DROP COLUMN `uid`,
ADD COLUMN `role_id` INT NOT NULL FIRST,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`role_id`);

ALTER TABLE `colfusion_sourceinfo_user` 
ADD COLUMN `rid` INT NOT NULL AFTER `uid`,
DROP PRIMARY KEY,
ADD PRIMARY KEY (`sid`, `uid`, `rid`),
ADD INDEX `UserroleKR_idx` (`rid` ASC);
ALTER TABLE `colfusion_sourceinfo_user` 
ADD CONSTRAINT `UserroleKR`
  FOREIGN KEY (`rid`)
  REFERENCES `colfusion_userroles` (`role_id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
