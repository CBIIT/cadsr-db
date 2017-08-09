set serveroutput on size 1000000SPOOL cadsrmeta-677.log
 update SBREXT.OBJECT_CLASSES_EXT     set long_name='Prostate Cancer',DEFINITION_SOURCE='NCI',  PREFERRED_DEFINITION='The score derived from universally embraced prostate cancer grading system developed by Dr. Donald F. Gleason in 1977. The system provides a reproducible description of the glandular architecture of prostate tissue to which a pathologist assigns a score depending primarily on the microscopic patterns of cancerous glands and cell morphology. The system correlates well with behavior at the extremes: Gleason 1+1 tumors are the most well differentiated, slowly growing and rarely spread; Gleason 4+5 tumors are the most poorly differentiated, often widely metastatic at the time of diagnosis. In the commoner intermediate grade tumors, however, behavior is extremely variable.'  where long_name='Gleason Score'  and OC_ID='2547908';  commit;  SPOOL OFF
