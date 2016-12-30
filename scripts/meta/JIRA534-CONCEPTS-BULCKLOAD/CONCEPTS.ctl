OPTIONS ( ERRORS= 10000, SKIP=1)
LOAD DATA
INFILE 'C:\meta\wiki\CONCEPTS\Concepts.csv' "str '\r'"
INTO TABLE "SBREXT"."META_CONCEPTS_EXT_TEMP"
INSERT
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(   PREFERRED_NAME  "TRIM(:PREFERRED_NAME )",
LONG_NAME CHAR(500) "TRIM(:LONG_NAME)",
PREFERRED_DEFINITION CHAR(3000) "TRIM(:PREFERRED_DEFINITION)"
)