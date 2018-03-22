/* Formatted on 3/21/2018 7:29:22 PM (QP5 v5.269.14213.34769) */
CREATE OR REPLACE FORCE VIEW MDSR_FB_XML_VW2
(
   "context",
   "createdBy",
   "dateCreated",
   "dateModified",
   "modifiedBy",
   "longName",
   "changeNote",
   "preferredDefinition",
   "cadsrRAI",
   "publicid",
   "version",
   "workflowStatusName",
   "categoryName",
   "type",
   "Form Instruction",
   MODULE_LIST,
   FRORM_PROTOCOL,
   FORMC_CLASS
)
AS
   SELECT cf.name "context",
          MF.CREATED_BY "createdBy",
          MF.DATE_CREATED "dateCreated",
          MF.DATE_MODIFIED "dateModified",
          MF.MODIFIED_by "modifiedBy",
          MF.long_name "longName",
          MF.CHANGE_NOTE "changeNote",
          MF.preferred_definition "preferredDefinition",
          '2.16.840.1.113883.3.26.2' "cadsrRAI",
          MF.QC_ID "publicid",
          MF.VERSION "version",
          MF.ASL_NAME "workflowStatusName",
          MF.QCDL_NAME "categoryName",
          MF.QTL_NAME "type",
          FI.preferred_definition "Form Instruction",
          CAST (
             MULTISET (
                  SELECT MM.DISPLAY_ORDER,
                         NVL (mm.REPEAT_NO, 0),
                         MM.long_name,
                         REDCAP_INSTRUCTIONS_T (Mod_instruction),
                         MM.preferred_Definition,
                         mm.mod_id,
                         mm.version,
                         MDSR_FB_UseCat_XML (usageType, Mod_instruction),
                         CAST (
                            MULTISET (
                                 SELECT                      --0level QUESTION
                                       QQ.QUES_id,
                                        QQ.QUES_version,
                                        isDerived,
                                        QQ.DISPLAY_ORDER,
                                        qq.date_created,
                                        qq.date_Modified,
                                        qq.Q_LONG_NAME,
                                        REDCAP_INSTRUCTIONS_T (Q_instruction),
                                        qq.EDITABLE_IND,
                                        qq.MANDATORY_IND,
                                        qq.multiValue,
                                        MDSR_FB_DATA_EL_XML_T (
                                           qq.de_LONG_NAME,
                                           de_PREFERRED_NAME,
                                           qq.CDE_ID,
                                           qq.de_version,
                                           qq.DE_context,
                                           qq.DE_WORKFLOW,
                                           qq.D_PREFERRED_DEFINITION,
                                           CAST (
                                              MULTISET (
                                                 SELECT           --1 data set
                                                       vd.long_name,
                                                        vd.vd_id,
                                                        vd.version,
                                                        vd.VD_TYPE_FLAG,
                                                        vd.ASL_NAME,
                                                        vd.DTL_NAME,
                                                        vd.MAX_LENGTH_NUM,
                                                        vd.MIN_LENGTH_NUM,
                                                        CAST (
                                                           MULTISET ( --2d data set
                                                              SELECT pv.VALUE,
                                                                     MDSR_FB_VM_XML_T (
                                                                        vm2.vm_id,
                                                                        vm2.version,
                                                                        vm2.long_name,
                                                                        CAST (
                                                                           MULTISET ( --3d data set MDSR_FB_DESIGN_XML_LIST_T
                                                                              SELECT d.created_by,
                                                                                     d.date_created,
                                                                                     d.LAE_NAME,
                                                                                     d.name,
                                                                                     DETL_NAME,
                                                                                     c.name,
                                                                                     CAST (
                                                                                        MULTISET ( --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                                             SELECT class_long_name,
                                                                                                    CS_ID,
                                                                                                    class_version,
                                                                                                    preferred_definition,
                                                                                                    MDSR_FB_FORM_CLI_XML_T (
                                                                                                       clitem_long_name,
                                                                                                       CSI_ID,
                                                                                                       clitem_version,
                                                                                                       CSITL_NAME)
                                                                                               FROM MDSR_FB_VM_CLASSIFICATION CL
                                                                                              WHERE d.DESIG_IDSEQ =
                                                                                                       CL.ATT_IDSEQ(+)
                                                                                           ORDER BY CS_ID) AS MDSR_FB_FORM_CL_XML_LIST_T) --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                                FROM SBR.DESIGNATIONS d,
                                                                                     SBR.contexts c
                                                                               WHERE     c.CONTE_IDSEQ =
                                                                                            d.CONTE_IDSEQ
                                                                                     AND d.ac_idseq =
                                                                                            vm2.vm_idseq) AS MDSR_FB_DESIGN_XML_LIST_T) --3d data set MDSR_FB_DESIGN_XML_LIST_T
                                                                                                                                       ,
                                                                        CAST (
                                                                           MULTISET ( --3d data set MDSR_FB_DEFIN_XML_LIST_T
                                                                              SELECT df.created_by,
                                                                                     df.date_created,
                                                                                     df.LAE_NAME,
                                                                                     df.DEFINITION,
                                                                                     SUBSTR (
                                                                                        DEFL_NAME,
                                                                                        1,
                                                                                        19),
                                                                                     -- c.name,
                                                                                     CAST (
                                                                                        MULTISET ( --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                                             SELECT class_long_name,
                                                                                                    CS_ID,
                                                                                                    class_version,
                                                                                                    preferred_definition,
                                                                                                    MDSR_FB_FORM_CLI_XML_T (
                                                                                                       clitem_long_name,
                                                                                                       CSI_ID,
                                                                                                       clitem_version,
                                                                                                       CSITL_NAME)
                                                                                               FROM MDSR_FB_VM_CLASSIFICATION CL
                                                                                              WHERE df.DEFIN_IDSEQ =
                                                                                                       CL.ATT_IDSEQ(+)
                                                                                           ORDER BY CS_ID) AS MDSR_FB_FORM_CL_XML_LIST_T) --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                                FROM SBR.DEFINITIONS df,
                                                                                     SBR.contexts c
                                                                               WHERE     c.CONTE_IDSEQ(+) =
                                                                                            df.CONTE_IDSEQ
                                                                                     AND df.ac_idseq =
                                                                                            vm2.vm_idseq) AS MDSR_FB_DEFIN_XML_LIST_T) --3d data set MDSR_FB_DEFIN_XML_LIST_T
                                                                                                                                      ,
                                                                        vm2.preferred_Definition)
                                                                FROM SBR.VALUE_MEANINGS vm2,
                                                                     SBR.PERMISSIBLE_VALUES pv,
                                                                     VD_PVS vp
                                                               WHERE     pv.pv_idseq =
                                                                            vp.pv_idseq --vm_id='3197154'
                                                                     AND vm2.vm_idseq =
                                                                            pv.VM_idseq
                                                                     AND vd.VD_IDSEQ =
                                                                            vp.VD_IDSEQ) AS MDSR_FB_PV_XML_LIST_T) ---2d list MDSR_FB_PV_XML_LIST_T
                                                   FROM value_domains vd
                                                  WHERE vd.vd_idseq = qq.vd_idseq) AS MDSR_FB_VD_XML_LIST_T),
                                              'https://cdebrowser.nci.nih.gov/CDEBrowser/search?elementDetails=9'
                                           || '&'
                                           || 'FirstTimer=0'
                                           || '&'
                                           || 'PageId=ElementDetailsGroup'
                                           || '&'
                                           || 'publicId='
                                           || QQ.CDE_ID
                                           || '&'
                                           || 'version='
                                           || QQ.de_version),
                                        CAST (
                                           MULTISET (
                                              SELECT rd.name,
                                                     rd.DCTL_NAME,
                                                     c2.name,
                                                     rd.doc_text,
                                                     rd.LAE_NAME,
                                                     rd.url
                                                FROM SBR.REFERENCE_DOCUMENTS rd,
                                                     SBR.contexts c2
                                               WHERE     c2.CONTE_IDSEQ =
                                                            rd.CONTE_IDSEQ
                                                     AND rd.ac_idseq =
                                                            qq.de_idseq) AS MDSR_FB_RD_XML_LIST_T4)
                                           AS FB_RD_LIST,
                                        CAST (
                                           MULTISET (
                                                SELECT TRIM (DISPLAY_ORDER),
                                                       TRIM (long_name),
                                                       TRIM (MEANING_TEXT),
                                                       TRIM (DESCRIPTION_TEXT),
                                                       MDSR_FB_VV_VM_XML_T (
                                                          vm_id,
                                                          vm_version)
                                                  FROM SBREXT.MDSR_FB_VALID_VALUE_MVW MVV
                                                 WHERE MVV.QUEST_IDseq =
                                                          qq.QUES_IDseq
                                              ORDER BY DISPLAY_ORDER) AS MDSR_FB_VV_XML_LIST_T)
                                           AS FB_VV_list
                                   -- from SBREXT.MDSR_FB_QUESTION_MVW QQ
                                   --where  qq.ques_id=2263418;
                                   FROM SBREXT.MDSR_FB_QUESTION_MVW QQ
                                  WHERE qq.mod_idseq = mm.MOD_IDSEQ
                               ORDER BY QQ.DISPLAY_ORDER) AS MDSR_FB_QUESTION_XML_LIST_T33)
                            AS Question_LIST
                    FROM SBREXT.MDSR_FB_QUEST_MODULE_MVW mm
                   WHERE mf.qc_IDSEQ = mm.CRF_IDSEQ
                --and mod_id=2263416
                ORDER BY MM.DISPLAY_ORDER) AS MDSR_FB_MODULE_XML_LIST_T33)
             AS MODULE_LIST,
          CAST (
             MULTISET (
                SELECT pe.lead_org,
                       pe.phase,
                       pe.TYPE,
                       pe.proto_ID,
                       TRIM (pe.long_name),
                       cf.name,
                       pe.PREFERRED_NAME,
                       UTL_I18N.UNESCAPE_REFERENCE (
                          TRIM (pe.PREFERRED_DEFINITION))
                  FROM PROTOCOLS_EXT pe, protocol_qc_ext pq
                 WHERE     mf.qc_IDSEQ = pq.qc_idseq(+)
                       AND pq.proto_idseq = pe.PROTO_IDSEQ(+)) AS MDSR_FB_PROTOCOL_XML_LIST_T)
             AS Frorm_PROTOCOL,
          CAST (MULTISET (  SELECT class_long_name,
                                   CS_ID,
                                   class_version,
                                   preferred_definition,
                                   MDSR_FB_FORM_CLI_XML_T (clitem_long_name,
                                                           CSI_ID,
                                                           clitem_version,
                                                           CSITL_NAME)
                              FROM MDSR_FB_classification CL
                             WHERE mf.qc_IDSEQ = CL.AC_IDSEQ(+)
                          ORDER BY CS_ID) AS NDSR_FB_FORM_CL_XML_LIST_T)
             AS formC_CLass
     FROM QUEST_CONTENTS_EXT mf,
          SBR.contexts cf,
          (SELECT *
             FROM QUEST_CONTENTS_EXT
            WHERE QTL_NAME = 'FORM_INSTR') fi,
          (SELECT *
             FROM QUEST_CONTENTS_EXT
            WHERE QTL_NAME = 'INSTRUCTION') ffi
    WHERE     mf.ASL_NAME = 'RELEASED'
          AND cf.CONTE_IDSEQ = mf.CONTE_IDSEQ
          AND fi.DN_CRF_IDSEQ(+) = mf.qc_idseq
          AND ffi.DN_CRF_IDSEQ(+) = mf.qc_idseq
          AND (MF.QTL_NAME = 'CRF' OR MF.QTL_NAME = 'TEMPLATE')
          AND mf.qc_id IN (5590324,
                           2263415,
                           2262683,
                           3443682,
                           3691952,
                           5791100,
                           4964471,
                           2019334,
                           2019339,
                           2019340,
                           2019343,
                           2019346);
