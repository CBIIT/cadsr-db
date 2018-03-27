CREATE OR REPLACE PROCEDURE SBREXT.MDSR_FB_XML_TRANSFORM2 IS

l_file_name VARCHAR2(500):='FB XML FORMS';
 errmsg VARCHAR2(500):='Non';
BEGIN 

--delite tags----
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<ROWSET>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</ROWSET>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<MDSR_FB_VD_XML_T1>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</MDSR_FB_VD_XML_T1>'||chr(10));
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<referenceDocument_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</referenceDocument_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<referenceDocument_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<dataElementDerivation_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<MODULE_LIST>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</MODULE_LIST>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<FORM_PROTOCOL>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</FORM_PROTOCOL>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<FORM_PROTOCOL/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<questions_x005F_xx>'||chr(10) );--
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</questions_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<FORM_CLASS>'||chr(10) ) ;
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</FORM_CLASS>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</definition_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<definition_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<definition_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<PermissibleValue_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</PermissibleValue_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<PermissibleValue_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</designation_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<designation_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<designation_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</classification_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<classification_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<classification_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,' <valueDomainConcept/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<validValues_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</validValues_x005F_xx>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<validValues_x005F_xx/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<instruction/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<REF_DOC>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</REF_DOC>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<REF_DOC/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<attachments/>'||chr(10) );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<valueDomainConcept_x005F_xx/>'||chr(10) );
--rename tags
update MDSR_FB_XML_TEMP set text=replace(text,'<dataElementDerivation_x005F_xx>','<dataElementDerivation>');
update MDSR_FB_XML_TEMP set text=replace(text,'</dataElementDerivation_x005F_xx>','</dataElementDerivation>');
update MDSR_FB_XML_TEMP set text=replace(text,'<?xml version="1.0"?>','<?xml version="1.0" encoding="UTF-8"?>');
update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_MODULE_XML_T1','module');
update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_QUESTION_XML_T1','question');
update MDSR_FB_XML_TEMP set text=replace(text,'DATA_ELEMENT_x005F_xx','dataElement');
update MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_RD_XML_T1','referenceDocument');
update MDSR_FB_XML_TEMP set text=replace(text,'</ROW>','</form>');
update MDSR_FB_XML_TEMP set text=replace(text,'<ROW>','<form>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_PV_XML_T1','permissibleValue');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_VV_XML_T1','validValue');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_DESIGN_XML_T1','designation');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_DEFIN_XML_T1','definition');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_FORM_CL_XML_T1','classification');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'FclassificationItem_XX','classificationSchemeItem' );
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_VD_XML_T1','valueDomain');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_VDCon_XML_T1','valueDomainConcept');
--dataElementDerivation 
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_PROTOCOL_XML_T','protocol');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'MDSR_FB_COM_DE_DR_XML_T1','componentDataElement');
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
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<MaximumLengthNumber>','<maximumLengthNumber>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</MaximumLengthNumber>','</maximumLengthNumber>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<MinimumLengthNumber>','<minimumLengthNumber>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</MinimumLengthNumber>','</minimumLengthNumber>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</Name>','</name>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<Name>','<name>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</url>','</URL>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<url>','<URL>');

UPDATE MDSR_FB_XML_TEMP set text=replace(text,'<ModifiedBy>','<modifiedBy>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'</ModifiedBy>','</modifiedBy>');
UPDATE MDSR_FB_XML_TEMP set text=replace(text,'valueDomainConcept_x005F_xx','valueDomainConcept');

  commit;    
 EXCEPTION
    WHEN OTHERS THEN
   errmsg := SQLERRM;
         dbms_output.put_line('errmsg  - '||errmsg);
        insert into REPORTS_ERROR_LOG VALUES (l_file_name,  errmsg, sysdate);
     commit;   

END ;
/