set serveroutput on size 1000000
SPOOL cadsrmeta-754.log  

update sbrext.CS_ITEMS set long_name='QIN Breast Study',
modified_by='SBREXT',change_note='Long Name was modified by User Request',
date_modified=SYSDATE  
where CSI_NAME='QIN' 
and preferred_name ='6788757' 
and version=1 
and CSITL_NAME='GROUP_TYPE'
and conte_idseq=(select conte_idseq from CONTEXTS where name ='NCIP' and version=1);
commit;

SPOOL OFF
