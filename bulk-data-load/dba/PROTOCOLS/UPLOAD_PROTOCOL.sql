set serveroutput on size 1000000
SPOOL cadsrmeta-598i.log  

EXEC SBREXT.UPLOAD_VALIDATE_PROTOCOL;
SPOOL OFF
