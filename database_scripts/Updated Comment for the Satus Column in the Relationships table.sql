ALTER TABLE `colfusion_relationships` 
CHANGE COLUMN `status` `status` INT(1) NOT NULL DEFAULT '0' COMMENT '0->valid, \n1->deleted, \n2->new, indexes on the columns are not created yet.' ;
