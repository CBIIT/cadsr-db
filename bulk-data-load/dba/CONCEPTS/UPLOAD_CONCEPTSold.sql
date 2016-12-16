set serveroutput on size 1000000
SPOOL cadsrmeta-conb.log

exec SBREXT.UPLOAD_VALIDATE_CONCEPTS;
SPOOL OFF