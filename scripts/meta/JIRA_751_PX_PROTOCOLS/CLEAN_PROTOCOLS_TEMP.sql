set serveroutput on size 1000000
SPOOL cadsrmeta-753d.log

DELETE from  sbrext.MDSR_PROTOCOLS_TEMP ;
commit;
SPOOL OFF