SELECT distinct  csv.preferred_name CLASSIFICATION,CDE_id||'v'||de.version DE_ID ,DE.LONG_NAME DE_LONG_NAME,VD_ID||'v'||VD.VERSION VD_ID,PV.VALUE PV,VM_ID||'v'||VM.VERSION VM_ID,VM.LONG_NAME VM_LONG_NAME,ALT_NAME, LAE_NAME,DETL_NAME,ALT_CONTEXT
                                                 
                  FROM sbrext.cdebrowser_cs_view csv,
                  sbr.VALUE_DOMAINS vd,
                 sbr.VALUE_MEANINGS vm,
                  SBR.data_elements de ,
                  sbr.permissible_values pv,
                          sbr.vd_pvs vp,
                      (  select ds.ac_IDSEQ,ds.name  ALT_NAME, ds.LAE_NAME,DETL_NAME,c.NAME ALT_CONTEXT
                      from  sbr.designations ds,
                          sbrext.contexts c
                          where c.CONTE_IDSEQ=ds.CONTE_IDSEQ)des
                    WHERE     vp.vd_idseq = vd.vd_idseq
                          AND vp.pv_idseq = pv.pv_idseq
                          AND pv.vm_idseq = vm.vm_idseq
                          and  de.CONTE_IDSEQ='6CB969CC-DD4B-1016-E053-F662850A40C7'
                and de.de_idseq = csv.ac_idseq
                and vd.VD_IDSEQ=DE.VD_IDSEQ
                and vm.VM_IDSEQ=des.ac_IDSEQ(+)
                and VD_TYPE_FLAG='E'
                and csv.preferred_name<>'CDMH 1.0'
                order by 1,CDE_id,VD_ID