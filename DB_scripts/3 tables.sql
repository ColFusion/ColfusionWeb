create table if not exists colfusion_dnamelist(
dnameid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
did INT,
cid INT,
Dname VARCHAR(100));

create table if not exists colfusion_documentinfo(
did INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
Ddescription VARCHAR(100),
UserId INT);

create table if not exists colfusion_columninfo(
cid INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
type VARCHAR(100),
value VARCHAR(100));
