CREATE OR REPLACE procedure SBREXT.MDSR_UPDATE_SYNONYMS_XML as
  
 V_error VARCHAR2 (2000);

 
begin
  
UPDATE SBREXT.MDSR_SYNONYMS_XML set CODE=
trim(regexp_replace(replace(replace(replace(substr(long_name,instr(long_name,'<entityID>')+ LENGTH('<entityID>'),
instr(long_name,'</entityID>')-(instr(long_name,'<entityID>')+ LENGTH('<entityID>'))),'<core:namespace>NCI_Thesaurus</core:namespace>',''),'<core:name>',''),'</core:name>','')
,  '(['||chr(10)||chr(11)||chr(13)||']+)')) where CODE is null;
commit;

UPDATE SBREXT.MDSR_SYNONYMS_XML set 
START_SYN=instr(long_name,'<designation designationRole="ALTERNATIVE"',1,1)+ LENGTH('<designation designationRole="ALTERNATIVE">'),
END_SYN =instr(long_name,'<definition definitionRole',1,1);
commit;

/*UPDATE SBREXT.MDSR_SYNONYMS_XML set TRIM_NAME=
trim(replace(replace(regexp_replace(replace(replace(replace(substr(long_name,start_SYN,END_SYN-START_SYN),'- '),
'</designation>'),'<core:language>en</core:language>'),  '(['||chr(10)||chr(11)||chr(13)||']+)'),'>  ','>'),' <','<')) 
where TRIM_NAME is null;*/
UPDATE SBREXT.MDSR_SYNONYMS_XML 
set TRIM_NAME=trim(regexp_replace(regexp_replace(replace(replace(replace(replace(substr(long_name,start_SYN,END_SYN-START_SYN),'- '),
'</designation>'),'<core:language>en</core:language>'),'designation designationRole="ALTERNATIVE" assertedInCodeSystemVersion='  ), 
'(['||chr(10)||chr(11)||chr(13)||']+)'),'( ){2,}', ' '));

/*UPDATE SBREXT.MDSR_SYNONYMS_XML 
set TRIM_NAME=trim(replace(replace(regexp_replace(replace(replace(replace(replace(substr(long_name,start_SYN,END_SYN-START_SYN),'- '),
'</designation>'),'<core:language>en</core:language>'),'designation designationRole="ALTERNATIVE" assertedInCodeSystemVersion='  ), 
'(['||chr(10)||chr(11)||chr(13)||']+)'),'>  ','>'),' <','<')) ;

UPDATE SBREXT.MDSR_SYNONYMS_XML 
set TRIM_NAME=trim(replace(replace(TRIM_NAME,'>  ','>'),' <','<')) ;*/

commit;

EXCEPTION

    WHEN others THEN
     V_error := substr(SQLERRM,1,200);     
      insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBREXT.MDSR_UPDATE_SYNONYMS_XML','SBREXT.MDSR_SYNONYMS_XML','NA','NA',V_error,sysdate );
  commit;
end;
/