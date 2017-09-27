set serveroutput on size 1000000
SPOOL cadsrmeta-581a.log

CREATE TABLE SBREXT.MDSR_DESIGNATIONS_LOAD_ERR
(
  PUBLICID                       VARCHAR2(15 BYTE),
  VERSION                        VARCHAR2(5 BYTE),
  LONGNAME                       VARCHAR2(500 BYTE),
  TYPE                           VARCHAR2(10 BYTE),
  CREATEDBY                      VARCHAR2(30 BYTE),
  DATECREATED                    VARCHAR2(20 BYTE),
  DATEMODIFIED                   VARCHAR2(20 BYTE),
  ID                             VARCHAR2(50 BYTE),
  LANGUAGENAME                   VARCHAR2(100 BYTE),
  MODIFIEDBY                     VARCHAR2(30 BYTE),
  NAME                           VARCHAR2(2000 BYTE),
  TYPE2                          VARCHAR2(20 BYTE),
  DESIGNATIONCLASSSCHEMEITEMCOL  VARCHAR2(100 BYTE),
  CONTEXT                        VARCHAR2(30 BYTE),
  AC_IDSEQ                       CHAR(36 BYTE),
  CONTE_IDSEQ                    CHAR(36 BYTE),
  COMMENTS                       VARCHAR2(200 BYTE),
  LOADDATE                       DATE
)
/
CREATE TABLE SBREXT.MDSR_DESIGNATIONS_UPLOAD
(
  PUBLICID                       VARCHAR2(15 BYTE),
  VERSION                        VARCHAR2(5 BYTE),
  LONGNAME                       VARCHAR2(500 BYTE),
  TYPE                           VARCHAR2(10 BYTE),
  CREATEDBY                      VARCHAR2(30 BYTE),
  DATECREATED                    VARCHAR2(20 BYTE),
  DATEMODIFIED                   VARCHAR2(20 BYTE),
  ID                             VARCHAR2(50 BYTE),
  LANGUAGENAME                   VARCHAR2(100 BYTE),
  MODIFIEDBY                     VARCHAR2(30 BYTE),
  NAME                           VARCHAR2(2000 BYTE),
  TYPE2                          VARCHAR2(20 BYTE),
  DESIGNATIONCLASSSCHEMEITEMCOL  VARCHAR2(100 BYTE),
  CONTEXT                        VARCHAR2(30 BYTE),
  AC_IDSEQ                       CHAR(36 BYTE),
  CONTE_IDSEQ                    CHAR(36 BYTE)
)
/
CREATE OR REPLACE FORCE VIEW SBREXT.MDSR_DES_UPLOAD_VW
(
   PUBLICID,
   VERSION,
   LONGNAME,
   TYPE,
   CREATEDBY,
   DATECREATED,
   DATEMODIFIED,
   ID,
   LANGUAGENAME,
   MODIFIEDBY,
   NAME,
   TYPE2,
   DESIGNATIONCLASSSCHEMEITEMCOL,
   CONTEXT,
   AC_IDSEQ,
   CONTE_IDSEQ
)
AS
   SELECT DISTINCT "PUBLICID",
                   "VERSION",
                   "LONGNAME",
                   "TYPE",
                   "CREATEDBY",
                   "DATECREATED",
                   "DATEMODIFIED",
                   "ID",
                   "LANGUAGENAME",
                   "MODIFIEDBY",
                   "NAME",
                   "TYPE2",
                   "DESIGNATIONCLASSSCHEMEITEMCOL",
                   "CONTEXT",
                   "AC_IDSEQ",
                   "CONTE_IDSEQ"
     FROM SBREXT.MDSR_designations_upload
/
SPOOL OFF