delete from REDCAPPROTOCOL_TEMP1 where Form_Name='Form Name' or Form_Name is  null;
 drop table REDCAPPROTOCOL_TEMP1;
select count(*) from REDCAPPROTOCOL_TEMP1 where Form_Name<>'Form Name' and Form_Name is not null;

delete from  REDCAP_PROTOCOL_751;

select count(*) from  REDCAP_PROTOCOL_751;
insert into REDCAP_PROTOCOL_751
(
  VARIABLE_FIELD_NAME ,
  FORM_NAME            ,
  SECTION              , 
  FIELD_TYPE          ,  
  FIELD_LABEL,
  QUESTION_CSV ,
  CHOICES             ,
  FIELD_NOTE          ,
  QUESTION           ,
  TEXT_VALID_TYPE     ,
  IDENTIFIER          ,
  LOGIC               ,
  REQUIRED            ,
  CUSTOM_ALIGNMENT     ,
  MATRIX_GROUP_NAME   , 
  PROTOCOL ,
  TEXT_VALID_MIN,
  TEXT_VALID_MAX ,   
  MATRIX_RANK         
)
select 
VARIABLE_FIELD_NAME ,
  FORM_NAME            ,
  SECTION              ,
  FIELD_TYPE          ,
  substr(FIELD_LABEL, 1, 2100 ) ,
  FIELD_LABEL         ,    
  CHOICES             ,
  FIELD_NOTE          ,
  QUESTION           ,
  TEXT_VALID_TYPE     ,
  IDENTIFIER          ,
  TRIM(LOGIC) ,
  REQUIRED            ,
  CUSTOM_ALIGNMENT     ,
  MATRIX_GROUP_NAME   ,
  'PX'||SUBSTR(TRIM(FIELD_NOTE),-6)  ,
  TEXT_VALID_MIN,
  TEXT_VALID_MAX ,   
  MATRIX_RANK
from REDCAPPROTOCOL_TEMP1

  update REDCAP_PROTOCOL_751 set field_label=replace (VARIABLE_FIELD_NAME,'_',' '), QUESTION_CSV =replace (VARIABLE_FIELD_NAME,'_',' ') 
  where field_label is null or field_label like '%???%'

merge into REDCAP_PROTOCOL_751 t1
using (select min(question)question,PROTOCOL
from REDCAP_PROTOCOL_751 group by PROTOCOL ) t2
on (t1.PROTOCOL = t2.PROTOCOL)
when matched then 
update set t1.question = t1.question-t2.question;


 update REDCAP_PROTOCOL_751 set FORM_QUESTION =
 CASE 
 when length(FIELD_LABEL||VARIABLE_FIELD_NAME)>1997 then  substr(FIELD_LABEL,1,(1986-length(VARIABLE_FIELD_NAME)))||'..TRUNCATED ('||VARIABLE_FIELD_NAME||')'
 else 
 FIELD_LABEL||' ('||VARIABLE_FIELD_NAME||')'
 end,
  QUEST_TB_QUESTION =CASE 
 when length(QUESTION_CSV||VARIABLE_FIELD_NAME)>3997 
 then substr(QUESTION_CSV,1,(3986-length(VARIABLE_FIELD_NAME)))||'..TRUNCATED ('||VARIABLE_FIELD_NAME||')'
 else 
 QUESTION_CSV||' ('||VARIABLE_FIELD_NAME||')'
 end;
 
select FORM_QUESTION,QUEST_TB_QUESTION,QUESTION ,protocol from   REDCAP_PROTOCOL_751
where  length(QUESTION_CSV||VARIABLE_FIELD_NAME)<40
order by 4,3

update  REDCAP_PROTOCOL_751 set FIELD_LABEL=substr(QUESTION_CSV ,1,3990)||'TRUNCATED'  where length(QUESTION_CSV )>4000;

merge into REDCAP_PROTOCOL_751 t1
using (select min(question)question,PROTOCOL
from REDCAP_PROTOCOL_751 group by PROTOCOL ) t2
on (t1.PROTOCOL = t2.PROTOCOL)
when matched then 
update set t1.question = t1.question-t2.question

select * from REDCAP_PROTOCOL_751 where question=0 order by protocol,question


