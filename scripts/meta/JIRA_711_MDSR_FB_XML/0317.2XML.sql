select cf.name,MF.CREATED_BY, MF.DATE_CREATED, MF.DATE_MODIFIED,MF.MODIFIED_by,
MF.long_name,MF.CHANGE_NOTE,MF.preferred_definition,'2.16.840.1.113883.3.26.2',MF.QC_ID,MF.VERSION,MF.ASL_NAME,MF.QCDL_NAME,MF.QTL_NAME,
FI.preferred_definition,
cast(multiset( select 
MM.DISPLAY_ORDER,
NVL(mm.REPEAT_NO,0),
MM.long_name,
REDCAP_INSTRUCTIONS_T(Mod_instruction),
MM.preferred_Definition,
mm.mod_id,
mm.version,
MDSR_FB_usageCat_XML(usageType ,
Mod_instruction),
cast(multiset( select
QQ.QUES_id,
QQ.QUES_version,
isDerived,
QQ.DISPLAY_ORDER,
qq.date_created,
qq.date_Modified,
qq.Q_LONG_NAME,
REDCAP_INSTRUCTIONS_T(Q_instruction ),
qq.EDITABLE_IND,
qq.MANDATORY_IND,
qq.multiValue,
qq.de_LONG_NAME,
de_PREFERRED_NAME,
qq.CDE_ID ,
qq.de_version,
qq.DE_context ,
qq.DE_WORKFLOW,
qq.D_PREFERRED_DEFINITION, 
    cast(multiset( select          
      vd.long_name,
       vd.vd_id,
       vd.version,
       vd.VD_TYPE_FLAG,
       vd.ASL_NAME,
       vd.DTL_NAME,       
       vd.MAX_LENGTH_NUM,
       vd.MIN_LENGTH_NUM,
       cast(multiset(
        select pv.value,
       cast(multiset(
        select 
        vm2.vm_id,
        vm2.version,
        vm2.long_name  , 
        (cast(multiset( 
          SELECT 
          d.created_by,d.date_created,d.LAE_NAME,
          d.name,
          DETL_NAME,
          c.name
          from SBR.DESIGNATIONS d,
          SBR.contexts c         
          where c.CONTE_IDSEQ=d.CONTE_IDSEQ
          and d.ac_idseq=vm1.vm_idseq       
          ) as MDSR_FB_DESIGN_XML_LIST_T )) ,
        vm2.preferred_Definition
         from SBR.VALUE_MEANINGS vm2
   where  pv.VM_idseq=vm2.vm_idseq)as MDSR_FB_VM_XML_LIST_T4)
         from SBR.VALUE_MEANINGS vm1,
         SBR.PERMISSIBLE_VALUES pv,
           VD_PVS vp
   where pv.pv_idseq=vp.pv_idseq--vm_id='3197154'
   and vm1.vm_idseq=pv.VM_idseq  
   and vd.VD_IDSEQ=vp.VD_IDSEQ)as MDSR_FB_PV_XML_LIST_T4)
   from value_domains vd 
    where  vd.vd_idseq=qq.vd_idseq) as MDSR_FB_VD_XML_LIST_T4),
    cast(multiset(  
    SELECT rd.name,rd.DCTL_NAME,c2.name,rd.doc_text,rd.LAE_NAME,rd.url
         from SBR.REFERENCE_DOCUMENTS rd,
          SBR.contexts c2 
          where c2.CONTE_IDSEQ=rd.CONTE_IDSEQ
          and rd.ac_idseq=qq.de_idseq )as MDSR_FB_RD_XML_LIST_T4)--3506034;
  ,
      CAST (
                                                          MULTISET (
                                                               SELECT TRIM (DISPLAY_ORDER),
                                                                      TRIM (VALUE),
                                                                      TRIM (MEANING_TEXT),
                                                                      TRIM (DESCRIPTION_TEXT),
                                                                      MDSR_FB_VV_VM_XML_T(vvm.vm_id,
                                                                      vvm.version)
                                                                 FROM  QUEST_CONTENTS_EXT QV,
                                                                 VALID_VALUES_ATT_EXT  VV , 
                                                             SBR.VALUE_MEANINGS vvm,
                                                                SBR.PERMISSIBLE_VALUES vpv,
                                                             VD_PVS vvp
                                                               where VV.QC_IDSEQ=QV.QC_IDSEQ
                                                               and P_QST_IDSEQ=qq.ques_idseq--'C0008243-FD07-E8E1-E040-BB89AD437A55'
                                                        and vpv.pv_idseq=vvp.pv_idseq--vm_id='3197154'
                                                        and vvm.vm_idseq=vpv.VM_idseq
                                                        and qv.VP_IDSEQ=vvp.VP_IDSEQ --and qv.VP_IDSEQ='871A0137-4215-F855-E040-BB89AD436829'
                                                        order by DISPLAY_ORDER)as MDSR_FB_VV_XML_LIST_T)
                                                        from SBREXT.MDSR_FB_QUESTION_MVW QQ
                                                        where  qq.mod_idseq=mm.MOD_IDSEQ
                                                        order by QQ.DISPLAY_ORDER                                                     
                                                       ) as  MDSR_FB_QUESTION_XML_LIST_T2)
                                                       
                                                       
                                                        from 
                            SBREXT.MDSR_FB_QUEST_MODULE_MVW mm
                            where mf.qc_IDSEQ=mm.CRF_IDSEQ                                                     
                            order by MM.DISPLAY_ORDER)as MDSR_FB_MODULE_XML_LIST_T2 ),
                      cast(multiset(
                                        SELECT  pe.lead_org,
                                        pe.phase,
                                        pe.type,
                                        pe.proto_ID,
                                        TRIM (pe.long_name),
                                        cf.name,
                                        pe.PREFERRED_NAME,                                                                       
                                        UTL_I18N.UNESCAPE_REFERENCE  (TRIM (pe.PREFERRED_DEFINITION))                              
                                        FROM   PROTOCOLS_EXT pe,
                                        protocol_qc_ext pq
                                        WHERE mf.qc_IDSEQ = pq.qc_idseq(+)
                                        AND pq.proto_idseq = pe.PROTO_IDSEQ(+))as MDSR_FB_PROTOCOL_XML_LIST_T ) ,
                                cast(multiset(     SELECT  cs.long_name, cs.CS_ID,cs.version,
                                    cs.preferred_definition,
                                    MDSR_FB_FORM_CLI_XML_T( i.long_name,
                                    i.CSI_ID,
                                    i.version  ,
                                    CSITL_NAME  )             
                                    FROM cs_csi cscsi,                                    
                                    classification_schemes cs,
                                    ac_csi accsi,
                                    CS_ITEMS i
                           WHERE  mf.qc_IDSEQ = accsi.AC_IDSEQ(+)         
                            AND cs.CS_IDSEQ = cscsi.CS_IDSEQ
                            AND accsi.CS_CSI_IDSEQ = cscsi.CS_CSI_IDSEQ        
                            AND i.CSI_IDSEQ = cscsi.CSI_IDSEQ order by cs.CS_ID
                            )as NDSR_FB_FORM_CL_XML_LIST_T )
                            from  QUEST_CONTENTS_EXT mf ,
                             SBR.contexts cf ,        
       
                             (select* from   QUEST_CONTENTS_EXT where QTL_NAME='FORM_INSTR') fi ,
                             (select* from   QUEST_CONTENTS_EXT where QTL_NAME='INSTRUCTION') ffi 
                          where  mf.ASL_NAME='RELEASED' 
                          AND cf.CONTE_IDSEQ=mf.CONTE_IDSEQ
                          and fi.DN_CRF_IDSEQ(+) =mf.qc_idseq   
                           and ffi.DN_CRF_IDSEQ(+) =mf.qc_idseq                       
                          and (MF.QTL_NAME = 'CRF'OR MF.QTL_NAME = 'TEMPLATE')
                          and mf.qc_id in (5590324,2263415,3443682,3691952,5791100,4964471)--,2019334
      