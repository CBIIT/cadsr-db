select*from SBR.TRRG_TRM_SPC_ERROR_LOG ;
select *from SBR.MDSR_TABLE_COLUMN_SPCHAR_LOG b, SBR.MDSR_TABLE_COLUMN_SPCHAR_LOG a where b.PROCESS_IND='BEFORE'
--and b.table_NAME='SBREXT.QUEST_CONTENTS_EXT'
and A.PROCESS_IND='AFTER'
and a.pk_VAL=b.pk_val
;
order by PK_NAME desc;
select count(*)from SBR.MDSR_TABLE_COLUMN_SPCHAR_LOG;
delete from SBR.MDSR_TABLE_COLUMN_SPCHAR_LOG where PROCESS_IND='AFTER';
exec SBR.MDSR_TABLE_FIND_SPC('AFTER');

exec SBR.MDSR_TABLE_FIND_SPC_TEST('AFTER');
exec SBR.MDSR_TABLE_FIND_SPC('BEFORE');
exec SBR.MDSR_TABLE_TRM_SPC_2 ;
exec SBR.MDSR_TABLE_TRM_SPC_3;
select *from SBREXT.TOOL_PROPERTIES_EXT;

select owner||'.'||table_name table_name,column_name from 
all_tab_columns c
where owner||'.'||table_name in ('SBR.CD_VMS',
'SBREXT.QC_TYPE_LOV_EXT'	,
'SBREXT.SOURCES_EXT'	,
'SBREXT.TOOL_PROPERTIES_EXT',
'SBR.ADMINISTERED_COMPONENTS';


select distinct owner||'.'||table_name table_name,
CASE 
when table_NAME in ('CD_VMS','ADMINISTERED_COMPONENTS') then'N/A' 
else '%BIU_ROW_TRM_SPC' END
trigger_name ,

column_name from 
all_tab_columns c
where owner||'.'||table_name in ('SBR.CD_VMS',
'SBREXT.QC_TYPE_LOV_EXT'	,
'SBREXT.SOURCES_EXT'	,
'SBREXT.TOOL_PROPERTIES_EXT',
'SBR.ADMINISTERED_COMPONENTS'
)
and c.column_name in ('FORML_NAME', 'LONG_NAME', 'PREFERRED_DEFINITION','PREFERRED_NAME', 'SHORT_MEANING',
'DEFINITION_SOURCE', 'VALUE', 'MEANING_DESCRIPTION','DEFINITION','NAME','DESCRIPTION','PROPL_NAME',
'DOC_TEXT', 'UOML_NAME','DEFAULT_VALUE','CRTL_NAME','SRC_NAME')
order by 1,3,4;


SELECT  rowid,length(PREFERRED_DEFINITION) ,PREFERRED_DEFINITION  FROM SBR.ADMINISTERED_COMPONENTS WHERE  date_created >sysdate-280 
 and REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)');
 
 SELECT  ROWIDTONCHAR (rowid),length(PREFERRED_NAME) ,PREFERRED_NAME  FROM SBR.ADMINISTERED_COMPONENTS WHERE  date_created >sysdate-280 
 and REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)')
 union
SELECT ROWIDTONCHAR (rowid),length(DESCRIPTION) ,DESCRIPTION  FROM SBR.CD_VMS WHERE  date_created >sysdate-280 
 and REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)')
  union
SELECT  ROWIDTONCHAR (rowid),length(SHORT_MEANING) ,SHORT_MEANING  FROM SBR.CD_VMS WHERE  date_created >sysdate-280 
 and REGEXP_like(SHORT_MEANING,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)')
  union
SELECT  ROWIDTONCHAR (rowid),length(DESCRIPTION) ,DESCRIPTION  FROM SBREXT.QC_TYPE_LOV_EXT WHERE  date_created >sysdate-280 
 and REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)')
 union
SELECT  ROWIDTONCHAR (rowid),length(DESCRIPTION) ,DESCRIPTION  FROM SBREXT.SOURCES_EXT WHERE  date_created >sysdate-280 
 and REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)')
 union
SELECT ROWIDTONCHAR (rowid),length(SRC_NAME) ,SRC_NAME  FROM SBREXT.SOURCES_EXT WHERE  date_created >sysdate-280 
 and REGEXP_like(SRC_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)');
 
 select PREFERRED_DEFINITION from quest_contents_ext where qc_idseq='97B4A2B0-3AE5-360B-E053-F662850A66CC';
 
 update quest_contents_ext set PREFERRED_DEFINITION =REGEXP_REPLACE(PREFERRED_DEFINITION ,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null)-- WHERE '||rec.pk_column||' = '''||t(i).c_pk||'''';
         where qc_idseq='97B4A2B0-3AE5-360B-E053-F662850A66CC';
