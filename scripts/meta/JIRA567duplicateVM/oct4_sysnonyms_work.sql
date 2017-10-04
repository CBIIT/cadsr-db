select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ,CONCEPT_NAME,VM_NAME,CONDR_IDSEQ,'FINAL' from
(
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM 
,VM_ID,VM_NAME,CONCEPT_NAME,CONDR_IDSEQ,VM_IDSEQ from
(
select VM_ID,VM_IDSEQ,VM.LONG_NAME VM_NAME,CN.LONG_NAME CONCEPT_NAME,VM.CONDR_IDSEQ
from SBR.VALUE_MEANINGS VM,
SBREXT.CON_DERIVATION_RULES_EXT DER,
SBREXT.CONCEPTS_EXT CN,
(
 select COUNT(*),CONDR_IDSEQ from SBR.VALUE_MEANINGS VM
 where   UPPER(ASL_NAME) not like '%RETIRED%' AND CONDR_IDSEQ is not null
 GROUP BY CONDR_IDSEQ HAVING COUNT(*)>1
 )DUP
 where   VM.CONDR_IDSEQ=DER.CONDR_IDSEQ
 AND VM.CONDR_IDSEQ=DUP.CONDR_IDSEQ
 and DER.NAME=CN.PREFERRED_NAME
 AND UPPER(VM.ASL_NAME) not like '%RETIRED%'
 AND TRIM(UPPER(VM.LONG_NAME)) =TRIM(UPPER(CN.LONG_NAME))
 AND instr(DER.NAME,'C45255')=0
 ))
 where FIN_VM=VM_ID
 UNION
  select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ,CONCEPT_NAME,VM_NAME,CONDR_IDSEQ,'FINAL' from
(
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM 
,VM_ID,VM_NAME,CONCEPT_NAME,CONDR_IDSEQ,VM_IDSEQ from
(
 SELECT VM_ID,VM_IDSEQ,trim(UPPER(CONCEPT_NAME))CONCEPT_NAME,trim(UPPER(LONG_NAME)) VM_NAME,VM.CONDR_IDSEQ,trim(UPPER(vm.DESCRIPTION)) VM_DESCRIPTION
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
 
 ORDER BY 4,2 desc ;
 
 select*from SBREXT.MDSR_VM_DUP_REF where FIN_VM<>VM_ID;
 
 exec SBREXT.MDSR_INSERT_VM_FINAL_DUP_REF;
 exec SBREXT.META_INSERT_CONCEPT_SYN;
 
 select distinct Rf.FIN_VM,Rf.FIN_IDSEQ ,vm.VM_ID,vm.VM_IDSEQ,SBREXT.MDSR_GET_CONCEPT_SYN(CONCEPTS_CODE,vm.LONG_NAME),CONCEPTS_CODE,CONCEPTS_NAME,vm.LONG_NAME,rf.CONDR_IDSEQ 
 FROM SBREXT.MDSR_VM_DUP_REF RF ,SBR.VALUE_MEANINGS VM 
 where Vm.CONDR_IDSEQ=RF.CONDR_IDSEQ
 AND UPPER(VM.ASL_NAME) not like '%RETIRED%'
AND  instr(CONCEPTS_CODE,':')=0
and (TRIM(upper(CONCEPTS_NAME))<>trim(upper(vm.LONG_NAME)))
and(instr(trim(upper(vm.LONG_NAME)),TRIM(upper(CONCEPTS_NAME)))>0)
and SBREXT.MDSR_GET_CONCEPT_SYN(CONCEPTS_CODE,vm.LONG_NAME)=0
 
 --delete  from SBREXT.MDSR_VM_DUP_REF;
  --delete  from SBREXT.MDSR_SYNONYMS_XML;
 
 
 
 SELECT *
FROM SBREXT.MDSR_CONCEPTS_SYNONYMS where TRIM(upper(CODE))=TRIM(upper('C15336'))
and TRIM(upper(SYNONYM_NAME))= TRIM(upper(p_NAME));


CREATE INDEX concept_sysn_idx
  ON SBREXT.MDSR_CONCEPTS_SYNONYMS(code);
  
  
  select * from SBREXT.MDSR_SYNONYMS_XML where CODE='C15336'