 SELECT
   XMLELEMENT( 
   "Context",CS_CONTEXT_NAME,
   (SELECT XMLAgg( XMLElement("CLASSIFICATION"  ,
         XMLForest( CS_ID as "CS_ID",
         
         VERSION as "VERSION",
         (SELECT XMLAgg( XMLElement("CLASSIFICATION"  ,
         XMLForest( CSI_ID as "CSI_ID",
         
         CSI_VERSION as "VERSION"
         ) )) from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW cli
         where cli.CS_IDSEQ=cl.CS_IDSEQ
         and CSI_LEVEL=1
        
        ) as CSI
         ) )) from (select distinct CS_IDSEQ,CS_ID,
    PREFERRED_NAME,
    LONG_NAME,
    PREFERRED_DEFINITION,
    VERSION,
    ASL_NAME,
    CS_CONTEXT_NAME,
    CS_CONTEXT_VERSION
    from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW order by CS_ID ) cl
         where cl.CS_CONTEXT_NAME=c.CS_CONTEXT_NAME
         
        
        ) )--select*
from (select distinct CS_CONTEXT_NAME from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW 
order by CS_CONTEXT_NAME) c

GROUP BY CS_CONTEXT_NAME
(
    CS_IDSEQ,
    
    select distinct CSI_CONTEXT_NAME from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW ;
    
SELECT sys_xmlgen(
   XMLELEMENT( 
   "Context",CSI_CONTEXT_NAME),
    XMLElement("CLASSIFICATIONS"
                             , (SELECT XMLAgg( XMLElement("CLASSIFICATION"  ,
         XMLForest( CSI_ID as "CSI_ID",
         
         VERSION as "VERSION"
         ) )) from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW cl
         where cl.CSI_CONTEXT_NAME=c.CSI_CONTEXT_NAME
        
        ) )).getClobVal() as XML_QUERY--select*
from (select distinct CSI_CONTEXT_NAME from SBREXT.MDSR_CLASS_SCHEME_ITEM_VW ) c

GROUP BY CSI_CONTEXT_NAME