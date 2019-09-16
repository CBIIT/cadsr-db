SELECT dbms_xmlgen.getxml( 'select* from MDSR_759XML_5CSI_LEVEL_VIEW')
       
        FROM DUAL ;
        
        SELECT dbms_xmlgen.getxml( 'select* from MDSR_759XML_VIEW')
       
        FROM DUAL ;
        
     
        
        exec MSDR_XML_Insert;
   exec MDSR_XML_TRANSFORM;
select*from SBREXT.MDSR_GENERATED_XML;
select* from MSDR_REPORTS_ERR_LOG

select* from MDSR_759XML_5CSI_LEVEL_VIEW;
