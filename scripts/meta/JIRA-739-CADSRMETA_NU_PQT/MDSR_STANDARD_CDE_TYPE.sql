CREATE OR REPLACE FORCE VIEW MDSR_STANDARD_CDE_TYPE
(
   MODULE_TYPE,
   MODULE_ORDER,  
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
            END
               MODULE_TYPE,
            CASE
               WHEN MD.long_NAME LIKE 'Mandatory%' THEN '1'
               WHEN MD.long_NAME LIKE 'Optional%' THEN '2'
               WHEN MD.long_NAME LIKE 'Conditional%' THEN '3'
            END
               MODULE_ORDER,
               CDE_ID,
            DE.VERSION DE_VERSION,
            DE.LONG_NAME DE_NAME
       FROM SBREXT.QUEST_CONTENTS_EXT FR,
            SBREXT.QUEST_CONTENTS_EXT MD,
            SBREXT.QUEST_CONTENTS_EXT Q,
            SBR.DATA_ELEMENTS DE,
            SBREXT.PROTOCOL_QC_EXT PQ,
            SBREXT.PROTOCOLS_EXT p
      WHERE     MD.DN_CRF_IDSEQ = FR.QC_IDSEQ
            AND PQ.QC_IDSEQ = FR.QC_IDSEQ
            AND PQ.PROTO_IDSEQ = P.PROTO_IDSEQ
            AND TRIM (FR.QTL_NAME) = 'CRF'
            AND FR.ASL_NAME = 'RELEASED'
            AND FR.conte_idseq = '6BDC8E1A-E021-BC44-E040-BB89AD4365F6'
            AND Q.P_MOD_IDSEQ = MD.QC_IDSEQ
            AND TRIM (MD.QTL_NAME) = 'MODULE'
            AND TRIM (Q.QTL_NAME) = 'QUESTION'
            AND Q.DE_IDSEQ = DE.DE_IDSEQ
            AND P.LONG_NAME = 'NCI Standard Template Forms'
             AND (MD.long_NAME LIKE 'Mandatory%'or
                MD.long_NAME LIKE 'Optional%' or
                MD.long_NAME LIKE 'Conditional%')
   ORDER BY MODULE_ORDER, CDE_ID, DE.VERSION;
