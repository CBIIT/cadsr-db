BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'clean_SP_CHAR_QUEST_CONTENTS',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBREXT.CT_FIX_QUEST_CONTENTS_EXT',
   start_date         =>  '28-APR-08 07.00.00 PM',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;

BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'clean_SP_CHAR_QUEST_CONTENTS',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBREXT.CT_FIX_SPCHAR_VV_ATT_EXT',
   start_date         =>  '28-APR-08 07.00.00 PM ',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1' /* every  day */
  );
   
END;
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'clean_SP_CHAR_QUEST_CONTENTS',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBR.SBR.CT_FIX_SP_CHAR_VM',
   start_date         =>  '28-APR-08 07.00.00 PM ',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;

BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'clean_SP_CHAR_QUEST_CONTENTS',
   job_type           =>  'STORED_PROCEDURE',
   job_action         =>  'SBR.SBR.CT_FIX_SP_CHAR_VM',
   start_date         =>  '28-APR-08 07.00.00 PM ',
   repeat_interval    =>  'FREQ=DAILY;INTERVAL=1');
   
END;