CREATE OR REPLACE procedure SBR.MDSR_CLEAR_DUP_VM_STEP1
as


cursor C1 is select distinct MAX_VM
from (
select max(VM_ID) over (partition by VM.CONDR_IDSEQ order by VM.CONDR_IDSEQ ) as MAX_VM,vm.version,vm_id,vm.long_name,vm.PREFERRED_DEFINITION,VM_IDSEQ, CONTE_IDSEQ
from SBR.VALUE_MEANINGS VM
where  1=1-- UPPER(VM.ASL_NAME) not like '%RETIRED%'
and CONDR_IDSEQ='F37D0428-BBB6-6787-E034-0003BA3F9857')
where MAX_VM<>VM_ID ;

cursor C2 is select FIN_VM,vm.version,VM.VM_ID,vm.long_name,vm.PREFERRED_DEFINITION,VM.VM_IDSEQ, CONTE_IDSEQ
from SBR.VALUE_MEANINGS VM,
MDSR_VM_DUP_REF REF
where   VM.VM_IDSEQ=REF.VM_IDSEQ
and CONDR_IDSEQ='F37D0428-BBB6-6787-E034-0003BA3F9857';

VM_REC SBR.VALUE_MEANINGS%ROWTYPE;
F_VM_IDSEQ SBR.VALUE_MEANINGS.VM_IDSEQ%TYPE;
V_VERS SBR.VALUE_MEANINGS.version%TYPE;
t_desig_id SBR.designations.desig_idseq%TYPE;
d_desig_id SBR.designations.desig_idseq%TYPE;
errm varchar2(2000);
V_VM_REC varchar2(2000);
D_REC SBR.DESIGNATIONS%ROWTYPE;
V_error VARCHAR(300);
V_len number:=0;
v_cntd number;
v_cnt1 number;
V_run number;
begin

begin
select count(*) into V_cnt1 from MDSR_VM_DUP_REF;
if V_cnt1=0 then
V_run:=1;
else
select max(RUN_NUMBER)+1 into V_cnt1 from MDSR_VM_DUP_REF;
end if;
insert into MDSR_VM_DUP_REF select  FIN_VM,vm_id,VM_IDSEQ,V_cnt1,SYSDATE from
(select  FIN_VM,vm_id,VM_IDSEQ--count(*)
from (
select max(VM_ID) over (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM,VM_ID,VM_IDSEQ,CONDR_IDSEQ
from 
SBR.VALUE_MEANINGS 
where   UPPER(ASL_NAME) not like '%RETIRED%')
where FIN_VM<>VM_ID 
MINUS
select  FIN_VM,vm_id,VM_IDSEQ from MDSR_VM_DUP_REF);

commit;
EXCEPTION

    WHEN others THEN
     -- DBMS_OUTPUT.PUT_LINE("No matching result. Please try again.");
     V_error := substr(SQLERRM,1,200);
     
      insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.MDSR_VM_DUP_REF','NA','NA','NA',V_error,sysdate );
  commit;
end;

for i in C1 loop
begin

update SBR.VALUE_MEANINGS VM set VM.ASL_NAME ='RELEASED' 
where vm_id = i.MAX_VM and version = 1;

select * into VM_REC
from SBR.VALUE_MEANINGS where vm_id = i.MAX_VM and version = 1;

select count(*) into V_cntd 
from SBR.DEFINITIONS
where AC_IDSEQ=VM_REC.VM_IDSEQ and CONTE_IDSEQ=VM_REC.conte_idseq and DEFINITION=VM_REC.PREFERRED_DEFINITION;


 
 If v_cntd=0 then
select sbr.admincomponent_crud.cmr_guid into d_desig_id from dual;
V_VM_REC:=d_desig_id||' , '||VM_REC.VM_IDSEQ||' , '|| VM_REC.conte_idseq||' , '||VM_REC.PREFERRED_DEFINITION;
Insert into SBR.DEFINITIONS 
(DEFIN_IDSEQ, AC_IDSEQ, CONTE_IDSEQ, DEFINITION,DEFL_NAME,LAE_NAME, DATE_CREATED, CREATED_BY)
VALUES (d_desig_id, VM_REC.VM_IDSEQ, VM_REC.conte_idseq,VM_REC.PREFERRED_DEFINITION,'Prior Preferred Definition','ENGLISH', sysdate, 'SBR');
end if;

 
EXCEPTION
    WHEN others THEN
     -- DBMS_OUTPUT.PUT_LINE("No matching result. Please try again.");
     V_error := substr(SQLERRM,1,200);
     
      insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.DEFINITIONS','C1 LOOP',i.MAX_VM,V_VM_REC,V_error,sysdate );
  commit;
  end;
end loop;


for i in C2 loop
 
begin
select max(version) into V_VERS  from SBR.VALUE_MEANINGS where  vm_id = i.FIN_VM ; 
select VM_IDSEQ into F_VM_IDSEQ from SBR.VALUE_MEANINGS where  vm_id = i.FIN_VM and version = V_VERS;


update SBR.VALUE_MEANINGS VM set VM.ASL_NAME ='RETIRED ARCHIVED' ,
 CHANGE_NOTE='Use VM public ID:' ||i.FIN_VM||' Version '||V_VERS||' instead. Modified by caDSR script.'||SYSDATE
where vm_id = i.vm_id and version = i.version;

--3. In the Preferred(FINAL) VM, a designation should be created for each Retired VM: ????
/*???????????????????????????????????
F_VM_IDSEQ or i.VM_IDSEQ
*/
select count(*) into V_cntd
from SBR.DESIGNATIONS
where AC_IDSEQ=F_VM_IDSEQ and CONTE_IDSEQ=i.conte_idseq and NAME='public ID and Version '||i.vm_id||'V'||i.version||' of the retired VM'
 and DETL_NAME='Duplicate VM';
 
 If v_cntd=0 then
select sbr.admincomponent_crud.cmr_guid into d_desig_id from dual;
 Insert into SBR.DESIGNATIONS 
 (DESIG_IDSEQ, AC_IDSEQ, CONTE_IDSEQ, NAME,DETL_NAME,LAE_NAME, DATE_CREATED, CREATED_BY)
 VALUES (t_desig_id, F_VM_IDSEQ, i.conte_idseq,'public ID and Version '||i.vm_id||'V'||i.version||' of the retired VM','Duplicate VM','ENGLISH', sysdate, 'SBR');
end if;

--4. Create list of DESIGNATIONS for FINAL VM for each DESIGNATIONS assosiated with retired VM



DECLARE
 CURSOR C_DES  IS  
 --select* into D_REC from SBR.DESIGNATIONS where AC_IDSEQ =i.VM_IDSEQ;
select MAX_RN, RWN,DESIG_IDSEQ,CONTE_IDSEQ,NAME,DETL_NAME,LAE_NAME,date_created from
(select max(rownum) over (partition by CONTE_IDSEQ,upper(NAME),DETL_NAME,LAE_NAME order by CONTE_IDSEQ,NAME,DETL_NAME ) as MAX_RN,
rownum RWN,DESIG_IDSEQ,CONTE_IDSEQ,NAME,DETL_NAME,LAE_NAME,date_created 
from designations where AC_IDSEQ =i.VM_IDSEQ)
where MAX_RN=RWN;
v_cnt number;
begin
for n in C_DES loop
begin

select count(*) into V_cnt
from SBR.DESIGNATIONS
where AC_IDSEQ=F_VM_IDSEQ and CONTE_IDSEQ=n.conte_idseq and upper(NAME)=upper(n.NAME) and DETL_NAME=n.DETL_NAME and LAE_NAME=n.LAE_NAME;

IF V_cnt=0 then
select sbr.admincomponent_crud.cmr_guid into d_desig_id from dual;
 Insert into SBR.DESIGNATIONS 
 (DESIG_IDSEQ, AC_IDSEQ, CONTE_IDSEQ, NAME,DETL_NAME,LAE_NAME, DATE_CREATED, CREATED_BY)
 VALUES (d_desig_id, F_VM_IDSEQ, n.conte_idseq,n.NAME,n.DETL_NAME,n.LAE_NAME, sysdate, 'SBR');
END IF;
 
EXCEPTION
    WHEN others THEN
     -- DBMS_OUTPUT.PUT_LINE("No matching result. Please try again.");
     V_error := substr(SQLERRM,1,200);
       insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.DESIGNATIONS','INNER LOOP',F_VM_IDSEQ,'NA',V_error,sysdate );
  commit;
  end; 
 end loop;
 END;
 
 
 
 DECLARE
 CURSOR C_DEF  IS  
select MAX_RN, RWN,DEFIN_IDSEQ,CONTE_IDSEQ,DEFINITION,DEFL_NAME,LAE_NAME,date_created from
(select max(rownum) over (partition by CONTE_IDSEQ,DEFINITION,DEFL_NAME,LAE_NAME order by DEFINITION,DEFL_NAME,LAE_NAME ) as MAX_RN,
rownum RWN,DEFIN_IDSEQ,CONTE_IDSEQ,DEFINITION,DEFL_NAME,LAE_NAME,date_created 
from SBR.DEFINITIONS where AC_IDSEQ=i.VM_IDSEQ)
where MAX_RN=RWN;
v_cnt number;
begin
for n in C_DEF loop
begin

select count(*) into V_cnt
from SBR.DEFINITIONS
where AC_IDSEQ=F_VM_IDSEQ and CONTE_IDSEQ=n.conte_idseq 
and upper(trim(DEFINITION))=upper(trim(n.DEFINITION)) and DEFL_NAME=n.DEFL_NAME and LAE_NAME=n.LAE_NAME;

IF V_cnt=0 then
select sbr.admincomponent_crud.cmr_guid into d_desig_id from dual;
 Insert into SBR.DEFINITIONS 
 (DEFIN_IDSEQ, AC_IDSEQ, CONTE_IDSEQ, DEFINITION,DEFL_NAME,LAE_NAME, DATE_CREATED, CREATED_BY)
 VALUES (d_desig_id, F_VM_IDSEQ, n.conte_idseq,n.DEFINITION,n.DEFL_NAME,n.LAE_NAME, sysdate, 'SBR');
END IF;
 commit;
EXCEPTION
    WHEN others THEN
     -- DBMS_OUTPUT.PUT_LINE("No matching result. Please try again.");
     V_error := substr(SQLERRM,1,200);
      V_len:= V_len+1;
      insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.DEFINITIONS','INNER LOOP',F_VM_IDSEQ,'NA',V_error,sysdate );
  commit;
  end; 
 end loop;
 END;


commit;
EXCEPTION
    WHEN others THEN
     -- DBMS_OUTPUT.PUT_LINE("No matching result. Please try again.");
     V_error := substr(SQLERRM,1,200);
     
      insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.DEFINITIONS','INNER LOOP',F_VM_IDSEQ,'NA',V_error,sysdate );
  commit;
  end;
  end loop;
end;
/