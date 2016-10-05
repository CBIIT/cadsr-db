select count(*) --97
from SBR.REFERENCE_DOCUMENTS
where SBREXT.meta_FIND_SP_CHAR(NAME)>0 or SBREXT.meta_FIND_SP_CHAR(DOC_TEXT)>0 ;
 
select count(*)--80
from SBR.CD_VMS 
WHERE SBREXT.meta_FIND_SP_CHAR(short_meaning)>0 or SBREXT.meta_FIND_SP_CHAR(DESCRIPTION)>0 ; 


select count(*)from SBR.PERMISSIBLE_VALUES --47
WHERE SBREXT.meta_FIND_SP_CHAR(short_meaning)>0 or SBREXT.meta_FIND_SP_CHAR(MEANING_DESCRIPTION)>0 ;

select count(*)--66
from SBR.VALUE_MEANINGS
where SBREXT.meta_FIND_SP_CHAR(short_meaning)>0
or SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 
or SBREXT.meta_FIND_SP_CHAR(DESCRIPTION)>0 ;
 

select count(*)--9
from SBR.VALUE_DOMAINS
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;

select count(*)--94
from SBR.DATA_ELEMENT_CONCEPTS
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;


select count(*)--117
from SBR.DATA_ELEMENTS
where ISBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;

select count(*) --5
from SBREXT.REPRESENTATIONS_EXT
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;


select count(*) --27
from SBREXT.OBJECT_CLASSES_EXT
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;


select count(*)--16
from SBREXT.PROPERTIES_EXT 
where SBREXT.meta_FIND_SP_CHAR(LONG_NAME)>0 
or SBREXT.meta_FIND_SP_CHAR(PREFERRED_DEFINITION)>0 ;

select count(*)--152
from SBREXT.VALID_VALUES_ATT_EXT 
WHERE SBREXT.meta_FIND_SP_CHAR(MEANING_TEXT)>0 or 
 SBREXT.meta_FIND_SP_CHAR(DESCRIPTION_TEXT)>0; 
 
 
 
delete from SBREXT.CT_PROPERTIES_EXT_BKUP;--
delete from SBREXT.CT_QUEST_CONTENTS_EXT_BKUP;
delete from SBREXT.CT_VALID_VALUES_ATT_EXT_BKUP ;
delete from SBR.CT_PERMISSIBLE_VALUES_BKUP;
delete from SBR.CT_VALUE_MEANINGS_BKUP;
delete from SBR.CT_VALUE_DOMAINS_BKUP;
delete from SBR.CT_CD_VMS_BKUP; --
select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP;

