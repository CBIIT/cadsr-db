set serveroutput on size 1000000
SPOOL cadsrmeta-764.log  
INSERT INTO SBREXT.DEFINITION_TYPES_LOV_EXT(DEFL_NAME, DESCRIPTION, DATE_CREATED, CREATED_BY) 
VALUES('NCI Standard Definition', 'NCI Standard Definition', sysdate, user)
/
commit;
SPOOL OFF