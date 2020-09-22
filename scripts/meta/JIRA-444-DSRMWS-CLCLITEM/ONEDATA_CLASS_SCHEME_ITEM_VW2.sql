DROP VIEW ONEDATA_WA.ONEDATA_CLASS_SCHEME_ITEM_VW;

/* Formatted on 9/21/2020 2:12:19 PM (QP5 v5.354) */
CREATE OR REPLACE FORCE VIEW ONEDATA_WA.ONEDATA_CLASS_SCHEME_ITEM_VW
(
    NCI_PUB_ID,
    NCI_VER_NR,
    ITEM_ID,
    VER_NR,
    ITEM_NM,
    ITEM_LONG_NM,
    ITEM_DESC,
    CNTXT_NM_DN,
    CURRNT_VER_IND,
    REGSTR_STUS_NM_DN,
    ADMIN_STUS_NM_DN,
    CREAT_DT,
    CREAT_USR_ID,
    LST_UPD_USR_ID,
    FLD_DELETE,
    LST_DEL_DT,
    S2P_TRN_DT,
    LST_UPD_DT,
    CS_ITEM_ID,
    CS_VER_NR,
    CS_LONG_NM,
    CS_ITEM_DESC,
    CSI_LEVEL,
    LEAF,
    PCSI_ITEM_ID,
    PCSI_VER_NR,
    PCSI_LONG_NM
)
BEQUEATH DEFINER
AS
        SELECT NCI_PUB_ID,
               NCI_VER_NR,
               ITEM_ID,
               VER_NR,
               ITEM_NM,
               ITEM_LONG_NM,
               ITEM_DESC,
               CNTXT_NM_DN,
               CURRNT_VER_IND,
               REGSTR_STUS_NM_DN,
               ADMIN_STUS_NM_DN,
               CREAT_DT,
               CREAT_USR_ID,
               LST_UPD_USR_ID,
               FLD_DELETE,
               LST_DEL_DT,
               S2P_TRN_DT,
               LST_UPD_DT,
               CS_ITEM_ID,
               CS_VER_NR,
               CS_LONG_NM,
               CS_ITEM_DESC,
              LEVEL,
              DECODE (CONNECT_BY_ISLEAF,  '1', 'FALSE',  '0', 'TRUE')
                   "IsLeaf",
               PCSI_ITEM_ID,
               PCSI_VER_NR
            --   ,               PCSI_LONG_NM
         -- ,CONNECT_BY_ISCYCLE "Cycle"
          FROM VW_CLASS_SCHEME_ITEM_MDSR--ONEDATA_WA.VW_CSI_NODE
    WHERE ITEM_ID=3070841-- CNTXT_NM_DN NOT IN ('TEST', 'Training')
    --   AND  INSTR (csi.CSITL_NAME, 'testCaseMix') = 0
                
               -- AND cs_conte.name NOT IN ('TEST', 'Training')
           --     AND ADMIN_STUS_NM_DN = 'RELEASED'--CS_ITEM_ID = 2192345
    --   and ITEM_ID=5635383 --  CONNECT BY  NOCYCLE

    CONNECT BY     PRIOR ITEM_ID = PCSI_ITEM_ID
               AND PRIOR VER_NR = PCSI_VER_NR
             --  AND PRIOR CS_ITEM_ID = CS_ITEM_ID
             --  AND PRIOR CS_VER_NR = CS_VER_NR
             AND PRIOR NCI_PUB_ID(+)< > NCI_PUB_ID
    START WITH PCSI_ITEM_ID IS NULL
      ORDER BY LEVEL, item_id;


--select*FROM VW_CLASS_SCHEME_ITEM_MDSR where item_id=3070841