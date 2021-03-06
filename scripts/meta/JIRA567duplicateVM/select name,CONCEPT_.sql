select name,CONCEPT_NAME from (
SELECT distinct NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME--,trim(UPPER(VM.LONG_NAME)) VM_NAME,vm.CONDR_IDSEQ
--,trim(UPPER(vm.DESCRIPTION)) VM_DESCRIPTION,trim(UPPER(c.PREFERRED_DEFINITION)) CONCEPT_PREFERRED_DEFINITION

FROM  SBR.VALUE_MEANINGS VM,
SBREXT.CON_DERIVATION_RULES_EXT DR,
 sbrext.concepts_ext  c ,
 (select count(*),CONDR_IDSEQ from SBR.VALUE_MEANINGS VM 
 where  UPPER(ASL_NAME) not like '%RETIRED%' and CONDR_IDSEQ is not null
 having count(*)>1GROUP BY CONDR_IDSEQ )VW
 
where    VW.CONDR_IDSEQ=VM.CONDR_IDSEQ
AND  VM.CONDR_IDSEQ=DR.CONDR_IDSEQ
AND DR.name=c.preferred_name
AND DR.NAME not in ('C18031','C28427','C25450','C25250','C25484','C102844','C61376',
'C25258','C74601','C15191','C49161','C82650','C25666','C106146','C102844' ,'C106146' ,
'C106172' ,'C106432' ,'C120468' ,'C12412' ,'C12445' ,'C1267' ,'C12736' ,'C1297' ,'C1311' 
,'C14209' ,'C1499' ,'C15191' ,'C15232' ,'C15421' ,'C1607' ,'C17211' ,'C18002' ,'C18031' 
,'C2265' ,'C2322' ,'C25250' ,'C25258' ,'C25342' ,'C25450' ,'C25458' ,'C25484' ,'C25594' 
,'C25640' ,'C25666' ,'C28343' ,'C28427' ,'C28554' ,'C3114' ,'C318' ,'C3262' ,'C37987' 
,'C40412' ,'C42620' ,'C48282' ,'C48500' ,'C48813' ,'C49161' ,'C50764' ,'C53279' ,'C61376' 
,'C62220' ,'C62559' ,'C63351' ,'C74601' ,'C82650' ,'C86024' ,'C88791' ,'C900' ,'C90025' ,'C91215' ,'C94226')
AND instr(trim(C.LONG_NAME),' ')>0
AND instr(trim(VM.LONG_NAME),' ')>0
AND substr (upper(trim(c.preferred_name)),1,1)='C'
AND instr(dr.name,':')=0
and UPPER(VM.ASL_NAME) not like '%RETIRED%'
and trim(UPPER(VM.LONG_NAME))<>trim(UPPER(C.LONG_NAME)) --escape 's' 
--and (instr(trim(UPPER(VM.LONG_NAME)),trim(UPPER(C.LONG_NAME)))>0 or instr(trim(UPPER(C.LONG_NAME)),trim(UPPER(VM.LONG_NAME)))>0 )
and  not regexp_like(trim(VM.long_name), '^[0-9]+$')


MINUS 
SELECT distinct NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME--,trim(UPPER(VM.LONG_NAME)) VM_NAME,vm.CONDR_IDSEQ
--,trim(UPPER(vm.DESCRIPTION)) VM_DESCRIPTION,trim(UPPER(c.PREFERRED_DEFINITION)) CONCEPT_PREFERRED_DEFINITION

FROM  SBR.VALUE_MEANINGS VM,
SBREXT.CON_DERIVATION_RULES_EXT DR,
 sbrext.concepts_ext  c ,
 (select count(*),CONDR_IDSEQ from SBR.VALUE_MEANINGS VM 
 where  UPPER(ASL_NAME) not like '%RETIRED%' and CONDR_IDSEQ is not null
 having count(*)>1GROUP BY CONDR_IDSEQ )VW
 
where    VW.CONDR_IDSEQ=VM.CONDR_IDSEQ
AND  VM.CONDR_IDSEQ=DR.CONDR_IDSEQ
AND DR.name=c.preferred_name
AND DR.NAME not in ('C18031','C28427','C25450','C25250','C25484','C102844','C61376',
'C25258','C74601','C15191','C49161','C82650','C25666','C106146','C102844' ,'C106146' ,
'C106172' ,'C106432' ,'C120468' ,'C12412' ,'C12445' ,'C1267' ,'C12736' ,'C1297' ,'C1311' 
,'C14209' ,'C1499' ,'C15191' ,'C15232' ,'C15421' ,'C1607' ,'C17211' ,'C18002' ,'C18031' 
,'C2265' ,'C2322' ,'C25250' ,'C25258' ,'C25342' ,'C25450' ,'C25458' ,'C25484' ,'C25594' 
,'C25640' ,'C25666' ,'C28343' ,'C28427' ,'C28554' ,'C3114' ,'C318' ,'C3262' ,'C37987' 
,'C40412' ,'C42620' ,'C48282' ,'C48500' ,'C48813' ,'C49161' ,'C50764' ,'C53279' ,'C61376' 
,'C62220' ,'C62559' ,'C63351' ,'C74601' ,'C82650' ,'C86024' ,'C88791' ,'C900' ,'C90025' ,'C91215' ,'C94226')
AND instr(trim(C.LONG_NAME),' ')=0
AND instr(trim(VM.LONG_NAME),' ')=0
AND instr(dr.name,':')=0
and UPPER(VM.ASL_NAME) not like '%RETIRED%'
and trim(UPPER(VM.LONG_NAME))<>trim(UPPER(C.LONG_NAME)) --escape 's' 
and (instr(trim(UPPER(VM.LONG_NAME)),trim(UPPER(C.LONG_NAME)))>0  )
and  not regexp_like(trim(VM.long_name), '^[0-9]+$')
and substr(trim(UPPER(VM.LONG_NAME)),-1,1)='S')


order by CONCEPT_NAME,NAME;