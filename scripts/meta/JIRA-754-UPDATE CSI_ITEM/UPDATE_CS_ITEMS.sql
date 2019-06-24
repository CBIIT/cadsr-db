set serveroutput on size 1000000
SPOOL cadsrmeta-754.log  

update sbrext.CS_ITEMS set long_name='QIN Breast Study',
modified_by='SBREXT',change_note='User Request',
date_modified=SYSDATE  where CSI_ID=6788757;
commit;

SPOOL OFF
