create table colfusion_license(
	license_ID INTEGER auto_increment NOT NULL,
	license_Name VARCHAR(50) NOT NULL,
	license_Des TEXT,
	license_URL TEXT,
	PRIMARY KEY(license_ID)
)

insert into colfusion_license (license_Name, license_Des, license_URL) values ('Creative Commons Attribution ShareAlike 4.0', 'Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)', 'https://creativecommons.org/licenses/by-sa/4.0/'), ('Creative Commons Attribution ShareAlike 3.0', 'Attribution-ShareAlike 3.0 Unported (CC BY-SA 3.0)', 'https://creativecommons.org/licenses/by-sa/3.0/'), ('Creative Commons Attribution 4.0', 'Attribution 4.0 International (CC BY 4.0)', 'https://creativecommons.org/licenses/by/4.0/'), ('Creative Commons Attribution 3.0 ', 'Attribution 3.0 Unported (CC BY 3.0)', 'https://creativecommons.org/licenses/by/3.0/'), ('Creative Commons CC0 Waiver(release all rights, like public domain)', 'CC0 1.0 Universal (CC0 1.0) Public Domain Dedication', 'https://creativecommons.org/publicdomain/zero/1.0/')

ALTER TABLE  'colfusion_sourceinfo' ADD  'license_ID' INT NULL DEFAULT NULL ;

ALTER TABLE  `colfusion_sourceinfo` ADD FOREIGN KEY (  `license_ID` ) REFERENCES  `colfusion_license` (  `license_ID` )