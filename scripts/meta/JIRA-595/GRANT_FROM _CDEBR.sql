select  'GRANT '||(LISTAGG (Privilege, ',')
               WITHIN GROUP (ORDER BY TB_NAME))||' ON '||TB_NAME||' TO CDEVALIDATE;'

from(

select distinct OWNER||'.'||p.TABLE_NAME TB_NAME ,Privilege 
from DBA_TAB_PRIVS p ,
user_tables u
where GRANTEE='CDEBROWSER'
and p.TABLE_NAME=u.TABLE_NAME
and p.TABLE_NAME not like '%VIEW%'
and p.TABLE_NAME not like '%TEMP%'
and p.TABLE_NAME not like '%TMP%'
and p.TABLE_NAME not like '%HST%'
and p.TABLE_NAME not like '%MVW%'
and p.TABLE_NAME not like '%BACKUP%'
and p.TABLE_NAME not like '%$%'
and p.TABLE_NAME not like '%STAGING%')
GROUP BY TB_NAME
order by 1;


select 'grant '||privilege||' on '||owner||'.'||table_name||' to cdevalidate;' from DBA_TAB_PRIVS where grantee='CDEBROWSER' and owner in ('SBR','SBREXT');

select * from dba_tables