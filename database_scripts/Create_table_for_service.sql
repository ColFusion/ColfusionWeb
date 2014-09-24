Create table colfusion_service(
	serviceID int not null,
	serviceName varchar(20),
	serviceAddress varchar (30) not null,
	portNumber int not null,
	serviceDir char(100) not null,
	serviceCommand varchar (100) not null,
	serviceStatus varchar (10) not null,
	primary key(serviceName)
)
