select*from SBREXT.MDSR_DUP_VM_ERR where date_created>SYSDATE-1

select * from dba_network_acls;

select acl , principal , privilege , is_grant from DBA_NETWORK_ACL_PRIVILEGES;

SELECT distinct ROLE FROM ROLE_SYS_PRIVS 


select utl_http.request('https://support.oracle.com', NULL,'file:/home/oracle/wallet','password123') from dual


select substr(utl_http.request('http://lexevscts2.nc.nih.gov'),1,30) from dual;
select substr(utl_http.request('http://www.oracleflash.com'),1,30) from dual
