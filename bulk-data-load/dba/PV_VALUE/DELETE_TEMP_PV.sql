set serveroutput on size 1000000
SPOOL cadsrmeta-501d.log

delete from SBR.TEMP_PERMISSIBLE_VALUES;
delete from SBR.PERMISSIBLE_VALUES_ERR;
commit;

SPOOL OFF