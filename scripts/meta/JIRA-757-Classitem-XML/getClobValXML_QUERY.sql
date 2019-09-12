 SELECT sys_xmlgen(MDSR759_XML_Context_T1( CS_CONTEXT_NAME,
      CS_CONTEXT_VERSION,
      CONTEXT_ID,
 CAST (
       MULTISET (SELECT 
    LONG_NAME,
    CS_ID,
    VERSION,
    PREFERRED_DEFINITION,
    
   
                          CAST (
                             MULTISET (
                                SELECT vw.CSI_LEVEL,
                                       vw.CSI_NAME,
                                       vw.CSI_ID,    
                                       CSI_VERSION,    
                                       vw.CSITL_NAME,    
                                       vw.DESCRIPTION,   
                                       vw.CSI_IDSEQ,
                                       vw.PARENT_CSI_IDSEQ,
                                        vw.CS_CSI_IDSEQ,
                                       CSI.CSI_ID,    
                                       CSI.VERSION,  
                                        vw.LEAF
                                  FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW vw,
                                      ( select csi.CSI_IDSEQ,csi.csi_id ,p_cs_csi_idseq,csi.version ,CS_CSI_IDSEQ from
                                       sbr.cs_items   csi,
                                       sbr.cs_csi   csc 
                                       WHERE    csc.csi_idseq = csi.csi_idseq)csi
                                 WHERE vw.CS_IDSEQ='E92962A2-9978-1F46-E034-0003BA3F9857'--cl.CS_IDSEQ
                                 and PARENT_CSI_IDSEQ=csi.p_cs_csi_idseq(+)
                                 and vw.CS_CSI_IDSEQ=csi.CS_CSI_IDSEQ(+)
                                -- and  CSI.CSI_ID=
                              --   group by csi.CSI_LEVEL,   csi.CSI_ID                                     
                              order by  vw.CSI_LEVEL,   csi.CSI_ID       ) AS MDSR759_XML_CSI_LIST_T1)      "ClassificationItemList"
                     FROM  (select distinct CS_IDSEQ,CS_ID,
    PREFERRED_NAME,
    LONG_NAME,
    PREFERRED_DEFINITION,
    VERSION,
    ASL_NAME,
    CS_CONTEXT_NAME,
    CS_CONTEXT_VERSION
    from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW 
       )cl
      where con.CS_CONTEXT_NAME=cl.CS_CONTEXT_NAME
order by  CS_ID) AS MDSR759_XML_CS_LIST_T1)  )).getClobVal() as XML_QUERY
 FROM 
 (select distinct 
    CS_CONTEXT_NAME,
    CS_CONTEXT_VERSION,conte_idseq CONTEXT_ID
    from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW ,
    sbr.contexts
    where name=CS_CONTEXT_NAME
     )con