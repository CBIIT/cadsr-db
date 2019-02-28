CREATE OR REPLACE PROCEDURE SBREXT.MDSR_xml_CDE_insert as

/*CURSOR c_form IS
SELECT CONTEXT,qc_id,qc_idseq,version  FROM MDSR_FB_FR_MVN 
  where CONTEXT in ('CTEP')--,'CTEP','COG') --
 -- and qc_id>=2300000 
  and qc_id>=2800000
  order by 1,2 ;*/


 l_file_name      VARCHAR2 (100):='NA';
   l_file_path      VARCHAR2 (200);
   l_result         CLOB:=null;
   l_xmldoc          CLOB:=null;
   l_pid        VARCHAR2 (30);
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
-- BEGIN
 -- FOR rec IN c_form LOOP
BEGIN
        l_file_path := 'SBREXT_DIR';
      --  l_pid:=rec.qc_id||rec.version;
         l_file_name :='CDE_NCIP';--rec.CONTEXT||rec.qc_id||'v'||rec.version||'.xml'-- v_protocol||'_'||rec.form_name||' _GeneratedFormFinalFormCartV2.xml';
       -- I_FR_ID:=rec.qc_id||'v'||rec.version;
        SELECT dbms_xmlgen.getxml( 'select*from  MDSR_DE_XML_749_VIEW')
        -- SELECT dbms_xmlgen.getxml( 'select*from  MDSR_CD_XML_VIEW where "publicid"||"version" ='||''''||l_pid||'''')
 INTO l_result
        FROM DUAL ;
        insert into MDSR_FB_XML_TEMP(TEXT,FILE_NAME,  CREATED_DATE) VALUES (l_result, l_file_name ,SYSDATE);

      --dbms_xslprocessor.clob2file(l_xmldoc,  l_file_path, l_file_name, nls_charset_id('UTF8'));

      commit;
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
       -- insert into MDSR_FB_XML_REPORT_ERR VALUES ('CDE_XML',  errmsg, sysdate);

     commit;
     END;
     --END LOOP;
/