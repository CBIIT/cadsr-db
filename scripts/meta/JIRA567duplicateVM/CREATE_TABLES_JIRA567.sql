set serveroutput on size 1000000
SPOOL cadsrmeta-567a.log

 CREATE TABLE MDSR_VM_DUP_REF
(
  FIN_VM                NUMBER,
  FIN_IDSEQ             VARCHAR2(36 BYTE),
  VM_ID                 NUMBER,
  VM_IDSEQ              VARCHAR2(36 BYTE),
  CONDR_IDSEQ           VARCHAR2(60 BYTE),
  CONCEPTS_CODE         VARCHAR2(100 BYTE),  
  CONCEPTS_NAME         VARCHAR2(255 BYTE),
  LONG_NAME             VARCHAR2(255 BYTE),
  CONCEPT_SYNONYM       VARCHAR2(10 BYTE),
  PREFERRED_DEFINITION  VARCHAR2(2000 BYTE),  
  RUN_NUMBER            NUMBER,
  DES                   VARCHAR2(10 BYTE),
  DEFN                  VARCHAR2(10 BYTE),
  DES_CL                VARCHAR2(10 BYTE),
  DEFN_CL               VARCHAR2(10 BYTE),
  PROCESSED             VARCHAR2(10 BYTE),
  DATE_CREATED          DATE,
  DATE_INSERTED         DATE  
)
/ 
CREATE INDEX MDSR_VM_DUP_REF_IDX ON MDSR_VM_DUP_REF(VM_ID,decode(CONDR_IDSEQ,NULL,'A',CONDR_IDSEQ))
/
CREATE TABLE MDSR_CONCEPTS_SYNONYMS_TMP
(
  CODE          VARCHAR2(130 BYTE),
  CONCEPT_NAME  VARCHAR2(255 BYTE),
  SYNONYM_NAME  VARCHAR2(500 BYTE)
)
/
CREATE TABLE MDSR_CONCEPTS_SYNONYMS_LOAD
(
  CODE          VARCHAR2(130 BYTE),
  CONCEPT_NAME  VARCHAR2(255 BYTE),
  SYNONYM_NAME  VARCHAR2(500 BYTE),
  SYN VARCHAR2(5 BYTE)
)
/
CREATE TABLE MDSR_CONCEPTS_SYNONYMS
(
  CODE          VARCHAR2(30 BYTE),
  CONCEPT_NAME  VARCHAR2(255 BYTE),
  SYNONYM_NAME  VARCHAR2(500 BYTE)
)
/
CREATE INDEX CONCEPT_SYSN_IDX ON MDSR_CONCEPTS_SYNONYMS(CODE)
/
CREATE TABLE MDSR_VM_DUP_ERR
(
  SP_NAME       CHAR(36 BYTE),
  TABLE_NAME    CHAR(50 BYTE),
  BLOCK_NAME    CHAR(80 BYTE),
  IDSEQ         CHAR(80 BYTE),
  PUBLICK_ID    CHAR(2000 BYTE),
  ERROR_TEXT    VARCHAR2(2000 BYTE),
  DATE_CREATED  DATE
)
/
CREATE TABLE MDSR_SYNONYMS_XML
(
  CODE          VARCHAR2(30 BYTE),
  TRIM_NAME     VARCHAR2(3999 BYTE),
  LONG_NAME     CLOB,
  START_SYN     NUMBER,
  END_SYN       NUMBER,
  DATE_CREATED  DATE,
  CONCEPT_NAME  VARCHAR2(300 BYTE),
  RESP_STATUS   VARCHAR2(100 BYTE)
)
/
CREATE INDEX MDSR_SYNONYMS_XML_IDX ON MDSR_SYNONYMS_XML(CODE,'1')
/
 CREATE TABLE MDSR_VM_DUP_REF_TMP
(
  FIN_VM                NUMBER,  
  VM_ID                 NUMBER,  
  CONDR_IDSEQ           VARCHAR2(60 BYTE),
  CONCEPTS_CODE         VARCHAR2(100 BYTE),  
  CONCEPTS_NAME         VARCHAR2(255 BYTE),
  LONG_NAME             VARCHAR2(255 BYTE),
  CONCEPT_SYNONYM       VARCHAR2(10 BYTE),
  PREFERRED_DEFINITION  VARCHAR2(2000 BYTE),    
  DATE_CREATED          DATE, 
  FIN_IDSEQ             VARCHAR2(36 BYTE),
  VM_IDSEQ              VARCHAR2(36 BYTE))
/
CREATE OR REPLACE PUBLIC SYNONYM MDSR_VM_DUP_REF FOR MDSR_VM_DUP_REF;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_VM_DUP_ERR FOR MDSR_VM_DUP_ERR;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_VM_DUP_REF_TMP FOR MDSR_VM_DUP_REF_TMP;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_SYNONYMS_XML FOR MDSR_SYNONYMS_XML;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_CONCEPTS_SYNONYMS FOR MDSR_CONCEPTS_SYNONYMS;
GRANT SELECT ON MDSR_VM_DUP_REF TO PUBLIC;
GRANT SELECT ON MDSR_VM_DUP_ERR TO PUBLIC;
GRANT SELECT ON  MDSR_VM_DUP_REF_TMP TO PUBLIC;
GRANT SELECT ON  MDSR_SYNONYMS_XML TO PUBLIC;
GRANT SELECT ON  MDSR_CONCEPTS_SYNONYMS TO PUBLIC;
SPOOL OFF