set serveroutput on size 1000000
SPOOL cadsrmeta-640.log
delete from SBR.SC_CONTEXTS where SCL_NAME = 'OCCAM_SC';
delete from SBR.CONTEXTS where name = 'OCCAM';
commit;
SPOOL OFF
