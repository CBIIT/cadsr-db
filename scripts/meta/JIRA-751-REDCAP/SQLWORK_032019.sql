CREATE  TABLE REDCAP_SECTION_NEW
(
 PROTOCOL VARCHAR2(40 BYTE),
 FORM_NAME VARCHAR2(400 BYTE), 
 SECTION_SEQ NUMBER,
 SECTION_Q_SEQ NUMBER,
 QUESTION NUMBER,
 SECTION VARCHAR2(2000 BYTE) 
);


select* from REDCAP_SECTION where INSTUCTION is not null protocol like '%PX741401%';
select* from REDCAP_SECTION_NEW where protocol like '%PX741401%';

delete from REDCAP_SECTION_NEW;
 INSERT INTO REDCAP_SECTION_NEW
( PROTOCOL ,
 FORM_NAME ,
 SECTION_SEQ,
 SECTION_Q_SEQ,
 QUESTION ,
SECTION )
 SELECT distinct q.protocol, q.form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,q.SECTION,FORM_QUESTION
 --select*
 from REDCAP_PROTOCOL_test q
 where SECTION_Q_SEQ is  null 
-- protocol like '%PX741401'--;
 and protocol not like'Instructions%'
 order by  --q.protocol, q.form_name
 1,5,3
 
  UPDATE REDCAP_PROTOCOL_test SET SECTION_SEQ=0 , SECTION_Q_SEQ=question
 WHERE SECTION_SEQ is null and SECTION_Q_SEQ is null and protocol not like 'Instructions%';
 
 select sec.SECTION ,section_SEQ from REDCAP_SECTION  sec
where  NVL (TRIM (sec.SECTION), 'N/A')<>'N/A'
and protocol like '%PX741401%'
union
select long_name,display_order
from sbrext.quest_contents_ext mod
where dn_crf_idseq in (select qc_idseq from sbrext.quest_contents_ext where  qtl_name='CRF' and long_name ='PhenX PX741401 - Use Of Tobacco Products')--rec.form_name)
--and DISPLAY_ORDER=rec.section_SEQ
and mod.qtl_name='MODULE'
--and length(trim(mod.long_name))<>length(trim(SECTION))
and NVL(mod.modified_by ,'FORMLOADER') ='FORMLOADER'
order by 1,2

select* from REPORTS_ERROR_LOG;

exec MSDRDEV.MDSR_RECAP_MODE_FIX_SQL ;
exec MSDRDEV.redCapSact_Quest_populate2;
exec redCapSaction_populate2 ;
select* from SBREXT.MDSR_CDE_XML_REPORT_ERR

select* from MSDRDEV.REDCAP_FIX_SQL where form_name like '%PX741401%'order by form_name;

delete from SBREXT.MDSR_CDE_XML_REPORT_ERR;

delete from MSDRDEV.REDCAP_FIX_SQL;
