DROP PROCEDURE SBREXT.MDSR_CDE_XML_TRANSFORM;

CREATE OR REPLACE PROCEDURE SBREXT.MDSR_CDE_XML_TRANSFORM IS

l_file_name VARCHAR2(500):='TRANSFORM CDE XML';
 errmsg VARCHAR2(500):='Non';
BEGIN

--delite tags---- <DE_Contest>
UPDATE SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'<ROW>'||chr(10));
UPDATE SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'</ROW>'||chr(10));
UPDATE SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'<ROWSET>'||chr(10));
UPDATE SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'</ROWSET>'||chr(10));
UPDATE SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'<DataElementList/>'||chr(10));
update SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'<MDSR_749_VALUEDOMAIN_T>'||chr(10) );
update SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'</MDSR_749_VALUEDOMAIN_T>'||chr(10) );
update SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'<MDSR_749_VALUEDOMAIN_T/>'||chr(10) );
--rename tags

update SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'MDSR_CDE_749_T','DataElement');
UPDATE SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'MDSR_749_ALTERNATENAME_ITEM_T','ALTERNATENAMELIST_ITEM');
update SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'MDSR_749_REFERENCEDOCUMENT_T','REFERENCEDOCUMENTSLIST_ITEM');
UPDATE SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'MDSR_749_PV_ITEM_T','PermissibleValues_ITEM');
update SBREXT.MDSR_CDE_XML_TEMP set text=replace(text,'<?xml version="1.0"?>','<?xml version="1.0" encoding="UTF-8"?>');


  commit;
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
     insert into SBREXT.MDSR_CDE_XML_REPORT_ERR VALUES (l_file_name,  errmsg, sysdate);
     commit;

END ;
/


DROP PROCEDURE SBREXT.MDSR_XML_CDE_INSERT;

CREATE OR REPLACE PROCEDURE SBREXT.MDSR_xml_CDE_insert as

CURSOR c_gr IS
SELECT  distinct GROUP_NUMBER GROUP_NUMBER from sbrext.MDSR_CONTEXT_GROUP_749_VW
--where GROUP_NUMBER<6
  order by 1 ;/**/


 l_file_name      VARCHAR2 (100):='NA';
   l_file_path      VARCHAR2 (200);
   l_result         CLOB:=null;
   l_xmldoc          CLOB:=null;
   l_pid        VARCHAR2 (30);
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
BEGIN
FOR rec IN c_gr LOOP
BEGIN
        if rec.GROUP_NUMBER<12 then
        SELECT  distinct name into l_file_name from sbrext.MDSR_CONTEXT_GROUP_749_VW 
        where GROUP_NUMBER=rec.GROUP_NUMBER       ;
        elsif rec.GROUP_NUMBER=12 then 
        l_file_name:='CCR_COG_NIDCR';
        elsif rec.GROUP_NUMBER=13 then 
       l_file_name:='Alliance_DCP_ECOGACRIN';
       elsif rec.GROUP_NUMBER=14 then 
       l_file_name:='BBRB_NRG_Theradex_PSCC_SPORE';
       else
       l_file_name:='Others';
       end if;
      --  l_pid:=rec.qc_id||rec.version;
         l_file_name :='CDE_'||l_file_name||'_'||rec.GROUP_NUMBER||'.xml';--rec.CONTEXT||rec.qc_id||'v'||rec.version||'.xml'-- v_protocol||'_'||rec.form_name||' _GeneratedFormFinalFormCartV2.xml';
       -- I_FR_ID:=rec.qc_id||'v'||rec.version;
        -- SELECT dbms_xmlgen.getxml( 'select*from  SBREXT.MDSR_DE_XML_749_VW')
        SELECT dbms_xmlgen.getxml( 'select*from  MDSR_DE_XML_749_VW where "GROUP_NUMBER" ='||''''||rec.GROUP_NUMBER||'''')
 INTO l_result
        FROM DUAL ;
        insert into SBREXT.SBREXT.MDSR_CDE_XML_TEMP(TEXT,FILE_NAME,  CREATED_DATE) VALUES (l_result, l_file_name ,SYSDATE);

      --dbms_xslprocessor.clob2file(l_xmldoc,  l_file_path, l_file_name, nls_charset_id('UTF8'));

      commit;
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
       insert into SBREXT.MDSR_CDE_XML_REPORT_ERR VALUES ('CDE_XML',  errmsg, sysdate);

     commit;
     END;
     END LOOP;
END;
/
