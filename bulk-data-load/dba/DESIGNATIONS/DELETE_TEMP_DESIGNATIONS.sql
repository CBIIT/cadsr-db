set serveroutput on size 1000000
SPOOL cadsrmeta-673d.log

delete from SBREXT.MDSR_DESIGNATIONS_UPLOAD;
commit;

SPOOL OFF