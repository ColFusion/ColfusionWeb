ALTER TABLE  `colfusion_relationships` DROP FOREIGN KEY `referenced` , DROP FOREIGN KEY `referencing` ;
ALTER TABLE  `colfusion_relationships` 
  ADD CONSTRAINT `referenced`
  FOREIGN KEY (`cl2` )
  REFERENCES  `colfusion_dnameinfo` (`cid` )
  ON DELETE CASCADE
  ON UPDATE CASCADE, 
  ADD CONSTRAINT `referencing`
  FOREIGN KEY (`cl1` )
  REFERENCES  `colfusion_dnameinfo` (`cid` )
  ON DELETE CASCADE
  ON UPDATE CASCADE;



ALTER TABLE  `colfusion_sourceinfo_DB` DROP FOREIGN KEY `colfusion_sourceinfo_DB_ibfk_1` ;
ALTER TABLE  `colfusion_sourceinfo_DB` 
  ADD CONSTRAINT `colfusion_sourceinfo_DB_ibfk_1`
  FOREIGN KEY (`sid` )
  REFERENCES  `colfusion_sourceinfo` (`Sid` )
  ON DELETE CASCADE
  ON UPDATE CASCADE;


ALTER TABLE  `colfusion_temporary` 
  ADD CONSTRAINT `fk_colfusion_temporary_1`
  FOREIGN KEY (`Sid` )
  REFERENCES  `colfusion_sourceinfo` (`Sid` )
  ON DELETE CASCADE
  ON UPDATE CASCADE
, ADD INDEX `fk_colfusion_temporary_1_idx` (`Sid` ASC) ;


ALTER TABLE  `colfusion_user_relationship_verdict` DROP FOREIGN KEY `fk_colfusion_user_relationship_verdict_1` ;
ALTER TABLE  `colfusion_user_relationship_verdict` 
  ADD CONSTRAINT `fk_colfusion_user_relationship_verdict_1`
  FOREIGN KEY (`cl1` , `cl2` )
  REFERENCES  `colfusion_relationships` (`cl1` , `cl2` )
  ON DELETE CASCADE
  ON UPDATE CASCADE;


ALTER TABLE  `colfusion_dname_meta_data` 
  ADD CONSTRAINT `fk_colfusion_dname_meta_data_1`
  FOREIGN KEY (`cid` )
  REFERENCES  `colfusion_dnameinfo` (`cid` )
  ON DELETE CASCADE
  ON UPDATE CASCADE
, ADD INDEX `fk_colfusion_dname_meta_data_1_idx` (`cid` ASC) ;


ALTER TABLE  `colfusion_des_attachments` DROP FOREIGN KEY `colfusion_des_attachments_ibfk_1` ;
ALTER TABLE  `colfusion_des_attachments` 
  ADD CONSTRAINT `colfusion_des_attachments_ibfk_1`
  FOREIGN KEY (`Sid` )
  REFERENCES  `colfusion_sourceinfo` (`Sid` )
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE  `colfusion_columnTableInfo` DROP FOREIGN KEY `fk_colfusion_columnTableInfo_1` ;
ALTER TABLE  `colfusion_columnTableInfo` 
  ADD CONSTRAINT `fk_colfusion_columnTableInfo_1`
  FOREIGN KEY (`cid` )
  REFERENCES  `colfusion_dnameinfo` (`cid` )
  ON DELETE CASCADE
  ON UPDATE CASCADE;

ALTER TABLE  `colfusion_dnameinfo` 
  ADD CONSTRAINT `fk_colfusion_dnameinfo_1`
  FOREIGN KEY (`sid` )
  REFERENCES  `colfusion_sourceinfo` (`Sid` )
  ON DELETE CASCADE
  ON UPDATE CASCADE
, ADD INDEX `fk_colfusion_dnameinfo_1_idx` (`sid` ASC) ;


ALTER TABLE  `colfusion_executeinfo` 
  ADD CONSTRAINT `fk_colfusion_executeinfo_1`
  FOREIGN KEY (`Sid` )
  REFERENCES  `colfusion_sourceinfo` (`Sid` )
  ON DELETE CASCADE
  ON UPDATE CASCADE
, ADD INDEX `fk_colfusion_executeinfo_1_idx` (`Sid` ASC) ;


ALTER TABLE  `colfusion_visualization` 
  ADD CONSTRAINT `fk_colfusion_visualization_1`
  FOREIGN KEY (`titleno` )
  REFERENCES  `colfusion_sourceinfo` (`Sid` )
  ON DELETE CASCADE
  ON UPDATE CASCADE
, ADD INDEX `fk_colfusion_visualization_1_idx` (`titleno` ASC) ;


