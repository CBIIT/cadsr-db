CREATE OR REPLACE procedure SBREXT.MDSR_INSERT_VM_FINAL_DUP_REF
as

V_error VARCHAR(300);
v_cnt0 number;
v_cnt1 number;
v_cnt2 number;
V_run number;


begin

delete from  SBREXT.MDSR_VM_DUP_REF where FIN_IDSEQ =VM_IDSEQ;
commit;
/**step1 
insert into MDSR_VM_DUP_REF  FINAL VM Records with CONDR_IDSEQ is not null
and Concepts Name not like "integer" and Concepts Name=VM.LONG_NAME
**/

select count(*) into V_cnt0 from SBREXT.MDSR_VM_DUP_REF  R
,SBREXT.CON_DERIVATION_RULES_EXT CN
where R.CONDR_IDSEQ=CN.CONDR_IDSEQ
AND instr(CN.NAME,'C45255')=0;

if V_cnt0=0 then
V_run:=1;
else
select max(RUN_NUMBER)+1 into V_run from SBREXT.MDSR_VM_DUP_REF  R
,SBREXT.CON_DERIVATION_RULES_EXT CN
where R.CONDR_IDSEQ=CN.CONDR_IDSEQ
AND instr(CN.NAME,'C45255')=0;
end if; 
INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PROC )
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ,name CONCEPTS_CODE,CONCEPT_NAME,VM_NAME,CONDR_IDSEQ,'FINAL' from
(
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM 
,VM_ID,VM_NAME,CONCEPT_NAME,CONDR_IDSEQ,VM_IDSEQ ,name from
(
select VM_ID,VM_IDSEQ,VM.LONG_NAME VM_NAME,CN.LONG_NAME CONCEPT_NAME,VM.CONDR_IDSEQ,name
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
 
 ORDER BY 4,2 desc ;
--and vm.CONDR_IDSEQ='F37D0428-BBB6-6787-E034-0003BA3F9857'
commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);     
      insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.MDSR_VM_DUP_REF','NA','NA','NA',V_error,sysdate );
  commit;
end;

/**step2 
insert into MDSR_VM_DUP_REF DUP Records for VM with CONDR_IDSEQ is not null
and Concepts Name not like "integer" 
a.FIN_VM FINAL VN public ID
a.vm_id RETIRED VM public ID**/

select distinct Rf.FIN_VM,Rf.FIN_IDSEQ ,vm.VM_ID,vm.VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,vm.LONG_NAME,rf.CONDR_IDSEQ ,SBREXT.MDSR_GET_CONCEPT_SYN(CONCEPTS_CODE,vm.LONG_NAME)
 FROM SBREXT.MDSR_VM_DUP_REF RF ,SBR.VALUE_MEANINGS VM 
 where Vm.CONDR_IDSEQ=RF.CONDR_IDSEQ
 AND UPPER(VM.ASL_NAME) not like '%RETIRED%'
 --AND  instr(CONCEPTS_CODE,':')=0
 and TRIM(upper(CONCEPTS_NAME))<>trim(upper(vm.LONG_NAME))
 and SBREXT.MDSR_GET_CONCEPT_SYN(CONCEPTS_CODE,vm.LONG_NAME)=0
 AND Rf.FIN_IDSEQ<>vm.VM_IDSEQ;
 ----records with no match to concepts/synonyms
 select CONDR_IDSEQ,NAME from
 (select count(*),VM.CONDR_IDSEQ,NAME from SBR.VALUE_MEANINGS VM ,
 SBREXT.CON_DERIVATION_RULES_EXT  X
 where  X.CONDR_IDSEQ=VM.CONDR_IDSEQ and
 (ASL_NAME) not like '%RETIRED%'
 having count(*)>1GROUP BY VM.CONDR_IDSEQ,NAME )
minus
 select CONDR_IDSEQ,CONCEPTS_CODE from
 (select distinct CONDR_IDSEQ,CONCEPTS_CODE 
 FROM SBREXT.MDSR_VM_DUP_REF where PROC='FINAL');

/**step3 
insert into MDSR_VM_DUP_REF Records for VM with CONDR_IDSEQ is null
a.FIN_VM FINAL VN public ID
a.vm_id RETIRED VM public ID**/
begin
select count(*) into V_cnt1 from SBREXT.MDSR_VM_DUP_REF where CONDR_IDSEQ is  null;
if V_cnt1=0 then
V_run:=1;
else
select max(RUN_NUMBER)+1 into V_cnt1 from SBREXT.MDSR_VM_DUP_REF where CONDR_IDSEQ is null;
end if;
INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_NAME,LONG_NAME,PREFERRED_DEFINITION,DATE_CREATED,  RUN_NUMBER )
select  
a.FIN_VM,b.VM_IDSEQ,a.vm_id,a.VM_IDSEQ,NULL,a.LONG_NAME,a.PREFERRED_DEFINITION,SYSDATE, V_cnt1
from
(select  FIN_VM,vm_id,VM_IDSEQ,LONG_NAME,PREFERRED_DEFINITION
from (
select max(VM_ID) over (partition by UPPER(trim(LONG_NAME)),UPPER(trim(PREFERRED_DEFINITION)) order by UPPER(trim(LONG_NAME)),UPPER(trim(PREFERRED_DEFINITION)) ) as FIN_VM,

VM_ID,VM_IDSEQ,UPPER(trim(LONG_NAME))LONG_NAME,UPPER(trim(PREFERRED_DEFINITION))PREFERRED_DEFINITION,CONDR_IDSEQ
from 
SBR.VALUE_MEANINGS 
where   UPPER(ASL_NAME) not like '%RETIRED%'
and UPPER(trim(LONG_NAME))='NOT EVALUATED'--'9 MONTHS' 
and CONDR_IDSEQ is null)
where FIN_VM<>VM_ID 
MINUS
select  FIN_VM,vm_id,VM_IDSEQ,UPPER(trim(LONG_NAME))LONG_NAME,UPPER(trim(PREFERRED_DEFINITION))PREFERRED_DEFINITION from SBREXT.MDSR_VM_DUP_REF
where  CONCEPTS_NAME is null and CONDR_IDSEQ is null)a,
SBR.VALUE_MEANINGS b
where a.FIN_VM=b.VM_ID;
commit;

EXCEPTION
    WHEN others THEN
     V_error := substr(SQLERRM,1,200);     
      insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBREXT.MDSR_VM_DUP_REF','NA','NA','NA',V_error,sysdate );
  commit;
end;

begin

/**Insert of duplicate VMs with Concepts(CONDR_IDSEQ is NOT NULL) and  Concepts Name like "integer".**/
select count(*) into V_cnt0 from SBREXT.MDSR_VM_DUP_REF  R
,CON_DERIVATION_RULES_EXT CN
where R.CONDR_IDSEQ=CN.CONDR_IDSEQ
AND instr(CN.NAME,'C45255')>0;

if V_cnt0=0 then
V_run:=1;
else
select max(RUN_NUMBER)+1 into V_run from SBREXT.MDSR_VM_DUP_REF R
,CON_DERIVATION_RULES_EXT CN
where R.CONDR_IDSEQ=CN.CONDR_IDSEQ
AND instr(CN.NAME,'C45255')>0;
end if; 
INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_NAME,LONG_NAME,PREFERRED_DEFINITION,DATE_CREATED,  RUN_NUMBER )
select  
a.FIN_VM,b.VM_IDSEQ,a.vm_id,a.VM_IDSEQ,a.CONCEPTS_NAME,a.LONG_NAME,a.PREFERRED_DEFINITION,SYSDATE, V_run
from
(select  FIN_VM,vm_id,VM_IDSEQ,CONDR_IDSEQ,CONCEPTS_NAME,long_name,trim(upper(PREFERRED_DEFINITION)) PREFERRED_DEFINITION
from (
select max(VM_ID) over  (partition by CN.NAME,trim(upper(CONCEPT_VALUE_AG)) order by CN.NAME,trim(upper(CONCEPT_VALUE_AG)) ) as FIN_VM,
VM_ID,VM_IDSEQ,CN.NAME||'::'||CONCEPT_VALUE_AG CONCEPTS_NAME,VM.CONDR_IDSEQ,vm.long_name,vm.PREFERRED_DEFINITION
from 
SBR.VALUE_MEANINGS VM,
SBREXT.CON_DERIVATION_RULES_EXT CN,
(SELECT CONDR_IDSEQ, LISTAGG(CONCEPT_VALUE,',') WITHIN GROUP (ORDER BY CONCEPT_VALUE) as CONCEPT_VALUE_AG
FROM  SBREXT.COMPONENT_CONCEPTS_EXT
where CONCEPT_VALUE is not null
GROUP BY CONDR_IDSEQ)CC
where   VM.CONDR_IDSEQ=CN.CONDR_IDSEQ
AND CC.CONDR_IDSEQ(+)=CN.CONDR_IDSEQ
AND UPPER(ASL_NAME) not like '%RETIRED%'
and instr(CN.NAME,'C45255')>0
and instr(CN.NAME,'XXXC45255')>0

)
where FIN_VM<>VM_ID 

MINUS
select  FIN_VM,vm_id,VM_IDSEQ,R.CONDR_IDSEQ,CONCEPTS_NAME ,long_name,trim(upper(PREFERRED_DEFINITION)) PREFERRED_DEFINITION
from SBREXT.MDSR_VM_DUP_REF R,
SBREXT.CON_DERIVATION_RULES_EXT CN
where R.CONDR_IDSEQ=CN.CONDR_IDSEQ
AND instr(CN.NAME,'XXXC45255')>0)a,
SBR.VALUE_MEANINGS b
where a.FIN_VM=b.VM_ID;

commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);     
      insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.MDSR_VM_DUP_REF','NA','NA','NA',V_error,sysdate );
  commit;
end;

end;
/