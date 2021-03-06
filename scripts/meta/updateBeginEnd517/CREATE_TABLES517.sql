set serveroutput on size 1000000
SPOOL cadsrmeta-517a.log
CREATE TABLE SBR.MDSR_PV_UP_ENDDATE_TEMP
(
  PV_VALUE     VARCHAR2(270 BYTE),
  VD_ID        VARCHAR2(50 BYTE),
  VD_VER       VARCHAR2(7 BYTE),
  BEGIN_DATE   DATE,
  END_DATE     DATE,
  MODIFIED_BY  VARCHAR2(50 BYTE)
)
/
CREATE TABLE SBR.MDSR_PV_UPDATE_ERR
(
  VALUE_DOMAIN_ID   VARCHAR2(50 BYTE),
  VALUE_DOMAIN_VER  VARCHAR2(5 BYTE),
  EXISTING_PV       VARCHAR2(1100 BYTE),
  COMMENTS          VARCHAR2(2000 BYTE),
  DATE_PROCESSED    DATE
)
/
CREATE OR REPLACE PUBLIC SYNONYM MDSR_PV_UP_ENDDATE_TEMP FOR SBR.MDSR_PV_UP_ENDDATE_TEMP;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_PV_UPDATE_ERR FOR SBR.MDSR_PV_UPDATE_ERR;
GRANT SELECT ON MDSR_PV_UP_ENDDATE_TEMP TO PUBLIC;
GRANT SELECT ON MDSR_PV_UPDATE_ERR TO PUBLIC;

SPOOL OFF