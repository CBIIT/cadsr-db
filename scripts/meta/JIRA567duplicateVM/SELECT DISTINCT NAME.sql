SELECT DISTINCT NAME,trim(UPPER(CONCEPT_NAME))CONCEPT_NAME
FROM  SBR.VALUE_MEANINGS VM,
(SELECT M.CONDR_IDSEQ,name, LISTAGG(M.LONG_NAME,' ') WITHIN GROUP (ORDER BY M.ELM_ORDER) as CONCEPT_NAME
FROM  (select CONDR_IDSEQ,name,spl.preferred_name,ELM_ORDER,LONG_NAME
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
  where spl.preferred_name=c.preferred_name) M
GROUP BY name,M.CONDR_IDSEQ)VW,
 (select count(*),CONDR_IDSEQ from SBR.VALUE_MEANINGS VM 
 where  UPPER(ASL_NAME) not like '%RETIRED%'
 having count(*)>1GROUP BY CONDR_IDSEQ )DR

where    VW.CONDR_IDSEQ=VM.CONDR_IDSEQ
AND  VW.CONDR_IDSEQ=DR.CONDR_IDSEQ
and UPPER(ASL_NAME) not like '%RETIRED%'
and trim(UPPER(VM.LONG_NAME))<>trim(UPPER(CONCEPT_NAME))
and instr(NAME,'C45255')=0

minus
SELECT distinct dr.NAME NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME
FROM  SBR.VALUE_MEANINGS VM,
SBREXT.CON_DERIVATION_RULES_EXT DR,
 sbrext.concepts_ext  c ,
 (select count(*),CONDR_IDSEQ from SBR.VALUE_MEANINGS VM 
 where  UPPER(ASL_NAME) not like '%RETIRED%' and CONDR_IDSEQ is not null
 having count(*)>1GROUP BY CONDR_IDSEQ )VW
 
where    VW.CONDR_IDSEQ=VM.CONDR_IDSEQ
AND  VM.CONDR_IDSEQ=DR.CONDR_IDSEQ
AND DR.name=c.preferred_name
AND instr(dr.name,':')=0
and UPPER(VM.ASL_NAME) not like '%RETIRED%'
and trim(UPPER(VM.LONG_NAME))<>trim(UPPER(C.LONG_NAME))
order by NAME,CONCEPT_NAME;