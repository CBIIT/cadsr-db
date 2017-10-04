CREATE OR REPLACE PROCEDURE SBREXT.META_INSERT_CONCEPT_SYN IS

V_concept VARCHAR2 (255);
 V_error VARCHAR2 (2000);
 V_cnt NUMBER;

/******************************************************************************
   NAME:       MMETA_INSERT_CONCEPT_SYN
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0       9/11/2017   trushi2       1. Created this procedure.


******************************************************************************/
cursor C1 is select distinct CODE,CONCEPT_NAME  from SBREXT.MDSR_SYNONYMS_XML where RESP_STATUS=200;
BEGIN


for i in C1 loop
BEGIN
/*SELECT COUNT(*) INTO  V_cnt from SBREXT.CONCEPTS_EXT where trim(preferred_name)=trim(i.CODE);
if V_cnt>1 then
select trim(upper(long_name)) into V_concept from SBREXT.CONCEPTS_EXT where trim(preferred_name)=trim(i.CODE)
and DATE_MODIFIED =(select max(DATE_MODIFIED)from SBREXT.CONCEPTS_EXT where trim(preferred_name)=trim(i.CODE));
ELSE
select trim(upper(long_name)) into V_concept from SBREXT.CONCEPTS_EXT where trim(preferred_name)=trim(i.CODE);
END IF;
--*/
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
  --*/
 commit;
 EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);     
      insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBREXT.META_INSERT_CONCEPT_SYN','SBREXT.MDSR_CONCEPTS_SYNONYMS',i.code,'NA',V_error,sysdate );
  commit;
end;
end loop;


EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);     
      insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBREXT.META_INSERT_CONCEPT_SYN','SBREXT.MDSR_CONCEPTS_SYNONYMS','NA','NA',V_error,sysdate );
  commit;
end;
END META_INSERT_CONCEPT_SYN;
/