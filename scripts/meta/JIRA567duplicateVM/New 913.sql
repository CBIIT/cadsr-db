select
distinct IDSEQ ,error_text
from SBREXT.MDSR_DUP_VM_ERR where date_created>SYSDATE-17
and (error_text ='ORA-01403: no data found' or error_text like'ORA-12899: value too large %')
and IDSEQ is not null
order by 2

select * from DBA_NETWORK_ACLS;
select  *from DBA_NETWORK_ACL_PRIVILEGES;

SELECT DISTINCT CODE FROM SBREXT.MDSR_CONCEPTS_SYNONYMS;
exec SBREXT.META_INSERT_CONCEPT_SYN;
exec SBREXT.MDSR_UPDATE_SYNONYMS_XML;
select utl_http.request('https://support.oracle.com', NULL,'file:/home/oracle/wallet','password123') from dual


select substr(utl_http.request('http://lexevscts2.nci.nih.gov'),1,30) from dual;
select substr(utl_http.request('http://www.oracleflash.com'),1,30) from dual;





select c.preferred_name,c.long_name
from SBREXT.CONCEPTS_EXT c, SBREXT.MDSR_SYNONYMS_XML x
where trim(preferred_name)=CODE
and code='C28427'    
order by 1;


SELECT*FROM SBREXT.MDSR_SYNONYMS_XML x
where  code='C28427'    ;


SELECT count(*)
FROM SBREXT.MDSR_CONCEPTS_SYNONYMS;

SELECT count(*) ,code
FROM SBREXT.MDSR_CONCEPTS_SYNONYMS
group by code;

select *
from SBREXT.CONCEPTS_EXT
 where trim(preferred_name)='C3114' ;
 
 select trim(upper(long_name))  from SBREXT.CONCEPTS_EXT where trim(preferred_name)='C3114'
and DATE_MODIFIED =(select max(DATE_MODIFIED)from SBREXT.CONCEPTS_EXT where trim(preferred_name)='C3114');