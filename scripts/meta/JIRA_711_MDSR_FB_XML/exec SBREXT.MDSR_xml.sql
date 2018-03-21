exec SBREXT.MDSR_xml_FB_insert

delete from REPORTS_ERROR_LOG
select*from REPORTS_ERROR_LOG

select*
--DELETE
from MDSR_FB_XML_TEMP where --F--ILE_NAME LIKE '%2263415%'--'%2262683%';
--
CREATED_DATE>SYSDATE-1;

CREATE table MDSR_FB_XML_TEMP as select*
--DELETE
from MDSR_FB_XML_TEMP where --F--ILE_NAME LIKE '%2263415%'--'%2262683%';
--
CREATED_DATE>SYSDATE-1;

select*from MDSR_FB_XML_TEMP
exec SBREXT.MDSR_xml_FB_insert;
exec  SBREXT.MDSR_FB_XML_TRANSFORM;

select*from MDSR_FB_XML_TEMP

select*
 from 
       SBREXT.MDSR_FB_QUEST_MODULE_MVW mm
     where mm.CRF_IDSEQ ='99CD59C5-A976-3FA4-E034-080020C9C0E0'
     
     
     select*from quest_CONTENTS_EXT WHERE QC_ID=2019343
     