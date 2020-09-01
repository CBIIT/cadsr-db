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
   SBR.MDSR_TABLE_COLUMN_SPCHAR_LOG where  to_char(date_created,'MM/DD/YYYY')<>'08/12/2020')
   where row_num=1);
   
   select 'SELECT '||trim(COLUMN_NAME)||', '''||trim(TABLE_NAME)||''' MyTable, '''||trim(PK_NAME)||''' PK, '''||trim(PK_VAL)||''' PK_VAL FROM '||trim(TABLE_NAME)||' WHERE '||trim(PK_NAME)||' = '''||trim(PK_VAL)||''';' SEL_SQL from
(select table_name,pK_NAME,COLUMN_NAME,PK_VAL,column_VAL from (
SELECT 
    row_number() OVER(
        PARTITION BY table_name,pK_NAME,COLUMN_NAME
        ORDER BY table_name,pK_NAME,COLUMN_NAME 
    ) row_num, 
    table_name,pK_NAME,COLUMN_NAME,PK_VAL,column_VAL
FROM 
 ( select* from SBR.MDSR_TABLE_COLUMN_SPCHAR_LOG where  to_char(date_created,'MM/DD/YYYY')<>'08/12/2020'))
   where row_num=1)
   order by table_name,COLUMN_NAME;
   
      select 'UPDATE '||trim(TABLE_NAME)||' set '||trim(COLUMN_NAME)||'='||trim(COLUMN_NAME)||'||''  '''||' WHERE '||trim(PK_NAME)||' = '''||trim(PK_VAL)||''';' SEL_SQL from
(select table_name,pK_NAME,COLUMN_NAME,PK_VAL,column_VAL from (
SELECT 
    row_number() OVER(
        PARTITION BY table_name,pK_NAME,COLUMN_NAME
        ORDER BY table_name,pK_NAME,COLUMN_NAME 
    ) row_num, 
    table_name,pK_NAME,COLUMN_NAME,PK_VAL,column_VAL
FROM 
   (select * from SBR.MDSR_TABLE_COLUMN_SPCHAR_LOG where  to_char(date_created,'MM/DD/YYYY')<>'08/12/2020'))
   where row_num=1)
   order by table_name,COLUMN_NAME;