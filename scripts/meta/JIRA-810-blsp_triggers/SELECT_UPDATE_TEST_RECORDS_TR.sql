--select *from SBR.MDSR_TABLE_COLUMN_SPCHAR_LOG;
select 'SELECT '||trim(PK_NAME)||', '||trim(COLUMN_NAME)||' FROM '||trim(TABLE_NAME)||' WHERE '||trim(PK_NAME)||' = '''||trim(PK_VAL)||''';' SEL_SQL from
(select table_name,pK_NAME,COLUMN_NAME,PK_VAL,column_VAL from (
SELECT 
    row_number() OVER(
        PARTITION BY table_name,pK_NAME,COLUMN_NAME
        ORDER BY table_name,pK_NAME,COLUMN_NAME 
    ) row_num, 
    table_name,pK_NAME,COLUMN_NAME,PK_VAL,column_VAL
FROM 
   SBR.MDSR_TABLE_COLUMN_SPCHAR_LOG)
   where row_num=1);
   
   select 'SELECT '||trim(COLUMN_NAME)||' FROM '||trim(TABLE_NAME)||' WHERE '||trim(PK_NAME)||' = '''||trim(PK_VAL)||''';' SEL_SQL from
(select table_name,pK_NAME,COLUMN_NAME,PK_VAL,column_VAL from (
SELECT 
    row_number() OVER(
        PARTITION BY table_name,pK_NAME,COLUMN_NAME
        ORDER BY table_name,pK_NAME,COLUMN_NAME 
    ) row_num, 
    table_name,pK_NAME,COLUMN_NAME,PK_VAL,column_VAL
FROM 
   SBR.MDSR_TABLE_COLUMN_SPCHAR_LOG)
   where row_num=1)
   order by table_name;
   
      select 'UPDATE '||trim(TABLE_NAME)||' set '||trim(COLUMN_NAME)||'='||trim(COLUMN_NAME)||'||''  '''||' WHERE '||trim(PK_NAME)||' = '''||trim(PK_VAL)||''';' SEL_SQL from
(select table_name,pK_NAME,COLUMN_NAME,PK_VAL,column_VAL from (
SELECT 
    row_number() OVER(
        PARTITION BY table_name,pK_NAME,COLUMN_NAME
        ORDER BY table_name,pK_NAME,COLUMN_NAME 
    ) row_num, 
    table_name,pK_NAME,COLUMN_NAME,PK_VAL,column_VAL
FROM 
   SBR.MDSR_TABLE_COLUMN_SPCHAR_LOG)
   where row_num=1)
   order by table_name;