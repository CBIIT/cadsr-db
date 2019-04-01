 UPDATE REDCAP_PROTOCOL_test set FORM_Q_num=QUESTION-1  where protocol||form_name in
 --select distinct protocol||form_name from REDCAP_PROTOCOL_751  where protocol||form_name in
 (
 select protocol||form_name from(
 
 select MIN_QUEST, protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
 from(
 select  min(Question) over  (partition by protocol, form_name order by protocol, form_name ) as MIN_QUEST,
 protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
from REDCAP_PROTOCOL_751)--where form_name='phenx_cancer_personal_and_family_history')
where MIN_QUEST>0 and MIN_QUEST=QUESTION
)
);

UPDATE REDCAP_PROTOCOL_751 set FORM_Q_num=QUESTION where protocol||form_name in
 --select distinct protocol||form_name,form_NAME_NEW from REDCAP_PROTOCOL_751  where protocol||form_name in
 (
 select protocol||form_name from(
 
 select MIN_QUEST, protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
 from(
 select  min(Question) over  (partition by protocol, form_name order by protocol, form_name ) as MIN_QUEST,
 protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
from REDCAP_PROTOCOL_751 where protocol not like 'Instructions%')--where form_name='phenx_cancer_personal_and_family_history')
where MIN_QUEST=0 and MIN_QUEST=QUESTION
)
);


exec MSDRDEV.redCapSaction_populate3 ;
exec MSDRDEV.redCapSact_Quest_populate3;


select distinct protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION from REDCAP_PROTOCOL_751

where section is not null and section like '%phenx_%'
and FORM_Q_num>0--and section=form_name
order by protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ


update REDCAP_PROTOCOL_751 set SECTION_SEQ=null,SECTION_Q_SEQ=null,SECTION=null
--select* from REDCAP_PROTOCOL_751
where protocol='PX090602'   --and section is not null and section=form_name 
--and FORM_Q_num>0
order by protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ