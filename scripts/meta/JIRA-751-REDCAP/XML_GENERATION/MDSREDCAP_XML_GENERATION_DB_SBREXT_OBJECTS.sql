CREATE TABLE MDSR_REDCAP_PROTOCOL_CSV
(
  VARIABLE_FIELD_NAME  VARCHAR2(400 BYTE),
  FORM_NAME            VARCHAR2(400 BYTE),
  SECTION              VARCHAR2(3000 BYTE),
  SECTION_SEQ          NUMBER,
  SECTION_Q_SEQ        NUMBER,
  FIELD_TYPE           VARCHAR2(100 BYTE),
  CHOICES              CLOB,
  FIELD_NOTE           VARCHAR2(100 BYTE),
  QUESTION             NUMBER,
  TEXT_VALID_TYPE      VARCHAR2(60 BYTE),
  TEXT_VALID_MIN       VARCHAR2(60 BYTE),
  TEXT_VALID_MAX       VARCHAR2(60 BYTE),
  IDENTIFIER           VARCHAR2(100 BYTE),
  LOGIC                VARCHAR2(4000 BYTE),
  REQUIRED             VARCHAR2(20 BYTE),
  CUSTOM_ALIGNMENT     VARCHAR2(100 BYTE),
  MATRIX_GROUP_NAME    VARCHAR2(100 BYTE),
  MATRIX_RANK          NUMBER(6,2),
  Q_NMB_SERV           NUMBER,
  PROTOCOL             VARCHAR2(40 BYTE),
  FIELD_LABEL          VARCHAR2(4000 BYTE),
  INSTRUCTIONS         VARCHAR2(4000 CHAR),
  VAL_MIN              VARCHAR2(100 BYTE),
  VAL_MAX              VARCHAR2(100 BYTE),
  VAL_TYPE             VARCHAR2(100 BYTE),
  QUESTION_CSV         CLOB,
  FORM_QUESTION        VARCHAR2(2000 BYTE),
  QUEST_TB_QUESTION    VARCHAR2(4000 BYTE),
  FORM_NAME_NEW        VARCHAR2(400 BYTE),
  FORM_Q_NUM           NUMBER,
  LOAD_SEQ             NUMBER
)
/
GRANT SELECT ON MDSR_REDCAP_PROTOCOL_CSV TO PUBLIC
/
CREATE TABLE MSDREDCAP_FORM_CSV
(
  PROTOCOL              VARCHAR2(40 BYTE),
  FORM_NAME_NEW         VARCHAR2(800 BYTE),
  PREFERRED_DEFINITION  VARCHAR2(2000 BYTE),
  PROTOCOL_NAME         VARCHAR2(500 BYTE),
  INSTRUCTIONS          VARCHAR2(2000 BYTE),
  LOAD_SEQ              NUMBER
)
/
GRANT SELECT ON MSDREDCAP_FORM_CSV TO PUBLIC
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
  LOAD_SEQ       NUMBER
)
/
GRANT SELECT ON MSDREDCAP_SECTION_CSV TO PUBLIC
/
CREATE TABLE MSDREDCAP_VALUE_CODE_CSV
(
  PROTOCOL      VARCHAR2(50 BYTE),
  FORM_NAME     VARCHAR2(255 BYTE),
  QUESTION      NUMBER,
  VAL_NAME      VARCHAR2(500 BYTE),
  VAL_VALUE     VARCHAR2(500 BYTE),
  VAL_ORDER     NUMBER,
  ELM_ORDER     VARCHAR2(50 BYTE),
  PIPE_NUM      NUMBER,
  VAL_VAL_NAME  CLOB,
  LOAD_SEQ      NUMBER
)
/
GRANT SELECT ON MSDREDCAP_VALUE_CODE_CSV TO PUBLIC
/
create index MDSR_PROTO_Q_INDX on  MDSR_REDCAP_PROTOCOL_CSV (PROTOCOL);
create index MDSR_FN_Q_INDX on  MDSR_REDCAP_PROTOCOL_CSV (form_name_new);
create index MDSR_FQ_INDX on  MDSR_REDCAP_PROTOCOL_CSV (question);
create index MDSR_FSEC_INDX on  MDSR_REDCAP_PROTOCOL_CSV (section_seq);
create index MDSR_FSEC_Q_INDX on  MDSR_REDCAP_PROTOCOL_CSV (section_q_seq);
create index MDSR_QLOAD_Q_INDX on  MDSR_REDCAP_PROTOCOL_CSV (LOAD_SEQ);
create index MDSR_VV_PROTO_Q_INDX on  MSDREDCAP_VALUE_CODE_CSV (PROTOCOL);
create index MDSR_VVFN_Q_INDX on  MSDREDCAP_VALUE_CODE_CSV (form_name);
create index MDSR_VVQ_INDX on  MSDREDCAP_VALUE_CODE_CSV (question);
create index MDSR_VVQLOAD_Q_INDX on  MSDREDCAP_VALUE_CODE_CSV (LOAD_SEQ);

CREATE OR REPLACE FORCE VIEW REDCAP_XML_GROUP_CSV_VW
(
    QUEST_SUM,
    PROTOCOL,
    GROUP_NUMBER
)
AS
      SELECT quest_sum,
             PROTOCOL,                                       --form_name_new ,
             CASE
                 WHEN quest_sum < 6 THEN 1
                 WHEN quest_sum >= 6 AND quest_sum <= 14 THEN 2
                 WHEN quest_sum >= 14 AND quest_sum <= 24 THEN 3
                 WHEN quest_sum > 24 AND quest_sum <= 38 THEN 4
                 WHEN quest_sum > 38 AND quest_sum <= 53 THEN 5
                 WHEN quest_sum > 53 AND quest_sum <= 100 THEN 6
                 WHEN quest_sum > 100 AND quest_sum <= 160 THEN 7
                 WHEN quest_sum > 160 AND quest_sum <= 240 THEN 8
                 WHEN quest_sum > 210 THEN 9
             END    group_number
        FROM (  SELECT COUNT (*) quest_sum, PROTOCOL, form_name_new
                  FROM MDSR_REDCAP_PROTOCOL_CSV
                 WHERE protocol NOT LIKE 'Instr%'
              GROUP BY PROTOCOL, form_name_new)
    ORDER BY 1, 2;
/
CREATE OR REPLACE FORCE VIEW REDCOP_PR_GROUP_CSV_VW
(
    GROUP_NUMBER,
    PROTOCOLS
)
AS
      SELECT group_number,
             LISTAGG (protocol, ',') WITHIN GROUP (ORDER BY protocol)    protocols
        FROM REDCAP_XML_GROUP_CSV_VW
    GROUP BY group_number;
/	
CREATE TABLE MDSR_REDCAP_XML
(
  PROTOCOL      VARCHAR2(30 BYTE),
  TEXT          CLOB,
  FILE_NAME     VARCHAR2(200 BYTE),
  CREATED_DATE  DATE,
  LOAD_SEQ             NUMBER
)
/
CREATE OR REPLACE TYPE REDCAP_validValue_T   as object(
"displayOrder"                                     NUMBER
,"value"                                      VARCHAR2(200)
,"meaningText"                                  VARCHAR2(200)  
,"description" VARCHAR2(2000))
/
CREATE OR REPLACE TYPE REDCAP_validValue_LIST_T AS TABLE OF REDCAP_validValue_T 
/ 
CREATE OR REPLACE TYPE REDCAP_INSTRUCTIONS_T as object(
"text" VARCHAR2(1000))
/
CREATE OR REPLACE TYPE REDCAP_PROTOCOL_T as object(
"protocolID" VARCHAR2(50),
"longName"  VARCHAR2(200),
"context"   VARCHAR2(10),
"shortName"  VARCHAR2(50),
"preferredDefinition"  VARCHAR2(2000))
/
CREATE OR REPLACE TYPE REDCAP_QUESTION_T as object(
"publicID"        NUMBER,
"version"          VARCHAR2(8),
"isDerived"       VARCHAR2(8),
"displayOrder"     NUMBER,
"dateCreated"      VARCHAR2(30),
"questionText"     VARCHAR2(4000),
"instruction"      REDCAP_INSTRUCTIONS_T,
"isEditable"       VARCHAR2(8),
"isMandatory"      VARCHAR2(8),
"multiValue"       VARCHAR2(8),
"validValues_xx"       REDCAP_validValue_LIST_T )
/
CREATE OR REPLACE TYPE REDCAP_QUESTION_LIST_T AS TABLE OF REDCAP_QUESTION_T  
/
CREATE OR REPLACE TYPE  REDCAP_SECTION_T as object(
"displayOrder"                                     NUMBER
,"maximumModuleRepeat"                              NUMBER
,"createdBy"   VARCHAR2(40)
,"dateCreated" VARCHAR2(30)
,"longName"    VARCHAR2(2000)
, "preferredDefinition" VARCHAR2(2000)
,"questions_xx"   REDCAP_QUESTION_LIST_T )
/
CREATE OR REPLACE TYPE  REDCAP_SECTION_LIST_T  AS TABLE OF REDCAP_SECTION_T ; 
/   
CREATE OR REPLACE TYPE REDCAP_HINSTRUCTIONS_T                                         as object(
"text" VARCHAR2(2000))
/
CREATE OR REPLACE TYPE  REDCAP_FORM_S                                          as object(
"context"                                    VARCHAR2(40)
,"createdBy"                                      VARCHAR2(100)
,"dateCreated"                         VARCHAR2(30)
,"longName"  VARCHAR2(150)
,"changeNote"                              VARCHAR2(40)
,"preferredDefinition"                      VARCHAR2(2000)
,"cadsrRAI"             VARCHAR2(40)
,"publicid"  NUMBER
,"version"  NUMBER
,"workflowStatusName" VARCHAR2(40)
,"type"              VARCHAR2(5)
,"headerInstruction"      REDCAP_HINSTRUCTIONS_T
,"footerInstruction"  VARCHAR2(100)
,"modules_xx"  REDCAP_SECTION_LIST_T
,"protocol" REDCAP_PROTOCOL_T)
/
CREATE OR REPLACE TYPE REDCAP_FORM_LIST_T AS TABLE OF REDCAP_FORM_S
/
CREATE OR REPLACE FORCE VIEW REDCAP_FORM_COLLECT_CSV_VW
(
    "collectionName",
    "collectionDescription",
    "group"
)
AS
    SELECT 'PhenX Protocols - ' || v.GROUP_NUMBER    "collectionName",
           'Load PhenX ' || v.protocols              "collectionDescription",
           CAST (
               MULTISET (
                     SELECT 'PhenX',
                            'dwarzel',
                               TO_CHAR (SYSDATE, 'YYYY-MM-DD')
                            || 'T'
                            || TO_CHAR (SYSDATE, 'HH24:MI:SS'),
                            p.form_name_new,
                            'Uploaded via FormLoader',
                            UTL_I18N.UNESCAPE_REFERENCE (
                                TRIM (p.preferred_definition)),
                            '2.16.840.1.113883.3.26.2',
                            '',
                            '1.0',
                            'DRAFT NEW',
                            'CRF',
                            REDCAP_HINSTRUCTIONS_T (
                                TRIM (
                                    UTL_I18N.UNESCAPE_REFERENCE (
                                        p.INSTRUCTIONS))),
                            '',
                            CAST (
                                MULTISET (
                                      SELECT NVL (TRIM (s.SECTION_SEQ), '0'),
                                             '0',
                                             'panh',
                                                TO_CHAR (SYSDATE, 'YYYY-MM-DD')
                                             || 'T'
                                             || TO_CHAR (SYSDATE, 'HH24:MI:SS'),
                                             TRIM (s.SECTION_new),
                                             TRIM (s.SECTION_new),
                                             CAST (
                                                 MULTISET (
                                                       SELECT MATRIX_GROUP_NAME,
                                                              MATRIX_RANK,
                                                              'false',
                                                              TRIM (
                                                                  q.section_Q_seq),
                                                                 TO_CHAR (
                                                                     SYSDATE,
                                                                     'YYYY-MM-DD')
                                                              || 'T'
                                                              || TO_CHAR (
                                                                     SYSDATE,
                                                                     'HH24:MI:SS'),
                                                              UTL_I18N.UNESCAPE_REFERENCE (
                                                                  TRIM (
                                                                      q.form_question)),
                                                              REDCAP_INSTRUCTIONS_T (
                                                                  SUBSTR (
                                                                      TRIM (
                                                                          UTL_I18N.UNESCAPE_REFERENCE (
                                                                              NVL (
                                                                                  q.INSTRUCTIONS,
                                                                                  'N/A'))),
                                                                      1,
                                                                      550)),
                                                              'No',
                                                              NVL (
                                                                  TRIM (q.REQUIRED),
                                                                  'No'),
                                                              'No',
                                                              CAST (
                                                                  MULTISET (
                                                                        SELECT TRIM (
                                                                                   VAL_ORDER),
                                                                               TRIM (
                                                                                   VAL_name),
                                                                               TRIM (
                                                                                   VAL_VALUE),
                                                                               CASE q.FIELD_TYPE
                                                                                   WHEN 'calc'
                                                                                   THEN
                                                                                          'Calculation: '
                                                                                       || TRIM (
                                                                                              VAL_VALUE)
                                                                                   ELSE
                                                                                       TRIM (
                                                                                           VAL_VALUE)
                                                                               END
                                                                          FROM MSDREDCAP_VALUE_CODE_CSV
                                                                               u
                                                                         WHERE     u.question(+) =
                                                                                   q.question
                                                                               AND u.protocol(+) =
                                                                                   q.protocol
                                                                      ORDER BY VAL_ORDER)
                                                                      AS REDCAP_validValue_LIST_T)
                                                                  "ValidValue"
                                                         FROM MDSR_REDCAP_PROTOCOL_CSV
                                                              q
                                                        WHERE     q.protocol =
                                                                  s.protocol
                                                              AND s.SECTION_SEQ =
                                                                  q.SECTION_SEQ
                                                     ORDER BY q.section_Q_seq)
                                                     AS REDCAP_QUESTION_LIST_T)
                                                 "Question"
                                        FROM MSDREDCAP_SECTION_CSV s
                                       WHERE p.protocol = s.protocol(+)
                                    ORDER BY s.SECTION_SEQ)
                                    AS REDCAP_SECTION_LIST_T),
                            REDCAP_PROTOCOL_T (
                                TRIM (pe.protocol_id),
                                UTL_I18N.UNESCAPE_REFERENCE (TRIM (long_name)),
                                'PhenX',
                                TRIM (pe.preferred_name),
                                UTL_I18N.UNESCAPE_REFERENCE (
                                    NVL (TRIM (pe.preferred_definition),
                                         'The Protocol is Not Found')))
                                AS "form"
                       FROM (SELECT DISTINCT protocol,
                                             form_name_new,
                                             preferred_definition,
                                             INSTRUCTIONS
                               FROM MSDREDCAP_FORM_CSV) p,
                            REDCAP_XML_GROUP_CSV_VW g,
                            sbrext.protocols_ext           pe
                      WHERE     p.protocol = g.protocol
                            AND pe.preferred_name = p.protocol
                            AND g.GROUP_NUMBER = v.GROUP_NUMBER
                   ORDER BY p.protocol, form_name_new)
                   AS REDCAP_FORM_LIST_T)    AS "group"
      FROM REDCOP_PR_GROUP_CSV_VW v;
/

CREATE TABLE REDCAP_ERROR_LOG
(
  FILE_NAME         VARCHAR2(50 BYTE),
  REPORT_ERROR_TXT  VARCHAR2(1100 BYTE),
  DATE_PROCESSED    DATE
)
/
CREATE TABLE REPORTS_ERROR_LOG
(
  FILE_NAME         VARCHAR2(50 BYTE),
  REPORT_ERROR_TXT  VARCHAR2(1100 BYTE),
  DATE_PROCESSED    DATE
)
/
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
CREATE OR REPLACE PROCEDURE SBR.MDSR_RECAP_UPDATE_CSV2(P_run_N number) as

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
from MDSR_REDCAP_PROTOCOL_CSV where LOAD_SEQ=P_run_N)--where form_name='phenx_cancer_personal_and_family_history')
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
from MDSR_REDCAP_PROTOCOL_CSV where protocol not like 'Instructions%' and LOAD_SEQ=P_run_N)
where MIN_QUEST=0 and MIN_QUEST=QUESTION 
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
   end,
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
 and LOAD_SEQ=P_run_N
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
 and LOAD_SEQ=P_run_N
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
 
 CREATE OR REPLACE PROCEDURE SBR.MDSRedCap_VALVAL_Insert(P_run_N number)
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
 LOAD_SEQ)
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
 choices,
 P_run_N
 from
 (select
 PROTOCOL,
 FORM_NAME ,
 question,
 cast(trim(CHOICES )  as varchar2(320)) as CHOICES
 
 from   MDSR_REDCAP_PROTOCOL_CSV
 where dbms_lob.getlength(choices) >0
 and dbms_lob.instr(CHOICES,'|')=0
 and REGEXP_COUNT(choices,',')>1
 and LOAD_SEQ=P_run_N);

 commit;


--when only 1 separated coma.

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
 LOAD_SEQ)

 select
 PROTOCOL,
 FORM_NAME ,
 question,
 --cast(trim(CHOICES )  as varchar2(320)) as CHOICES
 cast(trim(substr(choices,1,(instr(choices,',')-1)) )  as varchar2(320)) as CHOICES1 ,
 cast(trim(substr(choices,(instr(choices,',')+1)) )  as varchar2(320)) as CHOICES2,
 0,
 0, 
 0,
 choices,
 P_run_N
 from  MDSR_REDCAP_PROTOCOL_CSV
 where dbms_lob.getlength(choices) >0 and instr(choices,'|')=0 and LOAD_SEQ=P_run_N 
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
  VAL_VAL_NAME,
  LOAD_SEQ)
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
  P_run_N
  ---substring CHOICES before ||
 from(
 select
    cast(trim(regexp_substr(t.CHOICES, '[^|]+', 1, levels.column_value)  )  as varchar2(500)) as  CHOICES,levels.column_value  ELM_ORDER, FORM_NAME ,question,
  protocol,dbms_lob.instr(CHOICES,'[^|]+', 1, levels.column_value) AS PIPE_NUM
           from  (select  FORM_NAME_NEW FORM_NAME ,choices,protocol,question from  MDSR_REDCAP_PROTOCOL_CSV
		   where dbms_lob.getlength(choices) >0 and LOAD_SEQ=P_run_N)t,
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
CREATE OR REPLACE PROCEDURE xml_RedCap_insertCSV(p_run number) as
  

CURSOR c_protocol IS
SELECT   group_number
FROM REDCOP_PR_GROUP_CSV_VW 
order by group_number;


 l_file_name      VARCHAR2 (100):='NA';
   l_file_path      VARCHAR2 (200);
   l_result         CLOB:=null;
   l_xmldoc          CLOB:=null;
   l_protocol        VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
BEGIN 
 FOR rec IN c_protocol LOOP  
 BEGIN 
        l_file_path := 'SBREXT_DIR';       
       -- v_protocol:=rec.protocol ;
         l_file_name := rec.group_number||'_Run '|| p_run||SYSDATE;
        --dbms_output.put_line('group_number  - '||rec.group_number);
        dbms_output.put_line('group_number  - '||rec.group_number);
        SELECT dbms_xmlgen.getxml( 'select* from MSDRDEV.REDCAP_FORM_COLLECT_CSV_VW where "collectionName" like'||''''||'%'||rec.group_number||'%'||'''')
        INTO l_result
        FROM DUAL ;
        insert into REDCAP_XML VALUES (rec.group_number,l_result, l_file_name ,SYSDATE);
 
      --dbms_xslprocessor.clob2file(l_xmldoc,  l_file_path, l_file_name, nls_charset_id('UTF8'));

      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into REPORTS_ERROR_LOG VALUES (substr(l_file_name,1,49),  errmsg, sysdate);
        
     commit;   
        END;
END LOOP;

END;
/
CREATE OR REPLACE PROCEDURE REDCAP_XML_TRANSFORM IS

l_file_name VARCHAR2(500):='Phenx FORMS';
 errmsg VARCHAR2(500):='Non';
BEGIN

update redcap_xml set text=replace(text,'REDCAP_SECTION_T','module');
update redcap_xml set text=replace(text,'REDCAP_QUESTION_T','question');
update redcap_xml set text=replace(text,'</ROW>','</forms>');
update redcap_xml set text=replace(text,'<ROW>','<forms>');
UPDATE redcap_xml set text=replace(text,'REDCAP_VALIDVALUE_T','validValue');
UPDATE redcap_xml set text=replace(text,'REDCAP_FORM_S','form' ) ;
UPDATE redcap_xml set text=replace(text,'<group>'||chr(10) ) ;
UPDATE redcap_xml set text=replace(text,'</group>'||chr(10) ) ;
UPDATE redcap_xml set text=replace(text,'<ROWSET>'||chr(10) ) ;
UPDATE redcap_xml set text=replace(text,'</ROWSET>'||chr(10) );
update redcap_xml set text=replace(text,'</ROW>','</forms>');
update redcap_xml set text=replace(text,'<ROW>','<forms>');
update redcap_xml set text=replace(text,'REDCAP_SECTION_T','module');
update redcap_xml set text=replace(text,'REDCAP_QUESTION_T','question');
UPDATE redcap_xml set text=replace(text,'REDCAP_VALIDVALUE_T','validValue');
UPDATE redcap_xml set text=replace(text,'<validValues_x005F_xx>'||chr(10));
UPDATE redcap_xml set text=replace(text,'</validValues_x005F_xx>'||chr(10));
UPDATE redcap_xml set text=replace(text,'<validValues_x005F_xx/>'||chr(10));
UPDATE redcap_xml set text=replace(text,'CFR','CRF' ); 
UPDATE redcap_xml set text=replace(text,'<modules_x005F_xx>','' );
UPDATE redcap_xml set text=replace(text,'<modules_x005F_xx>'||chr(10));
UPDATE redcap_xml set text=replace(text,'</modules_x005F_xx>'||chr(10));
UPDATE redcap_xml set text=replace(text,'<questions_x005F_xx>'||chr(10));
UPDATE redcap_xml set text=replace(text,'</questions_x005F_xx>'||chr(10));
UPDATE redcap_xml set text=replace(text,'<questions_x005F_xx/>'||chr(10));
UPDATE redcap_xml set text=replace(text,'<?xml version="1.0"?>','<?xml version="1.0" encoding="UTF-8"?>');
--UPDATE redcap_xml set text=replace(text,'2016-08-01 16:20:20',TO_CHAR(SYSDATE,'YYYY-MM-DD')||'T00:00:00.0');
 commit;
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into REPORTS_ERROR_LOG VALUES (l_file_name,  errmsg, sysdate);
 commit;

END ;
/
CREATE OR REPLACE PROCEDURE MSDRDEV.REDCAP_XML_GROUP_insert as

CURSOR c_protocol IS
SELECT distinct  r.protocol
FROM MDSR_REDCAP_PROTOCOL_CSV r
order by 1;

   l_form_seq      number:='0';
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
BEGIN
 FOR rec IN c_protocol LOOP
 BEGIN
        l_form_seq:=l_form_seq+1;
        insert into MSDRDEV.REDCAP_XML_GROUP VALUES (rec.protocol,l_form_seq, null);

    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into REPORTS_ERROR_LOG VALUES (rec.protocol,  errmsg, sysdate);

     commit;
        END;
END LOOP;


END;
/
CREATE OR REPLACE PROCEDURE MSDRDEV.REDCAP_PREVIW_TRANSFORM IS

l_file_name VARCHAR2(500):='Phenx FORMS';
 errmsg VARCHAR2(500):='Non';
BEGIN 
UPDATE MDSR_REDCAP_PROTOCOL_CSV set field_label=replace(field_label,'÷','/')where instr( FIELD_LABEL,'÷')>0;
UPDATE MDSR_REDCAP_PROTOCOL_CSV set field_label=replace(field_label,'&'||'#149;','') where instr( FIELD_LABEL,'&'||'#149;')>0;
UPDATE MDSR_REDCAP_PROTOCOL_CSV set field_label=replace(field_label,'°','DDDD') where instr(field_label,'°')>0;
UPDATE MDSR_REDCAP_PROTOCOL_CSV set field_label=replace(field_label,'©','CCCC') where instr(field_label,'©')>0;
UPDATE MDSR_REDCAP_PROTOCOL_CSV set field_label=replace(field_label,'®','RRRR') where instr(field_label,'®')>0;
UPDATE MDSR_REDCAP_PROTOCOL_CSV set field_label=replace(field_label,'™','TTTT') where instr(field_label,'™')>0;
UPDATE MDSR_REDCAP_PROTOCOL_CSV set field_label=replace(field_label,'µ','MUMUMU') where instr(field_label,'µ')>0;
UPDATE MDSR_REDCAP_PROTOCOL_CSV set field_label=replace(field_label,'×','XxXxXx') where instr(field_label,'×')>0;
UPDATE MDSR_REDCAP_PROTOCOL_CSV set field_label=replace(field_label,'±','PMPMPM') where instr(field_label,'±')>0;
UPDATE MDSR_REDCAP_PROTOCOL_CSV set field_label=replace(field_label,'¢','ctctct') where instr(field_label,'¢')>0;
 commit; 
UPDATE MDSR_REDCAP_PROTOCOL_CSV set field_label=REGEXP_REPLACE(ASCIISTR(field_label), '\\[[:xdigit:]]{4}', '');
 commit;
UPDATE MDSR_REDCAP_PROTOCOL_CSV set field_label=regexp_replace(trim(FIELD_LABEL),'['||chr(128)||'-'||chr(255)||';]','',1,0,'in');
 commit;
UPDATE MDSR_REDCAP_PROTOCOL_CSV set field_label=regexp_replace(trim(FIELD_LABEL),'['||chr(1)||'-'||chr(31)||']','',1,0,'in');

 commit; 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg - '||errmsg);
 insert into REDCAP_ERROR_LOG VALUES (l_file_name, errmsg, sysdate);
 

END ;
/
