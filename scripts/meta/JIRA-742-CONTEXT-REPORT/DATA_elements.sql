select 'DATA_ELEMENTS' Table_name ,CDE_ID PublicId,version,long_name,ASL_NAME Status from SBR.DATA_ELEMENTS  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26' 
union
select 'DATA_ELEMENTS_CONCEPTS' Table_name ,DEC_ID,version,long_name,ASL_NAME Status 
from SBR.DATA_ELEMENT_CONCEPTS  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
union
select 'CLASSIFICATION' Table_name ,CS_ID,version,long_name,ASL_NAME Status  from 
SBR.CLASSIFICATION_SCHEMES  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
union
select 'CLASSIFICATION_ITEM' Table_name ,CSI_ID,version,long_name,ASL_NAME Status  from 
SBR.CS_ITEMS  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
union
select 'VALUE_DOMAINS' Table_name ,VD_ID,version,long_name,ASL_NAME Status  from
SBR.VALUE_DOMAINS  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
union
select 'Forms' Table_name ,QC_ID,version,long_name,ASL_NAME Status
from SBREXT.QUEST_CONTENTS_EXT  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
and QTL_NAME='CRF';


select * from SBR.ADMINISTERED_COMPONENTS  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'; 
select * from SBR.DATA_ELEMENTS where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26';
select *from SBREXT.QUEST_CONTENTS_EXT  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26';
select * from SBR.CS_ITEMS  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26';
select * from SBREXT.PROTOCOLS_EXT  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'; 

select * from SBREXT.OBJECT_CLASSES_EXT  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'; 
select * from SBREXT.OC_RECS_EXT  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'; 
select * from SBREXT.PROPERTIES_EXT  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26';

select DEFINITION,DEFL_NAME,AC.ACTL_NAME,PUBLIC_ID,LONG_NAME from SBR.DEFINITIONS DF ,
SBR.ADMINISTERED_COMPONENTS AC
where DF.AC_IDSEQ=AC.AC_IDSEQ
and DF.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26';

select NAME ALTERN_NAME,DETL_NAME,AC.ACTL_NAME CREATED_FOR,PUBLIC_ID,LONG_NAME from SBR.DESIGNATIONS DF, 
SBR.ADMINISTERED_COMPONENTS AC
where DF.AC_IDSEQ=AC.AC_IDSEQ
and DF.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
order by 3,4;

select  DOC_TEXT,DCTL_NAME,AC.ACTL_NAME CREATED_FOR,PUBLIC_ID,LONG_NAME 
from SBR.REFERENCE_DOCUMENTS RD ,
SBR.ADMINISTERED_COMPONENTS AC
where RD.AC_IDSEQ=AC.AC_IDSEQ
and RD.CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'
order by 3,4;


select * from SBR.DESIGNATIONS  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26';
select * from SBR.REFERENCE_DOCUMENTS  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26';  
select * from SBR.VD_PVS  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'; 

select * from SBREXT.PROPERTIES_EXT  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'; 
select * from SBREXT.PROTOCOLS_EXT  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26';  
select * from SBREXT.REPRESENTATIONS_EXT  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26';

select * from SBR.SC_CONTEXTS  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'; 
select *from SBREXT.SN_RECIPIENT_EXT  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26';
select * from SBREXT.STAGE_LOAD_PDF  where CONTE_IDSEQ='8F119EA6-BC32-2319-E040-BB89AD431E26'; 