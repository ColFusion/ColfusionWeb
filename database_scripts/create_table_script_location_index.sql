CREATE TABLE IF NOT EXISTS colfusion_index_location (
   lid  int(11) NOT NULL AUTO_INCREMENT,
   location_search_key VARCHAR(255),
   cid int(11) NOT NULL,
   PRIMARY KEY (lid),
   CONSTRAINT fk_colfusion_index_location_1 FOREIGN KEY (cid) REFERENCES colfusion_dnameinfo (cid) ON DELETE CASCADE ON UPDATE CASCADE,
   UNIQUE KEY (location_search_key,cid)   
)