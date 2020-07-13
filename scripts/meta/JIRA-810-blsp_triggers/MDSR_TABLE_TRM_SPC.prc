CREATE OR REPLACE PROCEDURE SBREXT.MDSR_TABLE_TRM_SPC as
  

CURSOR c_table IS
select distinct t.OWNER,TRIGGER_NAME,t.TABLE_NAME,c.column_name
from all_trigGers t,all_tab_columns c ,SBR.PERMISSIBLE_VALUES p
where 
trigger_name like '%BIU_ROW_TRM_SPC'
and t.table_name=c.table_name
and  c.column_name='VALUE'-- in ('FORML_NAME', 'LONG_NAME', --'PREFERRED_DEFINITION','PREFERRED_NAME', 'SHORT_MEANING',
--'DEFINITION_SOURCE', 'VALUE', 'MEANING_DESCRIPTION',
--'DEFINITION','NAME','DESCRIPTION','PROPL_NAME',
--'DOC_TEXT', 'UOML_NAME')
and t.table_name='PERMISSIBLE_VALUES' and   REGEXP_like(VALUE ,'(^[[:space:]]|[[:space:]]$)')
and p.date_created >sysdate-240
order by 3,4;

  --TYPE t_rec IS RECORD( T_NAME VARCHAR2(100), c_name VARCHAR2(100) );
  TYPE t_rec IS RECORD(  c_len number,c_name VARCHAR2(4000) );
  TYPE t_tab IS TABLE OF t_rec;
  t t_tab;
  v_table_name VARCHAR2(128) := 'HR.EMPLOYEES';
  v_col_name VARCHAR2(128) := 'HR.EMPLOYEES';

 l_table_name      VARCHAR2 (100):='NA';  
   l_result         number;
   l_xmldoc          CLOB:=null;
   l_table        VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
BEGIN 
 FOR rec IN c_table LOOP  

        
 --        l_file_name := rec.table_name;
 
 --DBMS_OUTPUT.PUT_LINE( 'SELECT '||rec.column_name  ||' FROM ' || rec.table_name||';' );
BEGIN
 EXECUTE IMMEDIATE 'SELECT length('||rec.column_name||') ,'||rec.column_name  ||'  FROM ' || rec.table_name|| ' WHERE  date_created >sysdate-240 and REGEXP_like('||rec.column_name|| ','||'''(^[[:space:]]|[[:space:]]$)'''||')'

   BULK COLLECT INTO t;

 FOR i IN 1 .. t.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE( 'col len :'||t(i).c_len ||' ,column_value :' || t(i).C_NAME );
  END LOOP;
END;
        
        --SELECT dbms_xmlgen.getxml( 'select* from MSDRDEV.REDCAP_FORM_COLLECT_VW_751 where "collectionName" ='||''''||rec.group_number||'''')
        

END LOOP;

END;
/
