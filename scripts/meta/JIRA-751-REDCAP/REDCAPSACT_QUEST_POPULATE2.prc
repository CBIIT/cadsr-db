CREATE OR REPLACE PROCEDURE MSDRDEV.redCapSact_Quest_populate2
AS

    CURSOR CUR_RC IS select protocol,FORM_NAME,FORM_Q_NUM,SECTION, SECTION_SEQ ,SECTION_Q_SEQ
    FROM MSDRDEV.REDCAP_PROTOCOL_test 
    where SECTION_SEQ is not null
    and SECTION_Q_SEQ=0
    and SECTION is not NULL
    and FORM_Q_NUM is not null
   --and protocol like '%PX741401%'
    order by protocol,FORM_NAME,FORM_Q_NUM;
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
   
     BEGIN
            V_sec_NC:=i.SECTION_SEQ;
            V_QC_NC:=i.FORM_Q_NUM;
            
            select MAX(SECTION_SEQ) into V_sec_MAX
            FROM MSDRDEV.REDCAP_PROTOCOL_TEST
            where  protocol=i.protocol
            and FORM_NAME=i.FORM_NAME
            ; 
            dbms_output.put_line('V_sec_MAX - '||V_sec_MAX||' V_sec_NC -'||i.SECTION_SEQ);
            
            IF V_sec_MAX> i.SECTION_SEQ THEN
            
            --find next section number and seq number in form
            select SECTION_SEQ,FORM_Q_NUM into V_sec_NEXT,V_QC_NCEXT
            FROM MSDRDEV.REDCAP_PROTOCOL_TEST
            where  protocol=i.protocol
            and FORM_NAME=i.FORM_NAME
            and SECTION is not NULL
            and SECTION_SEQ =i.SECTION_SEQ+1;
            END IF;
          


 
            DECLARE
            CURSOR C_nosec IS select protocol,FORM_NAME,FORM_Q_NUM,SECTION, SECTION_SEQ ,SECTION_Q_SEQ
            FROM MSDRDEV.REDCAP_PROTOCOL_test 
            where  protocol=i.protocol
            and FORM_NAME=i.FORM_NAME
            and SECTION is NULL
            and ((FORM_Q_NUM >V_QC_NC and FORM_Q_NUM <V_QC_NCEXT and V_sec_MAX>V_sec_NC) 
            or  (FORM_Q_NUM >V_QC_NC and V_sec_MAX=V_sec_NC))
            order by FORM_Q_NUM;


            BEGIN 
                for r in C_nosec loop
                    BEGIN 
                    UPDATE REDCAP_PROTOCOL_TEST SET SECTION_SEQ=V_sec_NC, SECTION_Q_SEQ=r.FORM_Q_NUM-V_QC_NC
                    WHERE protocol=r.protocol
                    and FORM_NAME=r.FORM_NAME
                    and FORM_Q_NUM =r.FORM_Q_NUM 
                    and SECTION_SEQ is null
                    and SECTION_Q_SEQ is null;

                    --dbms_output.put_line('output2 - V_sec_N='||V_sec_N||' V_sec_QN='||V_sec_QN);
                    commit;

                    EXCEPTION
                    WHEN OTHERS THEN
                    errmsg := SQLERRM;
                    dbms_output.put_line('errmsg3 - '||errmsg);
                    rollback;
                     insert into REPORTS_ERROR_LOG VALUES (r.FORM_Q_NUM||','||r.protocol,  errmsg, sysdate);
                     commit;
                    end;
                end loop;
            END;
            
            EXCEPTION
                    WHEN OTHERS THEN
                    errmsg := SQLERRM;
                    dbms_output.put_line('errmsg3 - '||errmsg);
                    rollback;
                     insert into REPORTS_ERROR_LOG VALUES (i.FORM_Q_NUM||','||i.protocol,  errmsg, sysdate);
                     commit;
            END ;
     end loop;

    
 END ;--end of proc
/