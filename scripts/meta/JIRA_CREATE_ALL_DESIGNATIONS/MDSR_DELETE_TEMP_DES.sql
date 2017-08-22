set serveroutput on size 1000000
SPOOL cadsrmeta-581.log

delete from SBREXT.MDSR_DESIGNATIONS_UPLOAD;
delete from SBREXT.MDSR_designations_load_err;
commit;

SPOOL OFF