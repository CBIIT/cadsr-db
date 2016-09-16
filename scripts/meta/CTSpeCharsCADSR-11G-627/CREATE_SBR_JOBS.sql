BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'cleanSPCH_VM',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBR.META_FIX_SP_CHAR_VM',
   start_date         =>  '15-SEP-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');  
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'cleanSPCH_PV',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBR.META_FIX_SP_CHAR_PV',
   start_date         =>  '15-SEP-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'cleanSPCH_VD',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBR.META_FIX_VALUE_DOMAINS',
   start_date         =>  '15-SEP-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'cleanSPCH_CD_VMS',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBR.META_FIX_CD_VMS',
   start_date         =>  '15-SEP-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'cleanSPCH_REF_DOC',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBR.META_FIX_REF_DOC',
   start_date         =>  '15-SEP-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'cleanSPCH_DATA_ELEMENT_CONC',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBR.META_FIX_DATA_ELEMENT_CONC',
   start_date         =>  '15-SEP-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'cleanSPCH_DATA_ELEMENTS',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBR.META_FIX_DATA_ELEMENTS',
   start_date         =>  '15-SEP-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;
/
