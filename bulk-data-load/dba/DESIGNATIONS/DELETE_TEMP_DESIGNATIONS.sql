set serveroutput on size 1000000
SPOOL cadsrmeta-618d.log

delete from SBR.META_UPLOAD_CONTACT;
delete from SBR.META_UPLOAD_ERROR_LOG;
commit;

SPOOL OFF