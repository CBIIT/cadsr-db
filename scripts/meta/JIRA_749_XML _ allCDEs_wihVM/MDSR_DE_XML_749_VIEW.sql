 CREATE OR REPLACE FORCE VIEW MDSR_DE_XML_749_VIEW
 as select CAST ( MULTISET (SELECT  de.cde_id CDEPublicID,
           de.version CDEVersion,           
           de.preferred_name  DataElementShortName,  
           de.long_name DataElementLongName,         
           de_conte.name DataElementContext,
           de.ASL_NAME  DataElementStatus        ,          
           CAST ( MULTISET (
                   SELECT des_conte.name,
                          '',
                          des.name,
                          des.detl_name,
                          des.lae_name
                     FROM (SELECT *
                             FROM sbr.designations
                            WHERE DETL_NAME <> 'USED_BY') des,
                          sbr.contexts  des_conte
                    WHERE     de.de_idseq = des.AC_IDSEQ(+)
                          AND des.conte_idseq = des_conte.conte_idseq(+))
                   AS  MDSR_749_DESIGN_LIST_T)
               "AlternateNameList",
           CAST (
               MULTISET (
                   SELECT rd.name,
                          rd.ORG_IDSEQ,
                          rd.DCTL_NAME,
                          rd.doc_text,
                          rd.url,
                          rd.LAE_NAME,
                          rd.DISPLAY_ORDER
                     FROM SBR.REFERENCE_DOCUMENTS rd
                    WHERE     rd.ac_idseq (+) = de.de_idseq
                          AND LOWER (rd.DCTL_NAME) LIKE '%question text%')
                   AS MDSR_749_RD_LIST_T)
               "ReferrenceDocumentList",
           dec.dec_id,                                                                       
           dec.version dec_version,
         CAST (
             MULTISET (select   
             vd.vd_id,
             vd.version ,
             vd.long_name ,
             vd.DTL_NAME,
             DECODE (vd.vd_type_flag,
                       'E', 'Enumerated',
                       'N', 'NonEnumerated',NULL),
                       CAST (
               MULTISET (
                   SELECT pv.VALUE,
                          vm.long_name           short_meaning,
                          vm.preferred_definition,
                          sbrext_common_routines.get_concepts (
                          vm.condr_idseq)    MeaningConcepts,                          
                          vm.vm_id,
                          vm.version,
                               CAST (
               MULTISET (
                   SELECT des_conte.name,
                          null,
                          des.name,
                          des.detl_name,
                          des.lae_name
                     FROM (SELECT *
                             FROM sbr.designations
                            WHERE DETL_NAME <> 'USED_BY') des,
                          sbr.contexts  des_conte
                    WHERE     vm.vm_idseq = des.AC_IDSEQ(+)
                          AND des.conte_idseq = des_conte.conte_idseq(+))
                   AS  MDSR_749_DESIGN_LIST_T)
               "AlternateNameList"
                     FROM sbr.permissible_values  pv,
                          sbr.vd_pvs              vp,
                          value_meanings          vm
                    WHERE     vp.vd_idseq = vd.vd_idseq
                          AND vp.pv_idseq = pv.pv_idseq
                          AND pv.vm_idseq = vm.vm_idseq)
                   AS MDSR_749_PV_LIST_T  )
               valid_values
                           from 
                           sbr.value_domains vd
                           where vd.vd_idseq=de.vd_idseq)
                          as MDSR_749_VD_LIST_T  )
               "ValueDomain"
          FROM 
         (select*from sbr.data_elements 
          where ASL_NAME not in( '%RETIRED WITHDRAWN%','RETIRED DELETED' ))de, 
          sbr.contexts de_conte,
          SBR.DATA_ELEMENT_CONCEPTS dec
          where  de.conte_idseq = de_conte.conte_idseq 
          and de.dec_idseq=dec.dec_idseq(+)
          and de_conte.conte_idseq=c.conte_idseq --AND cde_id in('2529097','2768794','3147627','2974175','2768794')
          order by de_conte.name,cde_id,de.version)as  MDSR_CDE_749_LIST_T )"DE_Contest"
          from 
          sbr.contexts c
          where name='CTEP'
          ;     
