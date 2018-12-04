create or replace procedure MDSR_CREATE_DUP_VM_DES_DEF
as
cursor C1 is select distinct FIN_VM,FIN_IDSEQ from SBREXT.MDSR_VM_DUP_REF where  PROCESSED='FINAL';

cursor C2 is select FIN_VM,FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,VM.CONTE_IDSEQ,REF.long_name,REF.PREFERRED_DEFINITION,VM.version
from SBR.VALUE_MEANINGS VM,
SBREXT.MDSR_VM_DUP_REF REF
where   VM.VM_IDSEQ=REF.VM_IDSEQ
AND PROCESSED is null;

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
,DATE_MODIFIED=SYSDATE,MODIFIED_BY='SBREXT'
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
VALUES (d_def_id, VM_REC.VM_IDSEQ, VM_REC.conte_idseq,VM_REC.PREFERRED_DEFINITION,'Prior Preferred Definition','ENGLISH', sysdate, 'SBREXT');
end if;

EXCEPTION
    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CREATE_DUP_VM_DES_DEF','SBR.DEFINITIONS', 'C1 LOOP',i.FIN_VM,DEF_REC,V_error,sysdate );
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
where AC_IDSEQ=i.vm_IDSEQ and CONTE_IDSEQ=i.conte_idseq;

If v_cntd>0 then

select count(*) into V_cntd
from SBR.DESIGNATIONS
where AC_IDSEQ=i.FIN_IDSEQ and CONTE_IDSEQ=i.conte_idseq and NAME=i.vm_id||'V'||'1.0 of the retired VM'
 and DETL_NAME='Duplicate VM';

 If v_cntd=0 then
select sbr.admincomponent_crud.cmr_guid into d_desig_id from dual;
 Insert into SBR.DESIGNATIONS
 (DESIG_IDSEQ, AC_IDSEQ, CONTE_IDSEQ, NAME,DETL_NAME,LAE_NAME, DATE_CREATED, CREATED_BY)
 VALUES (d_desig_id, i.FIN_IDSEQ, i.conte_idseq,i.vm_id||'V'||'1.0 of the retired VM','Duplicate VM','ENGLISH', sysdate, 'SBREXT');
end if;

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
 VALUES (d_desig_id, i.FIN_IDSEQ, n.conte_idseq,n.NAME,n.DETL_NAME,n.LAE_NAME, sysdate, 'SBREXT');
END IF;

EXCEPTION
    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
       insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CREATE_VM_DUP_DES_DEF', 'SBR.DESIGNATIONS','INNER LOOP',i.VM_IDSEQ,i.VM_ID,V_error,sysdate );
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
 VALUES (d_desig_id, i.FIN_IDSEQ, n.conte_idseq,n.DEFINITION,n.DEFL_NAME,n.LAE_NAME, sysdate, 'SBREXT');
END IF;
 commit;
EXCEPTION
    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CREATE_DUP_VM_DES_DEFR', 'SBR.DEFINITIONS','INNER LOOP',i.VM_IDSEQ,i.VM_ID,V_error,sysdate );
  commit;
  end;
 end loop;
 END;

commit;
EXCEPTION
    WHEN others THEN

     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CREATE_DUP_VM_DES_DEF', 'SBR.DEFINITIONS','INNER LOOP',F_VM_IDSEQ,'NA',V_error,sysdate );
  commit;
  end;
  end loop;
end MDSR_CREATE_DUP_VM_DES_DEF;
/
create or replace procedure MDSR_CREATE_DUP_VM_CSI
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
AND PROCESSED is null
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
AND PROCESSED is null
order by FIN_VM desc,VM.vm_id desc;

VM_REC SBR.VALUE_MEANINGS%ROWTYPE;
F_VM_IDSEQ SBR.VALUE_MEANINGS.VM_IDSEQ%TYPE;
V_VERS SBR.VALUE_MEANINGS.version%TYPE;
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
insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CREATE_DUP_VM_CSI', 'SBR.DESIGNATIONS','C1',i.VM_IDSEQ,i.VM_ID,v_errm,sysdate );

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

      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CREATE_DUP_VM_CSI', 'sbrext.ac_att_cscsi_ext','C3 LOOP','',V_VM_REC,V_error,sysdate );
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
insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CREATE_DUP_VM_CSI', 'SBR.DESIGNATIONS','C1',j.VM_IDSEQ,j.VM_ID,v_errm,sysdate );

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
VALUES (d_desig_id,j.CS_CSI_IDSEQ, DEF_REC.DEFIN_IDSEQ ,j.ATL_NAME, sysdate, 'SBREXT');
end if;
 commit;
 end if;
EXCEPTION
    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CREATE_DUP_VM_CSI', 'sbrext.ac_att_cscsi_ext','C2 LOOP','',V_VM_REC,V_error,sysdate );
  commit;
  end;

end loop;

 END MDSR_CREATE_DUP_VM_CSI;

/

create or replace procedure MDSR_CHECK_FVM_DES_DEF_CSI
as
cursor C1 is select FIN_VM,FIN_IDSEQ,REF.VM_ID,REF.VM_IDSEQ,VM.CONTE_IDSEQ,REF.CONCEPTS_NAME  ,REF.long_name,REF.PREFERRED_DEFINITION,VM.version
from SBR.VALUE_MEANINGS VM,
SBREXT.MDSR_VM_DUP_REF REF
where   VM.VM_IDSEQ=REF.VM_IDSEQ
AND  PROCESSED   is null;


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


/***************find all designations for record  i.VM_IDSEQ in cursor C1,
all designations for final VM and see if not all designations were created for final VM.
When all designations are created ,V_cntds will be 0
********************/
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
select VM.VM_ID,VM.VM_IDSEQ, DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,trim(upper(DS.LAE_NAME)) LAE_NAME
from
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS
where   VM.VM_IDSEQ=DS.AC_IDSEQ
AND VM.VM_IDSEQ=i.FIN_IDSEQ
)MS;



IF V_cntds=0 then

UPDATE  SBREXT.MDSR_VM_DUP_REF set DES=null
where VM_IDSEQ=i.VM_IDSEQ;
ELSE
-- if not all designations were created ,insert them in SBREXT.MDSR_VM_DUP_ERR table
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
select VM_ID,VM.VM_IDSEQ, DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,trim(upper(DS.LAE_NAME)) LAE_NAME
from
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS
where   VM.VM_IDSEQ=DS.AC_IDSEQ
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
insert into  SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'SBR.DESIGNATIONS','C2',j.VM_IDSEQ,j.VM_ID,v_errm,sysdate );
EXCEPTION
    WHEN others THEN
       V_error := substr(SQLERRM,1,200);
      insert into  SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'DESIGNATIONS','C2',j.VM_IDSEQ,'Last insert',V_error,sysdate );
  commit;
end;
end loop;
end;
commit;
 end if;


/***************find all DEFINITIONS for record  i.VM_IDSEQ in cursor C1,
all DEFINITIONS for final VM and see if not all DEFINITIONS were created for final VM.
When all DEFINITIONS are created ,V_cntds will be 0
********************/

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
select VM.VM_ID,VM.VM_IDSEQ,DF.CONTE_IDSEQ, trim(upper(DF.DEFINITION)) DEFINITION,
trim(upper(DF.DEFL_NAME)) DEFL_NAME,trim(upper(DF.LAE_NAME)) LAE_NAME
From
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF
where  VM.VM_IDSEQ=i.FIN_IDSEQ
AND VM.VM_IDSEQ=DF.AC_IDSEQ) MS
;

IF V_cntdf=0 then
UPDATE  SBREXT.MDSR_VM_DUP_REF set DEFN=NULL
where VM_IDSEQ=i.VM_IDSEQ;

ELSE
-- if not all DEFINITIONS were created ,insert them in SBREXT.MDSR_VM_DUP_ERR table
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
select VM.VM_ID,VM.VM_IDSEQ,DF.CONTE_IDSEQ, trim(upper(DF.DEFINITION)) DEFINITION,
trim(upper(DF.DEFL_NAME)) DEFL_NAME,trim(upper(DF.LAE_NAME)) LAE_NAME
From
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF
where   VM.VM_IDSEQ=DF.AC_IDSEQ
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
insert into  SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'SBR.DEFINITIONS','C3',j.VM_IDSEQ,j.VM_ID,v_errm,sysdate );
EXCEPTION
    WHEN others THEN
       V_error := substr(SQLERRM,1,200);
      insert into  SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_DUP_VM_ERR', 'MDSR_CHECK_FVM_DES_DEF_CSI','C3',j.VM_IDSEQ,'Last insert',V_error,sysdate );
  commit;
end;
end loop;
end;
commit;
 end if;

/***************find all Classifications/designations(CL/DES) for record  i.VM_IDSEQ in cursor C1,
all CL/DES for final VM and see if not all CL/DES were created for final VM.
When allCL/DES are created ,V_cntdscl will be 0
********************/
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
select VM_ID FIN_VM,VM.VM_IDSEQ FIN_IDSEQ, DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,
trim(upper(DS.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
 sbrext.ac_att_cscsi_ext AC
where  VM.VM_IDSEQ=i.FIN_IDSEQ
AND VM.VM_IDSEQ=DS.AC_IDSEQ
AND AC.att_idseq = DS.desig_idseq) MS
;

IF V_cntdscl=0 then
UPDATE  SBREXT.MDSR_VM_DUP_REF set DES_CL=NULL
where VM_IDSEQ=i.VM_IDSEQ;
ELSE
--found missing CL/DES
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
select VM_ID FIN_VM,VM.VM_IDSEQ FIN_IDSEQ, DS.CONTE_IDSEQ, trim(upper(DS.NAME)) NAME, trim(upper(DS.DETL_NAME)) DETL_NAME,
trim(upper(DS.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
from
 SBR.VALUE_MEANINGS VM,
 SBR.DESIGNATIONS DS,
 sbrext.ac_att_cscsi_ext AC
where  VM.VM_IDSEQ=i.FIN_IDSEQ
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
AND  PROCESSED  is null
order by 1 desc,3 desc;

 begin
for j in C4 loop
begin
v_errm:='CS_CSI '||j.CS_CSI_IDSEQ||' is not created CLASSIFICATIONS of VM:'||j.FIN_VM||' from VM:'||j.VM_ID||' and DES  '||j.DESIG_IDSEQ ||' and DES_NAME:'||j.NAME;
insert into  SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'SBREXT.ac_att_cscsi_ext for DES','C4',j.VM_IDSEQ,j.VM_ID,v_errm,sysdate );
  commit;
EXCEPTION
    WHEN others THEN
       V_error := substr(SQLERRM,1,200);
      insert into  SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'DESIGNATIONS','C4',j.VM_IDSEQ,'Last insert',V_error,sysdate );
  commit;
end;
end loop;
end;
commit;
 end if;
/***************find all Classifications/DEFINITIONS(CL/DEFIN) for record  i.VM_IDSEQ in cursor C1,
all CL/DEFIN for final VM and see if not all CL/DEFIN were created for final VM.
When all CL/DEFIN are created ,V_cntdscl will be 0
********************/
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
select VM.VM_ID,VM.VM_IDSEQ,DF.CONTE_IDSEQ, trim(upper(DF.DEFINITION)) DEFINITION,
trim(upper(DF.DEFL_NAME)) DEFL_NAME,trim(upper(DF.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
From
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
 sbrext.ac_att_cscsi_ext AC
where  VM.VM_IDSEQ=i.FIN_IDSEQ
AND VM.VM_IDSEQ=DF.AC_IDSEQ
AND AC.att_idseq = DF.DEFIN_IDSEQ) MS;

IF V_cntdfcl=0 then
UPDATE  SBREXT.MDSR_VM_DUP_REF set DEFN_CL=NULL
where VM_IDSEQ=i.VM_IDSEQ;
ELSE
--found missing CL/DEFIN
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
select VM.VM_ID,VM.VM_IDSEQ,DF.CONTE_IDSEQ, trim(upper(DF.DEFINITION)) DEFINITION,
trim(upper(DF.DEFL_NAME)) DEFL_NAME,trim(upper(DF.LAE_NAME)) LAE_NAME,AC.CS_CSI_IDSEQ,AC.ATL_NAME
From
 SBR.VALUE_MEANINGS VM,
 SBR.DEFINITIONS DF,
 sbrext.ac_att_cscsi_ext AC
where  VM.VM_IDSEQ=i.FIN_IDSEQ
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
insert into  SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'SBREXT.AC_ATT_CSCSI_EXT','C5',j.VM_IDSEQ,j.VM_ID,v_errm,sysdate );
EXCEPTION    WHEN others THEN

       V_error := substr(SQLERRM,1,200);
      insert into  SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'SBREXT.AC_ATT_CSCSI_EXT','C5',j.VM_IDSEQ,'Last insert',V_error,sysdate );
  commit;
end;
end loop;
end;
commit;
 end if;

 IF V_cntds=0 and V_cntdf=0 and V_cntdscl=0 and V_cntdfcl=0 THEN
 UPDATE  SBREXT.MDSR_VM_DUP_REF set  PROCESSED ='P',DES=NULL,DEFN=NULL,DES_CL=NULL,DEFN_CL=NULL
where VM_IDSEQ=i.VM_IDSEQ;
commit;
 END IF;
EXCEPTION
    WHEN others THEN
     -- DBMS_OUTPUT.PUT_LINE("No matching result. Please try again.");
     V_error := substr(SQLERRM,1,200);
      insert into  SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_DUP_VM_ERR', 'ALL tables','C1','Last update',i.VM_IDSEQ,V_error,sysdate );
  commit;
 end;
end loop;

UPDATE  SBREXT.MDSR_VM_DUP_REF set PROCESSED='ERROR'
where DES is not null or DEFN is not null or DES_CL is not null or   DEFN_CL is not null;
commit;
EXCEPTION
    WHEN others THEN
       V_error := substr(SQLERRM,1,200);
      insert into  SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_DUP_VM_ERR', 'MDSR_VM_DUP_REF','','','',V_error,sysdate );
  commit;

 END MDSR_CHECK_FVM_DES_DEF_CSI;
/
create or replace procedure MDSR_VM_DUP_ROLLBACK
as

V_error VARCHAR(300);
CURSOR C is select* from SBREXT.MDSR_VM_DUP_REF where PROCESSED ='ERROR';
begin
 for i in C loop
    begin
UPDATE SBR.VALUE_MEANINGS set ASL_NAME='RELEASED' ,
CHANGE_NOTE=substr(CHANGE_NOTE,INSTR(CHANGE_NOTE, ';',1,1)+1)
where VM_IDSEQ=i.VM_IDSEQ
AND INSTR(CHANGE_NOTE,'Version 1.0 instead. Modified by caDSR script.')>0
AND ASL_NAME like '%RETIRED%' ;
commit;

DELETE
from  SBR.DESIGNATIONS where 1=1--AC_IDSEQ=i.FIN_IDSEQ
AND DETL_NAME='Duplicate VM'
and NAME=i.vm_id||'V'||'1.0 of the retired VM';

commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into MDSR_VM_DUP_ERR VALUES('MDSR_DUP_VM_ROLBACK', 'SBR.VALUE_MEANINGS','STEP 1',i.VM_IDSEQ,i.VM_ID,V_error,sysdate );
  commit;

end;
end loop;
end MDSR_VM_DUP_ROLLBACK;

/