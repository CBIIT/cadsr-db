set serveroutput on size 1000000
SPOOL cadsrmeta-517i.log

exec SBR.MDSR_UPDATE_PV_ENDDATE;
SPOOL OFF
