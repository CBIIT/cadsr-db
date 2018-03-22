  SELECT de.DE_IDSEQ,QQ.QUES_IDSEQ,CAST (
             MULTISET (select
                   MDSR_FB_USECAT_XML('Mandatory','') ,
                      '0' ,
                     MDSR_FB_DE_DR_XML_T(
                     '0',
                     '0',
          MDSR_FB_VD_DR_XML_T(
                    'PRSN_WT_VAL'  ,
                    'NonEnumerated'   ,
                    'RELEASED'       ,
                    MDSR_FB_VDC_DR_XML_T('http://blankNode' ) ) ) 
from SBR.COMPLEX_DATA_ELEMENTS cdv,
       SBR.DATA_ELEMENTS DE     
       where  cdv.P_DE_IDSEQ = de.DE_IDSEQ    
       and de.DE_IDSEQ=QQ.de_idseq) as MDSR_FB_COM_DE_DR_XML_LIST_T)
        from SBREXT.MDSR_FB_QUESTION_MVW QQ
                                  where QQ.QUES_IDSEQ= '430203EE-CCBE-6162-E053-F662850A2532'