CREATE OR REPLACE procedure SBREXT.MDSR_CHECK_FVM_DES_DEF_CSI
as

cursor C1 is select FIN_VM,FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,VM.CONTE_IDSEQ,REF.CONCEPTS_NAME  ,REF.long_name,REF.PREFERRED_DEFINITION,VM.version
from SBR.VALUE_MEANINGS VM,
SBREXT.MDSR_VM_DUP_REF REF
where   VM.VM_IDSEQ=REF.VM_IDSEQ
AND PROC is null;


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
v_cntds number;
v_cntdf number;
v_cntdscl number;
v_cntdfcl number;
V_cnt number;
begin

for i in C1 loop
begin
v_errm:=NULL;
select count(*) into V_cntds
from 
(select FIN_VM,REF.FIN_IDSEQ,DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,trim(upper(DS.LAE_NAME)) LAE_NAME
from
 SBREXT.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS
where  REF.VM_IDSEQ=i.VM_IDSEQ
AND REF.VM_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ

MINUS

select FIN_VM,REF.FIN_IDSEQ, DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,trim(upper(DS.LAE_NAME)) LAE_NAME
from
(select distinct FIN_VM,FIN_IDSEQ from  SBREXT.MDSR_VM_DUP_REF )REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS
where  REF.FIN_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND REF.FIN_IDSEQ=i.FIN_IDSEQ
)MS;



IF V_cntds>0 then

UPDATE  SBREXT.MDSR_VM_DUP_REF set DES='NC'
where VM_IDSEQ=i.VM_IDSEQ;

declare 
cursor C2 is select distinct REF.FIN_VM,REF.FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,DS.DESIG_IDSEQ,DS.CONTE_IDSEQ, DS.NAME, DS.DETL_NAME,DS.LAE_NAME
from SBREXT.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
(select FIN_VM,REF.FIN_IDSEQ,DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,trim(upper(DS.LAE_NAME)) LAE_NAME
from
 SBREXT.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS
where  REF.VM_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ
MINUS
select FIN_VM,REF.FIN_IDSEQ, DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,trim(upper(DS.LAE_NAME)) LAE_NAME
from
(select distinct FIN_VM,FIN_IDSEQ from  SBREXT.MDSR_VM_DUP_REF )REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS
where  REF.FIN_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND VM.VM_IDSEQ=i.FIN_IDSEQ)MS
where MS.FIN_VM=REF.FIN_VM
AND VM.VM_IDSEQ=REF.VM_IDSEQ
AND VM.VM_IDSEQ=i.VM_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND MS.CONTE_IDSEQ=DS.CONTE_IDSEQ
and trim(upper(MS.NAME))=trim(upper(DS.NAME))
and MS.DETL_NAME=trim(upper(DS.DETL_NAME))
order by 1 desc,3 desc;
begin
for j in C2 loop
begin
v_errm:='DESIGNATIONS of VM:'||j.VM_IDSEQ||' and DESIGNATIONS for DS.NAME '||j.NAME||' DESIG_IDSEQ:' ||j.DESIG_IDSEQ ||'  not created for VM:'||j.FIN_VM;
insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'SBR.DESIGNATIONS','C2',j.VM_IDSEQ,j.VM_ID,v_errm,sysdate );
EXCEPTION
    WHEN others THEN
       V_error := substr(SQLERRM,1,200);     
      insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'DESIGNATIONS','C2',j.VM_IDSEQ,'Last insert',V_error,sysdate );
  commit;
end;
end loop;
end;
commit;
 end if;
 
 select count(*) into V_cntdf
 from  
(select FIN_VM,REF.FIN_IDSEQ,DF.CONTE_IDSEQ, trim(upper(DF.DEFINITION)) DEFINITION, 
trim(upper(DF.DEFL_NAME)) DEFL_NAME,trim(upper(DF.LAE_NAME)) LAE_NAME
from
 SBREXT.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF
where REF.VM_IDSEQ=VM.VM_IDSEQ
AND REF.VM_IDSEQ=i.VM_IDSEQ
AND VM.VM_IDSEQ=DF.AC_IDSEQ
MINUS
select FIN_VM,REF.FIN_IDSEQ,DF.CONTE_IDSEQ, trim(upper(DF.DEFINITION)) DEFINITION, 
trim(upper(DF.DEFL_NAME)) DEFL_NAME,trim(upper(DF.LAE_NAME)) LAE_NAME
From
 ( select distinct FIN_VM,FIN_IDSEQ from SBREXT.MDSR_VM_DUP_REF )REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF
where  REF.FIN_IDSEQ=VM.VM_IDSEQ
AND REF.FIN_IDSEQ=i.FIN_IDSEQ
AND VM.VM_IDSEQ=DF.AC_IDSEQ) MS
;

IF V_cntdf>0 then

UPDATE  SBREXT.MDSR_VM_DUP_REF set DEFN='NC'
where VM_IDSEQ=i.VM_IDSEQ;

declare 

cursor C3 is select REF.FIN_VM,REF.FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,DF.DEFIN_IDSEQ,DF.CONTE_IDSEQ, DF.DEFINITION, DF.DEFL_NAME,DF.LAE_NAME
from  SBREXT.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
(select FIN_VM,REF.FIN_IDSEQ,DF.CONTE_IDSEQ, trim(upper(DF.DEFINITION)) DEFINITION, 
trim(upper(DF.DEFL_NAME)) DEFL_NAME,trim(upper(DF.LAE_NAME)) LAE_NAME
from
 SBREXT.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF
where REF.vm_id=VM.vm_id
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND VM.VM_IDSEQ=i.VM_IDSEQ
MINUS
select FIN_VM,REF.FIN_IDSEQ,DF.CONTE_IDSEQ, trim(upper(DF.DEFINITION)) DEFINITION, 
trim(upper(DF.DEFL_NAME)) DEFL_NAME,trim(upper(DF.LAE_NAME)) LAE_NAME
From
 ( select distinct FIN_VM,FIN_IDSEQ from SBREXT.MDSR_VM_DUP_REF )REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF
where  REF.FIN_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND VM.VM_IDSEQ=i.FIN_IDSEQ) MS
where MS.FIN_VM=REF.FIN_VM
AND VM.VM_IDSEQ=REF.VM_IDSEQ
AND VM.VM_IDSEQ=i.VM_IDSEQ
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND MS.CONTE_IDSEQ=DF.CONTE_IDSEQ
and trim(upper(MS.DEFINITION))=trim(upper(DF.DEFINITION))
and MS.DEFL_NAME=trim(upper(DF.DEFL_NAME))
order by 1 desc,3 desc;

begin
for j in C3 loop
begin
v_errm:='DEFINITION of VM:'||j.VM_IDSEQ||' and DEFINITIONS for DEFINITION '||j.DEFINITION||' DEFIN_IDSEQ:' ||j.DEFIN_IDSEQ ||'  not created for VM:'||j.FIN_VM;
insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'SBR.DEFINITIONS','C3',j.VM_IDSEQ,j.VM_ID,v_errm,sysdate );
EXCEPTION
    WHEN others THEN
       V_error := substr(SQLERRM,1,200);     
      insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'MDSR_CHECK_FVM_DES_DEF_CSI','C3',j.VM_IDSEQ,'Last insert',V_error,sysdate );
  commit;
end;
end loop;
end;
commit;
 end if;
 
 ---
  select count(*) into V_cntdscl
 from  
(select FIN_VM,REF.FIN_IDSEQ,DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,
trim(upper(DS.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
  SBREXT.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
 sbrext.ac_att_cscsi_ext AC
where  REF.VM_IDSEQ=VM.VM_IDSEQ
AND REF.VM_IDSEQ=i.VM_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND AC.att_idseq = DS.desig_idseq
MINUS
select FIN_VM,REF.FIN_IDSEQ, DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,
trim(upper(DS.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
 ( select distinct FIN_VM,FIN_IDSEQ from  SBREXT.MDSR_VM_DUP_REF )REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
 sbrext.ac_att_cscsi_ext AC
where  REF.FIN_IDSEQ=VM.VM_IDSEQ
AND REF.FIN_IDSEQ=i.VM_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND AC.att_idseq = DS.desig_idseq) MS
;

IF V_cntdscl>0 then

UPDATE  SBREXT.MDSR_VM_DUP_REF set DES_CL='NC'
where VM_IDSEQ=i.VM_IDSEQ;

declare 
cursor C4 is select REF.FIN_VM,REF.FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,DS.DESIG_IDSEQ,
DS.CONTE_IDSEQ, DS.NAME, DS.DETL_NAME,DS.LAE_NAME,AC.ACA_IDSEQ,AC.CS_CSI_IDSEQ,AC.ATL_NAME
from  SBREXT.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
 sbrext.ac_att_cscsi_ext AC,
(select FIN_VM,REF.FIN_IDSEQ,DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,
trim(upper(DS.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
  SBREXT.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
 sbrext.ac_att_cscsi_ext AC
where  REF.VM_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND AC.att_idseq = DS.desig_idseq
AND REF.VM_IDSEQ=i.VM_IDSEQ
MINUS
select FIN_VM,REF.FIN_IDSEQ, DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,
trim(upper(DS.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
 ( select distinct FIN_VM,FIN_IDSEQ from  SBREXT.MDSR_VM_DUP_REF )REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
 sbrext.ac_att_cscsi_ext AC
where  REF.FIN_IDSEQ=VM.VM_IDSEQ
AND REF.FIN_IDSEQ=i.FIN_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND AC.att_idseq = DS.desig_idseq) MS
where MS.FIN_VM=REF.FIN_VM
AND REF.VM_IDSEQ=VM.VM_IDSEQ
AND REF.VM_IDSEQ=i.VM_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND MS.CONTE_IDSEQ=DS.CONTE_IDSEQ
AND AC.att_idseq = DS.desig_idseq
and trim(upper(MS.NAME))=trim(upper(DS.NAME))
and trim(upper(MS.DETL_NAME))=trim(upper(DS.DETL_NAME))
and  AC.CS_CSI_IDSEQ=MS.CS_CSI_IDSEQ
AND PROC is null
order by 1 desc,3 desc;


 begin
for j in C4 loop
begin
v_errm:='CS_CSI '||j.CS_CSI_IDSEQ||' is not created CLASSIFICATIONS of VM:'||j.FIN_VM||' from VM:'||j.VM_ID||' and DES  '||j.DESIG_IDSEQ ||' and DES_NAME:'||j.NAME;
insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'SBREXT.ac_att_cscsi_ext for DES','C3',j.VM_IDSEQ,j.VM_ID,v_errm,sysdate );
EXCEPTION
    WHEN others THEN
       V_error := substr(SQLERRM,1,200);     
      insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'DEFINITIONS','C3',j.VM_IDSEQ,'Last insert',V_error,sysdate );
  commit;
end;
end loop;
end;
commit;
 end if;
 
 
 
 ---
  select count(*) into V_cntdfcl
from  
(select FIN_VM,REF.FIN_IDSEQ,DF.CONTE_IDSEQ, trim(upper(DF.DEFINITION)) DEFINITION, 
trim(upper(DF.DEFL_NAME)) DEFL_NAME,trim(upper(DF.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
 SBREXT.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
 sbrext.ac_att_cscsi_ext AC
where REF.vm_id=VM.vm_id
AND VM.VM_IDSEQ=i.VM_IDSEQ
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND AC.att_idseq = DF.DEFIN_IDSEQ
MINUS
select FIN_VM,REF.FIN_IDSEQ,DF.CONTE_IDSEQ, trim(upper(DF.DEFINITION)) DEFINITION, 
trim(upper(DF.DEFL_NAME)) DEFL_NAME,trim(upper(DF.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
From
 ( select distinct FIN_VM,FIN_IDSEQ from  SBREXT.MDSR_VM_DUP_REF )REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
 sbrext.ac_att_cscsi_ext AC
where  REF.FIN_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=i.FIN_IDSEQ
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND AC.att_idseq = DF.DEFIN_IDSEQ) MS;

IF V_cntdfcl>0 then

UPDATE  SBREXT.MDSR_VM_DUP_REF set DEFN_CL='NC'
where VM_IDSEQ=i.VM_IDSEQ;

DECLARE
cursor C5 is select REF.FIN_VM,REF.FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,DF.DEFIN_IDSEQ,DF.CONTE_IDSEQ,
 DF.DEFINITION, DF.DEFL_NAME,DF.LAE_NAME,AC.ACA_IDSEQ,  AC.CS_CSI_IDSEQ,AC.ATL_NAME
from  SBREXT.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
 sbrext.ac_att_cscsi_ext AC,
(select FIN_VM,REF.FIN_IDSEQ,DF.CONTE_IDSEQ, trim(upper(DF.DEFINITION)) DEFINITION, 
trim(upper(DF.DEFL_NAME)) DEFL_NAME,trim(upper(DF.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
  SBREXT.MDSR_VM_DUP_REF REF, 
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
 ( select distinct FIN_VM,FIN_IDSEQ from  SBREXT.MDSR_VM_DUP_REF )REF, 
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
begin
for j in C5 loop
begin
--v_errm:='CS_CSI are not created for DEFINITION of VM:'||i.FIN_VM||' from VM:'||i.VM_IDSEQ||'and DEFINITION for CONCEPTS_NAME '||i.CONCEPTS_NAME ||'or LONG_NAME:'||i.LONG_NAME;
 
--insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBREXT.ac_att_cscsi_ext for DEF','C1',i.FIN_VM,i.FIN_IDSEQ,v_errm,sysdate );

v_errm:='DEFINITION of VM:'||j.VM_IDSEQ||'and CLASSIFICATIONS for DEFINITION '||j.DEFINITION||' DEFIN_IDSEQ:' ||j.DEFIN_IDSEQ ||'  not created for VM:'||j.FIN_VM;
insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'SBREXT.AC_ATT_CSCSI_EXT','C5',j.VM_IDSEQ,j.VM_ID,v_errm,sysdate );
EXCEPTION    WHEN others THEN

       V_error := substr(SQLERRM,1,200);     
      insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'SBREXT.AC_ATT_CSCSI_EXT','C5',j.VM_IDSEQ,'Last insert',V_error,sysdate );
  commit;
end;
end loop;
end;
commit;
 end if;
 
 IF V_cntds=0 and V_cntdf=0 and V_cntdscl=0 and V_cntdfcl=0 THEN
 UPDATE  SBREXT.MDSR_VM_DUP_REF set PROC='P',DES=NULL,DEFN=NULL,DES_CL=NULL,DEFN_CL=NULL
where VM_IDSEQ=i.VM_IDSEQ;
commit;
 END IF;
EXCEPTION
    WHEN others THEN
     -- DBMS_OUTPUT.PUT_LINE("No matching result. Please try again.");
     V_error := substr(SQLERRM,1,200);     
      insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'ALL tables','C1','Last update',i.VM_IDSEQ,V_error,sysdate );
  commit;
 end;
end loop;


--UPDATE  SBREXT.MDSR_VM_DUP_REF set PROC='P'
--where DES is null and DEFN is null and DES_CL is null and   DEFN_CL is null;
--commit;
EXCEPTION
    WHEN others THEN
       V_error := substr(SQLERRM,1,200);     
      insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'MDSR_VM_DUP_REF','','','',V_error,sysdate );
  commit;

 END;
/