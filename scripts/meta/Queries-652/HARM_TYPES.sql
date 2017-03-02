
CREATE OR REPLACE TYPE SBREXT."HARMONY_FORM_CDE_T"    AS OBJECT
("FormID"          number, 
"Version"             number (4,2),
 "FormName"        varchar2 (300) ,
 "FORM_CONTEXT"  varchar2 (1000) 

)
/
CREATE OR REPLACE TYPE SBREXT.HARMONY_FORM_CDE_LIST_T AS TABLE OF SBREXT.HARMONY_FORM_CDE_T;
/
CREATE OR REPLACE TYPE SBREXT."HARMONY_DESIGN_T"                                          as object(
   "DES_CONTEXT_NAME"                                     VARCHAR2(30)
   ,"DES_CONTEXT_VERSION"                                  NUMBER(4,2)
   ,"Alternate Name"                                               VARCHAR2(2000)
   ,"DES_DETL_NAME"                                          VARCHAR2(20))
   ;
   CREATE OR REPLACE TYPE SBREXT."HARMONY_DESIGN_LIST_T"                                          AS TABLE OF SBREXT.HARMONY_DESIGN_T;
/

CREATE OR REPLACE TYPE SBREXT."HARMONY_DEFINITION_T"                                          as object(
   "DEF_CONTEXT_NAME"                                     VARCHAR2(30)
   ,"DEF_CONTEXT_VERSION"                                  NUMBER(4,2)
   ,"Alternate DEFINITION"                                               VARCHAR2(2000)
   ,"DEFL_NAME"                                          VARCHAR2(20))
   ;
   CREATE OR REPLACE TYPE SBREXT."HARMONY_DEF_LIST_T"                                          AS TABLE OF SBREXT.HARMONY_DEFINITION_T;
/

CREATE OR REPLACE TYPE SBREXT."HARMONY_DOC_REF_T"                                          as object(
   "DEF_CONTEXT_NAME"                                     VARCHAR2(30)
   ,"DEF_CONTEXT_VERSION"                                  NUMBER(4,2)
   ,"Alternate Q TEXT"                                               VARCHAR2(2000)
   ,"RDTL_NAME"                                          VARCHAR2(20))
/
   CREATE OR REPLACE TYPE SBREXT."HARMONY_DOC_REF_LIST_T"            AS TABLE OF SBREXT.HARMONY_DOC_REF_T;
/

CREATE OR REPLACE TYPE SBREXT."HARMONY_VD_TYPE_T"      as object
( 
  "VD_PREFERRED_NAME"      VARCHAR2(70)
   ,"VD_TYPE"                VARCHAR2(40))
/
   CREATE OR REPLACE TYPE SBREXT."HARMONY_VD_TYPE_LIST_T"         AS TABLE OF SBREXT.HARMONY_VD_TYPE_T;
/
CREATE OR REPLACE TYPE SBREXT.HARMONY_FORM_PROTO_T    AS OBJECT
("FormID"          number, 
"Version"             number (4,2),
 "FormName"        varchar2 (300) ,
 "FORM_CONTEXT"  varchar2 (1000) ,
 "ModuleName"        varchar2 (300) ,
 "FormType"  varchar2 (100) ,
 "ProtocolName"       varchar2 (300) ,
 "FormWorkflowStatus"  varchar2 (100))
/
CREATE OR REPLACE TYPE SBREXT.HARMONY_FORM_PROTO_LIST_T AS TABLE OF SBREXT.HARMONY_FORM_PROTO_T
/

CREATE OR REPLACE TYPE SBREXT.HARMONY_VM_T    AS OBJECT
("Vm_PublicID"          number, 
"VM_Version"             number (4,2),
 "VM_LongName"        varchar2 (300) ,
 "VM_PreferredName"  varchar2 (300) ,
 "VM_ALT_Name"        varchar2 (2000) ,
 "VM_Context"        varchar2 (50) ,
 "VM_Comcepts"        varchar2 (3000) ,
 "Source"  varchar2 (2000) ,
 "vm_ChangeNote"       varchar2 (2000) ,
 "Create by" varchar2 (60) ,
 "create date" date, 
 "modified by" varchar2 (60) , 
 "modified date" date )
/
CREATE OR REPLACE TYPE SBREXT.HARMONY_VM_LIST_T AS TABLE OF SBREXT.HARMONY_VM_T
/
    
         