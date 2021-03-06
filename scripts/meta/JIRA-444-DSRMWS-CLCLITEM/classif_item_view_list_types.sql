DROP TYPE SBREXT.MDSR759_XML_CSI_LIST1_T;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CSI_LIST1_T"                                          as table of MDSR759_XML_CSI_L1_T
/


DROP TYPE SBREXT.MDSR759_XML_CSI_LIST2_T;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CSI_LIST2_T"                                          as table of MDSR759_XML_CSI_L2_T
/


DROP TYPE SBREXT.MDSR759_XML_CSI_LIST3_T;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CSI_LIST3_T"                                          as table of MDSR759_XML_CSI_L3_T
/


DROP TYPE SBREXT.MDSR759_XML_CSI_LIST4_T;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CSI_LIST4_T"                                          as table of MDSR759_XML_CSI_L4_T
/


DROP TYPE SBREXT.MDSR759_XML_CSI_LIST5_T;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CSI_LIST5_T"                                          as table of MDSR759_XML_CSI_L5_T
/


DROP TYPE SBREXT.MDSR759_XML_CSI_LIST_T1;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CSI_LIST_T1"                                          as table of MDSR759_XML_CSI_T1
/


DROP TYPE SBREXT.MDSR759_XML_CS_L5_LIST_T;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CS_L5_LIST_T"                                          as table of MDSR759_XML_CS_L5_T
/


DROP TYPE SBREXT.MDSR759_XML_CS_LIST_T1;

CREATE OR REPLACE TYPE SBREXT."MDSR759_XML_CS_LIST_T1"                                          as table of MDSR759_XML_CS_T1
/


GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST1_T TO GUEST;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST2_T TO GUEST;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST3_T TO GUEST;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST4_T TO GUEST;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST5_T TO GUEST;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CS_L5_LIST_T TO GUEST;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST1_T TO READONLY;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST2_T TO READONLY;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST3_T TO READONLY;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST4_T TO READONLY;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST5_T TO READONLY;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CS_L5_LIST_T TO READONLY;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST1_T TO SBR WITH GRANT OPTION;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST2_T TO SBR WITH GRANT OPTION;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST3_T TO SBR WITH GRANT OPTION;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST4_T TO SBR WITH GRANT OPTION;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CSI_LIST5_T TO SBR WITH GRANT OPTION;

GRANT EXECUTE, DEBUG ON SBREXT.MDSR759_XML_CS_L5_LIST_T TO SBR WITH GRANT OPTION;
