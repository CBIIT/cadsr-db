CREATE OR REPLACE FORCE VIEW SBREXT.DE_CDE_EXCEL_GEN_VIEW_5_3 
(DE_IDSEQ, CDE_ID, LONG_NAME, PREFERRED_NAME, DOC_TEXT, PREFERRED_DEFINITION, VERSION, ORIGIN, BEGIN_DATE, 
DE_CONTE_NAME, DE_CONTE_VERSION, DEC_ID, DEC_PREFERRED_NAME, DEC_VERSION, DEC_CONTE_NAME, DEC_CONTE_VERSION, VD_ID, 
VD_PREFERRED_NAME, VD_VERSION, VD_CONTE_NAME, VD_CONTE_VERSION, VD_TYPE, DTL_NAME, MAX_LENGTH_NUM, MIN_LENGTH_NUM, 
HIGH_VALUE_NUM, LOW_VALUE_NUM, DECIMAL_PLACE, FORML_NAME, VD_LONG_NAME, CD_ID, CD_PREFERRED_NAME, CD_VERSION, CD_CONTE_NAME, 
OC_ID, OC_PREFERRED_NAME, OC_LONG_NAME, OC_VERSION, OC_CONTE_NAME, PROP_ID, PROP_PREFERRED_NAME, PROP_LONG_NAME, PROP_VERSION, 
PROP_CONTE_NAME, DEC_LONG_NAME, DE_WK_FLOW_STATUS, REGISTRATION_STATUS, VALID_VALUES, REFERENCE_DOCS, CLASSIFICATIONS, DESIGNATIONS, 
DE_DERIVATION, VD_CONCEPTS, OC_CONCEPTS, PROP_CONCEPTS, REP_ID, REP_PREFERRED_NAME, REP_LONG_NAME, REP_VERSION, REP_CONTE_NAME, 
REP_CONCEPTS, DEC_WK_FLOW_STATUS, DEC_REG_STATUS, VD_WK_FLOW_STATUS, VD_REG_STATUS) AS 
  SELECT   de.de_idseq,
            de.cde_id,
            de.long_name,
            de.preferred_name,
            rd.doc_text,
            de.preferred_definition,
            de.version,
            de.origin,
            de.begin_date,
            de_conte.name de_conte_name,
            de_conte.version de_conte_version,
            dec.dec_id,
            dec.preferred_name dec_preferred_name,
            dec.version dec_version,
            dec_conte.name dec_conte_name,
            dec_conte.version dec_conte_version,
            vd.vd_id,
            vd.preferred_name vd_preferred_name,
            vd.version vd_version,
            vd_conte.name vd_conte_name,
            vd_conte.version vd_conte_version,
            DECODE (vd.vd_type_flag,
                    'E', 'Enumerated',
                    'N', 'Non Enumerated',
                    'Unknown')
               vd_type,
            vd.dtl_name,
            vd.max_length_num,
            vd.min_length_num,
            vd.high_value_num,
            vd.low_value_num,
            vd.DECIMAL_PLACE,
            vd.FORML_NAME,
            vd.LONG_NAME vd_long_name,
            cd.cd_id,
            cd.preferred_name cd_preferred_name,
            cd.version cd_version,
            cd_conte.name cd_conte_name,
            oc.oc_id,
            oc.preferred_name oc_preferred_name,
            oc.long_name oc_long_name,
            oc.version oc_version,
            oc_conte.name oc_conte_name,
            prop.prop_id,
            prop.preferred_name prop_preferred_name,
            prop.long_name prop_long_name,
            prop.version prop_version,
            prop_conte.name prop_conte_name,
            dec.LONG_NAME dec_long_name,
            de.ASL_NAME de_wk_flow_status,
            acr.registration_status,
            CAST (
               MULTISET(SELECT   pv.VALUE,
                                 vm.long_name short_meaning,
                                 vm.preferred_definition,
                                 sbrext_common_routines.get_concepts (
                                    vm.condr_idseq
                                 )
                                    MeaningConcepts,
                                 vp.begin_date,
                                 vp.end_date,
                                 vm.vm_id,
                                 vm.version
                          FROM   sbr.permissible_values pv,
                                 sbr.vd_pvs vp,
                                 value_meanings vm
                         WHERE       vp.vd_idseq = vd.vd_idseq
                                 AND vp.pv_idseq = pv.pv_idseq
                                 AND pv.vm_idseq = vm.vm_idseq
                      ) AS DE_VALID_VALUE_LIST_T
            )
               valid_values,
            CAST (
               MULTISET(SELECT   rd.name,
                                 org.name,
                                 rd.DCTL_NAME,
                                 rd.doc_text,
                                 rd.URL,
                                 rd.lae_name,
                                 rd.display_order
                          FROM   sbr.reference_documents rd,
                                 sbr.organizations org
                         WHERE   de.de_idseq = rd.ac_idseq(+)
                                 AND rd.ORG_IDSEQ = org.ORG_IDSEQ(+)) AS cdebrowser_rd_list_t
            )
               reference_docs,
            CAST (
               MULTISET (
                  SELECT   admin_component_with_id_t (csv.cs_id,
                                                      csv.cs_context_name,
                                                      csv.cs_context_version,
                                                      csv.preferred_name,
                                                      csv.version),
                           csv.csi_name,
                           csv.csitl_name,
                           csv.csi_id,
                           csv.csi_version
                    FROM   sbrext.cdebrowser_cs_view csv
                   WHERE   de.de_idseq = csv.ac_idseq
               ) AS cdebrowser_csi_list_t
            )
               classifications,
            CAST (
               MULTISET(SELECT   des_conte.NAME,
                                 des_conte.VERSION,
                                 des.NAME,
                                 des.DETL_NAME,
                                 des.LAE_NAME
                          FROM   sbr.designations des, sbr.contexts des_conte
                         WHERE   de.de_idseq = des.AC_IDSEQ(+)
                                 AND des.conte_idseq =
                                       des_conte.conte_idseq(+)) AS DESIGNATIONS_LIST_T
            )
               designations,
            derived_data_element_t (ccd.crtl_name,
                                    ccd.description,
                                    ccd.methods,
                                    ccd.rule,
                                    ccd.concat_char,
                                    "DataElementsList")
               DE_DERIVATION,
            CAST (
               MULTISET(  SELECT   con.preferred_name,
                                   con.long_name,
                                   con.con_id,
                                   con.definition_source,
                                   con.origin,
                                   con.evs_Source,
                                   com.primary_flag_ind,
                                   com.display_order
                            FROM   component_concepts_ext com, concepts_ext con
                           WHERE   vd.condr_idseq = com.condr_IDSEQ(+)
                                   AND com.con_idseq = con.con_idseq(+)
                        ORDER BY   display_order DESC) AS Concepts_list_t
            )
               vd_concepts,
            CAST (
               MULTISET(  SELECT   con.preferred_name,
                                   con.long_name,
                                   con.con_id,
                                   con.definition_source,
                                   con.origin,
                                   con.evs_Source,
                                   com.primary_flag_ind,
                                   com.display_order
                            FROM   component_concepts_ext com, concepts_ext con
                           WHERE   oc.condr_idseq = com.condr_IDSEQ(+)
                                   AND com.con_idseq = con.con_idseq(+)
                        ORDER BY   display_order DESC) AS Concepts_list_t
            )
               oc_concepts,
            CAST (
               MULTISET(  SELECT   con.preferred_name,
                                   con.long_name,
                                   con.con_id,
                                   con.definition_source,
                                   con.origin,
                                   con.evs_Source,
                                   com.primary_flag_ind,
                                   com.display_order
                            FROM   component_concepts_ext com, concepts_ext con
                           WHERE   prop.condr_idseq = com.condr_IDSEQ(+)
                                   AND com.con_idseq = con.con_idseq(+)
                        ORDER BY   display_order DESC) AS Concepts_list_t
            )
               prop_concepts,
            rep.rep_id,
            rep.preferred_name rep_preferred_name,
            rep.long_name rep_long_name,
            rep.version rep_version,
            rep_conte.name rep_conte_name,
            CAST (
               MULTISET(  SELECT   con.preferred_name,
                                   con.long_name,
                                   con.con_id,
                                   con.definition_source,
                                   con.origin,
                                   con.evs_Source,
                                   com.primary_flag_ind,
                                   com.display_order
                            FROM   component_concepts_ext com, concepts_ext con
                           WHERE   rep.condr_idseq = com.condr_IDSEQ(+)
                                   AND com.con_idseq = con.con_idseq(+)
                        ORDER BY   display_order DESC) AS Concepts_list_t
            )
               rep_concepts,
            dec.ASL_NAME DEC_WK_FLOW_STATUS, 
            acr_dec.registration_status DEC_REG_STATUS,     
            vd.ASL_NAME VD_WK_FLOW_STATUS, 
            acr_vd.registration_status VD_REG_STATUS 
     FROM   sbr.data_elements de,
            sbr.data_element_concepts dec,
            sbr.contexts de_conte,
            sbr.value_domains vd,
            sbr.contexts vd_conte,
            sbr.contexts dec_conte,
            sbr.ac_registrations acr,
            sbr.ac_registrations acr_dec,
            sbr.ac_registrations acr_vd,
            cdebrowser_complex_de_view ccd,
            conceptual_domains cd,
            contexts cd_conte,
            object_classes_Ext oc,
            contexts oc_conte,
            properties_ext prop,
            representations_ext rep,
            contexts prop_conte,
            contexts rep_conte,
            (SELECT   ac_idseq, doc_text
               FROM   reference_documents
              WHERE   dctl_name = 'Preferred Question Text') rd
    WHERE       de.dec_idseq = dec.dec_idseq
            AND dec.dec_idseq = acr_dec.ac_idseq(+)
            AND de.conte_idseq = de_conte.conte_idseq
            AND de.vd_idseq = vd.vd_idseq
            AND vd.vd_idseq = acr_vd.ac_idseq(+)
            AND vd.conte_idseq = vd_conte.conte_idseq
            AND dec.conte_idseq = dec_conte.conte_idseq
            AND de.de_idseq = rd.ac_idseq(+)
            AND de.de_idseq = acr.ac_idseq(+)
            AND de.de_idseq = ccd.p_de_idseq(+)
            AND vd.cd_idseq = cd.cd_idseq
            AND cd.conte_idseq = cd_conte.conte_idseq
            AND dec.oc_idseq = oc.oc_idseq(+)
            AND oc.conte_idseq = oc_conte.conte_idseq(+)
            AND dec.prop_idseq = prop.prop_idseq(+)
            AND prop.conte_idseq = prop_conte.conte_idseq(+)
            AND vd.rep_idseq = rep.rep_idseq(+)
            AND rep.conte_idseq = rep_conte.conte_idseq(+)
/
GRANT SELECT ON SBREXT.DE_CDE_EXCEL_GEN_VIEW_5_3 TO CDEBROWSER;
GRANT SELECT ON SBREXT.DE_CDE_EXCEL_GEN_VIEW_5_3 TO READONLY;
GRANT DELETE, INSERT, SELECT, UPDATE ON SBREXT.DE_CDE_EXCEL_GEN_VIEW_5_3 TO DER_USER;
CREATE OR REPLACE PUBLIC SYNONYM DE_CDE_EXCEL_GEN_VIEW_5_3 FOR SBREXT.DE_CDE_EXCEL_GEN_VIEW_5_3;