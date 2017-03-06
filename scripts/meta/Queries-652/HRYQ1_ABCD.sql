
  
  SELECT --dde.CONCEPT_NAME CONCEPT_NAME,dde.CONCEPT_CODE,dde.CONCEPT_PUBLIC_ID,
          de.cde_id DE_PublicId,de.version DE_VERSION,         
          de.long_name DE_long_name, de_conte.name DE_Context , 
          de.preferred_name DE_PREFER_NAME,
          DE.QUESTION  Preferred_question_text,
          de.preferred_definition DE_DEFINITION,          
          de.origin DE_ORIGIN,          
          DE.CHANGE_NOTE DE_CHANGE_NOTE,
          DE.ASL_NAME DE_WORKFLOW_STATUS,
          DE_AR.REGISTRATION_STATUS DE_REGISTRATION_STATUS,
          de.Created_by DE_Created_by, de.date_created DE_Date_Created,de.modified_by DE_Modified_by, de.DATE_MODIFIED DE_DATE_MODIFIED,
          --
          dec.dec_id DEC_PublicId,dec.version DEC_VERSION,         
          dec.long_name DEC_long_name, dec_conte.name DEC_Context , 
          dec.preferred_name DEC_PREFER_NAME,          
          dec.preferred_definition DEC_DEFINITION,          
          dec.origin DEC_ORIGIN,          
          DEC.CHANGE_NOTE DEC_CHANGE_NOTE,
          DEC.ASL_NAME DEC_WORKFLOW_STATUS,
          DEC_AR.REGISTRATION_STATUS DEC_REGISTRATION_STATUS,
          DEC.Created_by DEC_Created_by, DEC.date_created DEC_Date_Created,DEC.modified_by DEC_Modified_by, DEC.DATE_MODIFIED DEC_DATE_MODIFIED,
          oc.oc_id,
          oc.preferred_name oc_preferred_name,
          oc.long_name oc_long_name,
          oc.version oc_version,
          oc_conte.name oc_conte_name,
          oc.ASL_NAME OC_WORKFLOW_STATUS,
           ar_oc.REGISTRATION_STATUS OC_REGISTRATION_STATUS,
          prop.prop_id,
          prop.preferred_name prop_preferred_name,
          prop.long_name prop_long_name,
          prop.version prop_version,
          prop_conte.name prop_conte_name,
          prop.ASL_NAME PROP_WORKFLOW_STATUS,
          ar_prop.REGISTRATION_STATUS PROP_REGISTRATION_STATUS,
          VD.VD_id VD_PublicId,VD.version VD_VERSION,         
          VD.long_name VD_long_name, VD_conte.name VD_Context , 
          VD.preferred_name VD_PREFER_NAME,          
          VD.preferred_definition VD_DEFINITION,          
          VD.origin VD_ORIGIN,          
          VD.CHANGE_NOTE VD_CHANGE_NOTE,
          VD.ASL_NAME VD_WORKFLOW_STATUS,
          ar.REGISTRATION_STATUS VD_REGISTRATION_STATUS,
          vd.dtl_name,
          vd.max_length_num,
          vd.min_length_num,
          vd.high_value_num,
          vd.low_value_num,
          vd.DECIMAL_PLACE,
          vd.FORML_NAME,          
          VD.Created_by VD_Created_by, VD.date_created VD_Date_Created,VD.modified_by VD_Modified_by, VD.DATE_MODIFIED VD_DATE_MODIFIED,
          CAST (
             MULTISET (
                select distinct F.QC_ID ,F.version ,F.LONG_NAME ,CF_CONTE.NAME,M.LONG_NAME, F.QTL_NAME,p.LONG_NAME ,F.ASL_NAME 
                  FROM  SBREXT.QUEST_CONTENTS_EXT  Q,          
                  SBREXT.QUEST_CONTENTS_EXT  F,
                  SBR.CONTEXTS CF_conte,
                  SBREXT.QUEST_CONTENTS_EXT  M,
                  SBREXT.PROTOCOLS_EXT P,
                  SBREXT.PROTOCOL_QC_EXT PQ
                  where Q.DN_CRF_IDSEQ=F.QC_IDSEQ    
                  AND M.DN_CRF_IDSEQ=F.QC_IDSEQ            
                  AND Q.P_MOD_IDSEQ=M.QC_IDSEQ          
                  AND F.CONTE_IDSEQ=CF_conte.CONTE_IDSEQ  
                  and F.QC_IDSEQ=PQ.QC_IDSEQ (+)  
                  and PQ.PROTO_IDSEQ=P.PROTO_IDSEQ (+) 
                  and F.QTL_NAME IN ('CRF','TEMPLATE')
                  and Q.QTL_NAME='QUESTION' 
                  and M.QTL_NAME='MODULE'
                  AND F.ASL_NAME not like '%RETIRED%' 
                  and Q.DE_IDSEQ(+) = de.de_idseq ) AS SBREXT.HARMONY_FORM_PROTO_LIST_T) FORMS  ,
    DECODE (vd.vd_type_flag, 'E', 'Enumerated', 'N', 'Non Enumerated',  'Unknown')    vd_type,
                   
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
                 WHERE de.de_idseq = csv.ac_idseq) AS SBREXT.cdebrowser_csi_list_t)
             classifications,
          CAST (
             MULTISET (
                SELECT des_conte.NAME,
                       des_conte.VERSION,
                       des.NAME ,
                       des.DETL_NAME
                  FROM sbr.designations des, sbr.contexts des_conte
                 WHERE     de.de_idseq = des.AC_IDSEQ(+)
                       AND des.conte_idseq = des_conte.conte_idseq(+)) AS SBREXT.HARMONY_DESIGN_LIST_T)
             ALT_NAME_DESIGNATION  ,
              CAST (
             MULTISET (
                SELECT def_conte.NAME,
                       def_conte.VERSION,
                       def.DEFINITION ,
                       def.DEFL_NAME
                  FROM sbr.DEFINITIONS def, sbr.contexts def_conte
                 WHERE     de.de_idseq = def.AC_IDSEQ(+)
                       AND def.conte_idseq = def_conte.conte_idseq(+)) AS SBREXT.HARMONY_DEF_LIST_T)
             Alt_Definition ,
               CAST (
             MULTISET (
                SELECT rd_conte.NAME,
                       rd_conte.VERSION,
                       rd.DOC_TEXT ,
                       rd.RDTL_NAME
                  FROM sbr.reference_documents rd, sbr.contexts rd_conte
                 WHERE     de.de_idseq = rd.AC_IDSEQ(+)
                       AND rd.conte_idseq = rd_conte.conte_idseq(+)) AS SBREXT.HARMONY_DOC_REF_LIST_T)
                     
          ALT_QUESTION,
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
                         AND com.con_idseq = con.con_idseq(+)
                ORDER BY display_order DESC) AS Concepts_list_t)
             rep_concepts
   
     FROM SBR.DATA_ELEMENTS DE,
          SBR.DATA_ELEMENT_CONCEPTS DEC,
          sbr.contexts de_conte,
          sbr.contexts dec_conte, 
          sbr.VALUE_DOMAINS vd,
          SBR.AC_REGISTRATIONS_VIEW de_ar,
          SBR.AC_REGISTRATIONS_VIEW dec_ar,
          SBR.AC_REGISTRATIONS_VIEW ar,
         SBR.AC_REGISTRATIONS_VIEW ar_oc,
         SBR.AC_REGISTRATIONS_VIEW ar_prop,
         SBREXT.cdebrowser_complex_de_view ccd,
         SBR.contexts VD_conte,    
         SBREXT.object_classes_Ext oc,
         SBR.contexts oc_conte,
         SBREXT.properties_ext prop,        
         SBREXT.representations_ext rep,
         SBR.contexts prop_conte,
         SBR.contexts rep_conte,
          ( 
 select  DE.DE_IDSEQ,CON_ID CONCEPT_PUBLIC_ID,C.PREFERRED_NAME CONCEPT_CODE,C.LONG_NAME CONCEPT_NAME
 from SBR.DATA_ELEMENTS DE,
 SBR.VD_PVS PVS, SBR.PERMISSIBLE_VALUES PV,
 SBR.VALUE_MEANINGS VM ,
 SBREXT.CON_DERIVATION_RULES_EXT DR,
 SBREXT.CONCEPTS_EXT C
 where DE.VD_IDSEQ=PVS.VD_IDSEQ
 AND PVS.PV_IDSEQ=PV.PV_IDSEQ
 AND VM.VM_IDSEQ=PV.VM_IDSEQ
 AND VM.CONDR_IDSEQ= DR.CONDR_IDSEQ
 AND INSTR(DR.NAME,C.PREFERRED_NAME)>0
 --AND UPPER(replace(C.LONG_NAME,' '))= UPPER(replace('Time Point',' '))
 AND DE.ASL_NAME not like '%RETIRED%'
 UNION
 select DE.DE_IDSEQ,CON_ID,C.PREFERRED_NAME,C.LONG_NAME
 from SBR.DATA_ELEMENTS DE,
 SBR.DATA_ELEMENT_CONCEPTS DEC,
 SBREXT.OBJECT_CLASSES_EXT OC ,
 SBREXT.CON_DERIVATION_RULES_EXT DR,
 SBREXT.CONCEPTS_EXT C
 where DE.DEC_IDSEQ=DEC.DEC_IDSEQ 
 AND OC.OC_IDSEQ=DEC.OC_IDSEQ
 AND OC.CONDR_IDSEQ= DR.CONDR_IDSEQ
 AND INSTR(DR.NAME,C.PREFERRED_NAME)>0--DR.NAME=C.PREFERRED_NAME
 --AND UPPER(replace(C.LONG_NAME,' '))= UPPER(replace('Time Point',' '))
 AND DE.ASL_NAME not like '%RETIRED%'

UNION
 select DE.DE_IDSEQ,CON_ID,C.PREFERRED_NAME,C.LONG_NAME
 from SBR.DATA_ELEMENTS DE,
 SBR.DATA_ELEMENT_CONCEPTS DEC,
 SBREXT.PROPERTIES_EXT P ,
 SBREXT.CON_DERIVATION_RULES_EXT DR,
 SBREXT.CONCEPTS_EXT C

where DE.DEC_IDSEQ=DEC.DEC_IDSEQ 
 AND P.PROP_IDSEQ=DEC.PROP_IDSEQ
 AND P.CONDR_IDSEQ= DR.CONDR_IDSEQ
 AND INSTR(DR.NAME,C.PREFERRED_NAME)>0--DR.NAME=C.PREFERRED_NAME
-- AND UPPER(replace(C.LONG_NAME,' '))= UPPER(replace('Time Point',' '))
 AND DE.ASL_NAME not like '%RETIRED%'

UNION
  select DE.DE_IDSEQ,CON_ID,C.PREFERRED_NAME,C.LONG_NAME
 from SBR.DATA_ELEMENTS DE,
 SBR.VALUE_DOMAINS VD ,
 SBREXT.CON_DERIVATION_RULES_EXT DR,
 SBREXT.CONCEPTS_EXT C
 where VD.VD_IDSEQ=DE.VD_IDSEQ
 AND VD.CONDR_IDSEQ= DR.CONDR_IDSEQ
-- AND UPPER(replace(C.LONG_NAME,' '))= UPPER(replace('Time Point',' '))
 AND INSTR(DR.NAME,C.PREFERRED_NAME)>0
 AND DE.ASL_NAME not like '%RETIRED%')DDE
        WHERE   de.dec_idseq = dec.dec_idseq
        AND de.de_IDSEQ = de_ar.AC_IDSEQ(+) 
        AND dec.dec_IDSEQ = dec_ar.AC_IDSEQ(+) 
        AND de.VD_IDSEQ = VD.VD_IDSEQ 
        AND vd.VD_IDSEQ = ar.AC_IDSEQ(+)
        AND vd.rep_idseq = rep.rep_idseq(+)
        AND de.conte_idseq = de_conte.conte_idseq
        AND dec.conte_idseq = dec_conte.conte_idseq
        AND VD.conte_idseq = VD_conte.conte_idseq
        AND de.de_idseq = ccd.p_de_idseq(+)  
        AND dec.oc_idseq = oc.oc_idseq(+)
        AND oc.conte_idseq = oc_conte.conte_idseq(+)
        AND dec.prop_idseq = prop.prop_idseq(+)
        AND oc.oc_idseq = ar_oc.AC_IDSEQ(+)
        AND prop.prop_idseq=ar_prop.AC_IDSEQ(+)
        AND prop.conte_idseq = prop_conte.conte_idseq(+)
        AND rep.conte_idseq = rep_conte.conte_idseq(+)      
        AND DE.ASL_NAME NOT LIKE '%RETIRED%'
         and de.de_idseq = dde.de_idseq
   /*replace below values for CONCEPT_NAME,CONCEPT_PUBLIC_ID or CONCEPT_CODE
   Currently query is case insensitive (Time Point, time point, Time point, Timepoint, timepoint)
   and searches for any provided value of CONCEPT_NAME,CONCEPT_PUBLIC_ID or CONCEPT_CODE
   as it is shown below*/
     AND (UPPER(replace(dde.CONCEPT_NAME,' '))= UPPER(replace('Time Point',' '))
     or CONCEPT_PUBLIC_ID=2656619 or CONCEPT_CODE='C68568')
    
         
 order by de.cde_id