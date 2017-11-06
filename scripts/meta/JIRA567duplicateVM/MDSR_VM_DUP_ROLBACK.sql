CREATE OR REPLACE procedure SBREXT.MDSR_VM_DUP_ROLBACK
as

V_error VARCHAR(300);
v_cnt0 number;
v_cnt1 number;
v_cnt2 number;
V_run number;
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
--DELETE from SBR.DEFINITIONS where AC_IDSEQ=i.FIN_IDSEQ and 
--DEFL_NAME='Prior Preferred Definition'
--AND TO_CHAR(DATE_CREATED,'MM/DD/YYYY')= TO_CHAR(i.DATE_CREATED,'MM/DD/YYYY')
--AND CREATED_BY='SBREXT';
--commit;
DELETE
--select*
from  SBR.DESIGNATIONS where 1=1--AC_IDSEQ=i.FIN_IDSEQ
AND DETL_NAME='Duplicate VM'
and NAME=i.vm_id||'V'||'1.0 of the retired VM';


commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_DUP_VM_ROLBACK', 'SBR.VALUE_MEANINGS','STEP 1',i.VM_IDSEQ,i.VM_ID,V_error,sysdate );
  commit;
  
end;
end loop;
end MDSR_VM_DUP_ROLBACK;
/
