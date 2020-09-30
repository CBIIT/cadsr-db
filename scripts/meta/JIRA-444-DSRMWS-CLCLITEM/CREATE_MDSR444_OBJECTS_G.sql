CREATE TABLE ONEDATA_WA.PC_CS_CSI
(
  CS_CSI_IDSEQ      CHAR(36 BYTE)               NOT NULL,
  P_CS_CSI_IDSEQ    CHAR(36 BYTE),
  NCI_PUB_ID        NUMBER,
  P_NCI_PUB_ID      NUMBER,
  NCI_PUB_VER_NM    NUMBER(4,2),
  P_NCI_PUB_VER_NM  NUMBER(4,2)
);
insert into ONEDATA_WA.PC_CS_CSI values(CS_CSI_IDSEQ,P_CS_CSI_IDSEQ) as select CS_CSI_IDSEQ,P_CS_CSI_IDSEQ FROM SBR.SC_CSI;
MERGE INTO PC_CS_CSI s1 USING NCI_ADMIN_ITEM_REL_ALT_KEY s2 ON (s1.CS_CSI_IDSEQ = s2.NCI_IDSEQ) 
WHEN MATCHED THEN UPDATE SET s1.NCI_PUB_ID = s2.NCI_PUB_ID,s1.NCI_PUB_VER_NM = s2.NCI_VER_NR;

MERGE INTO PC_CS_CSI s1 USING NCI_ADMIN_ITEM_REL_ALT_KEY s2 ON (s1.P_CS_CSI_IDSEQ = s2.NCI_IDSEQ) 
WHEN MATCHED THEN UPDATE SET s1.P_NCI_PUB_ID = s2.NCI_PUB_ID,s1.P_NCI_PUB_VER_NM = s2.NCI_VER_NR;

CREATE OR REPLACE FORCE VIEW REL_CLASS_SCHEME_ITEM_VW
AS  SELECT  NODE.CNTXT_CS_ITEM_ID CS_ID,
            NODE.CNTXT_CS_VER_NR CS_VERSION, 
            CS.ITEM_LONG_NM PREFERRED_NAME,
            CS.ITEM_NM LONG_NAME,
            CSI.ITEM_DESC PREFERRED_DEFINITION,  
            cs.ADMIN_STUS_NM_DN  ASL_NAME,
            CS.CNTXT_NM_DN CS_CONTEXT_NAME,
            CS.CNTXT_VER_NR CS_CONTEXT_VERSION,
            -- CONTE_IDSEQ,
            NODE.NCI_PUB_ID,
            NODE.NCI_VER_NR,            
            NODE.C_ITEM_ID CSI_ID,
            NODE.C_item_ver_nr CSI_VERSION,           
            O.NCI_CD       CSITL_NAME,            
            -- CSI.ITEM_NM,
            CSI.ITEM_NM CSI_NAME,
            CSI.ITEM_DESC description,
            CSI.CNTXT_NM_DN CSI_CONTEXT_NAME,
            CSI.CNTXT_VER_NR CSI_CONTEXT_VERSION,
            CS.CREAT_DT  CS_DATE_CREATED,
            CSI.CREAT_DT  CSI_DATE_CREATED,                       
          --  LEVEL CSI_LEVEL,
           -- DECODE (CONNECT_BY_ISLEAF,  '1', 'FALSE',  '0', 'TRUE') "IsLeaf", 
            NODE.P_ITEM_ID P_CSI_ID,
            NODE.p_item_ver_nr P_CSI_VERSION ,
            NODE.NCI_IDSEQ,
             LEVEL CSI_LEVEL,
                DECODE (CONNECT_BY_ISLEAF,  '1', 'FALSE',  '0', 'TRUE')
                    "IsLeaf",
            P.CS_CSI_IDSEQ,
            P_CS_CSI_IDSEQ
    FROM 
       NCI_ADMIN_ITEM_REL_ALT_KEY  NODE,
       admin_item                  CS,
       admin_item                  CSI,  
       NCI_CLSFCTN_SCHM_ITEM  NCSI,
       OBJ_KEY                     O   ,
       PC_CS_CSI p   
    WHERE cs.ADMIN_ITEM_TYP_ID = 9
        AND cs.ADMIN_STUS_NM_DN ='RELEASED'
        AND csi.ADMIN_ITEM_TYP_ID = 51
        AND node.c_item_id = csi.item_id
        AND node.c_item_ver_nr = csi.ver_nr
        AND csi.item_id = ncsi.item_id
        AND csi.ver_nr = ncsi.ver_nr
        AND ncsi.CSI_TYP_ID = o.obj_key_id
        AND node.cntxt_cs_item_id = cs.item_id
        AND node.cntxt_cs_Ver_nr = cs.ver_nr
        AND node.rel_typ_id = 64
        AND INSTR (O.NCI_CD, 'testCaseMix') = 0  
      --  AND C_ITEM_ID=3070841
        AND CS.CNTXT_NM_DN  NOT IN ('TEST', 'Training')
        AND CSI.CNTXT_NM_DN  NOT IN ('TEST', 'Training')
        AND NODE.NCI_IDSEQ=P.CS_CSI_IDSEQ
        CONNECT BY PRIOR CS_CSI_IDSEQ = P_CS_CSI_IDSEQ
     START WITH P_CS_CSI_IDSEQ IS NULL  
     ORDER BY CNTXT_CS_ITEM_ID,C_ITEM_ID,P_ITEM_ID--,LEVEL ,;
        /
GRANT SELECT ON ONEDATA_WA.REL_CLASS_SCHEME_ITEM_VW TO PUBLIC ;
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
GRANT EXECUTE, DEBUG ON MDSR759_XML_CSI_L5_T TO PUBLIC
/
GRANT EXECUTE, DEBUG ON MDSR759_XML_CSI_LIST5_T TO PUBLIC
/
GRANT EXECUTE, DEBUG ON MDSR759_XML_CSI_L4_T TO PUBLIC
/
GRANT EXECUTE, DEBUG ON MDSR759_XML_CSI_LIST4_T TO PUBLIC
/
GRANT EXECUTE, DEBUG ON MDSR759_XML_CSI_L3_T TO PUBLIC
/
GRANT EXECUTE, DEBUG ON MDSR759_XML_CSI_LIST3_T TO PUBLIC
/
GRANT EXECUTE, DEBUG ON MDSR759_XML_CSI_L2_T TO PUBLIC
/
GRANT EXECUTE, DEBUG ON MDSR759_XML_CSI_LIST2_T TO PUBLIC
/
GRANT EXECUTE, DEBUG ON MDSR759_XML_CSI_L1_T TO PUBLIC
/
GRANT EXECUTE, DEBUG ON MDSR759_XML_CSI_LIST1_T TO PUBLIC
/
GRANT EXECUTE, DEBUG ON MDSR759_XML_CS_L5_T TO PUBLIC
/
GRANT EXECUTE, DEBUG ON MDSR759_XML_CS_L5_LIST_T TO PUBLIC
/
GRANT EXECUTE, DEBUG ON MDSR759_XML_Context_T1 TO PUBLIC
/
DROP VIEW ONEDATA_WA.MDSR444XML_5CSI_LEVEL_VIEW;

/* Formatted on 9/28/2020 10:44:13 AM (QP5 v5.354) */
CREATE OR REPLACE FORCE VIEW ONEDATA_WA.MDSR444XML_5CSI_LEVEL_VIEW
(
    "PreferredName",
    "Version",
    "ClassificationList"
)
BEQUEATH DEFINER
AS
    SELECT CS_CONTEXT_NAME,
           CS_CONTEXT_VERSION,
           CAST (MULTISET (  SELECT CS_ID,
                                    PREFERRED_NAME,
                                    LONG_NAME,
                                    CS_VERSION,
                                    cs_date_created,
                                    CAST (
                                        MULTISET (
                                              SELECT v1.CSI_LEVEL,
                                                     v1.CSI_NAME,
                                                     v1.CSITL_NAME,
                                                     v1.CSI_ID,
                                                     v1.CSI_VERSION,
                                                     v1.csi_date_created,
                                                     A.NCI_IDSEQ,
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
                                                                      A.NCI_IDSEQ,
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
                                                                                       A.NCI_IDSEQ,
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
                                                                                                        A.NCI_IDSEQ,
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
                                                                                                                         v5.csi_date_created,
                                                                                                                         A.NCI_IDSEQ,
                                                                                                                         v5.PARENT_CSI_IDSEQ,
                                                                                                                         v4.CSI_ID,
                                                                                                                         v4.CSI_VERSION,
                                                                                                                         v5.LEAF
                                                                                                                    FROM REL_CLASS_SCHEME_ITEM_VW
                                                                                                                         v5, ADMIN_ITEM a
                                                                                                                   --   ,(select* from  REL_CLASS_SCHEME_ITEM_VW  where CSI_LEVEL=4)v4
                                                                                                                   WHERE a.ITEM_ID= v5.CSI_ID
                                                                                                                   AND a.VER_NR= v5.CSI_VERSION
                                                                                                                        AND v5.PARENT_CSI_IDSEQ =v4.CS_CSI_IDSEQ
                                                                                                                           
                                                                                                                         AND v5.CSI_LEVEL =
                                                                                                                             5
                                                                                                                --   group by csi.CSI_LEVEL,   csi.CSI_ID
                                                                                                                ORDER BY v5.CSI_ID)
                                                                                                                AS MDSR759_XML_CSI_LIST5_T)
                                                                                                            "level5"
                                                                                                   FROM REL_CLASS_SCHEME_ITEM_VW V4,
                                                                                                               ADMIN_ITEM a
                                                                                                                   --   ,(select* from  REL_CLASS_SCHEME_ITEM_VW  where CSI_LEVEL=4)v4
                                                                                                                   WHERE a.ITEM_ID= v4.CSI_ID
                                                                                                                        AND V4.CSI_LEVEL =  4
                                                                                                        AND v4.PARENT_CSI_IDSEQ =
                                                                                                            v3.CS_CSI_IDSEQ
                                                                                               ORDER BY v4.CSI_ID)
                                                                                               AS MDSR759_XML_CSI_LIST4_T)
                                                                                           "level4"
                                                                                  FROM REL_CLASS_SCHEME_ITEM_VW V3,
                                                                                  ADMIN_ITEM a
                                                                                                                   --   ,(select* from  REL_CLASS_SCHEME_ITEM_VW  where CSI_LEVEL=4)v4
                                                                                  WHERE a.ITEM_ID= v3.CSI_ID
                                                                                         AND CSI_LEVEL =3 --4551586
                                                                                       AND v3.PARENT_CSI_IDSEQ =
                                                                                           v2.CS_CSI_IDSEQ
                                                                              ORDER BY v3.CSI_ID)
                                                                              AS MDSR759_XML_CSI_LIST3_T)
                                                                          "level3"
                                                                 FROM REL_CLASS_SCHEME_ITEM_VW   V2,
                                                                                  ADMIN_ITEM a
                                                                WHERE a.ITEM_ID= v2.CSI_ID
                                                                  AND    CSI_LEVEL =2
                                                                      AND v2.PARENT_CSI_IDSEQ =
                                                                          v1.CS_CSI_IDSEQ
                                                             ORDER BY v2.CSI_ID)
                                                             AS MDSR759_XML_CSI_LIST2_T)    "level2"
                                                FROM REL_CLASS_SCHEME_ITEM_VW V1,
                                                     ADMIN_ITEM a
                                                WHERE  a.ITEM_ID= v1.CSI_ID   
                                                   AND a.VER_NR= v1.CSI_VERSION                                                             
                                                   AND v1.CS_ID=cl.CS_ID 
                                                   AND CSI_LEVEL = 1
                                                   AND v1.CS_VERSION=cl.CS_VERSION
                                                         
                                            ORDER BY v1.CSI_ID)
                                            AS MDSR759_XML_CSI_LIST1_T)    "ClassificationItemList"
                               FROM (SELECT DISTINCT a.NCI_IDSEQ CS_IDSEQ,
                                                     CS_ID,
                                                     CS_VERSION,
                                                     PREFERRED_NAME,
                                                     LONG_NAME,
                                                     PREFERRED_DEFINITION,                                                     
                                                     CS_DATE_CREATED,
                                                     ASL_NAME,
                                                     CS_CONTEXT_NAME,
                                                     CS_CONTEXT_VERSION,
                                                     CS_CONTEXT_ID
                                       FROM REL_CLASS_SCHEME_ITEM_VW v,
                                                     ADMIN_ITEM a
                                               WHERE  a.ITEM_ID= v.CSI_ID
                                               and v.CS_VERSION=a.VER_NR) cl
                              WHERE cl.CS_CONTEXT_ID = con.CS_CONTEXT_ID
                              and cl.CS_CONTEXT_VERSION = con.CS_CONTEXT_VERSION
                           ORDER BY CS_ID) AS MDSR759_XML_CS_L5_LIST_T)    "ClassificationList"
      FROM (  SELECT DISTINCT
                     CS_CONTEXT_NAME,
                     CS_CONTEXT_VERSION,
                     CS_CONTEXT_ID
                FROM REL_CLASS_SCHEME_ITEM_VW
            ORDER BY CS_CONTEXT_NAME) con;



GRANT SELECT ON MDSR444XML_5CSI_LEVEL_VIEW TO PUBLIC;



/
CREATE TABLE MDSR_REPORTS_ERR_LOG
(
  FILE_NAME         VARCHAR2(50 BYTE),
  REPORT_ERROR_TXT  VARCHAR2(1100 BYTE),
  DATE_PROCESSED    DATE
)
/
GRANT SELECT ON MDSR_REPORTS_ERR_LOG TO PUBLIC
/
GRANT SELECT ON MDSR_REPORTS_ERR_LOG TO SBR WITH GRANT OPTION
/
CREATE TABLE MDSR_GENERATED_XML
(
  FILE_NAME     VARCHAR2(200 BYTE),
  TEXT          CLOB,
  CREATED_DATE  DATE                            DEFAULT SYSDATE,
  SEQ_ID        NUMBER
)
/
GRANT SELECT ON MDSR_GENERATED_XML TO PUBLIC
/
GRANT SELECT ON MDSR_GENERATED_XML TO SBR WITH GRANT OPTION
/
CREATE OR REPLACE PROCEDURE MSDR_XML759_Insert as
/*insert XML*/
P_file number;
l_file_name      VARCHAR2(100);
l_file_path      VARCHAR2(200);
l_result         CLOB:=null;
l_xmldoc          CLOB:=null; 
errmsg VARCHAR2(500):='Non';
  
BEGIN
 
select count(*) into P_file from MDSR_GENERATED_XML;
IF P_file>0 then
 select max(NVL(SEQ_ID,0))+1 into P_file from MDSR_GENERATED_XML;
end if;
        l_file_path := 'SBREXT_DIR';
       
         l_file_name := 'CS_CSI_XML_'||P_file||'.xml';

        SELECT dbms_xmlgen.getxml( 'select* from MDSR444XML_5CSI_LEVEL_VIEW')
        INTO l_result
        FROM DUAL ;
        insert into MDSR_GENERATED_XML VALUES ( l_file_name ,l_result,SYSDATE,P_file);      

 commit;
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into MDSR_REPORTS_ERR_LOG VALUES (l_file_name,  errmsg, sysdate);
 commit;

END ;
/
CREATE OR REPLACE PROCEDURE MDSR_XML_TRANSFORM IS

P_file number;
l_file_name VARCHAR2(500) ;
 errmsg VARCHAR2(500):='Non';
 
BEGIN
select max(SEQ_ID) into P_file from MDSR_GENERATED_XML;
select FILE_NAME into l_file_name from MDSR_GENERATED_XML where SEQ_ID=P_file;


update MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CS_L5_T','ClassificationScheme') where SEQ_ID=P_FILE;
update MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CSI_L1_T','CSI') where SEQ_ID=P_FILE;
update MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CSI_L2_T','CSI') where SEQ_ID=P_FILE;
update MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CSI_L3_T','CSI') where SEQ_ID=P_FILE;
update MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CSI_L4_T','CSI') where SEQ_ID=P_FILE;
update MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CSI_L5_T','CSI') where SEQ_ID=P_FILE;

UPDATE MDSR_GENERATED_XML set text=replace(text,'ROWSET','Classifications' ) where SEQ_ID=P_FILE;
update MDSR_GENERATED_XML set text=replace(text,'</ROW>','</Context>') where SEQ_ID=P_FILE;
update MDSR_GENERATED_XML set text=replace(text,'<ROW>','<Context>') where SEQ_ID=P_FILE;
UPDATE MDSR_GENERATED_XML set text=replace(text,'<ChildCSIList>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE MDSR_GENERATED_XML set text=replace(text,'</ChildCSIList>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE MDSR_GENERATED_XML set text=replace(text,'<ChildCSIList/>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE MDSR_GENERATED_XML set text=replace(text,'<ClassificationItem_LIST>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE MDSR_GENERATED_XML set text=replace(text,'<ClassificationItem_LIST/>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE MDSR_GENERATED_XML set text=replace(text,'</ClassificationItem_LIST>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE MDSR_GENERATED_XML set text=replace(text,'<ClassificationList>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE MDSR_GENERATED_XML set text=replace(text,'<ClassificationList/>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE MDSR_GENERATED_XML set text=replace(text,'</ClassificationList>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE MDSR_GENERATED_XML set text=replace(text,'ParentIdseq','ParentChildIdseq' ) where SEQ_ID=P_FILE;
UPDATE MDSR_GENERATED_XML set text=replace(text,'<?xml version="1.0"?>','<?xml version="1.0" encoding="UTF-8"?>') where SEQ_ID=P_FILE;
--UPDATE MDSR_GENERATED_XML set text=replace(text,'2016-08-01 16:20:20',TO_CHAR(SYSDATE,'YYYY-MM-DD')||'T00:00:00.0') where SEQ_ID=P_FILE;
 commit;
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into MDSR_REPORTS_ERR_LOG VALUES (l_file_name,  errmsg, sysdate);
 commit;

END ;
/
CREATE OR REPLACE PROCEDURE MSDR_GEN_XML_CLCSI AS
BEGIN
  delete  from MDSR_GENERATED_XML where CREATED_DATE>SYSDATE-7;
  commit;
  MSDR_XML759_Insert;
  MDSR_XML_TRANSFORM;
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'MSDR_GEN_XML_CLCSI_JOB',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'MSDR_GEN_XML_CLCSI',
   start_date         =>  '3-OCT-19 10.00.00 PM',
  /* repeat_interval    =>  'FREQ=DAILY;INTERVAL=7'  every  day */
   repeat_interval    =>  'FREQ=DAILY',
   enabled            =>  TRUE);

END;
