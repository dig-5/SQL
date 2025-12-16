create table x (x int);

drop table x;

select top 10 * from ddl_log
order by momentoauditoria desc;

select user_name()
