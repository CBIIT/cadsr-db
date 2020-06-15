set serveroutput on size 1000000
SPOOL cadsrmeta-812.log 
 
INSERT INTO SBREXT.DEFINITION_TYPES_LOV_EXT(DEFL_NAME, DESCRIPTION, DATE_CREATED, CREATED_BY) 
VALUES('CPTAC Definition', 'CPTAC Definition', sysdate, user)
/
commit;
SPOOL OFF
