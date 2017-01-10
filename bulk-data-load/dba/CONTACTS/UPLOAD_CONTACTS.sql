set serveroutput on size 1000000
SPOOL cadsrmeta-618i.log

 exec SBR.META_UPLOAD_CONTACT_SP;
SPOOL OFF