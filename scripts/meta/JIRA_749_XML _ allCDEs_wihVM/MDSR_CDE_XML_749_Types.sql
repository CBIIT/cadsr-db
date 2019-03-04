create or replace TYPE          "MDSR_CDE_DESIGN_XML_T"          as object(
"context"                             VARCHAR2(30),
"name"                                VARCHAR2(2000)
,"type"                                VARCHAR2(20)--"DETL_NAME"
,"languageName"                        VARCHAR2(30)

);

create or replace TYPE          MDSR_CDE_DESIGN_XML_LIST_T    as table of MDSR_CDE_DESIGN_XML_T;


create or replace TYPE          "MDSR_CDE_VM_XML_T"          as object(
"publicID"          number,
"version"          VARCHAR2(7),
"longname"        varchar2 (300) ,
"designation_xx"    MDSR_CDE_DESIGN_XML_LIST_T);

create or replace TYPE          "MDSR_CDE_PV_XML_T"          as object(

"value"       varchar2 (300) ,
"valueMeaning"    MDSR_CDE_VM_XML_T
);

create or replace TYPE         MDSR_CDE_PV_XML_LIST_T    as table of MDSR_CDE_PV_XML_T;

create or replace TYPE          MDSR_CDE_VD_XML_T    AS OBJECT  --8
("publicId"         number,
  "version"          VARCHAR2(7),
  "longName"      varchar2(255),
  --"shortName"    varchar2(60),  
  
  "Datatype"               varchar2 (30), 
  "PermissibleValue_xx"    MDSR_CDE_PV_XML_LIST_T
 
);

create or replace TYPE         MDSR_CDE_VD_XML_LIST_T    as table of MDSR_CDE_VD_XML_T;
-- drop type MDSR_CDE_VD_XML_LIST_T;
create or replace TYPE          "MDSR_DEC_XML_T"          as object(
"publicId"         number,
  "version"          VARCHAR2(7)
);
create or replace TYPE         MDSR_DEC_XML_LIST_T    as table of MDSR_DEC_XML_T;
create or replace TYPE          MDSR_CDE_RD_XML_T       AS OBJECT
(
  "name"      varchar2(255),
  "type"   varchar2(60),  
  "doctext"     VARCHAR2(4000),
  "languageName" VARCHAR2(40),
  "URL"  varchar2(240)
);

create or replace TYPE          MDSR_CDE_RD_XML_LIST_T    as table of MDSR_CDE_RD_XML_T;

CREATE OR REPLACE TYPE "MDSR_CDE_XML_T"                                          AS OBJECT
(
  --preferred-name
  "publicId"         number,
  "version"          VARCHAR2(7),
  "longName"      varchar2(255),
  "shortName"   varchar2(60),
  "context"    VARCHAR2(40),
  "workflowStatus"         varchar2 (20),  
  "DataElementConcepts" MDSR_DEC_XML_LIST_T,
 "designation_xx"    MDSR_CDE_DESIGN_XML_LIST_T,
"referenceDocument_xx"  MDSR_CDE_RD_XML_LIST_T,
 
  "valueDomain"    MDSR_CDE_VD_XML_LIST_T
 
);


create or replace TYPE          MDSR_CDE_XML_LIST_T    as table of MDSR_CDE_XML_T;



drop  type MDSR_CDE_XML_LIST_T ;
   drop  type MDSR_CDE_XML_T;
   
   
   
   create or replace TYPE          MDSR_749_VD_XML_T    AS OBJECT  --8
("VDPublicId"         number,
  "VDVersion"          VARCHAR2(7),
  "longName"      varchar2(255),
  --"shortName"    varchar2(60),  
  
  "Datatype"               varchar2 (30), 
  "PermissibleValue_xx"    DE_VALID_VALUE_LIST_T
 
);

create or replace TYPE          MDSR_749_VD_XML_LIST_T    as table of MDSR_749_VD_XML_T;


drop  type MDSR_749_VD_XML_LIST_T ;
   drop  type MDSR_749_VD_XML_T;
   
 create or replace TYPE          "MDSR_749_DESIGN_T"          as object(
"ContextName"                             VARCHAR2(30),
"ContextVersion"                        VARCHAR2(10),
"AlternateName"                                VARCHAR2(2000)
,"AlternateNameType"                                VARCHAR2(20)--"DETL_NAME"
,"Language"                        VARCHAR2(30)

);

create or replace TYPE          MDSR_749_RD_T       AS OBJECT
(
  "Name"      varchar2(255),
  "OrganizationName" varchar2(200),
  "DocumentType"   varchar2(60),  
  "DocumentText"     VARCHAR2(4000),
  "URL"  varchar2(240),
  "Language" VARCHAR2(40),
  "DisplayOrder" VARCHAR2(4)
  
);

create or replace TYPE          MDSR_749_RD_LIST_T    as table of MDSR_749_RD_T;

create or replace TYPE          MDSR_749_DESIGN_LIST_T    as table of MDSR_749_DESIGN_T;


create or replace TYPE          "MDSR_749_PV_T"          as object(
"VALIDVALUE"  VARCHAR2 (300) ,
"VALUEMEANING"        VARCHAR2 (300) ,
"MEANINGDESCRIPTION"  VARCHAR2 (4000) ,
"MEANINGCONCEPTS"  VARCHAR2 (400) ,
"VMPUBLICID"          number,
"VMVERSION"          VARCHAR2(7),
"designation_xx"    MDSR_749_DESIGN_LIST_T);

create or replace TYPE         MDSR_749_PV_LIST_T    as table of MDSR_749_PV_T;

drop type MDSR_749_PV_LIST_T ;


   create or replace TYPE          MDSR_749_VD_T    AS OBJECT  --8
("VDPublicId"         number,
  "VDVersion"          VARCHAR2(7),
  "longName"      varchar2(255),
  --"shortName"    varchar2(60),  
  "Datatype"               varchar2 (30), 
  "Type"               varchar2 (30),
  
  "PermissibleValue_xx"    MDSR_749_PV_LIST_T
 
);

create or replace TYPE          MDSR_749_VD_LIST_T    as table of MDSR_749_VD_T;


CREATE OR REPLACE TYPE "MDSR_CDE_749_T"                                          AS OBJECT
(
  --preferred-name
  "CDEPublicId"         number,
  "CDEversion"          VARCHAR2(7),  
  "DataElementShortName"   varchar2(60),
  "DataElementLongName"      varchar2(255),
  "CDEContext"    VARCHAR2(40),
  "WorkflowStatus"         varchar2 (20),   
  "designation_xx"    MDSR_749_DESIGN_LIST_T,
  "referenceDocument_xx"  MDSR_749_RD_LIST_T,
  "DECPublicId"         number,
  "DECversion"          VARCHAR2(7),
 
  "ValueDomain"    MDSR_749_VD_LIST_T
 
);




create or replace TYPE          MDSR_CDE_749_LIST_T    as table of MDSR_CDE_749_T;


drop type MDSR_CDE_749_LIST_T;
drop type MDSR_CDE_749_T;