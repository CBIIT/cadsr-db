CREATE OR REPLACE PROCEDURE SBR.MDSR_TABLE_TRM_SPC_3t as

CURSOR c_table IS
select 'select rowid,'||column_name|| ' FROM '||'table_name where '||column_name||' is null' select_st,owner||'.'||table_name table_name,column_name from ------SBR.CD_VMS c	,
all_tab_columns c
where owner||'.'||table_name in (--'SBR.CD_VMS',
--'SBREXT.QC_TYPE_LOV_EXT'	,
'SBREXT.SOURCES_EXT'	
--,'SBREXT.TOOL_PROPERTIES_EXT'--,'SBR.ADMINISTERED_COMPONENTS'
)
and c.column_name in ('FORML_NAME', 'LONG_NAME', 'PREFERRED_DEFINITION','PREFERRED_NAME', 'SHORT_MEANING',
'DEFINITION_SOURCE', 'VALUE', 'MEANING_DESCRIPTION','DEFINITION','NAME','DESCRIPTION','PROPL_NAME',
'DOC_TEXT', 'UOML_NAME','DEFAULT_VALUE','CRTL_NAME','SRC_NAME')	;

  TYPE t_rec IS RECORD( c_pk VARCHAR2(40),c_len number, c_name VARCHAR2(4000) );
  TYPE t_tab IS TABLE OF t_rec;
  t t_tab;
   stmt_str VARCHAR2(300);
   Pk_id  VARCHAR2(40);
   dml_str VARCHAR2(300);
 
   errmsg VARCHAR2(500):='Non';
   
BEGIN 
 FOR rec IN c_table LOOP  
BEGIN 
IF rec.table_name  ='SBR.ADMINISTERED_COMPONENTS'  then 
Pk_id:='AC_IDSEQ';
elsif rec.table_name  ='SBR.CD_VMS' then
Pk_id:='CV_IDSEQ';
else
Pk_id:='ROWID';
end if;

IF rec.table_name='TOOL_PROPERTIES_EXT' THEN

EXECUTE IMMEDIATE 'SELECT  rowid,length('||rec.column_name||') ,'||rec.column_name  ||'  FROM ' || rec.table_name|| ' WHERE  date_created >sysdate-240 and REGEXP_like('||rec.column_name|| ','||'''(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)'''||')'
BULK COLLECT INTO t;
ELSE
DBMS_OUTPUT.PUT_LINE(dml_str);
 EXECUTE IMMEDIATE 'SELECT  rowid,length('||rec.column_name||') ,'||rec.column_name  ||'  FROM ' || rec.table_name|| ' WHERE  date_created >sysdate-740 
 and REGEXP_like('||rec.column_name|| ','||'''(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)'''||')'
 BULK COLLECT INTO t;
 END IF;
/**/
 FOR i IN 1 .. t.COUNT LOOP
 BEGIN
 DBMS_OUTPUT.PUT_LINE('Inner loop');
      stmt_str := 'UPDATE '||rec.table_name||' set '||rec.column_name||' = REGEXP_REPLACE('||rec.column_name|| ','||'''(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)'',null) WHERE rowid = '''||t(i).c_pk||'''';
    
 DBMS_OUTPUT.PUT_LINE(stmt_str);   
execute immediate stmt_str;
commit;
   EXCEPTION
        WHEN OTHERS THEN
        errmsg := pk_id||':'||t(i).c_pk||';'||substr(SQLERRM,1,100);     
        insert into SBR.TRRG_TRM_SPC_ERROR_LOG VALUES('SBR.MDSR_TABLE_FIND_SPC',rec.table_name||'.'||rec.column_name, sysdate ,errmsg);
        commit;
 END;       
  END LOOP;
END;     

END LOOP;

END;
/
