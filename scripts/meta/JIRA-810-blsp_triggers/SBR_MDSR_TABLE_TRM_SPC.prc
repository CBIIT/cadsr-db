CREATE OR REPLACE PROCEDURE MDSR_TABLE_TRM_SPC as
  

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

  TYPE t_rec IS RECORD( c_len number,c_pk VARCHAR2(40), c_name VARCHAR2(4000) );
  TYPE t_tab IS TABLE OF t_rec;
  t t_tab;
  v_table_name VARCHAR2(128) := 'HR.EMPLOYEES';
  v_pcol_name VARCHAR2(40) := '';

 l_table_name      VARCHAR2 (100):='NA';  
   l_result         number;
   stmt_str VARCHAR2(300);
   Print_stmt_str VARCHAR2(300);
   l_table        VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
BEGIN 
 FOR rec IN c_table LOOP  
 
SELECT ucc.COLUMN_NAME into v_pcol_name
FROM USER_CONSTRAINTS uc  JOIN  USER_CONS_COLUMNS ucc 
ON uc.CONSTRAINT_NAME = ucc.CONSTRAINT_NAME 
AND uc.TABLE_NAME=ucc.TABLE_NAME
WHERE uc.TABLE_NAME=rec.table_name
and uc.CONSTRAINT_TYPE='P';


DBMS_OUTPUT.PUT_LINE( 'Table PK :'||rec.table_name||','||v_pcol_name );
BEGIN

 EXECUTE IMMEDIATE 'SELECT length('||rec.column_name||') ,'||v_pcol_name||','||rec.column_name  ||'  FROM ' || rec.table_name|| ' WHERE  date_created >sysdate-240 and REGEXP_like('||rec.column_name|| ','||'''(^[[:space:]]|[[:space:]]$)'''||')'

   BULK COLLECT INTO t;
/**/
 FOR i IN 1 .. t.COUNT LOOP
 
  --stmt_str := 'UPDATE '||rec.table_name||' set '||rec.column_name||' =REGEXP_REPLACE('||rec.column_name|| ','||'''(^[[:space:]]|[[:space:]]$)'''||') WHERE '||v_pcol_name||' = '''||t(i).c_pk||''';';
    stmt_str := 'UPDATE '||rec.table_name||' set date_modified=SYSDATE WHERE '||v_pcol_name||' = '''||t(i).c_pk||'''';
  -- dml_str := 'UPDATE '|| P_Table_name ||' set date_modified=SYSDATE WHERE '||P_col_name||'='''|| P_col_val||'''';
    
    --execute immediate 'UPDATE '||rec.table_name||' set date_modified=SYSDATE WHERE '||v_pcol_name||' = '''||t(i).c_pk||''';';
 select stmt_str into Print_stmt_str from dual;
execute immediate stmt_str;
DBMS_OUTPUT.PUT_LINE(Print_stmt_str);
commit;
--MDSR_COLOMN(stmt_str);
 --UPDATE rec.table_name set rec.column_name=regexp_replace(t(i).C_NAME,'(^[[:space:]]|[[:space:]]$)')) where 
--    DBMS_OUTPUT.PUT_LINE( stmt_str||'Col len :'||t(i).c_len ||', Table PK :'||t(i).c_pk ||' ,column_value :' || t(i).C_NAME );
  END LOOP;
END;
        

END LOOP;

END;
/
