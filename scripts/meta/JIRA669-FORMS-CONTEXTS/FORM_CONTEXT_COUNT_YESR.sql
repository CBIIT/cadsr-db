 select to_CHAR(f.date_created,'YYYY') Year,count(*) "Forms count", CF_CONTE.NAME Context
                 FROM  SBREXT.QUEST_CONTENTS_EXT  F,
                  SBR.CONTEXTS CF_conte         
                  
                  where    F.CONTE_IDSEQ=CF_conte.CONTE_IDSEQ 
                   and QTL_NAME IN ('CRF','TEMPLATE')                 
                  group by CF_CONTE.NAME,to_CHAR(f.date_created,'YYYY')
                  order by 1,3
                  