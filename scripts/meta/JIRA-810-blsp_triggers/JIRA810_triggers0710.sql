CREATE OR REPLACE TRIGGER SBR.DEF_BIU_ROW_TRM_SPC 
BEFORE INSERT OR UPDATE ON SBR.DEFINITIONS
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DEFINITION:= regexp_replace(:new.DEFINITION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'DEFIN_IDSEQ:'||:new.DEFIN_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('DEF_BIU_ROW_TRM_SPC','SBR.DEFINITIONS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.DESIG_BIU_ROW_TRM_SPC BEFORE INSERT OR UPDATE ON SBR.DESIGNATIONS
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.NAME := regexp_replace(:new.NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'DESIG_IDSEQ:'||:new.DESIG_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('DESIG_BIU_ROW_TRM_SPC','SBR.DESIGNATIONS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.CS_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.CLASSIFICATION_SCHEMES
FOR EACH ROW
DECLARE
errmsg VARCHAR2(200);
BEGIN 
         :new.long_name := regexp_replace(:new.long_name, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_name := regexp_replace(:new.preferred_name, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_definition := regexp_replace(:new.preferred_definition,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'CS_IDSEQ:'||:new.cs_idseq||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('CS_BIU_ROW_TRM_SPC','SBR.CLASSIFICATION_SCHEMES', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.CSI_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.CS_ITEMS
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION := regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.long_name := regexp_replace(:new.long_name, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_name := regexp_replace(:new.preferred_name,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_definition := regexp_replace(:new.preferred_definition,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);

EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'CSI_IDSEQ:'||:new.csi_idseq||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('CSI_VMS_BIU_ROW_TRM_SPC','SBR.CS_ITEMS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.CTX_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.CONTEXTS
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.NAME:= regexp_replace(:new.NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
 
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'CONTE_IDSEQ:'||:new.CONTE_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('CTX_BIU_ROW_TRM_SPC','SBR.CONTEXTS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.DEC_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.DATA_ELEMENT_CONCEPTS
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.PREFERRED_DEFINITION:= regexp_replace(:new.PREFERRED_DEFINITION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.PREFERRED_NAME:= regexp_replace(:new.PREFERRED_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.LONG_NAME:= regexp_replace(:new.LONG_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.PROPL_NAME:= regexp_replace(:new.PROPL_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
 
 

EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'DEC_IDSEQ:'||:new.DEC_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('DEC_BIU_ROW_TRM_SPC','SBR.DATA_ELEMENT_CONCEPTS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.DE_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.DATA_ELEMENTS
FOR EACH ROW
DECLARE
errmsg VARCHAR2(200);
BEGIN 
         :new.long_name := regexp_replace(:new.long_name, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_name := regexp_replace(:new.preferred_name, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_definition := regexp_replace(:new.preferred_definition,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'DE_IDSEQ:'||:new.DE_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('DE_BIU_ROW_TRM_SPC','SBR.DATA_ELEMENTS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

ENd;
CREATE OR REPLACE TRIGGER SBR.REFDOC_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.REFERENCE_DOCUMENTS
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.NAME:= regexp_replace(:new.NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.DOC_TEXT:= regexp_replace(:new.DOC_TEXT, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'RD_IDSEQ:'||:new.RD_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('REFDOC_BIU_ROW_TRM_SPC','SBR.REFERENCE_DOCUMENTS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.CD_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.CONCEPTUAL_DOMAINS
FOR EACH ROW
DECLARE
errmsg VARCHAR2(200);
BEGIN 
         :new.long_name := regexp_replace(:new.long_name, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_name := regexp_replace(:new.preferred_name, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_definition := regexp_replace(:new.preferred_definition,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);

EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'CD_IDSEQ:'||:new.cd_idseq||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('CD_BIU_ROW_TRM_SPC','SBR.CONCEPTUAL_DOMAINS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );
END;
CREATE OR REPLACE TRIGGER SBR.CD_VMS_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.CD_VMS
FOR EACH ROW
DECLARE
errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION := regexp_replace(:new.DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.SHORT_MEANING := regexp_replace(:new.SHORT_MEANING,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'CV_IDSEQ:'||:new.cv_idseq||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('CV_VMS_BIU_ROW_TRM_SPC','SBR.CD_VMS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.VD_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.VALUE_DOMAINS
FOR EACH ROW
DECLARE
errmsg VARCHAR2(200);
BEGIN 
         :new.long_name := regexp_replace(:new.long_name, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_name := regexp_replace(:new.preferred_name, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_definition := regexp_replace(:new.preferred_definition,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'VD_IDSEQ:'||:new.VD_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('VD_BIU_ROW_TRM_SPC','SBR.VALUE_DOMAINS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.VM_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.VALUE_MEANINGS
FOR EACH ROW
DECLARE
errmsg VARCHAR2(200);
BEGIN 
         :new.long_name := regexp_replace(:new.long_name, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_name := regexp_replace(:new.preferred_name, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_definition := regexp_replace(:new.preferred_definition,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.definition_source	:= regexp_replace(:new.definition_source,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
	     :new.description:= regexp_replace(:new.description,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.short_meaning:=regexp_replace(:new.short_meaning,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'VM_IDSEQ:'||:new.VM_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('VM_BIU_ROW_TRM_SPC','SBR.VALUE_MEANINGS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.PV_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.PERMISSIBLE_VALUES
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.VALUE:= regexp_replace(:new.VALUE, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.SHORT_MEANING:= regexp_replace(:new.SHORT_MEANING, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.MEANING_DESCRIPTION:= regexp_replace(:new.MEANING_DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
   
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'PV_IDSEQ:'||:new.PV_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.PV_BIU_ROW_TRM_SPC','SBR.PERMISSIBLE_VALUES', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBREXT.CONC_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBREXT.CONCEPTS_EXT
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.PREFERRED_DEFINITION:= regexp_replace(:new.PREFERRED_DEFINITION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.PREFERRED_NAME:= regexp_replace(:new.PREFERRED_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.LONG_NAME:= regexp_replace(:new.LONG_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.DEFINITION_SOURCE:= regexp_replace(:new.DEFINITION_SOURCE, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
 
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'CONTE_IDSEQ:'||:new.CONTE_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('CONC_BIU_ROW_TRM_SPC','SBREXT.CONCEPTS_EX', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBREXT.OCR_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBREXT.OC_RECS_EXT
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.PREFERRED_DEFINITION:= regexp_replace(:new.PREFERRED_DEFINITION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.PREFERRED_NAME:= regexp_replace(:new.PREFERRED_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.LONG_NAME:= regexp_replace(:new.LONG_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        

EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'OCR_IDSEQ:'||:new.OCR_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('OCR_BIU_ROW_TRM_SPC','SBREXT.OC_RECS_EXT', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBREXT.OC_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBREXT.OBJECT_CLASSES_EXT
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.PREFERRED_DEFINITION:= regexp_replace(:new.PREFERRED_DEFINITION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.PREFERRED_NAME:= regexp_replace(:new.PREFERRED_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.LONG_NAME:= regexp_replace(:new.LONG_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.DEFINITION_SOURCE:= regexp_replace(:new.DEFINITION_SOURCE, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
  
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'OC_IDSEQ:'||:new.OC_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('OC_BIU_ROW_TRM_SPC','SBREXT.OBJECT_CLASSES_EXT', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBREXT.PROP_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBREXT.PROPERTIES_EXT
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.PREFERRED_DEFINITION:= regexp_replace(:new.PREFERRED_DEFINITION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.PREFERRED_NAME:= regexp_replace(:new.PREFERRED_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.LONG_NAME:= regexp_replace(:new.LONG_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.DEFINITION_SOURCE:= regexp_replace(:new.DEFINITION_SOURCE, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
  

EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'PROP_IDSEQ:'||:new.PROP_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('PROP_BIU_ROW_TRM_SPC','SBREXT.PROPERTIES_EXT', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBREXT.PROTO_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBREXT.PROTOCOLS_EXT
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.PREFERRED_DEFINITION:= regexp_replace(:new.PREFERRED_DEFINITION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.PREFERRED_NAME:= regexp_replace(:new.PREFERRED_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.LONG_NAME:= regexp_replace(:new.LONG_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
 

EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'PROTO_IDSEQ:'||:new.PROTO_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('PROTO_BIU_ROW_TRM_SPC','SBREXT.PROTOCOLS_EXT', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBREXT.QC_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBREXT.QUEST_CONTENTS_EXT
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.PREFERRED_DEFINITION:= regexp_replace(:new.PREFERRED_DEFINITION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.PREFERRED_NAME:= regexp_replace(:new.PREFERRED_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.LONG_NAME:= regexp_replace(:new.LONG_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
 

EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'QC_IDSEQ:'||:new.QC_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('QC_BIU_ROW_TRM_SPC','SBREXT.QUEST_CONTENTS_EX', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBREXT.REP_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBREXT.REPRESENTATIONS_EXT

FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.PREFERRED_DEFINITION:= regexp_replace(:new.PREFERRED_DEFINITION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.PREFERRED_NAME:= regexp_replace(:new.PREFERRED_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.LONG_NAME:= regexp_replace(:new.LONG_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.DEFINITION_SOURCE:= regexp_replace(:new.DEFINITION_SOURCE, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
    
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'REP_IDSEQ:'||:new.REP_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('SBREXT.REP_BIU_ROW_TRM_SPC','SBREXT.REPRESENTATIONS_EXT', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;