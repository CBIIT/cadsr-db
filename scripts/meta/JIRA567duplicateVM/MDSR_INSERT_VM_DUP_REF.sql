CREATE OR REPLACE procedure SBREXT.MDSR_INSERT_VM_DUP_REF
as
cursor C1 is select distinct FIN_VM,FIN_IDSEQ from SBREXT.MDSR_VM_DUP_REF;


VM_REC SBR.VALUE_MEANINGS%ROWTYPE;
d_def_id SBR.designations.desig_idseq%TYPE;
DEF_REC VARCHAR(2000);
V_error VARCHAR(300);
v_cnt0 number;
v_cnt1 number;
V_run number;
begin
/**step1 
insert into MDSR_VM_DUP_REF Records for VM with CONDR_IDSEQ is not null
a.FIN_VM FINAL VN public ID
a.vm_id RETIRED VM public ID
**/

begin
select count(*) into V_cnt1 from SBREXT.MDSR_VM_DUP_REF where CONCEPTS_NAME is not null;
if V_cnt0=0 then
V_run:=1;
else
select max(RUN_NUMBER)+1 into V_cnt0 from SBREXT.MDSR_VM_DUP_REF where CONCEPTS_NAME is not null;
end if; 
INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_NAME,LONG_NAME,PREFERRED_DEFINITION,DATE_CREATED,  RUN_NUMBER )
select  
a.FIN_VM,b.VM_IDSEQ,a.vm_id,a.VM_IDSEQ,a.CONCEPTS_NAME,NULL,NULL,SYSDATE, V_cnt0
from
(select  FIN_VM,vm_id,VM_IDSEQ,CONCEPTS_NAME
from (
select max(VM_ID) over  (partition by NAME order by NAME ) as FIN_VM,VM_ID,VM_IDSEQ,CN.NAME CONCEPTS_NAME
from 
SBR.VALUE_MEANINGS VM,
CON_DERIVATION_RULES_EXT CN
where   VM.CONDR_IDSEQ=CN.CONDR_IDSEQ
AND UPPER(ASL_NAME) not like '%RETIRED%'
--and CONDR_IDSEQ='F37D0428-BBB6-6787-E034-0003BA3F9857'
and vm.CONDR_IDSEQ is not NULL)
where FIN_VM<>VM_ID 
MINUS
select  FIN_VM,vm_id,VM_IDSEQ,CONCEPTS_NAME from SBREXT.MDSR_VM_DUP_REF where CONCEPTS_NAME is not null)a,
SBR.VALUE_MEANINGS b
where a.FIN_VM=b.VM_ID;

commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);     
      insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.MDSR_VM_DUP_REF','NA','NA','NA',V_error,sysdate );
  commit;
end;

/**step3 
insert into MDSR_VM_DUP_REF Records for VM with CONDR_IDSEQ is null
a.FIN_VM FINAL VN public ID
a.vm_id RETIRED VM public ID**/
begin
select count(*) into V_cnt1 from SBREXT.MDSR_VM_DUP_REF where CONCEPTS_NAME is null;
if V_cnt1=0 then
V_run:=1;
else
select max(RUN_NUMBER)+1 into V_cnt1 from SBREXT.MDSR_VM_DUP_REF where CONCEPTS_NAME is null;
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
--and UPPER(trim(LONG_NAME))='9 MONTHS' 
and CONDR_IDSEQ is null)
where FIN_VM<>VM_ID 
MINUS
select  FIN_VM,vm_id,VM_IDSEQ,LONG_NAME,PREFERRED_DEFINITION from SBREXT.MDSR_VM_DUP_REF
where  CONCEPTS_NAME is null)a,
SBR.VALUE_MEANINGS b
where a.FIN_VM=b.VM_ID;
commit;

EXCEPTION
    WHEN others THEN
     V_error := substr(SQLERRM,1,200);     
      insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBREXT.MDSR_VM_DUP_REF','NA','NA','NA',V_error,sysdate );
  commit;
end;
/*4step UPDATE VM and create Prior Preferred Definition in DEFINITIONS*/
for i in C1 loop
begin

V_cnt0 :=0;
update SBR.VALUE_MEANINGS VM set VM.ASL_NAME ='RELEASED' 
where vm_idseq = i.FIN_IDSEQ ;

select * into VM_REC
from SBR.VALUE_MEANINGS where vm_idseq = i.FIN_IDSEQ ; 

select count(*) into V_cnt0
from SBR.DEFINITIONS
where AC_IDSEQ=VM_REC.VM_IDSEQ and CONTE_IDSEQ=VM_REC.conte_idseq and 
UPPER(trim(DEFINITION))= UPPER(trim(VM_REC.PREFERRED_DEFINITION));
 
 If v_cnt0=0 then
select sbr.admincomponent_crud.cmr_guid into d_def_id from dual;
DEF_REC:=d_def_id||' , '||VM_REC.VM_IDSEQ||' , '|| VM_REC.conte_idseq||' , '||VM_REC.LONG_NAME;
Insert into SBR.DEFINITIONS 
(DEFIN_IDSEQ, AC_IDSEQ, CONTE_IDSEQ, DEFINITION,DEFL_NAME,LAE_NAME, DATE_CREATED, CREATED_BY)
VALUES (d_def_id, VM_REC.VM_IDSEQ, VM_REC.conte_idseq,VM_REC.PREFERRED_DEFINITION,'Prior Preferred Definition','ENGLISH', sysdate, 'SBR');
end if;
 
EXCEPTION
    WHEN others THEN
     V_error := substr(SQLERRM,1,200);     
      insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.DEFINITIONS','C1 LOOP',i.FIN_VM,DEF_REC,V_error,sysdate );
  commit;
  end;
end loop;
end;
/