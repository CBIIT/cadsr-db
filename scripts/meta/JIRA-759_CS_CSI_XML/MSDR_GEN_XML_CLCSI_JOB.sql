CREATE OR REPLACE PROCEDURE SBREXT.MSDR_GEN_XML_CLCSI AS
BEGIN
  delete  from SBREXT.MDSR_GENERATED_XML where CREATED_DATE>SYSDATE-30;
  commit;
  SBREXT.MSDR_XML759_Insert;
  SBREXT.MDSR_XML_TRANSFORM;
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'MSDR_GEN_XML_CLCSI_JOB',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBREXT.MSDR_GEN_XML_CLCSI',
   start_date         =>  '3-OCT-19 10.00.00 PM',
   repeat_interval    =>  'FREQ=WEEKLY;INTERVAL=2' /* every  day */
  );   
END;