ALTER TABLE `colfusion_user_relationship_verdict` DROP FOREIGN KEY `fk_colfusion_user_relationship_verdict_1` ;


drop table colfusion_relationships;

CREATE  TABLE `colfusion_relationships` (
  `rel_id` INT NOT NULL ,
  `name` VARCHAR(255) NULL ,
  `description` TEXT NULL ,
  `creator` INT NOT NULL ,
  `creation_time` DATETIME NOT NULL ,
  `sid1` INT NOT NULL ,
  `sid2` INT NOT NULL ,
  PRIMARY KEY (`rel_id`) ,
  INDEX `fk_colfusion_relationships_1_idx` (`creator` ASC) ,
  INDEX `fk_colfusion_relationships_2_idx` (`sid1` ASC) ,
  INDEX `fk_colfusion_relationships_3_idx` (`sid2` ASC) ,
  CONSTRAINT `fk_colfusion_relationships_1`
    FOREIGN KEY (`creator` )
    REFERENCES `colfusion_users` (`user_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_colfusion_relationships_2`
    FOREIGN KEY (`sid1` )
    REFERENCES `colfusion_sourceinfo` (`Sid` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_colfusion_relationships_3`
    FOREIGN KEY (`sid2` )
    REFERENCES `colfusion_sourceinfo` (`Sid` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


drop table `colfusion_user_relationship_verdict`;

CREATE  TABLE `colfusion_user_relationship_verdict` (
  `rel_id` INT NOT NULL ,
  `user_id` INT NOT NULL ,
  `confidence` DECIMAL NOT NULL ,
  `comment` TEXT NULL ,
  `when` DATETIME NOT NULL ,
  PRIMARY KEY (`rel_id`, `user_id`) ,
  INDEX `fk_colfusion_user_relationship_verdict_1_idx` (`rel_id` ASC) ,
  INDEX `fk_colfusion_user_relationship_verdict_2_idx` (`user_id` ASC) ,
  CONSTRAINT `fk_colfusion_user_relationship_verdict_1`
    FOREIGN KEY (`rel_id` )
    REFERENCES `colfusion_relationships` (`rel_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_colfusion_user_relationship_verdict_2`
    FOREIGN KEY (`user_id` )
    REFERENCES `colfusion_users` (`user_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

ALTER TABLE `colfusion_relationships` CHANGE COLUMN `rel_id` `rel_id` INT(11) NOT NULL AUTO_INCREMENT  ;


CREATE  TABLE `colfusion_relationships_transformations` (
  `trans_id` INT NOT NULL AUTO_INCREMENT ,
  `from` VARCHAR(255) NOT NULL ,
  `to` VARCHAR(255) NOT NULL ,
  PRIMARY KEY (`trans_id`) );


CREATE  TABLE `colfusion_relationships_columns` (
  `rel_id` INT NOT NULL ,
  `cl_from` INT NOT NULL ,
  `cl_to` INT NOT NULL ,
  `trans_id` INT NULL ,
  PRIMARY KEY (`rel_id`) ,
  INDEX `fk_new_table_1_idx` (`rel_id` ASC) ,
  INDEX `fk_new_table_2_idx` (`cl_from` ASC) ,
  INDEX `fk_new_table_3_idx` (`cl_to` ASC) ,
  INDEX `fk_new_table_4_idx` (`trans_id` ASC) ,
  CONSTRAINT `fk_new_table_1`
    FOREIGN KEY (`rel_id` )
    REFERENCES `colfusion_relationships` (`rel_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_new_table_2`
    FOREIGN KEY (`cl_from` )
    REFERENCES `colfusion_dnameinfo` (`cid` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_new_table_3`
    FOREIGN KEY (`cl_to` )
    REFERENCES `colfusion_dnameinfo` (`cid` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_new_table_4`
    FOREIGN KEY (`trans_id` )
    REFERENCES `colfusion_relationships_transformations` (`trans_id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);



drop view `statOnVerdicts`;


create view statOnVerdicts as
SELECT rel_id, count(*) as numberOfVerdicts, 
	SUM(if(confidence > 0, 1, 0)) AS numberOfApproved, 
	SUM(if(confidence < 0, 1, 0)) AS numberOfReject,
	SUM(if(confidence = 0, 1, 0)) AS numberOfNotSure,
	AVG(confidence) AS avgConfidence
FROM colfusion_user_relationship_verdict
group by rel_id

ALTER TABLE `colfusion_user_relationship_verdict` DROP FOREIGN KEY `fk_colfusion_user_relationship_verdict_1` ;
ALTER TABLE `colfusion_user_relationship_verdict` 
  ADD CONSTRAINT `fk_colfusion_user_relationship_verdict_1`
  FOREIGN KEY (`rel_id` )
  REFERENCES `colfusion_relationships` (`rel_id` )
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE `colfusion_relationships_columns` DROP FOREIGN KEY `fk_new_table_1` , DROP FOREIGN KEY `fk_new_table_2` , DROP FOREIGN KEY `fk_new_table_3` ;
ALTER TABLE `colfusion_relationships_columns` 
  ADD CONSTRAINT `fk_new_table_1`
  FOREIGN KEY (`rel_id` )
  REFERENCES `colfusion_relationships` (`rel_id` )
  ON DELETE CASCADE
  ON UPDATE CASCADE, 
  ADD CONSTRAINT `fk_new_table_2`
  FOREIGN KEY (`cl_from` )
  REFERENCES `colfusion_dnameinfo` (`cid` )
  ON DELETE CASCADE
  ON UPDATE CASCADE, 
  ADD CONSTRAINT `fk_new_table_3`
  FOREIGN KEY (`cl_to` )
  REFERENCES `colfusion_dnameinfo` (`cid` )
  ON DELETE CASCADE
  ON UPDATE CASCADE;


ALTER TABLE `colfusion_relationships_columns` 
DROP PRIMARY KEY 
, ADD PRIMARY KEY (`rel_id`, `cl_from`, `cl_to`) ;


