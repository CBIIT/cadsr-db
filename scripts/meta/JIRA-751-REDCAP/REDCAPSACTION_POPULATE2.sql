CREATE OR REPLACE PROCEDURE redCapSaction_populate2 
AS

CURSOR CUR_RC IS select r.protocol,FORM_NAME,r.QUESTION,SECTION, SECTION_SEQ 
FROM REDCAP_PROTOCOL_test r
where NVL(SECTION,'A')<>'A'
and SECTION_SEQ is null
order by r.protocol,FORM_NAME,QUESTION;
 errmsg VARCHAR2(2000):='';
 V_sec_N number;
 V_sec_QN number;
 V_pr_SEC_N number;
 V_MIN_SEC_Q number;
 
BEGIN
for i in CUR_RC loop
BEGIN
 IF i.QUESTION=0 then 
 V_sec_N :=0; 
 V_sec_QN:=0;
 ELSE
 SELECT min(question) into V_MIN_SEC_Q 
 from REDCAP_PROTOCOL_test
 where SECTION is not NULL
 and protocol=i.protocol
 and FORM_NAME=i.FORM_NAME;
 
 IF V_MIN_SEC_Q=i.QUESTION THEN
 
 V_sec_N :=1;
 ELSE
 
 V_sec_N :=V_sec_N+1;
 END IF;
 END IF;
 
 UPDATE REDCAP_PROTOCOL_test SET SECTION_SEQ=V_sec_N , SECTION_Q_SEQ=0
 WHERE protocol=i.protocol
 and FORM_NAME=i.FORM_NAME
 and QUESTION =i.QUESTION
 and SECTION=i.SECTION
 and SECTION_SEQ is null;
 
 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg3 - '||errmsg);
 -- insert into META_CONCEPTS_EXT_ERROR_LOG VALUES (errmsg,sysdate,i.PREFERRED_NAME,i.LONG_NAME ,i.PREFERRED_DEFINITION);
 end; 
 end loop;

commit;

END ;
/