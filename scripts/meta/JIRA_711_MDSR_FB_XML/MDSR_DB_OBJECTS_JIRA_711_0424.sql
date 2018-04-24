set serveroutput on size 1000000
SPOOL cadsrmeta-711.log

DROP table SBREXT.MDSR_FB_XML_REPORT_ERR ;
DROP table SBREXT.MDSR_FB_XML_TEMP ;
DROP table SBREXT.MDSR_FB_XML_VW ;

DROP MATERIALIZED VIEW  SBREXT.MDSR_FB_QUEST_MODULE_MVW ;
DROP MATERIALIZED VIEW  SBREXT.MDSR_FB_QUESTION_MVW ;
DROP MATERIALIZED VIEW  SBREXT.MDSR_FB_VALID_VALUE_MVW

drop type MDSR_FB_FORM_XML_T1;
drop type MDSR_FB_PROTOCOL_XML_LIST_T; 
drop type  MDSR_FB_PROTOCOL_XML_T;

drop type MDSR_FB_MODULE_XML_LIST_T1;
drop type MDSR_FB_MODULE_XML_T1;

drop type MDSR_FB_QUESTION_XML_LIST_T1;
drop type MDSR_FB_QUESTION_XML_T1;

drop type MDSR_FB_DATA_EL_XML_T1;--MDSR_FB_DATA_EL_XML_T 
drop type MDSR_FB_VV_XML_LIST_T1;
drop type MDSR_FB_VV_XML_T1;
drop type MDSR_FB_VV_VM_XML_T1; 


drop type  MDSR_FB_COM_DE_DR_XML_LIST_T1;
drop type  MDSR_FB_COM_DE_DR_XML_T1;
drop type MDSR_FB_DE_DR_XML_T1;
drop type MDSR_FB_UseCat_XML;
drop type MDSR_FB_VD_DR_XML_T1;
drop type MDSR_FB_VDC_DR_XML_T1 ;
drop type MDSR_FB_VD_XML_T1;
drop type MDSR_FB_RD_XML_LIST_T1;
drop type MDSR_FB_RD_XML_T1;

--drop type MDSR_FB_VM_XML_T ;
drop type MDSR_FB_PV_XML_LIST_T1;
drop type MDSR_FB_PV_XML_T1;
drop type MDSR_FB_VM_XML_T1;

drop type MDSR_FB_VDCon_XML_LIST_T1;
drop type MDSR_FB_VDCon_XML_T1;
drop type MDSR_FB_DEFIN_XML_LIST_T1;
drop type MDSR_FB_DEFIN_XML_T1;
drop type MDSR_FB_DESIGN_XML_LIST_T1;
drop type MDSR_FB_DESIGN_XML_T1;

drop type MDSR_FB_FORM_CL_XML_LIST_T1;
drop type MDSR_FB_FORM_CL_XML_T1;
drop type MDSR_FB_FORM_CLI_XML_T1;

CREATE OR REPLACE TYPE               MDSR_FB_FORM_CLI_XML_T1 as object(   
 "name" VARCHAR2(255),
 "publicID"        NUMBER,
 "version"          VARCHAR2(7),
"type"   VARCHAR2(20)
,"preferredDefinition"  VARCHAR2(2000))
/
CREATE OR REPLACE TYPE               MDSR_FB_FORM_CL_XML_T1 as object(    
"name" VARCHAR2(255),
"publicID"        NUMBER,
"version"          VARCHAR2(7),
"preferredDefinition"  VARCHAR2(2000),
"FclassificationItem_XX"  MDSR_FB_FORM_CLI_XML_T1)
/
CREATE OR REPLACE TYPE         MDSR_FB_FORM_CL_XML_LIST_T1         as table of MDSR_FB_FORM_CL_XML_T1;
/
CREATE OR REPLACE TYPE          "MDSR_FB_DEFIN_XML_T1"          as object(  
"createdBy"                            VARCHAR2(100)
,"dateCreated"                         VARCHAR2(30)
,"dateModified"                         VARCHAR2(30)
,"ModifiedBy"                            VARCHAR2(100)
,"languageName"                         VARCHAR2(30) 
,"text"                                 VARCHAR2(2000)
,"type"                                 VARCHAR2(50)--"DETL_NAME"
,"classification_xx"  "MDSR_FB_FORM_CL_XML_LIST_T1" 
,"context"                             VARCHAR2(30) 
)
/
CREATE OR REPLACE TYPE          "MDSR_FB_DESIGN_XML_T1"          as object(  
"createdBy"                            VARCHAR2(100)
,"dateCreated"                         VARCHAR2(30)
,"dateModified"                         VARCHAR2(30)
,"modifiedBy"                            VARCHAR2(100)
,"languageName"                        VARCHAR2(30) 
,"name"                                VARCHAR2(2000)
,"type"                                VARCHAR2(20)--"DETL_NAME"
,"context"                             VARCHAR2(30) 
,"classification_xx"  "MDSR_FB_FORM_CL_XML_LIST_T1" )
/
CREATE OR REPLACE TYPE         MDSR_FB_DESIGN_XML_LIST_T1         as table of MDSR_FB_DESIGN_XML_T1 
/
CREATE OR REPLACE TYPE         MDSR_FB_DEFIN_XML_LIST_T1         as table of MDSR_FB_DEFIN_XML_T1  
/
CREATE OR REPLACE TYPE          "MDSR_FB_VM_XML_T1"          as object(
"publicID"          number,
"version"          VARCHAR2(7),
"longname"        varchar2 (300) ,
"designation_xx"    MDSR_FB_DESIGN_XML_LIST_T1,
"definition_xx"   MDSR_FB_DEFIN_XML_LIST_T1,
"preferredDefinition"  VARCHAR2(2000))
/
CREATE OR REPLACE TYPE          "MDSR_FB_PV_XML_T1"          as object( 
 
"value"       varchar2 (300) ,
"valueMeaning"    MDSR_FB_VM_XML_T1,
"beginDate"      varchar2 (30)
-- ,"endDate"         varchar2 (30)
)
/
CREATE OR REPLACE TYPE         MDSR_FB_PV_XML_LIST_T1    as table of MDSR_FB_PV_XML_T1
/
CREATE OR REPLACE TYPE          MDSR_FB_VDCon_XML_T1          as object(
 
 "primaryConceptName"       varchar2 (260) ,
 "primaryConceptCode"       varchar2 (30) ,
  "nciTermBrowserLink"       varchar2 (200) )
/
CREATE OR REPLACE TYPE         MDSR_FB_VDCon_XML_LIST_T1    as table of MDSR_FB_VDCon_XML_T1;  
/
CREATE OR REPLACE TYPE          MDSR_FB_RD_ATTACH_XML_T1      AS OBJECT 
(   
  "name"      varchar2(355),
  "mimeType"    VARCHAR2(128 BYTE), 
  "size"     NUMBER)
  /
CREATE OR REPLACE TYPE          MDSR_FB_RD_XML_T1       AS OBJECT 
(   
  "name"      varchar2(255),
  "type"   varchar2(60), 
  "context"    VARCHAR2(40),
  "doctext"     VARCHAR2(4000),
  "languageName" VARCHAR2(40),
  "URL"  varchar2(240),
  "attachments" MDSR_FB_RD_ATTACH_XML_T1
)
/
CREATE OR REPLACE TYPE     MDSR_FB_RD_XML_LIST_T1     as table of MDSR_FB_RD_XML_T1
/
CREATE OR REPLACE TYPE          MDSR_FB_VD_XML_T1    AS OBJECT  --8
(   
  "longName"      varchar2(255),
  "shortName"    varchar2(60),
  "publicId"         number,
  "version"          VARCHAR2(7),
  "type"        varchar2 (50),
  "context"    VARCHAR2(40),
  "workflowStatus"         varchar2 (20), 
  "Datatype"               varchar2 (20), 
  "decimalPlace"       number (2),
  "formatName"        VARCHAR2(20 BYTE),
  "highValueNumber"   VARCHAR2(255 BYTE),
  "lowValueNumber"    VARCHAR2(255 BYTE),
  "MaximumLengthNumber"          number (8),
  "MinimumLengthNumber"          number (8),  
  "UOMName"              VARCHAR2(20 BYTE)    ,
  "valueDomainConcept_xx" MDSR_FB_VDCon_XML_LIST_T1,  --
  "PermissibleValue_xx"    MDSR_FB_PV_XML_LIST_T1,
  "referenceDocument_xx"  MDSR_FB_RD_XML_LIST_T1
)
/
CREATE OR REPLACE TYPE          MDSR_FB_VDC_DR_XML_T1    AS OBJECT  
(   
  "nciTermBrowserLink"      varchar2(255)
)
/
CREATE OR REPLACE TYPE          MDSR_FB_VD_DR_XML_T1    AS OBJECT  
(   
  "shortName"      varchar2(255),
  "type"        varchar2 (50),
  "workflowStatusName"         varchar2 (20), 
  "valueDomainConcept"  MDSR_FB_VDC_DR_XML_T1)
  /
CREATE OR REPLACE TYPE          MDSR_FB_DE_DR_XML_T1    AS OBJECT  
(   
  "publicId"         number,
  "version"                number (4,2),  
  "valueDomain"    MDSR_FB_VD_DR_XML_T1
)
/
CREATE OR REPLACE TYPE                MDSR_FB_UseCat_XML    as object(
"usageType"   VARCHAR2(25),
"rule"      VARCHAR2(2000)
)
/
CREATE OR REPLACE TYPE          MDSR_FB_COM_DE_DR_XML_T1    AS OBJECT  
(   
  "usageCategory"  MDSR_FB_USECAT_XML,
  "displayOrder"         number, 
  "dataElement"     MDSR_FB_DE_DR_XML_T1 
)
/
CREATE OR REPLACE TYPE     MDSR_FB_COM_DE_DR_XML_LIST_T1     as table of MDSR_FB_COM_DE_DR_XML_T1
/
CREATE OR REPLACE TYPE          "MDSR_FB_DATA_EL_XML_T1"    AS OBJECT 
(   
  "longName"      varchar2(255),
  "shortName"   varchar2(60),--preferred-name
  "publicId"         number,
  "version"          VARCHAR2(7),
  "context"    VARCHAR2(40),
  "workflowStatus"         varchar2 (20), 
  "preferredDefinition" VARCHAR2(2000),
  "designation_xx"    MDSR_FB_DESIGN_XML_LIST_T1,
  "valueDomain"    MDSR_FB_VD_XML_T1,  
  "dataElementDerivation_xx"  MDSR_FB_COM_DE_DR_XML_LIST_T1, 
  "referenceDocument_xx"  MDSR_FB_RD_XML_LIST_T1,
  "cdeBrowserLink"       VARCHAR2(500)
)
/
CREATE OR REPLACE TYPE       MDSR_FB_VV_VM_XML_T1   as object( 
"publicID"                                     NUMBER
,"version"          VARCHAR2(7)
)
/
CREATE OR REPLACE TYPE       MDSR_FB_VV_XML_T1   as object( 
"displayOrder"                                     NUMBER
,"value"                                      VARCHAR2(2000)
,"meaningText"                                  VARCHAR2(2000)  
,"description" VARCHAR2(2000)
,"instruction"    REDCAP_INSTRUCTIONS_T
,"valueMeaning"   MDSR_FB_VV_VM_XML_T1 )
/
CREATE OR REPLACE TYPE     MDSR_FB_VV_XML_LIST_T1     as table of MDSR_FB_VV_XML_T1
/
CREATE OR REPLACE TYPE        MDSR_FB_QUESTION_XML_T1   as object(
"publicID"        NUMBER,
"version"          VARCHAR2(7),
"isDerived"       VARCHAR2(8),
"displayOrder"     NUMBER,
"dateCreated"      VARCHAR2(30),
"dateModified"     VARCHAR2(30),
"questionText"     VARCHAR2(4000),
"instruction"      REDCAP_INSTRUCTIONS_T,
"isEditable"       VARCHAR2(8),
"isMandatory"      VARCHAR2(8),
"multiValue"       VARCHAR2(8),
"dataElement"       MDSR_FB_DATA_EL_XML_T1,
"validValues_xx"    MDSR_FB_VV_XML_LIST_T1)
/
CREATE OR REPLACE TYPE     MDSR_FB_QUESTION_XML_LIST_T1    as table of MDSR_FB_QUESTION_XML_T1
/            
 CREATE OR REPLACE TYPE        MDSR_FB_MODULE_XML_T1    as object(
"displayOrder"                                     NUMBER
,"maximumModuleRepeat"                              NUMBER
,"longName"   VARCHAR2(255) 
,"instruction"      REDCAP_INSTRUCTIONS_T
, "preferredDefinition" VARCHAR2(2000)
,"publicid"  NUMBER
,"version"  VARCHAR2(7)
,"usageCategory"  MDSR_FB_USECAT_XML
,"questions_xx"   MDSR_FB_QUESTION_XML_LIST_T1
)
/           
  CREATE OR REPLACE TYPE     MDSR_FB_MODULE_XML_LIST_T1     as table of MDSR_FB_MODULE_XML_T1
/  
  CREATE OR REPLACE TYPE               MDSR_FB_PROTOCOL_XML_T as object(
 "leadOrganization" VARCHAR2(50),
 "phase" VARCHAR2(15),
"type" VARCHAR2(250),
"protocolID" VARCHAR2(50),
"longName"  VARCHAR2(255),
"context"   VARCHAR2(40),
"shortName"  VARCHAR2(60),
"preferredDefinition"  VARCHAR2(2000))
/
CREATE OR REPLACE TYPE  "MDSR_FB_PROTOCOL_XML_LIST_T"  AS TABLE OF  MDSR_FB_PROTOCOL_XML_T
/     
CREATE OR REPLACE TYPE                    MDSR_FB_FORM_XML_T1    as object(    
"context"                                    VARCHAR2(40)
,"createdBy"                                      VARCHAR2(100)
,"dateCreated"                         VARCHAR2(30)
,"dateModified"    VARCHAR2(30)
,"modifiedBy"   VARCHAR2(100)
,"longName"  VARCHAR2(255)   
,"changeNote"                              VARCHAR2(2000)
,"preferredDefinition"                      VARCHAR2(2000)
,"cadsrRAI"             VARCHAR2(40)
,"publicid"  NUMBER
,"version"   VARCHAR2(7)
,"workflowStatusName" VARCHAR2(40)
,"categoryName" VARCHAR2(255) 
,"type"              VARCHAR2(5) 
,"headerInstruction"     SBREXT.REDCAP_HINSTRUCTIONS_T                 
,"footerInstruction"     SBREXT.REDCAP_HINSTRUCTIONS_T  
,"module_xx" SBREXT.MDSR_FB_MODULE_XML_LIST_T1
,"protocol_xx" MDSR_FB_PROTOCOL_XML_LIST_T 
,"referenceDocument_xx"  MDSR_FB_RD_XML_LIST_T1
,"classification_xx"  MDSR_FB_FORM_CL_XML_LIST_T1
)
/
CREATE OR REPLACE FORCE VIEW MDSR_FB_CLASSIFICATION
(
   AC_IDSEQ,
   CLASS_LONG_NAME,
   CS_ID,
   CLASS_VERSION,
   PREFERRED_DEFINITION,
   CLITEM_LONG_NAME,
   CSI_ID,
   CLITEM_VERSION,
   CSITL_NAME,
   CLI_PREF_DEF
)
AS
     SELECT DISTINCT AC_IDSEQ,
                     cs.long_name class_long_name,
                     cs.CS_ID CS_ID,
                     cs.version class_version,
                     cs.preferred_definition,
                     i.long_name clitem_long_name,
                     i.CSI_ID,
                     i.version clitem_version,
                     CSITL_NAME,
                     i.preferred_definition CLI_PREF_DEF
       FROM cs_csi cscsi,
            classification_schemes cs,
            ac_csi accsi,
            CS_ITEMS i
      WHERE     cs.CS_IDSEQ = cscsi.CS_IDSEQ
            AND accsi.CS_CSI_IDSEQ = cscsi.CS_CSI_IDSEQ
            AND i.CSI_IDSEQ = cscsi.CSI_IDSEQ
   ORDER BY cs.CS_ID;
 /  
  CREATE OR REPLACE FORCE VIEW MDSR_FB_VM_CLASSIFICATION
(
   ATT_IDSEQ,
   CLASS_LONG_NAME,
   CS_ID,
   CLASS_VERSION,
   PREFERRED_DEFINITION,
   CLITEM_LONG_NAME,
   CSI_ID,
   CLITEM_VERSION,
   CSITL_NAME,
   CLI_PREF_DEF
)
AS
     SELECT DISTINCT ATT_IDSEQ,
                     cs.long_name class_long_name,
                     cs.CS_ID CS_ID,
                     cs.version class_version,
                     cs.preferred_definition,
                     i.long_name clitem_long_name,
                     i.CSI_ID,
                     i.version clitem_version,
                     CSITL_NAME,
                     i.preferred_definition AS CLI_PREF_DEF
       FROM cs_csi cscsi,
            classification_schemes cs,
            ac_att_cscsi_ext ATT,
            CS_ITEMS i
      WHERE     cs.CS_IDSEQ = cscsi.CS_IDSEQ
            AND ATT.CS_CSI_IDSEQ = cscsi.CS_CSI_IDSEQ
            AND i.CSI_IDSEQ = cscsi.CSI_IDSEQ
   ORDER BY cs.CS_ID;
 /
CREATE MATERIALIZED VIEW SBREXT.MDSR_FB_QUEST_MODULE_MVW
AS 
SELECT MOD.QC_IDSEQ MOD_IDSEQ,
       MOD.DN_CRF_IDSEQ CRF_IDSEQ,
       MOD.QC_ID MOD_ID,
       MOD.VERSION,
       MOD.CONTE_IDSEQ,
       MOD.ASL_NAME WORKFLOW,
       MOD.PREFERRED_NAME,
       MOD.PREFERRED_DEFINITION,
       MOD.LONG_NAME,
       MOD.LATEST_VERSION_IND,    
       MOD.DISPLAY_ORDER,
       MOD.repeat_no,
       CM.NAME CONTEXT,
       INS.PREFERRED_DEFINITION Mod_instruction,
       CASE
          WHEN MOD.long_NAME LIKE 'Mandatory%' THEN 'Mandatory'
          WHEN MOD.long_NAME LIKE 'Conditional%' THEN 'Conditional'
          WHEN MOD.long_NAME LIKE 'Optional%' THEN 'Optional'
          ELSE 'None'
       END
          AS usageType
  FROM SBREXT.QUEST_CONTENTS_EXT MOD,
       SBR.CONTEXTS CM,
       -- QC_RECS_EXT qr,
       -- SBR.CONTEXTS FRC,
       SBREXT.QUEST_CONTENTS_EXT FR,
       (SELECT *
          FROM SBREXT.QUEST_CONTENTS_EXT
         WHERE qtl_name = 'MODULE_INSTR') INS
 WHERE                                --AND    MOD.QC_IDSEQ = qr.C_QC_IDSEQ(+)
      MOD  .DN_CRF_IDSEQ = FR.QC_IDSEQ
       --AND FR.CONTE_IDSEQ = FRC.CONTE_IDSEQ
       AND MOD.CONTE_IDSEQ = CM.CONTE_IDSEQ
       AND INS.P_MOD_IDSEQ(+) = MOD.QC_IDSEQ
       AND fr.CONTE_IDSEQ NOT IN ('29A8FB18-0AB1-11D6-A42F-0010A4C1E842',
                                  'E5CA1CEF-E2C6-3073-E034-0003BA3F9857')
       AND FR.ASL_NAME = 'RELEASED'
       AND (FR.QTL_NAME = 'CRF' OR FR.QTL_NAME = 'TEMPLATE')
       AND MOD.qtl_name = 'MODULE'
       AND MOD.DELETED_IND = 'No';
/
CREATE INDEX SBREXT.MDSR_FB_MODF_ID_INX ON SBREXT.MDSR_FB_QUEST_MODULE_MVW
(CRF_IDSEQ)
/
CREATE INDEX SBREXT.MDSR_FB_MOD_ID_INX ON SBREXT.MDSR_FB_QUEST_MODULE_MVW
(MOD_IDSEQ)
/
CREATE MATERIALIZED VIEW SBREXT.MDSR_FB_QUESTION_MVW 
AS 
SELECT FR.QC_ID form_id,
       FR.QC_IDseq form_idSEQ,
       QQ.p_mod_idseq mod_idseq,
       QQ.QC_IDSEQ QUES_IDSEQ,
       QQ.QC_ID QUES_ID,
       QQ.VERSION QUES_VERSION,
       QQ.QTL_NAME,
       QQ.CONTE_IDSEQ,
       QC.name Q_context,
       QQ.date_created,
       QQ.DATE_MODIFIED,
       QQ.DISPLAY_ORDER,
       QQ.ASL_NAME WORKFLOW,
       QQ.PREFERRED_NAME Q_PREFERRED_NAME,
       QQ.PREFERRED_DEFINITION Q_PREFERRED_DEFINITION,
       QQ.DE_IDSEQ,
       QQ.LONG_NAME Q_LONG_NAME,
       QQ.date_Created dateCreated,
       de.QUESTION,
       de.VERSION DE_VERSION,
       de.LONG_NAME DE_LONG_NAME,
       de.CDE_ID,
       --  de.DE_IDSEQ,
       de.VD_IDSEQ,
       de.ASL_NAME DE_WORKFLOW,
       DE.PREFERRED_NAME DE_PREFERRED_NAME,
       DE.PREFERRED_DEFINITION D_PREFERRED_DEFINITION,
       DC.name DE_context,
       qa.EDITABLE_IND,
       qa.MANDATORY_IND,
       INS.PREFERRED_DEFINITION Q_instruction,
       DECODE (cdv.P_DE_IDSEQ, NULL, 'false', 'true') isDerived,
       CASE
          WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%check all%'
          THEN
             'Yes'
          WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%mark all%'
          THEN
             'Yes'
          WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%select all%'
          THEN
             'Yes'
          WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%choose all%'
          THEN
             'Yes'
          WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%all that%'
          THEN
             'Yes'
          WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%enter all%'
          THEN
             'Yes'
          WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%report all%'
          THEN
             'Yes'
          WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%include all%'
          THEN
             'Yes'
          ELSE
             'No'
       END
          multiValue
  --   select distinct FR.QC_ID
  FROM SBREXT.QUEST_CONTENTS_EXT qq,
       SBREXT.QUEST_ATTRIBUTES_EXT qa,
       SBREXT.QUEST_CONTENTS_EXT FR,
       SBR.CONTEXTS QC,
       (SELECT *
          FROM SBREXT.QUEST_CONTENTS_EXT
         WHERE qtl_name = 'QUESTION_INSTR') INS,
       SBR.COMPLEX_DATA_ELEMENTS_VIEW cdv,
       SBR.DATA_ELEMENTS de,
       SBR.CONTEXTS DC
 WHERE     QQ.QC_IDSEQ = qa.QC_IDSEQ
       AND QQ.DN_CRF_IDSEQ = FR.QC_IDSEQ
       AND QQ.CONTE_IDSEQ = QC.CONTE_IDSEQ(+)
       AND DE.CONTE_IDSEQ = DC.CONTE_IDSEQ(+)
       AND INS.P_QST_IDSEQ(+) = QQ.QC_IDSEQ
       AND fr.CONTE_IDSEQ NOT IN ('29A8FB18-0AB1-11D6-A42F-0010A4C1E842',
                                  'E5CA1CEF-E2C6-3073-E034-0003BA3F9857')
       AND FR.ASL_NAME = 'RELEASED'
       AND (FR.QTL_NAME = 'CRF' OR FR.QTL_NAME = 'TEMPLATE')
       AND QQ.qtl_name = 'QUESTION'
       AND cdv.P_DE_IDSEQ(+) = qq.DE_IDSEQ
       AND QQ.DE_IDSEQ = de.DE_IDSEQ(+);
/
CREATE INDEX SBREXT.MDSR_FB_QDE_ID_INX ON SBREXT.MDSR_FB_QUESTION_MVW
(DE_IDSEQ)
/
CREATE INDEX SBREXT.MDSR_FB_QF_ID_INX ON SBREXT.MDSR_FB_QUESTION_MVW
(FORM_IDSEQ)
/
CREATE INDEX SBREXT.MDSR_FB_QM_ID_INX ON SBREXT.MDSR_FB_QUESTION_MVW
(MOD_IDSEQ)
/
CREATE INDEX SBREXT.MDSR_FB_QVD_ID_INX ON SBREXT.MDSR_FB_QUESTION_MVW
(VD_IDSEQ)
/
CREATE INDEX SBREXT.MDSR_FB_Q_ID_INX ON SBREXT.MDSR_FB_QUESTION_MVW
(QUES_IDSEQ)   
/   
CREATE MATERIALIZED VIEW SBREXT.MDSR_FB_VALID_VALUE_MVW 
AS 
SELECT QF.qc_id FORM_ID,
       QF.qc_idseq FORM_IDSEQ,
       QM.qc_id MOD_ID,
       QM.qc_idseq MOD_IDseq,
       qq.qc_id QUEST_ID,
       qq.qc_idseq QUEST_IDseq,
       QV.QC_IDSEQ VV_IDSEQ,
       TRIM (QV.DISPLAY_ORDER),
       TRIM (QV.long_name) long_name,
       TRIM (VV.MEANING_TEXT) MEANING_TEXT,
       TRIM (VV.DESCRIPTION_TEXT) DESCRIPTION_TEXT,
       vm_id,
       vm_version,
       QV.VP_idseq,
       ins.PREFERRED_DEFINITION INSTRUCTION
  FROM QUEST_CONTENTS_EXT QV,
       QUEST_CONTENTS_EXT QQ,
       QUEST_CONTENTS_EXT QF,
       QUEST_CONTENTS_EXT QM,
       VALID_VALUES_ATT_EXT VV,
       (SELECT *
          FROM SBREXT.QUEST_CONTENTS_EXT
         WHERE qtl_name = 'VALUE_INSTR') INS,
       (SELECT VP_IDSEQ, vm.vm_id vm_id, vm.version vm_version
          FROM SBR.VALUE_MEANINGS vm, SBR.PERMISSIBLE_VALUES pv, VD_PVS vp
         WHERE vm.vm_idseq = pv.VM_idseq AND pv.pv_idseq = vp.pv_idseq) VP
 WHERE     QV.P_QST_IDSEQ = QQ.qc_idseq
       AND QQ.P_mod_idseq = QM.QC_IDSEQ
       AND QM.DN_CRF_idseq = QF.QC_IDSEQ
       AND VV.QC_IDSEQ = QV.QC_IDSEQ
       AND QV.QC_IDSEQ = INS.P_VAL_IDSEQ(+)
       AND QV.VP_idseq = VP.VP_IDSEQ(+)
       AND QV.QTL_NAME = 'VALID_VALUE'
       AND QQ.QTL_NAME = 'QUESTION'
       AND QF.ASL_NAME = 'RELEASED'
       AND (QF.QTL_NAME = 'CRF' OR QF.QTL_NAME = 'TEMPLATE')
       AND QM.QTL_NAME = 'MODULE'
       AND QF.CONTE_IDSEQ NOT IN ('29A8FB18-0AB1-11D6-A42F-0010A4C1E842',
                                  'E5CA1CEF-E2C6-3073-E034-0003BA3F9857');
/
CREATE INDEX MDSR_FB_VQ_ID_INX ON MDSR_FB_VALID_VALUE_MVW
(QUEST_IDSEQ)
/
CREATE INDEX MDSR_FB_VVP_ID_INX ON MDSR_FB_VALID_VALUE_MVW
(VP_IDSEQ)
/
CREATE INDEX MDSR_FB_VV_ID_INX ON MDSR_FB_VALID_VALUE_MVW
(VV_IDSEQ)   
/
/* Formatted on 4/24/2018 2:33:10 PM (QP5 v5.269.14213.34769) */
CREATE OR REPLACE FORCE VIEW MDSR_FB_XML_VW
(
   "context",
   "createdBy",
   "dateCreated",
   "dateModified",
   "modifiedBy",
   "longName",
   "changeNote",
   "preferredDefinition",
   "cadsrRAI",
   "publicid",
   "version",
   "workflowStatusName",
   "categoryName",
   "type",
   "headerInstruction",
   "footerInstruction",
   MODULE_LIST,
   FORM_PROTOCOL,
   REF_DOC,
   FORM_CLASS
)
AS
   SELECT cf.name "context",
          FR.CREATED_BY "createdBy",
             TO_CHAR (FR.DATE_CREATED, 'YYYY-MM-DD')
          || 'T'
          || TO_CHAR (FR.DATE_CREATED, 'HH24:MI:SS')
          || '.0'
             "dateCreated",
          DECODE (
             FR.DATE_MODIFIED,
             NULL, NULL,
                TO_CHAR (FR.DATE_MODIFIED, 'YYYY-MM-DD')
             || 'T'
             || TO_CHAR (FR.DATE_MODIFIED, 'HH24:MI:SS')
             || '.0')
             "dateModified",
          FR.MODIFIED_by "modifiedBy",
          FR.long_name "longName",
          FR.CHANGE_NOTE "changeNote",
          FR.preferred_definition "preferredDefinition",
          '2.16.840.1.113883.3.26.2' "cadsrRAI",
          FR.QC_ID "publicid",
          DECODE (INSTR (TO_CHAR (FR.version), '.'),
                  0, FR.version || '.0',
                  FR.version)
             "version",
          FR.ASL_NAME "workflowStatusName",
          FR.QCDL_NAME "categoryName",
          FR.QTL_NAME "type",
          SBREXT.REDCAP_HINSTRUCTIONS_T (FI.preferred_definition),
          SBREXT.REDCAP_HINSTRUCTIONS_T (FF.preferred_definition),
          CAST (
             MULTISET (
                  SELECT MM.DISPLAY_ORDER,
                         NVL (mm.REPEAT_NO, 0),
                         MM.long_name,
                         REDCAP_INSTRUCTIONS_T (Mod_instruction),
                         MM.preferred_Definition,
                         mm.mod_id,
                         DECODE (INSTR (TO_CHAR (mm.version), '.'),
                                 0, mm.version || '.0',
                                 mm.version),
                         MDSR_FB_UseCat_XML (usageType, Mod_instruction),
                         CAST (
                            MULTISET (
                                 SELECT                      --0level QUESTION
                                       QQ.QUES_id,
                                        DECODE (
                                           INSTR (TO_CHAR (QQ.QUES_version), '.'),
                                           0, QQ.QUES_version || '.0',
                                           QQ.QUES_version),
                                        isDerived,
                                        QQ.DISPLAY_ORDER,
                                           TO_CHAR (QQ.DATE_CREATED,
                                                    'YYYY-MM-DD')
                                        || 'T00:00:00.0'
                                           --|| TO_CHAR (QQ.DATE_CREATED, 'HH24:MI:SS')||'.0'
                                           "dateCreated",
                                        DECODE (
                                           QQ.DATE_MODIFIED,
                                           NULL, NULL,
                                              TO_CHAR (QQ.DATE_MODIFIED,
                                                       'YYYY-MM-DD')
                                           || 'T00:00:00.0')
                                           --  || TO_CHAR (QQ.DATE_MODIFIED, 'HH24:MI:SS')||'.0')
                                           "dateModified",
                                        qq.Q_LONG_NAME,
                                        REDCAP_INSTRUCTIONS_T (Q_instruction),
                                        TRIM (qq.EDITABLE_IND),
                                        TRIM (qq.MANDATORY_IND),
                                        TRIM (qq.multiValue),
                                        -- MDSR_FB_DATA_EL_XML_T1 started
                                        MDSR_FB_DATA_EL_XML_T1 (
                                           --select
                                           qq.de_LONG_NAME,
                                           de_PREFERRED_NAME,
                                           qq.CDE_ID,
                                           DECODE (
                                              INSTR (TO_CHAR (qq.de_version),
                                                     '.'),
                                              0, qq.de_version || '.0',
                                              qq.de_version),
                                           qq.DE_context,
                                           qq.DE_WORKFLOW,
                                           qq.D_PREFERRED_DEFINITION,
                                           CAST (
                                              MULTISET ( -- data set MDSR_FB_DESIGN_XML_LIST_T for VD
                                                 SELECT d.created_by,
                                                           TO_CHAR (
                                                              d.DATE_CREATED,
                                                              'YYYY-MM-DD')
                                                        || 'T'
                                                        || TO_CHAR (
                                                              d.DATE_CREATED,
                                                              'HH24:MI:SS')
                                                           "dateCreated",
                                                        DECODE (
                                                           d.DATE_MODIFIED,
                                                           NULL, NULL,
                                                              TO_CHAR (
                                                                 d.DATE_MODIFIED,
                                                                 'YYYY-MM-DD')
                                                           || 'T'
                                                           || TO_CHAR (
                                                                 d.DATE_MODIFIED,
                                                                 'HH24:MI:SS'))
                                                           "dateModified",
                                                        d.Modified_by,
                                                        d.LAE_NAME,
                                                        d.name,
                                                        DETL_NAME,
                                                        c.name,
                                                        CAST (
                                                           MULTISET ( --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                SELECT class_long_name,
                                                                       CS_ID,
                                                                       DECODE (
                                                                          INSTR (
                                                                             TO_CHAR (
                                                                                class_version),
                                                                             '.'),
                                                                          0,    class_version
                                                                             || '.0',
                                                                          class_version),
                                                                       preferred_definition,
                                                                       MDSR_FB_FORM_CLI_XML_T1 (
                                                                          clitem_long_name,
                                                                          CSI_ID,
                                                                          DECODE (
                                                                             INSTR (
                                                                                TO_CHAR (
                                                                                   clitem_version),
                                                                                '.'),
                                                                             0,    clitem_version
                                                                                || '.0',
                                                                             clitem_version),
                                                                          CSITL_NAME,
                                                                          CLI_PREF_DEF)
                                                                  FROM MDSR_FB_VM_CLASSIFICATION CL
                                                                 WHERE d.DESIG_IDSEQ =
                                                                          CL.ATT_IDSEQ(+)
                                                              ORDER BY CS_ID) AS MDSR_FB_FORM_CL_XML_LIST_T1) --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                   FROM SBR.DESIGNATIONS d,
                                                        SBR.contexts c
                                                  WHERE     c.CONTE_IDSEQ =
                                                               d.CONTE_IDSEQ
                                                        AND d.ac_idseq =
                                                               qq.de_idseq) AS MDSR_FB_DESIGN_XML_LIST_T1),
                                           MDSR_FB_VD_XML_T1 (    --1 data set
                                              vd.long_name,
                                              VD.preferred_name,
                                              vd.vd_id,
                                              DECODE (
                                                 INSTR (TO_CHAR (vd.version),
                                                        '.'),
                                                 0, vd.version || '.0',
                                                 vd.version),
                                              DECODE (vd.VD_TYPE_FLAG,
                                                      'E', 'Enumerated',
                                                      'N', 'NonEnumerated',
                                                      'Unknown'),
                                              cvd.name,
                                              vd.ASL_NAME,
                                              vd.DTL_NAME,
                                              vd.DECIMAL_PLACE,
                                              vd.FORML_NAME,
                                              vd.HIGH_VALUE_NUM,
                                              vd.LOW_VALUE_NUM,
                                              vd.MAX_LENGTH_NUM,
                                              vd.MIN_LENGTH_NUM,
                                              vd.UOML_NAME,
                                              CAST (
                                                 MULTISET (
                                                      SELECT c.long_name,
                                                             SUBSTR (
                                                                   DISPLAY_ORDER
                                                                || c.preferred_name,
                                                                2),
                                                                'http://ncit.nci.nih.gov/ncitbrowser/ConceptReport.jsp?dictionary=NCI%20Thesaurus'
                                                             || '&'
                                                             || 'amp;code='
                                                             || c.preferred_name
                                                                AS url
                                                        FROM COMPONENT_CONCEPTS_EXT cx,
                                                             CONCEPTS_EXT c
                                                       WHERE     cx.condr_idseq =
                                                                    vd.condr_idseq --'A9262D2A-4461-A9EB-E040-BB89AD43673D'
                                                             AND c.CON_IDSEQ =
                                                                    cx.CON_IDSEQ
                                                    ORDER BY DISPLAY_ORDER) AS MDSR_FB_VDCon_XML_LIST_T1) /* */
                                                                                                         ,
                                              CAST (
                                                 MULTISET (      --2d data set
                                                    SELECT pv.VALUE,
                                                           MDSR_FB_VM_XML_T1 (
                                                              vm2.vm_id,
                                                              DECODE (
                                                                 INSTR (
                                                                    TO_CHAR (
                                                                       vm2.version),
                                                                    '.'),
                                                                 0,    vm2.version
                                                                    || '.0',
                                                                 vm2.version),
                                                              vm2.long_name,
                                                              CAST (
                                                                 MULTISET ( --3d data set MDSR_FB_DESIGN_XML_LIST_T
                                                                    SELECT d.created_by,
                                                                              TO_CHAR (
                                                                                 d.DATE_CREATED,
                                                                                 'YYYY-MM-DD')
                                                                           || 'T'
                                                                           || TO_CHAR (
                                                                                 d.DATE_CREATED,
                                                                                 'HH24:MI:SS')
                                                                           || '.0'
                                                                              "dateCreated",
                                                                           DECODE (
                                                                              d.DATE_MODIFIED,
                                                                              NULL, NULL,
                                                                                 TO_CHAR (
                                                                                    d.DATE_MODIFIED,
                                                                                    'YYYY-MM-DD')
                                                                              || 'T'
                                                                              || TO_CHAR (
                                                                                    d.DATE_MODIFIED,
                                                                                    'HH24:MI:SS')
                                                                              || '.0'),
                                                                           d.Modified_by,
                                                                           d.LAE_NAME,
                                                                           d.name,
                                                                           DETL_NAME,
                                                                           c.name,
                                                                           CAST (
                                                                              MULTISET ( --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                                   SELECT class_long_name,
                                                                                          CS_ID,
                                                                                          DECODE (
                                                                                             INSTR (
                                                                                                TO_CHAR (
                                                                                                   class_version),
                                                                                                '.'),
                                                                                             0,    class_version
                                                                                                || '.0',
                                                                                             class_version),
                                                                                          preferred_definition,
                                                                                          MDSR_FB_FORM_CLI_XML_T1 (
                                                                                             clitem_long_name,
                                                                                             CSI_ID,
                                                                                             DECODE (
                                                                                                INSTR (
                                                                                                   TO_CHAR (
                                                                                                      clitem_version),
                                                                                                   '.'),
                                                                                                0,    clitem_version
                                                                                                   || '.0',
                                                                                                clitem_version),
                                                                                             CSITL_NAME,
                                                                                             CLI_PREF_DEF)
                                                                                     FROM MDSR_FB_VM_CLASSIFICATION CL
                                                                                    WHERE d.DESIG_IDSEQ =
                                                                                             CL.ATT_IDSEQ(+)
                                                                                 ORDER BY CS_ID) AS MDSR_FB_FORM_CL_XML_LIST_T1) --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                      FROM SBR.DESIGNATIONS d,
                                                                           SBR.contexts c
                                                                     WHERE     c.CONTE_IDSEQ =
                                                                                  d.CONTE_IDSEQ
                                                                           AND d.ac_idseq =
                                                                                  vm2.vm_idseq) AS MDSR_FB_DESIGN_XML_LIST_T1) --3d data set MDSR_FB_DESIGN_XML_LIST_T
                                                                                                                              ,
                                                              CAST (
                                                                 MULTISET ( --3d data set MDSR_FB_DEFIN_XML_LIST_T
                                                                    SELECT df.created_by,
                                                                              TO_CHAR (
                                                                                 df.DATE_CREATED,
                                                                                 'YYYY-MM-DD')
                                                                           || 'T'
                                                                           || TO_CHAR (
                                                                                 df.DATE_CREATED,
                                                                                 'HH24:MI:SS')
                                                                           || '.0'
                                                                              "dateCreated",
                                                                           DECODE (
                                                                              df.DATE_MODIFIED,
                                                                              NULL, NULL,
                                                                                 TO_CHAR (
                                                                                    df.DATE_MODIFIED,
                                                                                    'YYYY-MM-DD')
                                                                              || 'T'
                                                                              || TO_CHAR (
                                                                                    df.DATE_MODIFIED,
                                                                                    'HH24:MI:SS')
                                                                              || '.0')
                                                                              "dateModified",
                                                                           df.Modified_by,
                                                                           df.LAE_NAME,
                                                                           df.DEFINITION,
                                                                           DEFL_NAME,
                                                                           CAST (
                                                                              MULTISET ( --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                                   SELECT class_long_name,
                                                                                          CS_ID,
                                                                                          DECODE (
                                                                                             INSTR (
                                                                                                TO_CHAR (
                                                                                                   class_version),
                                                                                                '.'),
                                                                                             0,    class_version
                                                                                                || '.0',
                                                                                             class_version),
                                                                                          preferred_definition,
                                                                                          MDSR_FB_FORM_CLI_XML_T1 (
                                                                                             clitem_long_name,
                                                                                             CSI_ID,
                                                                                             DECODE (
                                                                                                INSTR (
                                                                                                   TO_CHAR (
                                                                                                      clitem_version),
                                                                                                   '.'),
                                                                                                0,    clitem_version
                                                                                                   || '.0',
                                                                                                clitem_version),
                                                                                             CSITL_NAME,
                                                                                             CLI_PREF_DEF)
                                                                                     FROM MDSR_FB_VM_CLASSIFICATION CL
                                                                                    WHERE df.DEFIN_IDSEQ =
                                                                                             CL.ATT_IDSEQ(+)
                                                                                 ORDER BY CS_ID) AS MDSR_FB_FORM_CL_XML_LIST_T1) --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                                                                                ,
                                                                           c.name
                                                                      FROM SBR.DEFINITIONS df,
                                                                           SBR.contexts c
                                                                     WHERE     c.CONTE_IDSEQ(+) =
                                                                                  df.CONTE_IDSEQ
                                                                           AND df.ac_idseq =
                                                                                  vm2.vm_idseq) AS MDSR_FB_DEFIN_XML_LIST_T1) --3d data set MDSR_FB_DEFIN_XML_LIST_T
                                                                                                                             ,
                                                              vm2.preferred_Definition),
                                                           DECODE (
                                                              pv.begin_date,
                                                              NULL, NULL,
                                                                 TO_CHAR (
                                                                    pv.begin_date,
                                                                    'YYYY-MM-DD')
                                                              || 'T'
                                                              || TO_CHAR (
                                                                    pv.begin_date,
                                                                    'HH24:MI:SS')
                                                              || '.0')
                                                              "begindate"
                                                      --,NULL
                                                      FROM SBR.VALUE_MEANINGS vm2,
                                                           SBR.PERMISSIBLE_VALUES pv,
                                                           VD_PVS vp
                                                     /* FROM SBR.VALUE_MEANINGS vm2,
                                                       SBR.PERMISSIBLE_VALUES pv
                                                       where vm2.vm_id='3197154'
                                                      AND vm2.vm_idseq = pv.VM_idseq*/
                                                     -- ,

                                                     WHERE     pv.pv_idseq =
                                                                  vp.pv_idseq --vm_id='3197154'
                                                           AND vm2.vm_idseq =
                                                                  pv.VM_idseq
                                                           AND vd.VD_IDSEQ =
                                                                  vp.VD_IDSEQ
                                                           AND vp.vd_idseq =
                                                                  qq.vd_idseq) AS MDSR_FB_PV_XML_LIST_T1) ---2d list MDSR_FB_PV_XML_LIST_T
                                                                                                         ,
                                              CAST (
                                                 MULTISET (
                                                    SELECT rd.name,
                                                           rd.DCTL_NAME,
                                                           c2.name,
                                                           rd.doc_text,
                                                           rd.LAE_NAME,
                                                           rd.url,
                                                           MDSR_FB_RD_ATTACH_XML_T1 (
                                                              rb.name,
                                                              rb.MIME_TYPE,
                                                              rb.doc_size)
                                                      FROM SBR.REFERENCE_DOCUMENTS rd,
                                                           SBR.contexts c2,
                                                           SBR.REFERENCE_BLOBS RB
                                                     WHERE     RD.RD_IDSEQ =
                                                                  RB.RD_IDSEQ(+)
                                                           AND c2.CONTE_IDSEQ =
                                                                  rd.CONTE_IDSEQ
                                                           AND rd.ac_idseq =
                                                                  qq.vd_idseq) AS MDSR_FB_RD_XML_LIST_T1)),
                                           CAST (
                                              MULTISET (
                                                 SELECT MDSR_FB_USECAT_XML (
                                                           'Mandatory',
                                                           ''),
                                                        '0',
                                                        MDSR_FB_DE_DR_XML_T1 (
                                                           '0',
                                                           '0',
                                                           MDSR_FB_VD_DR_XML_T1 (
                                                              'PRSN_WT_VAL',
                                                              'NonEnumerated',
                                                              'RELEASED',
                                                              MDSR_FB_VDC_DR_XML_T1 (
                                                                 'http://blankNode')))
                                                   FROM SBR.COMPLEX_DATA_ELEMENTS cdv,
                                                        SBR.DATA_ELEMENTS DE
                                                  WHERE     cdv.P_DE_IDSEQ(+) =
                                                               de.DE_IDSEQ
                                                        AND isDerived = 'true'
                                                        AND de.DE_IDSEQ =
                                                               qq.DE_IDSEQ) AS MDSR_FB_COM_DE_DR_XML_LIST_T1),
                                           CAST (
                                              MULTISET (
                                                 SELECT rd.name,
                                                        rd.DCTL_NAME,
                                                        c2.name,
                                                        rd.doc_text,
                                                        rd.LAE_NAME,
                                                        rd.url,
                                                        MDSR_FB_RD_ATTACH_XML_T1 (
                                                           rb.name,
                                                           rb.MIME_TYPE,
                                                           rb.doc_size)
                                                   FROM SBR.REFERENCE_DOCUMENTS rd,
                                                        SBR.contexts c2,
                                                        SBR.REFERENCE_BLOBS RB
                                                  WHERE     RD.RD_IDSEQ =
                                                               RB.RD_IDSEQ(+)
                                                        AND c2.CONTE_IDSEQ =
                                                               rd.CONTE_IDSEQ
                                                        AND rd.ac_idseq =
                                                               qq.de_idseq) AS MDSR_FB_RD_XML_LIST_T1),
                                              'https://cdebrowser.nci.nih.gov/CDEBrowser/search?elementDetails=9'
                                           || '&'
                                           || 'FirstTimer=0'
                                           || '&'
                                           || 'PageId=ElementDetailsGroup'
                                           || '&'
                                           || 'publicId='
                                           || QQ.CDE_ID
                                           || '&'
                                           || 'version='
                                           || DECODE (
                                                 INSTR (TO_CHAR (QQ.de_version),
                                                        '.'),
                                                 0, QQ.de_version || '.0',
                                                 QQ.de_version)),
                                        --  select
                                        CAST (
                                           MULTISET (
                                                SELECT TRIM (DISPLAY_ORDER),
                                                       TRIM (long_name),
                                                       TRIM (MEANING_TEXT),
                                                       TRIM (DESCRIPTION_TEXT),
                                                       REDCAP_INSTRUCTIONS_T (
                                                          TRIM (INSTRUCTION)),
                                                       MDSR_FB_VV_VM_XML_T1 (
                                                          vm_id,
                                                          DECODE (
                                                             INSTR (
                                                                TO_CHAR (
                                                                   vm_version),
                                                                '.'),
                                                             0, vm_version || '.0',
                                                             vm_version))
                                                  FROM SBREXT.MDSR_FB_VALID_VALUE_MVW MVV
                                                 WHERE MVV.QUEST_IDseq =
                                                          qq.QUES_IDseq
                                              ORDER BY DISPLAY_ORDER) AS MDSR_FB_VV_XML_LIST_T1)
                                           AS VV
                                   --select *from SBREXT.MDSR_FB_QUESTION_MVW QQ where QQ.QUES_IDSEQ= '430203EE-CCBE-6162-E053-F662850A2532';



                                   FROM SBREXT.MDSR_FB_QUESTION_MVW QQ,
                                        value_domains vd,
                                        SBR.contexts cvd
                                  WHERE     qq.mod_idseq = mm.MOD_IDSEQ
                                        AND cvd.CONTE_IDSEQ = vd.CONTE_IDSEQ
                                        AND vd.vd_idseq = qq.vd_idseq
                               ORDER BY QQ.DISPLAY_ORDER) AS MDSR_FB_QUESTION_XML_LIST_T1)
                            AS Question_LIST
                    FROM SBREXT.MDSR_FB_QUEST_MODULE_MVW mm
                   WHERE FR.qc_IDSEQ = mm.CRF_IDSEQ   --and mm.mod_id=4118190;
                ORDER BY mm.DISPLAY_ORDER) AS MDSR_FB_MODULE_XML_LIST_T1)
             AS MODULE_LIST,
          CAST (
             MULTISET (
                SELECT pe.lead_org,
                       pe.phase,
                       pe.TYPE,
                       pe.PROTOCOL_ID,
                       TRIM (pe.long_name),
                       c2.name,
                       pe.PREFERRED_NAME,
                       UTL_I18N.UNESCAPE_REFERENCE (
                          TRIM (pe.PREFERRED_DEFINITION))
                  FROM PROTOCOLS_EXT pe, protocol_qc_ext pq, SBR.contexts c2
                 WHERE     FR.qc_IDSEQ = pq.qc_idseq(+)
                       AND pq.proto_idseq = pe.PROTO_IDSEQ(+)
                       AND c2.CONTE_IDSEQ = pe.CONTE_IDSEQ) AS MDSR_FB_PROTOCOL_XML_LIST_T)
             AS Form_PROTOCOL,
          CAST (
             MULTISET (
                SELECT rd.name,
                       rd.DCTL_NAME,
                       c2.name,
                       rd.doc_text,
                       rd.LAE_NAME,
                       rd.url,
                       MDSR_FB_RD_ATTACH_XML_T1 (rb.name,
                                                 rb.MIME_TYPE,
                                                 rb.doc_size)
                  FROM SBR.REFERENCE_DOCUMENTS rd,
                       SBR.contexts c2,
                       SBR.REFERENCE_BLOBS RB
                 WHERE     RD.RD_IDSEQ = RB.RD_IDSEQ(+)
                       AND c2.CONTE_IDSEQ = rd.CONTE_IDSEQ
                       AND rd.ac_idseq = FR.qc_idseq) AS MDSR_FB_RD_XML_LIST_T1)
             AS REFDOC,
          CAST (
             MULTISET (
                  SELECT class_long_name,
                         CS_ID,
                         DECODE (INSTR (TO_CHAR (class_version), '.'),
                                 0, class_version || '.0',
                                 class_version),
                         preferred_definition,
                         MDSR_FB_FORM_CLI_XML_T1 (
                            clitem_long_name,
                            CSI_ID,
                            DECODE (INSTR (TO_CHAR (clitem_version), '.'),
                                    0, clitem_version || '.0',
                                    clitem_version),
                            CSITL_NAME,
                            CLI_PREF_DEF)
                    FROM MDSR_FB_classification CL
                   WHERE FR.qc_IDSEQ = CL.AC_IDSEQ(+)
                ORDER BY CS_ID) AS MDSR_FB_FORM_CL_XML_LIST_T1)
             AS form_CLass
     FROM SBREXT.QUEST_CONTENTS_EXT FR,
          SBR.contexts cf,
          (SELECT *
             FROM QUEST_CONTENTS_EXT
            WHERE QTL_NAME = 'FORM_INSTR') fi,
          (SELECT *
             FROM QUEST_CONTENTS_EXT
            WHERE QTL_NAME = 'FOOTER') ff
    WHERE     FR.ASL_NAME = 'RELEASED'
          AND cf.CONTE_IDSEQ = FR.CONTE_IDSEQ
          AND fi.DN_CRF_IDSEQ(+) = FR.qc_idseq
          AND ff.DN_CRF_IDSEQ(+) = FR.qc_idseq
          AND (FR.QTL_NAME = 'CRF' OR FR.QTL_NAME = 'TEMPLATE')
          AND FR.qc_id IN (3065877,
                           5590324,
                           2263415,
                           2262683,
                           3443682,
                           3691952,
                           5791100,
                           4964471,
                           2019334,
                           2019339,
                           2019340,
                           2019343,
                           2019346,
                           4118188,
                           4861838,
                           5317151,
                           3476190,
                           4750588,
                           5314951,
                           3476190,
                           5881710,
                           3915131,
                           4903131,
                           5108287)
/
CREATE TABLE SBREXT.MDSR_FB_XML_TEMP
(
  PROTOCOL      VARCHAR2(30 BYTE),
  TEXT          CLOB,
  FILE_NAME     VARCHAR2(200 BYTE),
  CREATED_DATE  DATE
)
/
CREATE TABLE SBREXT.MDSR_FB_XML_REPORT_ERR
(
  FILE_NAME         VARCHAR2(50 BYTE),
  REPORT_ERROR_TXT  VARCHAR2(1100 BYTE),
  DATE_PROCESSED    DATE
)
/	
CREATE OR REPLACE PUBLIC SYNONYM MDSR_FB_XML_REPORT_ERR FOR SBREXT.MDSR_FB_XML_REPORT_ERR;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_FB_XML_TEMP FOR SBREXT.MDSR_FB_XML_TEMP;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_FB_XML_VW FOR SBREXT.MDSR_FB_XML_VW;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_FB_CLASSIFICATION FOR SBREXT.MDSR_FB_CLASSIFICATION;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_FB_VM_CLASSIFICATION FOR SBREXT.MDSR_FB_VM_CLASSIFICATION;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_FB_QUEST_MODULE_MVW FOR SBREXT.MDSR_FB_QUEST_MODULE_MVW;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_FB_QUESTION_MVW FOR SBREXT.MDSR_FB_QUESTION_MVW;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_FB_VALID_VALUE_MVW FOR SBREXT.MDSR_FB_VALID_VALUE_MVW;


GRANT SELECT  ON MDSR_FB_XML_REPORT_ERR TO PUBLIC;
GRANT SELECT  ON MDSR_FB_XML_TEMP TO PUBLIC;
GRANT SELECT  ON MDSR_FB_XML_VW TO PUBLIC;
GRANT SELECT  ON MDSR_FB_CLASSIFICATION TO PUBLIC;
GRANT SELECT  ON MDSR_FB_VM_CLASSIFICATION TO PUBLIC;
GRANT SELECT  ON MDSR_FB_QUEST_MODULE_MVW TO PUBLIC;
GRANT SELECT  ON MDSR_FB_QUESTION_MVW TO PUBLIC;
GRANT SELECT  ON MDSR_FB_VALID_VALUE_MVW TO PUBLIC;
					   
CREATE OR REPLACE PROCEDURE SBREXT.MDSR_xml_FB_insert as

CURSOR c_form IS
SELECT qc_id,qc_idseq,version from  QUEST_CONTENTS_EXT 
 WHERE qc_id in (3065877,5590324,2263415,3443682,3691952,5791100,4964471,2019334,2019339,2019340,2019343,2019346,  
 4861838,5317151,3476190,4750588,5314951,3476190,5881710,3915131,4903131,5108287)
 and ASL_NAME='RELEASED';


 l_file_name      VARCHAR2 (100):='NA';
   l_file_path      VARCHAR2 (200);
   l_result         CLOB:=null;
   l_xmldoc          CLOB:=null;
   l_pid        VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
 BEGIN 
  FOR rec IN c_form LOOP  
BEGIN 
        l_file_path := 'SBREXT_DIR';       
        l_pid:=rec.qc_id;
         l_file_name :='MDSR_FB_XML_'||rec.qc_id||'.xml';-- v_protocol||'_'||rec.form_name||' _GeneratedFormFinalFormCartV2.xml';
        
        SELECT dbms_xmlgen.getxml( 'select*from MDSR_FB_XML_VW where "publicid" like'||''''||'%'||l_pid||'%'||'''')
 INTO l_result
        FROM DUAL ;
        insert into MDSR_FB_XML_TEMP VALUES (l_pid,l_result, l_file_name ,SYSDATE);
 
      --dbms_xslprocessor.clob2file(l_xmldoc,  l_file_path, l_file_name, nls_charset_id('UTF8'));

      commit;  
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into MDSR_FB_XML_REPORT_ERR VALUES (substr(l_file_name,1,49),  errmsg, sysdate);
        
     commit;   
     END;
     END LOOP;
    

  END;
/						   
   
   CREATE OR REPLACE PROCEDURE SBREXT.MDSR_FB_XML_TRANSFORM2 IS

l_file_name VARCHAR2(500):='FB XML FORMS';
 errmsg VARCHAR2(500):='Non';
BEGIN 

--delite tags----
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<ROWSET>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</ROWSET>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<MDSR_FB_VD_XML_T1>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</MDSR_FB_VD_XML_T1>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<referenceDocument_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</referenceDocument_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<referenceDocument_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<dataElementDerivation_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<MODULE_LIST>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</MODULE_LIST>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<FORM_PROTOCOL>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</FORM_PROTOCOL>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<FORM_PROTOCOL/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<questions_x005F_xx>'||chr(10) );--
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</questions_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<FORM_CLASS>'||chr(10) ) ;
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</FORM_CLASS>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</definition_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<definition_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<definition_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<PermissibleValue_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</PermissibleValue_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<PermissibleValue_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</designation_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<designation_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<designation_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</classification_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<classification_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<classification_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,' <valueDomainConcept/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<validValues_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</validValues_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<validValues_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<instruction/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<headerInstruction/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<footerInstruction/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<REF_DOC>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</REF_DOC>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<REF_DOC/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<attachments/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<valueDomainConcept_x005F_xx/>'||chr(10) );
--rename tags
update MDSR_FB_XML_TEMP set text=replace(text,'<dataElementDerivation_x005F_xx>','<dataElementDerivation>');
update MDSR_FB_XML_TEMP set text=replace(text,'</dataElementDerivation_x005F_xx>','</dataElementDerivation>');
update MDSR_FB_XML_TEMP set text=replace(text,'<?xml version="1.0"?>','<?xml version="1.0" encoding="UTF-8"?>');
update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_MODULE_XML_T1','module');
update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_QUESTION_XML_T1','question');
update MDSR_FB_XML_TEMP set text=replace(text,'DATA_ELEMENT_x005F_xx','dataElement');
update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_RD_XML_T1','referenceDocument');
update MDSR_FB_XML_TEMP set text=replace(text,'</ROW>','</form>');
update MDSR_FB_XML_TEMP set text=replace(text,'<ROW>','<form>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_PV_XML_T1','permissibleValue');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_VV_XML_T1','validValue');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_DESIGN_XML_T1','designation');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_DEFIN_XML_T1','definition');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_FORM_CL_XML_T1','classification');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'FclassificationItem_XX','classificationSchemeItem' );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_VD_XML_T1','valueDomain');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_VDCon_XML_T1','valueDomainConcept');
--dataElementDerivation 
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_PROTOCOL_XML_T','protocol');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_COM_DE_DR_XML_T1','componentDataElement');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<workflowStatus>','<workflowStatusName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<workflowStatus/>','<workflowStatusName/>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</workflowStatus>','</workflowStatusName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<publicid>','<publicID>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</publicid>','</publicID>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<publicId>','<publicID>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</publicId>','</publicID>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<Datatype>','<datatypeName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</Datatype>','</datatypeName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</longname>','</longName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<longname>','<longName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<MaximumLengthNumber>','<maximumLengthNumber>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</MaximumLengthNumber>','</maximumLengthNumber>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<MinimumLengthNumber>','<minimumLengthNumber>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</MinimumLengthNumber>','</minimumLengthNumber>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</Name>','</name>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<Name>','<name>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</url>','</URL>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<url>','<URL>');

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<ModifiedBy>','<modifiedBy>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</ModifiedBy>','</modifiedBy>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'valueDomainConcept_x005F_xx','valueDomainConcept');

  commit;    
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into REPORTS_ERROR_LOG VALUES (l_file_name,  errmsg, sysdate);
     commit;   

END ;
/
SPOOL OFF
   