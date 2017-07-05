select*

from SBREXT.PROPERTIES_EXT where PROP_ID= '3869974' and version='1';
select*from SBREXT.OBJECT_CLASSES_EXT where OC_ID= '5143631' and version='2';

UPDATE SBREXT.OBJECT_CLASSES_EXT set LONG_NAME='Same ISBT-128 Donation Identification Number',
PREFERRED_DEFINITION='A globally unique identifier that is assigned to each collection and each pooled product. The identifier is composed of four parts: a Facility Identification Number (FIN), a year of assignment, a serial number, and flag characters.'
where OC_ID= '5143631' and version='2';

UPDATE SBREXT.PROPERTIES_EXT set LONG_NAME='Same ISBT-128 Donation Identification Number',
PREFERRED_DEFINITION='Equal, or closely similar or comparable, in kind or quality or quantity or degree. :A globally unique identifier that is assigned to each collection and each pooled product. The identifier is composed of four parts: a Facility Identification Number (FIN), a year of assignment, a serial number, and flag characters.'
 where PROP_ID= '3869974' and version='1';
 
 select*from SBREXT.PROPERTIES_EXT where PROP_ID= '3869974' and ASL_NAME='RELEASED';
select*from SBREXT.OBJECT_CLASSES_EXT where OC_ID= '5143631' and ASL_NAME='RELEASED';

select * from SBR.ADMINISTERED_COMPONENTS where  DATE_MODIFIED>sysdate-1