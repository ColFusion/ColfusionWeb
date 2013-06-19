-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteSource`(IN param1 varchar(200))
    READS SQL DATA
BEGIN
		
	delete from colfusion_sourceinfo where sid = param1;
	delete from colfusion_links where link_id = param1;

END
