

CREATE OR REPLACE TYPE          "MDSR_FB_DESIGNATIONS_XML_T"          as object(
"createdBy"                                      VARCHAR2(100)
,"dateCreated"                         VARCHAR2(30)
,"languageName"                                           VARCHAR2(30) 
,"name"                                               VARCHAR2(2000)
,"type"                                      VARCHAR2(20)--"DETL_NAME"
,"context"                                     VARCHAR2(30) 
   );
/
CREATE OR REPLACE TYPE MDSR_FB_DESIGN_XML_LIST_T AS TABLE OF  MDSR_FB_DESIGNATIONS_XML_T;


CREATE OR REPLACE TYPE          "MDSR_FB_VM_XML_T4"          as object(
"publicID"          number,
"version"             number (4,2),
"longname"        varchar2 (300) ,
"designation"    MDSR_FB_DESIGN_XML_LIST_T,
"preferredDefinition"  VARCHAR2(2000));
/
CREATE OR REPLACE TYPE  "MDSR_FB_VM_XML_LIST_T4"  AS TABLE OF  MDSR_FB_VM_XML_T4;
/
CREATE OR REPLACE TYPE          "MDSR_FB_PV_XML_T4"          as object(
 
 "value"       varchar2 (300) ,
"valueMeaning"    MDSR_FB_VM_XML_LIST_T4);
/
CREATE OR REPLACE TYPE  "MDSR_FB_PV_XML_LIST_T4"  AS TABLE OF  MDSR_FB_PV_XML_T4;
/
CREATE OR REPLACE TYPE          "MDSR_FB_VD_XML_T4"                                          AS OBJECT
(   
  "longName"      varchar2(255),
  "publicId"         number,
  "version"                number (4,2),
  "type"        varchar2 (50),
  "workflowStatus"         varchar2 (20), 
  "Datatype"               varchar2 (20),   
  "MaximumLength"          number (8),
  "MinimumLength"          number (8),
  "PermissibleValue"    MDSR_FB_PV_XML_LIST_T4
);
/
CREATE OR REPLACE TYPE  "MDSR_FB_VD_XML_LIST_T4"  AS TABLE OF  MDSR_FB_VD_XML_T4;
/
/

CREATE OR REPLACE TYPE          "MDSR_FB_DATA_EL_XML_T4"                                          AS OBJECT
(   
  "longName"      varchar2(255),
  "shortName"   varchar2(60),
  "publicId"         number,
  "version"                number (4,2),
  "context"    VARCHAR2(40),
  "workflowStatus"         varchar2 (20), 
  "preferredDefinition" VARCHAR2(2000),
  "valueDomain"    MDSR_FB_VD_XML_LIST_T4
);

CREATE OR REPLACE TYPE          "MDSR_FB_DATA_EL_XML_T3"                                          AS OBJECT
(   
  "longName"      varchar2(255),
  "shortName"   varchar2(60),
  "publicId"         number,
  "version"                number (4,2),
  "context"    VARCHAR2(40),
  "workflowStatus"         varchar2 (20), 
  "preferredDefinition" VARCHAR2(2000),
  "valueDomain"    MDSR_FB_VD_XML_T4
);
CREATE OR REPLACE TYPE        MDSR_FB_QUESTION_XML_T   as object(
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
"dataElement_xx" MDSR_FB_DATA_EL_XML_T3
"validValues_xx"       REDCAP_validValue_LIST_T )
/
CREATE OR REPLACE TYPE  "MDSR_FB_DATA_EL_XML_LIST_T4"  AS TABLE OF  MDSR_FB_DATA_EL_XML_T4;
CREATE OR REPLACE TYPE               MDSR_FB_PROTOCOL_XML_T as object(
 "leadOrganization" VARCHAR2(50),
 "phase" VARCHAR2(5),
"type" VARCHAR2(250),
"protocolID" VARCHAR2(50),
"longName"  VARCHAR2(255),
"context"   VARCHAR2(10),
"shortName"  VARCHAR2(50),
"preferredDefinition"  VARCHAR2(2000))
/
CREATE OR REPLACE TYPE  "MDSR_FB_PROTOCOL_XML_LIST_T"  AS TABLE OF  MDSR_FB_PROTOCOL_XML_T
/
CREATE OR REPLACE TYPE                MDSR_FB_MODULE_XML_T    as object(
"displayOrder"                                     NUMBER
,"maximumModuleRepeat"                              NUMBER
,"createdBy"   VARCHAR2(40) 
,"publicid"  NUMBER
,"version"  NUMBER

, "preferredDefinition" VARCHAR2(2000)

)
/
CREATE OR REPLACE TYPE  "MDSR_FB_MODULE_XML_LIST_T"  AS TABLE OF  MDSR_FB_MODULE_XML_T
/
CREATE OR REPLACE TYPE             SBREXT.MDSR_FB_FORM_XML_T    as object(    
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
,"version"  NUMBER
,"workflowStatusName" VARCHAR2(40)
,"categoryName" VARCHAR2(255) 
,"type"              VARCHAR2(5) 
--,"headerInstruction"     SBREXT.REDCAP_HINSTRUCTIONS_T                       
--,"footerInstruction"  VARCHAR2(100)
,"module" SBREXT.MDSR_FB_MODULE_XML_T
,"protocol" SBREXT.MDSR_FB_PROTOCOL_XML_T)
/

      CREATE OR REPLACE FORCE VIEW SBREXT.MDSR_XML_FB_FORMS_VIEW
(
   QC_IDSEQ,
   VERSION,
   TYPE,
   CONTE_IDSEQ,
   CATEGORY_NAME,
   WORKFLOW,
   PREFERRED_NAME,
   DEFINITION,
   LONG_NAME,  
   CONTEXT_NAME,
   CREATED_BY,
   DATE_CREATED,
   DATE_MODIFIED,
   PUBLIC_ID,
   CHANGE_NOTE,
   LATEST_VERSION_IND
)
AS
     SELECT crf.QC_IDSEQ,
            crf.VERSION,
            crf.QTL_NAME,
            crf.CONTE_IDSEQ,
            crf.QCDL_NAME,
            crf.ASL_NAME,
            crf.PREFERRED_NAME,
            crf.PREFERRED_DEFINITION,
            crf.LONG_NAME,      
            cnt.NAME,
            crf.CREATED_BY,
            crf.DATE_CREATED,
            crf.DATE_MODIFIED,            
            crf.QC_ID,
            crf.change_note,
            crf.LATEST_VERSION_IND
       FROM QUEST_CONTENTS_EXT crf,
            CONTEXTS cnt
          
      WHERE  (crf.QTL_NAME = 'CRF' OR crf.QTL_NAME = 'TEMPLATE')
            AND crf.ASL_NAME='RELEASED'
            AND crf.CONTE_IDSEQ = cnt.CONTE_IDSEQ
            AND instr(cnt.NAME,'TEST')=0
            AND instr(NAME,'Training')=0
   ORDER BY crf.LONG_NAME;
CREATE OR REPLACE FORCE VIEW SBREXT.MDSR_XML_FB_MODULES_VIEW
(
   MOD_IDSEQ,
   CRF_IDSEQ,
   MOD_ID,
   VERSION,
   CONTE_IDSEQ,
   WORKFLOW,
   PREFERRED_NAME,
   DEFINITION,
   LONG_NAME,
   LATEST_VERSION_IND,
   QR_IDSEQ,
   P_QC_IDSEQ,
   C_QC_IDSEQ,
   DISPLAY_ORDER,
   REPEAT_NO
)
AS
     SELECT MOD.QC_IDSEQ,
            MOD.DN_CRF_IDSEQ,
            MOD.QC_ID,
            MOD.VERSION,
            MOD.CONTE_IDSEQ,
            MOD.ASL_NAME,
            MOD.PREFERRED_NAME,
            MOD.PREFERRED_DEFINITION,
            MOD.LONG_NAME,
            MOD.LATEST_VERSION_IND,
            qr.QR_IDSEQ,
            qr.P_QC_IDSEQ,
            qr.C_QC_IDSEQ,
            qr.DISPLAY_ORDER,
            MOD.repeat_no
       FROM SBREXT.QUEST_CONTENTS_EXT MOD, QC_RECS_EXT qr
      WHERE     MOD.QC_IDSEQ = qr.C_QC_IDSEQ
            AND MOD.qtl_name = 'MODULE'
            AND MOD.DELETED_IND = 'No'
            AND qr.RL_NAME = 'FORM_MODULE'
   ORDER BY MOD.DN_CRF_IDSEQ, qr.DISPLAY_ORDER;
   
   
   
   
    select QQ.qc_id,QQ.version,'false',QQ.DISPLAY_ORDER,qq.date_created,qq.date_Modified,qq.long_name,
                                                       qa.EDITABLE_IND,qa.MANDATORY_IND,qq.REPEAT_NO,
                                                       CAST (
                                                          MULTISET (
                                                               SELECT TRIM (DISPLAY_ORDER),
                                                                      TRIM (VALUE),
                                                                      TRIM (MEANING_TEXT),
                                                                      TRIM (DESCRIPTION_TEXT),
                                                                      MDSR_FB_VV_VM_XML_T(vvm.vm_id,
                                                                      vvm.version)
                                                                 FROM  QUEST_CONTENTS_EXT QV,
                                                                 VALID_VALUES_ATT_EXT  VV , 
                                                             SBR.VALUE_MEANINGS vvm,
                                                                SBR.PERMISSIBLE_VALUES vpv,
                                                             VD_PVS vvp
                                                               where VV.QC_IDSEQ=QV.QC_IDSEQ
                                                               and P_QST_IDSEQ=qq.qc_idseq--'C0008243-FD07-E8E1-E040-BB89AD437A55'
                                                        and vpv.pv_idseq=vvp.pv_idseq--vm_id='3197154'
                                                        and vvm.vm_idseq=vpv.VM_idseq
                                                        and qv.VP_IDSEQ=vvp.VP_IDSEQ --and qv.VP_IDSEQ='871A0137-4215-F855-E040-BB89AD436829'
                                                        order by DISPLAY_ORDER)as MDSR_FB_VV_XML_LIST_T)
                                                        from QUEST_CONTENTS_EXT qq,
                                                        QUEST_ATTRIBUTES_EXT qa  
                                                        where
                                                        qq.QC_IDSEQ=qa.QC_IDSEQ
                                                        and qq.qc_idseq='C0008243-FD07-E8E1-E040-BB89AD437A55'