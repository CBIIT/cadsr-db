set serveroutput on size 1000000
SPOOL cadsrmeta-581.log

delete from SBR.MDSR_DESIGNATIONS_UPLOAD;
delete from SBR.MDSR_DESIGNATIONS_MDSR_DESIGNATIONS_ERR;
commit;

SPOOL OFF