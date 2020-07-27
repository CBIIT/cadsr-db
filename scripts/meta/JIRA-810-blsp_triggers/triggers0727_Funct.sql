CREATE OR REPLACE TRIGGER SBR.PAL_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.PROGRAM_AREAS_LOV
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'PAL_NAME:'||:new.PAL_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.PAL_BIU_ROW_TRM_SPC','SBR.PROGRAM_AREAS_LOV', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.ORG_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.ORGANIZATIONS
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
                 :new.NAME:= regexp_replace(:new.NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);

EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'ORG_IDSEQ:'||:new.ORG_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.ORG_BIU_ROW_TRM_SPC','SBR.ORGANIZATIONS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.DESIG_TL_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.DESIGNATION_TYPES_LOV
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'DETL_NAME:'||:new.DETL_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.DESIG_TL_BIU_ROW_TRM_SPC','SBR.DESIGNATION_TYPES_LOV', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('DESIG_BIU_ROW_TRM_SPC','SBR.DESIGNATIONS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('DEF_BIU_ROW_TRM_SPC','SBR.DEFINITIONS', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('DEC_BIU_ROW_TRM_SPC','SBR.DATA_ELEMENT_CONCEPTS', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('DE_BIU_ROW_TRM_SPC','SBR.DATA_ELEMENTS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

ENd;
CREATE OR REPLACE TRIGGER SBR.DTL_TL_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.DATATYPES_LOV
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'DTL_NAME:'||:new.DTL_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.DTL_TL_BIU_ROW_TRM_SPC','SBR.DATATYPES_LOV', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.CS_TL_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.CS_TYPES_LOV
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'CSTL_NAME:'||:new.CSTL_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.CS_TL_BIU_ROW_TRM_SPC','SBR.CS_TYPES_LOV', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.CSI_TL_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.CSI_TYPES_LOV
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'CSITL_NAME:'||:new.CSITL_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.CSI_TL_BIU_ROW_TRM_SPC','SBR.CSI_TYPES_LOV', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('CTX_BIU_ROW_TRM_SPC','SBR.CONTEXTS', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('CD_BIU_ROW_TRM_SPC','SBR.CONCEPTUAL_DOMAINS', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('CSI_VMS_BIU_ROW_TRM_SPC','SBR.CS_ITEMS', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('CS_BIU_ROW_TRM_SPC','SBR.CLASSIFICATION_SCHEMES', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('VM_BIU_ROW_TRM_SPC','SBR.VALUE_MEANINGS', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('CV_VMS_BIU_ROW_TRM_SPC','SBR.CD_VMS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.ACT_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.AC_TYPES_LOV
FOR EACH ROW
DECLARE
errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'ACTL_NAME:'||:new.ACTL_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.ACT_BIU_ROW_TRM_SPC','SBR.AC_TYPES_LOV', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.ASL_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.AC_STATUS_LOV
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'ASL_NAME:'||:new.ASL_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('ASL_BIU_ROW_TRM_SPC','SBR.AC_STATUS_LOV', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.PV_BIU_ROW_TRM_SPC','SBR.PERMISSIBLE_VALUES', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('VD_BIU_ROW_TRM_SPC','SBR.VALUE_DOMAINS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.UOML_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.UNIT_OF_MEASURES_LOV
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.UOML_NAME:= regexp_replace(:new.UOML_NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'UOML_NAME:'||:new.UOML_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.UOML_BIU_ROW_TRM_SPC','SBR.UNIT_OF_MEASURES_LOV', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.UA_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.USER_ACCOUNTS
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.NAME:= regexp_replace(:new.NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);

EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'UA_NAME:'||:new.UA_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.UA_BIU_ROW_TRM_SPC','SBR.USER_ACCOUNTS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.SCL_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.SECURITY_CONTEXTS_LOV
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'SCL_NAME:'||:new.SCL_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.SCL_BIU_ROW_TRM_SPC','SBR.SECURITY_CONTEXTS_LOV', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.GR_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.GROUPS
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'GRP_NAME:'||:new.GRP_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.GR_BIU_ROW_TRM_SPC','SBR.SBR.GROUPS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBR.RL_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.RELATIONSHIPS_LOV
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'RL_NAME:'||:new.RL_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.RL_BIU_ROW_TRM_SPC','SBR.RELATIONSHIPS_LOV', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('REFDOC_BIU_ROW_TRM_SPC','SBR.REFERENCE_DOCUMENTS', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('QC_BIU_ROW_TRM_SPC','SBREXT.QUEST_CONTENTS_EX', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBREXT.QCTL_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBREXT.QC_TYPE_LOV_EXT
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'QTL_NAME:'||:new.QTL_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBREXT.QCTL_BIU_ROW_TRM_SPC','SBREXT.QC_TYPE_LOV_EXT', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('PROTO_BIU_ROW_TRM_SPC','SBREXT.PROTOCOLS_EXT', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('CONC_BIU_ROW_TRM_SPC','SBREXT.CONCEPTS_EX', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBREXT.TPROP_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBREXT.TOOL_PROPERTIES_EXT
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
                  :new.NAME:= regexp_replace(:new.NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
                  :new.VALUE:= regexp_replace(:new.NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);

EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'NAME:'||:new.NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('TPROP_BIU_ROW_TRM_SPC','SBREXT.TOOL_PROPERTIES_EXT', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBREXT.REP_BIU_ROW_TRM_SPC','SBREXT.REPRESENTATIONS_EXT', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('PROP_BIU_ROW_TRM_SPC','SBREXT.PROPERTIES_EXT', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('OCR_BIU_ROW_TRM_SPC','SBREXT.OC_RECS_EXT', sysdate ,errmsg);
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
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('OC_BIU_ROW_TRM_SPC','SBREXT.OBJECT_CLASSES_EXT', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBREXT.DEFL_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBREXT.DEFINITION_TYPES_LOV_EXT
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'DEFL_NAME:'||:new.DEFL_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBREXT.DEFL_BIU_ROW_TRM_SPC','SBREXT.DEFINITION_TYPES_LOV_EXT', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBREXT.SRC_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBREXT.SOURCES_EXT
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'SRC_NAME:'||:new.SRC_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBREXT.SRC_BIU_ROW_TRM_SPC','SBREXT.SOURCES_EXT', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBREXT.TOP_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBREXT.TOOL_OPTIONS_EXT
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
                  :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
                  :new.VALUE:= regexp_replace(:new.VALUE, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);

EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'TOOL_IDSEQ:'||:new.TOOL_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('TOP_BIU_ROW_TRM_SPC','SBREXT.TOOL_OPTIONS_EXT', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
CREATE OR REPLACE TRIGGER SBREXT.QUALIFIER_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBREXT.QUALIFIER_LOV_EXT
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION:= regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'QUALIFIER_NAME:'||:new.QUALIFIER_NAME||';'||substr(SQLERRM,1,100);     
       insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBREXT.QUALIFIER_BIU_ROW_TRM_SPC','SBREXT.QUALIFIER_LOV_EXT', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;

select --r.OWNER,t.OWNER,TRIGGER_NAME,t.TABLE_NAME,
'CREATE OR REPLACE TRIGGER '||r.DESCRIPTION||SBREXT.MDSR_SUBSTR_LONG(trigger_name,r.owner)TRIG_BODY 
from all_trigGers r ,all_tables t
where trigger_name like '%BIU_ROW_TRM_SPC'
and t.table_name=r.table_name
order by 2,4
CREATE OR REPLACE FUNCTION SBREXT.MDSR_SUBSTR_LONG ( trigger_name_in varchar2,owner_in varchar2)  RETURN varchar2 IS
    incoming    varchar2(32767);
    return_hold varchar2(4000);
Begin
    select TRIGGER_BODY into incoming from all_triggers
     where trigger_name = trigger_name_in
     and owner=owner_in;
    return_hold := substr(trim(incoming),1,3999);
    return return_hold;
END;
/