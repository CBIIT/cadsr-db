select* from MSDRDEV.REDCAP_XML_GROUP_CSV_VW where  group_number=3;

SELECT 
count(*)-14
 from  MDSR_REDCAP_PROTOCOL_CSV 
 select* from MSDRDEV.REDCAP_XML_GROUP_CSV_VW
 
   select* from MDSR_REDCAP_PROTOCOL_CSV where section is not null and  SECTION_SEQ=0,SECTION_Q_SEQ--set protocol='Instructions to'||PROTOCOL,question=1000
  where question=1000 and field_type='descriptive';
  delete from MSDREDCAP_SECTION_CSV
  update MDSR_REDCAP_PROTOCOL_CSV set SECTION_SEQ=null,SECTION_Q_SEQ=null;
 select count(*) from   MSDREDCAP_SECTION_CSV ;
 select count(*) from  MSDREDCAP_VALUE_CODE_CSV--17323
  select count(*)
--select distinct *--dn_crf_idseq
--delete 
from sbrext.QUEST_CONTENTS_EXT 
where date_created>sysdate-2 and CREATED_BY='FORMLOADER'
--and qc_idseq=
--and QTL_NAME='CRF' and long_name like 'PhenX%'
--and QTL_NAME='FORM_INSTR'
--and QTL_NAME='MODULE'
--and QTL_NAME = 'QUESTION'
and QTL_NAME='VALID_VALUE'; 16992
  
  delete  from MDSR_REDCAP_PROTOCOL_CSV;
exec MDSR_RECAP_INSERT_CSV;
exec MDSR_RECAP_UPDATE_CSV;
exec MDSR_RECAP_UPDATE_CSV2;
exec MDSRedCapSaction_populate ;
exec MSDRedCapSact_Quest_populate;
exec MDSRedCapSaction_Insert;
exec MDSRedCapForm_Insert ;
exec MSDRDEV.MDSRedCap_VALVAL_Insert;
select*
--select  count(*) 
from  MDSR_REDCAP_PROTOCOL_CSV where protocol not like 'Instructions%';
select count(*) from MSDREDCAP_FORM_CSV;
select count(*) from MSDREDCAP_SECTION_CSV;
select count(*) from MSDREDCAP_VALUE_CODE_CSV;

exec xml_RedCap_insertCSV;
exec MSDRDEV.REDCAP_XML_TRANSFORM;
select count(*)
--delete 
from  MSDREDCAP_VALUE_CODE_CSV
where VAL_NAME       is null or
  VAL_VALUE is null and dbms_lob.getlength(VAL_VAL_NAME) >0
  order by protocol,question
  
  selet* from  MSDRDEV.REDCOP_PR_GROUP_CSV_VW
  select* from REDCAP_XML
  
  select* from MSDRDEV.REDCAP_XML_GROUP_CSV_VW
  
  
    select count(*)
--select distinct *--dn_crf_idseq
--delete 
from sbrext.QUEST_CONTENTS_EXT f,sbrext.QUEST_CONTENTS_EXT v
where f.date_created>sysdate-2 and f.CREATED_BY='FORMLOADER'
and f.qc_idseq=v.dn_crf_idseq
and f.QTL_NAME='CRF' and f.long_name like 'PhenX%'
--and v.QTL_NAME='FORM_INSTR'
--and v.QTL_NAME='MODULE'
--and QTL_NAME = 'QUESTION'
and v.QTL_NAME='VALID_VALUE';



select form_name,trim(VAL_NAME) , trim(VAL_VALUE) 
from  MSDREDCAP_VALUE_CODE_CSV
--where form_name like 'PhenX PX100203%' or protocol='PX100203'
--order by 1,2,3-
minus

  select f.long_name,trim(v.long_name),trim(v.PREFERRED_DEFINITION)
  select count(*)
from sbrext.QUEST_CONTENTS_EXT f,sbrext.QUEST_CONTENTS_EXT v
where f.date_created>sysdate-2 and f.CREATED_BY='FORMLOADER'
and f.qc_idseq=v.dn_crf_idseq
and f.QTL_NAME='CRF' --and f.long_name like 'PhenX PX%'
--and v.QTL_NAME='FORM_INSTR'
--and v.QTL_NAME='MODULE'
and v.QTL_NAME = 'QUESTION'
--and v.QTL_NAME='VALID_VALUE'
order by 1,2;

select *--f.long_name,trim(q.long_name),trim(q.PREFERRED_DEFINITION)
from sbrext.QUEST_CONTENTS_EXT f--,sbrext.QUEST_CONTENTS_EXT q
where f.date_created>sysdate-2 and f.CREATED_BY='FORMLOADER'
--and f.qc_idseq=q.dn_crf_idseq
--and q.QTL_NAME = 'QUESTION'
and f.QTL_NAME='CRF' and f.long_name like 'PhenX PX100203%'

select protocol,form_name from  MSDREDCAP_VALUE_CODE_CSV
--MDSR_REDCAP_PROTOCOL_CSV
 where form_name not like 'PhenX%'
 
 
 select form_name_new from MSDREDCAP_FORM_CSV
 minus
 select long_name
from sbrext.QUEST_CONTENTS_EXT f
where f.date_created>sysdate-2 and f.CREATED_BY='FORMLOADER'
and f.QTL_NAME='CRF' and f.long_name  like 'PhenX%'




select distinct form_name from(

  select count(*) ctn,f.LONG_NAME form_name,m.display_order,v.long_name,v.p_mod_idseq,m.long_name
from sbrext.QUEST_CONTENTS_EXT f,sbrext.QUEST_CONTENTS_EXT v,sbrext.QUEST_CONTENTS_EXT m
where f.date_created>sysdate-2 and f.CREATED_BY='FORMLOADER'
and f.qc_idseq=m.dn_crf_idseq
and v.p_mod_idseq=m.qc_idseq
and f.QTL_NAME='CRF' --and f.long_name like 'PhenX PX%'
--and v.QTL_NAME='FORM_INSTR'
and m.QTL_NAME='MODULE'
and v.QTL_NAME = 'QUESTION'
group by f.LONG_NAME ,v.long_name,v.p_mod_idseq,m.long_name,m.display_order
having count(*)>2   --)
--and v.QTL_NAME='VALID_VALUE'
order by 2,3,4;

select f.LONG_NAME form_name,m.display_order,v.display_order,v.long_name,v.p_mod_idseq,m.long_name
from sbrext.QUEST_CONTENTS_EXT f,sbrext.QUEST_CONTENTS_EXT v,sbrext.QUEST_CONTENTS_EXT m
where f.date_created>sysdate-2 and f.CREATED_BY='FORMLOADER'
and f.qc_idseq=m.dn_crf_idseq
and v.p_mod_idseq=m.qc_idseq
and f.QTL_NAME='CRF' --and f.long_name like 'PhenX PX%'
--and v.QTL_NAME='FORM_INSTR'
and m.QTL_NAME='MODULE'
and v.QTL_NAME = 'QUESTION'
--and v.display_order in (43,44,45)
--and m.display_order=8
and f.long_name  like 'PhenX PX750201%'
order by 2,3

SX-23. How long have you been having a sexual relationship with this partner? (Please tell me how many days, months, or years.) [Interviewer: If 