set serveroutput on size 1000000
SPOOL cadsrmeta-637t.log
delete from temp_designations;
delete from designations_load_err where loaddate<sysdate-40;
rename  temp_designations to MDSR_designations_upload;
rename MDSR_designations_loaderr to  MDSR_designations_load_err;
create view MDSR_DES_UPLOAD_VW as select distinct * from MDSR_designations_upload;
SPOL OFF




