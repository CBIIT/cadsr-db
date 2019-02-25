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
  "DataElementConcepts" MDSR_DEC_XML_T,
 "designation_xx"    MDSR_CDE_DESIGN_XML_LIST_T,
"referenceDocument_xx"  MDSR_CDE_RD_XML_LIST_T,
 
  "valueDomain"    MDSR_CDE_VD_XML_T
 
);
create or replace TYPE          MDSR_CDE_XML_LIST_T    as table of MDSR_CDE_XML_T;



drop  type MDSR_CDE_XML_LIST_T ;
   drop  type MDSR_CDE_XML_T;