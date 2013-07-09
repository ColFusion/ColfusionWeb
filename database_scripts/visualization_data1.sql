use colfusion;
insert into colfusion_canvases(`name`,`user_id`,`privilege`) values ("Canvas1", 1, 0);
insert into colfusion_canvases(`name`,`user_id`,`privilege`) values ("Canvas2", 1, 0);
insert into colfusion_canvases(`name`,`user_id`,`privilege`) values ("Canvas3", 2, 0);
insert into colfusion_canvases(`name`,`user_id`,`privilege`) values ("Canvas4", 3, 0);
insert into colfusion_canvases(`name`,`user_id`,`privilege`) values ("Canvas5", 3, 0);

insert into colfusion_charts(`name`,`vid`, `type`, `left`,`top`,`depth`,`height`,`width`,`datainfo`)
values("pie chart 1", 1 , "pie", 300,200,2,300,300,"[{'Category':' 2.0','AggValue':'1'},{'Category':' 3.0','AggValue':'1'},{'Category':' 4.0','AggValue':'1'}]");
insert into colfusion_charts(`name`,`vid`, `type`, `left`,`top`,`depth`,`height`,`width`,`datainfo`)
values("pie chart 1", 2 , "pie", 300,200,2,300,300,"[{'Category':' 2.0','AggValue':'1'},{'Category':' 3.0','AggValue':'1'},{'Category':' 4.0','AggValue':'1'}]");
insert into colfusion_charts(`name`,`vid`, `type`, `left`,`top`,`depth`,`height`,`width`,`datainfo`)
values("pie chart 1", 3 , "pie", 100,100,2,500,300,"[{'Category':' 2.0','AggValue':'1'},{'Category':' 3.0','AggValue':'1'},{'Category':' 4.0','AggValue':'1'}]");
insert into colfusion_charts(`name`,`vid`, `type`, `left`,`top`,`depth`,`height`,`width`,`datainfo`)
values("column chart 1", 1 , "column", 50,500,2,300,300,"[{'Category':' 2.0','AggValue':'1'},{'Category':' 3.0','AggValue':'1'},{'Category':' 4.0','AggValue':'1'}]");
insert into colfusion_charts(`name`,`vid`, `type`, `left`,`top`,`depth`,`height`,`width`,`datainfo`)
values("column chart 1", 4 , "column", 100,500,2,300,300,"[{'Category':' 2.0','AggValue':'1'},{'Category':' 3.0','AggValue':'1'},{'Category':' 4.0','AggValue':'1'}]");
insert into colfusion_charts(`name`,`vid`, `type`, `left`,`top`,`depth`,`height`,`width`,`datainfo`)
values("column chart 1", 5 , "column", 50,500,2,500,300,"[{'Category':' 2.0','AggValue':'1'},{'Category':' 3.0','AggValue':'1'},{'Category':' 4.0','AggValue':'1'}]");
insert into colfusion_charts(`name`,`vid`, `type`, `left`,`top`,`depth`,`height`,`width`,`datainfo`)
values("table chart 1", 2 , "column", 400,500,2,300,300,"{'data':[{'rownum':'1','ID':' 2.0','la':' 35.273637','long':' 108.0','dvalue':' 2.0'},{'rownum':'2','ID':' 3.0','la':' 40.234','long':' 119.0','dvalue':' 3.0'},{'rownum':'3','ID':' 4.0','la':' 29.873','long':' 125.0','dvalue':' 4.0'}],'Control':{'perPage':'50','totalPage':1,'pageNo':'1','cols':'`ID`,`la`,`long`,`dvalue`'}}");

insert into colfusion_shares values(1,1,0);
insert into colfusion_shares values(2,1,0);
insert into colfusion_shares values(3,2,0);
insert into colfusion_shares values(4,3,0);
insert into colfusion_shares values(5,3,0);
insert into colfusion_shares values(1,2,1);
insert into colfusion_shares values(1,3,2);
insert into colfusion_shares values(2,3,2);
insert into colfusion_shares values(3,1,1);
insert into colfusion_shares values(4,1,2);
insert into colfusion_shares values(5,1,2);