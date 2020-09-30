DROP VIEW ONEDATA_WA.REL_CLASS_SCHEME_ITEM_VW;

/* Formatted on 9/28/2020 10:34:54 AM (QP5 v5.354) */
CREATE OR REPLACE FORCE VIEW ONEDATA_WA.REL_CLASS_SCHEME_ITEM_VW
(
    CS_ID,
    CS_VERSION,
    PREFERRED_NAME,
    LONG_NAME,
    PREFERRED_DEFINITION,
    ASL_NAME,
    CS_CONTEXT_NAME,
    CS_CONTEXT_VERSION,
    NCI_PUB_ID,
    NCI_VER_NR,
    CSI_ID,
    CSI_VERSION,
    CSITL_NAME,
    CSI_NAME,
    DESCRIPTION,
    CSI_CONTEXT_NAME,
    CSI_CONTEXT_VERSION,
    CS_DATE_CREATED,
    CSI_DATE_CREATED,
    P_CSI_ID,
    P_CSI_VERSION,
    NCI_IDSEQ,
    CSI_LEVEL,
    "IsLeaf",
    CS_CSI_IDSEQ,
    P_CS_CSI_IDSEQ,
    CS_CONTEXT_ID,
    CSI_CONTEXT_ID
)
BEQUEATH DEFINER
AS
        SELECT NODE.CNTXT_CS_ITEM_ID
                   CS_ID,
               NODE.CNTXT_CS_VER_NR
                   CS_VERSION,
               CS.ITEM_LONG_NM
                   PREFERRED_NAME,
               CS.ITEM_NM
                   LONG_NAME,
               CSI.ITEM_DESC
                   PREFERRED_DEFINITION,
               cs.ADMIN_STUS_NM_DN
                   ASL_NAME,
               CS.CNTXT_NM_DN
                   CS_CONTEXT_NAME,
               CS.CNTXT_VER_NR
                   CS_CONTEXT_VERSION,
               -- CONTE_IDSEQ,
               NODE.NCI_PUB_ID,
               NODE.NCI_VER_NR,
               NODE.C_ITEM_ID
                   CSI_ID,
               NODE.C_item_ver_nr
                   CSI_VERSION,
               O.NCI_CD
                   CSITL_NAME,
               -- CSI.ITEM_NM,
               CSI.ITEM_NM
                   CSI_NAME,
               CSI.ITEM_DESC
                   description,
               CSI.CNTXT_NM_DN
                   CSI_CONTEXT_NAME,
               CSI.CNTXT_VER_NR
                   CSI_CONTEXT_VERSION,
               CS.CREAT_DT
                   CS_DATE_CREATED,
               CSI.CREAT_DT
                   CSI_DATE_CREATED,
               --  LEVEL CSI_LEVEL,
               -- DECODE (CONNECT_BY_ISLEAF,  '1', 'FALSE',  '0', 'TRUE') "IsLeaf",
               NODE.P_ITEM_ID
                   P_CSI_ID,
               NODE.p_item_ver_nr
                   P_CSI_VERSION,
               NODE.NCI_IDSEQ,
               LEVEL
                   CSI_LEVEL,
               DECODE (CONNECT_BY_ISLEAF,  '1', 'FALSE',  '0', 'TRUE')
                   "IsLeaf",
               P.CS_CSI_IDSEQ,
               P_CS_CSI_IDSEQ,
               cs.CNTXT_ITEM_ID CS_CONTEXT_ID,csi.CNTXT_ITEM_ID CSI_CONTEXT_ID
               
          FROM NCI_ADMIN_ITEM_REL_ALT_KEY NODE,
               admin_item              CS,
               admin_item              CSI,
               NCI_CLSFCTN_SCHM_ITEM   NCSI,
               OBJ_KEY                 O,
               PC_CS_CSI               p
         WHERE     cs.ADMIN_ITEM_TYP_ID = 9
               AND cs.ADMIN_STUS_NM_DN = 'RELEASED'
               AND csi.ADMIN_ITEM_TYP_ID = 51
               AND node.c_item_id = csi.item_id
               AND node.c_item_ver_nr = csi.ver_nr
               AND csi.item_id = ncsi.item_id
               AND csi.ver_nr = ncsi.ver_nr
               AND ncsi.CSI_TYP_ID = o.obj_key_id
               AND node.cntxt_cs_item_id = cs.item_id
               AND node.cntxt_cs_Ver_nr = cs.ver_nr
               AND node.rel_typ_id = 64
               AND INSTR (O.NCI_CD, 'testCaseMix') = 0
               --  AND C_ITEM_ID=3070841
               AND CS.CNTXT_NM_DN NOT IN ('TEST', 'Training')
               AND CSI.CNTXT_NM_DN NOT IN ('TEST', 'Training')
               AND NODE.NCI_IDSEQ = P.CS_CSI_IDSEQ
    CONNECT BY PRIOR CS_CSI_IDSEQ = P_CS_CSI_IDSEQ
    START WITH P_CS_CSI_IDSEQ IS NULL
      ORDER BY CNTXT_CS_ITEM_ID, C_ITEM_ID, P_ITEM_ID             --,LEVEL ,;
;


GRANT SELECT ON ONEDATA_WA.REL_CLASS_SCHEME_ITEM_VW TO PUBLIC;
