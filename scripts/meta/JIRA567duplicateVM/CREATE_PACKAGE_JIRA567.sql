set serveroutput on size 1000000
SPOOL cadsrmeta-567b.log
CREATE OR REPLACE PACKAGE SBREXT.MDSR_CLEAN_VM_DUPLICATES AS 
    FUNCTION MDSR_GET_CONCEPT_SYNONYM(p_code IN VARCHAR2 ,p_NAME IN VARCHAR2)
    RETURN NUMBER;   
    PROCEDURE MDSR_CALL_NCI_WEBSERVICE; 
    PROCEDURE MDSR_INSERT_CONCEPT_SYN; 
    PROCEDURE MDSR_INSERT_VM_FINAL_DUP_REF; 
    PROCEDURE MDSR_CREATE_DUP_VM_DES_DEF;    
    PROCEDURE MDSR_CREATE_DUP_VM_CSI; 
    PROCEDURE MDSR_CHECK_FVM_DES_DEF_CSI; 
END MDSR_CLEAN_VM_DUPLICATES;
/
CREATE OR REPLACE PACKAGE BODY SBREXT.MDSR_CLEAN_VM_DUPLICATES AS

 Function MDSR_GET_CONCEPT_SYNONYM( p_code IN varchar2 ,p_NAME IN varchar2)
   RETURN NUMBER
IS
 V_error VARCHAR2 (200);
 V_CNT number:=0;
 V_NAME NUMBER;

BEGIN
SELECT COUNT(*) into V_CNT
FROM SBREXT.MDSR_CONCEPTS_SYNONYMS where TRIM(upper(CODE))=TRIM(upper(P_code))
and TRIM(upper(SYNONYM_NAME))= TRIM(upper(p_NAME));

IF  V_CNT=0 THEN
V_NAME:= 0;
ELSE
V_NAME:= 1;
END IF;
RETURN V_NAME;

EXCEPTION
WHEN OTHERS THEN
    V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBREXT.MDSR_GET_CONCEPT_SYNONYM','NA','P_code','p_NAME',V_error,sysdate );

END MDSR_GET_CONCEPT_SYNONYM;

 procedure MDSR_CALL_NCI_WEBSERVICE as
  t_http_req  utl_http.req;
  t_http_resp  utl_http.resp;
  t_response_text clob;
  t_code varchar2(160);
  errm varchar2(200);
  CURSOR C is
    select distinct c.preferred_name NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME
    FROM ( select distinct
    CONDR_IDSEQ,NAME CONCEPT_CODE,
    trim(regexp_substr(replace(replace(NAME,'Rh Negative Blood Group','C76252'),'Rh Positive Blood Group','C76251'), '[^:]+', 1, levels.column_value)) as preferred_name,levels.column_value ELM_ORDER
    from
    (SELECT distinct dr.NAME NAME,VM.CONDR_IDSEQ
    FROM  SBR.VALUE_MEANINGS VM,
    SBREXT.CON_DERIVATION_RULES_EXT DR,
    (select count(*),CONDR_IDSEQ from SBR.VALUE_MEANINGS VM
    where  UPPER(ASL_NAME) not like '%RETIRED%'
    having count(*)>1GROUP BY CONDR_IDSEQ )VW
    where    VW.CONDR_IDSEQ=VM.CONDR_IDSEQ
    AND  VM.CONDR_IDSEQ=DR.CONDR_IDSEQ
    AND UPPER(ASL_NAME) not like '%RETIRED%'
    AND  instr(NAME,':')>0) t,
    table(cast(multiset(select level from dual connect by level <= length (regexp_replace(t.NAME, '[^:]+')) + 1) as sys.OdciNumberList))
    levels) x,
    sbrext.concepts_ext  c
    where  trim(x.preferred_name)=trim(c.preferred_name)
    union
    SELECT distinct dr.NAME NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME
    FROM  SBR.VALUE_MEANINGS VM,
    SBREXT.CON_DERIVATION_RULES_EXT DR,
    sbrext.concepts_ext  c ,
    (select count(*),CONDR_IDSEQ from SBR.VALUE_MEANINGS VM
    where  UPPER(ASL_NAME) not like '%RETIRED%' and CONDR_IDSEQ is not null
    having count(*)>1GROUP BY CONDR_IDSEQ )VW
    where    VW.CONDR_IDSEQ=VM.CONDR_IDSEQ
    AND  VM.CONDR_IDSEQ=DR.CONDR_IDSEQ
    AND DR.name=c.preferred_name
    AND instr(dr.name,':')=0;

begin
for i in C loop
    begin
  t_code:=i.NAME;
  t_http_req:= utl_http.begin_request('https://lexevscts2.nci.nih.gov/lexevscts2/codesystem/NCI_Thesaurus/entity/'||t_code||'?format=xml','GET','HTTP/1.1');
   t_http_resp:= utl_http.get_response(t_http_req);
  UTL_HTTP.read_text(t_http_resp, t_response_text);
    Insert into SBREXT.MDSR_SYNONYMS_XML(code,long_name,DATE_CREATED,RESP_STATUS,CONCEPT_NAME) values (t_code,t_response_text,SYSDATE,t_http_resp.status_code,i.CONCEPT_NAME);
  commit;


  EXCEPTION
   WHEN OTHERS then
   errm := SUBSTR(SQLERRM,1,199);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBREXT.MDSR_call_webservice','SBREXT.MDSR_SYNONYMS_XML',t_code,i.CONCEPT_NAME,errm,sysdate );

   END;
   utl_http.end_response(t_http_resp);
   END LOOP;

end MDSR_CALL_NCI_WEBSERVICE;

PROCEDURE MDSR_INSERT_CONCEPT_SYN IS
V_concept VARCHAR2 (255);
 V_error VARCHAR2 (2000);
 V_cnt NUMBER;
/******************************************************************************
   NAME:       MMETA_INSERT_CONCEPT_SYN   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0       9/11/2017   trushi2       1. Created this procedure.

******************************************************************************/
cursor C1 is select distinct CODE,CONCEPT_NAME  from SBREXT.MDSR_SYNONYMS_XML where RESP_STATUS=200;
BEGIN

for i in C1 loop
BEGIN
insert into  SBREXT.MDSR_CONCEPTS_SYNONYMS
(
  CODE ,
  CONCEPT_NAME  ,
  SYNONYM_NAME
)

select     i.code ,
           i.CONCEPT_NAME,
           trim(el_NAME)

from (select el_NAME from (
      select distinct UPPER(SUBSTR(element,
  INSTR(element, '<core:value>') + LENGTH('<core:value>')))el_NAME from
      (   with tbl(str) as (
      select trim_name FROM SBREXT.MDSR_SYNONYMS_XML where code =i.code
    )
    SELECT REGEXP_SUBSTR( str ,'(.*?)(</core:value>|$)', 1, LEVEL, NULL, 1 ) AS element
    FROM   tbl
    CONNECT BY LEVEL <= regexp_count(str, '</core:value>')+1)
  )   where el_NAME is not null)

  MINUS

 select CODE ,
  CONCEPT_NAME  ,
  SYNONYM_NAME FROM SBREXT.MDSR_CONCEPTS_SYNONYMS where CODE=i.code
  ;
 commit;
 EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBREXT.META_INSERT_CONCEPT_SYN','SBREXT.MDSR_CONCEPTS_SYNONYMS',i.code,'NA',V_error,sysdate );
  commit;
end;
end loop;

EXCEPTION
    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBREXT.META_INSERT_CONCEPT_SYN','SBREXT.MDSR_CONCEPTS_SYNONYMS','NA','NA',V_error,sysdate );
  commit;
end MDSR_INSERT_CONCEPT_SYN;

procedure MDSR_INSERT_VM_FINAL_DUP_REF
as

V_error VARCHAR(300);
v_cnt0 number;
v_cnt1 number;
v_cnt2 number;
V_run number;

begin

delete from  SBREXT.MDSR_VM_DUP_REF where FIN_IDSEQ =VM_IDSEQ OR PROCESSED IS NULL;
commit;

begin

/**STEP 1A
insert into MDSR_VM_DUP_REF  FINAL VM Records with CONDR_IDSEQ is not null
and Concepts Name not like "integer" and Concepts Name=VM.LONG_NAME
**/
INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PROCESSED,CONCEPT_SYNONYM ,DATE_INSERTED)
 select  distinct FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ,name CONCEPTS_CODE,CONCEPT_NAME,VM_NAME,CONDR_IDSEQ,'FINAL','CONCEPT',SYSDATE from
(
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM
,VM_ID,VM_NAME,CONCEPT_NAME,CONDR_IDSEQ,VM_IDSEQ ,name from
(
select VM_ID,VM_IDSEQ,VM.LONG_NAME VM_NAME,CN.LONG_NAME CONCEPT_NAME,VM.CONDR_IDSEQ,name
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
 and DER.NAME=CN.PREFERRED_NAME
 AND UPPER(VM.ASL_NAME) not like '%RETIRED%'
 AND TRIM(UPPER(VM.LONG_NAME)) =TRIM(UPPER(CN.LONG_NAME))
 AND instr(DER.NAME,'C45255')=0
 ))
 where FIN_VM=VM_ID
 UNION
  select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ,name CONCEPTS_CODE,CONCEPT_NAME,VM_NAME,CONDR_IDSEQ,'FINAL','CONCEPT',SYSDATE from
(
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM
,VM_ID,VM_NAME,CONCEPT_NAME,name,CONDR_IDSEQ,VM_IDSEQ from
(
 SELECT VM_ID,VM_IDSEQ,name,trim(UPPER(CONCEPT_NAME))CONCEPT_NAME,trim(UPPER(LONG_NAME)) VM_NAME,VM.CONDR_IDSEQ,trim(UPPER(vm.DESCRIPTION)) VM_DESCRIPTION
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
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBR.MDSR_VM_DUP_REF','STEP 1A','NA','NA',V_error,sysdate );
  commit;
end;

/**STEP 1B
insert into MDSR_VM_DUP_REF DUP Records for VM with CONDR_IDSEQ is not null
and Concepts Name not like "integer"
a.FIN_VM FINAL VN public ID
a.vm_id RETIRED VM public ID**/
begin

select count(*) into V_cnt0 from SBREXT.MDSR_VM_DUP_REF  R
,SBREXT.CON_DERIVATION_RULES_EXT CN
where R.CONDR_IDSEQ=CN.CONDR_IDSEQ
AND instr(CN.NAME,'C45255')=0;

if V_cnt0=0 then
V_run:=1;
else
select max(RUN_NUMBER)+1 into V_run from SBREXT.MDSR_VM_DUP_REF  R
,SBREXT.CON_DERIVATION_RULES_EXT CN
where R.CONDR_IDSEQ=CN.CONDR_IDSEQ
AND instr(CN.NAME,'C45255')=0;
end if;

INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PREFERRED_DEFINITION,CONCEPT_SYNONYM,DATE_INSERTED)
select distinct FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,PREFERRED_DEFINITION,'CONCEPT',SYSDATE
from
(
(select distinct Rf.FIN_VM,Rf.FIN_IDSEQ ,vm.VM_ID,vm.VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,vm.LONG_NAME,rf.CONDR_IDSEQ ,
UPPER(trim(vm.PREFERRED_DEFINITION))PREFERRED_DEFINITION
 FROM SBREXT.MDSR_VM_DUP_REF RF ,SBR.VALUE_MEANINGS VM
 where Vm.CONDR_IDSEQ=RF.CONDR_IDSEQ
 AND UPPER(VM.ASL_NAME) not like '%RETIRED%'
 AND Rf.FIN_IDSEQ<>vm.VM_IDSEQ 
 AND PROCESSED ='FINAL'
 AND  instr(CONCEPTS_CODE,':')>0
 and instr(CONCEPTS_CODE,'C45255')=0
 and (TRIM(upper(CONCEPTS_NAME))=trim(upper(vm.LONG_NAME)) or trim(UPPER(VM.LONG_NAME))=trim(UPPER(CONCEPTS_NAME))||'S' 
 or MDSR_GET_CONCEPT_SYNONYM(CONCEPTS_CODE,vm.LONG_NAME)=1)
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
 and (TRIM(upper(CONCEPTS_NAME))=trim(upper(vm.LONG_NAME)) or MDSR_GET_CONCEPT_SYNONYM(CONCEPTS_CODE,vm.LONG_NAME)=1
 or trim(UPPER(replace(replace(VM.LONG_NAME,CONCEPTS_CODE,''),':','')))=trim(UPPER(CONCEPTS_NAME))))
 )
order by CONCEPTS_NAME,FIN_VM,VM_ID desc;
commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBR.MDSR_VM_DUP_REF','STEP 1B','NA','NA',V_error,sysdate );
  commit;
end;

/*********
**************
Step 2A Final VM records with  matching synonyms for single concepts
**************
*********/
 begin
 INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PROCESSED,CONCEPT_SYNONYM,DATE_INSERTED)
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ,'FINAL','SYNONYM',SYSDATE
FROM
(select  distinct FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ
from
 (select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM
,VM_ID,CONCEPTS_CODE,CONCEPTS_NAME,CONDR_IDSEQ,VM_IDSEQ ,VM_NAME from

 (select NRF.CONDR_IDSEQ,NRF.NAME CONCEPTS_CODE,C.LONG_NAME CONCEPTS_NAME,VM_ID,VM_IDSEQ,VM.LONG_NAME VM_NAME

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
 AND MDSR_GET_CONCEPT_SYNONYM(NRF.NAME,trim(UPPER(vm.LONG_NAME)))=1))

 WHERE FIN_VM=VM_ID )
ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;
commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBR.MDSR_VM_DUP_REF','STEP 2A','NA','NA',V_error,sysdate );
  commit;
end;
 ----STEP 2B
 --Duplicate VM records for VM with  matching synonyms for single concepts
 begin
  INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,CONCEPT_SYNONYM ,DATE_INSERTED)
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,long_NAME,CONDR_IDSEQ,'SYNONYM',SYSDATE
 FROM
 (select   FIN_VM ,FIN_IDSEQ,VM.VM_ID,VM.VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM.long_NAME,VM.CONDR_IDSEQ
 FROM SBREXT.MDSR_VM_DUP_REF RF,
 SBR.VALUE_MEANINGS VM
 WHERE RF.CONDR_IDSEQ=VM.CONDR_IDSEQ
 AND instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')=0
 and (ASL_NAME) not like '%RETIRED%'
 AND FIN_VM<>VM.VM_ID
 AND MDSR_GET_CONCEPT_SYNONYM(RF.CONCEPTS_CODE,trim(UPPER(vm.LONG_NAME)))=1
 AND  PROCESSED ='FINAL' and CONCEPT_SYNONYM like 'SYNONYM%'
 MINUS
 select   FIN_VM ,FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,long_NAME,CONDR_IDSEQ,CONCEPTS_NAME
 FROM SBREXT.MDSR_VM_DUP_REF WHERE PROCESSED is null and CONCEPT_SYNONYM like 'SYNONYM%')
 ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBR.MDSR_VM_DUP_REF','STEP 2B','NA','NA',V_error,sysdate );
  commit;
end;

/******Step4A****
 ----Final VM records with match to synonyms for multiple concepts
 *****/
BEGIN
 INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PROCESSED,CONCEPT_SYNONYM ,DATE_INSERTED )
select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ,'FINAL','SYNONYM',SYSDATE FROM
(

select  distinct FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ
from
 (
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM
,VM_ID,CONCEPTS_CODE,CONDR_IDSEQ,VM_IDSEQ ,VM_NAME,CONCEPTS_NAME from
(
select CDR.CONDR_IDSEQ,CDR.NAME CONCEPTS_CODE,VM_ID,VM_IDSEQ,VM.LONG_NAME VM_NAME ,CONCEPTS_NAME
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
 AND MDSR_GET_CONCEPT_SYNONYM(CDR.NAME,trim(UPPER(vm.LONG_NAME)))=1
 ) )
 WHERE FIN_VM=VM_ID
)
ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBR.MDSR_VM_DUP_REF','STEP 3A','NA','NA',V_error,sysdate );
  commit;
end;
/*************STEP 3B
---DUP VM records for multiple Concepts
***************/
begin
INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,DATE_INSERTED ,CONCEPT_SYNONYM)
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,long_NAME,CONDR_IDSEQ,SYSDATE,'SYNONYM'
 FROM
(select distinct FIN_VM ,FIN_IDSEQ,VM.VM_ID,VM.VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM.long_NAME,VM.CONDR_IDSEQ,CONCEPT_SYNONYM
 FROM SBREXT.MDSR_VM_DUP_REF RF,
 SBR.VALUE_MEANINGS VM
 WHERE RF.CONDR_IDSEQ=VM.CONDR_IDSEQ
 AND instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')>0
 AND CONCEPT_SYNONYM ='SYNONYM'
 AND (trim(UPPER(RF.LONG_NAME))=trim(UPPER(VM.long_NAME)) OR MDSR_GET_CONCEPT_SYNONYM(RF.CONCEPTS_CODE,trim(UPPER(vm.LONG_NAME)))=1)
 AND trim(UPPER(VM.LONG_NAME))<>trim(UPPER(CONCEPTS_NAME)) 
 AND FIN_VM<>VM.VM_ID
 AND RF.PROCESSED ='FINAL'
 AND VM.ASL_NAME not like '%RETIRED%'
 MINUS
 SELECT FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,CONCEPT_SYNONYM
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
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBR.MDSR_VM_DUP_REF','STEP 3B','NA','NA',V_error,sysdate );
  commit;
end;

/******Step4A****
 ----Final VM records with no match to concepts/synonyms for multiple concepts
 *****/
BEGIN
 INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PROCESSED,CONCEPT_SYNONYM ,DATE_INSERTED )
select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ,'FINAL','NON',SYSDATE FROM
(

select  distinct FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ
from
 (
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM
,VM_ID,CONCEPTS_CODE,CONDR_IDSEQ,VM_IDSEQ ,VM_NAME,CONCEPTS_NAME from
(
select CDR.CONDR_IDSEQ,CDR.NAME CONCEPTS_CODE,VM_ID,VM_IDSEQ,VM.LONG_NAME VM_NAME ,CONCEPTS_NAME
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
 AND MDSR_GET_CONCEPT_SYNONYM(CDR.NAME,trim(UPPER(vm.LONG_NAME)))=0
 ) )
 WHERE FIN_VM=VM_ID
)
ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBR.MDSR_VM_DUP_REF','STEP 4A','NA','NA',V_error,sysdate );
  commit;
end;
/*************STEP 4B
---DUP VM records for multiple Concepts
***************/
begin
  INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,DATE_INSERTED ,CONCEPT_SYNONYM)
 select  distinct FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,long_NAME,CONDR_IDSEQ,SYSDATE,'NON'
 FROM
(select FIN_VM ,FIN_IDSEQ,VM.VM_ID,VM.VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM.long_NAME,VM.CONDR_IDSEQ,CONCEPT_SYNONYM
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
 SELECT FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,CONCEPT_SYNONYM
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
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBR.MDSR_VM_DUP_REF','STEP 4','NA','NA',V_error,sysdate );
  commit;
end;


  /****STEP 5A *****
  ----Final VM records with no match to concepts/synonyms for single concepts
  **********************/
  BEGIN
 INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PROCESSED,CONCEPT_SYNONYM,DATE_INSERTED )
select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ,'FINAL','NON',SYSDATE FROM
(select distinct  FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM_NAME,CONDR_IDSEQ
from
 (
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM
,VM_ID,CONCEPTS_CODE,CONDR_IDSEQ,VM_IDSEQ ,CONCEPTS_NAME,VM_NAME from
(
 select NRF.CONDR_IDSEQ,NRF.NAME CONCEPTS_CODE,VM_ID,VM_IDSEQ,C.LONG_NAME CONCEPTS_NAME,VM.LONG_NAME VM_NAME from
 SBR.VALUE_MEANINGS VM,
  SBREXT.CONCEPTS_EXT C,
 (select a.CONDR_IDSEQ,a.NAME from
 (select count(*),VM.CONDR_IDSEQ,NAME from SBR.VALUE_MEANINGS VM ,
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
 AND NRF.NAME=C.PREFERRED_NAME
 AND VM.ASL_NAME not like '%RETIRED%'
  AND trim(UPPER(VM.LONG_NAME))<>trim(UPPER(C.LONG_NAME)) 
 AND MDSR_GET_CONCEPT_SYNONYM(NRF.NAME,trim(UPPER(vm.LONG_NAME)))=0
 )
 )
 WHERE FIN_VM=VM_ID
)
ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBR.MDSR_VM_DUP_REF','STEP 5A','NA','NA',V_error,sysdate );
  commit;
end;
/**********************STEP 5B
 ---DUP VM records for single Concepts
 ***********************/
 BEGIN
  INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,CONCEPT_SYNONYM ,DATE_INSERTED)
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,long_NAME,CONDR_IDSEQ,'NON',SYSDATE
 FROM
(select distinct FIN_VM ,FIN_IDSEQ,VM.VM_ID,VM.VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM.long_NAME,VM.CONDR_IDSEQ
 FROM SBREXT.MDSR_VM_DUP_REF RF,
 SBR.VALUE_MEANINGS VM
 WHERE RF.CONDR_IDSEQ=VM.CONDR_IDSEQ
 AND instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')=0
 AND CONCEPTS_NAME IS NULL
 AND trim(UPPER(RF.LONG_NAME))=trim(UPPER(VM.long_NAME))
 AND FIN_VM<>VM.VM_ID
 AND RF.PROCESSED ='FINAL'
 AND CONCEPT_SYNONYM='NON'
 and (ASL_NAME) not like '%RETIRED%' 
 AND MDSR_GET_CONCEPT_SYNONYM(RF.CONCEPTS_CODE,trim(UPPER(vm.LONG_NAME)))=0
 )
 ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBR.MDSR_VM_DUP_REF','STEP 5B','NA','NA',V_error,sysdate );
  commit;
end;


/*******************************/


/** STEP 6
insert into MDSR_VM_DUP_REF Records for VM with CONDR_IDSEQ is null
a.FIN_VM FINAL VN public ID
a.vm_id RETIRED VM public ID**/
begin
select count(*) into V_cnt1 from SBREXT.MDSR_VM_DUP_REF where CONDR_IDSEQ is  null;
if V_cnt1=0 then
V_run:=1;
else
select max(RUN_NUMBER)+1 into V_cnt1 from SBREXT.MDSR_VM_DUP_REF where CONDR_IDSEQ is null;
end if;
INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_NAME,LONG_NAME,PREFERRED_DEFINITION,DATE_CREATED,  RUN_NUMBER,DATE_INSERTED )
select
a.FIN_VM,b.VM_IDSEQ,a.vm_id,a.VM_IDSEQ,NULL,a.LONG_NAME,a.PREFERRED_DEFINITION,SYSDATE, V_cnt1,SYSDATE
from
(select  FIN_VM,vm_id,VM_IDSEQ,LONG_NAME,PREFERRED_DEFINITION
from (
select max(VM_ID) over (partition by UPPER(trim(LONG_NAME)),UPPER(trim(PREFERRED_DEFINITION)) order by UPPER(trim(LONG_NAME)),UPPER(trim(PREFERRED_DEFINITION)) ) as FIN_VM,

VM_ID,VM_IDSEQ,UPPER(trim(LONG_NAME))LONG_NAME,UPPER(trim(PREFERRED_DEFINITION))PREFERRED_DEFINITION,CONDR_IDSEQ
from
SBR.VALUE_MEANINGS
where   UPPER(ASL_NAME) not like '%RETIRED%'
and UPPER(trim(LONG_NAME))='NOT EVALUATED'--'9 MONTHS'
and CONDR_IDSEQ is null)
where FIN_VM<>VM_ID
MINUS
select  FIN_VM,vm_id,VM_IDSEQ,UPPER(trim(LONG_NAME))LONG_NAME,UPPER(trim(PREFERRED_DEFINITION))PREFERRED_DEFINITION from SBREXT.MDSR_VM_DUP_REF
where  CONCEPTS_NAME is null and CONDR_IDSEQ is null)a,
SBR.VALUE_MEANINGS b
where a.FIN_VM=b.VM_ID;
commit;

EXCEPTION
    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBREXT.MDSR_VM_DUP_REF','STEP 6','NA','NA',V_error,sysdate );
  commit;
end;

/********* STEP 7 *******************/
/**Insert of duplicate VMs with Concepts(CONDR_IDSEQ is NOT NULL) and  Concepts Name like "integer".**/
begin

select count(*) into V_cnt0 from SBREXT.MDSR_VM_DUP_REF  R
,CON_DERIVATION_RULES_EXT CN
where R.CONDR_IDSEQ=CN.CONDR_IDSEQ
AND instr(CN.NAME,'C45255')>0;

if V_cnt0=0 then
V_run:=1;
else
select max(RUN_NUMBER)+1 into V_run from SBREXT.MDSR_VM_DUP_REF R
,CON_DERIVATION_RULES_EXT CN
where R.CONDR_IDSEQ=CN.CONDR_IDSEQ
AND instr(CN.NAME,'C45255')>0;
end if;
INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_NAME,LONG_NAME,PREFERRED_DEFINITION,DATE_CREATED,  RUN_NUMBER,DATE_INSERTED )
select
a.FIN_VM,b.VM_IDSEQ,a.vm_id,a.VM_IDSEQ,a.CONCEPTS_NAME,a.LONG_NAME,a.PREFERRED_DEFINITION,SYSDATE, V_run,SYSDATE
from
(select  FIN_VM,vm_id,VM_IDSEQ,CONDR_IDSEQ,CONCEPTS_NAME,long_name,trim(upper(PREFERRED_DEFINITION)) PREFERRED_DEFINITION
from (
select max(VM_ID) over  (partition by CN.NAME,trim(upper(CONCEPT_VALUE_AG)) order by CN.NAME,trim(upper(CONCEPT_VALUE_AG)) ) as FIN_VM,
VM_ID,VM_IDSEQ,CN.NAME||'::'||CONCEPT_VALUE_AG CONCEPTS_NAME,VM.CONDR_IDSEQ,vm.long_name,vm.PREFERRED_DEFINITION
from
SBR.VALUE_MEANINGS VM,
SBREXT.CON_DERIVATION_RULES_EXT CN,
(SELECT CONDR_IDSEQ, LISTAGG(CONCEPT_VALUE,',') WITHIN GROUP (ORDER BY CONCEPT_VALUE) as CONCEPT_VALUE_AG
FROM  SBREXT.COMPONENT_CONCEPTS_EXT
where CONCEPT_VALUE is not null
GROUP BY CONDR_IDSEQ)CC
where   VM.CONDR_IDSEQ=CN.CONDR_IDSEQ
AND CC.CONDR_IDSEQ(+)=CN.CONDR_IDSEQ
AND UPPER(ASL_NAME) not like '%RETIRED%'
and instr(CN.NAME,'C45255')>0
and instr(CN.NAME,'XXXC45255')>0

)
where FIN_VM<>VM_ID

MINUS
select  FIN_VM,vm_id,VM_IDSEQ,R.CONDR_IDSEQ,CONCEPTS_NAME ,long_name,trim(upper(PREFERRED_DEFINITION)) PREFERRED_DEFINITION
from SBREXT.MDSR_VM_DUP_REF R,
SBREXT.CON_DERIVATION_RULES_EXT CN
where R.CONDR_IDSEQ=CN.CONDR_IDSEQ
AND instr(CN.NAME,'XXXC45255')>0)a,
SBR.VALUE_MEANINGS b
where a.FIN_VM=b.VM_ID;

commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBR.MDSR_VM_DUP_REF','STEP 7','NA','NA',V_error,sysdate );
  commit;
end;

end MDSR_INSERT_VM_FINAL_DUP_REF;



procedure MDSR_CREATE_DUP_VM_DES_DEF
as
cursor C1 is select distinct FIN_VM,FIN_IDSEQ from SBREXT.MDSR_VM_DUP_REF where  PROCESSED is null;

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
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'MDSR_CREATE_DUP_VM_DES_DEF','C1 LOOP',i.FIN_VM,DEF_REC,V_error,sysdate );
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
where AC_IDSEQ=i.vm_id and CONTE_IDSEQ=i.conte_idseq;

If v_cntd>0 then

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
 VALUES (d_desig_id, i.FIN_IDSEQ, n.conte_idseq,n.DEFINITION,n.DEFL_NAME,n.LAE_NAME, sysdate, 'SBR');
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

procedure MDSR_CREATE_DUP_VM_CSI
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
VALUES (d_desig_id,j.CS_CSI_IDSEQ, DEF_REC.DEFIN_IDSEQ ,j.ATL_NAME, sysdate, 'SBR');
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



procedure MDSR_CHECK_FVM_DES_DEF_CSI
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
AND  PROCESSED  is null
order by 1 desc,3 desc;

 begin
for j in C4 loop
begin
v_errm:='CS_CSI '||j.CS_CSI_IDSEQ||' is not created CLASSIFICATIONS of VM:'||j.FIN_VM||' from VM:'||j.VM_ID||' and DES  '||j.DESIG_IDSEQ ||' and DES_NAME:'||j.NAME;
insert into  SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'SBREXT.ac_att_cscsi_ext for DES','C3',j.VM_IDSEQ,j.VM_ID,v_errm,sysdate );
EXCEPTION
    WHEN others THEN
       V_error := substr(SQLERRM,1,200);
      insert into  SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_CHECK_FVM_DES_DEF_CSI', 'DEFINITIONS','C3',j.VM_IDSEQ,'Last insert',V_error,sysdate );
  commit;
end;
end loop;
end;
commit;
 end if;

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


--UPDATE  SBREXT.MDSR_VM_DUP_REF set PROC='P'
--where DES is null and DEFN is null and DES_CL is null and   DEFN_CL is null;
--commit;
EXCEPTION
    WHEN others THEN
       V_error := substr(SQLERRM,1,200);
      insert into  SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_DUP_VM_ERR', 'MDSR_VM_DUP_REF','','','',V_error,sysdate );
  commit;

 END MDSR_CHECK_FVM_DES_DEF_CSI;

END MDSR_CLEAN_VM_DUPLICATES;
/
SPOOL OFF