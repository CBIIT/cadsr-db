BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'clean_QUEST_CONTENTS_EXT',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBREXT.CT_FIX_QUEST_CONTENTS_EXT',
   start_date         =>  '24-AUG-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');   
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'clean_SPCHAR_VV_ATT_EXT',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBREXT.CT_FIX_SPCHAR_VV_ATT_EXT',
   start_date         =>  '24-AUG-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1' /* every  day */
  );   
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'clean_SP_CHAR_VM',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBR.CT_FIX_SP_CHAR_VM',
   start_date         =>  '24-AUG-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');  
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'clean_SP_CHAR_PV',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBR.CT_FIX_SP_CHAR_PV',
   start_date         =>  '24-AUG-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'clean_SP_CHAR_VD',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBR.CT_FIX_VALUE_DOMAINS',
   start_date         =>  '24-AUG-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'clean_SP_CHAR_CD_VMS',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBR.CT_FIX_CD_VMS',
   start_date         =>  '24-AUG-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'clean_SP_CHAR_REF_DOC',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBR.CT_FIX_REF_DOC',
   start_date         =>  '24-AUG-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');Irin@131!qIrin@131!qIrin@131!q
   
END;
/
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'clean_SP_CHAR_PROPERTIES',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBREXT.CT_FIX_PROPERTIES_EXT',
   start_date         =>  '24-AUG-16 10.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;
/

