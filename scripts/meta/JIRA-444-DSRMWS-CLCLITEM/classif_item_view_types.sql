DROP TYPE SBREXT.MDSR759_XML_CONTEXT_T1;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CONTEXT_T1"                                          as object(
"PreferredName" VARCHAR(60),
"Version"          VARCHAR2(7),
--"ContextID" VARCHAR(60),
"ClassificationScheme" MDSR759_XML_CS_L5_LIST_T)
/


DROP TYPE SBREXT.MDSR759_XML_CSI_L1_T;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CSI_L1_T"                                          as object(
"CSILevel" number,
 "ClassificationSchemeItemName" VARCHAR2(255),
 "ClassificationSchemeItemType"   VARCHAR2(20),
 "PublicId"        NUMBER,
 "Version"          VARCHAR2(7),
"DateCreated"  VARCHAR2(40),
 "CSI_IDSEQ" VARCHAR2(60),
 "ParentIdseq" VARCHAR2(60),
--  sc_csi_id VARCHAR2(60),
 "ParentPublicID"        NUMBER,
 "ParentVersion"          VARCHAR2(7),
 "AnyChildCSI" VARCHAR2(10),
 "ChildCSIList" MDSR759_XML_CSI_LIST2_T)
/


DROP TYPE SBREXT.MDSR759_XML_CSI_L2_T;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CSI_L2_T"                                          as object(
"CSILevel" number,
 "ClassificationSchemeItemName" VARCHAR2(255),
 "ClassificationSchemeItemType"   VARCHAR2(20),
 "PublicId"        NUMBER,
 "Version"          VARCHAR2(7),
"DateCreated"  VARCHAR2(40),
 "CSI_IDSEQ" VARCHAR2(60),
 "ParentIdseq" VARCHAR2(60),
--sc_csi_id VARCHAR2(60),
 "ParentPublicID"        NUMBER,
 "ParentVersion"          VARCHAR2(7),
 "AnyChildCSI" VARCHAR2(10),
 "ChildCSIList" MDSR759_XML_CSI_LIST3_T)
/


DROP TYPE SBREXT.MDSR759_XML_CSI_L3_T;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CSI_L3_T"                                          as object(
"CSILevel" number,
 "ClassificationSchemeItemName" VARCHAR2(255),
 "ClassificationSchemeItemType"   VARCHAR2(20),
 "PublicId"        NUMBER,
 "Version"          VARCHAR2(7),
"DateCreated"  VARCHAR2(40),
 "CSI_IDSEQ" VARCHAR2(60),
 "ParentIdseq" VARCHAR2(60),
 -- sc_csi_id VARCHAR2(60),
 "ParentPublicID"        NUMBER,
 "ParentVersion"          VARCHAR2(7),
 "AnyChildCSI" VARCHAR2(10),
 "ChildCSIList" MDSR759_XML_CSI_LIST4_T)
/


DROP TYPE SBREXT.MDSR759_XML_CSI_L4_T;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CSI_L4_T"                                          as object(
"CSILevel" number,
 "ClassificationSchemeItemName" VARCHAR2(255),
 "ClassificationSchemeItemType"   VARCHAR2(20),
 "PublicId"        NUMBER,
 "Version"          VARCHAR2(7),
"DateCreated"  VARCHAR2(40),
 "CSI_IDSEQ" VARCHAR2(60),
 "ParentIdseq" VARCHAR2(60),
--  sc_csi_id VARCHAR2(60),
 "ParentPublicID"        NUMBER,
 "ParentVersion"          VARCHAR2(7),
 "AnyChildCSI" VARCHAR2(10),
 "ChildCSIList" MDSR759_XML_CSI_LIST5_T)
/


DROP TYPE SBREXT.MDSR759_XML_CSI_L5_T;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CSI_L5_T"                                          as object(
"CSILevel" number,
 "ClassificationSchemeItemName" VARCHAR2(255),
 "ClassificationSchemeItemType"   VARCHAR2(20),
 "PublicId"        NUMBER,
 "Version"          VARCHAR2(7),
 "DateCreated"  VARCHAR2(40),
 "CSI_IDSEQ" VARCHAR2(60),
 "ParentIdseq" VARCHAR2(60),
  --sc_csi_id VARCHAR2(60),
 "ParentPublicID"        NUMBER,
 "ParentVersion"          VARCHAR2(7),
 "AnyChildCSI" VARCHAR2(10))
/


DROP TYPE SBREXT.MDSR759_XML_CSI_T1;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CSI_T1"                                          as object(
"item Level" number,
 "name" VARCHAR2(255),
 "publicID"        NUMBER,
 "version"          VARCHAR2(7),
 "type"   VARCHAR2(20),
"preferredDefinition"  VARCHAR2(2000),
 "Item id" VARCHAR2(60),
  "Parent id" VARCHAR2(60), 
  sc_csi_id VARCHAR2(60),
 "Parent publicID"        NUMBER,
 "Parent version"          VARCHAR2(7),
 "Children" VARCHAR2(10))
/


DROP TYPE SBREXT.MDSR759_XML_CS_L5_T;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CS_L5_T"                                          as object(
"PublicId"        NUMBER,
"PreferredName" VARCHAR2(60),
"LongName" VARCHAR2(255),
"Version"          VARCHAR2(7),
"DateCreated"  VARCHAR2(40),
"ClassificationItem_LIST"  MDSR759_XML_CSI_LIST1_T)
/


DROP TYPE SBREXT.MDSR759_XML_CS_LIST1_T;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CS_LIST1_T"                                          as table of MDSR759_XML_CS_L1_T  "Classif";
/


DROP TYPE SBREXT.MDSR759_XML_CS_T1;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CS_T1"                                          as object(
"name" VARCHAR2(255),
"publicID"        NUMBER,
"version"          VARCHAR2(7),
"preferredDefinition"  VARCHAR2(2000),
"ClassificationItem_LIST"  MDSR759_XML_CSI_LIST_T1)
/


GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CONTEXT_T1 TO GUEST;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L1_T TO GUEST;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L2_T TO GUEST;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L3_T TO GUEST;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L4_T TO GUEST;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L5_T TO GUEST;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CS_L5_T TO GUEST;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CONTEXT_T1 TO READONLY;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L1_T TO READONLY;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L2_T TO READONLY;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L3_T TO READONLY;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L4_T TO READONLY;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L5_T TO READONLY;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CS_L5_T TO READONLY;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CONTEXT_T1 TO SBR WITH GRANT OPTION;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L1_T TO SBR WITH GRANT OPTION;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L2_T TO SBR WITH GRANT OPTION;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L3_T TO SBR WITH GRANT OPTION;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L4_T TO SBR WITH GRANT OPTION;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_L5_T TO SBR WITH GRANT OPTION;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CS_L5_T TO SBR WITH GRANT OPTION;
