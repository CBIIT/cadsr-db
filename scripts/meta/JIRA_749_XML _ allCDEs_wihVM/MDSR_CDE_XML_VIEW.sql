CREATE OR REPLACE FORCE VIEW MDSR_CDE_XML_VIEW
as SELECT de.cde_id,
           de.version,
           de.preferred_name,
           de.long_name  ,
            de.ASL_NAME          ,
           de_conte.name,
            CAST (
                             MULTISET (
                                SELECT dec.dec_id,                                                                       
                                       dec.version 
                                       from
                                SBR.DATA_ELEMENT_CONCEPTS DEC           
                            WHERE   de.dec_idseq = dec.dec_idseq   
                                      
                                 ) AS MDSR_DEC_XML_LIST_T) "DataElementConcepts",
           CAST (
               MULTISET (
                   SELECT des_conte.name,
                          des.name,
                          des.detl_name,
                          des.lae_name
                     FROM (SELECT *
                             FROM sbr.designations
                            WHERE DETL_NAME <> 'USED_BY') des,
                          sbr.contexts  des_conte
                    WHERE     de.de_idseq = des.AC_IDSEQ(+)
                          AND des.conte_idseq = des_conte.conte_idseq(+))
                   AS MDSR_CDE_DESIGN_XML_LIST_T)
               "AlternateNameList",
           CAST (
               MULTISET (
                   SELECT rd.name,
                          rd.DCTL_NAME,
                          rd.doc_text,
                          rd.LAE_NAME,
                          rd.url
                     FROM SBR.REFERENCE_DOCUMENTS rd
                    WHERE     rd.ac_idseq = de.de_idseq
                          AND LOWER (rd.DCTL_NAME) LIKE '%question text%')
                   AS MDSR_CDE_RD_XML_LIST_T)
               "ReferrenceDocumentList",
         CAST (
             MULTISET (select   
             vd.vd_id,
             vd.version ,
             vd.long_name ,
             DECODE (vd.vd_type_flag,
                       'E', 'Enumerated',
                       'N', 'NonEnumerated',NULL),
             
             CAST (
                MULTISET (
                   SELECT pv.VALUE,                          
                       MDSR_CDE_VM_XML_T(   vm.VM_ID  ,
                         Vm.Version,
                         vm.long_name,
                          CAST (
                             MULTISET (
                                SELECT des_conte.name,
                                       des.name,
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
                          as MDSR_CDE_VD_XML_LIST_T )
               "ValueDomain"
               FROM 
         (select*from sbr.data_elements 
          where ASL_NAME not in( '%RETIRED WITHDRAWN%','RETIRED DELETED' ))de, 
          sbr.contexts de_conte
          where  de.conte_idseq = de_conte.conte_idseq AND cde_id in('62', '2002440')
          order by cde_id,version;