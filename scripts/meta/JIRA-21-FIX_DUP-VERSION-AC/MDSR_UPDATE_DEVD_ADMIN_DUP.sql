set serveroutput on size 1000000
SPOOL DSRMWS-21.log  
CREATE OR REPLACE PROCEDURE SBREXT.MDSR_UPDATE_DEVD_ADMIN_DUP AS
cursor C_AC is
select  public_id, version, --instr(version,'.')  mver,--length(to_char(version))vLen, 
 substr(version,1,instr(version,'.')-1)||'.99' v1,
  CASE 
    WHEN instr(version,'.')=0    THEN to_char(version)||'.99' -- CPU
    ELSE substr(version,1,instr(version,'.')-1)||'.99'
  END new_ver,
  actl_name, 
 CHANGE_NOTE, AC_IDSEQ
FROM SBR.ADMINISTERED_COMPONENTS 
where AC_IDSEQ in 
('B30B7C1F-2DCF-1182-E034-0003BA12F5E7','DDEAEB6E-32A1-3CD4-E034-0003BA12F5E7','DBF67698-F1E1-675B-E034-0003BA12F5E7',
'DB67CC4F-5242-474F-E034-0003BA12F5E7','DBF67698-EE6F-675B-E034-0003BA12F5E7','AECD5F45-40DE-6F74-E034-0003BA12F5E7',
'99BA9DC8-2782-4E69-E034-080020C9C0E0','B96A571D-FCFF-23B9-E034-0003BA12F5E7','C2F74AAA-C66F-2D5B-E034-0003BA12F5E7',
'BAD1CCE2-EEA3-09A9-E034-0003BA12F5E7','9B8825ED-D747-0817-E034-080020C9C0E0','B2044F73-E974-68B8-E034-0003BA12F5E7',
'BFF123A5-B223-1C5B-E034-0003BA12F5E7','BFF123A5-B1F2-1C5B-E034-0003BA12F5E7','DB67CC4F-54E4-474F-E034-0003BA12F5E7',
'E063C484-B72A-4D2C-E034-0003BA12F5E7')
--and public_id in(2015320,2183997)
order by actl_name,public_id;
errmsg VARCHAR2(2000):='';
V_ver VARCHAR2(20):='';
BEGIN

for i in C_AC loop

begin

IF i.actl_name='DATAELEMENT' then 

UPDATE SBR.DATA_ELEMENTS set VERSION=i.new_ver,CHANGE_NOTE=CHANGE_NOTE||' There was a duplicate of Version '||i.version||', changed to '||i.new_ver||' with script for migration on '||sysdate||'.'
where DE_IDSEQ=i.AC_IDSEQ;

ELSIF i.actl_name='VALUEDOMAIN' then 
UPDATE SBR.VALUE_DOMAINS set VERSION=i.new_ver,CHANGE_NOTE=CHANGE_NOTE||' There was a duplicate of Version '||i.version||', changed to '||i.new_ver||' with script for migration on '||sysdate||'.'
where VD_IDSEQ=i.AC_IDSEQ;
END IF;
   commit;
   dbms_output.put_line(i.actl_name||' PubliciD - '||i.public_id|| ', old version - '||i.version||', new version - '||i.new_ver|| ', AC_IDSEQ - '||i.AC_IDSEQ||',Append to CHANGE_NOTE= There was a duplicate of Version '||i.version||', changed to '||i.new_ver||' with script for migration on '||sysdate||'.' );
 EXCEPTION 
    WHEN OTHERS THEN
    errmsg := i.public_id||'v'||i.version||':'||substr(SQLERRM,1,100);
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;
       INSERT INTO SBREXT.MDSR_PROC_ERR_LOG(SP_NAME, TABLE_NAME, TABLE_ID, ERROR_TEXT,  DATE_CREATED)
       values('SBREXT.MDSR_UPDATE_PUBLIC_ID',i.ACTL_NAME,i.public_id,errmsg,SYSDATE);
     commit;
  END;
END LOOP;
END MDSR_UPDATE_DEVD_ADMIN_DUP;
exec SBREXT.MDSR_UPDATE_DEVD_ADMIN_DUP;
SPOOL OFF;