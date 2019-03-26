select*from 
MSDRDEV.REDCAP_PROTOCOL_form rf
--,REDCAP_SECTION_NEW  sec
where --sec.protocol=rf.protocol
--and NVL (TRIM (sec.SECTION), 'N/A')<>'N/A'and 
rf.form_name like '%PX741401%'

select*from 
REDCAP_SECTION_NEW  sec
where --sec.protocol=rf.protocol
--and NVL (TRIM (sec.SECTION), 'N/A')<>'N/A'and 
protocol like '%PX741401%'


select mod.DISPLAY_ORDER,sec.section_SEQ,f.long_name,sec.SECTION,mod.long_name,sec.form_name

from sbrext.quest_contents_ext mod,
sbrext.quest_contents_ext f,
REDCAP_SECTION_NEW  sec,
MSDRDEV.REDCAP_PROTOCOL_form rf
where mod.dn_crf_idseq=f.qc_idseq-- in (select qc_idseq from sbrext.quest_contents_ext where  qtl_name='CRF' )--and long_name  )--like '%PX741401%')--rec.form_name)
and mod.DISPLAY_ORDER=sec.section_SEQ
and sec.protocol=rf.protocol
and rf.form_name=f.long_name
and mod.qtl_name='MODULE'
and f.qtl_name='CRF'
--and f.long_name ='PhenX PX070601 - Cancer Personal And Family History' 
and length(trim(mod.long_name))=length(trim(sec.SECTION))
--and NVL(mod.modified_by ,'FORMLOADER') ='FORMLOADER';

select mod.DISPLAY_ORDER,mod.long_name,f.long_name--,sec.SECTION,sec.form_name,sec.section_SEQ
from sbrext.quest_contents_ext mod,
sbrext.quest_contents_ext f,
MSDRDEV.REDCAP_PROTOCOL_form rf
where mod.dn_crf_idseq=f.qc_idseq-- in (select qc_idseq from sbrext.quest_contents_ext where  qtl_name='CRF' )--and long_name  )--like '%PX741401%')--rec.form_name)
--and mod.DISPLAY_ORDER=sec.section_SEQ
--and sec.protocol=rf.protocol
and rf.form_name=f.long_name
and mod.qtl_name='MODULE'
and f.qtl_name='CRF'
and f.long_name ='PhenX PX070601 - Cancer Personal And Family History' 
order by 1

select * from REDCAP_SECTION_NEW where protocol like'PX070601%' order by section_SEQ
select protocol,section,section_SEQ,section_Q_SEQ,Question ,form_q_num from REDCAP_PROTOCOL_TEST where protocol ='PX070601' order by Question,section_SEQ


--select 'PhenX PX070601 - Cancer Personal And Family History'
select mod.DISPLAY_ORDER,mod.long_name--,sec.section_SEQ,f.long_name,sec.SECTION
from sbrext.quest_contents_ext mod
where mod.dn_crf_idseq in(select qc_idseq from sbrext.quest_contents_ext where  qtl_name='CRF' and long_name ='PhenX PX070601 - Cancer Personal And Family History'
)
and mod.qtl_name='MODULE'

order by mod.DISPLAY_ORDER

select* from  REDCAP_PROTOCOL_test where form_name='phenx_cancer_personal_and_family_history'

SELECT distinct q.protocol, q.form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,q.SECTION
 --select*
 from REDCAP_PROTOCOL_test q
 where form_name='phenx_cancer_personal_and_family_history'
-- and SECTION_Q_SEQ=0
 
 order by SECTION_SEQ
 
 UPDATE REDCAP_PROTOCOL_test set FORM_Q_num =QUESTION-1  
 where protocol||form_name in
 --select distinct protocol||form_name from REDCAP_PROTOCOL_test  where protocol||form_name in
 (
 select protocol||form_name from(
 
 select MIN_QUEST, protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
 from(
 select  min(Question) over  (partition by protocol, form_name order by protocol, form_name ) as MIN_QUEST,
 protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
from REDCAP_PROTOCOL_test where protocol not like'%nstructions%' )--where form_name='phenx_cancer_personal_and_family_history')not like='PX070601' '%nstructions%'
where MIN_QUEST>0 and MIN_QUEST=QUESTION
)
);

UPDATE REDCAP_PROTOCOL_test set FORM_Q_num=QUESTION  where protocol||form_name in
 --select distinct protocol||form_name from REDCAP_PROTOCOL_test  where protocol||form_name in
 (
 select protocol||form_name from(
 
 select MIN_QUEST, protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
 from(
 select  min(Question) over  (partition by protocol, form_name order by protocol, form_name ) as MIN_QUEST,
 protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
from REDCAP_PROTOCOL_test where protocol not like 'Instructions%')--where form_name='phenx_cancer_personal_and_family_history')
where MIN_QUEST=0 and MIN_QUEST=QUESTION
)
);

  select protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
   from  REDCAP_PROTOCOL_test where protocol not like 'Instructions%' and FORM_Q_num is null;
   
     select protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
   from  REDCAP_PROTOCOL_test where protocol like 'Instructions%' and QUESTION >0;
   
 select MIN_QUEST, protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION from(
 select  min(Question) over  (partition by protocol, form_name order by protocol, form_name ) as MIN_QUEST,
 protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
from REDCAP_PROTOCOL_test where protocol not like 'Instructions%')--where form_name='phenx_cancer_personal_and_family_history')
where MIN_QUEST>1 and MIN_QUEST=QUESTION;


(select substr(f.long_name,1,14)  form,mod.DISPLAY_ORDER,mod.long_name--*  --trim(regexp_replace(f.long_name,'\s+', ''))form--,mod.DISPLAY_ORDER--,mod.long_name
from sbrext.quest_contents_ext mod,
sbrext.quest_contents_ext f
where mod.dn_crf_idseq=f.qc_idseq
and mod.qtl_name='MODULE'
and f.qtl_name='CRF'
and f.long_name like 'PhenX PX%' )
minus
(select substr(rf.form_name,1,14) form,sec.section_SEQ,sec.SECTION_new--trim(regexp_replace(rf.form_name,'\s+', '')) form--,sec.section_SEQ--,sec.SECTION
from
REDCAP_SECTION_NEW  sec,
MSDRDEV.REDCAP_PROTOCOL_form rf
where   sec.protocol=rf.protocol)
--and sec.SECTION is not null


select trim(regexp_replace(f.long_name,'\s+', ''))--,mod.DISPLAY_ORDER--,mod.long_name
from sbrext.quest_contents_ext mod,
sbrext.quest_contents_ext f
where mod.dn_crf_idseq=f.qc_idseq
and mod.qtl_name='MODULE'
and f.qtl_name='CRF'
and f.long_name like 'PhenX PX%' 
--and mod.long_name is null
order by 1,2

PhenX PX010101 -  Current Age
PhenX PX010101 - Current Age


UPDATE REDCAP_SECTION_NEW set SECTION_new = SECTION where section is not null;

merge into REDCAP_SECTION_NEW t1
using(select* from REDCAP_PROTOCOL_FORM)t2
on (t1.PROTOCOL = t2.PROTOCOL
and t1.protocol=t2.protocol
and section is null and SECTION_SEQ=0)
when matched then 
update set t1.SECTION_new = t2.protocol_name;


select * from 
(select substr(f.long_name,1,14)  QC_form, mod.DISPLAY_ORDER,lower(trim(regexp_replace(replace(mod.long_name,'-'),'\s+', ''))) mod_name--*  --trim(regexp_replace(f.long_name,'\s+', ''))form--,mod.DISPLAY_ORDER--,mod.long_name
from sbrext.quest_contents_ext mod,
sbrext.quest_contents_ext f
where mod.dn_crf_idseq=f.qc_idseq
and mod.qtl_name='MODULE'
and f.qtl_name='CRF'
and f.long_name like 'PhenX PX%' )QC
,
(select substr(rf.form_name,1,14) RC_form,sec.section_SEQ,lower(trim(regexp_replace(replace(sec.SECTION_new,'-'),'\s+', '')))section--trim(regexp_replace(rf.form_name,'\s+', '')) form--,sec.section_SEQ--,sec.SECTION
from
REDCAP_SECTION_NEW  sec,
MSDRDEV.REDCAP_PROTOCOL_form rf
where   sec.protocol=rf.protocol)RC
where QC_form=RC_form
and section_SEQ=DISPLAY_ORDER
and mod_name<>SECTION


select *from REDCAP_PROTOCOL_TEST  where 

protocol like '%PX510101%' 
order by question

and section is not null;


select f.long_name,mod.*--f.long_name,mod.DISPLAY_ORDER,mod.long_name
from sbrext.quest_contents_ext mod,
sbrext.quest_contents_ext f
where mod.dn_crf_idseq=f.qc_idseq
and mod.qtl_name='QUESTION'
and f.qtl_name='CRF'
and f.long_name like 'PhenX PX510101%' 
--and mod.long_name is null
order by 1,2


PX121101

select substr(f.long_name,1,14)  form,mod.long_name,mod.DISPLAY_ORDER,q.DISPLAY_ORDER,q.version,q.qc_id,q.long_name,q.created_by,q.modified_by,q.date_created,q.date_modified  --trim(regexp_replace(f.long_name,'\s+', ''))form--,mod.DISPLAY_ORDER--,mod.long_name
from sbrext.quest_contents_ext mod,
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext f
where mod.dn_crf_idseq=f.qc_idseq
and mod.qc_idseq=q.P_mod_idseq
and mod.qtl_name='MODULE'
and f.qtl_name='CRF'
and q.qtl_name='QUESTION'
and f.long_name like 'PhenX PX121301%' 
--and q.DISPLAY_ORDER>43
order by 1,3,7,4

select* from MSDRDEV.REDCAP_PROTOCOL_new where protocol like '%121101%' 

select substr(rf.form_name,1,14) form,sec.section_SEQ,Q.SECTION_Q_SEQ--trim(regexp_replace(rf.form_name,'\s+', '')) form--,sec.section_SEQ--,sec.SECTION
from
REDCAP_SECTION_NEW  sec,
MSDRDEV.REDCAP_PROTOCOL_form rf,
MSDRDEV.REDCAP_PROTOCOL_test Q
where   sec.protocol=rf.protocol
and rf.protocol=q.protocol
and sec.section_SEQ=q.section_SEQ
and (rf.form_name like 'PhenX PX121301%' )
order by 1,2,3

select* from REDCAP_PROTOCOL_new  where form_name like '%phenx_personality_traits%'field_note like'%121101%'
order by section_SEQ,SECTION_Q_SEQ

select* from REDCAP_SECTION_NEW  where protocol='PX121101'

select count(*) from(
select  form_name,DISPLAY_ORDER,q_seq_n from 
(
 
select substr(f.long_name,7,8)  form_name,mod.DISPLAY_ORDER,q.DISPLAY_ORDER q_seq_n--,q.long_name--*  --trim(regexp_replace(f.long_name,'\s+', ''))form--,mod.DISPLAY_ORDER--,mod.long_name
from sbrext.quest_contents_ext mod,
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext f
where mod.dn_crf_idseq=f.qc_idseq
and mod.qc_idseq=q.P_mod_idseq
and mod.qtl_name='MODULE'
and f.qtl_name='CRF'
and q.qtl_name='QUESTION'
and (f.long_name like 'PhenX PX%')
--and substr(f.long_name,7,8)  not in ('PX121101','PX121301','PX121401','PX121501','PX121601','PX130101','PX130201','PX130301','PX510101','PX520104','PX520201','PX520202','PX520301','PX520302')-- and f.long_name not like '%121101%')
))
group_by form_name,DISPLAY_ORDER,q_seq_n



minus
select substr(rf.form_name,7,8) form,sec.section_SEQ,Q.SECTION_Q_SEQ--trim(regexp_replace(rf.form_name,'\s+', '')) form--,sec.section_SEQ--,sec.SECTION
from
REDCAP_SECTION_NEW  sec,
MSDRDEV.REDCAP_PROTOCOL_form rf,
MSDRDEV.REDCAP_PROTOCOL_test Q
where   sec.protocol=rf.protocol
and rf.protocol=q.protocol
and sec.section_SEQ=q.section_SEQ)

order by 1,2,3

select count(*) from(
select distinct a.form_name ,DISPLAY_ORDER,Q_DISPLAY_ORDER from 
(select substr(f.long_name,7,8)  form_name,mod.DISPLAY_ORDER,q.DISPLAY_ORDER Q_DISPLAY_ORDER,q.long_name--,q.long_name--*  --trim(regexp_replace(f.long_name,'\s+', ''))form--,mod.DISPLAY_ORDER--,mod.long_name
from sbrext.quest_contents_ext mod,
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext f
where mod.dn_crf_idseq=f.qc_idseq
and mod.qc_idseq=q.P_mod_idseq
and mod.qtl_name='MODULE'
and f.qtl_name='CRF'
and q.qtl_name='QUESTION'
and instr(f.long_name,'PhenX PX')>0
)a,
(select substr(rf.form_name,7,8) form_name,sec.section_SEQ,Q.SECTION_Q_SEQ,q.question--trim(regexp_replace(rf.form_name,'\s+', '')) form--,sec.section_SEQ--,sec.SECTION
from
REDCAP_SECTION_NEW  sec,
MSDRDEV.REDCAP_PROTOCOL_form rf,
MSDRDEV.REDCAP_PROTOCOL_test Q
where   sec.protocol=rf.protocol
and rf.protocol=q.protocol
and sec.section_SEQ=q.section_SEQ) b
where a.form_name=b.form_name
and a.DISPLAY_ORDER=section_SEQ
and Q_DISPLAY_ORDER=SECTION_Q_SEQ

)


17191


16768

select distinct a.form_name ,DISPLAY_ORDER,Q_DISPLAY_ORDER,modified_by,replace(q_long_name,'greater or =','>='),QUEST_TB_QUESTION,QUESTION_CSV from 
(select substr(f.long_name,7,8)  form_name,mod.DISPLAY_ORDER,q.DISPLAY_ORDER Q_DISPLAY_ORDER,q.long_name q_long_name,q.modified_by--,q.long_name--*  --trim(regexp_replace(f.long_name,'\s+', ''))form--,mod.DISPLAY_ORDER--,mod.long_name
from sbrext.quest_contents_ext mod,
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext f
where mod.dn_crf_idseq=f.qc_idseq
and mod.qc_idseq=q.P_mod_idseq
and mod.qtl_name='MODULE'
and f.qtl_name='CRF'
and q.qtl_name='QUESTION'
and instr(f.long_name,'PhenX PX')>0
and q.modified_by='FORMLOADER'
)a,
(select substr(rf.form_name,7,8) form_name,sec.section_SEQ,Q.SECTION_Q_SEQ,q.QUEST_TB_QUESTION,QUESTION_CSV--trim(regexp_replace(rf.form_name,'\s+', '')) form--,sec.section_SEQ--,sec.SECTION
from
REDCAP_SECTION_NEW  sec,
MSDRDEV.REDCAP_PROTOCOL_form rf,
MSDRDEV.REDCAP_PROTOCOL_test Q
where   sec.protocol=rf.protocol
and rf.protocol=q.protocol
and sec.section_SEQ=q.section_SEQ) b
where a.form_name=b.form_name
and a.DISPLAY_ORDER=section_SEQ
and Q_DISPLAY_ORDER=SECTION_Q_SEQ
and instr(QUEST_TB_QUESTION,'If helium dilution method is used to measure FRC')>0
and replace(replace(replace(upper(trim(regexp_replace(QUEST_TB_QUESTION,'\s+', ''))),'-'),';'),':')<>replace(replace(replace(replace(upper(trim(regexp_replace(q_long_name,'\s+', ''))),'-',''),';'),':'),'greater or =','>=')