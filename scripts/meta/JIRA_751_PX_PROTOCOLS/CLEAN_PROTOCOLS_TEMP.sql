set serveroutput on size 1000000
SPOOL cadsrmeta-conb.log

DELETE from  sbrext.MDSR_PROTOCOLS_TEMP ;
commit;
SPOOL OFF