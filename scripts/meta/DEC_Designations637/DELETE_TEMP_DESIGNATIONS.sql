set serveroutput on size 1000000
SPOOL cadsrmeta-637t.log
delete from temp_designations;
delete from designations_load_err where loaddate<sysdate-40;
rename temp_DESIGNATIONS to MDSR_DESIGNATIONS_UPLOAD;
rename DESIGNATIONS_load_err to MDSR_designations_load_err;
create view MDSR_DES_UPLOAD_VW as select distinct * from MDSR_designations_upload;
SPOOL OFF




