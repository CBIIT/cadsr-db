 CREATE table SBREXT.MDSR_REDCAP_QC_FL as select 

  VARIABLE_FIELD_NAME  ,
  FORM_NAME            ,
  SECTION             ,
  SECTION_SEQ         ,
  SECTION_Q_SEQ        ,
  FIELD_TYPE           ,
  FIELD_NOTE           ,
  QUESTION             ,
  TEXT_VALID_TYPE      ,
  TEXT_VALID_MIN       ,
  TEXT_VALID_MAX       ,
  IDENTIFIER           ,  
  REQUIRED            ,
  CUSTOM_ALIGNMENT     ,
  MATRIX_GROUP_NAME    ,
  MATRIX_RANK          ,  
  PROTOCOL             ,
  FIELD_LABEL          ,
  INSTRUCTIONS         ,
  VAL_MIN              ,
  VAL_MAX              ,
  VAL_TYPE             ,
  QUESTION_CSV         ,
  FORM_QUESTION        ,
  QUEST_TB_QUESTION    ,
  FORM_NAME_NEW        ,
  FORM_Q_NUM           ,
  '1'  RUN_NUM  
--  select count(*)
from MSDRDEV.REDCAP_PROTOCOL_751;--6000


CREATE TABLE  SBREXT.MDSR_REDCAP_FORM_FL as select 

  PROTOCOL             ,
  FORM_NAME_NEW         ,
  PREFERRED_DEFINITION  ,
  INSTRUCTIONS          ,
 '1'  RUN_NUM  
 --select count(*)
 from MSDRDEV.REDCAP_PROTOCOL_FORM_751;--151
 
 
 
 CREATE TABLE  SBREXT.MDSR_REDCAP_SECTION_FL as select

  PROTOCOL      ,
  FORM_NAME     ,
  SECTION_SEQ   ,
  SECTION_Q_SEQ ,
  QUESTION      ,
  SECTION       ,
  SECTION_NEW    ,
  INSTRUCTION    ,
 '1'  RUN_NUM 
-- select count(*) 
 from MSDRDEV.REDCAP_SECTION_751; 180
 
 
 CREATE TABLE SBREXT.MDSR_REDCAP_VALUE_FL
as select
  PROTOCOL      ,
  FORM_NAME     ,
  QUESTION      ,
  VAL_NAME      ,
  VAL_VALUE     ,
  VAL_ORDER     ,
  ELM_ORDER     ,
  PIPE_NUM      ,
  VAL_VAL_NAME  ,
 '1'  RUN_NUM  
 
 --select COUNT(*) 
 FROM MSDRDEV.REDCAP_VALUE_CODE_751;17040