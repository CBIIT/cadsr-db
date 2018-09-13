SELECT SYS_XMLAGG (
sys_xmlgen( XMLELEMENT("DataElement", XMLELEMENT("PublicId", CDE_id),
  XMLELEMENT("Version", de_version),
  XMLELEMENT ( "LongName", de_long_name),
  XMLELEMENT ("CLASSIFICATION" ,CLASSIFICATION ),  
  XMLELEMENT("ValueDomain",   XMLELEMENT ("PublicId" ,vd_id), 
  XMLELEMENT ("Version",vd_version),             
  XMLELEMENT ("LongName",vd_long_name),              
              
              (SELECT xmlagg( xmlelement("PermissibleValue_element",xmlelement("VALIDVALUE", pv.value),
                                                 xmlelement("ValueMeaning",
                                                 xmlelement("PublicID", vm_id),
                                                 xmlelement("Version", VM.version),
                                                 xmlelement("LongName", VM.Long_name),
                                                 
                                                  (SELECT xmlagg(  xmlelement("AlternativeName",
                                                 xmlelement("Name", ds.name ),
                                                 xmlelement("NameType", ds.DETL_NAME),
                                                 xmlelement("Language", ds.LAE_NAME)  ,
                                                  xmlelement("CONTEXT", c.NAME)))
                                                 
                                    from  sbr.designations ds,
                                    sbrext.contexts c
                                    where c.CONTE_IDSEQ=ds.CONTE_IDSEQ 
                                    and ds.ac_IDSEQ(+)=vm.vm_idseq
                                    ))      )                           )
                                                       
                                      
                              FROM sbr.permissible_values pv,
                          sbr.vd_pvs vp,
                          sbr.value_meanings vm
                    WHERE     vp.vd_idseq = a.vd_idseq
                          AND vp.pv_idseq = pv.pv_idseq
                          AND pv.vm_idseq = vm.vm_idseq
                         
                     )   )     
                            
                            ))).getclobval() xml_result          
            from
            (                
  select     csv.preferred_name CLASSIFICATION,
  de.CDE_id, de.version de_version, 
  de.long_name de_long_name, 
  vd.vd_id , vd.version vd_version,
  vd.long_name vd_long_name  ,                   
  vd.vd_idseq                                      
FROM sbrext.cdebrowser_cs_view csv,
sbr.VALUE_DOMAINS vd,
SBR.data_elements de 
WHERE   
de.CONTE_IDSEQ='6CB969CC-DD4B-1016-E053-F662850A40C7'
and  de.de_idseq = csv.ac_idseq
and vd.VD_IDSEQ=DE.VD_IDSEQ               
and VD_TYPE_FLAG='E'
and csv.preferred_name<>'CDMH 1.0' 
order by 1,2 ) a;