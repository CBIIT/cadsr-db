OPTIONS ( ERRORS= 10000, SKIP=1)
LOAD DATA
INFILE 'C:\meta\ORACLE12c\ALL_OBJECTS_11G.csv' "str '\r'" 

INTO TABLE SBREXT.DEV11G_OBJECTS
INSERT
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS                 
   ( OWNER ,    
    OBJECT_TYPE,
	OBJECT_NAME
    )
	
	