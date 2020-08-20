DROP VIEW ONEDATA_WA.CDEBROWSER_CS_VIEW_N;

/* Formatted on 8/20/2020 3:47:47 PM (QP5 v5.354) */
CREATE OR REPLACE FORCE VIEW ONEDATA_WA.CDEBROWSER_CS_VIEW_N
(
    DE_ITEM_ID,
    DE_VER_NR,
    CS_ITEM_ID,
    CS_ITEM_NM,
    CS_ITEM_LONG_NM,
    CS_PREF_DEF,
    CS_VER_NR,
    CS_ADMIN_STUS,
    CS_CNTXT_NM,
    CS_CNTXT_VER_NR,
    CSI_LONG_NM,
    CSITL_NM,
    CSI_PREF_DEF,
    CSI_ITEM_ID,
    CSI_VER_NR,
    CSI_ITEM_NM
)
BEQUEATH DEFINER
AS
    SELECT ac_csi.c_item_id         de_item_id,
           ac_csi.c_item_ver_nr     de_ver_nr,
           cs.item_id               cs_item_id,
           cs.item_nm               cs_item_nm,
           cs.item_long_nm          cs_item_long_nm,
           cs.item_desc             cs_pref_def,
           cs.ver_nr                cs_ver_nr,
           cs.admin_stus_nm_dn      cs_admin_stus,
           cs.cntxt_nm_dn           cs_cntxt_nm,
           cs.cntxt_ver_nr          cs_cntxt_ver_nr,
           csi.item_long_nm         csi_long_nm,
           o.NCI_CD                 csitl_nm,
           csi.item_desc            csi_pref_def,
           csi.item_id              csi_item_id,
           csi.ver_nr               csi_ver_nr,
           csi.item_nm              csi_item_nm
      FROM admin_item                  cs,
           NCI_ADMIN_ITEM_REL_ALT_KEY  cs_csi,
           ADMIN_ITEM                  csi,
           NCI_ALT_KEY_ADMIN_ITEM_REL  ac_csi,
           OBJ_KEY                     o,
           NCI_CLSFCTN_SCHM_ITEM       ncsi
     WHERE     cs.item_id = cs_csi.CNTXT_CS_ITEM_ID
           AND cs.ver_nr = cs_csi.CNTXT_CS_VER_NR
           AND csi.item_id = cs_csi.c_item_id
           AND csi.ver_nr = cs_csi.c_item_ver_nr
           AND cs_csi.nci_pub_id = ac_csi.nci_pub_id
           AND cs_csi.nci_ver_nr = ac_csi.nci_ver_nr
           AND csi.item_id = ncsi.item_id
           AND csi.ver_nr = ncsi.ver_nr
           AND ncsi.CSI_TYP_ID = o.obj_key_id;
