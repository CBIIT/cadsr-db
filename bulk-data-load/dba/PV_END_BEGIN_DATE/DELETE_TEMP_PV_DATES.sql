set serveroutput on size 1000000
SPOOL cadsrmeta-637d.log

delete from SBR.MDSR_PV_UPDATE_ERR;
delete from SBR.MDSR_PV_UP_ENDDATE_TEMP;
commit;

SPOOL OFF