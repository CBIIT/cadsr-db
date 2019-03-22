set serveroutput on size 1000000
SPOOL CC-FORMBUILD-595-Tables.log
create table SBREXT.CC_PARSER_DATA (
CCHECKER_IDSEQ CHAR(36 BYTE) NOT NULL ENABLE CONSTRAINT CC_PARSER_DATA_PK PRIMARY KEY,
FILE_NAME VARCHAR2(350 BYTE) NOT NULL ENABLE,
REPORT_OWNER VARCHAR2(350 BYTE) NOT NULL ENABLE,
DATE_CREATED DATE DEFAULT sysdate, 
CREATED_BY VARCHAR2(30 BYTE) DEFAULT user, 
DATE_MODIFIED DATE, 
MODIFIED_BY VARCHAR2(30 BYTE), 
PARSER_BLOB BLOB)
/
GRANT DELETE, INSERT, SELECT, UPDATE ON SBREXT.CC_PARSER_DATA TO DER_USER;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON SBREXT.CC_PARSER_DATA TO SBR WITH GRANT OPTION;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON SBREXT.CC_PARSER_DATA TO CDEVALIDATE;
GRANT SELECT ON SBREXT.CC_PARSER_DATA TO READONLY;
CREATE OR REPLACE PUBLIC SYNONYM CC_PARSER_DATA FOR SBREXT.CC_PARSER_DATA
/
create table SBREXT.CC_REPORT_ERROR (
CCHECKER_IDSEQ CHAR(36 BYTE) NOT NULL,
FILE_NAME VARCHAR2(350 BYTE) NOT NULL ENABLE,
REPORT_OWNER VARCHAR2(350 BYTE),
DATE_CREATED DATE DEFAULT sysdate, 
CREATED_BY VARCHAR2(30 BYTE) DEFAULT user, 
DATE_MODIFIED DATE, 
MODIFIED_BY VARCHAR2(30 BYTE), 
ERROR_REPORT_BLOB BLOB,
CONSTRAINT CCHECKER_IDSEQ_ERROR_FK
	FOREIGN KEY (CCHECKER_IDSEQ)
	REFERENCES CC_PARSER_DATA (CCHECKER_IDSEQ) ON DELETE CASCADE
)
/
GRANT DELETE, INSERT, SELECT, UPDATE ON SBREXT.CC_REPORT_ERROR TO DER_USER;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON SBREXT.CC_REPORT_ERROR TO SBR WITH GRANT OPTION;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON SBREXT.CC_REPORT_ERROR TO CDEVALIDATE;
GRANT SELECT ON SBREXT.CC_REPORT_ERROR TO READONLY;
CREATE OR REPLACE PUBLIC SYNONYM CC_REPORT_ERROR FOR SBREXT.CC_REPORT_ERROR
/
create table SBREXT.CC_REPORT_FULL (
CCHECKER_IDSEQ CHAR(36 BYTE) NOT NULL,
FILE_NAME VARCHAR2(350 BYTE) NOT NULL ENABLE,
REPORT_OWNER VARCHAR2(350 BYTE),
DATE_CREATED DATE DEFAULT sysdate, 
CREATED_BY VARCHAR2(30 BYTE) DEFAULT user, 
DATE_MODIFIED DATE, 
MODIFIED_BY VARCHAR2(30 BYTE), 
FULL_REPORT_BLOB BLOB,
CONSTRAINT CCHECKER_IDSEQ_FULL_FK
	FOREIGN KEY (CCHECKER_IDSEQ)
	REFERENCES CC_PARSER_DATA (CCHECKER_IDSEQ) ON DELETE CASCADE
)
/
GRANT DELETE, INSERT, SELECT, UPDATE ON SBREXT.CC_REPORT_FULL TO DER_USER;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON SBREXT.CC_REPORT_FULL TO SBR WITH GRANT OPTION;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON SBREXT.CC_REPORT_FULL TO CDEVALIDATE;
GRANT SELECT ON SBREXT.CC_REPORT_FULL TO READONLY;
CREATE OR REPLACE PUBLIC SYNONYM CC_REPORT_FULL FOR SBREXT.CC_REPORT_FULL
/
SPOOL OFF
