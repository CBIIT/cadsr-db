create or replace procedure MDSR_INSERT_VM_FINAL_DUP_REF1
as

V_error VARCHAR(300);
v_cnt0 number;
v_cnt1 number;
v_cnt2 number;
V_run number;

begin
--select*from SBREXT.MDSR_VM_DUP_REF where FIN_IDSEQ =VM_IDSEQ OR PROCESSED IS NULL;
delete from  SBREXT.MDSR_VM_DUP_REF 
where  instr(CONCEPTS_CODE,'C45255')=0
AND CONDR_IDSEQ is null
AND (FIN_IDSEQ =VM_IDSEQ OR PROCESSED IS NULL);
commit;

begin

/**STEP 1A
******************
insert into MDSR_VM_DUP_REF  FINAL VM Records with CONDR_IDSEQ is not null
and Concepts Name not like "integer" and Concepts Name=VM.LONG_NAME
************/
INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PROCESSED,CONCEPT_SYNONYM ,DATE_INSERTED,PREFERRED_DEFINITION)
 select  distinct FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ,name CONCEPTS_CODE,CONCEPT_NAME,VM_NAME,CONDR_IDSEQ,'FINAL','CONCEPT',SYSDATE,PREFERRED_DEFINITION
  from
(
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM
,VM_ID,VM_NAME,CONCEPT_NAME,CONDR_IDSEQ,VM_IDSEQ ,name,PREFERRED_DEFINITION from
(
select VM_ID,VM_IDSEQ,VM.LONG_NAME VM_NAME,CN.LONG_NAME CONCEPT_NAME,VM.CONDR_IDSEQ,name,
UPPER(trim(VM.PREFERRED_DEFINITION))PREFERRED_DEFINITION
from SBR.VALUE_MEANINGS VM,
SBREXT.CON_DERIVATION_RULES_EXT DER,
SBREXT.CONCEPTS_EXT CN,
(
 select COUNT(*),CONDR_IDSEQ from SBR.VALUE_MEANINGS VM
 where   UPPER(ASL_NAME) not like '%RETIRED%' AND CONDR_IDSEQ is not null
 GROUP BY CONDR_IDSEQ HAVING COUNT(*)>1
 )DUP
 where   VM.CONDR_IDSEQ=DER.CONDR_IDSEQ
 AND VM.CONDR_IDSEQ=DUP.CONDR_IDSEQ
 and replace(DER.NAME,'Rh Positive Blood Group','C76251')=CN.PREFERRED_NAME
 AND UPPER(VM.ASL_NAME) not like '%RETIRED%'
 AND TRIM(UPPER(VM.LONG_NAME)) =TRIM(UPPER(CN.LONG_NAME))
 AND instr(DER.NAME,'C45255')=0
 ))
 where FIN_VM=VM_ID
 UNION
  select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ,name CONCEPTS_CODE,CONCEPT_NAME,VM_NAME,CONDR_IDSEQ,'FINAL','CONCEPT',SYSDATE,PREFERRED_DEFINITION 
  from
(
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM
,VM_ID,VM_NAME,CONCEPT_NAME,name,CONDR_IDSEQ,VM_IDSEQ ,PREFERRED_DEFINITION from
(
 SELECT VM_ID,VM_IDSEQ,name,trim(UPPER(CONCEPT_NAME))CONCEPT_NAME,trim(UPPER(LONG_NAME)) VM_NAME,VM.CONDR_IDSEQ,UPPER(trim(VM.PREFERRED_DEFINITION))PREFERRED_DEFINITION
FROM  SBR.VALUE_MEANINGS VM,
(SELECT M.CONDR_IDSEQ,name, LISTAGG(M.LONG_NAME,' ') WITHIN GROUP (ORDER BY M.ELM_ORDER) as CONCEPT_NAME
FROM  (select CONDR_IDSEQ,name,spl.preferred_name,ELM_ORDER,LONG_NAME
from
(select distinct
 CONDR_IDSEQ,name,
  trim(regexp_substr(replace(replace(name,'Rh Negative Blood Group','C76252'),'Rh Positive Blood Group','C76251'), '[^:]+', 1, levels.column_value)) as preferred_name,levels.column_value ELM_ORDER
from
 (select *from SBREXT.CON_DERIVATION_RULES_EXT
 where  instr(name,':')>0) t,
 table(cast(multiset(select level from dual connect by level <= length (regexp_replace(t.name, '[^:]+')) + 1) as sys.OdciNumberList))
  levels) spl,
  sbrext.concepts_ext  c
  where spl.preferred_name=c.preferred_name) M
GROUP BY name,M.CONDR_IDSEQ)VW,
 (select count(*),CONDR_IDSEQ from SBR.VALUE_MEANINGS VM
 where  UPPER(ASL_NAME) not like '%RETIRED%'
 having count(*)>1GROUP BY CONDR_IDSEQ )DR
where    VW.CONDR_IDSEQ=VM.CONDR_IDSEQ
AND  VW.CONDR_IDSEQ=DR.CONDR_IDSEQ
and UPPER(ASL_NAME) not like '%RETIRED%'
and  trim(UPPER(VM.LONG_NAME))=trim(UPPER(CONCEPT_NAME))
and instr(NAME,'C45255')=0 ))
 where FIN_VM=VM_ID

 ORDER BY 4,2 desc ;
--and vm.CONDR_IDSEQ='F37D0428-BBB6-6787-E034-0003BA3F9857'
commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_INSERT_VM_FINAL_DUP_REF', 'SBR.MDSR_VM_DUP_REF','STEP 1A','NA','NA',V_error,sysdate );
  commit;
end;

/**STEP 1B
insert into MDSR_VM_DUP_REF DUP Records for VM with CONDR_IDSEQ is not null
and Concepts Name not like "integer"
a.FIN_VM FINAL VN public ID
a.vm_id RETIRED VM public ID**/
begin



INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PREFERRED_DEFINITION,CONCEPT_SYNONYM,DATE_INSERTED)
select distinct FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,PREFERRED_DEFINITION,'CONCEPT',SYSDATE
from
(
( select distinct Rf.FIN_VM,Rf.FIN_IDSEQ ,vm.VM_ID,vm.VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,vm.LONG_NAME,rf.CONDR_IDSEQ ,
UPPER(trim(vm.PREFERRED_DEFINITION))PREFERRED_DEFINITION
 FROM SBREXT.MDSR_VM_DUP_REF RF ,SBR.VALUE_MEANINGS VM
 where Vm.CONDR_IDSEQ=RF.CONDR_IDSEQ
 AND UPPER(VM.ASL_NAME) not like '%RETIRED%'
 AND Rf.FIN_IDSEQ<>vm.VM_IDSEQ
 AND PROCESSED ='FINAL'
 and vm.VM_ID in('2575507','3912401')
 AND PROCESSED ='FINAL'
 AND  instr(CONCEPTS_CODE,':')=0
 and instr(CONCEPTS_CODE,'C45255')=0
 and (TRIM(upper(CONCEPTS_NAME))=trim(upper(vm.LONG_NAME))
 OR TRIM(upper(CONCEPTS_NAME))= trim(upper(replace(vm.LONG_NAME ,'C76251','Rh Positive Blood Group')))
 or trim(UPPER(VM.LONG_NAME))=trim(UPPER(CONCEPTS_NAME))||'S'
 or MDSR_CLEAN_VM_DUPLICATES.MDSR_GET_CONCEPT_SYNONYM(CONCEPTS_CODE,vm.LONG_NAME)=1
 or  (replace(replace(replace(replace(replace(TRIM(upper(CONCEPTS_NAME)),'-',' '),'_',' '),',',' '),';',' '),':',' ')=
 replace(replace(replace(replace(replace(replace(trim(upper(vm.LONG_NAME)),'&#8236;'),'-',' '),'_',' '),',',' '),';',' '),':',' ') )
 or trim(UPPER(replace(replace(VM.LONG_NAME,CONCEPTS_CODE,''),':','')))=trim(UPPER(CONCEPTS_NAME)))
 UNION
  select distinct Rf.FIN_VM,Rf.FIN_IDSEQ ,vm.VM_ID,vm.VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,vm.LONG_NAME,rf.CONDR_IDSEQ ,
  UPPER(trim(vm.PREFERRED_DEFINITION)) PREFERRED_DEFINITION
 FROM SBREXT.MDSR_VM_DUP_REF RF ,SBR.VALUE_MEANINGS VM
 where Vm.CONDR_IDSEQ=RF.CONDR_IDSEQ
 AND UPPER(VM.ASL_NAME) not like '%RETIRED%'
 AND Rf.FIN_IDSEQ<>vm.VM_IDSEQ
 AND PROCESSED ='FINAL'
 AND  instr(CONCEPTS_CODE,':')=0
 and instr(CONCEPTS_CODE,'C45255')=0
 and (TRIM(upper(CONCEPTS_NAME))=trim(upper(vm.LONG_NAME))
 or trim(UPPER(VM.LONG_NAME))=trim(UPPER(CONCEPTS_NAME))||'S'
 or MDSR_CLEAN_VM_DUPLICATES.MDSR_GET_CONCEPT_SYNONYM(CONCEPTS_CODE,vm.LONG_NAME)=1
 or  (replace(replace(replace(replace(replace(TRIM(upper(CONCEPTS_NAME)),'-',' '),'_',' '),',',' '),';',' '),':',' ')=
 replace(replace(replace(replace(replace(replace(trim(upper(vm.LONG_NAME)),'&#8236;'),'-',' '),'_',' '),',',' '),';',' '),':',' ') )
 or trim(UPPER(replace(replace(VM.LONG_NAME,CONCEPTS_CODE,''),':','')))=trim(UPPER(CONCEPTS_NAME)))
 )
 )
order by CONCEPTS_NAME,FIN_VM,VM_ID desc;
commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_INSERT_VM_FINAL_DUP_REF', 'SBR.MDSR_VM_DUP_REF','STEP 1B','NA','NA',V_error,sysdate );
  commit;
end;
/*********
**************
Step 2A Final VM records with  matching synonyms for single concepts
**************
*********/
 begin
 INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PROCESSED,CONCEPT_SYNONYM,DATE_INSERTED,PREFERRED_DEFINITION)
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ,'FINAL','SYNONYM',SYSDATE,PREFERRED_DEFINITION
FROM
(select  distinct FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ,PREFERRED_DEFINITION
from
 (select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM
,VM_ID,CONCEPTS_CODE,CONCEPTS_NAME,CONDR_IDSEQ,VM_IDSEQ ,VM_NAME,PREFERRED_DEFINITION from

 (select NRF.CONDR_IDSEQ,NRF.NAME CONCEPTS_CODE,C.LONG_NAME CONCEPTS_NAME,VM_ID,VM_IDSEQ,VM.LONG_NAME VM_NAME,VM.PREFERRED_DEFINITION

 from
 SBR.VALUE_MEANINGS VM,
 SBREXT.CONCEPTS_EXT C,
 ((select CONDR_IDSEQ,NAME from
 (select count(*),VM.CONDR_IDSEQ,NAME from SBR.VALUE_MEANINGS VM ,
 SBREXT.CON_DERIVATION_RULES_EXT  X
 where  X.CONDR_IDSEQ=VM.CONDR_IDSEQ
 AND  instr(NAME,':')=0
 and (ASL_NAME) not like '%RETIRED%'
 and instr(name,'C45255')=0
 having count(*)>1GROUP BY VM.CONDR_IDSEQ,NAME ))
minus
 select distinct CONDR_IDSEQ,CONCEPTS_CODE
 FROM SBREXT.MDSR_VM_DUP_REF where PROCESSED ='FINAL' or PROCESSED is null
 ) NRF
 where  NRF.CONDR_IDSEQ=VM.CONDR_IDSEQ
 AND NRF.NAME=C.PREFERRED_NAME
 and (VM.ASL_NAME) not like '%RETIRED%'
 AND MDSR_CLEAN_VM_DUPLICATES.MDSR_GET_CONCEPT_SYNONYM(NRF.NAME,trim(UPPER(vm.LONG_NAME)))=1))

 WHERE FIN_VM=VM_ID )
ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;
commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_INSERT_VM_FINAL_DUP_REF', 'SBR.MDSR_VM_DUP_REF','STEP 2A','NA','NA',V_error,sysdate );
  commit;
end;
 ----STEP 2B
 --Duplicate VM records for VM with  matching synonyms for single concepts
 begin
  INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,CONCEPT_SYNONYM ,DATE_INSERTED,PREFERRED_DEFINITION)
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,long_NAME,CONDR_IDSEQ,'SYNONYM',SYSDATE,PREFERRED_DEFINITION
 FROM
 (select   FIN_VM ,FIN_IDSEQ,VM.VM_ID,VM.VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM.long_NAME,VM.CONDR_IDSEQ,VM.PREFERRED_DEFINITION
 FROM SBREXT.MDSR_VM_DUP_REF RF,
 SBR.VALUE_MEANINGS VM
 WHERE RF.CONDR_IDSEQ=VM.CONDR_IDSEQ
 AND instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')=0
 and (ASL_NAME) not like '%RETIRED%'
 AND FIN_VM<>VM.VM_ID
 AND (MDSR_CLEAN_VM_DUPLICATES.MDSR_GET_CONCEPT_SYNONYM(RF.CONCEPTS_CODE,trim(UPPER(vm.LONG_NAME)))=1
  or  (replace(replace(replace(replace(replace(TRIM(upper(CONCEPTS_NAME)),'-',' '),'_',' '),',',' '),';',' '),':',' ')=
 replace(replace(replace(replace(replace(replace(trim(upper(vm.LONG_NAME)),'&#8236;'),'-',' '),'_',' '),',',' '),';',' '),':',' ') ))
 AND  PROCESSED ='FINAL' and CONCEPT_SYNONYM like 'SYNONYM%'
 MINUS
 select   FIN_VM ,FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,long_NAME,CONDR_IDSEQ,CONCEPTS_NAME,PREFERRED_DEFINITION
 FROM SBREXT.MDSR_VM_DUP_REF WHERE PROCESSED is null and CONCEPT_SYNONYM like 'SYNONYM%')
 ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_INSERT_VM_FINAL_DUP_REF', 'SBR.MDSR_VM_DUP_REF','STEP 2B','NA','NA',V_error,sysdate );
  commit;
end;

/******Step 3A****
 ----Final VM records with match to synonyms for multiple concepts
 *****/
BEGIN
 INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PROCESSED,CONCEPT_SYNONYM ,DATE_INSERTED,PREFERRED_DEFINITION )
select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ,'FINAL','SYNONYM',SYSDATE,PREFERRED_DEFINITION FROM
(

select  distinct FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ,PREFERRED_DEFINITION
from
 (
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM
,VM_ID,CONCEPTS_CODE,CONDR_IDSEQ,VM_IDSEQ ,VM_NAME,CONCEPTS_NAME,PREFERRED_DEFINITION from
(
select CDR.CONDR_IDSEQ,CDR.NAME CONCEPTS_CODE,VM_ID,VM_IDSEQ,VM.LONG_NAME VM_NAME ,CONCEPTS_NAME,PREFERRED_DEFINITION
from
SBR.VALUE_MEANINGS VM,
 ---
(SELECT M.CONDR_IDSEQ,name, LISTAGG(M.LONG_NAME,' ') WITHIN GROUP (ORDER BY M.ELM_ORDER) as CONCEPTS_NAME
FROM  (select CONDR_IDSEQ,name,spl.preferred_name,ELM_ORDER,LONG_NAME
from
(select distinct
CONDR_IDSEQ,name,
trim(regexp_substr(replace(replace(name,'Rh Negative Blood Group','C76252'),'Rh Positive Blood Group','C76251'), '[^:]+', 1, levels.column_value)) as preferred_name,levels.column_value ELM_ORDER
from
(select *from SBREXT.CON_DERIVATION_RULES_EXT
where  instr(name,':')>0) t,
table(cast(multiset(select level from dual connect by level <= length (regexp_replace(t.name, '[^:]+')) + 1) as sys.OdciNumberList))
levels) spl,
sbrext.concepts_ext  c
where spl.preferred_name=c.preferred_name) M
GROUP BY name,M.CONDR_IDSEQ)    VW,
---
(select a.CONDR_IDSEQ from
 (select count(*),CONDR_IDSEQ
 from SBR.VALUE_MEANINGS VM
 WHERE (ASL_NAME) not like '%RETIRED%'
  having count(*)>1GROUP BY CONDR_IDSEQ )a
 minus
 select distinct CONDR_IDSEQ
 FROM SBREXT.MDSR_VM_DUP_REF where  PROCESSED ='FINAL')X ,

 SBREXT.CON_DERIVATION_RULES_EXT  CDR
 where  X.CONDR_IDSEQ=CDR.CONDR_IDSEQ
 and instr(CDR.name,'C45255')=0
 AND  instr(CDR.NAME,':')>0
 AND  CDR.CONDR_IDSEQ=VM.CONDR_IDSEQ
 AND VM.CONDR_IDSEQ=VW.CONDR_IDSEQ
 and (ASL_NAME) not like '%RETIRED%'
 AND trim(UPPER(VM.LONG_NAME))<>trim(UPPER(CONCEPTS_NAME))
 AND MDSR_CLEAN_VM_DUPLICATES.MDSR_GET_CONCEPT_SYNONYM(CDR.NAME,trim(UPPER(vm.LONG_NAME)))=1
 ) )
 WHERE FIN_VM=VM_ID
)
ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_INSERT_VM_FINAL_DUP_REF', 'SBR.MDSR_VM_DUP_REF','STEP 3A','NA','NA',V_error,sysdate );
  commit;
end;
/*************STEP 3B
---DUP VM records for multiple Concepts
***************/
begin
INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,DATE_INSERTED ,CONCEPT_SYNONYM,PREFERRED_DEFINITION)
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,long_NAME,CONDR_IDSEQ,SYSDATE,'SYNONYM',PREFERRED_DEFINITION
 FROM
(select distinct FIN_VM ,FIN_IDSEQ,VM.VM_ID,VM.VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM.long_NAME,VM.CONDR_IDSEQ,CONCEPT_SYNONYM,VM.PREFERRED_DEFINITION
 FROM SBREXT.MDSR_VM_DUP_REF RF,
 SBR.VALUE_MEANINGS VM
 WHERE RF.CONDR_IDSEQ=VM.CONDR_IDSEQ
 AND instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')>0
 AND CONCEPT_SYNONYM ='SYNONYM'
 AND (trim(UPPER(RF.LONG_NAME))=trim(UPPER(VM.long_NAME))
 or  (replace(replace(replace(replace(replace(TRIM(upper(RF.LONG_NAME)),'-',' '),'_',' '),',',' '),';',' '),':',' ')=
 replace(replace(replace(replace(replace(replace(trim(upper(vm.LONG_NAME)),'&#8236;'),'-',' '),'_',' '),',',' '),';',' '),':',' ') )
 OR MDSR_CLEAN_VM_DUPLICATES.MDSR_GET_CONCEPT_SYNONYM(RF.CONCEPTS_CODE,trim(UPPER(vm.LONG_NAME)))=1)
 AND trim(UPPER(VM.LONG_NAME))<>trim(UPPER(CONCEPTS_NAME))
 AND FIN_VM<>VM.VM_ID
 AND RF.PROCESSED ='FINAL'
 AND VM.ASL_NAME not like '%RETIRED%'
 MINUS
 SELECT FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,CONCEPT_SYNONYM,PREFERRED_DEFINITION
 FROM SBREXT.MDSR_VM_DUP_REF
 WHERE  instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')>0
 AND CONCEPT_SYNONYM ='SYNONYM'
 AND trim(UPPER(LONG_NAME))<>trim(UPPER(CONCEPTS_NAME))
 AND PROCESSED IS NULL)
 ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_INSERT_VM_FINAL_DUP_REF', 'SBR.MDSR_VM_DUP_REF','STEP 3B','NA','NA',V_error,sysdate );
  commit;
end;

/******Step4A****
 ----Final VM records with no match to concepts/synonyms for multiple concepts
 *****/
BEGIN
 INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PROCESSED,CONCEPT_SYNONYM ,DATE_INSERTED,PREFERRED_DEFINITION )
select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ,'FINAL','NON',SYSDATE,PREFERRED_DEFINITION FROM
(

select  distinct FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ,PREFERRED_DEFINITION
from
 (
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM
,VM_ID,CONCEPTS_CODE,CONDR_IDSEQ,VM_IDSEQ ,VM_NAME,CONCEPTS_NAME,PREFERRED_DEFINITION from
(
select CDR.CONDR_IDSEQ,CDR.NAME CONCEPTS_CODE,VM_ID,VM_IDSEQ,VM.LONG_NAME VM_NAME ,CONCEPTS_NAME,PREFERRED_DEFINITION
from
SBR.VALUE_MEANINGS VM,
 ---
(SELECT M.CONDR_IDSEQ,name, LISTAGG(M.LONG_NAME,' ') WITHIN GROUP (ORDER BY M.ELM_ORDER) as CONCEPTS_NAME
FROM  (select CONDR_IDSEQ,name,spl.preferred_name,ELM_ORDER,LONG_NAME
from
(select distinct
CONDR_IDSEQ,name,
trim(regexp_substr(replace(replace(name,'Rh Negative Blood Group','C76252'),'Rh Positive Blood Group','C76251'), '[^:]+', 1, levels.column_value)) as preferred_name,levels.column_value ELM_ORDER
from
(select *from SBREXT.CON_DERIVATION_RULES_EXT
where  instr(name,':')>0) t,
table(cast(multiset(select level from dual connect by level <= length (regexp_replace(t.name, '[^:]+')) + 1) as sys.OdciNumberList))
levels) spl,
sbrext.concepts_ext  c
where spl.preferred_name=c.preferred_name) M
GROUP BY name,M.CONDR_IDSEQ)    VW,
---
(select a.CONDR_IDSEQ from
 (select count(*),CONDR_IDSEQ
 from SBR.VALUE_MEANINGS VM
 WHERE (ASL_NAME) not like '%RETIRED%'
  having count(*)>1GROUP BY CONDR_IDSEQ )a
 minus
 select distinct CONDR_IDSEQ
 FROM SBREXT.MDSR_VM_DUP_REF where  PROCESSED ='FINAL')X ,

 SBREXT.CON_DERIVATION_RULES_EXT  CDR
 where  X.CONDR_IDSEQ=CDR.CONDR_IDSEQ
 and instr(CDR.name,'C45255')=0
 AND  instr(CDR.NAME,':')>0
 AND  CDR.CONDR_IDSEQ=VM.CONDR_IDSEQ
 AND VM.CONDR_IDSEQ=VW.CONDR_IDSEQ
 and (ASL_NAME) not like '%RETIRED%'
 AND trim(UPPER(VM.LONG_NAME))<>trim(UPPER(CONCEPTS_NAME))
 AND MDSR_CLEAN_VM_DUPLICATES.MDSR_GET_CONCEPT_SYNONYM(CDR.NAME,trim(UPPER(vm.LONG_NAME)))=0
 ) )
 WHERE FIN_VM=VM_ID
)
ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_INSERT_VM_FINAL_DUP_REF', 'SBR.MDSR_VM_DUP_REF','STEP 4A','NA','NA',V_error,sysdate );
  commit;
end;
/*************STEP 4B
---DUP VM records for multiple Concepts
***************/
begin
  INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,DATE_INSERTED ,CONCEPT_SYNONYM,PREFERRED_DEFINITION)
 select  distinct FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,long_NAME,CONDR_IDSEQ,SYSDATE,'NON',PREFERRED_DEFINITION
 FROM
(select FIN_VM ,FIN_IDSEQ,VM.VM_ID,VM.VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM.long_NAME,VM.CONDR_IDSEQ,CONCEPT_SYNONYM,VM.PREFERRED_DEFINITION
 FROM SBREXT.MDSR_VM_DUP_REF RF,
 SBR.VALUE_MEANINGS VM
 WHERE RF.CONDR_IDSEQ=VM.CONDR_IDSEQ
 AND instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')>0
 AND CONCEPT_SYNONYM ='NON'
 AND trim(UPPER(RF.LONG_NAME))=trim(UPPER(VM.long_NAME))
 AND FIN_VM<>VM.VM_ID
 AND RF.PROCESSED ='FINAL'
 AND VM.ASL_NAME not like '%RETIRED%'
 MINUS
 SELECT FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,CONCEPT_SYNONYM,PREFERRED_DEFINITION
 FROM SBREXT.MDSR_VM_DUP_REF
 WHERE  instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')>0
 AND CONCEPT_SYNONYM ='NON'
 AND PROCESSED IS NULL)
 ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_INSERT_VM_FINAL_DUP_REF', 'SBR.MDSR_VM_DUP_REF','STEP 4','NA','NA',V_error,sysdate );
  commit;
end;


  /****STEP 5A *****
  ----Final VM records with no match to concepts/synonyms for single concepts
  **********************/
  BEGIN
 INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PROCESSED,CONCEPT_SYNONYM,DATE_INSERTED,PREFERRED_DEFINITION )
select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ,'FINAL','NON',SYSDATE,PREFERRED_DEFINITION FROM
(select distinct  FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ,PREFERRED_DEFINITION
from
 (
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM
,VM_ID,CONCEPTS_CODE,CONDR_IDSEQ,VM_IDSEQ ,CONCEPTS_NAME,VM_NAME,PREFERRED_DEFINITION from
(
 select NRF.CONDR_IDSEQ,NRF.NAME CONCEPTS_CODE,VM_ID,VM_IDSEQ,C.LONG_NAME CONCEPTS_NAME,VM.LONG_NAME VM_NAME,VM.PREFERRED_DEFINITION from
 SBR.VALUE_MEANINGS VM,
  SBREXT.CONCEPTS_EXT C,
 (select a.CONDR_IDSEQ,a.NAME from
 (select count(*),VM.CONDR_IDSEQ,replace(NAME,'Rh Positive Blood Group','C76251') NAME from SBR.VALUE_MEANINGS VM ,
 SBREXT.CON_DERIVATION_RULES_EXT  X
 where  X.CONDR_IDSEQ=VM.CONDR_IDSEQ
 AND  instr(NAME,':')=0
 and (ASL_NAME) not like '%RETIRED%'
 and instr(name,'C45255')=0
 having count(*)>1GROUP BY VM.CONDR_IDSEQ,NAME )a
minus
 select distinct CONDR_IDSEQ,CONCEPTS_CODE
 FROM SBREXT.MDSR_VM_DUP_REF
 where instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')=0) NRF
 where  NRF.CONDR_IDSEQ=VM.CONDR_IDSEQ
 AND replace(NRF.NAME,'Rh Positive Blood Group','C76251')=C.PREFERRED_NAME
 AND VM.ASL_NAME not like '%RETIRED%'
  AND trim(UPPER(VM.LONG_NAME))<>trim(UPPER(C.LONG_NAME))
 AND MDSR_CLEAN_VM_DUPLICATES.MDSR_GET_CONCEPT_SYNONYM(NRF.NAME,trim(UPPER(vm.LONG_NAME)))=0
 )
 )
 WHERE FIN_VM=VM_ID
)
ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_INSERT_VM_FINAL_DUP_REF', 'SBR.MDSR_VM_DUP_REF','STEP 5A','NA','NA',V_error,sysdate );
  commit;
end;
/**********************STEP 5B
 ---DUP VM records for single Concepts
 ***********************/
 BEGIN
  INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,CONCEPT_SYNONYM ,DATE_INSERTED,PREFERRED_DEFINITION)
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,long_NAME,CONDR_IDSEQ,'NON',SYSDATE,PREFERRED_DEFINITION
 FROM
(select distinct FIN_VM ,FIN_IDSEQ,VM.VM_ID,VM.VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM.long_NAME,VM.CONDR_IDSEQ,VM.PREFERRED_DEFINITION
 FROM SBREXT.MDSR_VM_DUP_REF RF,
 SBR.VALUE_MEANINGS VM
 WHERE RF.CONDR_IDSEQ=VM.CONDR_IDSEQ
 AND instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')=0
 AND CONCEPTS_NAME IS NULL
 AND (trim(UPPER(RF.LONG_NAME))=trim(UPPER(VM.long_NAME))
 or  (replace(replace(replace(replace(replace(TRIM(upper(RF.LONG_NAME)),'-',' '),'_',' '),',',' '),';',' '),':',' ')<>
 replace(replace(replace(replace(replace(replace(trim(upper(vm.LONG_NAME)),'&#8236;'),'-',' '),'_',' '),',',' '),';',' '),':',' ') ))
 AND FIN_VM<>VM.VM_ID
 AND RF.PROCESSED ='FINAL'
 AND CONCEPT_SYNONYM='NON'
 and (ASL_NAME) not like '%RETIRED%'
 AND (MDSR_CLEAN_VM_DUPLICATES.MDSR_GET_CONCEPT_SYNONYM(RF.CONCEPTS_CODE,trim(UPPER(vm.LONG_NAME)))=0)
 )
 ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_INSERT_VM_FINAL_DUP_REF', 'SBR.MDSR_VM_DUP_REF','STEP 5B','NA','NA',V_error,sysdate );
  commit;
end;




end MDSR_INSERT_VM_FINAL_DUP_REF1;
