set serveroutput on size 1000000
SPOOL cadsrmeta-673d.log

delete from SBREXT.MDSR_DESIGNATIONS_UPLOAD;
commit;
delete from SBREXT.MDSR_designations_load_err;
commit;

SPOOL OFF
