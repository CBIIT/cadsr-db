CREATE OR REPLACE PROCEDURE MSDRDEV.redCapSact_Quest_populate2
AS

    CURSOR CUR_RC IS select protocol,FORM_NAME,QUESTION,SECTION, SECTION_SEQ ,SECTION_Q_SEQ
    FROM MSDRDEV.REDCAP_PROTOCOL_test 
    where SECTION is not NULL
    and SECTION_SEQ is not null
    --and protocol like '%PX741401%'
    order by protocol,FORM_NAME,QUESTION;
    errmsg VARCHAR2(2000):='';
    V_sec_NC number;
    V_sec_QN number;
    V_sec_NEXT number;
    V_sec_MAX number;
    V_sec_QN number;
    V_QC_NC number;
    V_QC_NCEXT number;
    

  BEGIN
   for i in CUR_RC loop
            V_sec_NC:=i.SECTION_SEQ;
            V_QC_NC:=i.QUESTION;
            select MAX(SECTION_SEQ) into V_sec_MAX
            FROM MSDRDEV.REDCAP_PROTOCOL_TEST
            where  protocol=i.protocol
            and FORM_NAME=i.FORM_NAME
            ;
            IF V_sec_MAX> i.SECTION_SEQ THEN
            select SECTION_SEQ,QUESTION into V_sec_NEXT,V_QC_NCEXT
            FROM MSDRDEV.REDCAP_PROTOCOL_TEST
            where  protocol=i.protocol
            and FORM_NAME=i.FORM_NAME
            and SECTION is not NULL
            and SECTION_SEQ =i.SECTION_SEQ+1;
            END IF;
          
 dbms_output.put_line('V_sec_MAX - '||V_sec_MAX||' V_sec_NC -'||i.SECTION_SEQ);

 
            DECLARE
            CURSOR C_nosec IS select protocol,FORM_NAME,QUESTION,SECTION, SECTION_SEQ ,SECTION_Q_SEQ
            FROM MSDRDEV.REDCAP_PROTOCOL_test 
            where  protocol=i.protocol
            and FORM_NAME=i.FORM_NAME
            and SECTION is NULL
            and ((QUESTION >V_QC_NC and QUESTION <V_QC_NCEXT and V_sec_MAX>V_sec_NC) 
            or  (QUESTION >V_QC_NC and V_sec_MAX=V_sec_NC))
            order by QUESTION;


            BEGIN 
                for r in C_nosec loop
                    BEGIN 
                    UPDATE REDCAP_PROTOCOL_TEST SET SECTION_SEQ=V_sec_NC, SECTION_Q_SEQ=r.QUESTION-V_QC_NC
                    WHERE protocol=r.protocol
                    and FORM_NAME=r.FORM_NAME
                    and QUESTION =r.QUESTION ;

                    --dbms_output.put_line('output2 - V_sec_N='||V_sec_N||' V_sec_QN='||V_sec_QN);
                    commit;

                    EXCEPTION
                    WHEN OTHERS THEN
                    errmsg := SQLERRM;
                    dbms_output.put_line('errmsg3 - '||errmsg);
                   -- rollback;
                     insert into REPORTS_ERROR_LOG VALUES (r.QUESTION||','||r.protocol,  errmsg, sysdate);
                     commit;
                    end;
                end loop;
            END;
     end loop;

    --END ;
 END ;--end of proc
/