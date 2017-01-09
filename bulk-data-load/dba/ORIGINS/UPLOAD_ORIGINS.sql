set serveroutput on size 1000000
SPOOL cadsrmeta-600i.log

exec UPLOAD_VALIDATE_ORIGINS;
SPOOL OFF