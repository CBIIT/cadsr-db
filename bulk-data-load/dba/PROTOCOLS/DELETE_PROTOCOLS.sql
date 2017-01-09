set serveroutput on size 1000000
SPOOL cadsrmeta-598d.log

delete from SBREXT.protocols_EXT_TEMP;
delete from SBREXT.PROTOCOLS_EXT_ERROR_LOG;
commit;

SPOOL OFF
