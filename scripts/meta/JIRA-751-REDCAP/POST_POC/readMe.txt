POST PROCESS steps:
1.(only the for first run)
Make a request to DBA team to create  DB objects and privileges for the POST PROCESS on a desired tier 
DBA strps:

1.1.DBA should be login as  SBREXT user.
2.1.Execute the script MSDR_POSTPROC_EXEC.sql which located at
https://github.com/CBIIT/cadsr-db/blob/master/scripts/meta/JIRA-751-REDCAP/POST_POC/MDSREDCAP_XML_POSTPROC_OBJ_with_PKG.sql
3.1. Send us the log file cadsrmeta-751ppexec.log.  

This applies for all runs of the POST PROCESS. Currently run=1.
In general run is: select max(LOAD_SEQ) from SBREXT.MDSR_REDCAP_PROTOCOL_CSV.  

2.After uploading XMLs run MDSR_POST_LOAD_REPORT.sql and create xlsx file containing all Form discrepancies are created by FL.
2.1. Find Forms with dup questions              
2.2. Find Forms which were modified after creation.        
2.3. Find Forms with no protocol preferred name in from long name 
2.4. Find Forms loaded with truncated long name, but from long name includes protocol preferred name
2.5. Find Forms with truncated preferred _definitions
2.6. Find Forms with truncated instructions long name
2.7. Find Forms with truncated Module long Name
2.8. Find Form Questions with truncated Question long name 
2.9. Find Form Questions with not matching long name 
2.10. Find Question Instructions with truncated long name
2.11. Find Forms with missing questions where loaded 

3.Provide a client with the report for Forms which have duplicate questions and Forms which modified after creation(before POST PROCESS). https://github.com/CBIIT/cadsr-db/blob/master/scripts/meta/JIRA-751-REDCAP/POST_POC/MDSR_POST_LOAD_REPORT.sql

Modify the script  https://github.com/CBIIT/cadsr-db/blob/master/scripts/meta/JIRA-751-REDCAP/POST_POC/MSDR_POSTPROC_EXEC.sql if needed.
Attach the script to DBA request 

4.Make request to DBA team to execute the POST process for existing run.
Currently run=1.In general run is max(LOAD_SEQ) from : 
1.DBA should be login as  SBREXT user.
2.Execute the attached script  MSDR_POSTPROC_EXEC.sql
3. Send us the log file cadsrmeta-751ppexec.log.  


After the script executed, it will fix all forms elements beside Forms with were created with duplicate Questions or modified before POST PROCESS
1. Forms with no protocol preferred name in from long name 
2. Forms loaded with truncated long name, but from long name includes protocol preferred name
3. Forms with truncated Preferred Definitions
4. Truncated Form Instructions.
5. Truncated Module long Name.
6. Truncated Questions.
7. Questions with not matching long name 
8. Truncated Question Instructions.
