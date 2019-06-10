/*exec SBREXT.MDSR_RECAP_INSERT_CSV;
exec SBREXT.MDSR_RECAP_UPDATE_CSV;
exec SBREXT.MDSR_RECAP_UPDATE_CSV2;
exec MDSRedCapSaction_populate ;
exec MSDRedCapSact_Quest_populate;
exec MDSRedCapSaction_Insert;
exec MDSRedCapForm_Insert */




/*******************************SP**********************************/
/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PROCEDURE MDSR_RECAP_INSERT_CSV as

 l_FORM_name      VARCHAR2 (100):='NA';
   l_where       VARCHAR2 (1000);
   l_SQL         CLOB:=null;
   l_update       VARCHAR2 (4000);
   l_qtl        VARCHAR2 (3):='CRF';
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
   v_ctn number;
   formatme CLOB;
   formatstr CLOB ;
BEGIN

delete from REDCAPPROTOCOL_TEMP where Form_Name='Form Name' or Form_Name is  null;
commit;
insert into MDSR_REDCAP_PROTOCOL_CSV
 (
 VARIABLE_FIELD_NAME ,
 FORM_NAME ,
 SECTION , 
 FIELD_TYPE ,
 FIELD_LABEL ,
 CHOICES ,
 FIELD_NOTE ,
 QUESTION ,
 TEXT_VALID_TYPE ,
 TEXT_VALID_MIN ,
 TEXT_VALID_MAX ,
 IDENTIFIER ,
 LOGIC ,
 REQUIRED ,
 CUSTOM_ALIGNMENT ,
 MATRIX_GROUP_NAME , 
 MATRIX_RANK ,
 PROTOCOL ,
 Q_NMB_SERV ,
 QUESTION_CSV 
)
select 
VARIABLE_FIELD_NAME ,
 FORM_NAME ,
 SECTION ,
 FIELD_TYPE ,
 substr(FIELD_LABEL, 1, 2000 ) ,
 CHOICES ,
 FIELD_NOTE ,
 TRIM(QUESTION) ,
 TEXT_VALID_TYPE ,
 TEXT_VALID_MIN ,
 TEXT_VALID_MAX ,
 IDENTIFIER ,
 TRIM(LOGIC) ,
 REQUIRED ,
 CUSTOM_ALIGNMENT ,
 MATRIX_GROUP_NAME ,
 MATRIX_RANK ,
 'PX'||SUBSTR(TRIM(FIELD_NOTE),-6) , 
 Q_NMB_SERV ,
 substr(FIELD_LABEL, 1, 4000 ) 
from REDCAPPROTOCOL_TEMP;

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values('MDSR_RECAP_INSERT_CSV','', errmsg ,SYSDATE);
     commit;
     END;
  

/

CREATE OR REPLACE PROCEDURE MDSR_RECAP_UPDATE_CSV as

 l_FORM_name      VARCHAR2 (100):='NA';
   l_where       VARCHAR2 (1000);
   l_SQL         CLOB:=null;
   l_update       VARCHAR2 (4000);
   l_qtl        VARCHAR2 (3):='CRF';
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
   v_ctn number;
   formatme CLOB;
   formatstr CLOB ;
BEGIN
update MDSR_REDCAP_PROTOCOL_CSV set field_label=replace (VARIABLE_FIELD_NAME,'_',' '), QUESTION_CSV =replace (VARIABLE_FIELD_NAME,'_',' ') 
  where field_label is null or field_label like '%???%';

     
  commit;
  update MDSR_REDCAP_PROTOCOL_CSV set FORM_QUESTION =
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
 commit;
 
 UPDATE MDSR_REDCAP_PROTOCOL_CSV set FORM_NAME_NEW=
 CASE WHEN INSTR(substr(FORM_NAME,7),'-')=0 then 'PhenX '||protocol||' - '||INITCAP(replace(substr(trim(FORM_NAME),7),'_',' '))
 WHEN INSTR(substr(FORM_NAME,7),'-')=1 then 'PhenX '||protocol||' - '||INITCAP(trim(replace(substr(FORM_NAME,8),'_',' ')))
 end  
 where lower(FORM_NAME) like '%phenx_%';
  commit;
 --8.b 
 update SBREXT.MDSR_REDCAP_PROTOCOL_CSV set choices='1 , YES|0 , NO'
  where FIELD_TYPE like'%yesno%';
  commit;
--8.c
UPDATE MDSR_REDCAP_PROTOCOL_CSV set 
VAL_MIN=DECODE(TEXT_VALID_MIN,NULL,NULL,'minLength='||TEXT_VALID_MIN||';'),
VAL_MAX=DECODE(TEXT_VALID_MAX,NULL,NULL,'maxLength='||TEXT_VALID_MAX||';'),
VAL_TYPE=DECODE(TEXT_VALID_TYPE,NULL,NULL,'datatype='||TEXT_VALID_TYPE||';')
where (TEXT_VALID_MIN is not null or TEXT_VALID_MAX is not null or TEXT_VALID_TYPE is not null
) and 
dbms_lob.getlength(choices) = 0;
 commit;
--8.d
UPDATE MDSR_REDCAP_PROTOCOL_CSV set 
INSTRUCTIONS=VAL_TYPE||VAL_MIN||VAL_MAX||LOGIC
where (TEXT_VALID_MIN is not null or TEXT_VALID_MAX is not null or TEXT_VALID_TYPE is not null
or logic is not null) and FIELD_TYPE<>'calc';
 commit;

UPDATE MDSR_REDCAP_PROTOCOL_CSV set 
INSTRUCTIONS='Calculation ;'||VAL_TYPE||VAL_MIN||VAL_MAX||LOGIC
where FIELD_TYPE='calc';
commit;

  UPDATE MDSR_REDCAP_PROTOCOL_CSV set instructions=substr(instructions,1,length(instructions)-1) 
 where SUBSTR(instructions, -1, 1)=';' ;
 
 commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values('MDSR_RECAP_UPDATE_CSV','', errmsg ,SYSDATE);
     commit;
     END;
/
/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PROCEDURE MDSR_RECAP_UPDATE_CSV2 as

 l_FORM_name      VARCHAR2 (100):='NA';
   l_where       VARCHAR2 (1000);
   l_SQL         CLOB:=null;
   l_update       VARCHAR2 (4000);
   l_qtl        VARCHAR2 (3):='CRF';
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
   v_ctn number;
   formatme CLOB;
   formatstr CLOB ;
BEGIN
--Update column QUESTION in table REDCAP_PROTOCOL_751 for each protocol starting from 0

merge into MDSR_REDCAP_PROTOCOL_CSV t1
using (select min(question)question,PROTOCOL
from MDSR_REDCAP_PROTOCOL_CSV group by PROTOCOL ) t2
on (t1.PROTOCOL = t2.PROTOCOL)
when matched then 
update set t1.question = t1.question-t2.question;

     
  commit;
--10.Populate sections in REDCAP_PROTOCOL_CSV:
--10.1. Find min Question Number for protocol which is >0 and set it to 0.

 UPDATE MDSR_REDCAP_PROTOCOL_CSV set FORM_Q_num=QUESTION-1  where protocol||form_name in
 --select distinct protocol||form_name from REDCAP_PROTOCOL_751  where protocol||form_name in
 (
 select protocol||form_name from(
 
 select MIN_QUEST, protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
 from(
 select  min(Question) over  (partition by protocol, form_name order by protocol, form_name ) as MIN_QUEST,
 protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
from MDSR_REDCAP_PROTOCOL_CSV)--where form_name='phenx_cancer_personal_and_family_history')
where MIN_QUEST>0 and MIN_QUEST=QUESTION
)
);
commit;
UPDATE MDSR_REDCAP_PROTOCOL_CSV set FORM_Q_num=QUESTION where protocol||form_name in
 --select distinct protocol||form_name,form_NAME_NEW from REDCAP_PROTOCOL_CSV where protocol||form_name in
 (
 select protocol||form_name from(
 
 select MIN_QUEST, protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
 from(
 select  min(Question) over  (partition by protocol, form_name order by protocol, form_name ) as MIN_QUEST,
 protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
from MDSR_REDCAP_PROTOCOL_CSV where protocol not like 'Instructions%')
where MIN_QUEST=0 and MIN_QUEST=QUESTION
)
);
commit;

    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values('MDSR_RECAP_UPDATE_CSV','', errmsg ,SYSDATE);
     commit;
     END;
  

/
----section----
CREATE OR REPLACE PROCEDURE MDSRedCapSaction_populate 
AS

    CURSOR CUR_RC IS select protocol,FORM_NAME,FORM_Q_NUM,SECTION, SECTION_SEQ ,SECTION_Q_SEQ
    FROM MDSR_REDCAP_PROTOCOL_CSV 
    where SECTION is not NULL
    and SECTION_SEQ is  null
    and FORM_Q_num is not null
    order by protocol,FORM_NAME,FORM_Q_num; 
     
 errmsg VARCHAR2(2000):='';
 V_sec_N number;
 V_sec_QN number;
 V_pr_SEC_N number;
 V_MIN_SEC_Q number;
 
BEGIN
for i in CUR_RC loop
BEGIN
 IF i.FORM_Q_num=0 then 
 V_sec_N :=0; 
 V_sec_QN:=0;
 ELSE
 SELECT min(FORM_Q_num) into V_MIN_SEC_Q 
 from MDSR_REDCAP_PROTOCOL_CSV
 where SECTION is not NULL
 and protocol=i.protocol
 and FORM_NAME=i.FORM_NAME;
 
 IF V_MIN_SEC_Q=i.FORM_Q_num THEN
 
 V_sec_N :=1;
 ELSE
 
 V_sec_N :=V_sec_N+1;
 END IF;
 END IF;
 
 UPDATE MDSR_REDCAP_PROTOCOL_CSV  SET SECTION_SEQ=V_sec_N , SECTION_Q_SEQ=0
 WHERE protocol=i.protocol
 and FORM_NAME=i.FORM_NAME
 and FORM_Q_num =i.FORM_Q_num
 and SECTION=i.SECTION
 and SECTION_SEQ is null;
 
 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg3 - '||errmsg);
  insert into REPORTS_ERROR_LOG VALUES (i.FORM_Q_NUM||','||i.protocol,  errmsg, sysdate);
  commit;
 end; 
 end loop;

commit;

END ;
/
CREATE OR REPLACE PROCEDURE MSDRedCapSact_Quest_populate
AS

    CURSOR CUR_RC IS select protocol,FORM_NAME,FORM_Q_NUM,SECTION, SECTION_SEQ ,SECTION_Q_SEQ
    FROM MDSR_REDCAP_PROTOCOL_CSV
    where SECTION_SEQ is not null
    and SECTION_Q_SEQ=0
    and SECTION is not NULL
    and FORM_Q_NUM is not null   
    order by protocol,FORM_NAME,FORM_Q_NUM;
    
    errmsg VARCHAR2(2000):='';
    V_sec_NC number;
    V_sec_QN number;
    V_sec_NEXT number;
    V_sec_MAX number;
    V_sec_QN number;
    V_QC_NC number;
    V_QC_NCEXT number;
    

  BEGIN
   for i in CUR_RC loop
   
     BEGIN
            V_sec_NC:=i.SECTION_SEQ;
            V_QC_NC:=i.FORM_Q_NUM;
            
            select MAX(SECTION_SEQ) into V_sec_MAX
            FROM MDSR_REDCAP_PROTOCOL_CSV
            where  protocol=i.protocol
            and FORM_NAME=i.FORM_NAME
            ; 
            dbms_output.put_line('V_sec_MAX - '||V_sec_MAX||' V_sec_NC -'||i.SECTION_SEQ);
            
            IF V_sec_MAX> i.SECTION_SEQ THEN
            
            --find next section number and seq number in form
            select SECTION_SEQ,FORM_Q_NUM into V_sec_NEXT,V_QC_NCEXT
            FROM MDSR_REDCAP_PROTOCOL_CSV
            where  protocol=i.protocol
            and FORM_NAME=i.FORM_NAME
            and SECTION is not NULL
            and SECTION_SEQ =i.SECTION_SEQ+1;
            END IF;
          


 
            DECLARE
            CURSOR C_nosec IS select protocol,FORM_NAME,FORM_Q_NUM,SECTION, SECTION_SEQ ,SECTION_Q_SEQ
            FROM MDSR_REDCAP_PROTOCOL_CSV
            where  protocol=i.protocol
            and FORM_NAME=i.FORM_NAME
            and SECTION is NULL
            and ((FORM_Q_NUM >V_QC_NC and FORM_Q_NUM <V_QC_NCEXT and V_sec_MAX>V_sec_NC) 
            or  (FORM_Q_NUM >V_QC_NC and V_sec_MAX=V_sec_NC))
            order by FORM_Q_NUM;


            BEGIN 
                for r in C_nosec loop
                    BEGIN 
                    UPDATE MDSR_REDCAP_PROTOCOL_CSV SET SECTION_SEQ=V_sec_NC, SECTION_Q_SEQ=r.FORM_Q_NUM-V_QC_NC
                    WHERE protocol=r.protocol
                    and FORM_NAME=r.FORM_NAME
                    and FORM_Q_NUM =r.FORM_Q_NUM 
                    and SECTION_SEQ is null
                    and SECTION_Q_SEQ is null;

                    --dbms_output.put_line('output2 - V_sec_N='||V_sec_N||' V_sec_QN='||V_sec_QN);
                    commit;

                    EXCEPTION
                    WHEN OTHERS THEN
                    errmsg := SQLERRM;
                    dbms_output.put_line('errmsg3 - '||errmsg);
                    rollback;
                     insert into REPORTS_ERROR_LOG VALUES (r.FORM_Q_NUM||','||r.protocol,  errmsg, sysdate);
                     commit;
                    end;
                end loop;
            END;
            
            EXCEPTION
                    WHEN OTHERS THEN
                    errmsg := SQLERRM;
                    dbms_output.put_line('errmsg3 - '||errmsg);
                    rollback;
                     insert into REPORTS_ERROR_LOG VALUES (i.FORM_Q_NUM||','||i.protocol,  errmsg, sysdate);
                     commit;
            END ;
     end loop;
     
 UPDATE MDSR_REDCAP_PROTOCOL_CSV  SET SECTION_SEQ=0 , SECTION_Q_SEQ=FORM_Q_NUM
 WHERE SECTION_SEQ is null and SECTION_Q_SEQ is null  and SECTION is null and 
 lower(FIELD_NOTE) not like 'Instructions%';
 commit;
  EXCEPTION
                    WHEN OTHERS THEN
                    errmsg := SQLERRM;
                    dbms_output.put_line('errmsg3 - '||errmsg);
                    rollback;
                     insert into REPORTS_ERROR_LOG VALUES ('UPDATE_SECTION_Q_SEQ_FORM_Q_NUM ',  errmsg, sysdate);
                     commit;
            END ;
    

/

CREATE TABLE MSDREDCAP_SECTION_CSV
(
  PROTOCOL       VARCHAR2(40 BYTE),
  FORM_NAME      VARCHAR2(800 BYTE),
  SECTION_SEQ    NUMBER,
  SECTION_Q_SEQ  NUMBER,
  QUESTION       NUMBER,
  SECTION        VARCHAR2(2000 BYTE),
  SECTION_NEW    VARCHAR2(2000 BYTE),
  INSTRUCTION    VARCHAR2(2000 BYTE),
RUN_NUM NUMBER);
/

CREATE OR REPLACE PROCEDURE MDSRedCapSaction_Insert 
AS

 errmsg VARCHAR2(2000):='';
 V_sec_N number;
 V_sec_QN number;
 V_pr_SEC_N number;
 V_MIN_SEC_Q number;
 
BEGIN
 INSERT INTO MSDREDCAP_SECTION_CSV
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
 from MDSR_REDCAP_PROTOCOL_CSV  q
 where SECTION_Q_SEQ=0 ;
 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg3 - '||errmsg);
  insert into REPORTS_ERROR_LOG VALUES ('Saction_Insert',  errmsg, sysdate);
  commit;

END ;
/

 CREATE TABLE MSDREDCAP_FORM_CSV
(
  PROTOCOL              VARCHAR2(40 BYTE),
  FORM_NAME             VARCHAR2(800 BYTE),
  PREFERRED_DEFINITION  VARCHAR2(2000 BYTE)     ,
  PROTOCOL_NAME         VARCHAR2(500 BYTE),
  INSTRUCTION           VARCHAR2(2000 BYTE),
  RUN_NUM NUMBER
)
/
CREATE OR REPLACE PROCEDURE MDSRedCapForm_Insert 
AS

 errmsg VARCHAR2(2000):='';
 V_sec_N number;
 V_sec_QN number;
 V_pr_SEC_N number;
 V_MIN_SEC_Q number;
 
BEGIN
 INSERT INTO MSDREDCAP_FORM_CSV
( PROTOCOL ,
 FORM_NAME ,
  PREFERRED_DEFINITION  ,
  PROTOCOL_NAME )
 SELECT 
 distinct  f.protocol, form_name_new,PREFERRED_DEFINITION,p.long_name
 from  MDSR_REDCAP_PROTOCOL_CSV  f,
 --select*from 
 SBREXT.PROTOCOLS_EXT p
 where preferred_name like'PX%'
 and f.protocol=preferred_name
 and FORM_Q_NUM=0 ;
 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg3 - '||errmsg);
  insert into REPORTS_ERROR_LOG VALUES ('FORM_Insert',  errmsg, sysdate);
  commit;

END ;
/
CREATE TABLE MSDREDCAP_VALUE_CODE_CSV1
( PROTOCOL             VARCHAR2(50)  ,
FORM_NAME   VARCHAR2(255)  ,
  QUESTION            NUMBER,
  VAL_NAME        VARCHAR2(500 )     ,
  VAL_VALUE            VARCHAR2(500 BYTE),
  VAL_ORDER NUMBER   , 
  ELM_ORDER  VARCHAR2(50)  ,
  PIPE_NUM NUMBER,
  RUN_NUM NUMBER
);

CREATE OR REPLACE PROCEDURE MDSRedCap_VALVAL_Insert 
AS

 errmsg VARCHAR2(2000):='';
 V_sec_N number;
 V_sec_QN number;
 V_pr_SEC_N number;
 V_MIN_SEC_Q number;
 
BEGIN
delete pipe from 1st position
 a.UPDATE SBREXT.REDCAP_PROTOCOL_NEW set choices=substr(choices,2)
 where choices is not null and substr(choices,1,1)='|'
 
 14.b insert in REDCAP_VALUE_CODE with no pipes and FIELD_TYPE like'%calc%'
 INSERT INTO SBREXT.REDCAP_VALUE_CODE
 ( PROTOCOL ,
 FORM_NAME ,
 QUESTION ,
 VAL_name ,
 VAL_VALUE ,
 VAL_ORDER,
 PIPE_NUM,
 ELM_ORDER)
 select 
 PROTOCOL,
 FORM_NAME ,
 question,
 CASE WHEN length(choices)> 254
 THEN substr(replace(choices,' '),1,243)||'..TRUNCATED'
 ELSE choices 
 END,
 choices,
 0,
 0,
 choices 
 from SBREXT.REDCAP_PROTOCOL_NEW 
 where choices is not null 
 and instr(choices,'|')=0
 and FIELD_TYPE like'%calc%';
	
	
 
	
14.c insert in REDCAP_VALUE_CODE with no pipes
 1.when many','
	INSERT INTO SBREXT.REDCAP_VALUE_CODE
 ( PROTOCOL ,
 FORM_NAME ,
 QUESTION ,
 VAL_name ,
 VAL_VALUE ,
 VAL_ORDER,
 PIPE_NUM,
 ELM_ORDER)
 select 
 PROTOCOL,
 FORM_NAME ,
 question,
 choices ,
 choices,
 0,
 0,
 choices 
 from SBREXT.REDCAP_PROTOCOL_NEW 
 where choices is not null and instr(choices,'|')=0
 and REGEXP_COUNT(choices,',')>1
	and trim(FIELD_TYPE) <>'calc';
	
14.d.when many',' FIELD_TYPE)='descriptive' and no '|'
 INSERT INTO SBREXT.REDCAP_VALUE_CODE
 ( PROTOCOL ,
 FORM_NAME ,
 QUESTION ,
 VAL_name ,
 VAL_VALUE ,
 VAL_ORDER,
 PIPE_NUM,
 ELM_ORDER)
 select 
 PROTOCOL,
 FORM_NAME ,
 question, 
 CASE WHEN length(choices)> 254
 THEN substr(choices,1,243)||'..TRUNCATED'
 ELSE choices 
 END,
 choices,
 0,
 0,
 choices 
 from SBREXT.REDCAP_PROTOCOL_NEW 
 where choices is not null and instr(choices,'|')=0
 and REGEXP_COUNT(choices,',')>1
 and trim(FIELD_TYPE)='descriptive';
 
14.e insert in REDCAP_VALUE_CODE with no pipes, many',' (FIELD_TYPE) not in ('calc','descriptive'); 
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
);
 and trim(FIELD_TYPE) not in ('calc','descriptive');
 
 
14.f when only 1 separated coma.
 
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
 from SBREXT.REDCAP_PROTOCOL_751 
 where choices is not null and instr(choices,'|')=0
 and REGEXP_COUNT(choices,',')=1;
	
15.
CREATE OR REPLACE FORCE VIEW MSDRDEV.REDCAP_VALUE_VW751
(
    PROTOCOL,
    QUESTION
)
AS
    SELECT DISTINCT p.protocol PROTOCOL, p.question
      FROM MSDRDEV.REDCAP_PROTOCOL_751  p
           LEFT OUTER JOIN REDCAP_VALUE_CODE_751 s
               ON p.protocol = s.protocol AND p.question = s.question
     WHERE s.protocol || s.question IS NULL AND choices IS NOT NULL;
	 
15a.
I INSERT INTO  REDCAP_VALUE_CODE_751
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
           from  (select  FORM_NAME_NEW FORM_NAME ,choices,protocol,question from REDCAP_PROTOCOL_751 where dbms_lob.getlength(choices) >0)t,
      table(cast(multiset(
        select level from dual 
        connect by level <= length (regexp_replace(t.CHOICES, '[^|]+')) + 1
      ) as sys.OdciNumberList)) levels)
      order by 1,3,6;
      
      ------------------check--------------------------------
select count(*) cnt,PROTOCOL  ,FORM_NAME ,QUESTION ,VAL_name ,VAL_VALUE ,  VAL_ORDER
from
REDCAP_VALUE_CODE_751
GROUP by PROTOCOL  ,FORM_NAME ,QUESTION ,VAL_name ,VAL_VALUE ,  VAL_ORDER
having count(*)>1
order by 2,4,7;


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
 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg3 - '||errmsg);
  insert into REPORTS_ERROR_LOG VALUES ('FORM_Insert',  errmsg, sysdate);
  commit;

END ;
/