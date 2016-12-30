set serveroutput on size 1000000
SPOOL cadsrmeta-653.log

  update SBREXT.OBJECT_CLASSES_EXT   
  set LONG_NAME='MD Anderson Symptom Inventory - Head and Neck'
  where PREFERRED_NAME='C105551'
  and OC_ID=3698757
  and version=1;
  commit;
  SPOOL OFF