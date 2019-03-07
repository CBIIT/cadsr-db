set serveroutput on size 1000000
SPOOL cadsrmeta-749c.log

CREATE OR REPLACE FORCE VIEW SBREXT.MDSR_DENew_XML_749_VW
(
    GROUP_NUMBER,
    "DataElementList"
)
AS
    SELECT a.GROUP_NUMBER ,
           CAST (
               MULTISET (
                     SELECT de.de_idseq,
           de.CDE_ID
               ,
           de.long_name
               ,
           de.preferred_name
               ,
           de.preferred_definition
               ,
           de.version
               ,
           de.ASL_NAME
               ,
           de_conte.name
               ,
           de_conte.version
               ,
           de.origin
               ,
           ar.registration_status
               ,
           cdebrowser_dec_t (
               dec.dec_id,
               dec.dec_preferred_name,
               dec.PREFERRED_DEFINITION,
               dec.dec_long_name,
               dec.dec_version,
               dec.ASL_NAME,
               dec.dec_context_name,
               dec.dec_context_version,
               admin_component_with_id_ln_t (dec.cd_id,
                                             dec.cd_context_name,
                                             dec.cd_context_version,
                                             dec.cd_preferred_name,
                                             dec.cd_version,
                                             dec.cd_long_name),
               admin_component_with_con_t (
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
                               FROM component_concepts_ext com,
                                    concepts_ext          con
                              WHERE     dec.oc_condr_idseq = com.condr_IDSEQ(+)
                                    AND com.con_idseq = con.con_idseq(+)
                           ORDER BY display_order DESC) AS Concepts_list_t)),
               admin_component_with_con_t (
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
                               FROM component_concepts_ext com,
                                    concepts_ext          con
                              WHERE     dec.prop_condr_idseq =
                                        com.condr_IDSEQ(+)
                                    AND com.con_idseq = con.con_idseq(+)
                           ORDER BY display_order DESC) AS Concepts_list_t)),
               dec.obj_class_qualifier,
               dec.property_qualifier,
               dec.dec_origin)
               ,
           cdebrowser_vd_t2 (
               vd.vd_id,
               vd.preferred_name,
               vd.preferred_definition,
               vd.long_name,
               vd.version,
               vd.asl_name,
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
               admin_component_with_con_t (
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
                           ORDER BY display_order DESC) AS Concepts_list_t)),
               CAST (
                   MULTISET (
                       SELECT pv.VALUE,
                              pv.short_meaning,
                              vm.preferred_definition,
                              sbrext_common_routines.get_concepts (
                                  vm.condr_idseq)    MeaningConcepts,
                              pv.begin_date,
                              pv.end_date,
                              vm.vm_id,
                              vm.version
                         FROM sbr.permissible_values  pv,
                              sbr.vd_pvs              vp,
                              value_meanings          vm
                        WHERE     vp.vd_idseq = vd.vd_idseq
                              AND vp.pv_idseq = pv.pv_idseq
                              AND pv.vm_idseq = vm.vm_idseq)
                       AS DE_VALID_VALUE_LIST_T),
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
                       ORDER BY display_order DESC) AS Concepts_list_t))
               ,
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
                   AS cdebrowser_rd_list_t)
               ,
           CAST (
               MULTISET (
                   SELECT admin_component_with_id_t (csv.cs_id,
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
                   AS cdebrowser_csi_list_t)
               ,
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
                   AS cdebrowser_altname_list_t)
               /*,
            derived_data_element_t (ccd.crtl_name,
                                    ccd.description,
                                    ccd.methods,
                                    ccd.rule,
                                    ccd.concat_char,
                                    "DataElementsList")
               "DataElementDerivation"*/
      FROM sbr.data_elements              de,
           sbrext.cdebrowser_de_dec_view  dec,
           sbr.contexts                   de_conte,
           sbr.value_domains              vd,
           sbr.contexts                   vd_conte,
           sbr.contexts                   cd_conte,
           sbr.conceptual_domains         cd,
           sbr.ac_registrations           ar,
           cdebrowser_complex_de_view     ccd,
           sbrext.representations_ext     rep,
           sbr.contexts                   rep_conte,
           sbrext.MDSR_CONTEXT_GROUP_749_VW de_gr
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
           AND de.ASL_NAME NOT IN ('%RETIRED WITHDRAWN%','RETIRED DELETED')
           AND de.de_idseq = de_gr.de_idseq
           and de.CDE_ID=3147627
         --  AND de.de_idseq = a.de_idseq
          -- AND de.dec_idseq = dec.dec_idseq(+)
                            AND de_gr.GROUP_NUMBER = a.GROUP_NUMBER 
                   ORDER BY de_gr.GROUP_NUMBER, de_conte.name,de.cde_id, de.version)
                   AS SBREXT.MDSR_DENEW_749_LIST_T )   "DataElementList"
      FROM (  SELECT DISTINCT GROUP_NUMBER--,DE_IDSEQ
                FROM sbrext.MDSR_CONTEXT_GROUP_749_VW c   
                where de_idseq='91F4555F-4E88-05CE-E040-BB89AD43554F'--GROUP_NUMBER =15--DE_IDSEQ ='C805F27F-D5F7-4CDB-E034-0003BA12F5E7'         
            ORDER BY GROUP_NUMBER) a
/
SPOOL OFF



