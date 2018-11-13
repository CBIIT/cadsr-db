set serveroutput on size 1000000
SPOOL cadsrpassw-163.log
set define off
update SBREXT.TOOL_OPTIONS_EXT set 
value='https://cbiit.nci.nih.gov/ncip/biomedical-informatics-resources/interoperability-and-semantics/metadata-and-models',
DATE_MODIFIED=sysdate, MODIFIED_BY=USER
where TOOL_NAME like 'PasswordChangeStation' and property='LOGO.ROOT'
/
commit
/
SPOOL OFF