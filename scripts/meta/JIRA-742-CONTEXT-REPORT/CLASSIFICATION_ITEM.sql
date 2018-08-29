SELECT distinct csi.csi_id,
           csi.version csi_version,
           csi_conte.name csi_context_name,--ac.ac_idseq,

           cs.cs_id,
         --  cs.preferred_name,
           cs.long_name,
      --     cs.preferred_definition,
           cs.version,
         --  cs.asl_name,
           cs_conte.name cs_context_name,
          -- cs_conte.version cs_context_version,
           csi.long_name csi_name,
           csi.csitl_name,ac.actl_name assosiated_DB_item,public_id assosiated_DB_item_publicid
          -- csi.preferred_definition description,
           
      FROM sbr.classification_schemes cs,
           sbr.cs_items csi,
           sbr.cs_csi csc,
           sbr.ac_csi acs,
           sbr.contexts cs_conte,
           sbr.contexts csi_conte,
           sbr.administered_components ac
     WHERE     ac.ac_idseq = acs.ac_idseq
           AND acs.cs_csi_idseq = csc.cs_csi_idseq
           AND csc.cs_idseq = cs.cs_idseq
           AND csc.csi_idseq = csi.csi_idseq
           AND cs.conte_idseq = cs_conte.conte_idseq
           AND csi.conte_idseq = csi_conte.conte_idseq
           and (cs.cs_id=3232477 or csi_id=3134869)
           order by 9,1;
           
           
           select* FROM sbr.classification_schemes cs,
           sbr.cs_csi csc,
           sbr.cs_items csi
         --  , sbr.ac_csi acs--
           where (cs_id=3232477 or csi_id=3134869
)
           AND csc.cs_idseq = cs.cs_idseq
           AND csc.csi_idseq = csi.csi_idseq
          -- AND acs.cs_csi_idseq = csc.cs_csi_idseq;
          
          
          
          
          select * from SBR.ADMINISTERED_COMPONENTS  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'; 
           