OPTIONS ( ERRORS= 10000, SKIP=1)
LOAD DATA
INFILE 'C:\meta\ORACLE12c\DEV12C_OBJECTS.csv' "str '\r'" 

INTO TABLE SBREXT.DEV11C_objects
INSERT
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS                 
   ( OWNER ,    
    OBJECT_TYPE,
	OBJECT_NAME
    )
	
	