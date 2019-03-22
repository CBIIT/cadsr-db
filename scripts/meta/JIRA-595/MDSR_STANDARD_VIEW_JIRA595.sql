set serveroutput on size 1000000
SPOOL CC-FORMBUILD-595-view
DROP VIEW SBREXT.MDSR_STANDARD_FORM_CDE_TYPE;

CREATE OR REPLACE FORCE VIEW SBREXT.MDSR_STANDARD_FORM_CDE_TYPE
(
    MODULE_TYPE,
    MODULE_ORDER,
    FORM_ID_VERSION,
    FORM_NAME,
    CDE_ID,
    DE_VERSION,
    DE_NAME
)
AS
      SELECT DISTINCT
             CASE
                 WHEN MD.long_NAME LIKE 'Mandatory%' THEN 'Mandatory'
                 WHEN MD.long_NAME LIKE 'Optional%' THEN 'Optional'
                 WHEN MD.long_NAME LIKE 'Conditional%' THEN 'Conditional'
             END                              MODULE_TYPE,
             CASE
                 WHEN MD.long_NAME LIKE 'Mandatory%' THEN '1'
                 WHEN MD.long_NAME LIKE 'Optional%' THEN '2'
                 WHEN MD.long_NAME LIKE 'Conditional%' THEN '3'
             END                              MODULE_ORDER,
             FR.QC_ID || 'v' || FR.VERSION    FORM_ID_VERSION,
             FR.LONG_NAME,
             CDE_ID,
             DE.VERSION                       DE_VERSION,
             DE.LONG_NAME                     DE_NAME
        FROM SBREXT.QUEST_CONTENTS_EXT FR,
             SBREXT.QUEST_CONTENTS_EXT MD,
             SBREXT.QUEST_CONTENTS_EXT Q,
             SBR.DATA_ELEMENTS        DE,
             SBREXT.PROTOCOL_QC_EXT   PQ,
             SBREXT.PROTOCOLS_EXT     p
       WHERE     MD.DN_CRF_IDSEQ = FR.QC_IDSEQ
             AND PQ.QC_IDSEQ = FR.QC_IDSEQ
             AND PQ.PROTO_IDSEQ = P.PROTO_IDSEQ
             AND TRIM (FR.QTL_NAME) = 'CRF'
             AND FR.ASL_NAME = 'RELEASED'
             AND FR.conte_idseq = '6BDC8E1A-E021-BC44-E040-BB89AD4365F6'
             AND Q.P_MOD_IDSEQ = MD.QC_IDSEQ
             AND TRIM (MD.QTL_NAME) = 'MODULE'
             AND TRIM (Q.QTL_NAME) = 'QUESTION'
             AND (   MD.long_NAME LIKE 'Mandatory%'
                  OR MD.long_NAME LIKE 'Optional%'
                  OR MD.long_NAME LIKE 'Conditional%')
             AND Q.DE_IDSEQ = DE.DE_IDSEQ
             AND P.LONG_NAME = 'NCI Standard Template Forms'
    ORDER BY MODULE_ORDER, CDE_ID, DE.VERSION;
/
CREATE OR REPLACE PUBLIC SYNONYM MDSR_STANDARD_FORM_CDE_TYPE FOR SBREXT.MDSR_STANDARD_FORM_CDE_TYPE;
GRANT SELECT ON SBREXT.MDSR_STANDARD_FORM_CDE_TYPE TO DER_USER;
GRANT SELECT ON SBREXT.MDSR_STANDARD_FORM_CDE_TYPE TO PUBLIC;
GRANT SELECT ON SBREXT.MDSR_STANDARD_FORM_CDE_TYPE TO READONLY;
GRANT SELECT ON SBREXT.MDSR_STANDARD_FORM_CDE_TYPE TO SBR;
GRANT SELECT ON SBREXT.MDSR_STANDARD_FORM_CDE_TYPE TO CDEVALIDATE;
CREATE OR REPLACE FORCE VIEW SBREXT.MDSR_STANDARD_FORM_CDE_AGR
(
    MODULE_TYPE,
    MODULE_ORDER,
    CDE_ID,
    DE_VERSION,
    DE_NAME,
    FORM_ID,
    FORM_NAME
)
AS
      SELECT MODULE_TYPE,
             MODULE_ORDER,
             CDE_ID,
             DE_VERSION,
             DE_NAME,
             LISTAGG (FORM_ID_VERSION, '::')
                 WITHIN GROUP (ORDER BY FORM_ID_VERSION)                          AS FORM_ID,
             LISTAGG (FORM_NAME, '::') WITHIN GROUP (ORDER BY FORM_ID_VERSION)    AS FORM_NAME
        FROM SBREXT.MDSR_STANDARD_FORM_CDE_TYPE
    GROUP BY MODULE_TYPE,
             MODULE_ORDER,
             CDE_ID,
             DE_VERSION,
             DE_NAME
    ORDER BY MODULE_ORDER, CDE_ID;


CREATE OR REPLACE PUBLIC SYNONYM MDSR_STANDARD_FORM_CDE_AGR FOR SBREXT.MDSR_STANDARD_FORM_CDE_AGR;
/
GRANT SELECT ON SBREXT.MDSR_STANDARD_FORM_CDE_AGR TO DER_USER;
GRANT SELECT ON SBREXT.MDSR_STANDARD_FORM_CDE_AGR TO PUBLIC;
GRANT SELECT ON SBREXT.MDSR_STANDARD_FORM_CDE_AGR TO READONLY;
GRANT SELECT ON SBREXT.MDSR_STANDARD_FORM_CDE_AGR TO SBR;
GRANT SELECT ON SBREXT.MDSR_STANDARD_FORM_CDE_AGR TO CDEVALIDATE;
SPOOL OFF
