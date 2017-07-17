CREATE OR REPLACE procedure SBREXT.MDSR_CHACK_FVM_DES_DEF_CSI
as

cursor C1 is select FIN_VM,FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,VM.CONTE_IDSEQ,REF.CONCEPTS_NAME  ,REF.long_name,REF.PREFERRED_DEFINITION,VM.version
from SBR.VALUE_MEANINGS VM,
SBREXT.MDSR_VM_DUP_REF REF
where   VM.VM_IDSEQ=REF.VM_IDSEQ
AND PROC is null;

/* cursor C1 collects missing DESIGNATIONS for Final VM 

cursor C1 collects missing DEFINITIONS for Final VM 
cursor C6 is select REF.FIN_VM,REF.FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,DF.DEFIN_IDSEQ,DF.CONTE_IDSEQ, DF.DEFINITION, DF.DEFL_NAME,DF.LAE_NAME
from  SBREXT.MDSR_VM_DUP_REF REF, 
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


-- cursor C1 collects missing CS_CSI_IDSEQ if DESIGNATIONS for Final VM 

cursor C7 is select REF.FIN_VM,REF.FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,DS.DESIG_IDSEQ,
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
MINUS
select FIN_VM,REF.FIN_IDSEQ, DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,
trim(upper(DS.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
 ( select distinct FIN_VM,FIN_IDSEQ from  SBREXT.MDSR_VM_DUP_REF )REF, 
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


-- cursor C4 collects missing CS_CSI_IDSEQ if DEFINITIONS for Final VM 


cursor C8 is select REF.FIN_VM,REF.FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,DF.DEFIN_IDSEQ,DF.CONTE_IDSEQ,
 DF.DEFINITION, DF.DEFL_NAME,DF.LAE_NAME,AC.ACA_IDSEQ,  AC.CS_CSI_IDSEQ,AC.ATL_NAME

order by 1 desc,3 desc;
**/
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
from SBREXT.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
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
)MS
where MS.FIN_VM=REF.FIN_VM
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND MS.CONTE_IDSEQ=DS.CONTE_IDSEQ
and trim(upper(MS.NAME))=trim(upper(DS.NAME))
and MS.DETL_NAME=trim(upper(DS.DETL_NAME));



IF V_cntds>0 then

UPDATE  SBREXT.MDSR_VM_DUP_REF set DES='NC'
where VM_IDSEQ=i.VM_IDSEQ;

v_errm:='DES of VM:'||i.VM_IDSEQ||'and DES for CONCEPTS_NAME '||i.CONCEPTS_NAME  ||'  not created for VM:'||i.FIN_VM;
insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.DESIGNATIONS','C1','',i.FIN_IDSEQ,v_errm,sysdate );

commit;
 end if;
 
 select count(*) into V_cntdf
 from  SBREXT.MDSR_VM_DUP_REF REF, 
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
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

where MS.FIN_VM=REF.FIN_VM
AND REF.VM_IDSEQ=i.VM_IDSEQ
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND MS.CONTE_IDSEQ=DF.CONTE_IDSEQ
and trim(upper(MS.DEFINITION))=trim(upper(DF.DEFINITION))
and MS.DEFL_NAME=trim(upper(DF.DEFL_NAME));

IF V_cntdf>0 then

UPDATE  SBREXT.MDSR_VM_DUP_REF set DEFN='NC'
where VM_IDSEQ=i.VM_IDSEQ;

v_errm:='DES of VM:'||i.VM_IDSEQ||'and DEFINITION for CONCEPTS_NAME '||i.CONCEPTS_NAME  ||'  not created for VM:'||i.FIN_VM;
insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.DESIGNATIONS','C1','',i.FIN_IDSEQ,v_errm,sysdate );

commit;
 end if;
 
 ---
  select count(*) into V_cntdscl
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
where MS.FIN_VM=REF.FIN_VM
AND REF.VM_IDSEQ=VM.VM_IDSEQ
AND REF.VM_IDSEQ=i.VM_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND MS.CONTE_IDSEQ=DS.CONTE_IDSEQ
AND AC.att_idseq = DS.desig_idseq
and trim(upper(MS.NAME))=trim(upper(DS.NAME))
and trim(upper(MS.DETL_NAME))=trim(upper(DS.DETL_NAME))
and  AC.CS_CSI_IDSEQ=MS.CS_CSI_IDSEQ;

IF V_cntdscl>0 then

UPDATE  SBREXT.MDSR_VM_DUP_REF set DES_CL='NC'
where VM_IDSEQ=i.VM_IDSEQ;

v_errm:='CS_CSI are not created designation of VM:'||i.FIN_VM||' from VM:'||i.VM_IDSEQ||'and DES for CONCEPTS_NAME '||i.CONCEPTS_NAME ||' LONG_NAME:'||i.LONG_NAME;
insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.ac_att_cscsi_ext','C3','',i.FIN_IDSEQ,v_errm,sysdate );
commit;
 end if;
 ---
  select count(*) into V_cntdfcl
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
AND AC.att_idseq = DF.DEFIN_IDSEQ) MS

where MS.FIN_VM=REF.FIN_VM
AND REF.VM_IDSEQ=VM.VM_IDSEQ
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND MS.CONTE_IDSEQ=DF.CONTE_IDSEQ
AND AC.att_idseq = DF.DEFIN_IDSEQ
and trim(upper(MS.DEFINITION))=trim(upper(DF.DEFINITION))
and MS.DEFL_NAME=trim(upper(DF.DEFL_NAME))
and  AC.CS_CSI_IDSEQ=MS.CS_CSI_IDSEQ;

IF V_cntdfcl>0 then

UPDATE  SBREXT.MDSR_VM_DUP_REF set DEFN_CL='NC'
where VM_IDSEQ=i.VM_IDSEQ;

v_errm:='CS_CSI are not created for DEFINITION of VM:'||i.FIN_VM||' from VM:'||i.VM_IDSEQ||'and DES for CONCEPTS_NAME '||i.CONCEPTS_NAME ||' LONG_NAME:'||i.LONG_NAME;

insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBR.ac_att_cscsi_ext','C3','',i.FIN_IDSEQ,v_errm,sysdate );

commit;
 end if;
 
 IF V_cntds+V_cntdf+V_cntdscl+V_cntdfcl=0 THEN
 UPDATE  SBREXT.MDSR_VM_DUP_REF set PROC='P'
where VM_IDSEQ=i.VM_IDSEQ;
commit;
 END IF;
EXCEPTION
    WHEN others THEN
     -- DBMS_OUTPUT.PUT_LINE("No matching result. Please try again.");
     V_error := substr(SQLERRM,1,200);     
      insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SNR.DESIGNATIONS','C1 LOOP','',i.FIN_IDSEQ,V_error,sysdate );
  commit;
 end;
end loop;


--UPDATE  SBREXT.MDSR_VM_DUP_REF set PROC='P'
--where DES is null and DEFN is null and DES_CL is null and   DEFN_CL is null;
--commit;
EXCEPTION
    WHEN others THEN
       V_error := substr(SQLERRM,1,200);     
      insert into  SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'MDSR_VM_DUP_REF','Last update','','',V_error,sysdate );
  commit;

 END;
/