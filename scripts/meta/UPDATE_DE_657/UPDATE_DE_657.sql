set serveroutput on size 1000000
SPOOL cadsrmeta-657.log
update SBR.DATA_ELEMENTS set version = 4.9 where de_idseq = 'BB0DF7B7-F178-6974-E034-0003BA12F5E7';
commit;
SPOOL OFF
