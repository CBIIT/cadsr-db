  select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ,name CONCEPTS_CODE,CONCEPT_NAME,VM_NAME,CONDR_IDSEQ,'FINAL' from
(
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM 
,VM_ID,VM_NAME,CONCEPT_NAME,name,CONDR_IDSEQ,VM_IDSEQ from
(
 SELECT VM_ID,VM_IDSEQ,name,trim(UPPER(CONCEPT_NAME))CONCEPT_NAME,trim(UPPER(LONG_NAME)) VM_NAME,VM.CONDR_IDSEQ,trim(UPPER(vm.DESCRIPTION)) VM_DESCRIPTION
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
and trim(UPPER(VM.LONG_NAME))=trim(UPPER(CONCEPT_NAME))
and instr(NAME,'C45255')=0
 ))
 where FIN_VM=VM_ID
 
 ORDER BY 4,2 desc;
 
 SELECT DISTINCT *
FROM SBREXT.MDSR_CONCEPTS_SYNONYMS 
where  instr(code,':')>0 order by code;

select count(*) from sbrext.concepts_ext where preferred_name like'C%'
create table SBREXT.MDSR_SYNONYMS_XML_1004 as select* FROM SBREXT.MDSR_SYNONYMS_XML