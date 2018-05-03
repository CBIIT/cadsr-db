DROP TABLE SBREXT.REDCAPPROTOCOL_TEMP;
DROP TABLE SBREXT.REDCAP_PROTOCOL_NEW;
DROP TABLE SBREXT.REDCAP_VALUE_CODE;
DROP TABLE SBREXT.REDCAP_PV_CODE;
DROP TABLE SBREXT.REDCAP_SECTION;
DROP TABLE SBREXT.REDCAP_TEMP;
DROP TABLE REDCAP_PROTOCOL_FORM;
DROP TABLE SBREXT.REDCAP_ERROR_LOG;
DROP TABLE REDCAP_XML_GROUP;
DROP TABLE SBREXT.REDCAP_XML;	
drop view REDCAP_FORM_COLLECT_VW;
drop type REDCAP_FORM_LIST_T;
drop type REDCAP_FORM_S;
drop type REDCAP_SECTION_LIST_T;
drop type REDCAP_SECTION_T;
drop type REDCAP_QUESTION_LIST_T;
drop type REDCAP_QUESTION_T;
drop type REDCAP_validValue_LIST_T;
drop type REDCAP_validValue_T;
drop type REDCAP_INSTRUCTIONS_T;
drop type REDCAP_HINSTRUCTIONS_T;
CREATE TABLE SBREXT.REDCAPPROTOCOL_TEMP
(
 VARIABLE_FIELD_NAME  VARCHAR2(400 BYTE),
  FORM_NAME            VARCHAR2(400 BYTE),
  SECTION              VARCHAR2(3000 BYTE),
  FIELD_TYPE           VARCHAR2(100 BYTE),
  FIELD_LABEL          CLOB,
  CHOICES              VARCHAR2(2500 BYTE),
  FIELD_NOTE           VARCHAR2(100 BYTE),
  TEXT_VALID_TYPE      VARCHAR2(100 BYTE),
  TEXT_VALID_MIN       VARCHAR2(100 BYTE),
  TEXT_VALID_MAX       VARCHAR2(100 BYTE),
  IDENTIFIER           VARCHAR2(100 BYTE),
  LOGIC                VARCHAR2(4000 BYTE),
  REQUIRED             VARCHAR2(50 BYTE),
  CUSTOM_ALIGNMENT     VARCHAR2(100 BYTE),
  Q_NMB_SERV           VARCHAR2(100 BYTE),
  MATRIX_GROUP_NAME    VARCHAR2(100 BYTE),
  MATRIX_RANK          VARCHAR2(100 BYTE),
  QUESTION             NUMBER
)
/
CREATE TABLE REDCAP_PROTOCOL_NEW
(
  VARIABLE_FIELD_NAME  VARCHAR2(400 BYTE),
  FORM_NAME            VARCHAR2(400 BYTE),
  SECTION              VARCHAR2(3000 BYTE),
  SECTION_SEQ          NUMBER,
  SECTION_Q_SEQ        NUMBER,
  FIELD_TYPE           VARCHAR2(100 BYTE),
  CHOICES              VARCHAR2(2500 BYTE),
  FIELD_NOTE           VARCHAR2(100 BYTE),
  QUESTION             NUMBER,
  TEXT_VALID_TYPE      VARCHAR2(30 BYTE),
  TEXT_VALID_MIN       VARCHAR2(60 BYTE),
  TEXT_VALID_MAX       VARCHAR2(60 BYTE),
  IDENTIFIER           VARCHAR2(100 BYTE),
  LOGIC                VARCHAR2(2000 BYTE),
  REQUIRED             VARCHAR2(5 BYTE),
  CUSTOM_ALIGNMENT     VARCHAR2(100 BYTE),
  MATRIX_GROUP_NAME    VARCHAR2(100 BYTE),
  MATRIX_RANK          NUMBER(6,2),
  Q_NMB_SERV           NUMBER,
  PROTOCOL             VARCHAR2(40 BYTE),
  FIELD_LABEL          VARCHAR2(4000 BYTE),
  INSTRUCTIONS         VARCHAR2(2000 BYTE),
  VAL_MIN              VARCHAR2(100 BYTE),
  VAL_MAX              VARCHAR2(100 BYTE),
  VAL_TYPE             VARCHAR2(100 BYTE),
  QUESTION_CSV         VARCHAR2(4000 BYTE),
  FORM_QUESTION        VARCHAR2(2000 BYTE)
)
/
CREATE TABLE SBREXT.REDCAP_VALUE_CODE
(  PROTOCOL      VARCHAR2(50 BYTE),
  FORM_NAME     VARCHAR2(100 BYTE),
  QUESTION      NUMBER,
  VAL_NAME      VARCHAR2(2000 BYTE),
  VAL_VALUE     VARCHAR2(2000 BYTE),
  VAL_ORDER     NUMBER,
  ELM_ORDER     VARCHAR2(2000 BYTE),
  PIPE_NUM      NUMBER,
  VAL_NAME_NEW  VARCHAR2(2000 BYTE))
 /
CREATE OR REPLACE FORCE VIEW REDCAP_VALUE_VW
(
   PROTOCOL,
   QUESTION
)
AS
   SELECT DISTINCT p.protocol PROTOCOL, p.question
     FROM SBREXT.REDCAP_PROTOCOL_NEW p
          LEFT OUTER JOIN REDCAP_VALUE_CODE s
             ON p.protocol = s.protocol AND p.question = s.question
    WHERE s.protocol || s.question IS NULL AND choices IS NOT NULL
/
CREATE TABLE REDCAP_PV_CODE
(
  PROTOCOL  VARCHAR2(50 BYTE),
  QUESTION  NUMBER,
  PV_NAME   VARCHAR2(30 BYTE),
  PV_VALUE  VARCHAR2(100 BYTE),
  PV_ORDER  NUMBER
)
/
CREATE TABLE SBREXT.REDCAP_SECTION
(
 PROTOCOL       VARCHAR2(40 BYTE),
  FORM_NAME      VARCHAR2(400 BYTE),
  SECTION        VARCHAR2(2000 BYTE),
  SECTION_SEQ    NUMBER,
  QUESTION       NUMBER,
  QUESTION_TEXT  VARCHAR2(2000 BYTE),
  INSTUCTION     VARCHAR2(2000 BYTE),
  SECTION_NEW    VARCHAR2(2000 BYTE)
)
/
CREATE TABLE REDCAP_TEMP
(
  VARIABLE_FIELD_NAME  VARCHAR2(400 BYTE),
  QUESTION_CSV         VARCHAR2(4000 BYTE)
)
/
CREATE TABLE REDCAP_PROTOCOL_FORM
(
  PROTOCOL              VARCHAR2(40 BYTE),
  FORM_NAME             VARCHAR2(449 BYTE),
  PREFERRED_DEFINITION  VARCHAR2(2000 BYTE)     NOT NULL,
  PROTOCOL_NAME         VARCHAR2(500 BYTE),
  INSTRUCTION           VARCHAR2(2000 BYTE)
)
/
CREATE TABLE SBREXT.REDCAP_ERROR_LOG
(
 FILE_NAME VARCHAR2(50 BYTE),
 REPORT_ERROR_TXT VARCHAR2(1100 BYTE),
 DATE_PROCESSED DATE
)
/
CREATE TABLE REDCAP_XML_GROUP
(
  PROTOCOL   VARCHAR2(30 BYTE),
  PR_SEQ     NUMBER,
  GROUP_NUM  NUMBER
)
/
CREATE TABLE SBREXT.REDCAP_XML
(
 PROTOCOL VARCHAR2(30 BYTE),
 TEXT CLOB,
 FILE_NAME VARCHAR2(200 BYTE),
 CREATED_DATE DATE
)
/
CREATE OR REPLACE FORCE VIEW REDCAP_SECTION_VW
(
   PROTOCOL,
   QUESTION
)
AS
   SELECT DISTINCT p.protocol PROTOCOL, p.QUESTION
     FROM SBREXT.REDCAP_PROTOCOL_NEW p
          LEFT OUTER JOIN REDCAP_SECTION s
             ON p.protocol = s.protocol AND p.QUESTION = s.QUESTION
    WHERE s.protocol || s.QUESTION IS NULL;
/	
CREATE OR REPLACE PROCEDURE SBREXT.redCapSaction_populate 
AS

CURSOR CUR_RC IS select r.protocol,FORM_NAME,r.QUESTION,SECTION, SECTION_SEQ 
FROM SBREXT.REDCAP_PROTOCOL_NEW r,
REDCAP_SECTION_VW v
where r.protocol=v.PROTOCOL
and NVL(SECTION,'A')<>'A'
and r.QUESTION=v.QUESTION
order by r.protocol,FORM_NAME,QUESTION;
 errmsg VARCHAR2(2000):='';
 V_sec_N number;
 V_sec_QN number;
 V_pr_SEC_N number;
 V_MIN_SEC_Q number;
 
BEGIN
for i in CUR_RC loop
BEGIN
 IF i.QUESTION=0 then 
 V_sec_N :=0; 
 ELSE
 SELECT min(question) into V_MIN_SEC_Q 
 from SBREXT.REDCAP_PROTOCOL_NEW
 where SECTION is not NULL
 and protocol=i.protocol
 and FORM_NAME=i.FORM_NAME;
 IF V_MIN_SEC_Q=i.QUESTION THEN
 
 V_sec_N :=1;
 ELSE
 
 V_sec_N :=V_sec_N+1;
 END IF;
 END IF;
 
 UPDATE REDCAP_PROTOCOL_NEW SET SECTION_SEQ=V_sec_N , SECTION_Q_SEQ=0
 WHERE protocol=i.protocol
 and FORM_NAME=i.FORM_NAME
 and QUESTION =i.QUESTION
 and SECTION=i.SECTION;
 
 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg3 - '||errmsg);
 -- insert into META_CONCEPTS_EXT_ERROR_LOG VALUES (errmsg,sysdate,i.PREFERRED_NAME,i.LONG_NAME ,i.PREFERRED_DEFINITION);
 end; 
 end loop;

commit;

END ;
/
CREATE OR REPLACE PROCEDURE redCapSact_Quest_populate 
AS

CURSOR CUR_RC IS select r.protocol,FORM_NAME,QUESTION,SECTION, SECTION_SEQ ,SECTION_Q_SEQ
FROM SBREXT.REDCAP_PROTOCOL_NEW r,
REDCAP_SECTION_VW v
where r.protocol=v.PROTOCOL
order by r.protocol,FORM_NAME,QUESTION;
 errmsg VARCHAR2(2000):='';
 V_sec_N number;
 V_sec_QN number;
 
BEGIN
for i in CUR_RC loop
BEGIN
 IF i.SECTION_SEQ is not null then 
 V_sec_N :=i.SECTION_SEQ;
 V_sec_QN :=i.SECTION_Q_SEQ; 
 
 dbms_output.put_line('output1 - V_sec_N='||V_sec_N||' V_sec_QN='||V_sec_QN);
 ELSE
 select SECTION_SEQ,SECTION_Q_SEQ+1 into V_sec_N,V_sec_QN 
 FROM SBREXT.REDCAP_PROTOCOL_NEW 
 where QUESTION =i.QUESTION-1
 and protocol=i.protocol
 and FORM_NAME=i.FORM_NAME;
 
 dbms_output.put_line('output2 - V_sec_N='||V_sec_N||' V_sec_QN='||V_sec_QN);
 END IF;
 
 /**/ 
 UPDATE REDCAP_PROTOCOL_NEW SET SECTION_SEQ=V_sec_N , SECTION_Q_SEQ= V_sec_QN
 WHERE protocol=i.protocol
 and FORM_NAME=i.FORM_NAME
 and QUESTION =i.QUESTION;
 
 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg3 - '||errmsg);
 -- insert into META_CONCEPTS_EXT_ERROR_LOG VALUES (errmsg,sysdate,i.PREFERRED_NAME,i.LONG_NAME ,i.PREFERRED_DEFINITION);
 end; 
 end loop;

commit;

END ;
/
CREATE OR REPLACE TYPE REDCAP_INSTRUCTIONS_T as object(
"text" VARCHAR2(2000))
/ 
CREATE OR REPLACE TYPE REDCAP_HINSTRUCTIONS_T as object(
"text" VARCHAR2(2000))
/
CREATE OR REPLACE TYPE REDCAP_validValue_T as object(
"displayOrder"                                     NUMBER
,"value"                                      VARCHAR2(2000)
,"meaningText"                                  VARCHAR2(2000)  
,"description" VARCHAR2(2000))
/
CREATE OR REPLACE TYPE REDCAP_validValue_LIST_T AS TABLE OF REDCAP_validValue_T ; 
 / 
CREATE OR REPLACE TYPE REDCAP_PROTOCOL_T as object(
"protocolID" VARCHAR2(50),
"longName" VARCHAR2(200),
"context" VARCHAR2(10),
"shortName" VARCHAR2(50),
"preferredDefinition" VARCHAR2(2000))
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
CREATE OR REPLACE TYPE REDCAP_QUESTION_LIST_T AS TABLE OF REDCAP_QUESTION_T ;
/ 
CREATE OR REPLACE TYPE REDCAP_SECTION_T as object(
"displayOrder"                                     NUMBER
,"maximumModuleRepeat"                              NUMBER
,"createdBy"   VARCHAR2(40)
,"dateCreated" VARCHAR2(30)
,"longName"    VARCHAR2(2000) 
, "preferredDefinition" VARCHAR2(2000)
,"questions_xx"   REDCAP_QUESTION_LIST_T )
/
CREATE OR REPLACE TYPE REDCAP_SECTION_LIST_T AS TABLE OF REDCAP_SECTION_T ; 
 /
CREATE OR REPLACE TYPE               REDCAP_FORM_S    as object(    
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
,"headerInstruction"     SBREXT.REDCAP_HINSTRUCTIONS_T                       
,"footerInstruction"  VARCHAR2(100)
,"modules_xx" SBREXT.REDCAP_SECTION_LIST_T
,"protocol" SBREXT.REDCAP_PROTOCOL_T)
/
 CREATE OR REPLACE TYPE REDCAP_FORM_LIST_T AS TABLE OF REDCAP_FORM_S ;  
/
CREATE OR REPLACE PROCEDURE SBREXT.REDCAP_XML_GROUP_insert as  

CURSOR c_protocol IS
SELECT distinct  r.protocol
FROM REDCAP_PROTOCOL_NEW r
order by 1;

   l_form_seq      number:='0'; 
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
BEGIN 
 FOR rec IN c_protocol LOOP  
 BEGIN 
        l_form_seq:=l_form_seq+1;  
        insert into SBREXT.REDCAP_XML_GROUP VALUES (rec.protocol,l_form_seq, null); 
      
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
CREATE OR REPLACE FORCE VIEW REDCOP_PR_GROUP_VW
(
   GROUP_NUM,
   PROTOCOLS
)
AS
     SELECT group_num,
            LISTAGG (protocol, ',') WITHIN GROUP (ORDER BY protocol) protocols
       FROM SBREXT.REDCAP_XML_GROUP
   GROUP BY group_num;
/
/* Formatted on 4/30/2018 2:57:30 PM (QP5 v5.269.14213.34769) */
CREATE OR REPLACE FORCE VIEW REDCAP_FORM_COLLECT_VW
(
   "collectionName",
   "collectionDescription",
   "group"
)
AS
   SELECT 'PhenX Protocols - ' || v.GROUP_NUM "collectionName",
          'Load PhenX ' || v.protocols "collectionDescription",
          CAST (
             MULTISET (
                  SELECT 'PhenX',
                         'dwarzel',
                            TO_CHAR (SYSDATE, 'YYYY-MM-DD')
                         || 'T'
                         || TO_CHAR (SYSDATE, 'HH24:MI:SS'),
                         SUBSTR (p.protocol || p.form_name, 9),
                         'Uploaded via FormLoader',
                         UTL_I18N.UNESCAPE_REFERENCE (
                            TRIM (p.preferred_definition)),
                         '2.16.840.1.113883.3.26.2',
                         '',
                         '1.0',
                         'DRAFT NEW',
                         'CRF',
                         REDCAP_HINSTRUCTIONS_T (
                            TRIM (UTL_I18N.UNESCAPE_REFERENCE (p.INSTRUCTION))),
                         '',
                         CAST (
                            MULTISET (
                                 SELECT NVL (TRIM (s.SECTION_SEQ), '0'),
                                        '0',
                                        'panh',
                                           TO_CHAR (SYSDATE, 'YYYY-MM-DD')
                                        || 'T'
                                        || TO_CHAR (SYSDATE, 'HH24:MI:SS'),
                                        NVL (TRIM (s.SECTION_new),
                                             TRIM (protocol_name)),
                                        --  REDCAP_INSTRUCTIONS_T (   TRIM (   UTL_I18N.UNESCAPE_REFERENCE (   question_text))),
                                        NVL (TRIM (s.SECTION_new),
                                             'No definition'),
                                        CAST (
                                           MULTISET (
                                                SELECT MATRIX_GROUP_NAME,
                                                       MATRIX_RANK,
                                                       'false',
                                                       TRIM (q.section_Q_seq),
                                                          TO_CHAR (SYSDATE,
                                                                   'YYYY-MM-DD')
                                                       || 'T'
                                                       || TO_CHAR (SYSDATE,
                                                                   'HH24:MI:SS'),
                                                       UTL_I18N.UNESCAPE_REFERENCE (
                                                          TRIM (q.form_question)),
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
                                                       NVL (TRIM (q.REQUIRED),
                                                            'No'),
                                                       'No',
                                                       CAST (
                                                          MULTISET (
                                                               SELECT TRIM (
                                                                         VAL_ORDER),
                                                                      TRIM (VAL_name),
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
                                                                 FROM REDCAP_VALUE_CODE u
                                                                WHERE     u.question(+) =
                                                                             q.question
                                                                      AND u.protocol(+) =
                                                                             q.protocol
                                                             ORDER BY VAL_ORDER) AS REDCAP_validValue_LIST_T)
                                                          "ValidValue"
                                                  FROM REDCAP_PROTOCOL_NEW q
                                                 WHERE     1 = 1
                                                       AND q.protocol = s.protocol
                                                       AND s.SECTION_SEQ =
                                                              q.SECTION_SEQ
                                              ORDER BY q.section_Q_seq) AS REDCAP_QUESTION_LIST_T)
                                           "Question"
                                   FROM REDCAP_SECTION s
                                  WHERE p.protocol = s.protocol(+)
                               ORDER BY s.SECTION_SEQ) AS REDCAP_SECTION_LIST_T),
                         REDCAP_PROTOCOL_T (
                            TRIM (pe.protocol_id),
                            TRIM (long_name),
                            'PhenX',
                            TRIM (pe.preferred_name),
                            UTL_I18N.UNESCAPE_REFERENCE (
                               NVL (TRIM (pe.preferred_definition),
                                    'The Protocol is Not Found')))
                            AS "form"
                    FROM (SELECT DISTINCT protocol,
                                          protocol_name,
                                          form_name,
                                          preferred_definition,
                                          INSTRUCTION
                            FROM SBREXT.REDCAP_PROTOCOL_FORM) p,
                         SBREXT.REDCAP_XML_GROUP g,
                         protocols_ext pe
                   WHERE     p.protocol = g.protocol
                         AND pe.preferred_name = p.protocol
                         AND g.GROUP_NUM = v.GROUP_NUM
                --    and p.protocol='PX120402'
                --   AND g.GROUP_NUM =27
                ORDER BY p.protocol, form_name) AS SBREXT.REDCAP_FORM_LIST_T) --.REDCAP_FORM_S
             AS "group"
     FROM REDCOP_PR_GROUP_VW v;
/
CREATE OR REPLACE PROCEDURE SBREXT.xml_RedCop_insert as
  

CURSOR c_protocol IS
SELECT distinct  r.protocol,form_name
FROM REDCAP_PROTOCOL_NEW r
left outer join REDCAP_XML x
on r.protocol=x.protocol
where x.protocol is null;


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
        v_protocol:=rec.protocol ;
         l_file_name := v_protocol||'_'||rec.form_name||' _GeneratedFormFinalFormCartV2.xml';
        
        SELECT dbms_xmlgen.getxml( 'select*REDCAP_FORM_COLLECT_VW   where "collectionName" like'||''''||'%'||v_protocol||'%'||'''')
        INTO l_result
        FROM DUAL ;
        insert into REDCAP_XML VALUES (v_protocol,l_result, l_file_name ,SYSDATE);
 
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
CREATE OR REPLACE PROCEDURE SBREXT.REDCAP_XML_TRANSFORM IS

l_file_name VARCHAR2(500):='Phenx FORMS';
 errmsg VARCHAR2(500):='Non';
BEGIN 
   
update redcap_xml set text=replace(text,'REDCAP_SECTION_T','module');
update redcap_xml set text=replace(text,'REDCAP_QUESTION_T','question');
update redcap_xml set text=replace(text,'</ROW>','</forms>');
update redcap_xml set text=replace(text,'<ROW>','<forms>');
UPDATE redcap_xml set text=replace(text,'REDCAP_VALIDVALUE_T','validValue');
UPDATE redcap_xml set text=replace(text,'<modules__x0040_>'||chr(10) );
UPDATE redcap_xml set text=replace(text,'</modules__x0040_>'||chr(10) );
UPDATE redcap_xml set text=replace(text,'<questions__x0040_>'||chr(10) );--
UPDATE redcap_xml set text=replace(text,'</questions__x0040_>'||chr(10) );
UPDATE redcap_xml set text=replace(text,'<ROWSET>'||chr(10) ) ;
UPDATE redcap_xml set text=replace(text,'</ROWSET>'||chr(10) );--where protocol like'%PX0171001%';
UPDATE redcap_xml set text=replace(text,'</validValues__x0040_>'||chr(10) );
UPDATE redcap_xml set text=replace(text,'<validValues__x0040_>'||chr(10) );

UPDATE redcap_xml set text=replace(text,'<ROWSET>'||chr(10) ) ;
UPDATE redcap_xml set text=replace(text,'</ROWSET>'||chr(10) );
update redcap_xml set text=replace(text,'</ROW>','</forms>');
update redcap_xml set text=replace(text,'<ROW>','<forms>');

update redcap_xml set text=replace(text,'REDCAP_SECTION_T','module');
update redcap_xml set text=replace(text,'REDCAP_QUESTION_T','question');
UPDATE redcap_xml set text=replace(text,'REDCAP_VALIDVALUE_T','validValue');
UPDATE redcap_xml set text=replace(text,'<validValues__x0040_>'||chr(10) );
UPDATE redcap_xml set text=replace(text,'</validValues__x0040_>'||chr(10) );
UPDATE redcap_xml set text=replace(text,'<validValues__x0040_/>'||chr(10) );
UPDATE redcap_xml set text=replace(text,'CFR','CRF' );
--UPDATE redcap_xml set text=replace(text,'2016-08-01 16:20:20',TO_CHAR(SYSDATE,'YYYY-MM-DD')||'T00:00:00.0');
      
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into REPORTS_ERROR_LOG VALUES (l_file_name,  errmsg, sysdate);
    

END ;
/

