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
 distinct  f.protocol--, form_name_new--,PREFERRED_DEFINITION,p.long_name
 from REDCAP_PROTOCOL_751 f,
 --select*from 
 SBREXT.PROTOCOLS_EXT p
 where --preferred_name like'PX%' and
 f.protocol=preferred_name(+)
 and preferred_name is null
 order by 1
 
 CREATE TABLE REDCAP_VALUE_CODE_751
( PROTOCOL             VARCHAR2(50)  ,
  FORM_NAME   VARCHAR2(255)  ,
  QUESTION            NUMBER,
  VAL_NAME        VARCHAR2(500 )     ,
  VAL_VALUE            VARCHAR2(500),
  VAL_ORDER NUMBER   , 
  ELM_ORDER  VARCHAR2(50)  ,
  PIPE_NUM NUMBER);
  
  create view REDCAP_VALUE_VW751 as
select distinct p.protocol PROTOCOL FROM REDCAP_PROTOCOL_751 p
left outer join REDCAP_VALUE_CODE_751 s
on p.protocol=s.protocol
where  s.protocol is null;

select* from REDCAP_VALUE_VW751;
INSERT INTO  SBREXT.REDCAP_VALUE_CODE_751
( PROTOCOL             ,
FORM_NAME ,
  QUESTION           ,
  VAL_name           ,
  VAL_VALUE            ,
  VAL_ORDER,
  PIPE_NUM,
  ELM_ORDER)
  select 
  PROTOCOL,
  FORM_NAME ,
  question,
  substr(CHOICES,1,instr(CHOICES,',')-1) ,--VAL_NAME substring CHOICES before first ',' and ||
  substr(CHOICES,instr(CHOICES,',')+1),--VAL_NAME substring CHOICES after first ',' and  before||
  ELM_ORDER-1,
  PIPE_NUM, --Pipe position in string CHOICES
  CHOICES ---substring CHOICES before || 
--  select*
 from 
(select distinct
  PROTOCOL,FORM_NAME,question  ,
  trim(dbms_lob.substr(CHOICES, '[^|]+', 1, levels.column_value))  as CHOICES, dbms_lob.instr(CHOICES,'[^|]+', 1, levels.column_value) AS PIPE_NUM,levels.column_value ELM_ORDER
from 
  (select p.*from REDCAP_PROTOCOL_751 p,
 REDCAP_VALUE_VW751 s
  where p.protocol=s.protocol
   and choices is not null) t,
  table(cast(multiset(select level from dual connect by  level <= length (regexp_replace(t.CHOICES, '[^|]+'))  + 1) as sys.OdciNumberList)) levels
)
order by 1,2,3,ELM_ORDER ;

select distinct
  PROTOCOL,FORM_NAME,question  ,
  trim(dbms_lob.substr(CHOICES, '[^|]+', 1, levels.column_value))  as CHOICES--, dbms_lob.instr(CHOICES,'[^|]+', 1, levels.column_value) AS PIPE_NUM,levels.column_value ELM_ORDER
from 
  REDCAP_PROTOCOL_751
 where  choices is not null;
 select CHOICES,
 substr(CHOICES,1,instr(CHOICES,',')-1) ,--VAL_NAME substring CHOICES before first ',' and ||
  substr(CHOICES,instr(CHOICES,',')+1)
 ,val_level,question,
  protocol
 from(
 select 
    cast(trim(
    regexp_substr(t.CHOICES, '[^|]+', 1, levels.column_value)
  )  as varchar2(500)) as  CHOICES,levels.column_value  val_level,question,
  protocol,dbms_lob.instr(CHOICES,'[^|]+', 1, levels.column_value) AS PIPE_NUM
from  (select choices,protocol,question from REDCAP_PROTOCOL_751 where dbms_lob.getlength(choices) >0)t,
      table(cast(multiset(
        select level from dual 
        connect by level <= length (regexp_replace(t.CHOICES, '[^|]+')) + 1
      ) as sys.OdciNumberList)) levels)
      order by 6,5,4;
      
      select*
      from REDCAP_PROTOCOL_751 
 where dbms_lob.getlength(choices) >0
 --and dbms_lob.instr(CHOICES,'[^|]+')=0
 and FIELD_TYPE like'%calc%';
 
 
 UPDATE SBREXT.REDCAP_PROTOCOL_NEW set choices=substr(choices,2)
 where choices is not null and substr(choices,1,1)='|'
 
 
  select protocol,CHOICES
  from REDCAP_PROTOCOL_751 
 where dbms_lob.getlength(choices) >0
and dbms_lob.instr(CHOICES,'|')=0
 and REGEXP_COUNT(choices,',')=1
 and FIELD_TYPE like'%calc%';
 
 
 
  INSERT INTO SBREXT.REDCAP_VALUE_CODE
 ( PROTOCOL ,
 FORM_NAME ,
 QUESTION ,
 VAL_name ,
 VAL_VALUE ,
 VAL_ORDER,
 PIPE_NUM,
 ELM_ORDER,
 VAL_VAL_NAME)
 )
 INSERT INTO REDCAP_VALUE_CODE_751
 ( PROTOCOL ,
 FORM_NAME ,
 QUESTION ,
 VAL_name ,
 VAL_VALUE ,
 VAL_ORDER,
 PIPE_NUM,
 ELM_ORDER,
 VAL_VAL_NAME)
 select 
 PROTOCOL,
 FORM_NAME , 
 question, 
 CASE WHEN trim(choices)='99,99,9999 , unknown'
 THEN '99,99,9999'
 ELSE substr(choices,1,(instr(choices,',')-1))
 END,
 CASE WHEN trim(choices)='99,99,9999 , unknown'
 THEN 'unknown'
 ELSE substr(choices,(instr(choices,',')+1))
 END,
 0,
 0,
 0,
 choices
 from
 (select 
 PROTOCOL,
 FORM_NAME ,
 question, 
 cast(trim(CHOICES )  as varchar2(320)) as CHOICES
 from  REDCAP_PROTOCOL_751
  where dbms_lob.getlength(choices) >0
and dbms_lob.instr(CHOICES,'|')=0 
)
order by 1,3
;

 INSERT INTO SBREXT.REDCAP_VALUE_CODE
 ( PROTOCOL ,
 FORM_NAME ,
 QUESTION ,
 VAL_name ,
 VAL_VALUE ,
 VAL_ORDER,
 PIPE_NUM,
 ELM_ORDER,
 VAL_VAL_NAME)

 select 
 PROTOCOL,
 FORM_NAME ,
 question,
 substr(choices,1,(instr(choices,',')-1)) ,
 substr(choices,(instr(choices,',')+1)),
 0,
 0,
 0,
 choices 
 select*
 from REDCAP_PROTOCOL_751 
 where dbms_lob.getlength(choices) >0
and dbms_lob.instr(CHOICES,'|')=0 
 and REGEXP_COUNT(choices,',')=1;
 
 
 select* from REDCAP_VALUE_CODE_751 order by 1,3;
 
 
 INSERT INTO  REDCAP_VALUE_CODE_751
( PROTOCOL             ,
FORM_NAME ,
  QUESTION           ,
  VAL_name           ,
  VAL_VALUE            ,
  VAL_ORDER,
  PIPE_NUM,
  ELM_ORDER,
  VAL_VAL_NAME)
  select 
  PROTOCOL,
  FORM_NAME ,
  question,
  substr(CHOICES,1,instr(CHOICES,',')-1) ,--VAL_NAME substring CHOICES before first ',' and ||
  substr(CHOICES,instr(CHOICES,',')+1),--VAL_NAME substring CHOICES after first ',' and  before||
  ELM_ORDER-1,
  PIPE_NUM, --Pipe position in string CHOICES
  ELM_ORDER,
  CHOICES ---substring CHOICES before || 
 from(
 select 
    cast(trim(regexp_substr(t.CHOICES, '[^|]+', 1, levels.column_value)  )  as varchar2(500)) as  CHOICES,levels.column_value  ELM_ORDER, FORM_NAME ,question,
  protocol,dbms_lob.instr(CHOICES,'[^|]+', 1, levels.column_value) AS PIPE_NUM
           from  (select  FORM_NAME_NEW FORM_NAME ,choices,protocol,question from REDCAP_PROTOCOL_751 
           where dbms_lob.getlength(choices) >0)t,
      table(cast(multiset(
        select level from dual 
        connect by level <= length (regexp_replace(t.CHOICES, '[^|]+')) + 1
      ) as sys.OdciNumberList)) levels)
      order by 1,3,6;
      
      
      
      
select count(*) cnt,PROTOCOL  ,FORM_NAME ,QUESTION ,VAL_name ,VAL_VALUE ,  VAL_ORDER
from
REDCAP_VALUE_CODE_751
GROUP by PROTOCOL  ,FORM_NAME ,QUESTION ,VAL_name ,VAL_VALUE ,  VAL_ORDER
having count(*)>1
order by 2,4,7;

select* from REDCAP_VALUE_CODE_751 where val_name is null and val_value is null
delete from SBREXT.REDCAP_VALUE_CODE where val_name is null and val_value is null


select p.protocol,p.question,p.val_val_name ,p.val_order , v.val_order,v.val_val_name
from
(
select p.protocol,p.question,p.choices,val_val_name,val_order from 
REDCAP_PROTOCOL_751 p,
REDCAP_VALUE_CODE_751 v 
where p.protocol=v.protocol
and p.question=v.question and 
val_name is null and val_value is null) v,
REDCAP_VALUE_CODE_751 p
where 
p.protocol=v.protocol
and p.question=v.question
and p.val_val_name is not null
--and p.val_order=v.val_order
order by 1,2,4,5


delete from REDCAP_VALUE_CODE_751 where val_name is null and val_value is null


select p.protocol,p.question,p.choices,val_val_name,val_order from 
REDCAP_PROTOCOL_751 p,
REDCAP_VALUE_CODE_751 v 
where p.protocol=v.protocol(+)
and p.question=v.question(+)
and V.protocol is null
and v.question is null
and   dbms_lob.getlength(choices) >0



select distinct question,protocol from  REDCAP_PROTOCOL_751 where dbms_lob.getlength(choices) >0
minus
select distinct question,protocol from  REDCAP_VALUE_CODE_751 


select distinct protocol--,question--,length(val_val_name),val_val_name
from 

REDCAP_VALUE_CODE_751 v 
--group_by protocol,question
where length(val_val_name)>250
order by 1,2