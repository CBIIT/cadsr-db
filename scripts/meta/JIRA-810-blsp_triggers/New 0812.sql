select*from SBR.TRRG_TRM_SPC_ERROR_LOG 

select count(*)from SBR.MDSR_TABLE_COLUMN_SPCHAR_LOG
delete from SBR.MDSR_TABLE_COLUMN_SPCHAR_LOG

exec SBR.MDSR_TABLE_FIND_SPC('BEFORE');

select *from SBREXT.TOOL_PROPERTIES_EXT

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
