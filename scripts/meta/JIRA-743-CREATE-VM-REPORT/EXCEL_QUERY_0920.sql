SELECT distinct  csv.preferred_name CLASSIFICATION,CDE_id||'v'||de.version DE_ID ,DE.LONG_NAME DE_LONG_NAME,de_con.Name DE_CONTEXT,VD_ID||'v'||VD.VERSION VD_ID,
PV.VALUE PV,VM_ID||'v'||VM.VERSION VM_ID,VM.LONG_NAME VM_LONG_NAME, AlternateName, LAE_NAME AlternateName_Language,DETL_NAME AlternateName_type, AlternateName_CONTEXT   
                                                 
                    FROM sbrext.cdebrowser_cs_view csv,
                    sbr.VALUE_DOMAINS vd,
                    sbr.VALUE_MEANINGS vm,
                    SBR.data_elements de ,
                    sbr.permissible_values pv,
                    sbr.contexts de_con,
                    sbr.vd_pvs vp,
                    (select ds.ac_IDSEQ,ds.name   AlternateName, 
                    ds.LAE_NAME,DETL_NAME,c.NAME AlternateName_CONTEXT 
                    from  sbr.designations ds,
                    sbrext.contexts c
                    where c.CONTE_IDSEQ=ds.CONTE_IDSEQ)des
                    
                    WHERE vp.vd_idseq = vd.vd_idseq
                    AND vp.pv_idseq = pv.pv_idseq
                    AND pv.vm_idseq = vm.vm_idseq
                    and  de.CONTE_IDSEQ=de_con.CONTE_IDSEQ
                    and de.de_idseq = csv.ac_idseq
                    and vd.VD_IDSEQ=DE.VD_IDSEQ
                    and vm.VM_IDSEQ=des.ac_IDSEQ(+)
                    and VD_TYPE_FLAG='E'
                    and csv.preferred_name in ('ACT Network CDM 1.4','PCORnet CDM 4.0','Sentinel CDM 6.02','OMOP 4.0') 
                    order by 1,DE_id,VD_ID