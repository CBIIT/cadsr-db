CREATE OR REPLACE PACKAGE BODY MDSR_CLEAN_VM_DUPLICATES AS 

 Function MDSR_GET_CONCEPT_SYNONYM( p_code IN varchar2 ,p_NAME IN varchar2)
   RETURN NUMBER
IS 
 V_error VARCHAR2 (2000);
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
  
   select distinct preferred_name NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME
   FROM SBREXT.MDSR_CONDR_ID_CONCEPT_EXT x,
   sbrext.concepts_ext  c
   where  trim(CONCEPT_CODE)=trim(c.preferred_name)
    union     
    SELECT distinct dr.NAME NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME
    --select count(*)
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

delete from  SBREXT.MDSR_VM_DUP_REF where FIN_IDSEQ =VM_IDSEQ;
commit;

begin
/**step1 
insert into MDSR_VM_DUP_REF  FINAL VM Records with CONDR_IDSEQ is not null
and Concepts Name not like "integer" and Concepts Name=VM.LONG_NAME
**/
INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PROCESSED,CONCEPT_SYNONYM )
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ,name CONCEPTS_CODE,CONCEPT_NAME,VM_NAME,CONDR_IDSEQ,'FINAL','CONCEPT' from
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
  select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ,name CONCEPTS_CODE,CONCEPT_NAME,VM_NAME,CONDR_IDSEQ,'FINAL','CONCEPT' from
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
and (trim(UPPER(VM.LONG_NAME))=trim(UPPER(CONCEPT_NAME))||'S' or trim(UPPER(VM.LONG_NAME))=trim(UPPER(CONCEPT_NAME)))
and instr(NAME,'C45255')=0 ))
 where FIN_VM=VM_ID
 
 ORDER BY 4,2 desc ;
--and vm.CONDR_IDSEQ='F37D0428-BBB6-6787-E034-0003BA3F9857'
commit;
EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);     
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBR.MDSR_VM_DUP_REF','NA','NA','NA',V_error,sysdate );
  commit;
end;

/**step2 
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
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PREFERRED_DEFINITION)
select distinct FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,PREFERRED_DEFINITION
from
(
(select distinct Rf.FIN_VM,Rf.FIN_IDSEQ ,vm.VM_ID,vm.VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,vm.LONG_NAME,rf.CONDR_IDSEQ ,
UPPER(trim(vm.PREFERRED_DEFINITION))PREFERRED_DEFINITION
 FROM SBREXT.MDSR_VM_DUP_REF RF ,SBR.VALUE_MEANINGS VM 
 where Vm.CONDR_IDSEQ=RF.CONDR_IDSEQ
 AND UPPER(VM.ASL_NAME) not like '%RETIRED%' 
 AND Rf.FIN_IDSEQ<>vm.VM_IDSEQ
 AND  instr(CONCEPTS_CODE,':')>0
 and instr(CONCEPTS_CODE,'C45255')=0 
 and (TRIM(upper(CONCEPTS_NAME))=trim(upper(vm.LONG_NAME)) or trim(UPPER(VM.LONG_NAME))=trim(UPPER(CONCEPTS_NAME))||'S' )
 UNION 
  select distinct Rf.FIN_VM,Rf.FIN_IDSEQ ,vm.VM_ID,vm.VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,vm.LONG_NAME,rf.CONDR_IDSEQ ,
  UPPER(trim(vm.PREFERRED_DEFINITION)) PREFERRED_DEFINITION
 FROM SBREXT.MDSR_VM_DUP_REF RF ,SBR.VALUE_MEANINGS VM 
 where Vm.CONDR_IDSEQ=RF.CONDR_IDSEQ
 AND UPPER(VM.ASL_NAME) not like '%RETIRED%' 
 AND Rf.FIN_IDSEQ<>vm.VM_IDSEQ 
 AND  instr(CONCEPTS_CODE,':')=0
 and instr(CONCEPTS_CODE,'C45255')=0 
 and (TRIM(upper(CONCEPTS_NAME))=trim(upper(vm.LONG_NAME)) or SBREXT.MDSR_GET_CONCEPT_SYN(CONCEPTS_CODE,vm.LONG_NAME)=1
 or trim(UPPER(replace(replace(VM.LONG_NAME,CONCEPTS_CODE,''),':','')))=trim(UPPER(CONCEPTS_NAME))))
 MINUS
 
(Select FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PREFERRED_DEFINITION from SBREXT.MDSR_VM_DUP_REF))
order by CONCEPTS_NAME,FIN_VM,VM_ID desc;
commit;

 ----Final VM records with  matching synonyms
 INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ, PROCESSED,CONCEPT_SYNONYM)
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,'SYNONYM',VM_NAME,CONDR_IDSEQ,'FINAL','SYNONYM'
FROM
(select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,VM_NAME,CONDR_IDSEQ
from
 (select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM 
,VM_ID,CONCEPTS_CODE,CONDR_IDSEQ,VM_IDSEQ ,VM_NAME from

 (select NRF.CONDR_IDSEQ,NRF.NAME CONCEPTS_CODE,VM_ID,VM_IDSEQ,VM.LONG_NAME VM_NAME 
 
 from
 SBR.VALUE_MEANINGS VM,
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
 FROM SBREXT.MDSR_VM_DUP_REF where instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')=0
 ) NRF
 where  NRF.CONDR_IDSEQ=VM.CONDR_IDSEQ
 and (ASL_NAME) not like '%RETIRED%'
 AND SBREXT.MDSR_GET_CONCEPT_SYN(NRF.NAME,vm.LONG_NAME)=1))

 WHERE FIN_VM=VM_ID
 MINUS
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,long_NAME,CONDR_IDSEQ
 FROM SBREXT.MDSR_VM_DUP_REF)
ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;

 ----Duplicate VM records for VM with  matching synonyms
  INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ,CONCEPT_SYNONYM )
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,'SYNONYM',long_NAME,CONDR_IDSEQ,'SYNONYM'
 FROM
 (select   FIN_VM ,FIN_IDSEQ,VM.VM_ID,VM.VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM.long_NAME,VM.CONDR_IDSEQ
 FROM SBREXT.MDSR_VM_DUP_REF RF,
 SBR.VALUE_MEANINGS VM
 WHERE RF.CONDR_IDSEQ=VM.CONDR_IDSEQ
 AND instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')=0
 and (ASL_NAME) not like '%RETIRED%'
 AND FIN_VM<>VM.VM_ID
 AND SBREXT.MDSR_GET_CONCEPT_SYN(RF.CONCEPTS_CODE,vm.LONG_NAME)=1
 AND  PROCESSED ='FINAL' and CONCEPT_SYNONYM like 'SYNONYM%' 
 MINUS
 select   FIN_VM ,FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,long_NAME,CONDR_IDSEQ,CONCEPTS_NAME
 FROM SBREXT.MDSR_VM_DUP_REF WHERE PROCESSED is null and CONCEPT_SYNONYM like 'SYNONYM%')
 ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;
 ----Final VM records with no match to concepts/synonyms for multiple concepts
  
 INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,LONG_NAME,CONDR_IDSEQ, PROCESSED,CONCEPT_SYNONYM  )
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,VM_NAME,CONDR_IDSEQ,'FINAL','NON' FROM
(select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,VM_NAME,CONDR_IDSEQ
from
 (
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM 
,VM_ID,CONCEPTS_CODE,CONDR_IDSEQ,VM_IDSEQ ,VM_NAME from
(
 select NRF.CONDR_IDSEQ,NRF.NAME CONCEPTS_CODE,VM_ID,VM_IDSEQ,VM.LONG_NAME VM_NAME from
 SBR.VALUE_MEANINGS VM,
 (select a.CONDR_IDSEQ,a.NAME from
 (select count(*),VM.CONDR_IDSEQ,NAME from SBR.VALUE_MEANINGS VM ,
 SBREXT.CON_DERIVATION_RULES_EXT  X
 where  X.CONDR_IDSEQ=VM.CONDR_IDSEQ 
 AND  instr(NAME,':')>0
 and (ASL_NAME) not like '%RETIRED%'
 and instr(name,'C45255')=0 
 having count(*)>1GROUP BY VM.CONDR_IDSEQ,NAME )a
minus
select distinct CONDR_IDSEQ,CONCEPTS_CODE 
 FROM SBREXT.MDSR_VM_DUP_REF where instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')>0) NRF
 where  NRF.CONDR_IDSEQ=VM.CONDR_IDSEQ)
 )
 WHERE FIN_VM=VM_ID
 MINUS
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,long_NAME,CONDR_IDSEQ
 FROM SBREXT.MDSR_VM_DUP_REF)
ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;
---DUP VM records for multiple Concepts 
  INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ )
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,long_NAME,CONDR_IDSEQ
 FROM
(select FIN_VM ,FIN_IDSEQ,VM.VM_ID,VM.VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM.long_NAME,VM.CONDR_IDSEQ
 FROM SBREXT.MDSR_VM_DUP_REF RF,
 SBR.VALUE_MEANINGS VM
 WHERE RF.CONDR_IDSEQ=VM.CONDR_IDSEQ 
 AND instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')>0
 AND CONCEPTS_NAME IS NULL
 AND trim(UPPER(RF.LONG_NAME))=trim(UPPER(VM.long_NAME))
  AND FIN_VM<>VM.VM_ID
 AND RF.PROCESSED ='FINAL'
 MINUS
 SELECT FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ
 FROM SBREXT.MDSR_VM_DUP_REF
 WHERE  instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')>0
 AND CONCEPTS_NAME IS NULL
 AND PROCESSED IS NULL)
 ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;
 
  ----Final VM records with no match to concepts/synonyms for single concepts
 INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,LONG_NAME,CONDR_IDSEQ, PROCESSED )
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,VM_NAME,CONDR_IDSEQ,'FINAL' FROM
(select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,VM_NAME,CONDR_IDSEQ
from
 (
select  max(VM_ID) over  (partition by CONDR_IDSEQ order by CONDR_IDSEQ ) as FIN_VM 
,VM_ID,CONCEPTS_CODE,CONDR_IDSEQ,VM_IDSEQ ,VM_NAME from
(
 select NRF.CONDR_IDSEQ,NRF.NAME CONCEPTS_CODE,VM_ID,VM_IDSEQ,VM.LONG_NAME VM_NAME from
 SBR.VALUE_MEANINGS VM,
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
 FROM SBREXT.MDSR_VM_DUP_REF where instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')=0) NRF
 where  NRF.CONDR_IDSEQ=VM.CONDR_IDSEQ)
 )
 WHERE FIN_VM=VM_ID
 MINUS
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,long_NAME,CONDR_IDSEQ
 FROM SBREXT.MDSR_VM_DUP_REF where instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')=0)
ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;
 
 ---DUP VM records for multiple Concepts 
  INSERT INTO SBREXT.MDSR_VM_DUP_REF
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ )
 select   FIN_VM ,VM_IDSEQ FIN_IDSEQ,VM_ID,VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,long_NAME,CONDR_IDSEQ
 FROM
(select FIN_VM ,FIN_IDSEQ,VM.VM_ID,VM.VM_IDSEQ, CONCEPTS_CODE,CONCEPTS_NAME,VM.long_NAME,VM.CONDR_IDSEQ
 FROM SBREXT.MDSR_VM_DUP_REF RF,
 SBR.VALUE_MEANINGS VM
 WHERE RF.CONDR_IDSEQ=VM.CONDR_IDSEQ 
 AND instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')=0
 AND CONCEPTS_NAME IS NULL
 AND trim(UPPER(RF.LONG_NAME))=trim(UPPER(VM.long_NAME))
  AND FIN_VM<>VM.VM_ID
 AND RF.PROCESSED ='FINAL'
 MINUS
 SELECT FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_CODE,CONCEPTS_NAME,LONG_NAME,CONDR_IDSEQ
 FROM SBREXT.MDSR_VM_DUP_REF
 WHERE  instr(CONCEPTS_CODE,'C45255')=0
 AND instr(CONCEPTS_CODE,':')=0
 AND CONCEPTS_NAME IS NULL
 AND PROCESSED IS NULL)
 ORDER BY CONCEPTS_CODE,FIN_VM,VM_ID desc;
 commit;
/*  
 ******************************
 */
  commit;
 EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);     
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBR.MDSR_VM_DUP_REF','NA','NA','NA',V_error,sysdate );
  commit;
end;

/**step3 
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
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_NAME,LONG_NAME,PREFERRED_DEFINITION,DATE_CREATED,  RUN_NUMBER )
select  
a.FIN_VM,b.VM_IDSEQ,a.vm_id,a.VM_IDSEQ,NULL,a.LONG_NAME,a.PREFERRED_DEFINITION,SYSDATE, V_cnt1
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
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBREXT.MDSR_VM_DUP_REF','NA','NA','NA',V_error,sysdate );
  commit;
end;

begin

/**Insert of duplicate VMs with Concepts(CONDR_IDSEQ is NOT NULL) and  Concepts Name like "integer".**/
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
(FIN_VM,FIN_IDSEQ ,VM_ID,VM_IDSEQ,CONCEPTS_NAME,LONG_NAME,PREFERRED_DEFINITION,DATE_CREATED,  RUN_NUMBER )
select  
a.FIN_VM,b.VM_IDSEQ,a.vm_id,a.VM_IDSEQ,a.CONCEPTS_NAME,a.LONG_NAME,a.PREFERRED_DEFINITION,SYSDATE, V_run
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
      insert into SBREXT.MDSR_VM_DUP_ERR VALUES('MDSR_VM_DUP_ERR', 'SBR.MDSR_VM_DUP_REF','NA','NA','NA',V_error,sysdate );
  commit;
end;

end MDSR_INSERT_VM_FINAL_DUP_REF;

   
END MDSR_CLEAN_VM_DUPLICATES; 