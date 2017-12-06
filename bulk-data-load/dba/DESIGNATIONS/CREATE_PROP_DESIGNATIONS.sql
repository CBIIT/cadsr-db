set serveroutput on size 1000000
SPOOL cadsrmeta-637i.log

exec SBREXT.MDSR_CEATE_DESIGNATIONS('PROPERTIES_EXT');
SPOOL OFF