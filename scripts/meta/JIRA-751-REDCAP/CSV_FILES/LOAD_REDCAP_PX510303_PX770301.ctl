OPTIONS ( ERRORS= 10000, SKIP=1)
LOAD DATA

INFILE 'C:\META\JIRA-751\CSV_FILES\PX510303.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX510304.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX510404.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX510801.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX520307.csv' "str '\r'"

INFILE 'C:\META\JIRA-751\CSV_FILES\PX520406.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX520407.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX520506.csv' "str '\r'" 
INFILE 'C:\META\JIRA-751\CSV_FILES\PX530402.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX530602.csv' "str '\r'"

INFILE 'C:\META\JIRA-751\CSV_FILES\PX540401.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX540402.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX540603.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX550202.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX550302.csv' "str '\r'"

INFILE 'C:\META\JIRA-751\CSV_FILES\PX550702.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX560201.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX560303.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX560304.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX630801.csv' "str '\r'"

INFILE 'C:\META\JIRA-751\CSV_FILES\PX660601.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX660701.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX660702.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX660801.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX660901.csv' "str '\r'"

INFILE 'C:\META\JIRA-751\CSV_FILES\PX661001.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX661101.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX661201.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX661301.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX661302.csv' "str '\r'"

INFILE 'C:\META\JIRA-751\CSV_FILES\PX661401.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX661501.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX661502.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX661503.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX661504.csv' "str '\r'"

INFILE 'C:\META\JIRA-751\CSV_FILES\PX661601.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX661701.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX661801.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX661901.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX662001.csv' "str '\r'"

INFILE 'C:\META\JIRA-751\CSV_FILES\PX662101.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX662102.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX662201.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX662301.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX662401.csv' "str '\r'"

INFILE 'C:\META\JIRA-751\CSV_FILES\PX662402.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX710302.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX741201.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX741202.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX741203.csv' "str '\r'"

INFILE 'C:\META\JIRA-751\CSV_FILES\PX750201.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX750301.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX750302.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX760101.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX770101.csv' "str '\r'"

INFILE 'C:\META\JIRA-751\CSV_FILES\PX770201.csv' "str '\r'"
INFILE 'C:\META\JIRA-751\CSV_FILES\PX770301.csv' "str '\r'"






INTO TABLE "SBREXT"."REDCAPPROTOCOL_TEMP"
append
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS   
(              
  VARIABLE_FIELD_NAME   CHAR(400) ,
    FORM_NAME CHAR(400), 
    SECTION CHAR(1500) , 
    FIELD_TYPE CHAR(100), 
    FIELD_LABEL CHAR(4000) ,
    CHOICES CHAR(1500), 
    FIELD_NOTE CHAR(100),
TEXT_VALID_TYPE     ,
  TEXT_VALID_MIN       ,
  TEXT_VALID_MAX       ,
  IDENTIFIER           ,
  LOGIC           CHAR(1000)    ,
  REQUIRED             ,
  CUSTOM_ALIGNMENT     ,
  Q_NMB_SERV,
  MATRIX_GROUP_NAME    ,
  MATRIX_RANK,
QUESTION SEQUENCE(0,1) )
