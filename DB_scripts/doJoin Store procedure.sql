-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `doJoin`(IN param1 varchar(200))
    READS SQL DATA
BEGIN

	SET @text := TRIM(BOTH ',' FROM param1);
	SET @strLen := 0;
	SET @i := 1;

	SET @sid := SUBSTRING_INDEX(@text, ',', @i);
    SET @strLen := LENGTH(@sid);
    SET @i := @i + 1;
	set @sid := SUBSTRING_INDEX(@sid, ',', -1);

	SET @joinTableIndex := 0;
	
	SET @sql = CONCAT('drop temporary table if exists resultDoJoin');
	PREPARE stmt FROM @sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

	IF @sid <> "" THEN

			SET @sql = CONCAT('drop temporary table if exists tmpTable', @i);
			PREPARE stmt FROM @sql;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;

			SET @sql = NULL;

			SELECT
			  GROUP_CONCAT(DISTINCT
				CONCAT(
				  'MAX(IF(dname = ''',
				  TRIM(dname),
				  ''', value, NULL)) AS `',
				  TRIM(dname),'`'
				)
			  ) INTO @sql
			FROM
			  colfusion_temporary
			where 
			sid = @sid;
				
			SET @sql = CONCAT('CREATE TEMPORARY TABLE tmpTable', @i, ' SELECT rownum, ', @sql, ' FROM colfusion_temporary where sid = ', @sid,' GROUP BY rownum');

			PREPARE stmt FROM @sql;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;


		WHILE @strLen < LENGTH(@text)  DO
			SET @sid := SUBSTRING_INDEX(@text, ',', @i);
			SET @strLen := LENGTH(@sid);
			SET @i := @i + 1;
			set @sid := SUBSTRING_INDEX(@sid, ',', -1);

				SET @sql = CONCAT('drop temporary table if exists tmpTable', @i);
				PREPARE stmt FROM @sql;
				EXECUTE stmt;
				DEALLOCATE PREPARE stmt;

					SET @sql = NULL;

					SELECT
					  GROUP_CONCAT(DISTINCT
						CONCAT(
						  'MAX(IF(dname = ''',
						  TRIM(dname),
						  ''', value, NULL)) AS `',
						  TRIM(dname),'`'
						)
					  ) INTO @sql
					FROM
					  colfusion_temporary
					where 
					sid = @sid;
			

					SET @sql = CONCAT('CREATE TEMPORARY TABLE tmpTable', @i, ' SELECT rownum, ', @sql, ' FROM colfusion_temporary where sid = ', @sid,' GROUP BY rownum');

					PREPARE stmt FROM @sql;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;

				if @joinTableIndex = 0 then
					
					SET @sql = CONCAT('drop temporary table if exists tmpTableJoined', @joinTableIndex);
					
					PREPARE stmt FROM @sql;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;

					SET @sql = CONCAT('CREATE TEMPORARY TABLE tmpTableJoined', @joinTableIndex, ' SELECT * FROM tmpTable', @i-1,' NATURAL JOIN ', 'tmpTable',@i);

					PREPARE stmt FROM @sql;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;

					SET @sql = CONCAT('drop temporary table if exists tmpTable', @i-1);
					
					PREPARE stmt FROM @sql;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;

					SET @sql = CONCAT('drop temporary table if exists tmpTable', @i);
					
					PREPARE stmt FROM @sql;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;
				else

					SET @sql = CONCAT('drop temporary table if exists tmpTableJoined', @joinTableIndex);
					
					PREPARE stmt FROM @sql;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;
				
					SET @sql = CONCAT('CREATE TEMPORARY TABLE tmpTableJoined', @joinTableIndex, ' SELECT * FROM tmpTableJoined', @joinTableIndex-1,' NATURAL JOIN ', 'tmpTable',@i);	

					PREPARE stmt FROM @sql;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;

					SET @sql = CONCAT('drop temporary table if exists tmpTableJoined', @joinTableIndex-1);
					
					PREPARE stmt FROM @sql;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;

					SET @sql = CONCAT('drop temporary table if exists tmpTable', @i);
					
					PREPARE stmt FROM @sql;
					EXECUTE stmt;
					DEALLOCATE PREPARE stmt;

				end if;

				

			SET @joinTableIndex := @joinTableIndex + 1;
		END WHILE;

		IF @joinTableIndex > 0 THEN
		--	SET @sql = CONCAT('select * from tmpTableJoined', @joinTableIndex-1, ' LIMIT ', lim);
		--	PREPARE stmt FROM @sql;
		--	EXECUTE stmt;
		--	DEALLOCATE PREPARE stmt;


			SET @sql = CONCAT('CREATE TEMPORARY TABLE resultDoJoin SELECT * FROM tmpTableJoined', @joinTableIndex-1);
			PREPARE stmt FROM @sql;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;



			SET @sql = CONCAT('drop temporary table if exists tmpTableJoined', @joinTableIndex - 1);
			PREPARE stmt FROM @sql;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;
		else
		--	SET @sql = CONCAT('select * from tmpTable', @i, ' LIMIT ', lim);
			
		--	PREPARE stmt FROM @sql;
		--	EXECUTE stmt;
		--	DEALLOCATE PREPARE stmt;

			
			SET @sql = CONCAT('CREATE TEMPORARY TABLE resultDoJoin SELECT * FROM tmpTable', @i);
			PREPARE stmt FROM @sql;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;


			SET @sql = CONCAT('drop temporary table if exists tmpTable', @i);
			PREPARE stmt FROM @sql;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;
		END IF;

	END IF;



END
