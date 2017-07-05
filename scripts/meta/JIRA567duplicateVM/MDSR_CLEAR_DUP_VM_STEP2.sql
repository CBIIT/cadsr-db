CREATE OR REPLACE procedure SBR.MDSR_CLEAR_DUP_VM_STEP2
as


cursor C1 is select FIN_VM,VM.long_name,VM.PREFERRED_DEFINITION,VM.VM_IDSEQ, DS.DESIG_IDSEQ, DS.AC_IDSEQ, 
DS.CONTE_IDSEQ, DS.NAME, DS.DETL_NAME
from
 (select distinct FIN_VM from MDSR_VM_DUP_REF)REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS
where  FIN_VM=vm_id
AND VM.VM_IDSEQ=DS.AC_IDSEQ
and DS.NAME not like'%of the retired VM%'
and CONDR_IDSEQ='F37D0428-BBB6-6787-E034-0003BA3F9857';






cursor C2 is select FIN_VM,VM.long_name,VM.PREFERRED_DEFINITION,VM.VM_IDSEQ, DF.DEFIN_IDSEQ, DF.AC_IDSEQ, 
DF.CONTE_IDSEQ, DF.DEFINITION, DF.DEFL_NAME,LAE_NAME
from
 (select distinct FIN_VM from MDSR_VM_DUP_REF)REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF
where  FIN_VM=vm_id
AND VM.VM_IDSEQ=DF.AC_IDSEQ
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
V_cnt number;
begin

for i in C1 loop
begin
select count(*) into V_cnt
from SBR.DESIGNATIONS
where AC_IDSEQ=F_VM_IDSEQ and CONTE_IDSEQ=i.conte_idseq and NAME=i.NAME and DETL_NAME=i.DETL_NAME;

  /********************************************************/
  DECLARE

cursor C3 is select FIN_VM,VM.vm_id,VM.long_name,VM.PREFERRED_DEFINITION,VM.VM_IDSEQ, DS.DESIG_IDSEQ, DS.AC_IDSEQ, 
DS.CONTE_IDSEQ, DS.NAME, DS.DETL_NAME,DS.LAE_NAME,AC.ACA_IDSEQ,  AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
  SBR.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
 sbrext.ac_att_cscsi_ext AC
where  REF.vm_id=VM.vm_id
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND AC.att_idseq = DS.desig_idseq
and FIN_VM=i.FIN_VM
and DS.CONTE_IDSEQ=i.conte_idseq
and NAME=i.NAME
and DS.DETL_NAME=i.DETL_NAME;
begin

for n in C3 loop
begin
select count(*) into V_cntd 
from  
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
 sbrext.ac_att_cscsi_ext AC
where VM.vm_id=n.FIN_VM
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND AC.att_idseq = DS.desig_idseq
AND DS.CONTE_IDSEQ=n.conte_idseq
AND NAME=n.NAME
AND DS.DETL_NAME=n.DETL_NAME
AND AC.CS_CSI_IDSEQ=n.CS_CSI_IDSEQ;

 If v_cntd=0 then
select sbr.admincomponent_crud.cmr_guid into d_desig_id from dual;
V_VM_REC:=d_desig_id||' ,FVM: '||i.VM_IDSEQ||' ,FVM_DS: '||i.DESIG_IDSEQ||' ,RT_VM_DS: '||n.DESIG_IDSEQ ||' , '|| n.conte_idseq||' , '||n.CS_CSI_IDSEQ;
Insert into sbrext.ac_att_cscsi_ext
(ACA_IDSEQ, CS_CSI_IDSEQ, ATT_IDSEQ ,ATL_NAME, DATE_CREATED, CREATED_BY)
VALUES (d_desig_id,n.CS_CSI_IDSEQ, i.DESIG_IDSEQ ,n.ATL_NAME, sysdate, 'SBR');
end if;
 commit;
EXCEPTION
    WHEN others THEN
     -- DBMS_OUTPUT.PUT_LINE("No matching result. Please try again.");
     V_error := substr(SQLERRM,1,200);
     
      insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'sbrext.ac_att_cscsi_ext','C3 LOOP','',V_VM_REC,V_error,sysdate );
  commit;
  end;
end loop;
  end;
EXCEPTION
    WHEN others THEN
     -- DBMS_OUTPUT.PUT_LINE("No matching result. Please try again.");
     V_error := substr(SQLERRM,1,200);
     
      insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.DEFINITIONS','C1 LOOP','',V_VM_REC,V_error,sysdate );
  commit;
end;
end loop;


for i in C2 loop
begin


DECLARE

cursor C4 is select FIN_VM,VM.vm_id,VM.long_name,VM.PREFERRED_DEFINITION,VM.VM_IDSEQ, DF.DEFIN_IDSEQ, DF.AC_IDSEQ, 
DF.CONTE_IDSEQ, DF.DEFINITION, DF.DEFL_NAME,DF.LAE_NAME,AC.ACA_IDSEQ,  AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
  SBR.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
 sbrext.ac_att_cscsi_ext AC
where REF.vm_id=VM.vm_id
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND AC.att_idseq = DF.DEFIN_IDSEQ
and FIN_VM=i.FIN_VM
and DF.CONTE_IDSEQ=i.conte_idseq
and DF.DEFINITION=i.DEFINITION
and DF.DEFL_NAME=i.DEFL_NAME;
begin

for j in C4 loop
begin
select count(*) into V_cntd 
from  
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
 sbrext.ac_att_cscsi_ext AC
where VM.vm_id=j.FIN_VM
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND AC.att_idseq = DF.DEFIN_IDSEQ
and DF.CONTE_IDSEQ=j.conte_idseq
and DF.DEFINITION=j.DEFINITION
and DF.DEFL_NAME=j.DEFL_NAME
AND AC.CS_CSI_IDSEQ=j.CS_CSI_IDSEQ;

 If v_cntd=0 then
select sbr.admincomponent_crud.cmr_guid into d_desig_id from dual;
V_VM_REC:=d_desig_id||' ,FVM: '||i.VM_IDSEQ||' ,FVM_DS: '||i.DEFIN_IDSEQ||' ,RT_VM_DS: '||j.DEFIN_IDSEQ ||' , '|| j.conte_idseq||' , '||j.CS_CSI_IDSEQ;
Insert into sbrext.ac_att_cscsi_ext
(ACA_IDSEQ, CS_CSI_IDSEQ, ATT_IDSEQ ,ATL_NAME, DATE_CREATED, CREATED_BY)
VALUES (d_desig_id,j.CS_CSI_IDSEQ, i.DEFIN_IDSEQ ,j.ATL_NAME, sysdate, 'SBR');
end if;
 commit;
EXCEPTION
    WHEN others THEN
     -- DBMS_OUTPUT.PUT_LINE("No matching result. Please try again.");
     V_error := substr(SQLERRM,1,200);
     
      insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'sbrext.ac_att_cscsi_ext','C3 LOOP','',V_VM_REC,V_error,sysdate );
  commit;
  end;
end loop;
  end;
  /********************************************************/

EXCEPTION
    WHEN others THEN
     -- DBMS_OUTPUT.PUT_LINE("No matching result. Please try again.");
     V_error := substr(SQLERRM,1,200);
     
      insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.DEFINITIONS','C1 LOOP','',V_VM_REC,V_error,sysdate );
  commit;
end;
end loop;

 END;
/