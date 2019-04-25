CREATE OR REPLACE PROCEDURE MSDRDEV.MDSRedCap_VALVAL_Insert 
AS

 errmsg VARCHAR2(2000):='';
 V_sec_N number;
 V_sec_QN number;
 V_pr_SEC_N number;
 V_MIN_SEC_Q number;
 
BEGIN


-- insert in REDCAP_VALUE_CODE with no pipes, many',' (FIELD_TYPE) not in ('calc','descriptive'); 
  INSERT INTO MSDREDCAP_VALUE_CODE_CSV
 ( PROTOCOL ,
 FORM_NAME ,
 QUESTION ,
 VAL_name ,
 VAL_VALUE ,
 VAL_ORDER,
 PIPE_NUM,
 ELM_ORDER,
 VAL_VAL_NAME)
 select 
 PROTOCOL,
 FORM_NAME_new , 
 question, 
 CASE WHEN trim(choices)='99,99,9999 , unknown'
 THEN '99,99,9999'
 ELSE substr(choices,1,(instr(choices,',')-1))
 END,
 CASE WHEN trim(choices)='99,99,9999 , unknown'
 THEN 'unknown'
 ELSE substr(choices,(instr(choices,',')+1))
 END,
 0,
 0,
 0,
 choices
 from
 (select 
 PROTOCOL,
 FORM_NAME_new ,
 question, 
 cast(trim(CHOICES )  as varchar2(320)) as CHOICES
 from  MDSR_REDCAP_PROTOCOL_CSV
 where dbms_lob.getlength(choices) >0
 and dbms_lob.instr(CHOICES,'|')=0 
 and REGEXP_COUNT(choices,',')>1);

 commit;


--when only 1 separated coma.
 
 INSERT INTO MSDREDCAP_VALUE_CODE_CSV
 ( PROTOCOL ,
 FORM_NAME ,
 QUESTION ,
 VAL_name ,
 VAL_VALUE ,
 VAL_ORDER,
 PIPE_NUM,
 ELM_ORDER,
 VAL_VAL_NAME)

 select 
 PROTOCOL,
 FORM_NAME_NEW ,
 question,
 --cast(trim(CHOICES )  as varchar2(320)) as CHOICES
 cast(trim(substr(choices,1,(instr(choices,',')-1)) )  as varchar2(320)) as CHOICES1 ,
 cast(trim(substr(choices,(instr(choices,',')+1)) )  as varchar2(320)) as CHOICES2,
 0,
 0,
 0,
 choices 
 from MDSR_REDCAP_PROTOCOL_CSV
 where dbms_lob.getlength(choices) >0 and instr(choices,'|')=0
 and REGEXP_COUNT(choices,',')=1 ;--and protocol='PX770301';
 commit;
 
 
INSERT INTO  MSDREDCAP_VALUE_CODE_CSV
( PROTOCOL             ,
FORM_NAME ,
  QUESTION           ,
  VAL_name           ,
  VAL_VALUE            ,
  VAL_ORDER,
  PIPE_NUM,
  ELM_ORDER,
  VAL_VAL_NAME)
  select 
  PROTOCOL,
  FORM_NAME ,
  question,
  substr(CHOICES,1,instr(CHOICES,',')-1) ,--VAL_NAME substring CHOICES before first ',' and ||
  substr(CHOICES,instr(CHOICES,',')+1),--VAL_NAME substring CHOICES after first ',' and  before||
  ELM_ORDER-1,
  PIPE_NUM, --Pipe position in string CHOICES
  ELM_ORDER,
  CHOICES ---substring CHOICES before || 
 from(
 select 
    cast(trim(regexp_substr(t.CHOICES, '[^|]+', 1, levels.column_value)  )  as varchar2(500)) as  CHOICES,levels.column_value  ELM_ORDER, FORM_NAME ,question,
  protocol,dbms_lob.instr(CHOICES,'[^|]+', 1, levels.column_value) AS PIPE_NUM
           from  (select  FORM_NAME_NEW FORM_NAME ,choices,protocol,question from MDSR_REDCAP_PROTOCOL_CSV where dbms_lob.getlength(choices) >0 )t,
      table(cast(multiset(
        select level from dual 
        connect by level <= length (regexp_replace(t.CHOICES, '[^|]+')) + 1
      ) as sys.OdciNumberList)) levels)
      order by 1,3,6;
 commit;     
      ------------------check--------------------------------
      /*
select count(*) cnt,PROTOCOL  ,FORM_NAME ,QUESTION ,VAL_name ,VAL_VALUE ,  VAL_ORDER
from
REDCAP_VALUE_CODE_751
GROUP by PROTOCOL  ,FORM_NAME ,QUESTION ,VAL_name ,VAL_VALUE ,  VAL_ORDER
having count(*)>1--and protocol='PX770301'
order by 2,4,7;


delete from REDCAP_VALUE_CODE_751 where val_name is null and val_value is null


select p.protocol,p.question,p.choices,val_val_name,val_order from 
REDCAP_PROTOCOL_751 p,
REDCAP_VALUE_CODE_751 v 
where p.protocol=v.protocol(+)
and p.question=v.question(+)
and V.protocol is null
and v.question is null
and   dbms_lob.getlength(choices) >0



select distinct question,protocol from  REDCAP_PROTOCOL_751 where dbms_lob.getlength(choices) >0
minus
select distinct question,protocol from  REDCAP_VALUE_CODE_751 */
 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg3 - '||errmsg);
  insert into REPORTS_ERROR_LOG VALUES ('VALUE_Insert',  errmsg, sysdate);
  commit;

END ;
/
