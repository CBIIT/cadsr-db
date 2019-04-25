sbrext.quest_contents_ext 

create table MDSR_quest_contents_ext as select* from sbrext.quest_contents_ext 
where date_created>sysdate-1;

select count(*) from MDSR_quest_contents_ext
where QTL_NAME = 'VALID_VALUE';
select count(*) from MDSR_quest_contents_ext
where QTL_NAME = 'QUESTION';

select count(*),substr(long_name,1,16)
from sbrext.quest_contents_ext f
where  
 f.QTL_NAME='CRF'
and long_name like'%PX%'
group by substr(long_name,1,16)
having COUNT(*)>1
order by 1
;

select *
from sbrext.quest_contents_ext f
where  
 f.QTL_NAME='CRF'
and long_name like'%PhenX PX020101%'
--and f.date_created<sysdate-100
--group by substr(long_name,1,16)
--having COUNT(*)>1
order by long_name
;


select long_name,form_name_new,f.preferred_definition incorrect_preferred_definition,r.preferred_definition
from sbrext.quest_contents_ext f,
REDCAP_PROTOCOL_form_751 r
where  instr(f.long_name,protocol)>0
and f.QTL_NAME='CRF'
and f.date_created<sysdate-100
--and form_name_new<> long_name 
--and trim(r.preferred_definition)<>trim(f.preferred_definition)
order by 1
;


select form_name_new,f.preferred_definition incorrect_preferred_definition,r.preferred_definition
from sbrext.MDSR_QUEST_DEV_751 f,
MSDREDCAP_FORM_CSV r
where  trim(f.long_name)=r.form_name_new
and f.QTL_NAME='CRF'
--and f.date_created>sysdate-7
--where form_name_new=form_long_name 
and trim(r.preferred_definition)<>trim(f.preferred_definition)
order by 1
;



select --f.long_name form_long_name,
v.long_name inst_name,instructions,v.preferred_definition incorrect_instruction
from sbrext.quest_contents_ext f,
sbrext.quest_contents_ext v,
MSDREDCAP_FORM_CSV r
where v.dn_crf_idseq =f.qc_idseq 
and trim(f.long_name)=r.form_name_new
and f.QTL_NAME='CRF'
and  v.QTL_NAME ='FORM_INSTR'
--and v.date_created>sysdate-7
--where form_name_new=form_long_name 
and trim(instructions)<>trim(v.preferred_definition)
;


select form_name,trim(section_new) correct_mod_name,trim(m.long_name) incorrect_mod_name--,SECTION_SEQ ,m.display_order 
--(select f.long_name form_long_name,m.long_name mod_name,v.preferred_definition,v.display_order
from sbrext.quest_contents_ext f,
sbrext.quest_contents_ext m,
MSDREDCAP_SECTION_CSV r
where m.dn_crf_idseq =f.qc_idseq 
and f.long_name =r.form_name
and f.QTL_NAME='CRF'
and  m.QTL_NAME ='MODULE'
and SECTION_SEQ=m.display_order
--and m.date_created>sysdate-11
and trim(section_new)<>trim(m.long_name) ;




select form_name_new,m.long_name mod_name,form_question correct_question,q.long_name incorrect_question,m.display_order mod_order, q.display_order 
from sbrext.quest_contents_ext f,
MDSR_REDCAP_PROTOCOL_CSV r,
sbrext.quest_contents_ext  q,
sbrext.quest_contents_ext  m,
MSDREDCAP_SECTION_CSV s
where m.dn_crf_idseq =f.qc_idseq 
and s.form_name=r.form_name_new
and r.SECTION_SEQ=s.SECTION_SEQ
and q.p_MOD_IDSEQ=m.qc_idseq
and f.long_name =r.form_name_new
and f.QTL_NAME='CRF'
and m.QTL_NAME='MODULE'
and  q.QTL_NAME ='QUESTION'
and m.display_order=s.SECTION_SEQ
and q.display_order=r.SECTION_Q_SEQ
--and q.date_created>sysdate-10
and trim(form_question)<>trim(q.long_name)
--and instr(form_question,q.long_name)=0
and f.long_name  like 'PhenX PX750201%'
order by 1,5,6;

select correct_QUEST_INST,incorrect_quest_instr truncated_INSTRUCTION,form_name, mod_name,form_question,  mod_order, Question_order

from(
select form_name_new form_name,m.long_name mod_name,form_question, trim(instructions) correct_QUEST_INST,trim(replace(replace(qi.long_name,';;',';'),'; Question in xml doesn''t contain valid CDE public id and version. Unable to validate question in xml.')) incorrect_quest_instr,m.display_order mod_order, q.display_order Question_order
from sbrext.MDSR_QUEST_DEV_751 f,
sbrext.MDSR_QUEST_DEV_751 q,
sbrext.MDSR_QUEST_DEV_751 m,
sbrext.MDSR_QUEST_DEV_751 qi,
REDCAP_PROTOCOL_751 r
where m.dn_crf_idseq =f.qc_idseq 
and q.p_MOD_IDSEQ=m.qc_idseq
and qi.p_qst_idseq =q.qc_idseq 
and f.long_name=r.form_name_new
and f.QTL_NAME='CRF'
and m.QTL_NAME='MODULE'
and q.QTL_NAME ='QUESTION'
and qi.QTL_NAME = 'QUESTION_INSTR'
and m.display_order=r.SECTION_SEQ
and q.display_order=r.SECTION_Q_SEQ
and r.INSTRUCTIONS is not null
and instr(qi.LONG_NAME,'N/A')=0
--and q.date_created>sysdate-11
)
where correct_QUEST_INST<>incorrect_quest_instr

order by 3,6,7;


select correct_QUEST_INST,incorrect_quest_instr truncated_INSTRUCTION,form_name, mod_name,form_question,  mod_order, Question_order

from(
select form_name_new form_name,m.long_name mod_name,form_question, trim(instructions) correct_QUEST_INST,trim(replace(replace(qi.long_name,';;',';'),'; Question in xml doesn''t contain valid CDE public id and version. Unable to validate question in xml.')) incorrect_quest_instr,m.display_order mod_order, q.display_order Question_order
from sbrext.quest_contents_ext f,
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext qi,
MDSR_REDCAP_PROTOCOL_CSV r
where m.dn_crf_idseq =f.qc_idseq 
and q.p_MOD_IDSEQ=m.qc_idseq
and qi.p_qst_idseq =q.qc_idseq 
and f.long_name=r.form_name_new
and f.QTL_NAME='CRF'
and m.QTL_NAME='MODULE'
and q.QTL_NAME ='QUESTION'
and qi.QTL_NAME = 'QUESTION_INSTR'
and m.display_order=r.SECTION_SEQ
and q.display_order=r.SECTION_Q_SEQ
and r.INSTRUCTIONS is not null
and instr(qi.LONG_NAME,'N/A')=0
and q.date_created>sysdate-2)
where correct_QUEST_INST<>incorrect_quest_instr
and instr(correct_QUEST_INST||'; Question in xml doesn''t contain valid CDE public id and version. Unable to validate question in xml.',incorrect_quest_instr)>0
order by 3,6,7


select form_name_new ,SECTION_SEQ,SECTION_Q_SEQ,VAL_ORDER,DISPLAY_ORDER,VAL_NAME,VAL_VALUE,long_name,form_question,question_name,mod_name--,section_new
from
(


select form_name_new,q.section_seq,q.section_q_seq,q.FORM_Q_NUM,q.QUESTION,v.QUESTION,v.VAL_NAME,v.VAL_VALUE,v.VAL_ORDER,form_question--,section_new
--select count(*)
from REDCAP_PROTOCOL_751 q,
REDCAP_VALUE_CODE_751 v

where v.form_name=q.form_name_new
--and q.SECTION_SEQ=12

and q.QUESTION = v.QUESTION
--and q.form_name_new='PhenX PX560201 - Comprehensive Hiv Risk Assessment'
)a,

(select f.long_name form_long_name,m.long_name mod_name,q.long_name question_name,m.display_order mod_order, q.display_order q_order,v.display_order,v.long_name,v.preferred_name,v.preferred_definition

--select count(*)
from sbrext.quest_contents_ext f,
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext v
where f.qc_idseq =m.dn_crf_idseq 
  and m.qc_idseq=q.p_MOD_IDSEQ
 and  q.qc_idseq= v.p_qst_idseq
and f.QTL_NAME='CRF'
and m.QTL_NAME='MODULE'
and q.QTL_NAME ='QUESTION'
and v.QTL_NAME = 'VALID_VALUE'
--and v.display_order=0
--and trim(f.long_name) ='PhenX PX560201 - Comprehensive Hiv Risk Assessment'

--and m.display_order=12

and q.date_created>sysdate-7)b

where a.form_name_new=b.form_long_name
and b.mod_order=a.SECTION_SEQ
and b.q_order=a.SECTION_Q_SEQ
and b.display_order-1=a.VAL_ORDER
and trim(long_name)=trim(val_name)
order by 1,3,5,6




select  *--max(DATE_CREATED) 
from sbrext.quest_contents_ext v
where  v.QTL_NAME Like 'VALID_VALUE%'
and v.display_order=0
and created_BY='FORMLOADER'
and DATE_CREATED>sysdate-90
