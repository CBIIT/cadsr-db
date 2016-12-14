set serveroutput on size 1000000
SPOOL cadsrmeta-645a.log

delete from SBREXT.MDSR_CONCEPTS_EXT_TEMP;
commit;
delete from SBREXT.MDSR_CONCEPTS_EXT_ERROR_LOG;
commit;
SPOOL OFF

