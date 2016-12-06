set serveroutput on size 1000000
SPOOL cadsrmeta-580b.log

exec SBREXT.UPLOAD_VALIDATE_CONCEPTS;
SPOOL OFF