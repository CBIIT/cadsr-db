
select *
--delete                                                                   --   delete 
 from  sbrext.PROTOCOL_QC_EXT   where QC_IDSEQ in
(select QC_IDSEQ
---select count(*)
from sbrext.QUEST_CONTENTS_EXT 
where date_created>sysdate-2 and CREATED_BY='FORMLOADER' --);
--and QTL_NAME='CRF'
and (long_name like'PhenX PX030502%' or long_name like'PhenX PX030502%' 
or long_name like'PhenX PX030502%' or long_name like'PhenX PX030502%' or));
PX030502,PX061501,PX510404,PX510801,PX660701,PX660801



select count(*)
--delete 
from  QUEST_ATTRIBUTES_EXT  where QC_IDSEQ in(select QC_IDSEQ
from QUEST_CONTENTS_EXT 
where date_created>sysdate-2 and CREATED_BY='FORMLOADER');

select count(*)
--delete
from 
VALID_VALUES_ATT_EXT  where QC_IDSEQ in(select QC_IDSEQ
from QUEST_CONTENTS_EXT 
where date_created>sysdate-2
and CREATED_BY='FORMLOADER');


select count(*)
--select distinct *--dn_crf_idseq
--delete 
from sbrext.QUEST_CONTENTS_EXT 
where date_created>sysdate-2 and CREATED_BY='FORMLOADER'
--and qc_idseq=
and QTL_NAME='CRF' and long_name like 'PhenX%'
and QTL_NAME='FORM_INSTR'
and QTL_NAME='MODULE'
and QTL_NAME = 'QUESTION_INSTR'
and QTL_NAME='VALID_VALUE';
PX031402,PX161602,PX230101,PX560201





select *   --delete                                                                   --   delete 
   from  PROTOCOL_QC_EXT   where QC_IDSEQ in
(select QC_IDSEQ
--delete 
from QUEST_CONTENTS_EXT 
where QC_id=5605352);

         select*
--delete 
from  QUEST_ATTRIBUTES_EXT  where QC_IDSEQ in(select QC_IDSEQ
--delete 
from QUEST_CONTENTS_EXT 
where DN_CRF_IDSEQ in (select QC_IDSEQ
--delete 
from QUEST_CONTENTS_EXT 
where QC_id=5605352));

select*
--delete
from 
VALID_VALUES_ATT_EXT  where QC_IDSEQ in
(select QC_IDSEQ
--delete 
from QUEST_CONTENTS_EXT 
where DN_CRF_IDSEQ in (select QC_IDSEQ
--delete 
from QUEST_CONTENTS_EXT 
where QC_id=5605352));

select count(*)
--delete 
from QUEST_CONTENTS_EXT 
where date_created>sysdate-35 and CREATED_BY='FORMLOADER'
          
          
 
select MAX(QC_ID),MIN(QC_ID)
-- select count(*)
--delete 
from QUEST_CONTENTS_EXT 
where date_created>sysdate-15 and CREATED_BY='FORMLOADER'
--and QTL_NAME like 'QUESTION%'
and QTL_NAME='VALID_VALUE'
and QC_ID<6330000
select distinct protocol from sbrext.redcap_protocol_new


select*from redcap_xml_group  where protocol in ('PX021001','PX071101','PX090901','PX091301','PX151302','PX161001','PX170801')



select*from MDSR_PROTOCOLS_ERR_LOG;
select*from MDSR_PROTOCOLS_temp;

 select *   --delete                                                                   --   delete 
   from  PROTOCOL_QC_EXT   where QC_IDSEQ in
(select QC_IDSEQ
--delete 
from QUEST_CONTENTS_EXT 
where date_created>sysdate-2 and CREATED_BY='FORMLOADER')
and long_name like'Calcium Intake%')


select *from SBREXT.protocols_ext where preferred_name like 'PX030702'; 

--where proto_IDSEQ='3FB252DB-B368-4254-E053-246C850A144D'
select*
--delete 
FROM SBREXT.REDCAP_XML where created_date>sysdate-8 order by 1

select *

from QUEST_CONTENTS_EXT where qc_id=6462585
where date_created>sysdate-20 and CREATED_BY='FORMLOADER'
and QTL_NAME='CRF' and long_name like'PhenX %'
and QTL_NAME not like 'QUESTION%'
and QTL_NAME not like'VALID_VALUE%'

UPDATE QUEST_CONTENTS_EXT  set long_name=replace(long_name,'PhenX  ','PhenX ')
where date_created>sysdate-20 and CREATED_BY='FORMLOADER'
and QTL_NAME='CRF' and long_name like'PhenX  %'

select form_name_new from REDCAP_PROTOCOL_FORM_751
minus
select qc_id

from QUEST_CONTENTS_EXT where  date_created>sysdate-2 and CREATED_BY='FORMLOADER'
and QTL_NAME='CRF' and long_name not like'%PX%'
