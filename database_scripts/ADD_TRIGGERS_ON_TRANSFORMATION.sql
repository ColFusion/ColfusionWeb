DELIMITER $$

CREATE
	TRIGGER `transformation_after_insert` AFTER INSERT 
	ON `colfusion_pentaho_log_transformaion` 
	FOR EACH ROW 
        BEGIN
	        UPDATE `colfusion_executeinfo`
                SET status = (SELECT status FROM colfusion_pentaho_log_transformaion where TRANSNAME = NEW. TRANSNAME)
                WHERE Eid = NEW. TRANSNAME;
		
    END$$

DELIMITER ;


DELIMITER $$

CREATE
	TRIGGER `transformation_after_update` AFTER UPDATE 
	ON `colfusion_pentaho_log_transformaion` 
	FOR EACH ROW 
        BEGIN
	        UPDATE `colfusion_executeinfo`
                SET status = (SELECT status FROM colfusion_pentaho_log_transformaion where TRANSNAME = NEW. TRANSNAME)
                WHERE Eid = NEW. TRANSNAME;
		
    END$$

DELIMITER ;