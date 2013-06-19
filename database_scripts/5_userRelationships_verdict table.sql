CREATE  TABLE `colfusion_user_relationship_verdict` (
  `cl1` INT NOT NULL ,
  `cl2` INT NOT NULL ,
  `user_id` INT NOT NULL ,
  `verdict` ENUM('approve', 'reject', 'not_sure') NOT NULL ,
  `confidence` DECIMAL NOT NULL ,
  `comment` TEXT NULL ,
  `when` DATETIME NOT NULL ,
  PRIMARY KEY (`cl1`, `cl2`) ,
  INDEX `fk_colfusion_user_relationship_verdict_1_idx` (`cl1` ASC, `cl2` ASC) ,
  INDEX `fk_colfusion_user_relationship_verdict_2_idx` (`user_id` ASC) ,
  CONSTRAINT `fk_colfusion_user_relationship_verdict_1`
    FOREIGN KEY (`cl1` , `cl2` )
    REFERENCES `colfusion_relationships` (`cl1` , `cl2` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_colfusion_user_relationship_verdict_2`
    FOREIGN KEY (`user_id` )
    REFERENCES `colfusion_users` (`user_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);



ALTER TABLE `colfusion_user_relationship_verdict` 
DROP PRIMARY KEY 
, ADD PRIMARY KEY (`cl1`, `cl2`, `user_id`) ;

ALTER TABLE `colfusion_user_relationship_verdict` DROP COLUMN `verdict` ;



ALTER TABLE `colfusion_user_relationship_verdict` CHANGE COLUMN `confidence` `confidence` DECIMAL(10,0) NOT NULL DEFAULT 0  ;


