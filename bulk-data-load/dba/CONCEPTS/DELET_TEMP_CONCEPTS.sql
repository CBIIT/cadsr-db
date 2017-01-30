set serveroutput on size 1000000
SPOOL cadsrmeta-cona.log

delete from SBREXT.META_CONCEPTS_EXT_TEMP;
delete from SBREXT.META_CONCEPTS_EXT_ERROR_LOG;
commit;
SPOOL OFF
