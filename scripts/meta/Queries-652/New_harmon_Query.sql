 SELECT de.cde_id DE_PublicId,de.version DE_Version,         
          de.long_name, de_conte.name de_Context , 
          de.preferred_name,
          DE.QUESTION  Preferred_question_text,
          de.preferred_definition DE_definition,          
          de.origin DE_Origin,          
          DE.CHANGE_NOTE DE_CHANGE_NOTE,
          DE.ASL_NAME DE_WORKFLOW_STATUS,
          DE.REGISTRATION_STATUS DE_REGISTRATION_STATUS,
          de.Created_by DE_Created_by, de.date_created DE_Date_Created,de.modified_by DE_Modified_by, de.DATE_MODIFIED DE_DATE_MODIFIED,
          CAST (
             MULTISET (
                SELECT  F.QC_ID ,f.VERSION ,F.LONG_NAME ,
c.NAME 
from SBREXT.QUEST_CONTENTS_EXT  Q, 
SBR.CONTEXTS C, 
SBREXT.QUEST_CONTENTS_EXT  F
where Q.DN_CRF_IDSEQ=F.QC_IDSEQ
AND F.CONTE_IDSEQ=C.CONTE_IDSEQ
and F.QTL_NAME='CRF'
and Q.QTL_NAME='QUESTION' 
and Q.DE_IDSEQ = de.de_idseq ) AS FORM_CDE_LIST_T) FORM_CDE_LIST_T,
          dec.dec_id DEC_PublicId,
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
             MULTISET (
                SELECT pv.VALUE,
                       vm.long_name short_meaning,
                       vm.preferred_definition,
                       sbrext_common_routines.get_concepts (vm.condr_idseq)
                          MeaningConcepts,
                       pv.begin_date,
                       pv.end_date,
                       vm.vm_id,
                       vm.version,
                       defs.definition                               --GF32647
                  FROM sbr.permissible_values pv,
                       sbr.vd_pvs vp,
                       value_meanings vm,
                       sbr.definitions_view defs                     --GF32647
                 WHERE     vp.vd_idseq = vd.vd_idseq
                       AND vp.pv_idseq = pv.pv_idseq
                       AND pv.vm_idseq = vm.vm_idseq
                       AND vm.vm_idseq = defs.ac_idseq(+)     --GF32647 JR1047
                                                         ) AS valid_value_list_t)
             valid_values,
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
                 WHERE     de.de_idseq = rd.ac_idseq(+)
                       AND rd.ORG_IDSEQ = org.ORG_IDSEQ(+)) AS cdebrowser_rd_list_t)
             reference_docs,
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
                 WHERE de.de_idseq = csv.ac_idseq) AS cdebrowser_csi_list_t)
             classifications,
          CAST (
             MULTISET (
                SELECT des_conte.NAME,
                       des_conte.VERSION,
                       des.NAME,
                       des.DETL_NAME,
                       des.LAE_NAME
                  FROM sbr.designations des, sbr.contexts des_conte
                 WHERE     de.de_idseq = des.AC_IDSEQ(+)
                       AND des.conte_idseq = des_conte.conte_idseq(+)) AS DESIGNATIONS_LIST_T)
             designations,
          derived_data_element_t (ccd.crtl_name,
                                  ccd.description,
                                  ccd.methods,
                                  ccd.rule,
                                  ccd.concat_char,
                                  "DataElementsList")
             DE_DERIVATION,
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
                         AND UPPER (REPLACE (CON.LONG_NAME, ' ')) =
                                UPPER (REPLACE ('Time Point', ' '))
                         AND com.con_idseq = con.con_idseq(+)
                ORDER BY display_order DESC) AS Concepts_list_t)
             vd_concepts,
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
                   WHERE     oc.condr_idseq = com.condr_IDSEQ(+)
                         AND UPPER (REPLACE (CON.LONG_NAME, ' ')) =
                                UPPER (REPLACE ('Time Point', ' '))
                         AND com.con_idseq = con.con_idseq(+)
                ORDER BY display_order DESC) AS Concepts_list_t)
             oc_concepts,
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
                   WHERE     prop.condr_idseq = com.condr_IDSEQ(+)
                         AND UPPER (REPLACE (CON.LONG_NAME, ' ')) =
                                UPPER (REPLACE ('Time Point', ' '))
                         AND com.con_idseq = con.con_idseq(+)
                ORDER BY display_order DESC) AS Concepts_list_t)
             prop_concepts,
                           
          rep.rep_id,
          rep.preferred_name rep_preferred_name,
          rep.long_name rep_long_name,
          rep.version rep_version,
          rep_conte.name rep_conte_name,
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
                   WHERE     rep.condr_idseq = com.condr_IDSEQ(+)
                         AND UPPER (REPLACE (CON.LONG_NAME, ' ')) =
                                UPPER (REPLACE ('Time Point', ' '))
                         AND com.con_idseq = con.con_idseq(+)
                ORDER BY display_order DESC) AS Concepts_list_t)
             rep_concepts
     FROM SBREXT.CABIO31_DATA_ELEMENTS_VIEW de,
          sbr.data_element_concepts dec,
          sbr.contexts de_conte,
          sbr.value_domains vd,
          sbr.contexts vd_conte,
          sbr.contexts dec_conte,
          sbr.ac_registrations acr,
          cdebrowser_complex_de_view ccd,
          conceptual_domains cd,
          contexts cd_conte,
          object_classes_Ext oc,
          contexts oc_conte,
          properties_ext prop,
          representations_ext rep,
          contexts prop_conte,
          contexts rep_conte,
          (
 select DE.LONG_NAME DE_LONG_NAME,DE.QUESTION,DE.REGISTRATION_STATUS,DE.CDE_ID ,DE.VERSION DE_VERSION,
 DE.PREFERRED_NAME DE_PREFERRED_NAME,DE.PREFERRED_DEFINITION DEFINITION,DE.ASL_NAME WORKFLOW_STATUS,DE.ORIGIN,DE.CHANGE_NOTE,
 DE.DATE_CREATED,DE.CREATED_BY,DE.DATE_MODIFIED,DE.MODIFIED_BY,DE.DEC_IDSEQ,DE.DE_IDSEQ,DE.CONTE_IDSEQ
 from SBREXT.CABIO31_DATA_ELEMENTS_VIEW DE,
 SBR.VD_PVS PVS, SBR.PERMISSIBLE_VALUES PV,
 SBR.VALUE_MEANINGS VM ,
 SBREXT.CON_DERIVATION_RULES_EXT DR,
 SBREXT.CONCEPTS_EXT C
 where DE.VD_IDSEQ=PVS.VD_IDSEQ
 AND PVS.PV_IDSEQ=PV.PV_IDSEQ
 AND VM.VM_IDSEQ=PV.VM_IDSEQ
 AND VM.CONDR_IDSEQ= DR.CONDR_IDSEQ
 AND INSTR(DR.NAME,C.PREFERRED_NAME)>0
 AND UPPER(replace(C.LONG_NAME,' '))= UPPER(replace('Time Point',' '))
 AND DE.ASL_NAME not like '%RETIRED%'
 UNION
 select DE.LONG_NAME DE_LONG_NAME,DE.QUESTION,DE.REGISTRATION_STATUS,DE.CDE_ID ,DE.VERSION DE_VERSION,
 DE.PREFERRED_NAME DE_PREFERRED_NAME,DE.PREFERRED_DEFINITION DEFINITION,DE.ASL_NAME WORKFLOW_STATUS,DE.ORIGIN,DE.CHANGE_NOTE,
 DE.DATE_CREATED,DE.CREATED_BY,DE.DATE_MODIFIED,DE.MODIFIED_BY,DE.DEC_IDSEQ,DE.DE_IDSEQ,DE.CONTE_IDSEQ
 from SBREXT.CABIO31_DATA_ELEMENTS_VIEW DE,
 SBREXT.CABIO31_DE_CONCEPTS_VIEW DEC,
 SBREXT.OBJECT_CLASSES_EXT OC ,
 SBREXT.CON_DERIVATION_RULES_EXT DR,
 SBREXT.CONCEPTS_EXT C
 where DE.DEC_IDSEQ=DEC.DEC_IDSEQ 
 AND OC.OC_IDSEQ=DEC.OC_IDSEQ
 AND OC.CONDR_IDSEQ= DR.CONDR_IDSEQ
 AND INSTR(DR.NAME,C.PREFERRED_NAME)>0--DR.NAME=C.PREFERRED_NAME
 AND UPPER(replace(C.LONG_NAME,' '))= UPPER(replace('Time Point',' '))
 AND DE.ASL_NAME not like '%RETIRED%'

UNION
 select DE.LONG_NAME DE_LONG_NAME,DE.QUESTION,DE.REGISTRATION_STATUS,DE.CDE_ID ,DE.VERSION DE_VERSION,
 DE.PREFERRED_NAME DE_PREFERRED_NAME,DE.PREFERRED_DEFINITION DEFINITION,DE.ASL_NAME WORKFLOW_STATUS,DE.ORIGIN,DE.CHANGE_NOTE,
 DE.DATE_CREATED,DE.CREATED_BY,DE.DATE_MODIFIED,DE.MODIFIED_BY,DE.DEC_IDSEQ,DE.DE_IDSEQ,DE.CONTE_IDSEQ
 from SBREXT.CABIO31_DATA_ELEMENTS_VIEW DE,
 SBREXT.CABIO31_DE_CONCEPTS_VIEW DEC,
 SBREXT.PROPERTIES_EXT P ,
 SBREXT.CON_DERIVATION_RULES_EXT DR,
 SBREXT.CONCEPTS_EXT C

where DE.DEC_IDSEQ=DEC.DEC_IDSEQ 
 AND P.PROP_IDSEQ=DEC.PROP_IDSEQ
 AND P.CONDR_IDSEQ= DR.CONDR_IDSEQ
 AND INSTR(DR.NAME,C.PREFERRED_NAME)>0--DR.NAME=C.PREFERRED_NAME
 AND UPPER(replace(C.LONG_NAME,' '))= UPPER(replace('Time Point',' '))
 AND DE.ASL_NAME not like '%RETIRED%'

UNION
 select DE.LONG_NAME DE_LONG_NAME,DE.QUESTION,DE.REGISTRATION_STATUS,DE.CDE_ID ,DE.VERSION DE_VERSION,
 DE.PREFERRED_NAME DE_PREFERRED_NAME,DE.PREFERRED_DEFINITION DEFINITION,DE.ASL_NAME WORKFLOW_STATUS,DE.ORIGIN,DE.CHANGE_NOTE,
 DE.DATE_CREATED,DE.CREATED_BY,DE.DATE_MODIFIED,DE.MODIFIED_BY,DE.DEC_IDSEQ,DE.DE_IDSEQ,DE.CONTE_IDSEQ
 from SBREXT.CABIO31_DATA_ELEMENTS_VIEW DE,
 SBR.VALUE_DOMAINS VD ,
 SBREXT.CON_DERIVATION_RULES_EXT DR,
 SBREXT.CONCEPTS_EXT C
 where VD.VD_IDSEQ=DE.VD_IDSEQ
 AND VD.CONDR_IDSEQ= DR.CONDR_IDSEQ
 AND UPPER(replace(C.LONG_NAME,' '))= UPPER(replace('Time Point',' '))
 AND INSTR(DR.NAME,C.PREFERRED_NAME)>0
 AND DE.ASL_NAME not like '%RETIRED%')DDE
    WHERE     de.dec_idseq = dec.dec_idseq
          AND de.conte_idseq = de_conte.conte_idseq
          AND de.vd_idseq = vd.vd_idseq
          AND vd.conte_idseq = vd_conte.conte_idseq
          AND dec.conte_idseq = dec_conte.conte_idseq
          --  AND de.de_idseq = rd.ac_idseq(+)
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
          AND DE.ASL_NAME NOT LIKE '%RETIRED%'
        AND upper(DE.LONG_NAME)  LIKE 'BLOOD TR%'
          and de.de_idseq = dde.de_idseq;