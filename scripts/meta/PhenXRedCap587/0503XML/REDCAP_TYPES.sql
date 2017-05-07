DROP VIEW SBREXT.REDCAP_FORM_COLLECT_VW;
drop type REDCAP_FORM_LIST_T;
drop type REDCAP_FORM_S;
drop type SBREXT.REDCAP_PROTOCOL_T;
drop type REDCAP_SECTION_LIST_T;
drop type REDCAP_SECTION_T;
drop type REDCAP_QUESTION_LIST_T;
drop type REDCAP_QUESTION_T;
drop type REDCAP_INSTRUCTIONS_T;
drop type REDCAP_validValue_LIST_T;
drop type REDCAP_validValue_T;

CREATE OR REPLACE TYPE SBREXT.REDCAP_validValue_T as object(
"displayOrder" NUMBER
,"value" VARCHAR2(2000)
,"meaningText" VARCHAR2(2000) 
,"description" VARCHAR2(2000))
/
CREATE OR REPLACE TYPE SBREXT.REDCAP_validValue_LIST_T AS TABLE OF REDCAP_validValue_T 
/ 
CREATE OR REPLACE TYPE SBREXT.REDCAP_INSTRUCTIONS_T as object("text" VARCHAR2(2000))
/
CREATE OR REPLACE TYPE SBREXT.REDCAP_PROTOCOL_T as object(
"protocolID" VARCHAR2(50),
"longName" VARCHAR2(200),
"context" VARCHAR2(10),
"shortName" VARCHAR2(50),
"preferredDefinition" VARCHAR2(2000))
/
CREATE OR REPLACE TYPE SBREXT.REDCAP_QUESTION_T as object(
"publicID" NUMBER,
"version" VARCHAR2(8),
"isDerived" VARCHAR2(8),
"displayOrder" NUMBER,
"dateCreated" VARCHAR2(30),
"questionText" VARCHAR2(4000),
"instruction" REDCAP_INSTRUCTIONS_T,
"isEditable" VARCHAR2(8),
"isMandatory" VARCHAR2(8),
"multiValue" VARCHAR2(8),
"validValues_xx" REDCAP_validValue_LIST_T )
/
CREATE OR REPLACE TYPE SBREXT.REDCAP_QUESTION_LIST_T AS TABLE OF SBREXT.REDCAP_QUESTION_T 
/ 
CREATE OR REPLACE
TYPE         SBREXT.REDCAP_SECTION_T    as object(
"displayOrder"                                     NUMBER
,"maximumModuleRepeat"                              NUMBER
,"createdBy"   VARCHAR2(40)
,"dateCreated" VARCHAR2(30)
,"longName"    VARCHAR2(2000)   
--,"instruction" REDCAP_INSTRUCTIONS_T   
, "preferredDefinition" VARCHAR2(2000)

,"questions_xx"   REDCAP_QUESTION_LIST_T )
/
/
CREATE OR REPLACE TYPE SBREXT.REDCAP_SECTION_LIST_T AS TABLE OF SBREXT.REDCAP_SECTION_T 
/ 
CREATE OR REPLACE TYPE SBREXT.REDCAP_FORM_S as object( 
"context" VARCHAR2(40)
,"createdBy" VARCHAR2(100)
,"dateCreated" VARCHAR2(30)
,"longName" VARCHAR2(150) 
,"changeNote" VARCHAR2(40)
,"preferredDefinition" VARCHAR2(2000)
,"cadsrRAI" VARCHAR2(40)
,"publicid" NUMBER
,"version" NUMBER
,"workflowStatusName" VARCHAR2(40)
,"type" VARCHAR2(5) 
,"headerInstruction" VARCHAR2(100) 
,"footerInstruction" VARCHAR2(100)
,"modules_xx" REDCAP_SECTION_LIST_T
,"protocol" REDCAP_PROTOCOL_T)
/ 
CREATE OR REPLACE TYPE SBREXT.REDCAP_FORM_LIST_T AS TABLE OF SBREXT.REDCAP_FORM_S
/
CREATE OR REPLACE FORCE VIEW SBREXT.REDCAP_FORM_COLLECT_VW
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
 TO_CHAR (SYSDATE, 'YYYY-MM-DD') ||'T'|| TO_CHAR (SYSDATE, 'HH24:MI:SS'), 
 SUBSTR (p.protocol || p.form_name, 9),
 'Uploaded via FormLoader',
 UTL_I18N.UNESCAPE_REFERENCE( TRIM (p.preferred_definition)),
 '2.16.840.1.113883.3.26.2',
 '',
 '1.0',
 'DRAFT NEW',
 'CRF',
 '',
 '',
 CAST (
 MULTISET (
 SELECT NVL (TRIM (s.SECTION_SEQ), '0'),
 '0',
 'panh',
 TO_CHAR (SYSDATE, 'YYYY-MM-DD')
 || 'T'
 || TO_CHAR (SYSDATE, 'HH24:MI:SS'),
 NVL (TRIM (s.SECTION), 'N/A'),
 NVL (TRIM (s.SECTION), 'No definition'),
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
 TRIM (q.field_label)),
 REDCAP_INSTRUCTIONS_T (
 SUBSTR (
 TRIM (
 UTL_I18N.UNESCAPE_REFERENCE (
 q.INSTRUCTIONS)),
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
 TRIM (VAL_VALUE),
 TRIM (VAL_VALUE)
 FROM REDCAP_VALUE_CODE u
 WHERE u.question(+) =
 q.question
 AND u.protocol(+) =
 q.protocol
 ORDER BY VAL_ORDER) AS REDCAP_validValue_LIST_T)
 "ValidValue"
 FROM REDCAP_PROTOCOL_NEW q
 WHERE 1 = 1
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
 FROM (SELECT DISTINCT
 protocol, form_name, preferred_definition
 FROM REDCAP_PROTOCOL_FORM) p,
 SBREXT.REDCAP_XML_GROUP g,
 protocols_ext pe
 WHERE p.protocol = g.protocol
 AND pe.preferred_name = p.protocol
 AND g.GROUP_NUM = v.GROUP_NUM
 --AND g.GROUP_NUM in (1,2)
 ORDER BY p.protocol, form_name) AS SBREXT.REDCAP_FORM_LIST_T)--.REDCAP_FORM_S 
 AS "group"
 FROM REDCOP_PR_GROUP_VW v
	 
	 
	 DROP VIEW SBREXT.REDCAP_FORM_COLLECT_VW;

/* Formatted on 4/9/2017 8:13:36 PM (QP5 v5.269.14213.34769) */
CREATE OR REPLACE FORCE VIEW SBREXT.REDCAP_FORM_COLLECT_VW
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
 '',
 '',
 CAST (
 MULTISET (
 SELECT NVL (TRIM (s.SECTION_SEQ), '0'),
 '0',
 'panh',
 TO_CHAR (SYSDATE, 'YYYY-MM-DD')
 || 'T'
 || TO_CHAR (SYSDATE, 'HH24:MI:SS'),
 NVL (TRIM (s.SECTION), INITCAP(REPLACE 
 ( REPLACE(LOWER(TRIM(form_name)), '_', ' '),
 'phenx',''))),
 NVL (TRIM (s.SECTION), 'No definition'),
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
 NVL(q.INSTRUCTIONS,'N/A'))),
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
 TRIM (VAL_name_new),
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
 WHERE u.question(+) =
 q.question
 AND u.protocol(+) =
 q.protocol
 ORDER BY VAL_ORDER) AS REDCAP_validValue_LIST_T)
 "ValidValue"
 FROM REDCAP_PROTOCOL_NEW q
 WHERE 1 = 1
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
 FROM (SELECT DISTINCT
 protocol, form_name, preferred_definition
 FROM REDCAP_PROTOCOL_FORM) p,
 SBREXT.REDCAP_XML_GROUP g,
 protocols_ext pe
 WHERE p.protocol = g.protocol
 AND pe.preferred_name = p.protocol
 AND g.GROUP_NUM = v.GROUP_NUM
 AND g.GROUP_NUM <20
 ORDER BY p.protocol, form_name) AS SBREXT.REDCAP_FORM_LIST_T) --.REDCAP_FORM_S
 AS "group"
 FROM REDCOP_PR_GROUP_VW v;
