OPTIONS ( ERRORS= 10000, SKIP=1)
LOAD DATA
INFILE 'C:\meta\JIRA-598\Phenx_Protocol_all.csv' "str '\r'"
INTO TABLE SBREXT.MDSR_PROTOCOLS_TEMP
INSERT
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(PREFERRED_NAME char(300),
LONG_NAME char(300),
PREFERRED_DEFINITION char(3000),
CONTEXT char(360),
WORKFLOW char(360),
ORIGIN char(1000),
TYPE  char(2400),
PROTOCOL_ID char(500),
PHASE char(300),
LEAD_ORG char(1000))

