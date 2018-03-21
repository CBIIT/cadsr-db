drop type MDSR_FB_MODULE_XML_LIST_T33;
drop type MDSR_FB_MODULE_XML_T33;
drop type MDSR_FB_PROTOCOL_XML_LIST_T;
drop type MDSR_FB_PROTOCOL_XML_T;


drop type MDSR_FB_QUESTION_XML_LIST_T33;
drop type MDSR_FB_QUESTION_XML_T33;
drop type MDSR_FB_FORM_CLI_XML_T;
drop type MDSR_FB_FORM_CL_XML_LIST_T;
drop type MDSR_FB_FORM_CL_XML_LIST_T;
drop type MDSR_FB_QUESTION_XML_LIST_T33;
drop type MDSR_FB_QUESTION_XML_T33;

drop type MDSR_FB_DATA_EL_XML_T;
drop type MDSR_FB_VV_XML_LIST_T;
drop type MDSR_FB_VV_XML_T;
drop type MDSR_FB_VV_VM_XML_T; 

drop type MDSR_FB_RD_XML_LIST_T4;
drop type MDSR_FB_RD_XML_T4;

drop type MDSR_FB_VD_XML_LIST_T;
drop type MDSR_FB_VD_XML_T;
--drop type MDSR_FB_VM_XML_T ;
drop type MDSR_FB_PV_XML_LIST_T;
drop type MDSR_FB_PV_XML_T;
drop type MDSR_FB_PV_XML_T;?

drop type MDSR_FB_DEFIN_XML_LIST_T;
drop type MDSR_FB_DEFIN_XML_T;
drop type MDSR_FB_DESIGN_XML_LIST_T;
drop type MDSR_FB_DESIGN_XML_T;

drop type MDSR_FB_FORM_CL_XML_LIST_T;
drop type MDSR_FB_FORM_CL_XML_T;
drop type MDSR_FB_FORM_CLI_XML_T;


                                     
 CREATE OR REPLACE TYPE               MDSR_FB_FORM_CLI_XML_T as object(   --1
 "name" VARCHAR2(60),
 "publicID"        NUMBER,
"version"          VARCHAR2(8),
"type"   VARCHAR2(20))
/
CREATE OR REPLACE TYPE               MDSR_FB_FORM_CL_XML_T as object(    --2
 "name" VARCHAR2(60),
 "publicID"        NUMBER,
"version"          VARCHAR2(8),
"preferredDefinition"  VARCHAR2(2000),
"FclassificationItem_XX"  MDSR_FB_FORM_CLI_XML_T)
/

CREATE OR REPLACE TYPE         MDSR_FB_FORM_CL_XML_LIST_T         as table of MDSR_FB_CL_XML_T;  --3
/
CREATE OR REPLACE TYPE          "MDSR_FB_DEFIN_XML_T"          as object(   -- 4
"createdBy"                            VARCHAR2(100)
,"dateCreated"                         VARCHAR2(30)
,"languageName"                         VARCHAR2(30) 
,"text"                                 VARCHAR2(2000)
,"type"                                 VARCHAR2(50)--"DETL_NAME"
,"classification_xx"  "MDSR_FB_FORM_CL_XML_LIST_T" );
/
CREATE OR REPLACE TYPE          "MDSR_FB_DESIGN_XML_T"          as object(  -- 4
"createdBy"                            VARCHAR2(100)
,"dateCreated"                         VARCHAR2(30)
,"languageName"                        VARCHAR2(30) 
,"name"                                VARCHAR2(2000)
,"type"                                VARCHAR2(20)--"DETL_NAME"
,"context"                             VARCHAR2(30) 
,"classification_xx"  "MDSR_FB_FORM_CL_XML_LIST_T" );
/
CREATE OR REPLACE TYPE         MDSR_FB_DESIGN_XML_LIST_T         as table of MDSR_FB_DESIGN_XML_T;  --5
/
CREATE OR REPLACE TYPE         MDSR_FB_DEFIN_XML_LIST_T         as table of MDSR_FB_DEFIN_XML_T;  --5
/
CREATE OR REPLACE TYPE          "MDSR_FB_VM_XML_T"          as object(
"publicID"          number,
"version"             number (4,2),
"longname"        varchar2 (300) ,
"designation_xx"    MDSR_FB_DESIGN_XML_LIST_T,
"definition_xx"   MDSR_FB_DEFIN_XML_LIST_T,
"preferredDefinition"  VARCHAR2(2000));
/
CREATE OR REPLACE TYPE          "MDSR_FB_PV_XML_T"          as object( --6
 
 "value"       varchar2 (300) ,
"valueMeaning"    MDSR_FB_VM_XML_T);
/
CREATE OR REPLACE TYPE         MDSR_FB_PV_XML_LIST_T    as table of MDSR_FB_PV_XML_T;  --7
/
CREATE OR REPLACE TYPE          MDSR_FB_VD_XML_T    AS OBJECT  --8
(   
  "longName"      varchar2(255),
  "publicId"         number,
  "version"                number (4,2),
  "type"        varchar2 (50),
  "workflowStatus"         varchar2 (20), 
  "Datatype"               varchar2 (20),   
  "MaximumLength"          number (8),
  "MinimumLength"          number (8),
  "PermissibleValue"    MDSR_FB_PV_XML_LIST_T
);
/
CREATE OR REPLACE TYPE     MDSR_FB_VD_XML_LIST_T      as table of MDSR_FB_VD_XML_T;  --9
/
CREATE OR REPLACE TYPE          MDSR_FB_RD_ATTACH_XML_T      AS OBJECT --7
(   
  "name"      varchar2(355),
  "mimeType"    VARCHAR2(128 BYTE), 
  "size"     NUMBER);
  
CREATE OR REPLACE TYPE          MDSR_FB_RD_XML_T       AS OBJECT --8
(   
  "Name"      varchar2(255),
  "type"   varchar2(60), 
  "context"    VARCHAR2(40),
  "doctext"     VARCHAR2(4000),
  "languageName" VARCHAR2(40),
  "url"  varchar2(240),
  "attachments" MDSR_FB_RD_ATTACH_XML_T
);
/
CREATE OR REPLACE TYPE     MDSR_FB_RD_XML_LIST_T     as table of MDSR_FB_RD_XML_T;  --9
/
CREATE OR REPLACE TYPE       MDSR_FB_VV_VM_XML_T   as object( --7
"publicID"                                     NUMBER
,"version"                number (4,2)
)
/
CREATE OR REPLACE TYPE       MDSR_FB_VV_XML_T   as object( --8
"displayOrder"                                     NUMBER
,"value"                                      VARCHAR2(2000)
,"meaningText"                                  VARCHAR2(2000)  
,"description" VARCHAR2(2000)
,"valueMeaning"   MDSR_FB_VV_VM_XML_T )
/
CREATE OR REPLACE TYPE     MDSR_FB_VV_XML_LIST_T     as table of MDSR_FB_VV_XML_T;  --9
/
CREATE OR REPLACE TYPE          "MDSR_FB_DATA_EL_XML_T"    AS OBJECT --10
(   
  "longName"      varchar2(255),
  "shortName"   varchar2(60),
  "publicId"         number,
  "version"                number (4,2),
  "context"    VARCHAR2(40),
  "workflowStatus"         varchar2 (20), 
  "preferredDefinition" VARCHAR2(2000),
  "valueDomain"    MDSR_FB_VD_XML_LIST_T,
  "cdeBrowserLink"       VARCHAR2(500)
);
/
CREATE OR REPLACE TYPE        MDSR_FB_QUESTION_XML_T   as object(--11
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
"long_name"        VARCHAR2(255),          
"shortname"         VARCHAR2(50),
"de_publicID"        NUMBER,
"de_version"          VARCHAR2(8),
"workflowStatusName"  VARCHAR2(30),
"context"            VARCHAR2(30),
"preferredDefinition" VARCHAR2(4000),
"VALUE_DOMAIN_xx"       MDSR_FB_VD_XML_LIST_T,
"referenceDocument_xx"  MDSR_FB_RD_XML_LIST_T,
"validValues_xx"        MDSR_FB_VV_XML_LIST_T)
/

CREATE OR REPLACE TYPE          MDSR_FB_VD_XML_T    AS OBJECT  --8
(   
  "longName"      varchar2(255),
  "publicId"         number,
  "version"                number (4,2),
  "type"        varchar2 (50),
  "workflowStatus"         varchar2 (20), 
  "Datatype"               varchar2 (20),   
  "MaximumLength"          number (8),
  "MinimumLength"          number (8),
  "PermissibleValue"    MDSR_FB_PV_XML_LIST_T
);
<dataElementDerivation>
               <componentDataElement>
                  <usageCategory>
                     <usageType>Mandatory</usageType>
                  </usageCategory>
                  <displayOrder>0</displayOrder>
                  <dataElement>
                     <publicID>0</publicID>
                     <version>0</version>
                     <valueDomain>
                        <shortName>PRSN_WT_VAL</shortName>
                        <type>NonEnumerated</type>
                        <workflowStatusName>RELEASED</workflowStatusName>
                        <valueDomainConcept>
                           <nciTermBrowserLink>http://blankNode</nciTermBrowserLink>
                        </valueDomainConcept>
                     </valueDomain>
                  </dataElement>
               </componentDataElement>
            </dataElementDerivation>
            
 CREATE OR REPLACE TYPE        MDSR_FB_MODULE_XML_T    as object(
"displayOrder"                                     NUMBER
,"maximumModuleRepeat"                              NUMBER
,"longName"   VARCHAR2(255) 
,"instruction"      REDCAP_INSTRUCTIONS_T
, "preferredDefinition" VARCHAR2(2000)
,"publicid"  NUMBER
,"version"  NUMBER
,"usageCategory"  MDSR_FB_USECAT_XML
,"questions_xx"   MDSR_FB_QUESTION_XML_LIST_T
)
/           
            
CREATE OR REPLACE TYPE                    MDSR_FB_FORM_XML_T3    as object(    
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

,"module_xx" SBREXT.MDSR_FB_MODULE_XML_LIST_T
,"referenceDocument_xx"  MDSR_FB_RD_XML_LIST_T
,"classification_xx"  MDSR_FB_FORM_CL_XML_LIST_T
,"protocol_xx" MDSR_FB_PROTOCOL_XML_LIST_T 
)
/
