CREATE OR REPLACE procedure SBREXT.MDSR_CREATE_DUP_VM_CSI
as

cursor C1 is select FIN_VM,VM.vm_id,REF.FIN_IDSEQ,VM.PREFERRED_DEFINITION,VM.VM_IDSEQ, DS.DESIG_IDSEQ, DS.AC_IDSEQ, 
DS.CONTE_IDSEQ, DS.NAME, DS.DETL_NAME,DS.LAE_NAME,AC.ACA_IDSEQ,  AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
 SBREXT.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
 sbrext.ac_att_cscsi_ext AC
where  REF.vm_id=VM.vm_id
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND AC.att_idseq = DS.desig_idseq
AND PROC is null
order by FIN_VM desc,VM.vm_id desc;


cursor C2 is select FIN_VM,REF.FIN_IDSEQ,VM.vm_id,VM.long_name,VM.PREFERRED_DEFINITION,VM.VM_IDSEQ, DF.DEFIN_IDSEQ, DF.AC_IDSEQ, 
DF.CONTE_IDSEQ, DF.DEFINITION, DF.DEFL_NAME,DF.LAE_NAME,AC.ACA_IDSEQ,  AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
 SBREXT.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
 sbrext.ac_att_cscsi_ext AC
where REF.vm_id=VM.vm_id
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND AC.att_idseq = DF.DEFIN_IDSEQ
AND PROC is null
order by FIN_VM desc,VM.vm_id desc;

VM_REC SBR.VALUE_MEANINGS%ROWTYPE;
F_VM_IDSEQ SBR.VALUE_MEANINGS.VM_IDSEQ%TYPE;
V_VERS SBR.VALUE_MEANINGS.version%TYPE;
t_desig_id SBR.designations.desig_idseq%TYPE;
d_desig_id SBR.designations.desig_idseq%TYPE;
V_errm varchar2(2000);
V_VM_REC varchar2(2000);
DES_REC SBR.DESIGNATIONS%ROWTYPE;
DEF_REC SBR.DEFINITIONS%ROWTYPE;
V_error VARCHAR(300);
V_len number:=0;
v_cntd number;
v_cnt1 number;
V_cnt number;
begin

for i in C1 loop
begin
v_errm:=NULL;
select count(*) into V_cnt
from SBR.DESIGNATIONS
where AC_IDSEQ=i.FIN_IDSEQ and CONTE_IDSEQ=i.conte_idseq and upper(trim(NAME))=upper(trim(i.NAME)) 
and upper(trim(DETL_NAME))=upper(trim(i.DETL_NAME));

IF V_cnt>1 then
UPDATE MDSR_VM_DUP_REF set DES='NC'
where VM_IDSEQ=VM_IDSEQ;
v_errm:='To many DES of  '||i.FIN_VM||' for VM:'||i.VM_IDSEQ||'and DES:'||i.DESIG_IDSEQ;
insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.DESIGNATIONS','C1','',i.FIN_IDSEQ,v_errm,sysdate );

ELSIF V_cnt=1 then
select * into DES_REC
from SBR.DESIGNATIONS
where AC_IDSEQ=i.FIN_IDSEQ and CONTE_IDSEQ=i.conte_idseq and upper(trim(NAME))=upper(trim(i.NAME)) and upper(trim(DETL_NAME))=upper(trim(i.DETL_NAME));

select count(*) into V_cntd 
from  
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
 sbrext.ac_att_cscsi_ext AC
where VM.vm_id=i.FIN_VM
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND AC.att_idseq = DS.desig_idseq
AND DS.CONTE_IDSEQ=i.conte_idseq
AND upper(trim(NAME))=upper(trim(i.NAME))
AND DS.DETL_NAME=i.DETL_NAME
AND AC.CS_CSI_IDSEQ=i.CS_CSI_IDSEQ;

 If v_cntd=0 then
select sbr.admincomponent_crud.cmr_guid into d_desig_id from dual;
V_VM_REC:=d_desig_id||' ,FVM: '||i.VM_IDSEQ||' ,FVM_DS: '||DES_REC.DESIG_IDSEQ||' ,RT_VM_DS: '||i.DESIG_IDSEQ ||' , '|| i.conte_idseq||' , '||i.CS_CSI_IDSEQ;
Insert into sbrext.ac_att_cscsi_ext
(ACA_IDSEQ, CS_CSI_IDSEQ, ATT_IDSEQ ,ATL_NAME, DATE_CREATED, CREATED_BY)
VALUES (d_desig_id,i.CS_CSI_IDSEQ, DES_REC.DESIG_IDSEQ ,i.ATL_NAME, sysdate, 'SBR');
end if;
 commit;
 end if;
EXCEPTION
    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
     
      insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'sbrext.ac_att_cscsi_ext','C3 LOOP','',V_VM_REC,V_error,sysdate );
  commit;
  end;
end loop;


for j in C2 loop
begin

v_errm:=NULL;
select count(*) into V_cnt
from SBR.DEFINITIONS
where AC_IDSEQ=j.FIN_IDSEQ and CONTE_IDSEQ=j.conte_idseq and upper(trim(DEFINITION))=upper(trim(j.DEFINITION)) 
and upper(trim(DEFL_NAME))=upper(trim(j.DEFL_NAME));

IF  V_cnt>1 then
UPDATE MDSR_VM_DUP_REF set DEFN='NC'
where VM_IDSEQ=j.VM_IDSEQ;
v_errm:='To many DES of  '||j.FIN_VM||' for VM:'||j.VM_IDSEQ||'and DES:'||j.DEFIN_IDSEQ;
insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.DESIGNATIONS','C1','',j.FIN_IDSEQ,v_errm,sysdate );

ELSIF V_cnt=1 then
select * into DEF_REC
from SBR.DEFINITIONS
where AC_IDSEQ=j.FIN_IDSEQ and CONTE_IDSEQ=j.conte_idseq and 
upper(trim(DEFINITION))=upper(trim(j.DEFINITION)) and upper(trim(DEFL_NAME))=upper(trim(j.DEFL_NAME));

select count(*) into V_cntd 
from  
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
 sbrext.ac_att_cscsi_ext AC
where VM.VM_IDSEQ=j.FIN_IDSEQ
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND AC.att_idseq = DF.DEFIN_IDSEQ
and DF.CONTE_IDSEQ=j.conte_idseq
and DF.DEFINITION=j.DEFINITION
and DF.DEFL_NAME=j.DEFL_NAME
AND AC.CS_CSI_IDSEQ=j.CS_CSI_IDSEQ;

 If v_cntd=0 then
select sbr.admincomponent_crud.cmr_guid into d_desig_id from dual;
V_VM_REC:=d_desig_id||' ,FVM: '||j.FIN_IDSEQ||' ,FVM_DF: '||DEF_REC.DEFIN_IDSEQ||' ,RT_VM_DF: '||j.DEFIN_IDSEQ ||' , '|| j.conte_idseq||' , '||j.CS_CSI_IDSEQ;
Insert into sbrext.ac_att_cscsi_ext
(ACA_IDSEQ, CS_CSI_IDSEQ, ATT_IDSEQ ,ATL_NAME, DATE_CREATED, CREATED_BY)
VALUES (d_desig_id,j.CS_CSI_IDSEQ, DEF_REC.DEFIN_IDSEQ ,j.ATL_NAME, sysdate, 'SBR');
end if;
 commit; 
 end if;
EXCEPTION
    WHEN others THEN
     V_error := substr(SQLERRM,1,200);     
      insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'sbrext.ac_att_cscsi_ext','C2 LOOP','',V_VM_REC,V_error,sysdate );
  commit;
  end;
  
end loop;


 END;
/