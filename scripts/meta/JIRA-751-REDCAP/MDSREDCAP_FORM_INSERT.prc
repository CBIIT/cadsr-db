CREATE OR REPLACE PROCEDURE MDSRedCapSaction_Insert 
AS

 errmsg VARCHAR2(2000):='';
 V_sec_N number;
 V_sec_QN number;
 V_pr_SEC_N number;
 V_MIN_SEC_Q number;
 
BEGIN
 INSERT INTO MSDREDCAP_SECTION_CSV
( PROTOCOL ,
 FORM_NAME ,
 SECTION_SEQ,
 SECTION_Q_SEQ,
 QUESTION ,
 SECTION,
 SECTION_NEW )
 SELECT 
 distinct q.protocol, q.form_name_new,SECTION_SEQ,SECTION_Q_SEQ,FORM_Q_NUM,q.SECTION,
 case
 when q.SECTION is NULL or q.SECTION like '%phenx_%' then substr(q.form_name_new,18) 
   when q.SECTION is not NULL and q.SECTION not like '%phenx_%' then q.SECTION
   end
 --select*
 from MDSR_REDCAP_PROTOCOL_CSV  q
 where SECTION_Q_SEQ=0 ;
 

 
 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg3 - '||errmsg);
  insert into REPORTS_ERROR_LOG VALUES ('Saction_Insert',  errmsg, sysdate);
  commit;

END ;
/