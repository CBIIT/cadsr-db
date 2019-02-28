CREATE OR REPLACE PROCEDURE SBREXT.MDSR_CDE_XML_TRANSFORM_file(P_file IN  VARCHAR2) IS

l_file_name VARCHAR2(500):='CDE XML';
 errmsg VARCHAR2(500):='Non';
BEGIN



--delite tags---- <DE_Contest>
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<ROW>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</ROW>'||chr(10));

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<DE_Contest>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</DE_Contest>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<MDSR_DEC_VD_XML_T>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</MDSR_DEC_VD_XML_T>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</MDSR_FB_VD_XML_T>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<MDSR_DEC_XML_T>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</MDSR_DEC_XML_T>'||chr(10));

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<referenceDocument_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</referenceDocument_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<referenceDocument_x005F_xx/>'||chr(10) );

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</definition_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<definition_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<definition_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<PermissibleValue_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</PermissibleValue_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<PermissibleValue_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</designation_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<designation_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<designation_x005F_xx/>'||chr(10) );

UPDATE MDSR_FB_XML_TEMP set text=replace(text,' <valueDomainConcept/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<validValues_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</validValues_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<validValues_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<instruction/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<headerInstruction/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<footerInstruction/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<REF_DOC>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</REF_DOC>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<REF_DOC/>'||chr(10) );
update MDSR_FB_XML_TEMP set text=replace(text,'</ROW>'||chr(10) );
update MDSR_FB_XML_TEMP set text=replace(text,'<ROW>'||chr(10) );
--rename tags

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'ROWSET','dataElements');

update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_CDE_XML_T','dataElement');
update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_CDE_RD_XML_T','referenceDocument');
update MDSR_FB_XML_TEMP set text=replace(text,'<?xml version="1.0"?>','<?xml version="1.0" encoding="UTF-8"?>');
update MDSR_FB_XML_TEMP set text=replace(text,'DATA_ELEMENT_x005F_xx','dataElement');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_CDE_PV_XML_T','permissibleValue');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_CDE_DESIGN_XML_T','designation');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_CDE_DEFIN_XML_T','definition');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_CDE_VD_XML_T','valueDomain');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_VDCon_XML_T','valueDomainConcept');
--dataElementDerivation

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<workflowStatus>','<workflowStatusName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<workflowStatus/>','<workflowStatusName/>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</workflowStatus>','</workflowStatusName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<publicid>','<publicID>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</publicid>','</publicID>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<publicId>','<publicID>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</publicId>','</publicID>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<Datatype>','<datatypeName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</Datatype>','</datatypeName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</longname>','</longName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<longname>','<longName>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</Name>','</name>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<Name>','<name>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</url>','</URL>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<url>','<URL>');



  commit;
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
     --   insert into SBREXT.MDSR_FB_XML_REPORT_ERR VALUES (l_file_name,  errmsg, sysdate);
     commit;

END ;
/

