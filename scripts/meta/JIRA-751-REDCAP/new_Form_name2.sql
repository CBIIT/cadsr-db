
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


select distinct FORM_NAME ,FORM_NAME_NEW  from REDCAP_PROTOCOL_751
where lower(FORM_NAME) like '%phenx_%'


 UPDATE REDCAP_PROTOCOL_test set FORM_NAME_NEW=
 CASE 
 WHEN INSTR(substr(FORM_NAME,7),'-_')=0 then substr(FORM_NAME,7)
 WHEN INSTR(substr(FORM_NAME,7),'-_')=1 then substr(FORM_NAME,8)
 end
 
 select distinct FORM_NAME,CASE WHEN INSTR(substr(FORM_NAME,7),'-')=0 then 'PhenX '||protocol||' - '||INITCAP(replace(substr(trim(FORM_NAME),7),'_',' '))
 WHEN INSTR(substr(FORM_NAME,7),'-')=1 then 'PhenX '||protocol||' - '||INITCAP(trim(replace(substr(FORM_NAME,8),'_',' ')))
 end 
 from REDCAP_PROTOCOL_751
where lower(FORM_NAME) like '%phenx_%'


 UPDATE REDCAP_PROTOCOL_751 set FORM_NAME_NEW=
 CASE WHEN INSTR(substr(FORM_NAME,7),'-')=0 then 'PhenX '||protocol||' - '||INITCAP(replace(substr(trim(FORM_NAME),7),'_',' '))
 WHEN INSTR(substr(FORM_NAME,7),'-')=1 then 'PhenX '||protocol||' - '||INITCAP(trim(replace(substr(FORM_NAME,8),'_',' ')))
 end  
 where lower(FORM_NAME) like '%phenx_%'