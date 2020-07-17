
select  'select '''||TABLE_NAME ||''' table'||','||column_name||','||PK_COLUMN ||','||' from '||TABLE_NAME||' where  REGEXP_like('||column_name|| ','||'''(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)'''||')'
SQL_STR from MDSR_LOVS;
create or replace  View MDSR_LOVS_SQL as 
select  'select count(*) CTN , '''||TABLE_NAME ||''',  '''||column_name ||''' from '||TABLE_NAME||' where  REGEXP_like('||column_name|| ','||'''(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)'''||')'
||' group by 2,3' 
 SQL_STR from MDSR_LOVS
 order by 2;
 select listagg(SQL_STR,' 
 UNION 
 ')from SBR.MDSR_CPCHAR_TB;
--select ci_name, sg, listagg( new_support_group, ';' ) within group (order by rn) new_sg, max(column1), max(column2)
 -- from data2

select*from SBR.MDSR_CPCHAR_TB;
CREATE OR REPLACE FORCE VIEW SBR.MDSR_CPCHAR_TB

AS

select  'select nvl(count(*),0) CTN , '''||TABLE_NAME ||''',  '''||column_name ||''' from '||TABLE_NAME||' where  REGEXP_like('||column_name|| ','||'''(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)'''||')'
||' group by 2,3' 
 SQL_STR from
      (  SELECT DISTINCT
           a.owner || '.' || a.TABLE_NAME     TABLE_NAME,
             a.column_name
             FROM all_tab_columns a,
             all_objects    o 
       WHERE     o.object_name = a.TABLE_NAME
             AND o.object_type = 'TABLE' 
             AND o.OWNER = a.OWNER            
             AND a.column_name IN ('FORML_NAME',
                                   'LONG_NAME',
                                   'PREFERRED_DEFINITION',
                                   'PREFERRED_NAME',
                                   'SHORT_MEANING',
                                   'DEFINITION_SOURCE',
                                   'VALUE',
                                   'MEANING_DESCRIPTION',
                                   'DEFINITION',
                                   'NAME',
                                   'DESCRIPTION',
                                   'PROPL_NAME',
                                   'DOC_TEXT',
                                   'UOML_NAME',
                                   'DESCRIPTION')
             AND o.owner IN ('SBR', 'SBREXT')
             AND a.owner IN ('SBR', 'SBREXT')            
             AND a.table_name NOT LIKE ('%_MVW%')
             AND a.table_name NOT LIKE ('%STAGING%')
             AND a.table_name NOT LIKE ('STAG%')
             AND a.table_name NOT LIKE ('%BACKUP%')
             AND a.table_name NOT LIKE ('%_TEMP%')
             AND a.table_name NOT LIKE ('%_HST%')
             AND a.table_name NOT LIKE ('%_BKUP%')
             AND a.table_name NOT LIKE ('%_STG%')
             AND a.table_name NOT LIKE ('%_CSV%')
             AND a.table_name NOT LIKE ('%REDCAP%')
             AND a.table_name NOT LIKE ('%DMRS_%')
             AND a.table_name NOT LIKE ('%ERROR%')
             AND a.table_name NOT LIKE ('%_LOG%')
             AND a.table_name NOT LIKE ('%_BK%')
             AND a.table_name NOT LIKE ('%_BU%')
             AND a.table_name NOT LIKE ('%_UPDATED%')
             AND a.table_name NOT LIKE ('%JAVA$%')
             AND a.table_name NOT LIKE ('%UPLOAD%')
             AND a.table_name NOT LIKE ('%_LOAD_%')
             AND a.table_name NOT LIKE ('%_HST%')
             --AND a.table_name NOT LIKE ('S_%')
             --AND a.table_name NOT LIKE ('UI_%')
    ORDER BY 1, 2);


select*from SBR.MDSR_CPCHAR_TB

CREATE OR REPLACE FORCE VIEW SBR.MDSR_CPCHAR_TB
(
    TABLE_NAME,
    COLUMN_NAME,
    PK_COLUMN
)
BEQUEATH DEFINER
AS
      SELECT DISTINCT
             a.owner || '.' || a.TABLE_NAME     TABLE_NAME,
             a.column_name,
             ucc.COLUMN_NAME                    PK_COLUMN
        --,'select a.owner||'.'||a.TABLE_NAME, a.column_name ,ucc.COLUMN_NAME PK_COLUMN
        FROM all_tab_columns a,
             all_objects     o,
             ALL_CONSTRAINTS uc,
             all_CONS_COLUMNS ucc
       WHERE     o.object_name = a.TABLE_NAME
             AND o.object_type = 'TABLE'
             AND uc.CONSTRAINT_NAME = ucc.CONSTRAINT_NAME
             AND uc.TABLE_NAME = ucc.TABLE_NAME
             AND uc.TABLE_NAME = a.table_name
             AND o.OWNER = a.OWNER
             AND uc.OWNER = a.OWNER
             AND uc.OWNER = ucc.OWNER
             AND uc.CONSTRAINT_TYPE = 'P'
             AND a.column_name IN ('FORML_NAME',
                                   'LONG_NAME',
                                   'PREFERRED_DEFINITION',
                                   'PREFERRED_NAME',
                                   'SHORT_MEANING',
                                   'DEFINITION_SOURCE',
                                   'VALUE',
                                   'MEANING_DESCRIPTION',
                                   'DEFINITION',
                                   'NAME',
                                   'DESCRIPTION',
                                   'PROPL_NAME',
                                   'DOC_TEXT',
                                   'UOML_NAME',
                                   'DESCRIPTION')
             AND o.owner IN ('SBR', 'SBREXT')
             AND object_type = 'TABLE'
             AND a.owner IN ('SBR', 'SBREXT')            
             AND a.table_name NOT LIKE ('%_MVW%')
             AND a.table_name NOT LIKE ('%STAGING%')
             AND a.table_name NOT LIKE ('STAG%')
             AND a.table_name NOT LIKE ('%BACKUP%')
             AND a.table_name NOT LIKE ('%_TEMP%')
             AND a.table_name NOT LIKE ('%_HST%')
             AND a.table_name NOT LIKE ('%_BKUP%')
             AND a.table_name NOT LIKE ('%_STG%')
             AND a.table_name NOT LIKE ('%_CSV%')
             AND a.table_name NOT LIKE ('%REDCAP%')
             AND a.table_name NOT LIKE ('%DMRS_%')
             AND a.table_name NOT LIKE ('%ERROR%')
             AND a.table_name NOT LIKE ('%_LOG%')
             AND a.table_name NOT LIKE ('%_BK%')
             AND a.table_name NOT LIKE ('%_BU%')
             AND a.table_name NOT LIKE ('%_UPDATED%')
             AND a.table_name NOT LIKE ('%JAVA$%')
             AND a.table_name NOT LIKE ('%UPLOAD%')
             AND a.table_name NOT LIKE ('%_LOAD_%')
             AND a.table_name NOT LIKE ('%_HST%')
             AND a.table_name NOT LIKE ('%QS_07%')
             --AND a.table_name NOT LIKE ('S_%')
             --AND a.table_name NOT LIKE ('UI_%')
    ORDER BY 2, 1, 3;
    
    
   select listagg(SQL_STR,' 
 UNION 
 ')from SBR.MDSR_CPCHAR_TB2;  
 
CREATE OR REPLACE FORCE VIEW SBR.MDSR_CPCHAR_TB2

AS

select  'select nvl(count(*),0) CTN , '''||TABLE_NAME ||''',  '''||column_name ||''' from '||TABLE_NAME||' where  REGEXP_like('||column_name|| ','||'''(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)'''||')'
||' group by 2,3' 
 SQL_STR from
      (  SELECT DISTINCT
           a.owner || '.' || a.TABLE_NAME     TABLE_NAME,
             a.column_name
             FROM all_tab_columns a,
             all_objects    o 
       WHERE     o.object_name = a.TABLE_NAME
             AND o.object_type = 'TABLE' 
             AND o.OWNER = a.OWNER            
             AND a.column_name IN ('FORML_NAME',
                                   'LONG_NAME',
                                   'PREFERRED_DEFINITION',
                                   'PREFERRED_NAME',
                                   'SHORT_MEANING',
                                   'DEFINITION_SOURCE',
                                   'VALUE',
                                   'MEANING_DESCRIPTION',
                                   'DEFINITION',
                                   'NAME',
                                   'DESCRIPTION',
                                   'PROPL_NAME',
                                   'DOC_TEXT',
                                   'UOML_NAME',
                                   'DESCRIPTION')
             AND o.owner IN ('SBR', 'SBREXT')
             AND a.owner IN ('SBR', 'SBREXT')            
             AND a.table_name NOT LIKE ('%_MVW%')
             AND a.table_name NOT LIKE ('%STAGING%')
             AND a.table_name NOT LIKE ('STAG%')
             AND a.table_name NOT LIKE ('%BACKUP%')
             AND a.table_name NOT LIKE ('%_TEMP%')
             AND a.table_name NOT LIKE ('%_HST%')
             AND a.table_name NOT LIKE ('%_BKUP%')
             AND a.table_name NOT LIKE ('%_STG%')
             AND a.table_name NOT LIKE ('%_CSV%')
             AND a.table_name NOT LIKE ('%REDCAP%')
             AND a.table_name NOT LIKE ('%DMRS_%')
             AND a.table_name NOT LIKE ('%ERROR%')
             AND a.table_name NOT LIKE ('%_LOG%')
             AND a.table_name NOT LIKE ('%_BK%')
             AND a.table_name NOT LIKE ('%_BU%')
             AND a.table_name NOT LIKE ('%_UPDATED%')
             AND a.table_name NOT LIKE ('%JAVA$%')
             AND a.table_name NOT LIKE ('%UPLOAD%')
             AND a.table_name NOT LIKE ('%_LOAD_%')
             AND a.table_name NOT LIKE ('%_HST%')
             AND (a.table_name  LIKE ('S_%') or a.table_name  LIKE ('UI_%'))
    ORDER BY 1, 2);