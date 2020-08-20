--DROP VIEW ONEDATA_WA.ONEDATA_WA_DE_CDE1_XML_GENERATOR_749VW;

/* Formatted on 8/20/2020 10:19:39 AM (QP5 v5.354) */
CREATE OR REPLACE FORCE VIEW ONEDATA_WA.ONEDATA_WA_DE_CDE1_XML_GENERATOR_749VW
(
    RAI,
    PUBLICID,
    LONGNAME,
    PREFERREDNAME,
    PREFERREDDEFINITION,
    VERSION,
    WORKFLOWSTATUS,
    CONTEXTNAME,
    CONTEXTVERSION,
    ORIGIN,
    REGISTRATIONSTATUS,
    DATAELEMENTCONCEPT,
    VALUEDOMAIN,
    REFERENCEDOCUMENTSLIST,
    CLASSIFICATIONSLIST,
    ALTERNATENAMELIST
)
BEQUEATH DEFINER
AS
    SELECT                                                     ---de.de_idseq,
           '2.16.840.1.113883.3.26.2'
               "RAI",
           ai.ITEM_ID
               "PublicId",
           ai.ITEM_LONG_NM
               "LongName",
           ai.ITEM_NM
               "PreferredName",
           ai.ITEM_DESC
               "PreferredDefinition",
           ai.VER_NR
               "Version",
           ai.ADMIN_STUS_NM_DN
               "WorkflowStatus",
           ai.CNTXT_NM_DN
               "ContextName",
           ai.CNTXT_VER_NR
               "ContextVersion",
           ai.origin
               "Origin",
           ai.REGSTR_STUS_NM_DN
               "RegistrationStatus",
           cdebrowser_dec_t (
               dec.dec_id,
               dec.dec_long_name,
               dec.PREFERRED_DEFINITION,
               dec.dec_preferred_name,
               dec.dec_version,
               dec.ASL_NAME,
               dec.dec_context_name,
               dec.dec_context_version,
               admin_component_with_id_ln_t (dec.cd_id,
                                             dec.cd_context_name,
                                             dec.cd_context_version,
                                             dec.cd_long_name,
                                             dec.cd_version,
                                             dec.cd_preferred_name),
               admin_component_with_con_t (
                   dec.oc_id,
                   dec.oc_context_name,
                   dec.oc_context_version,
                   dec.oc_long_name,
                   dec.oc_version,
                   dec.oc_preferred_name,
                   CAST (
                       MULTISET (
                             SELECT con.item_long_nm      preferred_name,
                                    con.item_nm           long_name,
                                    con.item_id           con_id,
                                    con.def_src           definition_source,
                                    con.origin            origin,
                                    cncpt.evs_src         evs_Source,
                                    com.NCI_PRMRY_IND     primary_flag_ind,
                                    com.nci_ord           display_order
                               FROM cncpt_admin_item   com,
                                    Admin_item         con,
                                    ONEDATA_WA.VW_CNCPT cncpt
                              WHERE     dec.oc_id = com.item_id(+)
                                    AND dec.oc_version = com.ver_nr(+)
                                    AND com.cncpt_item_id = con.item_id(+)
                                    AND com.cncpt_ver_nr = con.ver_nr(+)
                                    AND con.admin_item_typ_id(+) = 49
                                    AND com.cncpt_item_id = cncpt.item_id(+)
                                    AND com.cncpt_ver_nr = cncpt.ver_nr(+)
                           ORDER BY nci_ord DESC)
                           AS Concepts_list_t)),
               admin_component_with_con_t (
                   dec.prop_id,
                   dec.pt_context_name,
                   dec.pt_context_version,
                   dec.pt_long_name,
                   dec.pt_version,
                   dec.pt_preferred_name,
                   CAST (
                       MULTISET (
                             SELECT con.item_long_nm      preferred_name,
                                    con.item_nm           long_name,
                                    con.item_id           con_id,
                                    con.def_src           definition_source,
                                    con.origin            origin,
                                    cncpt.evs_src         evs_Source,
                                    com.NCI_PRMRY_IND     primary_flag_ind,
                                    com.nci_ord           display_order
                               FROM cncpt_admin_item   com,
                                    Admin_item         con,
                                    ONEDATA_WA.VW_CNCPT cncpt
                              WHERE     dec.prop_id = com.item_id(+)
                                    AND dec.pt_version = com.ver_nr(+)
                                    AND com.cncpt_item_id = con.item_id(+)
                                    AND com.cncpt_ver_nr = con.ver_nr(+)
                                    AND con.admin_item_typ_id(+) = 49
                                    AND com.cncpt_item_id = cncpt.item_id(+)
                                    AND com.cncpt_ver_nr = cncpt.ver_nr(+)
                           ORDER BY nci_ord DESC)
                           AS Concepts_list_t)),
               dec.obj_class_qualifier,
               dec.property_qualifier,
               dec.dec_origin)
               "DataElementConcept",
           -- select
           CDEBROWSER_VD_T749 (
               vdai.item_id,
               vdai.item_long_nm,
               vdai.item_desc,
               vdai.item_nm,
               vdai.ver_nr,
               vdai.admin_stus_nm_dn,
               vdai.cntxt_nm_dn,
               vdai.cntxt_ver_nr,
               admin_component_with_id_ln_T (cd.item_id,
                                               cd.cntxt_nm_dn,
                                               cd.cntxt_ver_nr,
                                               cd.item_long_nm,
                                               cd.ver_nr,
                                               cd.item_nm
                                               ),  /* */
               vd.dttype_id,
               DECODE (vd.VAL_DOM_TYP_ID,
                       17, 'Enumerated',
                       18, 'Non-enumerated'),
               vd.uom_id,
               vd.VAL_DOM_FMT_ID,
               vd.VAL_DOM_MAX_CHAR,
               vd.VAL_DOM_MIN_CHAR,
               vd.NCI_DEC_PREC,
               vd.CHAR_SET_ID,
               vd.VAL_DOM_HIGH_VAL_NUM,
               vd.VAL_DOM_LOW_VAL_NUM,
               vdai.origin,
               /*
                  sbrext.admin_component_with_con_t (
                   rep.rep_id,
                   rep_conte.name,
                   rep_conte.version,
                   rep.preferred_name,
                   rep.version,
                   rep.long_name,
                   CAST (
                       MULTISET (
                             SELECT con.preferred_name,
                                    con.long_name,
                                    con.con_id,
                                    con.definition_source,
                                    con.origin,
                                    con.evs_Source,
                                    com.primary_flag_ind,
                                    com.display_order
                               FROM component_concepts_ext com,
                                    concepts_ext          con
                              WHERE     rep.condr_idseq = com.condr_IDSEQ(+)
                                    AND com.con_idseq = con.con_idseq(+)
                           ORDER BY display_order DESC)
                           AS Concepts_list_t)),
                           */
               CAST (
                   MULTISET (
                       SELECT pv.PERM_VAL_NM,
                              pv.PERM_VAL_DESC_TXT,
                              vm.item_desc,
                              nci_11179.get_concepts (vm.item_id,
                                                      vm.ver_nr)
                                  MeaningConcepts,
                              /*  SBREXT.MDSR_CDEBROWSER.get_condr_origin (
                                    vm.condr_idseq)
                                    MeaningConceptOrigin,  */
                              nci_11179.get_concepts (vm.item_id, vm.ver_nr)
                                  MeaningConceptOrigin,
                              nci_11179.get_concept_order (vm.item_id,
                                                           vm.ver_nr)
                                  MeaningConceptDisplayOrder,
                              pv.PERM_VAL_BEG_DT,
                              pv.PERM_VAL_END_DT,
                              vm.item_id,
                              vm.ver_nr,
                              CAST (
                                  MULTISET (
                                      SELECT des.cntxt_nm_dn,
                                             TO_CHAR (des.cntxt_ver_nr),
                                             des.NM_DESC,
                                             ok.obj_key_desc,
                                             TO_CHAR (des.lang_id)   -- decode
                                        FROM alt_nms des, obj_key ok
                                       WHERE     vm.item_id = des.item_id(+)
                                             AND vm.ver_nr = des.ver_nr(+)
                                             AND des.NM_TYP_ID =
                                                 ok.obj_key_id(+))
                                      AS MDSR_749_ALTERNATENAM_LIST_T)
                                  "AlternateNameList"
                         FROM PERM_VAL pv, ADMIN_ITEM vm
                        WHERE     pv.val_dom_item_id = vd.item_id
                              AND pv.Val_dom_ver_nr = vd.ver_nr
                              AND pv.NCI_VAL_MEAN_ITEM_ID = vm.ITEM_ID
                              AND pv.NCI_VAL_MEAN_VER_NR = vm.VER_NR
                              AND vm.ADMIN_ITEM_TYP_ID = 53)
                       AS MDSR_749_PV_VD_LIST_T) /*,
                                         CAST (
                                             MULTISET (
                                                   SELECT con.preferred_name,
                                                          con.long_name,
                                                          con.con_id,
                                                          con.definition_source,
                                                          con.origin,
                                                          con.evs_Source,
                                                          com.primary_flag_ind,
                                                          com.display_order
                                                     FROM component_concepts_ext com, concepts_ext con
                                                    WHERE     vd.condr_idseq = com.condr_IDSEQ(+)
                                                          AND com.con_idseq = con.con_idseq(+)
                                                 ORDER BY display_order DESC) AS Concepts_list_t) */
                                                )
               "ValueDomain",
           CAST (
               MULTISET (
                   SELECT rd.ref_nm,
                          -- org.name,
                          ok.OBJ_KEY_DESC,
                          ok.obj_key_desc,
                          rd.ref_desc,
                          rd.URL,
                          TO_CHAR (rd.lang_id),
                          rd.disp_ord
                     FROM REF rd, obj_key ok
                    WHERE     rd.REF_TYP_ID = ok.obj_key_id(+)
                          --, sbr.organizations org
                          AND de.item_id = rd.item_id
                          AND de.ver_nr = rd.ver_nr)
                   AS cdebrowser_rd_list_t)
               "ReferenceDocumentsList",
           CAST (
               MULTISET (
                   SELECT admin_component_with_id_t (csv.cs_item_id,
                                                     csv.cs_cntxt_nm,
                                                     csv.cs_cntxt_ver_nr,
                                                     csv.csi_long_nm,
                                                     csv.cs_ver_nr),
                          csv.csi_item_nm,
                          csv.csitl_nm,
                          csv.csi_item_id,
                          csv.csi_ver_nr
                     FROM cdebrowser_cs_view_n csv
                    WHERE     de.item_id = csv.de_item_id
                          AND de.ver_nr = csv.de_ver_nr)
                   AS cdebrowser_csi_list_t)
               "ClassificationsList",
           CAST (
               MULTISET (
                   SELECT des.cntxt_nm_dn,
                          TO_CHAR (des.cntxt_ver_nr),
                          des.NM_DESC,
                          ok.obj_key_desc,
                          TO_CHAR (des.lang_id)
                     FROM alt_nms des, obj_key ok
                    WHERE     de.item_id = des.item_id
                          AND de.ver_nr = des.ver_nr
                          AND des.nm_typ_id = ok.obj_key_id(+))
                   AS cdebrowser_altname_list_t)
               "AlternateNameList"
      FROM ADMIN_ITEM              ai,
           cdebrowser_de_dec_view  dec,
           admin_item              vdai,
           ADMIN_ITEM              cd,
           ADMIN_ITEM              rep,
           value_dom               vd,
           de                      de
     WHERE     ai.item_id = dec.de_id
           AND ai.ver_nr = dec.de_version
           AND ai.ADMIN_STUS_NM_DN NOT IN
                   ('RETIRED WITHDRAWN', 'RETIRED DELETED')
           AND ai.item_id = de.item_id
           AND ai.ver_nr = de.ver_nr
           AND ai.admin_item_typ_id = 4
           AND cd.admin_item_typ_id = 1           
           AND cd.item_id=vd.CONC_DOM_ITEM_ID
           and cd.ver_nr=vd.CONC_DOM_VER_NR
           AND rep.ADMIN_ITEM_TYP_ID=7
           AND rep.item_id=vd.REP_CLS_ITEM_ID(+)
           AND rep.ver_nr=vd.REP_CLS_VER_NR(+)

           AND de.val_dom_item_id = vdai.item_id
           AND de.val_dom_ver_nr = vdai.ver_nr
           AND vdai.admin_item_typ_id = 3
           AND de.val_dom_item_id = vd.item_id
           AND de.val_dom_ver_nr = vd.ver_nr
           AND ai.ITEM_ID=2181785;
