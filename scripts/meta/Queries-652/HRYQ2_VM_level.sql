  
  SELECT --dde.CONCEPT_NAME CONCEPT_NAME,dde.CONCEPT_CODE,dde.CONCEPT_PUBLIC_ID,
          de.cde_id DE_PublicId,de.version DE_VERSION,         
          de.long_name DE_long_name, de_conte.name DE_Context , 
          de.preferred_name DE_PREFER_NAME,
          DE.QUESTION  Preferred_question_text,
          de.preferred_definition DE_DEFINITION,          
          de.origin DE_ORIGIN,          
          DE.CHANGE_NOTE DE_CHANGE_NOTE,
          DE.ASL_NAME DE_WORKFLOW_STATUS,
          DE.REGISTRATION_STATUS DE_REGISTRATION_STATUS,
          de.Created_by DE_Created_by, de.date_created DE_Date_Created,de.modified_by DE_Modified_by, de.DATE_MODIFIED DE_DATE_MODIFIED,
         
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
                SELECT vm.vm_id,
                       vm.version,
                       vm.long_name ,
                       vm.preferred_name,
                       d.name alt_name,
                       c.Name,
                         sbrext.sbrext_common_routines.get_concepts (vm.condr_idseq),
                       vm.DEFINITION_SOURCE,
                       vm.change_note ,
                       vm.Created_by , 
                       vm.date_created ,
                       vm.modified_by ,
                       vm.DATE_MODIFIED
                  FROM  SBR.VD_PVS VP, 
                        SBR.PERMISSIBLE_VALUES PV,
                        SBR.VALUE_MEANINGS VM ,
                        SBR.DESIGNATIONS D,
                        SBR.CONTEXTS C            
                 WHERE     vp.vd_idseq = vd.vd_idseq
                       AND vp.pv_idseq = pv.pv_idseq
                       AND pv.vm_idseq = vm.vm_idseq
                       and vm.conte_idseq=c.conte_idseq
                       AND VM.CONDR_IDSEQ= DDE.CONDR_IDSEQ                       
                       AND vm.vm_idseq = d.ac_idseq(+)     
                                                         ) AS SBREXT.HARMONY_VM_LIST_T)
             Value_Mening,
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
                select distinct F.QC_ID ,F.version ,F.LONG_NAME ,CF_CONTE.NAME,M.LONG_NAME, F.QTL_NAME,p.LONG_NAME ,F.ASL_NAME 
                FROM  SBREXT.QUEST_CONTENTS_EXT  Q,          
                  SBREXT.QUEST_CONTENTS_EXT  F,
                  SBR.CONTEXTS CF_conte,
                  SBREXT.QUEST_CONTENTS_EXT  M,
                  SBREXT.PROTOCOLS_EXT P,
                  SBREXT.QUEST_CONTENTS_EXT  VV,
                  SBREXT.PROTOCOL_QC_EXT PQ 
                  where Q.DN_CRF_IDSEQ=F.QC_IDSEQ    
                  AND M.DN_CRF_IDSEQ=F.QC_IDSEQ            
                  AND Q.P_MOD_IDSEQ=M.QC_IDSEQ          
                  AND F.CONTE_IDSEQ=CF_conte.CONTE_IDSEQ  
                  AND VV.DN_CRF_IDSEQ=F.QC_IDSEQ    
                  and F.QC_IDSEQ=PQ.QC_IDSEQ (+)  
                  and PQ.PROTO_IDSEQ=P.PROTO_IDSEQ (+) 
                  and F.QTL_NAME IN ('CRF','TEMPLATE')
                  and Q.QTL_NAME='QUESTION' 
                  and M.QTL_NAME='MODULE'
                  AND VV.QTL_NAME='VALID_VALUE'
                  AND F.ASL_NAME not like '%RETIRED%' 
                  and Q.DE_IDSEQ = de.de_idseq
                  and vv.VP_IDSEQ=dde.VP_IDSEQ) 
        AS SBREXT.HARMONY_FORM_PROTO_LIST_T) FORMS  ,
                           
          CAST (
             MULTISET (
                SELECT admin_component_with_id_t (
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
                 WHERE de.de_idseq = csv.ac_idseq(+)) AS cdebrowser_csi_list_t)
             classifications 
     FROM SBREXT.CABIO31_DATA_ELEMENTS_VIEW de,        
          sbr.contexts de_conte,         
          sbr.VALUE_DOMAINS vd,
          SBR.AC_REGISTRATIONS_VIEW ar,         
         SBREXT.cdebrowser_complex_de_view ccd,
         SBR.contexts VD_conte, 
         
          ( 
 select  DE.DE_IDSEQ,CON_ID CONCEPT_PUBLIC_ID,C.PREFERRED_NAME CONCEPT_CODE,C.LONG_NAME CONCEPT_NAME,VM.CONDR_IDSEQ,PVS.VP_IDSEQ
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
 )DDE
        WHERE    de.VD_IDSEQ = VD.VD_IDSEQ 
        AND vd.VD_IDSEQ = ar.AC_IDSEQ(+)        
        AND de.conte_idseq = de_conte.conte_idseq        
        AND VD.conte_idseq = VD_conte.conte_idseq
        AND de.de_idseq = ccd.p_de_idseq(+)         
        AND DE.ASL_NAME NOT LIKE '%RETIRED%'
        and de.de_idseq = dde.de_idseq
   /*replace below values for CONCEPT_NAME,CONCEPT_PUBLIC_ID or CONCEPT_CODE
   Currently query is case insensitive (Time Point, time point, Time point, Timepoint, timepoint)
   and searches for any provided value of CONCEPT_NAME,CONCEPT_PUBLIC_ID or CONCEPT_CODE
   as it is shown below*/
     AND (UPPER(replace(dde.CONCEPT_NAME,' '))= UPPER(replace('Time Point',' '))
     or CONCEPT_PUBLIC_ID=2656619 or CONCEPT_CODE='C68568')
    
 order by de.cde_id