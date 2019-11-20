set serveroutput on size 1000000
SPOOL cadsrmeta-759.log

CREATE OR REPLACE FORCE VIEW SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
(
    CS_IDSEQ,
    PREFERRED_NAME,
    LONG_NAME,
    PREFERRED_DEFINITION,
    VERSION,
    ASL_NAME,
    CS_CONTEXT_NAME,
    CS_CONTEXT_VERSION,
    CONTE_IDSEQ,
    CSI_NAME,
    CSITL_NAME,
    DESCRIPTION,
    CSI_ID,
    CSI_VERSION,
    CSI_IDSEQ,
    CSI_CONTEXT_NAME,
    CS_ID,
	cs_date_created,
	csi_date_created,
    CS_CSI_IDSEQ,
    CSI_LEVEL,
    LEAF,
    PARENT_CSI_IDSEQ
)
AS
    (    SELECT cs.cs_idseq,
                cs.preferred_name,
                cs.long_name,
                cs.preferred_definition,
                cs.version,
                cs.asl_name,
                cs_conte.name
                    cs_context_name,
                cs_conte.version
                    cs_context_version,
                cs.conte_idseq
                    conte_idseq,				
                csi.long_name
                    csi_name,
                csi.csitl_name,
                csi.preferred_definition
                    description,
                csi.csi_id,
                csi.version
                csi_version,
                csi.CSI_IDSEQ,
                csi_conte.name
                csi_context_name,					
                cs.cs_id,
				cs.date_created cs_date_created,
				csi.date_created csi_date_created,
                CS_CSI_IDSEQ,
                LEVEL,
                DECODE (CONNECT_BY_ISLEAF,  '1', 'FALSE',  '0', 'TRUE')
                    "IsLeaf",
                p_cs_csi_idseq
           FROM sbr.classification_schemes cs,
                sbr.cs_items            csi,
                sbr.cs_csi              csc,
                sbr.contexts            cs_conte,
                sbr.contexts            csi_conte
          WHERE     csc.cs_idseq = cs.cs_idseq
                AND csc.csi_idseq = csi.csi_idseq
                AND cs.conte_idseq = cs_conte.conte_idseq
                AND csi.conte_idseq = csi_conte.conte_idseq
                AND INSTR (csi.CSITL_NAME, 'testCaseMix') = 0
                AND csi_conte.name NOT IN ('TEST', 'Training')
                AND cs_conte.name NOT IN ('TEST', 'Training')
                AND cs.ASL_NAME = 'RELEASED'
     CONNECT BY PRIOR CS_CSI_IDSEQ = P_CS_CSI_IDSEQ
     START WITH P_CS_CSI_IDSEQ IS NULL);
/
GRANT SELECT ON SBREXT.MDSR_CLASS_SCHEME_ITEM_VW TO CDEBROWSER
/
GRANT SELECT ON SBREXT.MDSR_CLASS_SCHEME_ITEM_VW TO DER_USER
/
GRANT SELECT ON SBREXT.MDSR_CLASS_SCHEME_ITEM_VW TO GUEST
/
GRANT SELECT ON SBREXT.MDSR_CLASS_SCHEME_ITEM_VW TO READONLY
/
GRANT SELECT ON SBREXT.MDSR_CLASS_SCHEME_ITEM_VW TO SBR WITH GRANT OPTION
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_L5_T as object(
"CSILevel" number,
 "ClassificationSchemeItemName" VARCHAR2(255),
 "ClassificationSchemeItemType"   VARCHAR2(20),
 "PublicId"        NUMBER,
 "Version"          VARCHAR2(7), 
 "DateCreated"  VARCHAR2(40),
 "CSI_IDSEQ" VARCHAR2(60),
 "ParentIdseq" VARCHAR2(60), 
  --sc_csi_id VARCHAR2(60),
 "ParentPublicID"        NUMBER,
 "ParentVersion"          VARCHAR2(7),
 "AnyChildCSI" VARCHAR2(10))
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_LIST5_T as table of MDSR759_XML_CSI_L5_T
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_L4_T as object(
"CSILevel" number,
 "ClassificationSchemeItemName" VARCHAR2(255),
 "ClassificationSchemeItemType"   VARCHAR2(20),
 "PublicId"        NUMBER,
 "Version"          VARCHAR2(7), 
"DateCreated"  VARCHAR2(40),
 "CSI_IDSEQ" VARCHAR2(60),
 "ParentIdseq" VARCHAR2(60), 
--  sc_csi_id VARCHAR2(60),
 "ParentPublicID"        NUMBER,
 "ParentVersion"          VARCHAR2(7),
 "AnyChildCSI" VARCHAR2(10),
 "ChildCSIList" MDSR759_XML_CSI_LIST5_T) 
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_LIST4_T as table of MDSR759_XML_CSI_L4_T
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_L3_T as object(
"CSILevel" number,
 "ClassificationSchemeItemName" VARCHAR2(255),
 "ClassificationSchemeItemType"   VARCHAR2(20),
 "PublicId"        NUMBER,
 "Version"          VARCHAR2(7), 
"DateCreated"  VARCHAR2(40),
 "CSI_IDSEQ" VARCHAR2(60),
 "ParentIdseq" VARCHAR2(60), 
 -- sc_csi_id VARCHAR2(60),
 "ParentPublicID"        NUMBER,
 "ParentVersion"          VARCHAR2(7),
 "AnyChildCSI" VARCHAR2(10),
 "ChildCSIList" MDSR759_XML_CSI_LIST4_T) 
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_LIST3_T as table of MDSR759_XML_CSI_L3_T
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_L2_T as object(
"CSILevel" number,
 "ClassificationSchemeItemName" VARCHAR2(255),
 "ClassificationSchemeItemType"   VARCHAR2(20),
 "PublicId"        NUMBER,
 "Version"          VARCHAR2(7), 
"DateCreated"  VARCHAR2(40),
 "CSI_IDSEQ" VARCHAR2(60),
 "ParentIdseq" VARCHAR2(60), 
--sc_csi_id VARCHAR2(60),
 "ParentPublicID"        NUMBER,
 "ParentVersion"          VARCHAR2(7),
 "AnyChildCSI" VARCHAR2(10),
 "ChildCSIList" MDSR759_XML_CSI_LIST3_T) 
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_LIST2_T as table of MDSR759_XML_CSI_L2_T
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_L1_T as object(
"CSILevel" number,
 "ClassificationSchemeItemName" VARCHAR2(255),
 "ClassificationSchemeItemType"   VARCHAR2(20),
 "PublicId"        NUMBER,
 "Version"          VARCHAR2(7), 
"DateCreated"  VARCHAR2(40),
 "CSI_IDSEQ" VARCHAR2(60),
 "ParentIdseq" VARCHAR2(60), 
--  sc_csi_id VARCHAR2(60),
 "ParentPublicID"        NUMBER,
 "ParentVersion"          VARCHAR2(7),
 "AnyChildCSI" VARCHAR2(10),
 "ChildCSIList" MDSR759_XML_CSI_LIST2_T) 
/
CREATE OR REPLACE TYPE MDSR759_XML_CSI_LIST1_T as table of MDSR759_XML_CSI_L1_T
/
CREATE OR REPLACE TYPE MDSR759_XML_CS_L5_T as object(
"PublicId"        NUMBER,
"PreferredName" VARCHAR2(60),
"LongName" VARCHAR2(255),
"Version"          VARCHAR2(7),
"DateCreated"  VARCHAR2(40),
"ClassificationItem_LIST"  MDSR759_XML_CSI_LIST1_T)
/
CREATE OR REPLACE TYPE MDSR759_XML_CS_L5_LIST_T  as table of MDSR759_XML_CS_L5_T
/
CREATE OR REPLACE TYPE MDSR759_XML_Context_T1   as object(
"PreferredName" VARCHAR(60),
"Version"          VARCHAR2(7),
--"ContextID" VARCHAR(60),
"ClassificationScheme" MDSR759_XML_CS_L5_LIST_T)
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L5_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L5_T TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST5_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST5_T TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L4_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L4_T TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST4_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST4_T TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L3_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L3_T TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST3_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST3_T TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L2_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L2_T TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST2_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST2_T TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L1_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L1_T TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST1_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST1_T TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CS_L5_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CS_L5_T TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CS_L5_LIST_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CS_L5_LIST_T TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_Context_T1 TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_Context_T1 TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L5_T TO GUEST
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST5_T TO GUEST
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L4_T TO GUEST
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST4_T TO GUEST
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L3_T TO GUEST
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST3_T TO GUEST
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L2_T TO GUEST
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST2_T TO GUEST
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L1_T TO GUEST
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST1_T TO GUEST
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CS_L5_T TO GUEST
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CS_L5_LIST_T TO GUEST
/
GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_Context_T1 TO GUEST
/
CREATE OR REPLACE FORCE VIEW SBREXT.MDSR_759XML_5CSI_LEVEL_VIEW
(
    "PreferredName",
    "Version",
    "ClassificationList"
)
AS
    SELECT CS_CONTEXT_NAME,
           CS_CONTEXT_VERSION,
           CAST (
               MULTISET (  SELECT CS_ID,
                                  PREFERRED_NAME,
                                  LONG_NAME,
                                  VERSION,
								  cs_date_created,
                                  CAST (
                                      MULTISET (
                                            SELECT v1.CSI_LEVEL,
                                                   v1.CSI_NAME,
                                                   v1.CSITL_NAME,
                                                   v1.CSI_ID,
                                                   v1.CSI_VERSION,
												   v1.csi_date_created,
                                                   v1.CSI_IDSEQ,
                                                   '',
                                                   NULL,
                                                   '',
                                                   v1.LEAF,
                                                   CAST (
                                                       MULTISET (
                                                             SELECT v2.CSI_LEVEL,
                                                                    v2.CSI_NAME,
                                                                    v2.CSITL_NAME,
                                                                    v2.CSI_ID,
                                                                    v2.CSI_VERSION,
																	v2.csi_date_created,
                                                                    v2.CSI_IDSEQ,
                                                                    v2.PARENT_CSI_IDSEQ,
                                                                    v1.CSI_ID,
                                                                    v1.CSI_VERSION,
                                                                    v2.LEAF,
                                                                    CAST (
                                                                        MULTISET (
                                                                              SELECT v3.CSI_LEVEL,
                                                                                     v3.CSI_NAME,
                                                                                     v3.CSITL_NAME,
                                                                                     v3.CSI_ID,
                                                                                     v3.CSI_VERSION,
																					 v3.csi_date_created,
                                                                                     v3.CSI_IDSEQ,
                                                                                     v3.PARENT_CSI_IDSEQ,
                                                                                     v2.CSI_ID,
                                                                                     v2.CSI_VERSION,
                                                                                     v3.LEAF,
                                                                                     CAST (
                                                                                         MULTISET (
                                                                                               SELECT v4.CSI_LEVEL,
                                                                                                      v4.CSI_NAME,
                                                                                                      v4.CSITL_NAME,
                                                                                                      v4.CSI_ID,
                                                                                                      v4.CSI_VERSION,
																									  v4.csi_date_created,
                                                                                                      v4.CSI_IDSEQ,
                                                                                                      v4.PARENT_CSI_IDSEQ,
                                                                                                      v3.CSI_ID,
                                                                                                      v3.CSI_VERSION,
                                                                                                      v4.LEAF,
                                                                                                      CAST (
                                                                                                          MULTISET (
                                                                                                                SELECT v5.CSI_LEVEL,
                                                                                                                       v5.CSI_NAME,
                                                                                                                       v5.CSITL_NAME,
                                                                                                                       v5.CSI_ID,
                                                                                                                       v5.CSI_VERSION,
 v5.csi_date_created,                                                                                                                      v5.CSI_IDSEQ,
                                                                                                                       v5.PARENT_CSI_IDSEQ,
                                                                                                                       v4.CSI_ID,
                                                                                                                       v4.CSI_VERSION,
                                                                                                                       v5.LEAF
                                                                                                                  FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
                                                                                                                       v5
                                                                                                                 --   ,(select* from  SBREXT.MDSR_CLASS_SCHEME_ITEM_VW  where CSI_LEVEL=4)v4
                                                                                                                 WHERE     v5.PARENT_CSI_IDSEQ =
                                                                                                                           v4.CS_CSI_IDSEQ
                                                                                                                       AND v5.CSI_LEVEL =
                                                                                                                           5
                                                                                                              --   group by csi.CSI_LEVEL,   csi.CSI_ID
                                                                                                              ORDER BY v5.CSI_ID)
                                                                                                              AS MDSR759_XML_CSI_LIST5_T)
                                                                                                          "level5"
                                                                                                 FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
                                                                                                      V4
                                                                                                WHERE     V4.CSI_LEVEL =
                                                                                                          4
                                                                                                      AND v4.PARENT_CSI_IDSEQ =
                                                                                                          v3.CS_CSI_IDSEQ
                                                                                             ORDER BY v4.CSI_ID)
                                                                                             AS MDSR759_XML_CSI_LIST4_T)
                                                                                         "level4"
                                                                                FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
                                                                                     V3
                                                                               WHERE     CSI_LEVEL =
                                                                                         3 --4551586
                                                                                     AND v3.PARENT_CSI_IDSEQ =
                                                                                         v2.CS_CSI_IDSEQ
                                                                            ORDER BY v3.CSI_ID)
                                                                            AS MDSR759_XML_CSI_LIST3_T)
                                                                        "level3"
                                                               FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
                                                                    V2
                                                              WHERE     CSI_LEVEL =
                                                                        2
                                                                    AND v2.PARENT_CSI_IDSEQ =
                                                                        v1.CS_CSI_IDSEQ
                                                           ORDER BY v2.CSI_ID)
                                                           AS MDSR759_XML_CSI_LIST2_T)    "level2"
                                              FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
                                                   V1
                                             WHERE     CSI_LEVEL = 1
                                                   AND V1.CS_IDSEQ =
                                                       cl.CS_IDSEQ
                                          ORDER BY v1.CSI_ID)
                                          AS MDSR759_XML_CSI_LIST1_T)    "ClassificationItemList"
                             FROM (SELECT DISTINCT CS_IDSEQ,
                                                   CS_ID,
                                                   PREFERRED_NAME,
                                                   LONG_NAME,
                                                   PREFERRED_DEFINITION,
                                                   VERSION,
												   CS_DATE_CREATED,
                                                   ASL_NAME,
                                                   CS_CONTEXT_NAME,
                                                   CS_CONTEXT_VERSION,
                                                   conte_idseq
                                     FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW) cl
                            WHERE cl.conte_idseq = con.CONTEXT_ID
                         ORDER BY CS_ID) AS MDSR759_XML_CS_L5_LIST_T)    "ClassificationList"
      FROM (  SELECT DISTINCT
                     CS_CONTEXT_NAME,
                     CS_CONTEXT_VERSION,
                     conte_idseq     CONTEXT_ID
                FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
            ORDER BY CS_CONTEXT_NAME) con;


GRANT SELECT ON SBREXT.MDSR_759XML_5CSI_LEVEL_VIEW TO READONLY
/
GRANT SELECT ON SBREXT.MDSR_759XML_5CSI_LEVEL_VIEW TO SBR WITH GRANT OPTION
/
GRANT SELECT ON SBREXT.MDSR_759XML_5CSI_LEVEL_VIEW TO GUEST
/

/
CREATE TABLE SBREXT.MDSR_REPORTS_ERR_LOG
(
  FILE_NAME         VARCHAR2(50 BYTE),
  REPORT_ERROR_TXT  VARCHAR2(1100 BYTE),
  DATE_PROCESSED    DATE
)
/
GRANT SELECT ON SBREXT.MDSR_REPORTS_ERR_LOG TO READONLY
/
GRANT SELECT ON SBREXT.MDSR_REPORTS_ERR_LOG TO SBR WITH GRANT OPTION
/
GRANT SELECT ON SBREXT.MDSR_REPORTS_ERR_LOG TO GUEST
/
CREATE TABLE SBREXT.MDSR_GENERATED_XML
(
  FILE_NAME     VARCHAR2(200 BYTE),
  TEXT          CLOB,
  CREATED_DATE  DATE                            DEFAULT SYSDATE,
  SEQ_ID        NUMBER
)
/
GRANT SELECT ON SBREXT.MDSR_GENERATED_XML TO READONLY
/
GRANT SELECT ON SBREXT.MDSR_GENERATED_XML TO GUEST
/
GRANT SELECT ON SBREXT.MDSR_GENERATED_XML TO SBR WITH GRANT OPTION
/
CREATE OR REPLACE PROCEDURE SBREXT.MSDR_XML759_Insert as
/*insert XML*/
P_file number;
l_file_name      VARCHAR2(100);
l_file_path      VARCHAR2(200);
l_result         CLOB:=null;
l_xmldoc          CLOB:=null; 
errmsg VARCHAR2(500):='Non';
  
BEGIN
 
select count(*) into P_file from SBREXT.MDSR_GENERATED_XML;
IF P_file>0 then
 select max(NVL(SEQ_ID,0))+1 into P_file from SBREXT.MDSR_GENERATED_XML;
end if;
        l_file_path := 'SBREXT_DIR';
       
         l_file_name := 'CS_CSI_XML_'||P_file||'.xml';

        SELECT dbms_xmlgen.getxml( 'select* from MDSR_759XML_5CSI_LEVEL_VIEW')
        INTO l_result
        FROM DUAL ;
        insert into SBREXT.MDSR_GENERATED_XML VALUES ( l_file_name ,l_result,SYSDATE,P_file);      

 commit;
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into SBREXT.MDSR_REPORTS_ERR_LOG VALUES (l_file_name,  errmsg, sysdate);
 commit;

END ;
/
CREATE OR REPLACE PROCEDURE SBREXT.MDSR_XML_TRANSFORM IS

P_file number;
l_file_name VARCHAR2(500) ;
 errmsg VARCHAR2(500):='Non';
 
BEGIN
select max(SEQ_ID) into P_file from SBREXT.MDSR_GENERATED_XML;
select FILE_NAME into l_file_name from SBREXT.MDSR_GENERATED_XML where SEQ_ID=P_file;


update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CS_L5_T','ClassificationScheme') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CSI_L1_T','CSI') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CSI_L2_T','CSI') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CSI_L3_T','CSI') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CSI_L4_T','CSI') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CSI_L5_T','CSI') where SEQ_ID=P_FILE;

UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'ROWSET','Classifications' ) where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'</ROW>','</Context>') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'<ROW>','<Context>') where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'<ChildCSIList>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'</ChildCSIList>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'<ChildCSIList/>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'<ClassificationItem_LIST>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'<ClassificationItem_LIST/>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'</ClassificationItem_LIST>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'<ClassificationList>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'<ClassificationList/>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'</ClassificationList>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'ParentIdseq','ParentChildIdseq' ) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'<?xml version="1.0"?>','<?xml version="1.0" encoding="UTF-8"?>') where SEQ_ID=P_FILE;
--UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'2016-08-01 16:20:20',TO_CHAR(SYSDATE,'YYYY-MM-DD')||'T00:00:00.0') where SEQ_ID=P_FILE;
 commit;
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into MDSR_REPORTS_ERR_LOG VALUES (l_file_name,  errmsg, sysdate);
 commit;

END ;
/
CREATE OR REPLACE PROCEDURE SBREXT.MSDR_GEN_XML_CLCSI AS
BEGIN
  delete  from SBREXT.MDSR_GENERATED_XML where CREATED_DATE<SYSDATE-7;
  commit;
  SBREXT.MSDR_XML759_Insert;
  SBREXT.MDSR_XML_TRANSFORM;
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'MSDR_GEN_XML_CLCSI_JOB',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBREXT.MSDR_GEN_XML_CLCSI',
   start_date         =>  '13-NOV-19 11.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY',
   enabled            =>  TRUE);

END;
/
SPOOL OFF;
