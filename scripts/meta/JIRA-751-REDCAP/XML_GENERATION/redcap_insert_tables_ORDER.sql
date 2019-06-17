/*exec MDSR_RECAP_INSERT_CSV;
exec MDSR_RECAP_UPDATE_CSV;
exec MDSR_RECAP_UPDATE_CSV2;
exec MDSRedCapSaction_populate ;
exec MSDRedCapSact_Quest_populate;
exec MDSRedCapSaction_Insert;
exec MDSRedCapForm_Insert 
MDSRedCap_VALVAL_Insert */




/*******************************SP**********************************/
/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PROCEDURE MDSR_RECAP_INSERT_CSV(P_run_N number) as

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
 QUESTION_CSV ,
 LOAD_SEQ 
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
 substr(FIELD_LABEL, 1, 4000 ) ,
 P_run_N
from REDCAPPROTOCOL_TEMP;

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into MDSR_QUEST_CONTENTS_UPDATE_ERR values('MDSR_RECAP_INSERT_CSV','', errmsg ,SYSDATE);
     commit;
     END;
  

/

CREATE OR REPLACE PROCEDURE MDSR_RECAP_UPDATE_CSV(P_run_N number) as

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
  where field_label is null or field_label like '%???%' and LOAD_SEQ=P_run_N  ;

     
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
 where lower(FORM_NAME) like '%phenx_%'  and LOAD_SEQ=P_run_N ;
  commit;
 --8.b 
 update MDSR_REDCAP_PROTOCOL_CSV set choices='1 , YES|0 , NO'
  where FIELD_TYPE like'%yesno%';
  commit;
--8.c
UPDATE MDSR_REDCAP_PROTOCOL_CSV set 
VAL_MIN=DECODE(TEXT_VALID_MIN,NULL,NULL,'minLength='||TEXT_VALID_MIN||';'),
VAL_MAX=DECODE(TEXT_VALID_MAX,NULL,NULL,'maxLength='||TEXT_VALID_MAX||';'),
VAL_TYPE=DECODE(TEXT_VALID_TYPE,NULL,NULL,'datatype='||TEXT_VALID_TYPE||';')
where (TEXT_VALID_MIN is not null or TEXT_VALID_MAX is not null or TEXT_VALID_TYPE is not null
) and 
dbms_lob.getlength(choices) = 0 and LOAD_SEQ=P_run_N ;
 commit;
--8.d
UPDATE MDSR_REDCAP_PROTOCOL_CSV set 
INSTRUCTIONS=VAL_TYPE||VAL_MIN||VAL_MAX||LOGIC
where (TEXT_VALID_MIN is not null or TEXT_VALID_MAX is not null or TEXT_VALID_TYPE is not null
or logic is not null) and FIELD_TYPE<>'calc' and LOAD_SEQ=P_run_N ;
 commit;

UPDATE MDSR_REDCAP_PROTOCOL_CSV set 
INSTRUCTIONS='Calculation ;'||VAL_TYPE||VAL_MIN||VAL_MAX||LOGIC
where FIELD_TYPE='calc' and LOAD_SEQ=P_run_N ;
commit;

  UPDATE MDSR_REDCAP_PROTOCOL_CSV set instructions=substr(instructions,1,length(instructions)-1) 
 where SUBSTR(instructions, -1, 1)=';' and LOAD_SEQ=P_run_N ;
 
 commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into MDSR_QUEST_CONTENTS_UPDATE_ERR values('MDSR_RECAP_UPDATE_CSV','', errmsg ,SYSDATE);
     commit;
     END;
/
/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PROCEDURE MDSR_RECAP_UPDATE_CSV2(P_run_N number) as

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
from MDSR_REDCAP_PROTOCOL_CSV where LOAD_SEQ=P_run_N group by PROTOCOL  ) t2
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
where MIN_QUEST=0 and MIN_QUEST=QUESTION and LOAD_SEQ=P_run_N
)
);
commit;

    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into MDSR_QUEST_CONTENTS_UPDATE_ERR values('MDSR_RECAP_UPDATE_CSV','', errmsg ,SYSDATE);
     commit;
     END;
  

/

CREATE OR REPLACE PROCEDURE  MDSRedCapForm_Insert(P_run_N number) 
AS

 errmsg VARCHAR2(2000):='';
 V_sec_N number;
 V_sec_QN number;
 V_pr_SEC_N number;
 V_MIN_SEC_Q number;
 
BEGIN
 INSERT INTO MSDREDCAP_FORM_CSV
( PROTOCOL ,
 FORM_NAME_NEW ,
  PREFERRED_DEFINITION  ,
  PROTOCOL_NAME ,
  INSTRUCTIONS,
   LOAD_SEQ)
 SELECT 
 distinct  f.protocol, form_name_new,PREFERRED_DEFINITION,p.long_name,i.FIELD_LABEL,P_run_N
 --select *
 from
 (select distinct replace(protocol,'Instructions to') protocol, form_name_new ,section_seq,section_q_seq, form_name 
 from   MDSR_REDCAP_PROTOCOL_CSV where FORM_Q_NUM=0 and LOAD_SEQ=P_run_N)f,
 (select replace(protocol,'Instructions to') protocol, form_name ,FIELD_LABEL 
 from  MDSR_REDCAP_PROTOCOL_CSV where protocol like 'Instructions%' and section is null and LOAD_SEQ=P_run_N)i,
 --select*from 
 SBREXT.PROTOCOLS_EXT p
 where  f.protocol=preferred_name
 and f.protocol=i.protocol(+)
 and f.form_name=i.form_name(+)  ;
 commit;

 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg3 - '||errmsg);
  insert into REPORTS_ERROR_LOG VALUES ('FORM_Insert',  errmsg, sysdate);
  commit;

END ;
/
CREATE OR REPLACE PROCEDURE MSDRedCapSact_Quest_populate(P_run_N number)
AS

    CURSOR CUR_RC IS select protocol,FORM_NAME,FORM_Q_NUM,SECTION, SECTION_SEQ ,SECTION_Q_SEQ
    FROM MDSR_REDCAP_PROTOCOL_CSV
    where SECTION_SEQ is not null
    and SECTION_Q_SEQ=0
    and SECTION is not NULL
    and FORM_Q_NUM is not null   
	and LOAD_SEQ=P_run_N 
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
			and LOAD_SEQ=P_run_N 
            ; 
            dbms_output.put_line('V_sec_MAX - '||V_sec_MAX||' V_sec_NC -'||i.SECTION_SEQ);
            
            IF V_sec_MAX> i.SECTION_SEQ THEN
            
            --find next section number and seq number in form
            select SECTION_SEQ,FORM_Q_NUM into V_sec_NEXT,V_QC_NCEXT
            FROM MDSR_REDCAP_PROTOCOL_CSV
            where  protocol=i.protocol
            and FORM_NAME=i.FORM_NAME
            and SECTION is not NULL
            and SECTION_SEQ =i.SECTION_SEQ+1
			and LOAD_SEQ=P_run_N ;
            END IF;
          


 
            DECLARE
            CURSOR C_nosec IS select protocol,FORM_NAME,FORM_Q_NUM,SECTION, SECTION_SEQ ,SECTION_Q_SEQ
            FROM MDSR_REDCAP_PROTOCOL_CSV
            where  protocol=i.protocol
            and FORM_NAME=i.FORM_NAME
            and SECTION is NULL and LOAD_SEQ=P_run_N 
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
                    and SECTION_Q_SEQ is null
					and LOAD_SEQ=P_run_N ;

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
 lower(FIELD_NOTE) not like 'Instructions%'and LOAD_SEQ=P_run_N ;
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



CREATE OR REPLACE PROCEDURE  MDSRedCapSaction_Insert(P_run_N number) 
AS

 errmsg VARCHAR2(2000):='';
 V_sec_N number;
 V_sec_QN number;
 V_pr_SEC_N number;
 V_MIN_SEC_Q number;
 
BEGIN
 INSERT INTO  MSDREDCAP_SECTION_CSV
( PROTOCOL ,
 FORM_NAME ,
 SECTION_SEQ,
 SECTION_Q_SEQ,
 QUESTION ,
 SECTION,
 SECTION_NEW ,
 LOAD_SEQ)
 SELECT 
 distinct q.protocol, q.form_name_new,SECTION_SEQ,SECTION_Q_SEQ,FORM_Q_NUM,q.SECTION,
 case
 when q.SECTION is NULL or q.SECTION like '%phenx_%' then substr(q.form_name_new,18) 
   when q.SECTION is not NULL and q.SECTION not like '%phenx_%' then q.SECTION
   end
   P_run_N
 --select*
 from  MDSR_REDCAP_PROTOCOL_CSV  q
 where SECTION_Q_SEQ=0 and LOAD_SEQ=P_run_N;
 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg3 - '||errmsg);
  insert into  REPORTS_ERROR_LOG VALUES ('Saction_Insert',  errmsg, sysdate);
  commit;

END ;
/


CREATE OR REPLACE PROCEDURE  MDSRedCapSaction_populate(P_run_N number) 
AS

    CURSOR CUR_RC IS select protocol,FORM_NAME,FORM_Q_NUM,SECTION, SECTION_SEQ ,SECTION_Q_SEQ
    FROM  MDSR_REDCAP_PROTOCOL_CSV 
    where SECTION is not NULL
    and SECTION_SEQ is  null
    and FORM_Q_num is not null and LOAD_SEQ=P_run_N 
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
 and LOAD_SEQ=P_run_N;
 and protocol=i.protocol
 and FORM_NAME=i.FORM_NAME;
 
 IF V_MIN_SEC_Q=i.FORM_Q_num THEN
 
 V_sec_N :=1;
 ELSE
 
 V_sec_N :=V_sec_N+1;
 END IF;
 END IF;
 
 UPDATE  MDSR_REDCAP_PROTOCOL_CSV  SET SECTION_SEQ=V_sec_N , SECTION_Q_SEQ=0
 WHERE protocol=i.protocol
 and FORM_NAME=i.FORM_NAME
 and FORM_Q_num =i.FORM_Q_num
 and SECTION=i.SECTION
 and LOAD_SEQ=P_run_N;
 and SECTION_SEQ is null;
 
 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg3 - '||errmsg);
  insert into  REPORTS_ERROR_LOG VALUES (i.FORM_Q_NUM||','||i.protocol,  errmsg, sysdate);
  commit;
 end; 
 end loop;

commit;

END ;
/

CREATE OR REPLACE PROCEDURE MDSRedCap_VALVAL_Insert(P_run_N number) 
AS

 errmsg VARCHAR2(2000):='';
 V_sec_N number;
 V_sec_QN number;
 V_pr_SEC_N number;
 V_MIN_SEC_Q number;
 
BEGIN


-- insert in REDCAP_VALUE_CODE with no pipes, many',' (FIELD_TYPE) not in ('calc','descriptive'); 
  INSERT INTO  MSDREDCAP_VALUE_CODE_CSV
 ( PROTOCOL ,
 FORM_NAME ,
 QUESTION ,
 VAL_name ,
 VAL_VALUE ,
 VAL_ORDER,
 PIPE_NUM,
 ELM_ORDER,
 VAL_VAL_NAME,
 and LOAD_SEQ)
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
 cast(trim(CHOICES )  as varchar2(320)) as CHOICES,
 P_run_N
 from   MDSR_REDCAP_PROTOCOL_CSV
 where dbms_lob.getlength(choices) >0
 and dbms_lob.instr(CHOICES,'|')=0 
 and REGEXP_COUNT(choices,',')>1)
 and LOAD_SEQ=P_run_N;;

 commit;


--when only 1 separated coma.
 
 INSERT INTO  MSDREDCAP_VALUE_CODE_CSV(P_run_N number)
 ( PROTOCOL ,
 FORM_NAME ,
 QUESTION ,
 VAL_name ,
 VAL_VALUE ,
 VAL_ORDER,
 PIPE_NUM,
 ELM_ORDER,
 VAL_VAL_NAME,
 LOAD_SEQ)

 select 
 PROTOCOL,
 FORM_NAME ,
 question,
 --cast(trim(CHOICES )  as varchar2(320)) as CHOICES
 cast(trim(substr(choices,1,(instr(choices,',')-1)) )  as varchar2(320)) as CHOICES1 ,
 cast(trim(substr(choices,(instr(choices,',')+1)) )  as varchar2(320)) as CHOICES2,
 0,
 0,,
 P_run_N;
 choices 
 from  MDSR_REDCAP_PROTOCOL_CSV
 where dbms_lob.getlength(choices) >0 and instr(choices,'|')=0 and LOAD_SEQ=P_run_N;
 and REGEXP_COUNT(choices,',')=1 ;--and protocol='PX770301';
 commit;
INSERT INTO  MSDREDCAP_VALUE_CODE_CSV
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
  CHOICES,
LOAD_SEQ  ---substring CHOICES before || 
 from(
 select 
    cast(trim(regexp_substr(t.CHOICES, '[^|]+', 1, levels.column_value)  )  as varchar2(500)) as  CHOICES,levels.column_value  ELM_ORDER, FORM_NAME ,question,
  protocol,dbms_lob.instr(CHOICES,'[^|]+', 1, levels.column_value) AS PIPE_NUM,LOAD_SEQ
           from  (select  FORM_NAME_NEW FORM_NAME ,choices,protocol,question from  MDSR_REDCAP_PROTOCOL_CSV 
		   where dbms_lob.getlength(choices) >0 and LOAD_SEQ=P_run_N;)t,
      table(cast(multiset(
        select level from dual 
        connect by level <= length (regexp_replace(t.CHOICES, '[^|]+')) + 1
      ) as sys.OdciNumberList)) levels)
      order by 1,3,6;
 commit;     
      ------------------check--------------------------------
      /*
select count(*) cnt,PROTOCOL  ,FORM_NAME ,QUESTION ,VAL_name ,VAL_VALUE ,  VAL_ORDER
from
REDCAP_VALUE_CODE_751
GROUP by PROTOCOL  ,FORM_NAME ,QUESTION ,VAL_name ,VAL_VALUE ,  VAL_ORDER
having count(*)>1--and protocol='PX770301'
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
select distinct question,protocol from  REDCAP_VALUE_CODE_751 */
 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg3 - '||errmsg);
  insert into  REPORTS_ERROR_LOG VALUES ('VALUE_Insert',  errmsg, sysdate);
  commit;

END ;
/