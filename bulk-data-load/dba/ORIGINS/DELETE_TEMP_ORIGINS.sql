set serveroutput on size 1000000
SPOOL cadsrmeta-600d.log

delete from SBREXT.ORIGIN_TEMP;
delete from SBREXT.ORIGIN_TEMP_ERROR_LOG;
commit;

SPOOL OFF