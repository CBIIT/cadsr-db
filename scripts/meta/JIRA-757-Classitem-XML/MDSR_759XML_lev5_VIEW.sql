 create or replace view MDSR_759XML_5CSI_LEVEL_VIEW
 as select CS_CONTEXT_NAME,
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
                                SELECT v1.CSI_LEVEL,
                                       v1.CSI_NAME,
                                       v1.CSI_ID,    
                                       v1.CSI_VERSION,    
                                       v1.CSITL_NAME,    
                                       v1.DESCRIPTION,   
                                       v1.CSI_IDSEQ,
                                       v1.PARENT_CSI_IDSEQ,
                                       v1.CS_CSI_IDSEQ,                                      
                                       v1.LEAF,
                             CAST (
                             MULTISET (SELECT v2.CSI_LEVEL,
                                       v2.CSI_NAME,
                                       v2.CSI_ID,    
                                       v2.CSI_VERSION,    
                                       v2.CSITL_NAME,    
                                       v2.DESCRIPTION,   
                                       v2.CSI_IDSEQ,
                                       v2.PARENT_CSI_IDSEQ,
                                        v2.CS_CSI_IDSEQ,
                                       v1.CSI_ID,    
                                       v1.VERSION,  
                                        v2.LEAF,
                             CAST (
                             MULTISET (SELECT v3.CSI_LEVEL,
                                       v3.CSI_NAME,
                                       v3.CSI_ID,    
                                       v3.CSI_VERSION,    
                                       v3.CSITL_NAME,    
                                       v3.DESCRIPTION,   
                                       v3.CSI_IDSEQ,
                                       v3.PARENT_CSI_IDSEQ,
                                        v3.CS_CSI_IDSEQ,
                                       v2.CSI_ID,    
                                       v2.VERSION,  
                                        v3.LEAF,
                             CAST (
                             MULTISET (
                                SELECT   v4.CSI_LEVEL,
                                       v4.CSI_NAME,
                                       v4.CSI_ID,    
                                       v4.CSI_VERSION,    
                                       v4.CSITL_NAME,    
                                       v4.DESCRIPTION,   
                                       v4.CSI_IDSEQ,
                                       v4.PARENT_CSI_IDSEQ,
                                        v4.CS_CSI_IDSEQ,
                                       v3.CSI_ID,    
                                       v3.VERSION,  
                                        v4.LEAF,
                             CAST (
                             MULTISET (
                                SELECT v5.CSI_LEVEL,
                                       v5.CSI_NAME,
                                       v5.CSI_ID,    
                                       v5.CSI_VERSION,    
                                       v5.CSITL_NAME,    
                                       v5.DESCRIPTION,   
                                       v5.CSI_IDSEQ,
                                       v5.PARENT_CSI_IDSEQ,
                                       v5.CS_CSI_IDSEQ,
                                       v4.CSI_ID,    
                                       v4.VERSION,  
                                       v5.LEAF
                                  FROM SBREXT.MDSR_CLASS_SCHEME_ITEM_VW v5
                                  --   ,(select* from  SBREXT.MDSR_CLASS_SCHEME_ITEM_VW  where CSI_LEVEL=4)v4
                                      WHERE v5.PARENT_CSI_IDSEQ=v4.CS_CSI_IDSEQ
                                      and v5.CSI_LEVEL=5
                                     
                              --   group by csi.CSI_LEVEL,   csi.CSI_ID                                     
                              order by  v5.CSI_ID       ) AS MDSR759_XML_CSI_LIST5_T)  "level5"
                              from 
                              SBREXT.MDSR_CLASS_SCHEME_ITEM_VW V4 
                              where V4.CSI_LEVEL=4
                              and v4.PARENT_CSI_IDSEQ=v3.CS_CSI_IDSEQ
                                 order by  v4.CSI_ID       ) AS MDSR759_XML_CSI_LIST4_T)       "level4"
                              from 
                              SBREXT.MDSR_CLASS_SCHEME_ITEM_VW V3 where CSI_LEVEL=3--4551586
                              and v3.PARENT_CSI_IDSEQ=v2.CS_CSI_IDSEQ
                                 order by  v3.CSI_ID       ) AS MDSR759_XML_CSI_LIST3_T)       "level3"
                                 from 
                              SBREXT.MDSR_CLASS_SCHEME_ITEM_VW V2 where CSI_LEVEL=2
                              and v2.PARENT_CSI_IDSEQ=v1.CS_CSI_IDSEQ
                                 order by  v2.CSI_ID       ) AS MDSR759_XML_CSI_LIST2_T)       "level2"
                                 from 
                              SBREXT.MDSR_CLASS_SCHEME_ITEM_VW V1 where CSI_LEVEL=1
                              and V1.CS_IDSEQ=cl.CS_IDSEQ
                               order by  v1.CSI_ID       ) AS MDSR759_XML_CSI_LIST1_T)      "ClassificationItemList"
                     FROM  (select distinct CS_IDSEQ,CS_ID,
    PREFERRED_NAME,
    LONG_NAME,
    PREFERRED_DEFINITION,
    VERSION,
    ASL_NAME,
    CS_CONTEXT_NAME,
    CS_CONTEXT_VERSION,
    conte_idseq
    from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW 
       )cl
      where cl.conte_idseq= con.CONTEXT_ID--'D9344734-8CAF-4378-E034-0003BA12F5E7' --'EB011825-878C-E0E9-E040-BB89AD437FDD''D8D849BC-68CF-10AA-E040-BB89AD430348'--
order by  CS_ID) AS MDSR759_XML_CS_L5_LIST_T)   "ClassificationList"
 FROM 
 (select distinct 
    CS_CONTEXT_NAME,
    CS_CONTEXT_VERSION,conte_idseq CONTEXT_ID
    from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW 
  -- where conte_idseq=  'D9344734-8CAF-4378-E034-0003BA12F5E7'--'D8D849BC-68CF-10AA-E040-BB89AD430348'--CS_CONTEXT_NAME='AECC'
   order by CS_CONTEXT_NAME  )con
     
     
   /* -- select* from MDSR_759XML_5CSI_LEVEL_VIEW where CS_CONTEXT_NAME='COG'
     
     --  select count(*) , CS_CONTEXT_NAME ,conte_idseq from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
     group by CS_CONTEXT_NAME ,conte_idseq
     order by 1
     select * from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW
     select  
   *
    from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW where CS_CONTEXT_NAME='COG'
    where conte_idseq=  'D8D849BC-68CF-10AA-E040-BB89AD430348'*/