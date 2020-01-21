select count(*),owner from( 
select* from DBOBJ_11g
minus
select*from DBOBJ_12c )group by owner
order by 2;



select count(*),'      '||owner,'      '||object_type from( 
select* from DBOBJ_11g
minus
select*from DBOBJ_12c )
group by owner,object_type
order by 2,3;

select count(*)from all_objects where  owner like'SBR%' order by 1
,3,2;

select *from all_objects where  owner like'SBR%' order by 1,3,2;

select owner,object_name,object_type from all_objects where object_name = 'CADSR_USERS';


select * from all_objects where object_name = 'CADSR_USERS';

select * from ALL_VIEWS where VIEW_name = 'CADSR_USERS';

select* from sys.user$  or sys.dba_users

select * from all_objects where object_name in ('USER$','DBA_USERS')


select* from sys.dba_tables where table_name in ('USER$','DBA_USERS')


