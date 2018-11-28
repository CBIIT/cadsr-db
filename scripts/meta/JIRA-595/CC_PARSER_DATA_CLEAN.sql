set serveroutput on size 1000000
SPOOL CCHECKER-595cl.log

CREATE TABLE SBREXT.MDSR_PROC_ERR_LOG
(
  SP_NAME        CHAR(36 BYTE),
  TABLE_NAME     CHAR(40 BYTE),
  TABLE_ID        CHAR(100 BYTE),
  ERROR_TEXT     VARCHAR2(2000 BYTE),
  DATE_CREATED  DATE
);
/
CREATE OR REPLACE PUBLIC SYNONYM MDSR_PROC_ERR_LOG FOR  SBREXT.MDSR_PROC_ERR_LOG
/
GRANT SELECT, DELETE, INSERT, UPDATE ON MDSR_PROC_ERR_LOG TO DER_USER;
/
GRANT SELECT  ON MDSR_PROC_ERR_LOG TO READONLY
/
GRANT SELECT, DELETE, INSERT, REFERENCES, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON MDSR_PROC_ERR_LOG TO SBR WITH GRANT OPTION;
/
CREATE OR REPLACE PROCEDURE SBREXT.CC_PARSER_DATA_CLEAN AS
cursor C_PD is
 select  CCHECKER_IDSEQ 
from SBREXT.CC_PARSER_DATA 
where  to_date(to_char(DATE_CREATED,'MM/DD/YYYY'),'MM/DD/YYYY')< to_date(to_char(SYSDATE-14,'MM/DD/YYYY'),'MM/DD/YYYY');

errmsg VARCHAR2(2000):='';
BEGIN

for i in C_PD loop

begin

delete from SBREXT.CC_PARSER_DATA  where CCHECKER_IDSEQ=i.CCHECKER_IDSEQ;
commit;

  EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLCODE||'-'||substr(SQLERRM,1,200);
         insert into SBREXT.MDSR_PROC_ERR_LOG VALUES('SBREXT.CC_PARSER_DATA_CLEAN','SBREXT.CC_PARSER_DATA',i.CCHECKER_IDSEQ, sysdate ,errmsg);
     commit;
        dbms_output.put_line('errmsg - CCHECKER_IDSEQ:'||i.CCHECKER_IDSEQ||':'||errmsg);
        raise_application_error(-20000, 'errmsg - CCHECKER_IDSEQ:'||i.CCHECKER_IDSEQ||':'||errmsg);
 end;
  end loop;

commit;

END CC_PARSER_DATA_CLEAN;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'clean_CC_PARSER_DATA',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBREXT.CC_PARSER_DATA_CLEAN',
   start_date         =>  '27-NOV-18 11.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=7');   
END;
/
SPOOL OFF;