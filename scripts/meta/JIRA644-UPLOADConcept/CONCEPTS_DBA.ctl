OPTIONS ( ERRORS= 10000, SKIP=1)
LOAD DATA
INFILE 'DBA_PATH\CCR_Measure_Responses.csv' "str '\r'"
BADFILE 'DBA_PATH\CCR_Measure_Responses.bad'
DISCARDFILE 'DBA_PATH\CCR_Measure_Responses.dsc'
INTO TABLE "SBREXT"."MDSR_CONCEPTS_EXT_TEMP"
INSERT
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(PREFERRED_NAME  "TRIM(:PREFERRED_NAME )",   
LONG_NAME CHAR(500) "TRIM(:LONG_NAME)",
PREFERRED_DEFINITION CHAR(3000) "TRIM(:PREFERRED_DEFINITION)"
)