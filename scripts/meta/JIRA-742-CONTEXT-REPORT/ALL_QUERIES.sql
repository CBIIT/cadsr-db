/****************DATA_ELEMENTS_CONCEPTS/****************/
  
  SELECT  
          de.cde_id||'v'||de.version  DE_PublicId        ,
          de.long_name DE_long_name, 
          de_conte.name DE_Context , 
          de.preferred_name DE_PREFER_NAME,
          DE.QUESTION  Preferred_question_text,
       --   de.preferred_definition DE_DEFINITION,               
          DE.ASL_NAME DE_WORKFLOW_STATUS,     
          dec.dec_id||'v'||dec.version DEC_PublicId,
                   
          dec.long_name DEC_long_name,         
          VD.VD_id||'v'||VD.version VD_PublicId,         
          VD.long_name VD_long_name,  
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
                          vm.version
                     FROM sbr.permissible_values pv,
                          sbr.vd_pvs vp,
                          sbr.value_meanings vm
                    WHERE     vp.vd_idseq = vd.vd_idseq
                          AND vp.pv_idseq = pv.pv_idseq
                          AND pv.vm_idseq = vm.vm_idseq) AS DE_VALID_VALUE_LIST_T_MDSR)value_meaning,                 
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
                  and Q.DE_IDSEQ(+) = de.de_idseq ) AS SBREXT.HARMONY_FORM_PROTO_LIST_T) FORMS  ,
                    
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
                     
          ALT_QUESTION
   
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
         SBR.contexts rep_conte
 
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
      
     AND DE.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
 order by de.cde_id;
 
select  CDE_ID,version,DEFL_NAME,DEFINITION--DOC_TEXT,DCTL_NAME,AC.ACTL_NAME CREATED_FOR,PUBLIC_ID,LONG_NAME 
from SBR.DEFINITIONS RD ,
 SBR.DATA_ELEMENTS DEC
where RD.AC_IDSEQ=DEC.DE_IDSEQ
and DEC.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26';

/****************DATA_ELEMENTS_CONCEPTS/****************/

  
  SELECT   dec.dec_id||'v'||dec.version DEC_PublicId, 
           dec.long_name DEC_long_name,         
             DEC.ASL_NAME DE_WORKFLOW_STATUS,            
          de.cde_id||'v'||de.version  DE_PublicId        ,
          de.long_name DE_long_name, 
          de_conte.name DE_Context , 
          de.preferred_name DE_PREFER_NAME,
          DE.QUESTION  Preferred_question_text,      
          VD.VD_id||'v'||VD.version VD_PublicId,         
          VD.long_name VD_long_name,      
          
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
                          vm.version
                     FROM sbr.permissible_values pv,
                          sbr.vd_pvs vp,
                          sbr.value_meanings vm
                    WHERE     vp.vd_idseq = vd.vd_idseq
                          AND vp.pv_idseq = pv.pv_idseq
                          AND pv.vm_idseq = vm.vm_idseq) AS DE_VALID_VALUE_LIST_T_MDSR)value_meaning,                 
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
                  and Q.DE_IDSEQ(+) = de.de_idseq ) AS SBREXT.HARMONY_FORM_PROTO_LIST_T) FORMS  ,
                    
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
                 WHERE dec.dec_idseq = csv.ac_idseq) AS SBREXT.cdebrowser_csi_list_t)
             classifications,
          CAST (
             MULTISET (
                SELECT des_conte.NAME,
                       des_conte.VERSION,
                       des.NAME ,
                       des.DETL_NAME
                  FROM sbr.designations des, sbr.contexts des_conte
                 WHERE     dec.dec_idseq = des.AC_IDSEQ(+)
                       AND des.conte_idseq = des_conte.conte_idseq(+)) AS SBREXT.HARMONY_DESIGN_LIST_T)
             ALT_NAME_DESIGNATION  ,
              CAST (
             MULTISET (
                SELECT def_conte.NAME,
                       def_conte.VERSION,
                       def.DEFINITION ,
                       def.DEFL_NAME
                  FROM sbr.DEFINITIONS def, sbr.contexts def_conte
                 WHERE     dec.dec_idseq = def.AC_IDSEQ(+)
                       AND def.conte_idseq = def_conte.conte_idseq(+)) AS SBREXT.HARMONY_DEF_LIST_T)
             Alt_Definition ,
               CAST (
             MULTISET (
                SELECT rd_conte.NAME,
                       rd_conte.VERSION,
                       rd.DOC_TEXT ,
                       rd.RDTL_NAME
                  FROM sbr.reference_documents rd, sbr.contexts rd_conte
                 WHERE     dec.dec_idseq = rd.AC_IDSEQ(+)
                       AND rd.conte_idseq = rd_conte.conte_idseq(+)) AS SBREXT.HARMONY_DOC_REF_LIST_T)
                     
          ALT_QUESTION
   
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
         SBR.contexts rep_conte
 
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
      
     AND DEC.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
 order by dec.dec_id
select  *--DOC_TEXT,DCTL_NAME,AC.ACTL_NAME CREATED_FOR,PUBLIC_ID,LONG_NAME 
from SBR.REFERENCE_DOCUMENTS RD ,
 SBR.DATA_ELEMENT_CONCEPTS DEC
where RD.AC_IDSEQ=DEC.DEC_IDSEQ
and DEC.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
order by 3,4;
select  *--DOC_TEXT,DCTL_NAME,AC.ACTL_NAME CREATED_FOR,PUBLIC_ID,LONG_NAME 
from SBR.DESIGNATIONS RD ,
 SBR.DATA_ELEMENT_CONCEPTS DEC
where RD.AC_IDSEQ=DEC.DEC_IDSEQ
and DEC.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
order by 3,4;
select  DEC_ID,version,DEFL_NAME,DEFINITION--DOC_TEXT,DCTL_NAME,AC.ACTL_NAME CREATED_FOR,PUBLIC_ID,LONG_NAME 
from SBR.DEFINITIONS RD ,
 SBR.DATA_ELEMENT_CONCEPTS DEC
where RD.AC_IDSEQ=DEC.DEC_IDSEQ
and DEC.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
order by 3,4;


/****************VALUE_DOMAINS tab/****************/

  
  SELECT  VD.VD_id||'v'||VD.version VD_PublicId,         
          VD.long_name VD_long_name,       
           vd_conte.name vd_Context ,        
             VD.ASL_NAME VD_WORKFLOW_STATUS,            
          de.cde_id||'v'||de.version  DE_PublicId        ,
          de.long_name DE_long_name, 
          de_conte.name DE_Context , 
          de.preferred_name DE_PREFER_NAME,
          DE.QUESTION  Preferred_question_text,      
          dec.dec_id||'v'||dec.version DEC_PublicId, 
           dec.long_name DEC_long_name, 
          
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
                          vm.version
                     FROM sbr.permissible_values pv,
                          sbr.vd_pvs vp,
                          sbr.value_meanings vm
                    WHERE     vp.vd_idseq = vd.vd_idseq
                          AND vp.pv_idseq = pv.pv_idseq
                          AND pv.vm_idseq = vm.vm_idseq) AS DE_VALID_VALUE_LIST_T_MDSR)value_meaning,                 
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
                  and Q.DE_IDSEQ(+) = de.de_idseq ) AS SBREXT.HARMONY_FORM_PROTO_LIST_T) FORMS  ,
                    
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
                 WHERE vd.vd_idseq = csv.ac_idseq) AS SBREXT.cdebrowser_csi_list_t)
             classifications,
          CAST (
             MULTISET (
                SELECT des_conte.NAME,
                       des_conte.VERSION,
                       des.NAME ,
                       des.DETL_NAME
                  FROM sbr.designations des, sbr.contexts des_conte
                 WHERE     vd.vd_idseq = des.AC_IDSEQ(+)
                       AND des.conte_idseq = des_conte.conte_idseq(+)) AS SBREXT.HARMONY_DESIGN_LIST_T)
             ALT_NAME_DESIGNATION  ,
              CAST (
             MULTISET (
                SELECT def_conte.NAME,
                       def_conte.VERSION,
                       def.DEFINITION ,
                       def.DEFL_NAME
                  FROM sbr.DEFINITIONS def, sbr.contexts def_conte
                 WHERE     vd.vd_idseq = def.AC_IDSEQ(+)
                       AND def.conte_idseq = def_conte.conte_idseq(+)) AS SBREXT.HARMONY_DEF_LIST_T)
             Alt_Definition ,
               CAST (
             MULTISET (
                SELECT rd_conte.NAME,
                       rd_conte.VERSION,
                       rd.DOC_TEXT ,
                       rd.RDTL_NAME
                  FROM sbr.reference_documents rd, sbr.contexts rd_conte
                 WHERE     vd.vd_idseq = rd.AC_IDSEQ(+)
                       AND rd.conte_idseq = rd_conte.conte_idseq(+)) AS SBREXT.HARMONY_DOC_REF_LIST_T)
                     
          ALT_QUESTION
   
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
         SBR.contexts rep_conte
 
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
      
     AND VD.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
 order by dec.dec_id

select  *--DOC_TEXT,DCTL_NAME,AC.ACTL_NAME CREATED_FOR,PUBLIC_ID,LONG_NAME 
from SBR.REFERENCE_DOCUMENTS RD ,
 SBR.VALUE_DOMAINS DEC
where RD.AC_IDSEQ=DEC.VD_IDSEQ
and DEC.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
;
select  *--DOC_TEXT,DCTL_NAME,AC.ACTL_NAME CREATED_FOR,PUBLIC_ID,LONG_NAME 
from SBR.DESIGNATIONS RD ,
 SBR.VALUE_DOMAINS DEC
where RD.AC_IDSEQ=DEC.VD_IDSEQ
and DEC.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
;
select  *--DEC_ID,version,DEFL_NAME,DEFINITION--DOC_TEXT,DCTL_NAME,AC.ACTL_NAME CREATED_FOR,PUBLIC_ID,LONG_NAME 
from SBR.DEFINITIONS RD ,
 SBR.VALUE_DOMAINS DEC
where RD.AC_IDSEQ=DEC.VD_IDSEQ
and DEC.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
;
select csv.cs_id||'v'||csv.version CS_ID, csv.preferred_name,
       csv.csi_id||'v'||csv.csi_version CL_ITEM_ID,     
                       csv.csi_name CL_ITEM_NAME                       
                  FROM sbrext.cdebrowser_cs_view csv,
                   SBR.VALUE_DOMAINS VD
                 WHERE vd.vd_idseq = csv.ac_idseq
                 and vd.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26';



/****************Form Elements********************/
select distinct QF.QC_ID FormId,QE.QTL_NAME,QE.QC_ID||'v'||QE.version ElementId,QE.long_name Form_Element_long_name,QE.ASL_NAME Status,QE.DE_IDSEQ,DE.CDE_ID||'v'||DE.VERSION DE_ID,DE.long_name DE_LONG_NAME,DE.QUESTION,QE.VP_IDSEQ,VD.VD_ID||'v'||VD.version,vd.LONG_NAME,vd.vd_idseq
from SBREXT.QUEST_CONTENTS_EXT  QE,
SBREXT.QUEST_CONTENTS_EXT  QF,
SBR.DATA_ELEMENTS DE ,
 sbr.value_domains vd
 where (QF.QC_IDSEQ=QE.DN_CRF_IDSEQ or QE.QC_IDSEQ=QF.QC_IDSEQ)
  AND de.vd_idseq = vd.vd_idseq(+)
  AND QE.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
 and QF.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
 and QE.DE_IDSEQ=DE.DE_IDSEQ(+)
 and QF.QTL_NAME='CRF'
 order by 3;
 /****************REFERENCE_DOCUMENTS tab********************/

select  DOC_TEXT,DCTL_NAME,AC.ACTL_NAME CREATED_FOR,PUBLIC_ID||'v'||AC.VERSION PUBLIC_ID,LONG_NAME 
from SBR.REFERENCE_DOCUMENTS RD ,
SBR.ADMINISTERED_COMPONENTS AC
where RD.AC_IDSEQ=AC.AC_IDSEQ
and RD.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
order by 3,4;
/************************CLASSIFICATIONS*****************************/
SELECT distinct csi.csi_id,
           csi.version csi_version,
           csi_conte.name csi_context_name,--ac.ac_idseq,

           cs.cs_id,
         --  cs.preferred_name,
           cs.long_name,
      --     cs.preferred_definition,
           cs.version,
         --  cs.asl_name,
           cs_conte.name cs_context_name,
          -- cs_conte.version cs_context_version,
           csi.long_name csi_name,
           csi.csitl_name,ac.actl_name assosiated_DB_item,public_id assosiated_DB_item_publicid
          -- csi.preferred_definition description,
           
      FROM sbr.classification_schemes cs,
           sbr.cs_items csi,
           sbr.cs_csi csc,
           sbr.ac_csi acs,
           sbr.contexts cs_conte,
           sbr.contexts csi_conte,
           sbr.administered_components ac
     WHERE     ac.ac_idseq = acs.ac_idseq
           AND acs.cs_csi_idseq = csc.cs_csi_idseq
           AND csc.cs_idseq = cs.cs_idseq
           AND csc.csi_idseq = csi.csi_idseq
           AND cs.conte_idseq = cs_conte.conte_idseq
           AND csi.conte_idseq = csi_conte.conte_idseq
           and (cs.cs_id=3232477 )--or csi_id=3134869)
           order by 9,1;
           
           
           select* FROM sbr.classification_schemes cs,
           sbr.cs_csi csc,
           sbr.cs_items csi
         --  , sbr.ac_csi acs--
           where (cs_id=3232477 or csi_id=3134869
)
           AND csc.cs_idseq = cs.cs_idseq
           AND csc.csi_idseq = csi.csi_idseq;
           
/***************DEFINITIONS**********************/
           select DEFINITION,DEFL_NAME,AC.ACTL_NAME,PUBLIC_ID,LONG_NAME from SBR.DEFINITIONS DF ,
SBR.ADMINISTERED_COMPONENTS AC
where DF.AC_IDSEQ=AC.AC_IDSEQ
and DF.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26';
/***************DESIGNATIONS/***************/
           select DEFINITION,DEFL_NAME,AC.ACTL_NAME,PUBLIC_ID||'v'||AC.VERSION PUBLIC_ID,LONG_NAME from SBR.DEFINITIONS DF ,
SBR.ADMINISTERED_COMPONENTS AC
where DF.AC_IDSEQ=AC.AC_IDSEQ
and DF.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
order by 3,4;

select NAME ALTERN_NAME,DETL_NAME,AC.ACTL_NAME CREATED_FOR,PUBLIC_ID||'v'||AC.VERSION PUBLIC_ID ,LONG_NAME from SBR.DESIGNATIONS DF, 
SBR.ADMINISTERED_COMPONENTS AC
where DF.AC_IDSEQ=AC.AC_IDSEQ

and DF.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
order by 3,4
