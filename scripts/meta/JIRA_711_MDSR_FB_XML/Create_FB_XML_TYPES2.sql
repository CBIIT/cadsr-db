--new--
drop type MDSR_FB_FORM_XML_T1;

drop type MDSR_FB_MODULE_XML_LIST_T1;
drop type MDSR_FB_MODULE_XML_T1;
drop type MDSR_FB_PROTOCOL_XML_LIST_T;
drop type MDSR_FB_PROTOCOL_XML_T;

drop type MDSR_FB_QUESTION_XML_LIST_T1;
drop type MDSR_FB_QUESTION_XML_T1;


drop type MDSR_FB_FORM_CLI_XML_T1;
drop type MDSR_FB_FORM_CL_XML_LIST_T1;
drop type MDSR_FB_FORM_CL_XML_LIST_T;

drop type MDSR_FB_DATA_EL_XML_T1;--MDSR_FB_DATA_EL_XML_T 
drop type MDSR_FB_VV_XML_LIST_T1;
drop type MDSR_FB_VV_XML_T1;
drop type MDSR_FB_VV_VM_XML_T1; 


drop type  MDSR_FB_COM_DE_DR_XML_LIST_T1;
drop type  MDSR_FB_COM_DE_DR_XML_T1;
drop type MDSR_FB_DE_DR_XML_T1;

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


                                     
 CREATE OR REPLACE TYPE               MDSR_FB_FORM_CLI_XML_T1 as object(   --1
 "name" VARCHAR2(60),
 "publicID"        NUMBER,
"version"          VARCHAR2(8),
"type"   VARCHAR2(20)
,"preferredDefinition"  VARCHAR2(2000))
/
CREATE OR REPLACE TYPE               MDSR_FB_FORM_CL_XML_T1 as object(    --2
 "name" VARCHAR2(60),
 "publicID"        NUMBER,
"version"          VARCHAR2(8),
"preferredDefinition"  VARCHAR2(2000),
"FclassificationItem_XX"  MDSR_FB_FORM_CLI_XML_T1)
/

CREATE OR REPLACE TYPE         MDSR_FB_FORM_CL_XML_LIST_T1         as table of MDSR_FB_FORM_CL_XML_T1;  --3  dateModified
/
CREATE OR REPLACE TYPE          "MDSR_FB_DEFIN_XML_T1"          as object(   -- 4
"createdBy"                            VARCHAR2(100)
,"dateCreated"                         VARCHAR2(30)
,"dateModified"                         VARCHAR2(30)
,"ModifiedBy"                            VARCHAR2(100)
,"languageName"                         VARCHAR2(30) 
,"text"                                 VARCHAR2(2000)
,"type"                                 VARCHAR2(50)--"DETL_NAME"
,"classification_xx"  "MDSR_FB_FORM_CL_XML_LIST_T1" 
,"context"                             VARCHAR2(30) 
);
/
CREATE OR REPLACE TYPE          "MDSR_FB_DESIGN_XML_T1"          as object(  -- 4
"createdBy"                            VARCHAR2(100)
,"dateCreated"                         VARCHAR2(30)
,"dateModified"                         VARCHAR2(30)
,"modifiedBy"                            VARCHAR2(100)
,"languageName"                        VARCHAR2(30) 
,"name"                                VARCHAR2(2000)
,"type"                                VARCHAR2(20)--"DETL_NAME"
,"context"                             VARCHAR2(30) 
,"classification_xx"  "MDSR_FB_FORM_CL_XML_LIST_T1" );
/
CREATE OR REPLACE TYPE         MDSR_FB_DESIGN_XML_LIST_T1         as table of MDSR_FB_DESIGN_XML_T1;  --5
/
CREATE OR REPLACE TYPE         MDSR_FB_DEFIN_XML_LIST_T1         as table of MDSR_FB_DEFIN_XML_T1;  --5
/
CREATE OR REPLACE TYPE          "MDSR_FB_VM_XML_T1"          as object(
"publicID"          number,
"version"             number (4,2),
"longname"        varchar2 (300) ,
"designation_xx"    MDSR_FB_DESIGN_XML_LIST_T1,
"definition_xx"   MDSR_FB_DEFIN_XML_LIST_T1,
"preferredDefinition"  VARCHAR2(2000));
/
CREATE OR REPLACE TYPE          "MDSR_FB_PV_XML_T1"          as object( --6
 
"value"       varchar2 (300) ,
"valueMeaning"    MDSR_FB_VM_XML_T1,
"beginDate"      varchar2 (30) ,
"endDate"         varchar2 (30));
/
CREATE OR REPLACE TYPE         MDSR_FB_PV_XML_LIST_T1    as table of MDSR_FB_PV_XML_T1;  --7
/

CREATE OR REPLACE TYPE          MDSR_FB_VDCon_XML_T1          as object( --6
 
 "primaryConceptName"       varchar2 (260) ,
 "primaryConceptCode"       varchar2 (30) ,
  "nciTermBrowserLink"       varchar2 (200) )
/
CREATE OR REPLACE TYPE         MDSR_FB_VDCon_XML_LIST_T1    as table of MDSR_FB_VDCon_XML_T1;  --7
 
/
CREATE OR REPLACE TYPE          MDSR_FB_RD_ATTACH_XML_T1      AS OBJECT --7
(   
  "name"      varchar2(355),
  "mimeType"    VARCHAR2(128 BYTE), 
  "size"     NUMBER);
  /
CREATE OR REPLACE TYPE          MDSR_FB_RD_XML_T1       AS OBJECT --8
(   
  "name"      varchar2(255),
  "type"   varchar2(60), 
  "context"    VARCHAR2(40),
  "doctext"     VARCHAR2(4000),
  "languageName" VARCHAR2(40),
  "URL"  varchar2(240),
  "attachments" MDSR_FB_RD_ATTACH_XML_T1
);
/
CREATE OR REPLACE TYPE     MDSR_FB_RD_XML_LIST_T1     as table of MDSR_FB_RD_XML_T1;  --9





CREATE OR REPLACE TYPE          MDSR_FB_VD_XML_T1    AS OBJECT  --8
(   
  "longName"      varchar2(255),
  "shortName"    varchar2(30),
  "publicId"         number,
  "version"                number (4,2),
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
);
/
CREATE OR REPLACE TYPE          MDSR_FB_VDC_DR_XML_T1    AS OBJECT  --8
(   
  "nciTermBrowserLink"      varchar2(255)
);

CREATE OR REPLACE TYPE          MDSR_FB_VD_DR_XML_T1    AS OBJECT  --8
(   
  "shortName"      varchar2(255),
  "type"        varchar2 (50),
  "workflowStatusName"         varchar2 (20), 
  "valueDomainConcept"  MDSR_FB_VDC_DR_XML_T1
);


CREATE OR REPLACE TYPE          MDSR_FB_DE_DR_XML_T1    AS OBJECT  --8
(   
  "publicId"         number,
  "version"                number (4,2),  
  "valueDomain"    MDSR_FB_VD_DR_XML_T1
);
--desc sbr.value_domains
--CREATE OR REPLACE TYPE     MDSR_FB_VD_XML_LIST_T1      as table of MDSR_FB_VD_XML_T1;  --9

CREATE OR REPLACE TYPE          MDSR_FB_COM_DE_DR_XML_T1    AS OBJECT  --8
(   
  "usageCategory"  MDSR_FB_USECAT_XML,
  "displayOrder"         number, 
  "dataElement"     MDSR_FB_DE_DR_XML_T1 
);
CREATE OR REPLACE TYPE     MDSR_FB_COM_DE_DR_XML_LIST_T1     as table of MDSR_FB_COM_DE_DR_XML_T1;

/
CREATE OR REPLACE TYPE          "MDSR_FB_DATA_EL_XML_T1"    AS OBJECT --10
(   
  "longName"      varchar2(255),
  "shortName"   varchar2(60),--preferred-name
  "publicId"         number,
  "version"                number (4,2),
  "context"    VARCHAR2(40),
  "workflowStatus"         varchar2 (20), 
  "preferredDefinition" VARCHAR2(2000),
  "designation_xx"    MDSR_FB_DESIGN_XML_LIST_T1,
  "valueDomain"    MDSR_FB_VD_XML_T1,  
  "dataElementDerivation_xx"  MDSR_FB_COM_DE_DR_XML_LIST_T1, --
  "referenceDocument_xx"  MDSR_FB_RD_XML_LIST_T1,
  "cdeBrowserLink"       VARCHAR2(500)
);
/
/
CREATE OR REPLACE TYPE       MDSR_FB_VV_VM_XML_T1   as object( --7
"publicID"                                     NUMBER
,"version"                number (4,2)
)
/
CREATE OR REPLACE TYPE       MDSR_FB_VV_XML_T1   as object( --8
"displayOrder"                                     NUMBER
,"value"                                      VARCHAR2(2000)
,"meaningText"                                  VARCHAR2(2000)  
,"description" VARCHAR2(2000)
,"instruction"    REDCAP_INSTRUCTIONS_T
,"valueMeaning"   MDSR_FB_VV_VM_XML_T1 )
/
CREATE OR REPLACE TYPE     MDSR_FB_VV_XML_LIST_T1     as table of MDSR_FB_VV_XML_T1;  --9
/

CREATE OR REPLACE TYPE        MDSR_FB_QUESTION_XML_T1   as object(--11
"publicID"        NUMBER,
"version"          VARCHAR2(8),
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

CREATE OR REPLACE TYPE     MDSR_FB_QUESTION_XML_LIST_T1     as table of MDSR_FB_QUESTION_XML_T1;




            
 CREATE OR REPLACE TYPE        MDSR_FB_MODULE_XML_T1    as object(
"displayOrder"                                     NUMBER
,"maximumModuleRepeat"                              NUMBER
,"longName"   VARCHAR2(255) 
,"instruction"      REDCAP_INSTRUCTIONS_T
, "preferredDefinition" VARCHAR2(2000)
,"publicid"  NUMBER
,"version"  NUMBER
,"usageCategory"  MDSR_FB_USECAT_XML
,"questions_xx"   MDSR_FB_QUESTION_XML_LIST_T1
)
/           
  CREATE OR REPLACE TYPE     MDSR_FB_MODULE_XML_LIST_T1     as table of MDSR_FB_MODULE_XML_T1;          
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
,"version"  NUMBER
,"workflowStatusName" VARCHAR2(40)
,"categoryName" VARCHAR2(255) 
,"type"              VARCHAR2(5) 
,"headerInstruction"     SBREXT.REDCAP_HINSTRUCTIONS_T                 

,"module_xx" SBREXT.MDSR_FB_MODULE_XML_LIST_T1
,"protocol_xx" MDSR_FB_PROTOCOL_XML_LIST_T 
,"referenceDocument_xx"  MDSR_FB_RD_XML_LIST_T1
,"classification_xx"  MDSR_FB_FORM_CL_XML_LIST_T1

)
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
,"version"  NUMBER
,"workflowStatusName" VARCHAR2(40)
,"categoryName" VARCHAR2(255) 
,"type"              VARCHAR2(5) 
,"headerInstruction"     SBREXT.REDCAP_HINSTRUCTIONS_T                 

,"module_xx" SBREXT.MDSR_FB_MODULE_XML_LIST_T1
,"protocol_xx" MDSR_FB_PROTOCOL_XML_LIST_T 
,"referenceDocument_xx"  MDSR_FB_RD_XML_LIST_T1
,"classification_xx"  MDSR_FB_FORM_CL_XML_LIST_T1

)
/
