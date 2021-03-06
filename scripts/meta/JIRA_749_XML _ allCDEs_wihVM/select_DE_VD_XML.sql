select   
        de.cde_id,de.version,de_preferred_name,de.long_name   , CAST (
                             MULTISET (
                                SELECT dec.dec_id,                                                                       
                                       dec.version 
                                       from
                                SBR.DATA_ELEMENT_CONCEPTS DEC           
                            WHERE   de.dec_idseq = dec.dec_idseq   (+)
                                      
                                 ) AS MDSR_DEC_XML_LIST_T) ,
        CAST (
             MULTISET (select vd.long_name ,
              vd.preferred_name ,            
            
             vd.vd_id,
             vd.version ,
             vd.vd_idseq,
             '',--vd.asl_name,
             CAST (
                MULTISET (
                   SELECT pv.VALUE,                          
                       MDSR_CDE_VM_XML_T(   vm.VM_ID  ,
                         Vm.Version,
                         vm.long_name,
                          CAST (
                             MULTISET (
                                SELECT des_conte.name,                                                                            des.name,
                                       des.detl_name,
                                       des.lae_name
                                  FROM sbr.designations des,
                                       sbr.contexts des_conte
                                 WHERE vm.vm_idseq = des.AC_IDSEQ
                                       AND des.conte_idseq =  des_conte.conte_idseq(+)
                                 ) AS MDSR_CDE_DESIGN_XML_LIST_T)   ) 
                     FROM sbr.permissible_values pv,
                          sbr.vd_pvs vp,
                          value_meanings vm
                          
                    WHERE     vp.vd_idseq = vd.vd_idseq
                          AND vp.pv_idseq = pv.pv_idseq
                          AND pv.vm_idseq = vm.vm_idseq
                          ) AS MDSR_CDE_PV_XML_LIST_T)
                       
                          from 
                           sbr.value_domains vd
                           where vd.vd_idseq=de.vd_idseq)
                          as MDSR_CDE_VD_XML_LIST_T )VD
                       
             
     FROM 
         (select*from sbr.data_elements 
          where ASL_NAME not in( '%RETIRED WITHDRAWN%','RETIRED DELETED' ))de
           
          where   cde_id = '2002440';
          
          
          select count(*) from sbr.data_elements 
          where upper(ASL_NAME)  like '%RETIRED WITHDRAWN%';
            select count(*) from sbr.data_elements 
          where upper(ASL_NAME)  like '%RETIRED%';
          
          select distinct ASL_NAME from sbr.data_elements 
          where upper(ASL_NAME)  like '%RETIRED%';
          
          select sum(cnt) from (
          select count(*)cnt,ASL_NAME from sbr.data_elements 
          where upper(ASL_NAME)  like '%RETIRED%'
          group by ASL_NAME);
          
          select count(*)cnt,ASL_NAME from sbr.data_elements 
          where upper(ASL_NAME)  like '%RETIRED%'
          group by ASL_NAME;
          
          
          select*from sbr.value_domains where vd_id= 2016566;
          
          select*from MDSR_CDE_XML_VIEW
          
          select*from  sbr.contexts
          
          
          select count(*)from sbr.data_elements d, sbr.contexts de_conte
          where d.ASL_NAME not in( '%RETIRED WITHDRAWN%','RETIRED DELETED' )
         and d.conte_idseq = de_conte.conte_idseq AND  
          name='NCIP'
          
          SELECT dbms_xmlgen.getxml( 'select*from  MDSR_CDE_XML_VIEW')
        
        FROM DUAL ;
        
         --select*from sbr.data_elements  where cde_id =62;
          
         -- select* from sbr.contexts where conte_idseq='99BA9DC8-2095-4E69-E034-080020C9C0E0';
         
         --select count(*)from sbr.data_elements where conte_idseq='99BA9DC8-2095-4E69-E034-080020C9C0E0'         and ASL_NAME not in( '%RETIRED WITHDRAWN%','RETIRED DELETED' );
         --delete from MDSR_FB_XML_TEMP
        exec MDSR_xml_CDE_insert
        exec MDSR_CDE_XML_TRANSFORM
        
        select* from MDSR_FB_XML_TEMP