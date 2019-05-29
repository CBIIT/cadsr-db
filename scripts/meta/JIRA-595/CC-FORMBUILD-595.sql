set serveroutput on size 1000000
SPOOL CC-FORMBUILD-595.log

START C:\meta\UPLOAD\create_table_cc_parser_data.sql;  
START C:\meta\UPLOAD\MDSR_STANDARD_VIEW_JIRA595.sql;
START C:\meta\UPLOAD\CC_PARSER_DATA_CLEAN.sql; 

SPOOL OFF