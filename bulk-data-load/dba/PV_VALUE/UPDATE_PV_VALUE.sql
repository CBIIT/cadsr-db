set serveroutput on size 1000000
SPOOL cadsrmeta-501b.log

exec SBR.UPD_PV_NEW;
SPOOL OFF