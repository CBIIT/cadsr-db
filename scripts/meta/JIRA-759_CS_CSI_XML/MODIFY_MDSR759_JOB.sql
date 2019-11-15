set serveroutput on size 1000000
SPOOL cadsrmeta-759.log

BEGIN
  DBMS_SCHEDULER.DROP_JOB ('SBREXT.MSDR_GEN_XML_CLCSI_JOB');
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'MSDR_GEN_XML_CLCSI_JOB',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBREXT.MSDR_GEN_XML_CLCSI',
   start_date         =>  '3-OCT-19 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY',
   enabled            =>  TRUE);

END;
/
SPOOL OFF;