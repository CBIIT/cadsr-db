CREATE OR REPLACE PROCEDURE SBREXT.MDSR_CDE_XML_TRANSFORM IS

l_file_name VARCHAR2(500):='TRANSFORM CDE XML';
 errmsg VARCHAR2(500):='Non';
BEGIN

--delite tags---- <DE_Contest>
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<ROW>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</ROW>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<ROWSET>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</ROWSET>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<DataElementList/>'||chr(10));
update MDSR_FB_XML_TEMP set text=replace(text,'<MDSR_749_VALUEDOMAIN_T>'||chr(10) );
update MDSR_FB_XML_TEMP set text=replace(text,'</MDSR_749_VALUEDOMAIN_T>'||chr(10) );
update MDSR_FB_XML_TEMP set text=replace(text,'<MDSR_749_VALUEDOMAIN_T/>'||chr(10) );
--rename tags

update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_CDE_749_T','DataElement');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_749_ALTERNATENAME_ITEM_T','ALTERNATENAMELIST_ITEM');
update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_749_REFERENCEDOCUMENT_T','REFERENCEDOCUMENTSLIST_ITEM');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_749_PV_ITEM_T','PermissibleValues_ITEM');
update MDSR_FB_XML_TEMP set text=replace(text,'<?xml version="1.0"?>','<?xml version="1.0" encoding="UTF-8"?>');


--UPDATE MDSR_FB_XML_TEMP set text=replace(text,'language','Language');
--UPDATE MDSR_FB_XML_TEMP set text=replace(text,'longName','LongName');






  commit;
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
     --   insert into SBREXT.MDSR_FB_XML_REPORT_ERR VALUES (l_file_name,  errmsg, sysdate);
     commit;

END ;
/