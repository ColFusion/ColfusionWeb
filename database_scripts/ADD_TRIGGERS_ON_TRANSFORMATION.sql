DELIMITER $$

CREATE
	TRIGGER `transformation_after_insert` AFTER INSERT 
	ON `colfusion_pentaho_log_transformaion` 
	FOR EACH ROW 
    BEGIN
	      IF NEW.status like '%end%' THEN
    		UPDATE `colfusion_executeinfo`
            SET status = 'success', RecordsProcessed = NEW.LINES_WRITTEN
            WHERE Eid = NEW.TRANSNAME;
    	ELSE
    		UPDATE `colfusion_executeinfo`
        	SET status = NEW.status
        	WHERE Eid = NEW.TRANSNAME;
    	END IF;
    END$$

DELIMITER ;


DELIMITER $$

CREATE
	TRIGGER `transformation_after_update` AFTER UPDATE 
	ON `colfusion_pentaho_log_transformaion` 
	FOR EACH ROW 
    BEGIN
    	IF NEW.status like '%end%' THEN
    		UPDATE `colfusion_executeinfo`
            SET status = 'success', RecordsProcessed = NEW.LINES_WRITTEN
            WHERE Eid = NEW.TRANSNAME;
    	ELSE
    		UPDATE `colfusion_executeinfo`
        	SET status = NEW.status
        	WHERE Eid = NEW.TRANSNAME;
    	END IF;
    END$$

DELIMITER ;