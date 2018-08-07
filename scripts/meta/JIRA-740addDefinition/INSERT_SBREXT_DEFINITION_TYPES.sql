set serveroutput on size 1000000
SPOOL cadsrmeta-740.log
insert into SBREXT.DEFINITION_TYPES_LOV_EXT(DEFL_NAME,DESCRIPTION,DATE_CREATED,CREATED_BY) VALUES ('Alt VD Definition',  'Alt VD Definition',SYSDATE,'SBREXT');
commit;
SPOOL OFF