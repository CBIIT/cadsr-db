CREATE TABLE SBREXT.MDSR_CONDR_ID_CONCEPT_EXT
(  CONDR_ID  CHAR(60) ,
   CONDR_ID_NAME CHAR(100),
    CONCEPT_CODE CHAR(60),
    ELM_ORDER NUMBER);
  --  DROP table SBREXT.MDSR_CONDR_ID_CONCEPT_EXT;
    
    select* from SBREXT.MDSR_CONDR_ID_CONCEPT_CODE;
    
 INSERT into    SBREXT.MDSR_CONDR_ID_CONCEPT_EXT
 select distinct
 CONDR_ID,CONCEPT_CODE,
 trim(regexp_substr(replace(replace(CONCEPT_CODE,'Rh Negative Blood Group','C76252'),'Rh Positive Blood Group','C76251'), '[^:]+', 1, levels.column_value)) as preferred_name,levels.column_value ELM_ORDER
from 
 (select *from SBREXT.MDSR_CONDR_ID_CONCEPT_CODE 
 where  instr(CONCEPT_CODE,':')>0) t,
 table(cast(multiset(select level from dual connect by level <= length (regexp_replace(t.CONCEPT_CODE, '[^:]+')) + 1) as sys.OdciNumberList))
 levels
 order by CONCEPT_CODE,CONDR_ID,ELM_ORDER;
 
 
 select distinct CONCEPT_CODE from SBREXT.MDSR_CONDR_ID_CONCEPT_EXT;