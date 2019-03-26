QUEST_TB_QUESTION,QUESTION_CSV 


update SBREXT.REDCAP_PROTOCOL_NEW set QUEST_TB_QUESTION=QUESTION_CSV ||'; variable='||VARIABLE_FIELD_NAME where length(FIELD_LABEL||VARIABLE_FIELD_NAME)<1988;

 update REDCAP_PROTOCOL_TEST set QUEST_TB_QUESTION=substr(QUESTION_CSV,1,(1977-length(VARIABLE_FIELD_NAME)))||'..TRUNCATED'||' ('||VARIABLE_FIELD_NAME||')'
 where length(QUESTION_CSV)+length(VARIABLE_FIELD_NAME)>1986;
 
 
update REDCAP_PROTOCOL_test set QUEST_TB_QUESTION=QUESTION_CSV||' ('||VARIABLE_FIELD_NAME||')'
  --select QUESTION_CSV||'('||VARIABLE_FIELD_NAME||')' from REDCAP_PROTOCOL_NEW
 
  where length(QUESTION_CSV)+length(VARIABLE_FIELD_NAME)<1996 --and length(QUESTION_CSV||VARIABLE_FIELD_NAME)>1900
 and protocol not like '%nstruction%';
 
  update REDCAP_PROTOCOL_test set QUEST_TB_QUESTION=replace (VARIABLE_FIELD_NAME,'_',' ')||' ('||VARIABLE_FIELD_NAME||')' where 
 (QUESTION_CSV is null or QUESTION_CSV like '%???%') and protocol not like '%nstruction%'
  
  select replace (VARIABLE_FIELD_NAME,'_',' '),FIELD_LABEL from REDCAP_PROTOCOL_test 
  --update REDCAP_PROTOCOL_NEW set QUEST_TB_QUESTION=replace (VARIABLE_FIELD_NAME,'_',' ') ||' 
  where QUEST_TB_QUESTION is null
  and protocol not like '%nstruction%' 

update REDCAP_PROTOCOL_TEST set FIELD_LABEL=substr(FIELD_LABEL,1,(1977-length(VARIABLE_FIELD_NAME)))||'..TRUNCATED'||'('||VARIABLE_FIELD_NAME||')'
 where length(FIELD_LABEL||VARIABLE_FIELD_NAME)>1988;
 
UPDATE REDCAP_PROTOCOL_TEST set QUEST_TB_QUESTION=replace(replace(QUEST_TB_QUESTION,'<a href=',''),'</a>','') where instr(QUEST_TB_QUESTION,'<a href=')>0;
UPDATE REDCAP_PROTOCOL_TEST set QUEST_TB_QUESTION=replace(replace(QUEST_TB_QUESTION,'<a target="_blank" href=',''),'</a>','') where instr(QUEST_TB_QUESTION,'<a target="_blank" href=')>0;
UPDATE REDCAP_PROTOCOL_TEST set QUEST_TB_QUESTION=replace(QUEST_TB_QUESTION,'target="_blank">','') where instr(QUEST_TB_QUESTION,'target="_blank">')>0;
UPDATE REDCAP_PROTOCOL_TEST set QUEST_TB_QUESTION=replace(replace(QUEST_TB_QUESTION,'<i>',''),'</i>','') where instr(QUEST_TB_QUESTION,'<i>')>0;
UPDATE REDCAP_PROTOCOL_TEST set QUEST_TB_QUESTION=replace(replace(QUEST_TB_QUESTION,'<b>',''),'</b>','') where instr(QUEST_TB_QUESTION,'<b>')>0;
UPDATE REDCAP_PROTOCOL_TEST set QUEST_TB_QUESTION=replace(replace(QUEST_TB_QUESTION,'<p>',''),'</p>','') where instr(QUEST_TB_QUESTION,'<p>')>0;


UPDATE redcap_xml set text=replace(text,'÷','/');
UPDATE redcap_xml set text=replace(text,'REDCAP_FORM_S','form' ) ;
UPDATE redcap_xml set text=replace(text,'&'||'#149;','' ) where instr( text,'&'||'#149;')>0;
UPDATE redcap_xml set text=replace(text,'&'||'quot;','"' ) ;
UPDATE redcap_xml set text=replace(text,'&'||'amp;quot;','"' ) ;
UPDATE redcap_xml set text=replace(text,'&'||'apos;','''' ) ;
UPDATE redcap_xml set text=replace(text,'&'||'amp;#8217;','''' ) ;

select *from REDCAP_PROTOCOL_TEST where   instr( QUEST_TB_QUESTION,'&'||'#149;')>0;
UPDATE REDCAP_PROTOCOL_TEST  set QUEST_TB_QUESTION=replace(QUEST_TB_QUESTION,'÷','/');

UPDATE REDCAP_PROTOCOL_TEST  set QUEST_TB_QUESTION=replace(QUEST_TB_QUESTION,'&'||'#149;','' ) where instr( QUEST_TB_QUESTION,'&'||'#149;')>0;
UPDATE REDCAP_PROTOCOL_TEST  set QUEST_TB_QUESTION=replace(QUEST_TB_QUESTION,'&'||'quot;','"' ) ;
UPDATE REDCAP_PROTOCOL_TEST  set QUEST_TB_QUESTION=replace(QUEST_TB_QUESTION,'&'||'amp;quot;','"' ) ;
UPDATE REDCAP_PROTOCOL_TEST  set QUEST_TB_QUESTION=replace(QUEST_TB_QUESTION,'&'||'apos;','''' ) ;
UPDATE REDCAP_PROTOCOL_TEST  set QUEST_TB_QUESTION=replace(QUEST_TB_QUESTION,'&'||'amp;#8217;','''' ) ;