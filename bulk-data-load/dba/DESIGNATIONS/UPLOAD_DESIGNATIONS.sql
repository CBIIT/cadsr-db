set serveroutput on size 1000000
SPOOL cadsrmeta-637i.log

exec SBR.MDSR_INS_DEC_DESIGNATIONS;
SPOOL OFF