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
,"description" VARCHAR2(2000));
CREATE OR REPLACE TYPE REDCAP_validValue_LIST_T AS TABLE OF REDCAP_validValue_T ;     
 
CREATE OR REPLACE TYPE REDCAP_INSTRUCTIONS_T as object(
"text" VARCHAR2(1000));   
    
CREATE OR REPLACE TYPE REDCAP_PROTOCOL_T as object(
"protocolID" VARCHAR2(50),
"longName"  VARCHAR2(200),
"context"   VARCHAR2(10),
"shortName"  VARCHAR2(50),
"preferredDefinition"  VARCHAR2(2000)); 


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
CREATE OR REPLACE TYPE  REDCAP_INSTRUCTIONS_T as object(
"text" VARCHAR2(2000))
/ 

CREATE OR REPLACE TYPE REDCAP_QUESTION_LIST_T AS TABLE OF REDCAP_QUESTION_T  ;

 
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
                               FROM MSDRDEV.MSDREDCAP_FORM_CSV) p,
                            MSDRDEV.REDCAP_XML_GROUP_CSV_VW g,
                            sbrext.protocols_ext           pe
                      WHERE     p.protocol = g.protocol
                            AND pe.preferred_name = p.protocol
                            AND g.GROUP_NUMBER = v.GROUP_NUMBER
                   ORDER BY p.protocol, form_name_new)
                   AS MSDRDEV.REDCAP_FORM_LIST_T)    AS "group"
      FROM REDCOP_PR_GROUP_CSV_VW v;
/
