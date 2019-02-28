CREATE OR REPLACE PROCEDURE SBREXT.MDSR_CDE_XML_TRANSFORM IS

l_file_name VARCHAR2(500):='CDE XML';
 errmsg VARCHAR2(500):='Non';
BEGIN

--delite tags---- <DE_Contest>
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<ROW>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</ROW>'||chr(10));

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<DE_Contest>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</DE_Contest>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<DE_Contest/>'||chr(10));

update MDSR_FB_XML_TEMP set text=replace(text,'</ROW>'||chr(10) );
update MDSR_FB_XML_TEMP set text=replace(text,'<ROW>'||chr(10) );
update MDSR_FB_XML_TEMP set text=replace(text,'<MDSR_749_VD_T>'||chr(10) );
update MDSR_FB_XML_TEMP set text=replace(text,'</MDSR_749_VD_T>'||chr(10) );
update MDSR_FB_XML_TEMP set text=replace(text,'<MDSR_749_VD_T/>'||chr(10) );
--rename tags

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'ROWSET','DataElementList');
update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_CDE_749_T','DataElement');

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'designation_x005F_xx','ALTERNATENAMELIST');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_749_DESIGN_T','ALTERNATENAMELIST_ITEM');

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'referenceDocument_x005F_xx','REFERENCEDOCUMENTSLIST') ;
update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_749_RD_T','REFERENCEDOCUMENTSLIST_ITEM');

update MDSR_FB_XML_TEMP set text=replace(text,'<?xml version="1.0"?>','<?xml version="1.0" encoding="UTF-8"?>');
--update MDSR_FB_XML_TEMP set text=replace(text,'DATA_ELEMENT_x005F_xx','dataElement');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'PermissibleValue_x005F_xx','PermissibleValues' );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_749_PV_T','PermissibleValues_ITEM');

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'language','Language');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'longName','LongName');






  commit;
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
     --   insert into SBREXT.MDSR_FB_XML_REPORT_ERR VALUES (l_file_name,  errmsg, sysdate);
     commit;

END ;
/