select  FIELD_LABEL,REGEXP_REPLACE(ASCIISTR(FIELD_LABEL), '\\[[:xdigit:]]{4}', '') from  REDCAP_PROTOCOL_NEW --where instr(field_label,'¤')>0;
where protocol='PX021501' and question=0;

where protocol='PX170901' and question=86;

select*from REDCAP_PROTOCOL_NEW where  instr( FIELD_LABEL,'&'||'#149;')>0;-- protocol='PX220901' and question=0;

&#149;

select  FIELD_LABEL,REGEXP_REPLACE(ASCIISTR(FIELD_LABEL), '\\[[:xdigit:]]{4}', '') from  REDCAP_PROTOCOL_NEW --where instr(field_label,'¤')>0;
where protocol='PX050601' and instr(field_label,'RRRR')>0;

SElect distinct protocol from redcap_xml where instr(field_label,'°')>0;
SElect distinct protocol from redcap_xml where instr(text,'©')>0;
SElect distinct protocol from redcap_xml where instr(text,'®')>0;
SElect distinct protocol from redcap_xml where instr(text,'™')>0;
SElect distinct protocol from redcap_xml where instr(text,'÷')>0;
SElect distinct protocol from redcap_xml where instr(text,'±')>0; -- PX150302 collect 14
SElect * from redcap_xml_BKUP where instr(text,'µ')>0;
SElect distinct protocol from redcap_xml where instr(text,'¢')>0;  &cent; CTCTCT

create table REDCAP_PROTOCOL_NEW_BKUP as select*from REDCAP_PROTOCOL_NEW
create table redcap_xml_BKUP as select*from redcap_xml where CREATED_DATE<sysdate-20
select*from REDCAP_PROTOCOL_NEW where instr(field_label,'µ')>0;

UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'°','DDDD') where instr(field_label,'°')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'©','CCCC') where instr(field_label,'©')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'®','RRRR') where instr(field_label,'®')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'™','TTTT') where instr(field_label,'™')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'µ','MUMUMU') where instr(field_label,'µ')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'×','XxXxXx') where instr(field_label,'×')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'±','PMPMPM') where instr(field_label,'±')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'¢','ctctct') where instr(field_label,'¢')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=REGEXP_REPLACE(ASCIISTR(field_label), '\\[[:xdigit:]]{4}', '')
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'&'||'#149;','') where  instr( FIELD_LABEL,'&'||'#149;')>0;

select* FROM REDCAP_VALUE_CODE where protocol='PX140802'

trim(val_value)='y' --val_name is null ;

select*from sbr.valid_values


update   redcap_value_code set val_name='F' where protocol='PX220101' and val_name is null ;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'÷','/') where instr(field_label,'÷')>0;

select UTL_I18N.UNESCAPE_REFERENCE('&'||'deg;')from  dual;
select UTL_I18N.UNESCAPE_REFERENCE('&'||'copy;')from  dual;
select UTL_I18N.UNESCAPE_REFERENCE('&'||'cent;')from  dual;
select UTL_I18N.UNESCAPE_REFERENCE('&'||'reg;')from  dual;
select UTL_I18N.UNESCAPE_REFERENCE('&'||'plusmn;')from  dual;
select UTL_I18N.UNESCAPE_REFERENCE('&'||'micro;')from  dual;
select UTL_I18N.UNESCAPE_REFERENCE('&'||'#215;')from  dual;
select UTL_I18N.UNESCAPE_REFERENCE('&'||'#8482;')from  dual;

UPDATE redcap_xml set text=UTL_I18N.UNESCAPE_REFERENCE('&'||'deg;') where instr(text,'DDDD')>0;
UPDATE redcap_xml set text=UTL_I18N.UNESCAPE_REFERENCE('&'||'copy;') where instr(text,'CCCC')>0;
UPDATE redcap_xml set text=UTL_I18N.UNESCAPE_REFERENCE('&'||'reg;') where instr(text,'RRRR')>0;
UPDATE redcap_xml set text=UTL_I18N.UNESCAPE_REFERENCE('&'||'#8482;') where instr(text,'TTTT')>0;
UPDATE redcap_xml set text=UTL_I18N.UNESCAPE_REFERENCE('&'||'micro;') where instr(text,'MUMUMU')>0;
UPDATE redcap_xml set text=UTL_I18N.UNESCAPE_REFERENCE('&'||'#215;') where instr(text,'XxXxXx')>0;
UPDATE redcap_xml set text=UTL_I18N.UNESCAPE_REFERENCE('&'||'plusmn;') where instr(text,'PMPMPM')>0;
UPDATE redcap_xml set text=UTL_I18N.UNESCAPE_REFERENCE('&'||'cent;') where instr(text,'ctctct')>0;
where  instr( FIELD_LABEL,'&'||'#149;')>0;

delete  from redcap_xml
© CCCC

® RRRR

° DDDD

™  TTTT

select*from REDCAP_COLLECT_VW  where substr("collectionName",19) =22

select*from SBREXT.REDCAP_COLLECT_VW
select*from SBREXT.REDCAP_XML where created_date>sysdate-5 order by 1;


select replace 


--SELECT REGEXP_REPLACE(COLUMN,'[^' || CHR(1) || '-' || CHR(127) || '],'');


select 1 from dual
where regexp_like(trim('xx test text æ¸¬è© ¦ “xmx” number²'),'['||chr(128)||'-'||chr(255)||']','in')


select REGEXP_REPLACE (FIELD_LABEL,'[^' || CHR (32) || '-' || CHR (127) || ']', ' ') from  REDCAP_PROTOCOL_NEW
where protocol='PX021501' and question=0;


select regexp_replace(trim(FIELD_LABEL),'['||chr(128)||'-'||chr(255)||']','',1,0,'in')
from  REDCAP_PROTOCOL_NEW
where protocol='PX021501' and question=0;

select regexp_replace(trim(FIELD_LABEL),'['||chr(1)||'-'||chr(31)||']','',1,0,'in')
from  REDCAP_PROTOCOL_NEW
where protocol='PX021501' and question=0;

create table REDCAP_PROTOCOL_FORM as SELECT DISTINCT r.protocol, TRIM ('PhenX '|| INITCAP ( REPLACE 
                                       ( REPLACE (LOWER (TRIM (form_name)), '_', ' '),
                                        'phenx',''))||' - '||r.protocol) form_name,preferred_Definition
                            FROM REDCAP_PROTOCOL_NEW r,
                            protocols_ext p
                            where p.preferred_name=r.protocol;
                            
                            select count(*),protocol from REDCAP_PROTOCOL_FORM
                            group by protocol having count(*)>1;
                            
                            
                            select * from REDCAP_PROTOCOL_FORM where protocol='PX510101'
                            delete from REDCAP_PROTOCOL_FORM where protocol='PX510101' and FORM_NAME like'%Drugs%'
                            exec SBREXT.REDCAP_PREVIW_TRANSFORM;
select*from SBREXT.REDCAP_COLLECT_VW;
exec SBREXT.REDCAP_PREVIW_TRANSFORM;
exec SBREXT.xml_GROUP_RedCop_insert;
exec SBREXT.REDCAP_XML_TRANSFORM;


select*from SBREXT.REDCAP_XML where created_date>sysdate-5 order by 1;

select*from protocols_ext where preferred_name in ('PX150801','PX751301')


select distinct form_name from 


select* from REDCAP_PROTOCOL_NEW
where protocol in('PX510101' ,'PX510102')
order by protocol,question;--and question=0;
select* from REDCAP_PROTOCOL_NEW
--UPdate REDCAP_PROTOCOL_NEW set protocol='PX510102'
where protocol='PX510102' and question=53;


select*from REDCAP_VALUE_CODE where protocol='PX510102'

update REDCAP_VALUE_CODE set question=question+1 where protocol='PX510102';

select* from REDCAP_PROTOCOL_NEW
--UPdate REDCAP_PROTOCOL_NEW set  question=0,SECTION_Q_SEQ=0
where protocol='PX510102' 
order by question;


select 1 from REDCAP_PROTOCOL_FORM
where regexp_like(trim(preferred_definition),'['||chr(1)||'-'||chr(31)||']','in') and protocol='PX630402';


select protocol from REDCAP_PROTOCOL_FORM
where regexp_like(trim(preferred_definition),'['||chr(127)||'-'||chr(255)||']','in') order by 1;


SELECT REGEXP_REPLACE(preferred_definition,'[^' || CHR(1) || '-' || CHR(31) || ']','',1,0,'in') from REDCAP_PROTOCOL_FORM
where protocol='PX630402';

select regexp_replace(trim('xx test text æ¸¬è© ¦ “xmxmx” number²'),'['||chr(128)||'-'||chr(255)||']','',1,0,'in')
from dual;

select distinct protocol,form_name from
REDCAP_PROTOCOL_NEW
where protocol ='PX150901'
in ('PX150801','PX751301')

phenx_total_physical_activityobjective_measure
phenx_support_for_tobaccorelated_policies

select preferred_name,long_name from protocols_ext where PREFERRED_NAME like 'PX%' and upper(long_name) like '%TOBAC%' and upper(long_name) like '%SUPPORT%'
order by long_name

select preferred_name,long_name from protocols_ext where PREFERRED_NAME like 'PX%' and lower(long_name) like '%physical%' and lower(long_name) like '%activity%'
order by long_name