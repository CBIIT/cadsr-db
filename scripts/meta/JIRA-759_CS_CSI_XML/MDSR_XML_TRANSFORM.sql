/*CREATE TABLE MSDR_REPORTS_ERR_LOG
(
  FILE_NAME         VARCHAR2(50 BYTE),
  REPORT_ERROR_TXT  VARCHAR2(1100 BYTE),
  DATE_PROCESSED    DATE
);*/
CREATE OR REPLACE PROCEDURE MDSR_XML_TRANSFORM IS

P_file number;
l_file_name VARCHAR2(500) ;
 errmsg VARCHAR2(500):='Non';
 
BEGIN
select max(SEQ_ID) into P_file from SBREXT.MDSR_GENERATED_XML;
select FILE_NAME into l_file_name from SBREXT.MDSR_GENERATED_XML where SEQ_ID=P_file;

update SBREXT.MDSR_GENERATED_XML set text=replace(text,'Children','ClassificationSchemeItemList') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CS_L1_T','ClassificationScheme') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CS_L2_T','ClassificationScheme') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CS_L3_T','ClassificationScheme') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CS_L5_T','ClassificationScheme') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CS_L5_T','ClassificationScheme') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CSI_L1_T','CSI') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CSI_L2_T','CSI') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CSI_L3_T','CSI') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CSI_L4_T','CSI') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'MDSR759_XML_CSI_L5_T','CSI') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'<ClassificationSchemeItemList/>'||chr(10)) where SEQ_ID=P_FILE;

update SBREXT.MDSR_GENERATED_XML set text=replace(text,'AnyClassificationSchemeItemList','AnyChildCSI') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'ClassificationSchemeItemList','ChildCSIList') where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'type' ,'ClassificationSchemeItemType') where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'name' ,'ClassificationSchemeItemName') where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'CS_CONTEXT_NAME','PreferredName') where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'CS_CONTEXT_VERSION','Version' ) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'<CONTEXT_ID>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'</CONTEXT_ID>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'<CONTEXT_ID/>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'CONTEXT_ID','ContextId' ) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'ROWSET','Classifications' ) where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'</ROW>','</Context>') where SEQ_ID=P_FILE;
update SBREXT.MDSR_GENERATED_XML set text=replace(text,'<ROW>','<Context>') where SEQ_ID=P_FILE;

update SBREXT.MDSR_GENERATED_XML set text=replace(text,'item_x005F_x0020_Level','CSILevel') where SEQ_ID=P_FILE;
 update SBREXT.MDSR_GENERATED_XML set text=replace(text,'Item_x005F_x0020_id','CSI_IDSEQ') where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'<SC_CSI_ID>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'<SC_CSI_ID/>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'</SC_CSI_ID>'||chr(10)) where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'Parent_x005F_x0020_id','ParentIdseq') where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'Parent_x005F_x0020_version','ParentVersion') where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'Parent_x005F_x0020_publicID','ParentPublicID') where SEQ_ID=P_FILE;
UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'<?xml version="1.0"?>','<?xml version="1.0" encoding="UTF-8"?>') where SEQ_ID=P_FILE;
--UPDATE SBREXT.MDSR_GENERATED_XML set text=replace(text,'2016-08-01 16:20:20',TO_CHAR(SYSDATE,'YYYY-MM-DD')||'T00:00:00.0') where SEQ_ID=P_FILE;
 commit;
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into MSDR_REPORTS_ERR_LOG VALUES (l_file_name,  errmsg, sysdate);
 commit;

END ;
/