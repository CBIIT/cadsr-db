CREATE OR REPLACE TYPE SBREXT.MDSR_749_ALTERNATENAME_ITEM_T          as object(
"ContextName"                             VARCHAR2(30),
"ContextVersion"                        VARCHAR2(10),
"AlternateName"                                VARCHAR2(2000)
,"AlternateNameType"                                VARCHAR2(20)--"DETL_NAME"
,"Language"                        VARCHAR2(30)

)
/
CREATE OR REPLACE TYPE SBREXT.MDSR_749_ALTERNATENAM_LIST_T    as table of MDSR_749_ALTERNATENAME_ITEM_T
/
CREATE OR REPLACE TYPE SBREXT.MDSR_749_REFERENCEDOCUMENT_T       AS OBJECT
(
  "Name"      varchar2(255),
  "OrganizationName" varchar2(200),
  "DocumentType"   varchar2(60),  
  "DocumentText"     VARCHAR2(4000),
  "URL"  varchar2(240),
  "Language" VARCHAR2(40),
  "DisplayOrder" VARCHAR2(4)
  
)
/
CREATE OR REPLACE TYPE SBREXT.MDSR_749_REFERENCEDOC_LIST_T    as table of MDSR_749_REFERENCEDOCUMENT_T
/
CREATE OR REPLACE TYPE SBREXT.MDSR_749_PV_ITEM_T          as object(
"VALIDVALUE"  VARCHAR2 (300) ,
"VALUEMEANING"        VARCHAR2 (300) ,
"MEANINGDESCRIPTION"  VARCHAR2 (4000) ,
"MEANINGCONCEPTS"  VARCHAR2 (400) ,
"VMPUBLICID"          number,
"VMVERSION"          VARCHAR2(7),
"ALTERNATENAMELIST"    MDSR_749_ALTERNATENAM_LIST_T);
/
CREATE OR REPLACE TYPE SBREXT.MDSR_749_PVs_LIST_T    as table of MDSR_749_PV_ITEM_T 
/
CREATE OR REPLACE TYPE SBREXT.MDSR_749_ValueDomain_T    AS OBJECT  
("VDPublicId"         number,
  "VDVersion"          VARCHAR2(7),
  "LongName"      varchar2(255),
  --"shortName"    varchar2(60),  
  "Datatype"               varchar2 (30), 
  "Type"               varchar2 (30),
  "PermissibleValues"    MDSR_749_PVs_LIST_T
 
)
/
CREATE OR REPLACE TYPE SBREXT.MDSR_749_ValueDomain_LIST_T    as table of MDSR_749_ValueDomain_T
/
CREATE OR REPLACE TYPE SBREXT."MDSR_CDE_749_T"                                          AS OBJECT
(
  --preferred-name
  "CDEPublicId"         number,
  "CDEversion"          VARCHAR2(7),  
  "DataElementShortName"   varchar2(60),
  "DataElementLongName"      varchar2(255),
  "CDEContext"    VARCHAR2(40),
  "WorkflowStatus"         varchar2 (20),   
  "ALTERNATENAMELIST"    MDSR_749_ALTERNATENAM_LIST_T,
  "REFERENCEDOCUMENTSLIST_ITEM"  MDSR_749_REFERENCEDOC_LIST_T,
  "DECPublicId"         number,
  "DECversion"          VARCHAR2(7),
 
  "ValueDomain"    MDSR_749_ValueDomain_LIST_T
 
)
/
CREATE OR REPLACE TYPE SBREXT.MDSR_CDE_749_LIST_T    as table of MDSR_CDE_749_T
/
DROP TYPE SBREXT.MDSR_CDE_749_LIST_T;
DROP TYPE SBREXT.MDSR_CDE_749_T;
DROP TYPE SBREXT.MDSR_749_VALUEDOMAIN_LIST_T;
DROP TYPE SBREXT.MDSR_749_VALUEDOMAIN_T;
DROP TYPE SBREXT.MDSR_749_ALTERNATENAM_LIST_T;
DROP TYPE SBREXT.MDSR_ALTERNATENAME_ITEM_749_T;
DROP TYPE SBREXT.MDSR_749_REFERENCEDOCUMENT_T;
DROP TYPE SBREXT.MDSR_749_REFERENCEDOC_LIST_T;
DROP TYPE SBREXT.MDSR_749_PVS_LIST_T;
DROP TYPE SBREXT.MDSR_749_PV_ITEM_T;


