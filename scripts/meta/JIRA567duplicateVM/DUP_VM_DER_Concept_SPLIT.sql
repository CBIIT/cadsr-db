create table SBREXT.MDSR_CON_DER_RULES_SPLIT as
select CONDR_IDSEQ,name,spl.preferred_name,ELM_ORDER,LONG_NAME
from
(select distinct
 CONDR_IDSEQ,name,
 trim(regexp_substr(name, '[^:]+', 1, levels.column_value)) as preferred_name,levels.column_value ELM_ORDER
from 
 (select *from SBREXT.CON_DERIVATION_RULES_EXT 
 
 where  instr(name,':')>0) t,
 table(cast(multiset(select level from dual connect by level <= length (regexp_replace(t.name, '[^:]+')) + 1) as sys.OdciNumberList))
  levels) spl,
  sbrext.concepts_ext  c
  where spl.preferred_name=c.preferred_name  
 
order by 1,2,ELM_ORDER,3 ;


SELECT CONDR_IDSEQ,name, LISTAGG(LONG_NAME,' ') WITHIN GROUP (ORDER BY LONG_NAME) as LONG_NAME_AG
FROM  SBREXT.MDSR_CON_DER_RULES_SPLIT
WHERE instr(NAME,'C45255')=0
GROUP BY name,CONDR_IDSEQ