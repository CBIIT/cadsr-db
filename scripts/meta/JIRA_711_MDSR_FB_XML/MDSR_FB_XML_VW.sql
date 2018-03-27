/* Formatted on 3/27/2018 1:23:59 PM (QP5 v5.269.14213.34769) */
CREATE OR REPLACE FORCE VIEW MDSR_FB_XML_VW
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
   "headerInstruction",
   MODULE_LIST,
   FORM_PROTOCOL,
   REF_DOC,
   FORM_CLASS
)
AS
   SELECT cf.name "context",
          FR.CREATED_BY "createdBy",
             TO_CHAR (FR.DATE_CREATED, 'YYYY-MM-DD')
          || 'T'
          || TO_CHAR (FR.DATE_CREATED, 'HH24:MI:SS')
             "dateCreated",
          DECODE (
             FR.DATE_MODIFIED,
             NULL, NULL,
                TO_CHAR (FR.DATE_MODIFIED, 'YYYY-MM-DD')
             || 'T'
             || TO_CHAR (FR.DATE_MODIFIED, 'HH24:MI:SS'))
             "dateModified",
          FR.MODIFIED_by "modifiedBy",
          FR.long_name "longName",
          FR.CHANGE_NOTE "changeNote",
          FR.preferred_definition "preferredDefinition",
          '2.16.840.1.113883.3.26.2' "cadsrRAI",
          FR.QC_ID "publicid",
          FR.VERSION "version",
          FR.ASL_NAME "workflowStatusName",
          FR.QCDL_NAME "categoryName",
          FR.QTL_NAME "type",
          SBREXT.REDCAP_HINSTRUCTIONS_T (FI.preferred_definition),
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
                                           TO_CHAR (QQ.DATE_CREATED,
                                                    'YYYY-MM-DD')
                                        || 'T'
                                        || TO_CHAR (QQ.DATE_CREATED,
                                                    'HH24:MI:SS')
                                           "dateCreated",
                                        DECODE (
                                           QQ.DATE_MODIFIED,
                                           NULL, NULL,
                                              TO_CHAR (QQ.DATE_MODIFIED,
                                                       'YYYY-MM-DD')
                                           || 'T'
                                           || TO_CHAR (QQ.DATE_MODIFIED,
                                                       'HH24:MI:SS'))
                                           "dateModified",
                                        qq.Q_LONG_NAME,
                                        REDCAP_INSTRUCTIONS_T (Q_instruction),
                                        trim(qq.EDITABLE_IND),
                                        trim(qq.MANDATORY_IND),
                                        trim(qq.multiValue),
                                        -- MDSR_FB_DATA_EL_XML_T1 started
                                        MDSR_FB_DATA_EL_XML_T1 (
                                           --select
                                           qq.de_LONG_NAME,
                                           de_PREFERRED_NAME,
                                           qq.CDE_ID,
                                           qq.de_version,
                                           qq.DE_context,
                                           qq.DE_WORKFLOW,
                                           qq.D_PREFERRED_DEFINITION,
                                           CAST (
                                              MULTISET ( -- data set MDSR_FB_DESIGN_XML_LIST_T for VD
                                                 SELECT d.created_by,
                                                           TO_CHAR (
                                                              d.DATE_CREATED,
                                                              'YYYY-MM-DD')
                                                        || 'T'
                                                        || TO_CHAR (
                                                              d.DATE_CREATED,
                                                              'HH24:MI:SS')
                                                           "dateCreated",
                                                        DECODE (
                                                           d.DATE_MODIFIED,
                                                           NULL, NULL,
                                                              TO_CHAR (
                                                                 d.DATE_MODIFIED,
                                                                 'YYYY-MM-DD')
                                                           || 'T'
                                                           || TO_CHAR (
                                                                 d.DATE_MODIFIED,
                                                                 'HH24:MI:SS'))
                                                           "dateModified",
                                                        d.Modified_by,
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
                                                                       MDSR_FB_FORM_CLI_XML_T1 (
                                                                          clitem_long_name,
                                                                          CSI_ID,
                                                                          clitem_version,
                                                                          CSITL_NAME,
                                                                          CLI_PREF_DEF)
                                                                  FROM MDSR_FB_VM_CLASSIFICATION CL
                                                                 WHERE d.DESIG_IDSEQ =
                                                                          CL.ATT_IDSEQ(+)
                                                              ORDER BY CS_ID) AS MDSR_FB_FORM_CL_XML_LIST_T1) --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                   FROM SBR.DESIGNATIONS d,
                                                        SBR.contexts c
                                                  WHERE     c.CONTE_IDSEQ =
                                                               d.CONTE_IDSEQ
                                                        AND d.ac_idseq =
                                                               qq.vd_idseq) AS MDSR_FB_DESIGN_XML_LIST_T1) --3d data set MDSR_FB_DESIGN_XML_LIST_T
                                                                                                          ,
                                           -- CAST (
                                           --  MULTISET (
                                           MDSR_FB_VD_XML_T1 (    --1 data set
                                              vd.long_name,
                                              VD.preferred_name,
                                              vd.vd_id,
                                              vd.version,
                                              DECODE (vd.VD_TYPE_FLAG,
                                                      'E', 'Enumerated',
                                                      'N', 'NonEnumerated',
                                                      'Unknown'),
                                              cvd.name,
                                              vd.ASL_NAME,
                                              vd.DTL_NAME,
                                              vd.DECIMAL_PLACE,
                                              vd.FORML_NAME,
                                              vd.HIGH_VALUE_NUM,
                                              vd.LOW_VALUE_NUM,
                                              vd.MAX_LENGTH_NUM,
                                              vd.MIN_LENGTH_NUM,
                                              vd.UOML_NAME,
                                              CAST (
                                                 MULTISET (
                                                      SELECT c.long_name,
                                                             SUBSTR (
                                                                   DISPLAY_ORDER
                                                                || c.preferred_name,
                                                                2),
                                                                'http://ncit.nci.nih.gov/ncitbrowser/ConceptReport.jsp?dictionary=NCI%20Thesaurus'
                                                             || '&'
                                                             || 'amp;code='
                                                             || c.preferred_name
                                                                AS url
                                                        FROM COMPONENT_CONCEPTS_EXT cx,
                                                             CONCEPTS_EXT c
                                                       WHERE     cx.condr_idseq =
                                                                    vd.condr_idseq --'A9262D2A-4461-A9EB-E040-BB89AD43673D'
                                                             AND c.CON_IDSEQ =
                                                                    cx.CON_IDSEQ
                                                             AND vd.condr_idseq =
                                                                    'A9262D2A-4461-A9EB-E040-BB89AD43673D' --vd.condr_idseq
                                                    ORDER BY DISPLAY_ORDER) AS MDSR_FB_VDCon_XML_LIST_T1) /* */
                                                                                                         ,
                                              CAST (
                                                 MULTISET (      --2d data set
                                                    SELECT pv.VALUE,
                                                           MDSR_FB_VM_XML_T1 (
                                                              vm2.vm_id,
                                                              vm2.version,
                                                              vm2.long_name,
                                                              CAST (
                                                                 MULTISET ( --3d data set MDSR_FB_DESIGN_XML_LIST_T
                                                                    SELECT d.created_by,
                                                                              TO_CHAR (
                                                                                 d.DATE_CREATED,
                                                                                 'YYYY-MM-DD')
                                                                           || 'T'
                                                                           || TO_CHAR (
                                                                                 d.DATE_CREATED,
                                                                                 'HH24:MI:SS')
                                                                              "dateCreated",
                                                                           DECODE (
                                                                              d.DATE_MODIFIED,
                                                                              NULL, NULL,
                                                                                 TO_CHAR (
                                                                                    d.DATE_MODIFIED,
                                                                                    'YYYY-MM-DD')
                                                                              || 'T'
                                                                              || TO_CHAR (
                                                                                    d.DATE_MODIFIED,
                                                                                    'HH24:MI:SS')),
                                                                           d.Modified_by,
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
                                                                                          MDSR_FB_FORM_CLI_XML_T1 (
                                                                                             clitem_long_name,
                                                                                             CSI_ID,
                                                                                             clitem_version,
                                                                                             CSITL_NAME,
                                                                                             CLI_PREF_DEF)
                                                                                     FROM MDSR_FB_VM_CLASSIFICATION CL
                                                                                    WHERE d.DESIG_IDSEQ =
                                                                                             CL.ATT_IDSEQ(+)
                                                                                 ORDER BY CS_ID) AS MDSR_FB_FORM_CL_XML_LIST_T1) --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                      FROM SBR.DESIGNATIONS d,
                                                                           SBR.contexts c
                                                                     WHERE     c.CONTE_IDSEQ =
                                                                                  d.CONTE_IDSEQ
                                                                           AND d.ac_idseq =
                                                                                  vm2.vm_idseq) AS MDSR_FB_DESIGN_XML_LIST_T1) --3d data set MDSR_FB_DESIGN_XML_LIST_T
                                                                                                                              ,
                                                              CAST (
                                                                 MULTISET ( --3d data set MDSR_FB_DEFIN_XML_LIST_T
                                                                    SELECT df.created_by,
                                                                              TO_CHAR (
                                                                                 df.DATE_CREATED,
                                                                                 'YYYY-MM-DD')
                                                                           || 'T'
                                                                           || TO_CHAR (
                                                                                 df.DATE_CREATED,
                                                                                 'HH24:MI:SS')
                                                                              "dateCreated",
                                                                           DECODE (
                                                                              df.DATE_MODIFIED,
                                                                              NULL, NULL,
                                                                                 TO_CHAR (
                                                                                    df.DATE_MODIFIED,
                                                                                    'YYYY-MM-DD')
                                                                              || 'T'
                                                                              || TO_CHAR (
                                                                                    df.DATE_MODIFIED,
                                                                                    'HH24:MI:SS'))
                                                                              "dateModified",
                                                                           df.Modified_by,
                                                                           df.LAE_NAME,
                                                                           df.DEFINITION,
                                                                           DEFL_NAME,
                                                                           CAST (
                                                                              MULTISET ( --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                                   SELECT class_long_name,
                                                                                          CS_ID,
                                                                                          class_version,
                                                                                          preferred_definition,
                                                                                          MDSR_FB_FORM_CLI_XML_T1 (
                                                                                             clitem_long_name,
                                                                                             CSI_ID,
                                                                                             clitem_version,
                                                                                             CSITL_NAME,
                                                                                             --CLI_PREF_DEF
                                                                                             NULL)
                                                                                     FROM MDSR_FB_VM_CLASSIFICATION CL
                                                                                    WHERE df.DEFIN_IDSEQ =
                                                                                             CL.ATT_IDSEQ(+)
                                                                                 ORDER BY CS_ID) AS MDSR_FB_FORM_CL_XML_LIST_T1) --4th data set   MDSR_FB_FORM_CL_XML_LIST_T
                                                                                                                                ,
                                                                           c.name
                                                                      FROM SBR.DEFINITIONS df,
                                                                           SBR.contexts c
                                                                     WHERE     c.CONTE_IDSEQ(+) =
                                                                                  df.CONTE_IDSEQ
                                                                           AND df.ac_idseq =
                                                                                  vm2.vm_idseq) AS MDSR_FB_DEFIN_XML_LIST_T1) --3d data set MDSR_FB_DEFIN_XML_LIST_T
                                                                                                                             ,
                                                              vm2.preferred_Definition),
                                                           DECODE (
                                                              pv.begin_date,
                                                              NULL, NULL,
                                                                 TO_CHAR (
                                                                    pv.begin_date,
                                                                    'YYYY-MM-DD')
                                                              || 'T'
                                                              || TO_CHAR (
                                                                    pv.begin_date,
                                                                    'HH24:MI:SS'))
                                                              "begindate",
                                                           DECODE (
                                                              pv.end_date,
                                                              NULL, NULL,
                                                                 TO_CHAR (
                                                                    pv.end_date,
                                                                    'YYYY-MM-DD')
                                                              || 'T'
                                                              || TO_CHAR (
                                                                    pv.end_date,
                                                                    'HH24:MI:SS'))
                                                              "enddate"
                                                      FROM SBR.VALUE_MEANINGS vm2,
                                                           SBR.PERMISSIBLE_VALUES pv,
                                                           VD_PVS vp
                                                     /* FROM SBR.VALUE_MEANINGS vm2,
                                                       SBR.PERMISSIBLE_VALUES pv
                                                       where vm2.vm_id='3197154'
                                                      AND vm2.vm_idseq = pv.VM_idseq*/
                                                     -- ,

                                                     WHERE     pv.pv_idseq =
                                                                  vp.pv_idseq --vm_id='3197154'
                                                           AND vm2.vm_idseq =
                                                                  pv.VM_idseq
                                                           AND vd.VD_IDSEQ =
                                                                  vp.VD_IDSEQ
                                                           AND vp.vd_idseq =
                                                                  qq.vd_idseq) AS MDSR_FB_PV_XML_LIST_T1) ---2d list MDSR_FB_PV_XML_LIST_T
                                                                                                         ,
                                              CAST (
                                                 MULTISET (
                                                    SELECT rd.name,
                                                           rd.DCTL_NAME,
                                                           c2.name,
                                                           rd.doc_text,
                                                           rd.LAE_NAME,
                                                           rd.url,
                                                           MDSR_FB_RD_ATTACH_XML_T1 (
                                                              rb.name,
                                                              rb.MIME_TYPE,
                                                              rb.doc_size)
                                                      FROM SBR.REFERENCE_DOCUMENTS rd,
                                                           SBR.contexts c2,
                                                           SBR.REFERENCE_BLOBS RB
                                                     WHERE     RD.RD_IDSEQ =
                                                                  RB.RD_IDSEQ(+)
                                                           AND c2.CONTE_IDSEQ =
                                                                  rd.CONTE_IDSEQ
                                                           AND rd.ac_idseq =
                                                                  qq.vd_idseq) AS MDSR_FB_RD_XML_LIST_T1)) /*    --select*
                                                                                                            FROM SBREXT.MDSR_FB_QUESTION_MVW QQ,
                                                                                                            value_domains vd,
                                                                                                            SBR.contexts cvd
                                                                                                            WHERE qq.vd_idseq='88C8CA47-107D-15CD-E040-BB89AD437F3A'
                                                                                                            AND  cvd.CONTE_IDSEQ = vd.CONTE_IDSEQ
                                                                                                            and vd.vd_idseq = qq.vd_idseq*/



                                                -- ) AS MDSR_FB_VD_XML_LIST_T)
                                           ,
                                           CAST (
                                              MULTISET (
                                                 SELECT MDSR_FB_USECAT_XML (
                                                           'Mandatory',
                                                           ''),
                                                        '0',
                                                        MDSR_FB_DE_DR_XML_T1 (
                                                           '0',
                                                           '0',
                                                           MDSR_FB_VD_DR_XML_T1 (
                                                              'PRSN_WT_VAL',
                                                              'NonEnumerated',
                                                              'RELEASED',
                                                              MDSR_FB_VDC_DR_XML_T1 (
                                                                 'http://blankNode')))
                                                   FROM SBR.COMPLEX_DATA_ELEMENTS cdv,
                                                        SBR.DATA_ELEMENTS DE
                                                  WHERE     cdv.P_DE_IDSEQ(+) =
                                                               de.DE_IDSEQ
                                                        AND isDerived = 'true'
                                                        AND de.DE_IDSEQ =
                                                               qq.DE_IDSEQ) AS MDSR_FB_COM_DE_DR_XML_LIST_T1),
                                           CAST (
                                              MULTISET (
                                                 SELECT rd.name,
                                                        rd.DCTL_NAME,
                                                        c2.name,
                                                        rd.doc_text,
                                                        rd.LAE_NAME,
                                                        rd.url,
                                                        MDSR_FB_RD_ATTACH_XML_T1 (
                                                           rb.name,
                                                           rb.MIME_TYPE,
                                                           rb.doc_size)
                                                   FROM SBR.REFERENCE_DOCUMENTS rd,
                                                        SBR.contexts c2,
                                                        SBR.REFERENCE_BLOBS RB
                                                  WHERE     RD.RD_IDSEQ =
                                                               RB.RD_IDSEQ(+)
                                                        AND c2.CONTE_IDSEQ =
                                                               rd.CONTE_IDSEQ
                                                        AND rd.ac_idseq =
                                                               qq.de_idseq) AS MDSR_FB_RD_XML_LIST_T1),
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
                                        --  select
                                        CAST (
                                           MULTISET (
                                                SELECT TRIM (DISPLAY_ORDER),
                                                       TRIM (long_name),
                                                       TRIM (MEANING_TEXT),
                                                       TRIM (DESCRIPTION_TEXT),
                                                       REDCAP_INSTRUCTIONS_T (
                                                          TRIM (INSTRUCTION)),
                                                       MDSR_FB_VV_VM_XML_T1 (
                                                          vm_id,
                                                          vm_version)
                                                  FROM SBREXT.MDSR_FB_VALID_VALUE_MVW MVV
                                                 WHERE MVV.QUEST_IDseq =
                                                          qq.QUES_IDseq
                                              ORDER BY DISPLAY_ORDER) AS MDSR_FB_VV_XML_LIST_T1)
                                           AS VV
                                   --select *from SBREXT.MDSR_FB_QUESTION_MVW QQ where QQ.QUES_IDSEQ= '430203EE-CCBE-6162-E053-F662850A2532';



                                   FROM SBREXT.MDSR_FB_QUESTION_MVW QQ,
                                        value_domains vd,
                                        SBR.contexts cvd
                                  WHERE     qq.mod_idseq = mm.MOD_IDSEQ
                                        AND cvd.CONTE_IDSEQ = vd.CONTE_IDSEQ
                                        AND vd.vd_idseq = qq.vd_idseq
                               ORDER BY QQ.DISPLAY_ORDER) AS MDSR_FB_QUESTION_XML_LIST_T1)
                            AS Question_LIST
                    FROM SBREXT.MDSR_FB_QUEST_MODULE_MVW mm
                   WHERE FR.qc_IDSEQ = mm.CRF_IDSEQ   --and mm.mod_id=4118190;
                ORDER BY mm.DISPLAY_ORDER) AS MDSR_FB_MODULE_XML_LIST_T1)
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
                 WHERE     FR.qc_IDSEQ = pq.qc_idseq(+)
                       AND pq.proto_idseq = pe.PROTO_IDSEQ(+)) AS MDSR_FB_PROTOCOL_XML_LIST_T)
             AS Form_PROTOCOL,
          CAST (
             MULTISET (
                SELECT rd.name,
                       rd.DCTL_NAME,
                       c2.name,
                       rd.doc_text,
                       rd.LAE_NAME,
                       rd.url,
                       MDSR_FB_RD_ATTACH_XML_T1 (rb.name,
                                                 rb.MIME_TYPE,
                                                 rb.doc_size)
                  FROM SBR.REFERENCE_DOCUMENTS rd,
                       SBR.contexts c2,
                       SBR.REFERENCE_BLOBS RB
                 WHERE     RD.RD_IDSEQ = RB.RD_IDSEQ(+)
                       AND c2.CONTE_IDSEQ = rd.CONTE_IDSEQ
                       AND rd.ac_idseq = FR.qc_idseq) AS MDSR_FB_RD_XML_LIST_T1)
             AS REFDOC,
          CAST (MULTISET (  SELECT class_long_name,
                                   CS_ID,
                                   class_version,
                                   preferred_definition,
                                   MDSR_FB_FORM_CLI_XML_T1 (clitem_long_name,
                                                            CSI_ID,
                                                            clitem_version,
                                                            CSITL_NAME,
                                                            CLI_PREF_DEF)
                              FROM MDSR_FB_classification CL
                             WHERE FR.qc_IDSEQ = CL.AC_IDSEQ(+)
                          ORDER BY CS_ID) AS MDSR_FB_FORM_CL_XML_LIST_T1)
             AS form_CLass
     FROM SBREXT.QUEST_CONTENTS_EXT FR,
          SBR.contexts cf,
          (SELECT *
             FROM QUEST_CONTENTS_EXT
            WHERE QTL_NAME = 'FORM_INSTR') fi,
          (SELECT *
             FROM QUEST_CONTENTS_EXT
            WHERE QTL_NAME = 'INSTRUCTION') ffi
    WHERE     FR.ASL_NAME = 'RELEASED'
          AND cf.CONTE_IDSEQ = FR.CONTE_IDSEQ
          AND fi.DN_CRF_IDSEQ(+) = FR.qc_idseq
          AND ffi.DN_CRF_IDSEQ(+) = FR.qc_idseq
          AND (FR.QTL_NAME = 'CRF' OR FR.QTL_NAME = 'TEMPLATE')
          AND FR.qc_id IN (5590324,
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
                           2019346,
                           4118188);
