BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'cleanSPCH_VV_ATT_EXT',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBREXT.META_FIX_SPCHAR_VV_ATT_EXT',
   start_date         =>  '15-SEP-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1' 
END;
/

BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'cleanSPCH_PROPERTIES',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBREXT.META_FIX_PROPERTIES_EXT',
   start_date         =>  '15-SEP-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;
/

BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'cleanSPCH_REPRESENT_EXT',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBREXT.META_FIX_REPRESENTATIONS_EXT',
   start_date         =>  '15-SEP-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'cleanSPCH_OBJECT_CLASSES',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBREXT.META_FIX_OBJECT_CLASSES_EXT',
   start_date         =>  '15-SEP-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;
/

