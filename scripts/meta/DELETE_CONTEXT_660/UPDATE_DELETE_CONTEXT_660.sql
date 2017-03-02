set serveroutput on size 1000000
SPOOL cadsrmeta-660.log

exec SBR.MDSR_UPD_CONTE_IDSEQ ('CTD-2' ,'TEST','DWARZEL');
exec SBR.MDSR_DELETE_CONTEXT('CTD-2' );

SPOOL OFF
