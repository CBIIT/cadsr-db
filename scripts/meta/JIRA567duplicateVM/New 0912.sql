SELECT distinct NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME,VM.date_created,trim(UPPER(VM.LONG_NAME)) VM_NAME,trim(UPPER(vm.DESCRIPTION)) VM_DESCRIPTION,trim(UPPER(c.PREFERRED_DEFINITION)) CONCEPT_PREFERRED_DEFINITION,vm.CONDR_IDSEQ
FROM  SBR.VALUE_MEANINGS VM,
SBREXT.CON_DERIVATION_RULES_EXT DR,
 sbrext.concepts_ext  c ,
 (select count(*),CONDR_IDSEQ from SBR.VALUE_MEANINGS VM 
 where  UPPER(ASL_NAME) not like '%RETIRED%' and CONDR_IDSEQ is not null
 having count(*)>1GROUP BY CONDR_IDSEQ )VW
 
where    VW.CONDR_IDSEQ=VM.CONDR_IDSEQ
AND  VM.CONDR_IDSEQ=DR.CONDR_IDSEQ
AND DR.name=c.preferred_name
--AND instr(trim(C.LONG_NAME),' ')=0
AND instr(trim(VM.LONG_NAME),' ')=0
AND instr(dr.name,':')=0
and UPPER(VM.ASL_NAME) not like '%RETIRED%'
and substr(trim(UPPER(VM.LONG_NAME)),1,length(trim(UPPER(C.LONG_NAME)))) <>trim(UPPER(C.LONG_NAME)) --escape 's' 
--and (instr(trim(UPPER(VM.LONG_NAME)),trim(UPPER(C.LONG_NAME)))>0 or instr(trim(UPPER(C.LONG_NAME)),trim(UPPER(VM.LONG_NAME)))>0 )
and  NOT regexp_like(trim(VM.long_name), '^[0-9]+$')
--and regexp_like(trim(VM.LONG_NAME),trim(C.LONG_NAME),'i')
--and instr(NAME,'C45255')=0
--and instr(NAME,'C18002')>0
--AND VM.CONDR_IDSEQ='F37D0428-E63A-6787-E034-0003BA3F9857'
order by CONCEPT_NAME,NAME,VM_NAME,VM.date_created;


----
SELECT distinct NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME,trim(UPPER(VM.LONG_NAME)) VM_NAME,trim(UPPER(vm.DESCRIPTION)) VM_DESCRIPTION,trim(UPPER(c.PREFERRED_DEFINITION)) CONCEPT_PREFERRED_DEFINITION,vm.CONDR_IDSEQ
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
and substr(trim(UPPER(VM.LONG_NAME)),1,length(trim(UPPER(C.LONG_NAME))))<>trim(UPPER(C.LONG_NAME)) --escape 's' 
--and (instr(trim(UPPER(VM.LONG_NAME)),trim(UPPER(C.LONG_NAME)))>0 or instr(trim(UPPER(C.LONG_NAME)),trim(UPPER(VM.LONG_NAME)))>0 )
and  NOT regexp_like(trim(VM.long_name), '^[0-9]+$')
--and regexp_like(trim(VM.LONG_NAME),trim(C.LONG_NAME),'i')
and substr(trim(UPPER(VM.LONG_NAME)),-1,1)='S'
order by CONCEPT_NAME,NAME,VM_NAME;

----




SELECT VM.VM_ID,VM.CONDR_IDSEQ,NAME,LONG_NAME_AG,LONG_NAME
FROM  SBR.VALUE_MEANINGS VM,
(SELECT M.CONDR_IDSEQ,name, LISTAGG(M.LONG_NAME,' ') WITHIN GROUP (ORDER BY M.ELM_ORDER) as LONG_NAME_AG
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
and trim(UPPER(VM.LONG_NAME))<>trim(UPPER(LONG_NAME_AG))
and instr(NAME,'C45255')=0
order by VM.CONDR_IDSEQ,LONG_NAME,VM.VM_ID;


-------------------------plurales
SELECT distinct NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME,trim(UPPER(VM.LONG_NAME)) LONG_NAME,trim(UPPER(vm.DESCRIPTION))VM_DESCRIPTION,
trim(UPPER(c.PREFERRED_DEFINITION))CONCEPT_DEF,vm.CONDR_IDSEQ
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
and trim(UPPER(VM.LONG_NAME))<>trim(UPPER(C.LONG_NAME)) 
and (instr(trim(UPPER(VM.LONG_NAME)),trim(UPPER(C.LONG_NAME)))>0  )
and  NOT regexp_like(trim(VM.long_name), '^[0-9]+$')
MINUS
SELECT distinct NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME,trim(UPPER(VM.LONG_NAME)) LONG_NAME,trim(UPPER(vm.DESCRIPTION))VM_DESCRIPTION,
trim(UPPER(c.PREFERRED_DEFINITION))CONCEPT_DEF,vm.CONDR_IDSEQ
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
and substr(trim(UPPER(VM.LONG_NAME)),1,length(trim(UPPER(C.LONG_NAME)))) =trim(UPPER(C.LONG_NAME)) --escape 's' 
and trim(UPPER(VM.LONG_NAME))<>trim(UPPER(C.LONG_NAME)) 
and (instr(trim(UPPER(VM.LONG_NAME)),trim(UPPER(C.LONG_NAME)))>0  )
and  NOT regexp_like(trim(VM.long_name), '^[0-9]+$')
and substr(trim(UPPER(VM.LONG_NAME)),-1,1)='S'
--and regexp_like(trim(VM.LONG_NAME),trim(C.LONG_NAME),'i')
--and instr(NAME,'C45255')=0
--and instr(NAME,'C18002')>0
--AND VM.CONDR_IDSEQ='F37D0428-E63A-6787-E034-0003BA3F9857'
order by CONCEPT_NAME,LONG_NAME;


---------------------numbers
select name,CONCEPT_NAME,CONDR_IDSEQ from (
SELECT distinct NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME,vm.CONDR_IDSEQ--,trim(UPPER(VM.LONG_NAME)) VM_NAME
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
--AND instr(trim(C.LONG_NAME),' ')=0
--AND instr(trim(VM.LONG_NAME),' ')=0
AND instr(dr.name,':')=0
and UPPER(VM.ASL_NAME) not like '%RETIRED%'
and trim(UPPER(VM.LONG_NAME))<>trim(UPPER(C.LONG_NAME)) --escape 's' 
--and (instr(trim(UPPER(VM.LONG_NAME)),trim(UPPER(C.LONG_NAME)))>0 or instr(trim(UPPER(C.LONG_NAME)),trim(UPPER(VM.LONG_NAME)))>0 )
and  not regexp_like(trim(VM.long_name), '^[0-9]+$')


MINUS 
SELECT distinct NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME,vm.CONDR_IDSEQ--,trim(UPPER(VM.LONG_NAME)) VM_NAME
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