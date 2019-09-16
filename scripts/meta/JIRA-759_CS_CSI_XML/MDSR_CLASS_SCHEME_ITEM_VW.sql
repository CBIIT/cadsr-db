DROP VIEW SBREXT.MDSR_CLASS_SCHEME_ITEM_VW;

/* Formatted on 9/16/2019 9:45:17 AM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
(
    CS_IDSEQ,
    PREFERRED_NAME,
    LONG_NAME,
    PREFERRED_DEFINITION,
    VERSION,
    ASL_NAME,
    CS_CONTEXT_NAME,
    CS_CONTEXT_VERSION,
    CONTE_IDSEQ,
    CSI_NAME,
    CSITL_NAME,
    DESCRIPTION,
    CSI_ID,
    CSI_VERSION,
    CSI_IDSEQ,
    CSI_CONTEXT_NAME,
    CS_ID,
    CS_CSI_IDSEQ,
    CSI_LEVEL,
    LEAF,
    PARENT_CSI_IDSEQ
)
AS
    (    SELECT cs.cs_idseq,
                cs.preferred_name,
                cs.long_name,
                cs.preferred_definition,
                cs.version,
                cs.asl_name,
                cs_conte.name                                           cs_context_name,
                cs_conte.version                                        cs_context_version,
                cs.conte_idseq                                          conte_idseq,
                csi.long_name                                           csi_name,
                csi.csitl_name,
                csi.preferred_definition                                description,
                csi.csi_id,
                csi.version                                             csi_version,
                csi.CSI_IDSEQ,
                csi_conte.name                                          csi_context_name,
                cs.cs_id,
                CS_CSI_IDSEQ,
                LEVEL,
                DECODE (CONNECT_BY_ISLEAF,  '1', 'FALSE',  '0', 'TRUE')    "IsLeaf",
                p_cs_csi_idseq
           FROM sbr.classification_schemes cs,
                sbr.cs_items            csi,
                sbr.cs_csi              csc,
                sbr.contexts            cs_conte,
                sbr.contexts            csi_conte
          WHERE     csc.cs_idseq = cs.cs_idseq
                AND csc.csi_idseq = csi.csi_idseq
                AND cs.conte_idseq = cs_conte.conte_idseq
                AND csi.conte_idseq = csi_conte.conte_idseq
                AND INSTR (csi.CSITL_NAME, 'testCaseMix') = 0
                AND csi_conte.name NOT IN ('TEST', 'Training')
                AND cs_conte.name NOT IN ('TEST', 'Training')
                AND cs.ASL_NAME = 'RELEASED'
     CONNECT BY PRIOR CS_CSI_IDSEQ = P_CS_CSI_IDSEQ
     START WITH P_CS_CSI_IDSEQ IS NULL);


GRANT SELECT ON SBREXT.MDSR_CLASS_SCHEME_ITEM_VW TO CDEBROWSER;

GRANT SELECT ON SBREXT.MDSR_CLASS_SCHEME_ITEM_VW TO DER_USER;

GRANT SELECT ON SBREXT.MDSR_CLASS_SCHEME_ITEM_VW TO DEV_READ_ONLY;

GRANT SELECT ON SBREXT.MDSR_CLASS_SCHEME_ITEM_VW TO GUEST;

GRANT SELECT ON SBREXT.MDSR_CLASS_SCHEME_ITEM_VW TO READONLY;

GRANT SELECT ON SBREXT.MDSR_CLASS_SCHEME_ITEM_VW TO SBR WITH GRANT OPTION;
