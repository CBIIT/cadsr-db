select  QQ.qc_id,QQ.version,'false',QQ.DISPLAY_ORDER,qq.date_created,qq.date_Modified,qq.long_name,
 qa.EDITABLE_IND,qa.MANDATORY_IND,qq.REPEAT_NO,
  cast(multiset( select de.LONG_NAME,de.PREFERRED_NAME,de.CDE_ID ,de.version
,c1.name ,de.ASL_NAME
    ,de.PREFERRED_DEFINITION, 
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
  -- where  vd.vd_idseq='86F80BB1-5F4C-B573-E040-BB89AD4330B9'
    where  vd.vd_idseq=de.vd_idseq) as MDSR_FB_VD_XML_LIST_T4),
    cast(multiset(  
    SELECT rd.name,rd.DCTL_NAME,c2.name,rd.doc_text,rd.LAE_NAME,rd.url
         from SBR.REFERENCE_DOCUMENTS rd,
          SBR.contexts c2 
          where c2.CONTE_IDSEQ=rd.CONTE_IDSEQ
          and rd.ac_idseq=de.de_idseq )as MDSR_FB_RD_XML_LIST_T4)--3506034;
   from sbr.data_elements de 
 ,SBR.contexts c1
   where de.de_idseq=qq.de_idseq--2003746--seq= '8756B99C-D1B9-58C0-E040-BB89AD43357F' 
   and c1.CONTE_IDSEQ=de.CONTE_IDSEQ) as  MDSR_FB_DATA_EL_XML_LIST_T3),
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
                                                               and P_QST_IDSEQ=qq.qc_idseq--'C0008243-FD07-E8E1-E040-BB89AD437A55'
                                                        and vpv.pv_idseq=vvp.pv_idseq--vm_id='3197154'
                                                        and vvm.vm_idseq=vpv.VM_idseq
                                                        and qv.VP_IDSEQ=vvp.VP_IDSEQ --and qv.VP_IDSEQ='871A0137-4215-F855-E040-BB89AD436829'
                                                        order by DISPLAY_ORDER)as MDSR_FB_VV_XML_LIST_T)
                                                        from QUEST_CONTENTS_EXT qq,
                                                        QUEST_ATTRIBUTES_EXT qa  
                                                        where
                                                        qq.QC_IDSEQ=qa.QC_IDSEQ
                                                        and qq.qc_idseq='C0008243-FD07-E8E1-E040-BB89AD437A55';