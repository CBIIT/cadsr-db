set serveroutput on size 1000000
SPOOL cadsrmeta-637i.log

exec SBREXT.MDSR_CEATE_DESIGNATIONS('VALUE_DOMAINS');
SPOOL OFF