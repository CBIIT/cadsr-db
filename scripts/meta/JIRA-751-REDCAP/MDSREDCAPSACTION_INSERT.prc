CREATE OR REPLACE PROCEDURE MDSRedCapSaction_populate 
AS

/*CURSOR CUR_RC IS select r.protocol,FORM_NAME,r.QUESTION,SECTION, SECTION_SEQ 
FROM REDCAP_PROTOCOL_test r
where NVL(SECTION,'A')<>'A'
and SECTION_SEQ is null
order by r.protocol,FORM_NAME,QUESTION;*/
    CURSOR CUR_RC IS select protocol,FORM_NAME,FORM_Q_NUM,SECTION, SECTION_SEQ ,SECTION_Q_SEQ
    FROM MDSR_REDCAP_PROTOCOL_CSV 
    where SECTION is not NULL
    and SECTION_SEQ is  null
    and FORM_Q_num is not null
    order by protocol,FORM_NAME,FORM_Q_num; 
     
 errmsg VARCHAR2(2000):='';
 V_sec_N number;
 V_sec_QN number;
 V_pr_SEC_N number;
 V_MIN_SEC_Q number;
 
BEGIN
for i in CUR_RC loop
BEGIN
 IF i.FORM_Q_num=0 then 
 V_sec_N :=0; 
 V_sec_QN:=0;
 ELSE
 SELECT min(FORM_Q_num) into V_MIN_SEC_Q 
 from MDSR_REDCAP_PROTOCOL_CSV
 where SECTION is not NULL
 and protocol=i.protocol
 and FORM_NAME=i.FORM_NAME;
 
 IF V_MIN_SEC_Q=i.FORM_Q_num THEN
 
 V_sec_N :=1;
 ELSE
 
 V_sec_N :=V_sec_N+1;
 END IF;
 END IF;
 
 UPDATE MDSR_REDCAP_PROTOCOL_CSV  SET SECTION_SEQ=V_sec_N , SECTION_Q_SEQ=0
 WHERE protocol=i.protocol
 and FORM_NAME=i.FORM_NAME
 and FORM_Q_num =i.FORM_Q_num
 and SECTION=i.SECTION
 and SECTION_SEQ is null;
 
 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg3 - '||errmsg);
  insert into REPORTS_ERROR_LOG VALUES (i.FORM_Q_NUM||','||i.protocol,  errmsg, sysdate);
  commit;
 end; 
 end loop;

commit;

END ;
/