set serveroutput on size 1000000
SPOOL cadsrmeta-815.log
 
alter table REFERENCE_DOCUMENTS disable constraint RD_DCTL_FK;
update DOCUMENT_TYPES_LOV set DCTL_NAME='BBRB Question Text' where DCTL_NAME='BBRB Text';
commit;
update REFERENCE_DOCUMENTS set DCTL_NAME='BBRB Question Text' where DCTL_NAME='BBRB Text';
commit;
alter table REFERENCE_DOCUMENTS enable constraint RD_DCTL_FK;
SPOOL OFF;
