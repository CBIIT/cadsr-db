CREATE OR REPLACE PROCEDURE SBR.MDSR_TABLE_FIND_SPC(P_PROC_IND VARCHAR2) as  

CURSOR c_table IS
select distinct t.OWNER||'.'||t.TABLE_NAME TABLE_NAME,TRIGGER_NAME,ucc.COLUMN_NAME PK_COLUMN,c.column_name 
from all_trigGers t,all_tab_columns c ,ALL_CONSTRAINTS uc ,all_CONS_COLUMNS ucc 
where trigger_name like '%BIU_ROW_TRM_SPC'
and t.table_name=c.table_name
and uc.CONSTRAINT_NAME = ucc.CONSTRAINT_NAME 
and uc.TABLE_NAME=ucc.TABLE_NAME
and uc.TABLE_NAME=c.table_name
and t.OWNER=c.OWNER
and uc.OWNER=c.OWNER
and uc.OWNER=ucc.OWNER
and uc.CONSTRAINT_TYPE='P'
and  c.column_name in ('FORML_NAME', 'LONG_NAME', 'PREFERRED_DEFINITION','PREFERRED_NAME', 'SHORT_MEANING',
'DEFINITION_SOURCE', 'VALUE', 'MEANING_DESCRIPTION','DEFINITION','NAME','DESCRIPTION','PROPL_NAME',
'DOC_TEXT', 'UOML_NAME')
order by 1,3,4;

TYPE t_rec IS RECORD( c_len number,c_pk VARCHAR2(40), c_name VARCHAR2(4000) );
TYPE t_tab IS TABLE OF t_rec;
t t_tab;
stmt_str VARCHAR2(300);
Print_stmt_str VARCHAR2(300);
dml_str VARCHAR2(300); 
errmsg VARCHAR2(500):='';
   
BEGIN 
FOR rec IN c_table LOOP  

    BEGIN
    /*find record whish soud be cleanup*/
  --  dml_str :='SELECT length('||rec.column_name||') ,'||rec.pk_column||','||rec.column_name  ||'  FROM ' || rec.table_name||' WHERE  date_created >sysdate-600 and REGEXP_like('||rec.column_name|| ','||'''(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)'''||')';
  --  DBMS_OUTPUT.PUT_LINE(dml_str);
    /*DBMS SQL*/
    EXECUTE IMMEDIATE 'SELECT length('||rec.column_name||') ,'||rec.pk_column||','||rec.column_name  ||'  FROM ' || rec.table_name|| ' WHERE  date_created >sysdate-600 and REGEXP_like('||rec.column_name|| ','||'''(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)'''||')'
    BULK COLLECT INTO t;    
    
    FOR i IN 1 .. t.COUNT LOOP
        BEGIN
        errmsg :='';       
        INSERT INTO SBREXT.MDSR_TABLE_COLUMN_SPCHAR_LOG VALUES(rec.table_name,rec.pk_column,t(i).c_pk,rec.column_name,t(i).C_NAME,'Before Update',SYSDATE);
        commit;
        --    DBMS_OUTPUT.PUT_LINE( stmt_str||'Col len :'||t(i).c_len ||', Table PK :'||t(i).c_pk ||' ,column_value :' || t(i).C_NAME );
        EXCEPTION
        WHEN OTHERS THEN
        errmsg := rec.pk_column||':'||t(i).c_pk||';'||substr(SQLERRM,1,100);     
        insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.MDSR_TABLE_FIND_SPC',rec.table_name||'.'||rec.column_name, sysdate ,errmsg);
        commit;
        END;  
    END LOOP;
    END;     

END LOOP;

END;
/
