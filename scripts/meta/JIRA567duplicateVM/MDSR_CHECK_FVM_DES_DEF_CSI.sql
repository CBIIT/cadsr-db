CREATE OR REPLACE procedure SBR.MDSR_CHACK_FVM_DES_DEF_CSI
as

/* cursor C1 collects missing DESIGNATIONS for Final VM */
cursor C1 is select REF.FIN_VM,REF.FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,DS.DESIG_IDSEQ,DS.CONTE_IDSEQ, DS.NAME, DS.DETL_NAME,DS.LAE_NAME
from SBR.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
(select FIN_VM,REF.FIN_IDSEQ,DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,trim(upper(DS.LAE_NAME)) LAE_NAME
from
  SBR.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS
where  REF.VM_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ

MINUS

select FIN_VM,REF.FIN_IDSEQ, DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,trim(upper(DS.LAE_NAME)) LAE_NAME
from
 ( select distinct FIN_VM,FIN_IDSEQ from SBR.MDSR_VM_DUP_REF )REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS
where  REF.FIN_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ)MS
where MS.FIN_VM=REF.FIN_VM
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND MS.CONTE_IDSEQ=DS.CONTE_IDSEQ
and trim(upper(MS.NAME))=trim(upper(DS.NAME))
and MS.DETL_NAME=trim(upper(DS.DETL_NAME))
order by 1 desc,3 desc;

/* cursor C1 collects missing DEFINITIONS for Final VM */
cursor C2 is select REF.FIN_VM,REF.FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,DF.DEFIN_IDSEQ,DF.CONTE_IDSEQ, DF.DEFINITION, DF.DEFL_NAME,DF.LAE_NAME
from SBR.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
(select FIN_VM,REF.FIN_IDSEQ,DF.CONTE_IDSEQ, trim(upper(DF.DEFINITION)) DEFINITION, 
trim(upper(DF.DEFL_NAME)) DEFL_NAME,trim(upper(DF.LAE_NAME)) LAE_NAME
from
 SBR.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF
where REF.vm_id=VM.vm_id
AND VM.VM_IDSEQ=DF.AC_IDSEQ
MINUS
select FIN_VM,REF.FIN_IDSEQ,DF.CONTE_IDSEQ, trim(upper(DF.DEFINITION)) DEFINITION, 
trim(upper(DF.DEFL_NAME)) DEFL_NAME,trim(upper(DF.LAE_NAME)) LAE_NAME
From
 ( select distinct FIN_VM,FIN_IDSEQ from SBR.MDSR_VM_DUP_REF )REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF
where  REF.FIN_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=DF.AC_IDSEQ) MS
where MS.FIN_VM=REF.FIN_VM
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND MS.CONTE_IDSEQ=DF.CONTE_IDSEQ
and trim(upper(MS.DEFINITION))=trim(upper(DF.DEFINITION))
and MS.DEFL_NAME=trim(upper(DF.DEFL_NAME))
AND PROC is null
order by 1 desc,3 desc;


/* cursor C1 collects missing CS_CSI_IDSEQ if DESIGNATIONS for Final VM */

cursor C3 is select REF.FIN_VM,REF.FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,DS.DESIG_IDSEQ,
DS.CONTE_IDSEQ, DS.NAME, DS.DETL_NAME,DS.LAE_NAME,AC.ACA_IDSEQ,AC.CS_CSI_IDSEQ,AC.ATL_NAME
from SBR.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
 sbrext.ac_att_cscsi_ext AC,
(select FIN_VM,REF.FIN_IDSEQ,DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,
trim(upper(DS.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
  SBR.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
 sbrext.ac_att_cscsi_ext AC
where  REF.VM_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND AC.att_idseq = DS.desig_idseq
MINUS
select FIN_VM,REF.FIN_IDSEQ, DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,
trim(upper(DS.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
 ( select distinct FIN_VM,FIN_IDSEQ from SBR.MDSR_VM_DUP_REF )REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
 sbrext.ac_att_cscsi_ext AC
where  REF.FIN_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND AC.att_idseq = DS.desig_idseq) MS
where MS.FIN_VM=REF.FIN_VM
AND REF.VM_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND MS.CONTE_IDSEQ=DS.CONTE_IDSEQ
AND AC.att_idseq = DS.desig_idseq
and trim(upper(MS.NAME))=trim(upper(DS.NAME))
and trim(upper(MS.DETL_NAME))=trim(upper(DS.DETL_NAME))
and  AC.CS_CSI_IDSEQ=MS.CS_CSI_IDSEQ
AND PROC is null
order by 1 desc,3 desc;


/* cursor C4 collects missing CS_CSI_IDSEQ if DEFINITIONS for Final VM */


cursor C4 is select REF.FIN_VM,REF.FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,DF.DEFIN_IDSEQ,DF.CONTE_IDSEQ,
 DF.DEFINITION, DF.DEFL_NAME,DF.LAE_NAME,AC.ACA_IDSEQ,  AC.CS_CSI_IDSEQ,AC.ATL_NAME
from SBR.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
 sbrext.ac_att_cscsi_ext AC,
(select FIN_VM,REF.FIN_IDSEQ,DF.CONTE_IDSEQ, trim(upper(DF.DEFINITION)) DEFINITION, 
trim(upper(DF.DEFL_NAME)) DEFL_NAME,trim(upper(DF.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
 SBR.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
 sbrext.ac_att_cscsi_ext AC
where REF.vm_id=VM.vm_id
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND AC.att_idseq = DF.DEFIN_IDSEQ
MINUS
select FIN_VM,REF.FIN_IDSEQ,DF.CONTE_IDSEQ, trim(upper(DF.DEFINITION)) DEFINITION, 
trim(upper(DF.DEFL_NAME)) DEFL_NAME,trim(upper(DF.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
From
 ( select distinct FIN_VM,FIN_IDSEQ from SBR.MDSR_VM_DUP_REF )REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
 sbrext.ac_att_cscsi_ext AC
where  REF.FIN_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND AC.att_idseq = DF.DEFIN_IDSEQ) MS

where MS.FIN_VM=REF.FIN_VM
AND REF.VM_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND MS.CONTE_IDSEQ=DF.CONTE_IDSEQ
AND AC.att_idseq = DF.DEFIN_IDSEQ
and trim(upper(MS.DEFINITION))=trim(upper(DF.DEFINITION))
and MS.DEFL_NAME=trim(upper(DF.DEFL_NAME))
and  AC.CS_CSI_IDSEQ=MS.CS_CSI_IDSEQ
order by 1 desc,3 desc;

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

IF V_cnt=0 then

UPDATE MDSR_VM_DUP_REF set DES='NC'
where VM_IDSEQ=VM_IDSEQ;

v_errm:='DES of VM:'||i.VM_IDSEQ||'and DES:'||i.DESIG_IDSEQ||' are not created for VM:'||i.FIN_VM;
insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.DESIGNATIONS','C1','',i.FIN_IDSEQ,v_errm,sysdate );

commit;
 end if;
EXCEPTION
    WHEN others THEN
     -- DBMS_OUTPUT.PUT_LINE("No matching result. Please try again.");
     V_error := substr(SQLERRM,1,200);     
      insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SNR.DESIGNATIONS','C1 LOOP','',i.FIN_IDSEQ,V_error,sysdate );
  commit;
 end;
end loop;


for i in C2 loop
begin
v_errm:=NULL;
select count(*) into V_cnt
from SBR.DEFINITIONS
where AC_IDSEQ=i.FIN_IDSEQ and CONTE_IDSEQ=i.conte_idseq 
and upper(trim(DEFINITION))=upper(trim(i.DEFINITION)) and
trim(upper(DEFL_NAME))=trim(upper(i.DEFL_NAME)) and trim(upper(LAE_NAME))=trim(upper(i.LAE_NAME));


IF V_cnt=0 then

UPDATE MDSR_VM_DUP_REF set DEFN='NC'
where VM_IDSEQ=VM_IDSEQ;

v_errm:='DEFIN of VM:'||i.VM_IDSEQ||'and DEFIN:'||i.DEFIN_IDSEQ||' are not created for VM:'||i.FIN_VM;
insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.DEFINITIONS','C2','',i.FIN_IDSEQ,v_errm,sysdate );

commit;
end if;
EXCEPTION
    WHEN others THEN
        V_error := substr(SQLERRM,1,200);     
      insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'sbrext.ac_att_cscsi_ext','C2 LOOP','',V_VM_REC,V_error,sysdate );
  commit;
 end;
end loop;


for i in C3 loop
begin
v_errm:=NULL;

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
UPDATE MDSR_VM_DUP_REF set DES_CL='NC'
where VM_IDSEQ=VM_IDSEQ;

v_errm:='CS_CSI '||i.CS_CSI_IDSEQ||' of VM:'||i.VM_IDSEQ||'and DES:'||i.DESIG_IDSEQ||' are not created for VM:'||i.FIN_VM;
insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.ac_att_cscsi_ext','C3','',i.FIN_IDSEQ,v_errm,sysdate );

 commit;
 end if;
EXCEPTION
    WHEN others THEN
      V_error := substr(SQLERRM,1,200);     
      insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'sbrext.ac_att_cscsi_ext','C3 LOOP','','MDSR_VM_DUP_REF',V_error,sysdate );
  commit;
   end;
end loop;


for i in C4 loop
begin

select count(*) into V_cntd 
from  
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
 sbrext.ac_att_cscsi_ext AC
where VM.VM_IDSEQ=i.FIN_IDSEQ
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND AC.att_idseq = DF.DEFIN_IDSEQ
and DF.CONTE_IDSEQ=i.conte_idseq
and DF.DEFINITION=i.DEFINITION
and DF.DEFL_NAME=i.DEFL_NAME
AND AC.CS_CSI_IDSEQ=i.CS_CSI_IDSEQ;

 If v_cntd=0 then
UPDATE MDSR_VM_DUP_REF set DEFN_CL='NC'
where VM_IDSEQ=VM_IDSEQ;

v_errm:='CS_CSI '||i.CS_CSI_IDSEQ||' of VM:'||i.VM_IDSEQ||'and DEFIN:'||i.DEFIN_IDSEQ||' are not created for VM:'||i.FIN_VM;
insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.ac_att_cscsi_ext','C4','SBR.DEFINITIONS DF',i.FIN_IDSEQ,v_errm,sysdate );

 commit;
 end if;
EXCEPTION
    WHEN others THEN
         V_error := substr(SQLERRM,1,200);     
      insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'sbrext.ac_att_cscsi_ext','C3 LOOP','','MDSR_VM_DUP_REF',V_error,sysdate );
  commit;
   end;
end loop;

UPDATE MDSR_VM_DUP_REF set PROC='P'
where DES is null and DEFN is null and DES_CL is null and   DEFN_CL is null;
commit;
EXCEPTION
    WHEN others THEN
       V_error := substr(SQLERRM,1,200);     
      insert into SBR.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'MDSR_VM_DUP_REF','Last update','','',V_error,sysdate );
  commit;
   end;
 END;
/