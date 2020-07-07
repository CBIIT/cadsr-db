REATE TABLE SBREXT.TRRG_TRM_SPC_ERROR_LOG
(
  TR_NAME        CHAR(36 BYTE)                  NOT NULL,
  DATE_MODIFIED  DATE,
  ERROR_TEXT     VARCHAR2(500 BYTE)
);


CREATE OR REPLACE PUBLIC SYNONYM TRRG_TRM_SPC_ERROR_LOG FOR SBREXT.TRRG_TRM_SPC_ERROR_LOG;


GRANT SELECT ON SBREXT.TRRG_TRM_SPC_ERROR_LOG TO PUBLIC;

GRANT INSERT, SELECT, UPDATE ON SBREXT.TRRG_TRM_SPC_ERROR_LOG TO SBR;
