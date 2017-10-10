select count(*)FROM SBREXT.MDSR_VM_DUP_REF  where NVL(proc,'X')='FINAL';

select *FROM SBREXT.MDSR_VM_DUP_REF where proc<>'FINAL'
order by  5,1,3 desc;

  select count(*) from 
  ( select distinct CODE 
  --,CONCEPT_NAME 
   --,upper(trim(SYNONYM_NAME))
    
  FROM SBREXT.MDSR_CONCEPTS_SYNONYMS )
  
  create table SBREXT.MDSR_CONCEPTS_SYNONYMS_BK as select* FROM SBREXT.MDSR_CONCEPTS_SYNONYMS
  delete from SBREXT.MDSR_CONCEPTS_SYNONYMS
  
   exec SBREXT.MDSR_INSERT_CONCEPT_SYN;
   
   select*from SBREXT.MDSR_DUP_VM_ERR where date_created>sysdate-1;
   
   select*from SBREXT.MDSR_SYNONYMS_XML where code in (
    select distinct CODE from SBREXT.MDSR_SYNONYMS_XML where RESP_STATUS=200
    minus
   select distinct CODE    
  FROM SBREXT.MDSR_CONCEPTS_SYNONYMS) ;
   select *   
  FROM SBREXT.MDSR_CONCEPTS_SYNONYMS where code='C422';
  
  exec SBREXT.MDSR_INSERT_VM_FINAL_DUP_REF;
  execute SBREXT.MDSR_UPDATE_SYNONYMS_XML;
  
  
   select   NM.CONDR_IDSEQ,NM.NAME CONDR_IDSEQ,VM.VM_ID,VM.LONG_NAME,SBREXT.MDSR_GET_CONCEPT_SYN(NAME,vm.LONG_NAME)SYNON
 FROM
 SBR.VALUE_MEANINGS VM,
 (select CONDR_IDSEQ,NAME from
 (select count(*),VM.CONDR_IDSEQ,NAME from SBR.VALUE_MEANINGS VM ,
 SBREXT.CON_DERIVATION_RULES_EXT  X
 where  X.CONDR_IDSEQ=VM.CONDR_IDSEQ 
 AND  instr(NAME,':')=0
 and (ASL_NAME) not like '%RETIRED%'
 and instr(name,'C45255')=0 
 having count(*)>1GROUP BY VM.CONDR_IDSEQ,NAME )
minus
 select CONDR_IDSEQ,CONCEPTS_CODE from
 (select distinct CONDR_IDSEQ,CONCEPTS_CODE 
 FROM SBREXT.MDSR_VM_DUP_REF where instr(CONCEPTS_CODE,'C45255')=0))NM
 WHERE NM.CONDR_IDSEQ=VM.CONDR_IDSEQ 
 AND (ASL_NAME) not like '%RETIRED%'and SBREXT.MDSR_GET_CONCEPT_SYN(NAME,vm.LONG_NAME)=1
 order by name,VM_ID,SYNON desc;
  
 
 
 select NRF.CONDR_IDSEQ,NRF.NAME,LONG_NAME from
 SBR.VALUE_MEANINGS VM,
 (select CONDR_IDSEQ,NAME from
 (select count(*),VM.CONDR_IDSEQ,NAME from SBR.VALUE_MEANINGS VM ,
 SBREXT.CON_DERIVATION_RULES_EXT  X
 where  X.CONDR_IDSEQ=VM.CONDR_IDSEQ 
 AND  instr(NAME,':')>0
 and (ASL_NAME) not like '%RETIRED%'
 and instr(name,'C45255')=0 
 having count(*)>1GROUP BY VM.CONDR_IDSEQ,NAME )
minus
select distinct CONDR_IDSEQ,CONCEPTS_CODE 
 FROM SBREXT.MDSR_VM_DUP_REF where instr(CONCEPTS_CODE,'C45255')=0) NRF
 where  NRF.CONDR_IDSEQ=VM.CONDR_IDSEQ
ORDER BY NRF.NAME,LONG_NAME