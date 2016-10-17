set serveroutput on size 1000000
SPOOL cadsrmeta-637t.log
delete from temp_designations;
delete from designations_load_err where loaddate<sysdate-30;
SPOL OFF
