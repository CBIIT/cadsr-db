CREATE OR REPLACE procedure SBREXT.MDSR_CREATE_DUP_VM_DES_DEF
as


cursor C1 is select distinct FIN_VM,FIN_IDSEQ from SBREXT.MDSR_VM_DUP_REF where  PROC is null;

cursor C2 is select FIN_VM,FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,VM.CONTE_IDSEQ,REF.long_name,REF.PREFERRED_DEFINITION,VM.version
from SBR.VALUE_MEANINGS VM,
SBREXT.MDSR_VM_DUP_REF REF
where   VM.VM_IDSEQ=REF.VM_IDSEQ
AND PROC is null;

VM_REC SBR.VALUE_MEANINGS%ROWTYPE;
F_VM_IDSEQ SBR.VALUE_MEANINGS.VM_IDSEQ%TYPE;
V_VERS SBR.VALUE_MEANINGS.version%TYPE;
d_desig_id SBR.designations.desig_idseq%TYPE;
DEF_REC VARCHAR(2000);
d_def_id SBR.designations.desig_idseq%TYPE;
errm varchar2(2000);
V_VM_REC varchar2(2000);
D_REC SBR.DESIGNATIONS%ROWTYPE;
V_error VARCHAR(300);
V_cnt0 number:=0;
v_cntd number;
v_cnt1 number;
V_run number;
begin

/*1step UPDATE VM and create Prior Preferred Definition in DEFINITIONS*/
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
DEF_REC:=SUBSTR(d_def_id||' , '||VM_REC.VM_IDSEQ||' , '|| VM_REC.conte_idseq||' , '||VM_REC.LONG_NAME,1,1999);
Insert into SBR.DEFINITIONS 
(DEFIN_IDSEQ, AC_IDSEQ, CONTE_IDSEQ, DEFINITION,DEFL_NAME,LAE_NAME, DATE_CREATED, CREATED_BY)
VALUES (d_def_id, VM_REC.VM_IDSEQ, VM_REC.conte_idseq,VM_REC.PREFERRED_DEFINITION,'Prior Preferred Definition','ENGLISH', sysdate, 'SBR');
end if;
 
EXCEPTION
    WHEN others THEN
     V_error := substr(SQLERRM,1,200);     
      insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'MDSR_CREATE_DUP_VM_DES_DEF','C1 LOOP',i.FIN_VM,DEF_REC,V_error,sysdate );
  commit;
  end;
end loop;

for i in C2 loop
 
begin


update SBR.VALUE_MEANINGS VM set VM.ASL_NAME ='RETIRED ARCHIVED' ,
 CHANGE_NOTE=substr('Use VM public ID:' ||i.FIN_VM||' Version 1.0 instead. Modified by caDSR script.'||SYSDATE||'; '||CHANGE_NOTE,1,2000)
where vm_id = i.vm_id and version = i.version;
--FIN_VM,FIN_IDSEQ
--2. In the Preferred(FINAL) VM, a designation should be created for each Retired VM*/
select count(*) into V_cntd
from SBR.DESIGNATIONS
where AC_IDSEQ=i.FIN_IDSEQ and CONTE_IDSEQ=i.conte_idseq and NAME=i.vm_id||'V'||'1.0 of the retired VM'
 and DETL_NAME='Duplicate VM';
 
 If v_cntd=0 then
select sbr.admincomponent_crud.cmr_guid into d_desig_id from dual;
 Insert into SBR.DESIGNATIONS 
 (DESIG_IDSEQ, AC_IDSEQ, CONTE_IDSEQ, NAME,DETL_NAME,LAE_NAME, DATE_CREATED, CREATED_BY)
 VALUES (d_desig_id, i.FIN_IDSEQ, i.conte_idseq,i.vm_id||'V'||'1.0 of the retired VM','Duplicate VM','ENGLISH', sysdate, 'SBR');
end if;

--3. Create list of DESIGNATIONS for FINAL VM for each DESIGNATIONS assosiated with retired VM


DECLARE
 CURSOR C_DES  IS   
select MAX_RN, RWN,DESIG_IDSEQ,CONTE_IDSEQ,NAME,DETL_NAME,LAE_NAME,date_created from
(select max(rownum) over (partition by CONTE_IDSEQ,trim(upper(NAME)),trim(upper(DETL_NAME)),trim(upper(LAE_NAME)) 
order by trim(upper(NAME)),trim(upper(DETL_NAME)),trim(upper(LAE_NAME)),CONTE_IDSEQ ) as MAX_RN,
rownum RWN,DESIG_IDSEQ,CONTE_IDSEQ,NAME,DETL_NAME,LAE_NAME,date_created 
from designations where AC_IDSEQ =i.VM_IDSEQ)
where MAX_RN=RWN;
v_cnt number;
begin
for n in C_DES loop
begin

select count(*) into V_cnt
from SBR.DESIGNATIONS
where AC_IDSEQ=i.FIN_IDSEQ and CONTE_IDSEQ=n.conte_idseq and trim(upper(NAME))=trim(upper(n.NAME))
and trim(upper(DETL_NAME))=trim(upper(n.DETL_NAME)) and trim(upper(LAE_NAME))=trim(upper(n.LAE_NAME));

IF V_cnt=0 then
select sbr.admincomponent_crud.cmr_guid into d_desig_id from dual;
 Insert into SBR.DESIGNATIONS 
 (DESIG_IDSEQ, AC_IDSEQ, CONTE_IDSEQ, NAME,DETL_NAME,LAE_NAME, DATE_CREATED, CREATED_BY)
 VALUES (d_desig_id, i.FIN_IDSEQ, n.conte_idseq,n.NAME,n.DETL_NAME,n.LAE_NAME, sysdate, 'SBR');
END IF;
 
EXCEPTION
    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
       insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_CREATE_DUP_VM_DES_DEF', 'SBR.DESIGNATIONS','INNER LOOP',i.VM_IDSEQ,i.VM_ID,V_error,sysdate );
  commit;
  end; 
 end loop;
 END; 
 
 
 DECLARE
 CURSOR C_DEF  IS  
select MAX_RN, RWN,DEFIN_IDSEQ,CONTE_IDSEQ,DEFINITION,DEFL_NAME,LAE_NAME,date_created from
(select max(rownum) over (partition by CONTE_IDSEQ,UPPER(trim(DEFINITION)),UPPER(trim(DEFL_NAME)),UPPER(trim(LAE_NAME))
 order by UPPER(trim(DEFINITION)),UPPER(trim(DEFL_NAME)),UPPER(trim(LAE_NAME)) ) as MAX_RN,
rownum RWN,DEFIN_IDSEQ,CONTE_IDSEQ,DEFINITION,DEFL_NAME,LAE_NAME,date_created 
from SBR.DEFINITIONS where AC_IDSEQ=i.VM_IDSEQ)
where MAX_RN=RWN;
v_cnt number;
begin
for n in C_DEF loop
begin

select count(*) into V_cnt
from SBR.DEFINITIONS
where AC_IDSEQ=i.FIN_IDSEQ and CONTE_IDSEQ=n.conte_idseq 
and upper(trim(DEFINITION))=upper(trim(n.DEFINITION)) and
trim(upper(DEFL_NAME))=trim(upper(n.DEFL_NAME)) and trim(upper(LAE_NAME))=trim(upper(n.LAE_NAME));

IF V_cnt=0 then
select sbr.admincomponent_crud.cmr_guid into d_desig_id from dual;
 Insert into SBR.DEFINITIONS 
 (DEFIN_IDSEQ, AC_IDSEQ, CONTE_IDSEQ, DEFINITION,DEFL_NAME,LAE_NAME, DATE_CREATED, CREATED_BY)
 VALUES (d_desig_id, i.FIN_IDSEQ, n.conte_idseq,n.DEFINITION,n.DEFL_NAME,n.LAE_NAME, sysdate, 'SBR');
END IF;
 commit;
EXCEPTION
    WHEN others THEN
     V_error := substr(SQLERRM,1,200);  
      insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_CREATE_DUP_VM_DES_DEFR', 'SBR.DEFINITIONS','INNER LOOP',i.VM_IDSEQ,i.VM_ID,V_error,sysdate );
  commit;
  end; 
 end loop;
 END;

commit;
EXCEPTION
    WHEN others THEN
    
     V_error := substr(SQLERRM,1,200);     
      insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_CREATE_DUP_VM_DES_DEF', 'SBR.DEFINITIONS','INNER LOOP',F_VM_IDSEQ,'NA',V_error,sysdate );
  commit;
  end;
  end loop;
end;
/