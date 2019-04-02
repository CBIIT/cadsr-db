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


update REDCAP_PROTOCOL_751 set choices='1 , YES|0 , NO'
--select * from REDCAP_PROTOCOL_751
where FIELD_TYPE like'%yes%'

UPDATE REDCAP_PROTOCOL_751 set 
VAL_MIN=DECODE(TEXT_VALID_MIN,NULL,NULL,'minLength='||TEXT_VALID_MIN||';'),
VAL_MAX=DECODE(TEXT_VALID_MAX,NULL,NULL,'maxLength='||TEXT_VALID_MAX||';'),
VAL_TYPE=DECODE(TEXT_VALID_TYPE,NULL,NULL,'datatype='||TEXT_VALID_TYPE||';')
--,LOGIC=DECODE(LOGIC,NULL,NULL,LOGIC||';')
--select count(*) from REDCAP_PROTOCOL_751
where (TEXT_VALID_MIN is not null or TEXT_VALID_MAX is not null or TEXT_VALID_TYPE is not null) and 
--choices is not null;

dbms_lob.getlength(choices) = 0;

UPDATE REDCAP_PROTOCOL_751 set 
INSTRUCTIONS=VAL_TYPE||VAL_MIN||VAL_MAX||LOGIC
where (TEXT_VALID_MIN is not null or TEXT_VALID_MAX is not null or TEXT_VALID_TYPE is not null
or logic is not null) and FIELD_TYPE<>'calc';

UPDATE REDCAP_PROTOCOL_751 set 
INSTRUCTIONS='Calculation ;'||VAL_TYPE||VAL_MIN||VAL_MAX||LOGIC
where FIELD_TYPE='calc';

select count(*)
 from REDCAP_PROTOCOL_751 q
 where SECTION_Q_SEQ is null
 and SECTION is  null
 and SECTION_SEQ is null

UPDATE REDCAP_PROTOCOL_751 SET SECTION_SEQ=0 , SECTION_Q_SEQ=FORM_Q_NUM
 WHERE SECTION_SEQ is null and SECTION_Q_SEQ is null  and SECTION is null and protocol not like 'Instructions%';


CREATE TABLE MSDRDEV.REDCAP_SECTION_751
(
  PROTOCOL       VARCHAR2(40 BYTE),
  FORM_NAME      VARCHAR2(400 BYTE),
  SECTION_SEQ    NUMBER,
  SECTION_Q_SEQ  NUMBER,
  QUESTION       NUMBER,
  SECTION        VARCHAR2(2000 BYTE),
  SECTION_NEW    VARCHAR2(2000 BYTE),
  INSTRUCTION    VARCHAR2(2000 BYTE)
)

CREATE TABLE MSDRDEV.REDCAP_SECTION_751
(
  PROTOCOL       VARCHAR2(40 BYTE),
  FORM_NAME      VARCHAR2(400 BYTE),
  SECTION_SEQ    NUMBER,
  SECTION_Q_SEQ  NUMBER,
  QUESTION       NUMBER,
  SECTION        VARCHAR2(2000 BYTE),
  SECTION_NEW    VARCHAR2(2000 BYTE),
  INSTRUCTION    VARCHAR2(2000 BYTE)
)

delete from REDCAP_SECTION_751
 INSERT INTO REDCAP_SECTION_751
( PROTOCOL ,
 FORM_NAME ,
 SECTION_SEQ,
 SECTION_Q_SEQ,
 QUESTION ,
SECTION,
SECTION_NEW )
 SELECT 
 distinct q.protocol, q.form_name_new,SECTION_SEQ,SECTION_Q_SEQ,FORM_Q_NUM,q.SECTION,
 case
 when q.SECTION is NULL or q.SECTION like '%phenx_%' then substr(q.form_name_new,18) 
   when q.SECTION is not NULL and q.SECTION not like '%phenx_%' then q.SECTION
   end
 --select*
 from REDCAP_PROTOCOL_751 q
 where SECTION_Q_SEQ=0 ;
 and SECTION is not null
 
  SELECT  * from
 REDCAP_SECTION_751
 where SECTION like '%phenx_%'
 
 CREATE TABLE MSDRDEV.REDCAP_PROTOCOL_FORM_751
(
  PROTOCOL              VARCHAR2(40 BYTE),
  FORM_NAME             VARCHAR2(449 BYTE),
  PREFERRED_DEFINITION  VARCHAR2(2000 BYTE)     NOT NULL,
  PROTOCOL_NAME         VARCHAR2(500 BYTE),
  INSTRUCTION           VARCHAR2(2000 BYTE)
)

INSERT INTO REDCAP_PROTOCOL_FORM_751
( PROTOCOL ,
 FORM_NAME  )
 SELECT 
 distinct  f.protocol, form_name_new,PREFERRED_DEFINITION,p.long_name
 from REDCAP_PROTOCOL_751 f,
 --select*from 
 SBREXT.PROTOCOLS_EXT p
 where preferred_name like'PX%'
 and f.protocol=preferred_name