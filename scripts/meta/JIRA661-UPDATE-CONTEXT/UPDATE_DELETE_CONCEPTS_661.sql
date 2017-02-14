set serveroutput on size 1000000
SPOOL cadsrmeta-661b.log

exec SBR.MDSR_UPD_CONTE_IDSEQ ('CDISC' ,'TEST','DWARZEL');
exec SBR.MDSR_DELETE_CONTEXT('CDISC' ,'DWARZEL');;

SPOOL OFF
