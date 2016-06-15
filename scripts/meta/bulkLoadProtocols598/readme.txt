DBA steps: (Natalia test)
1.run the script in attached file UPLOAD_PROTOCOL.sql
2.Open the attached control file LOAD_PROTOCOL_DBA.ctl.
3.Replace  DBA_PATH to the location path where you will place the attached PhenxProtocol_final.csv file.
4.load data via SQL LOADER using control file  LOAD_PROTOCOL_DBA.ctl
5.run following statement:
EXEC SBREXT. UPLOAD_VALIDATE_PROTOCOL
 
 
QA steps:
Steps 1,2 are for Natalia test. Step3 is Rue test.
1.run following statements:
EXEC SBREXT. UPLOAD_VALIDATE_PROTOCOL
select*from PROTOCOLS_EXT_ERROR_LOG
 
2.if no records records return in output ,the following select should bring record count =629
select count(*)
from  PROTOCOLS_EXT where date_CREATED>SYSDATE-1
 
3.Check protocols in a browser against PhenxProtocol_final.csv attached file.