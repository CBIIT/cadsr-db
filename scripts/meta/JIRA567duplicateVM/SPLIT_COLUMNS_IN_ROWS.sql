CREATE TABLE SBREXT.MDSR_CONDR_ID_CONCEPT_EXT
(  CONDR_ID  CHAR(60) ,
   CONDR_ID_NAME CHAR(100),
    CONCEPT_CODE CHAR(60),
    ELM_ORDER NUMBER);
  --  DROP table SBREXT.MDSR_CONDR_ID_CONCEPT_EXT;
    
    select* from SBREXT.MDSR_CONDR_ID_CONCEPT_CODE;
    
 INSERT into    SBREXT.MDSR_CONDR_ID_CONCEPT_EXT
 select distinct
 CONDR_ID,CONCEPT_CODE,
 trim(regexp_substr(replace(replace(CONCEPT_CODE,'Rh Negative Blood Group','C76252'),'Rh Positive Blood Group','C76251'), '[^:]+', 1, levels.column_value)) as preferred_name,levels.column_value ELM_ORDER
from 
 (select *from SBREXT.MDSR_CONDR_ID_CONCEPT_CODE 
 where  instr(CONCEPT_CODE,':')>0) t,
 table(cast(multiset(select level from dual connect by level <= length (regexp_replace(t.CONCEPT_CODE, '[^:]+')) + 1) as sys.OdciNumberList))
 levels
 order by CONCEPT_CODE,CONDR_ID,ELM_ORDER;
 
 
 select distinct TRIM(CONCEPT_CODE) from SBREXT.MDSR_CONDR_ID_CONCEPT_EXT
 MINUS
 select distinct code from SBREXT.MDSR_CONCEPTS_SYNONYMS;
 
 INSERT into  SBREXT.MDSR_CONCEPTS_SYNONYMS
 SELECT distinct trim(NAME),trim(UPPER(C.LONG_NAME)) CONCEPT_NAME,trim(UPPER(VM.LONG_NAME)) VM_NAME--,trim(UPPER(vm.DESCRIPTION)) VM_DESCRIPTION,trim(UPPER(c.PREFERRED_DEFINITION)) CONCEPT_PREFERRED_DEFINITION,vm.CONDR_IDSEQ
FROM  SBR.VALUE_MEANINGS VM,
SBREXT.CON_DERIVATION_RULES_EXT DR,
 sbrext.concepts_ext  c ,
 (select count(*),CONDR_IDSEQ from SBR.VALUE_MEANINGS VM 
 where  UPPER(ASL_NAME) not like '%RETIRED%' and CONDR_IDSEQ is not null
 having count(*)>1GROUP BY CONDR_IDSEQ )VW
 
where    VW.CONDR_IDSEQ=VM.CONDR_IDSEQ
AND  VM.CONDR_IDSEQ=DR.CONDR_IDSEQ
AND DR.name=c.preferred_name
AND instr(trim(C.LONG_NAME),' ')=0
AND instr(trim(VM.LONG_NAME),' ')=0
AND instr(dr.name,':')=0
and UPPER(VM.ASL_NAME) not like '%RETIRED%'
and trim(UPPER(VM.LONG_NAME))<>trim(UPPER(C.LONG_NAME)) --escape 's' 
--and (instr(trim(UPPER(VM.LONG_NAME)),trim(UPPER(C.LONG_NAME)))>0 or instr(trim(UPPER(C.LONG_NAME)),trim(UPPER(VM.LONG_NAME)))>0 )
and   regexp_like(trim(VM.long_name), '^[0-9]+$')

 MINUS
 select CODE,CONCEPT_NAME,synonym_name from SBREXT.MDSR_CONCEPTS_SYNONYMS

order by CONCEPT_NAME,NAME,VM_NAME;



select  distinct  CODE from SBREXT.MDSR_CONCEPTS_SYNONYMS;