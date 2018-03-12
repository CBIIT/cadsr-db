select  

sys_xmlgen( MDSR_FB_DATA_EL_XML_T3(de.LONG_NAME,de.PREFERRED_NAME,de.CDE_ID ,de.version
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
          and rd.ac_idseq=de.de_idseq )as MDSR_FB_RD_XML_LIST_T4)))--3506034;
   from sbr.data_elements de 
 ,SBR.contexts c1
   where de.cde_id=59--2003746--seq= '8756B99C-D1B9-58C0-E040-BB89AD43357F' 
   and c1.CONTE_IDSEQ=de.CONTE_IDSEQ;