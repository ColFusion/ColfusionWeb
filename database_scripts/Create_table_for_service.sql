create table colfusion_service(
	service_id int not null,
	service_name varchar(20) collate utf8_unicode_ci,
	service_address varchar (30) collate utf8_unicode_ci not null,
	port_number int not null,
	service_dir varchar(100) collate utf8_unicode_ci not null,
	service_command varchar (100) collate utf8_unicode_ci not null,
	service_status varchar (20) collate utf8_unicode_ci not null,
	primary key(service_name)
)

