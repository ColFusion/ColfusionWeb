DELIMITER $$

CREATE
	TRIGGER `transformation_after_insert` AFTER INSERT 
	ON `colfusion_pentaho_log_transformaion` 
	FOR EACH ROW 
        BEGIN
	        SET @st = (SELECT status FROM colfusion_pentaho_log_transformaion where TRANSNAME = NEW.TRANSNAME);

	        UPDATE `colfusion_executeinfo`
            SET status = 
                CASE 
                   WHEN @st like '%end%' THEN
                    'success'
                	ELSE @st
                END
            WHERE Eid = NEW.TRANSNAME;
		
    END$$

DELIMITER ;


DELIMITER $$

CREATE
	TRIGGER `transformation_after_update` AFTER UPDATE 
	ON `colfusion_pentaho_log_transformaion` 
	FOR EACH ROW 
        BEGIN
        	SET @st = (SELECT status FROM colfusion_pentaho_log_transformaion where TRANSNAME = NEW.TRANSNAME);

	        UPDATE `colfusion_executeinfo`
            SET status = 
                CASE 
                   WHEN @st like '%end%' THEN
                    'success'
                	ELSE @st
                END
            WHERE Eid = NEW.TRANSNAME;
		
    END$$

DELIMITER ;