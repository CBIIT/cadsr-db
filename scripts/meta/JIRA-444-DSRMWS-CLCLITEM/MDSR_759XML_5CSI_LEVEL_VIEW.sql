DROP VIEW SBREXT.MDSR_759XML_5CSI_LEVEL_VIEW;

/* Formatted on 9/17/2020 4:11:39 PM (QP5 v5.354) */
CREATE OR REPLACE FORCE VIEW SBREXT.MDSR_759XML_5CSI_LEVEL_VIEW
(
    "PreferredName",
    "Version",
    "ClassificationList"
)
BEQUEATH DEFINER
AS
    SELECT CS_CONTEXT_NAME,
           CS_CONTEXT_VERSION,
           CAST (
               MULTISET (  SELECT CS_ID,
                                  PREFERRED_NAME,
                                  LONG_NAME,
                                  VERSION,
                                  cs_date_created,
                                  CAST (
                                      MULTISET (
                                            SELECT v1.CSI_LEVEL,
                                                   v1.CSI_NAME,
                                                   v1.CSITL_NAME,
                                                   v1.CSI_ID,
                                                   v1.CSI_VERSION,
                                                   v1.csi_date_created,
                                                   v1.CSI_IDSEQ,
                                                   '',
                                                   NULL,
                                                   '',
                                                   v1.LEAF,
                                                   CAST (
                                                       MULTISET (
                                                             SELECT v2.CSI_LEVEL,
                                                                    v2.CSI_NAME,
                                                                    v2.CSITL_NAME,
                                                                    v2.CSI_ID,
                                                                    v2.CSI_VERSION,
                                                                    v2.csi_date_created,
                                                                    v2.CSI_IDSEQ,
                                                                    v2.PARENT_CSI_IDSEQ,
                                                                    v1.CSI_ID,
                                                                    v1.CSI_VERSION,
                                                                    v2.LEAF,
                                                                    CAST (
                                                                        MULTISET (
                                                                              SELECT v3.CSI_LEVEL,
                                                                                     v3.CSI_NAME,
                                                                                     v3.CSITL_NAME,
                                                                                     v3.CSI_ID,
                                                                                     v3.CSI_VERSION,
                                                                                     v3.csi_date_created,
                                                                                     v3.CSI_IDSEQ,
                                                                                     v3.PARENT_CSI_IDSEQ,
                                                                                     v2.CSI_ID,
                                                                                     v2.CSI_VERSION,
                                                                                     v3.LEAF,
                                                                                     CAST (
                                                                                         MULTISET (
                                                                                               SELECT v4.CSI_LEVEL,
                                                                                                      v4.CSI_NAME,
                                                                                                      v4.CSITL_NAME,
                                                                                                      v4.CSI_ID,
                                                                                                      v4.CSI_VERSION,
                                                                                                      v4.csi_date_created,
                                                                                                      v4.CSI_IDSEQ,
                                                                                                      v4.PARENT_CSI_IDSEQ,
                                                                                                      v3.CSI_ID,
                                                                                                      v3.CSI_VERSION,
                                                                                                      v4.LEAF,
                                                                                                      CAST (
                                                                                                          MULTISET (
                                                                                                                SELECT v5.CSI_LEVEL,
                                                                                                                       v5.CSI_NAME,
                                                                                                                       v5.CSITL_NAME,
                                                                                                                       v5.CSI_ID,
                                                                                                                       v5.CSI_VERSION,
                                                                                                                       v5.csi_date_created,
                                                                                                                       v5.CSI_IDSEQ,
                                                                                                                       v5.PARENT_CSI_IDSEQ,
                                                                                                                       v4.CSI_ID,
                                                                                                                       v4.CSI_VERSION,
                                                                                                                       v5.LEAF
                                                                                                                  FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
                                                                                                                       v5
                                                                                                                 --   ,(select* from  SBREXT.MDSR_CLASS_SCHEME_ITEM_VW  where CSI_LEVEL=4)v4
                                                                                                                 WHERE     v5.PARENT_CSI_IDSEQ =
                                                                                                                           v4.CS_CSI_IDSEQ
                                                                                                                       AND v5.CSI_LEVEL =
                                                                                                                           5
                                                                                                              --   group by csi.CSI_LEVEL,   csi.CSI_ID
                                                                                                              ORDER BY v5.CSI_ID)
                                                                                                              AS MDSR759_XML_CSI_LIST5_T)
                                                                                                          "level5"
                                                                                                 FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
                                                                                                      V4
                                                                                                WHERE     V4.CSI_LEVEL =
                                                                                                          4
                                                                                                      AND v4.PARENT_CSI_IDSEQ =
                                                                                                          v3.CS_CSI_IDSEQ
                                                                                             ORDER BY v4.CSI_ID)
                                                                                             AS MDSR759_XML_CSI_LIST4_T)
                                                                                         "level4"
                                                                                FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
                                                                                     V3
                                                                               WHERE     CSI_LEVEL =
                                                                                         3 --4551586
                                                                                     AND v3.PARENT_CSI_IDSEQ =
                                                                                         v2.CS_CSI_IDSEQ
                                                                            ORDER BY v3.CSI_ID)
                                                                            AS MDSR759_XML_CSI_LIST3_T)
                                                                        "level3"
                                                               FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
                                                                    V2
                                                              WHERE     CSI_LEVEL =
                                                                        2
                                                                    AND v2.PARENT_CSI_IDSEQ =
                                                                        v1.CS_CSI_IDSEQ
                                                           ORDER BY v2.CSI_ID)
                                                           AS MDSR759_XML_CSI_LIST2_T)    "level2"
                                              FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
                                                   V1
                                             WHERE     CSI_LEVEL = 1
                                                   AND V1.CS_IDSEQ =
                                                       cl.CS_IDSEQ
                                          ORDER BY v1.CSI_ID)
                                          AS MDSR759_XML_CSI_LIST1_T)    "ClassificationItemList"
                             FROM (SELECT DISTINCT CS_IDSEQ,
                                                   CS_ID,
                                                   PREFERRED_NAME,
                                                   LONG_NAME,
                                                   PREFERRED_DEFINITION,
                                                   VERSION,
                                                   CS_DATE_CREATED,
                                                   ASL_NAME,
                                                   CS_CONTEXT_NAME,
                                                   CS_CONTEXT_VERSION,
                                                   conte_idseq
                                     FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW) cl
                            WHERE cl.conte_idseq = con.CONTEXT_ID
                         ORDER BY CS_ID) AS MDSR759_XML_CS_L5_LIST_T)    "ClassificationList"
      FROM (  SELECT DISTINCT
                     CS_CONTEXT_NAME,
                     CS_CONTEXT_VERSION,
                     conte_idseq     CONTEXT_ID
                FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
            ORDER BY CS_CONTEXT_NAME) con;


CREATE OR REPLACE SYNONYM IGNATIUSC.MDSR_759XML_5CSI_LEVEL_VIEW FOR SBREXT.MDSR_759XML_5CSI_LEVEL_VIEW;


CREATE OR REPLACE SYNONYM KONGD.MDSR_759XML_5CSI_LEVEL_VIEW FOR SBREXT.MDSR_759XML_5CSI_LEVEL_VIEW;


CREATE OR REPLACE SYNONYM RAJMANNAR.MDSR_759XML_5CSI_LEVEL_VIEW FOR SBREXT.MDSR_759XML_5CSI_LEVEL_VIEW;


CREATE OR REPLACE SYNONYM ZHENGWUL.MDSR_759XML_5CSI_LEVEL_VIEW FOR SBREXT.MDSR_759XML_5CSI_LEVEL_VIEW;


GRANT SELECT ON SBREXT.MDSR_759XML_5CSI_LEVEL_VIEW TO GUEST;

GRANT SELECT ON SBREXT.MDSR_759XML_5CSI_LEVEL_VIEW TO READONLY;

GRANT SELECT ON SBREXT.MDSR_759XML_5CSI_LEVEL_VIEW TO SBR WITH GRANT OPTION;
