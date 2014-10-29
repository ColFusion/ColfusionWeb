ALTER TABLE colfusion_services DROP PRIMARY KEY;
ALTER TABLE colfusion_services ADD PRIMARY KEY (service_id);
ALTER TABLE colfusion_services MODIFY COLUMN service_id INT AUTO_INCREMENT;