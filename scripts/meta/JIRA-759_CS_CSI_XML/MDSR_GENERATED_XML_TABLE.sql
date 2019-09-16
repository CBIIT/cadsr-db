CREATE OR REPLACE PROCEDURE RXML_PREVIW_TRANSFORM IS

l_file_name VARCHAR2(500):='Phenx FORMS';
 errmsg VARCHAR2(500):='Non';
BEGIN 
UPDATE MDSR_GENERATED_XML set field_label=replace(field_label,'÷','/')where instr( FIELD_LABEL,'÷')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'&'||'#149;','') where instr( FIELD_LABEL,'&'||'#149;')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'°','DDDD') where instr(field_label,'°')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'©','CCCC') where instr(field_label,'©')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'®','RRRR') where instr(field_label,'®')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'™','TTTT') where instr(field_label,'™')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'µ','MUMUMU') where instr(field_label,'µ')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'×','XxXxXx') where instr(field_label,'×')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'±','PMPMPM') where instr(field_label,'±')>0;
UPDATE REDCAP_PROTOCOL_NEW set field_label=replace(field_label,'¢','ctctct') where instr(field_label,'¢')>0;
 commit; 
UPDATE REDCAP_PROTOCOL_NEW set field_label=REGEXP_REPLACE(ASCIISTR(field_label), '\\[[:xdigit:]]{4}', '');
 commit;
UPDATE REDCAP_PROTOCOL_NEW set field_label=regexp_replace(trim(FIELD_LABEL),'['||chr(128)||'-'||chr(255)||';]','',1,0,'in');
 commit;
UPDATE REDCAP_PROTOCOL_NEW set field_label=regexp_replace(trim(FIELD_LABEL),'['||chr(1)||'-'||chr(31)||']','',1,0,'in');

 commit; 
 EXCEPTION
 WHEN OTHERS THEN
 errmsg := SQLERRM;
 dbms_output.put_line('errmsg - '||errmsg);
 insert into REDCAP_ERROR_LOG VALUES (l_file_name, errmsg, sysdate);
 

END ;
/
