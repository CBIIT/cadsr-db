set serveroutput on size 1000000
SPOOL CADSRMETA-787.log  
CREATE OR REPLACE FORCE VIEW SBREXT.DE_CDE1_XML_GENERATOR_749VW
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
    DATE_MODIFIED,
    DATAELEMENTCONCEPT,
    VALUEDOMAIN,
    REFERENCEDOCUMENTSLIST,
    CLASSIFICATIONSLIST,
    ALTERNATENAMELIST,
    DATAELEMENTDERIVATION
)
AS
    SELECT                                                      --de.de_idseq,
           '2.16.840.1.113883.3.26.2'                            "RAI",
           de.CDE_ID                                             "PublicId",
           de.long_name                                          "LongName",
           de.preferred_name                                     "PreferredName",
           de.preferred_definition                               "PreferredDefinition",
           de.version                                            "Version",
           de.ASL_NAME                                           "WorkflowStatus",
           de_conte.name                                         "ContextName",
           de_conte.version                                      "ContextVersion",
           de.origin                                             "Origin",
           ar.registration_status                                "RegistrationStatus",
           de.DATE_MODIFIED                                      "dateModified",
           cdebrowser_dec_t (dec.dec_id,
                             dec.dec_preferred_name,
                             dec.PREFERRED_DEFINITION,
                             dec.dec_long_name,
                             dec.dec_version,
                             dec.ASL_NAME,
                             dec.dec_context_name,
                             dec.dec_context_version,
                             sbrext.admin_component_with_id_ln_t (
                                 dec.cd_id,
                                 dec.cd_context_name,
                                 dec.cd_context_version,
                                 dec.cd_preferred_name,
                                 dec.cd_version,
                                 dec.cd_long_name),
                             sbrext.admin_component_with_con_t (
                                 dec.oc_id,
                                 dec.oc_context_name,
                                 dec.oc_context_version,
                                 dec.oc_preferred_name,
                                 dec.oc_version,
                                 dec.oc_long_name,
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
                                             FROM sbrext.component_concepts_ext
                                                  com,
                                                  sbrext.concepts_ext con
                                            WHERE     dec.oc_condr_idseq =
                                                      com.condr_IDSEQ(+)
                                                  AND com.con_idseq =
                                                      con.con_idseq(+)
                                         ORDER BY display_order DESC)
                                         AS Concepts_list_t)),
                             sbrext.admin_component_with_con_t (
                                 dec.prop_id,
                                 dec.pt_context_name,
                                 dec.pt_context_version,
                                 dec.pt_preferred_name,
                                 dec.pt_version,
                                 dec.pt_long_name,
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
                                             FROM sbrext.component_concepts_ext
                                                  com,
                                                  sbrext.concepts_ext con
                                            WHERE     dec.prop_condr_idseq =
                                                      com.condr_IDSEQ(+)
                                                  AND com.con_idseq =
                                                      con.con_idseq(+)
                                         ORDER BY display_order DESC)
                                         AS Concepts_list_t)),
                             dec.obj_class_qualifier,
                             dec.property_qualifier,
                             dec.dec_origin)                     "DataElementConcept",
           sbrext.CDEBROWSER_VD_T787 (
               vd.vd_id,
               vd.preferred_name,
               vd.preferred_definition,
               vd.long_name,
               vd.version,
               vd.asl_name,
               vd.DATE_MODIFIED,
               vd_conte.name,
               vd_conte.version,
               admin_component_with_id_ln_T (cd.cd_id,
                                             cd_conte.name,
                                             cd_conte.version,
                                             cd.preferred_name,
                                             cd.version,
                                             cd.long_name),
               vd.dtl_name,
               DECODE (vd.vd_type_flag,
                       'E', 'Enumerated',
                       'N', 'NonEnumerated'),
               vd.uoml_name,
               vd.forml_name,
               vd.max_length_num,
               vd.min_length_num,
               vd.decimal_place,
               vd.char_set_name,
               vd.high_value_num,
               vd.low_value_num,
               vd.origin,
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
               CAST (
                   MULTISET (
                       SELECT pv.VALUE,
                              pv.short_meaning,
                              vm.preferred_definition,
                              SBREXT.sbrext_common_routines.get_concepts (
                                  vm.condr_idseq)
                                  MeaningConcepts,
                              SBREXT.MDSR_CDEBROWSER.get_condr_origin (
                                  vm.condr_idseq)
                                  MeaningConceptOrigin,
                              SBREXT.MDSR_CDEBROWSER.get_concept_order (
                                  vm.condr_idseq)
                                  MeaningConceptDisplayOrder,
                              vp.begin_date,
                              vp.end_date,
                              vm.vm_id,
                              vm.version,
                              CAST (
                                  MULTISET (
                                      SELECT des_conte.name,
                                             des_conte.version,
                                             des.name,
                                             des.detl_name,
                                             des.lae_name
                                        FROM sbr.designations  des,
                                             sbr.contexts      des_conte
                                       WHERE     vm.vm_idseq =
                                                 des.AC_IDSEQ(+)
                                             AND des.conte_idseq =
                                                 des_conte.conte_idseq(+))
                                      AS sbrext.MDSR_749_ALTERNATENAM_LIST_T)
                                  "AlternateNameList"
                         FROM sbr.permissible_values  pv,
                              sbr.vd_pvs              vp,
                              value_meanings          vm
                        WHERE     vp.vd_idseq = vd.vd_idseq
                              AND vp.pv_idseq = pv.pv_idseq
                              AND pv.vm_idseq = vm.vm_idseq)
                       AS MDSR_749_PV_VD_LIST_T),
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
                       ORDER BY display_order DESC)
                       AS Concepts_list_t))                      "ValueDomain",
           CAST (
               MULTISET (
                   SELECT rd.name,
                          org.name,
                          rd.DCTL_NAME,
                          rd.doc_text,
                          rd.URL,
                          rd.lae_name,
                          rd.display_order
                     FROM sbr.reference_documents rd, sbr.organizations org
                    WHERE     de.de_idseq = rd.ac_idseq
                          AND rd.ORG_IDSEQ = org.ORG_IDSEQ(+))
                   AS cdebrowser_rd_list_t)                      "ReferenceDocumentsList",
           CAST (
               MULTISET (SELECT sbrext.admin_component_with_id_t (
                                    csv.cs_id,
                                    csv.cs_context_name,
                                    csv.cs_context_version,
                                    csv.preferred_name,
                                    csv.version),
                                csv.csi_name,
                                csv.csitl_name,
                                csv.csi_id,
                                csv.csi_version
                           FROM sbrext.cdebrowser_cs_view csv
                          WHERE de.de_idseq = csv.ac_idseq)
                   AS cdebrowser_csi_list_t)                     "ClassificationsList",
           CAST (
               MULTISET (
                   SELECT des_conte.name,
                          des_conte.version,
                          des.name,
                          des.detl_name,
                          des.lae_name
                     FROM sbr.designations des, sbr.contexts des_conte
                    WHERE     de.de_idseq = des.AC_IDSEQ(+)
                          AND des.conte_idseq = des_conte.conte_idseq(+))
                   AS cdebrowser_altname_list_t)                 "AlternateNameList",
           sbrext.derived_data_element_t (ccd.crtl_name,
                                          ccd.description,
                                          ccd.methods,
                                          ccd.rule,
                                          ccd.concat_char,
                                          "DataElementsList")    "DataElementDerivation"
      FROM sbr.data_elements                  de,
           sbrext.cdebrowser_de_dec_view      dec,
           sbr.contexts                       de_conte,
           sbr.value_domains                  vd,
           sbr.contexts                       vd_conte,
           sbr.contexts                       cd_conte,
           sbr.conceptual_domains             cd,
           sbr.ac_registrations               ar,
           sbrext.cdebrowser_complex_de_view  ccd,
           sbrext.representations_ext         rep,
           sbr.contexts                       rep_conte
     WHERE     de.de_idseq = dec.de_idseq
           AND de.conte_idseq = de_conte.conte_idseq
           AND de.vd_idseq = vd.vd_idseq
           AND vd.conte_idseq = vd_conte.conte_idseq
           AND vd.cd_idseq = cd.cd_idseq
           AND cd.conte_idseq = cd_conte.conte_idseq
           AND de.de_idseq = ar.ac_idseq(+)
           AND de.de_idseq = ccd.p_de_idseq(+)
           AND vd.rep_idseq = rep.rep_idseq(+)
           AND rep.conte_idseq = rep_conte.conte_idseq(+)
           AND de.ASL_NAME NOT IN ('RETIRED WITHDRAWN', 'RETIRED DELETED');
