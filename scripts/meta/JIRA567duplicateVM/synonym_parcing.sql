



Accepted Solution
by:sdstuber 

 
ID: 41657183·2016-06-16 



select regexp_substr(long_name,'ALTERNATIVE: (.+)$',1,1,'m',1) status
 
select substr(long_name,1234,200) from SBREXT.MSDR_SYNONYMS_XML
  
  select instr(long_name,'<designation designationRole="ALTERNATIVE" assertedInCodeSystemVersion="NCI-GLOSS">')
  from SBREXT.MSDR_SYNONYMS_XML
  select instr(long_name,'<definition definitionRole'),
  instr(long_name,'<definition definitionRole')-LENGTH('<definition definitionRole')
  from SBREXT.MSDR_SYNONYMS_XML
  
  SELECT SUBSTR(long_name, 
  INSTR(long_name, '<core:value>') + LENGTH('<core:value>'), 
  INSTR(long_name, '</core:value>') - (INSTR(long_name, '<core:value>') + LENGTH('<core:value>')))
FROM SBREXT.MSDR_SYNONYMS_XML;

         
  select distinct element , SUBSTR(element, 
  INSTR(element, '<core:value>') + LENGTH('<core:value>')) from       
      (   with tbl(str) as (
      select trim_name FROM SBREXT.MSDR_SYNONYMS_XML
    )
    SELECT REGEXP_SUBSTR( str ,'(.*?)(</core:value>|$)', 1, LEVEL, NULL, 1 ) AS element
    FROM   tbl
    CONNECT BY LEVEL <= regexp_count(str, '</core:value>')+1);


select substr(long_name,instr(long_name,'<designation designationRole="ALTERNATIVE"><core:vaue>'),instr(long_name,'<definition definitionRole')) FROM SBREXT.MSDR_SYNONYMS_XML;

select substr(long_name,instr(long_name,'<designation designationRole="ALTERNATIVE">')+ LENGTH('<designation designationRole="ALTERNATIVE">'),
instr(long_name,'<definition definitionRole')-(instr(long_name,'<designation designationRole="ALTERNATIVE">')+ LENGTH('<designation designationRole="ALTERNATIVE">')))--LENGTH('<definition definitionRole')) 
FROM SBREXT.MSDR_SYNONYMS_XML;


select instr(long_name,'<designation designationRole="ALTERNATIVE">'),instr(long_name,'<definition definitionRole=')FROM SBREXT.MSDR_SYNONYMS_XML;

select 
substr(long_name,1294)--(instr(long_name,'<definition definitionRole=')-100))--+LENGTH('<definition definitionRole') )
FROM SBREXT.MSDR_SYNONYMS_XML;

select 
instr(long_name,'<definition definitionRole'),instr(long_name,'<definition definitionRole')-100,LENGTH('<definition definitionRole')
FROM SBREXT.MSDR_SYNONYMS_XML;


select replace(replace(replace(substr(long_name,instr(long_name,'<designation designationRole="ALTERNATIVE">')+ LENGTH('<designation designationRole="ALTERNATIVE">'),
instr(long_name,'<definition definitionRole')-(instr(long_name,'<designation designationRole="ALTERNATIVE">')+ LENGTH('<designation designationRole="ALTERNATIVE">'))),'- '),
'</designation>'),'<core:language>en</core:language>')
FROM SBREXT.MSDR_SYNONYMS_XML;


select replace(replace(replace(replace(long_name,'</designation>'),'<core:language>en</core:language>'),'- '),chr(ascii(10)),'')
FROM SBREXT.MSDR_SYNONYMS_XML;



UPDATE SBREXT.MSDR_SYNONYMS_XML set TRIM_NAME=
replace(replace(replace(substr(long_name,instr(long_name,'<designation designationRole="ALTERNATIVE">')+ LENGTH('<designation designationRole="ALTERNATIVE">'),
instr(long_name,'<definition definitionRole')-(instr(long_name,'<designation designationRole="ALTERNATIVE">')+ LENGTH('<designation designationRole="ALTERNATIVE">'))),'- '),
'</designation>'),'<core:language>en</core:language>');

select  replace(replace(regexp_replace(TRIM_NAME,  '(['||chr(10)||chr(11)||chr(13)||']+)'),'>  ','>'),'  <','<')
 from SBREXT.MSDR_SYNONYMS_XML;
 
 
 
UPDATE SBREXT.MSDR_SYNONYMS_XML 
set TRIM_NAME=replace(replace(regexp_replace(TRIM_NAME,  '(['||chr(10)||chr(11)||chr(13)||']+)'),'>  ','>'),' ; <','<');


         
  select distinct element ,UPPER(SUBSTR(element, 
  INSTR(element, '<core:value>') + LENGTH('<core:value>'))) el from       
      (   with tbl(str) as (
      select trim_name FROM SBREXT.MSDR_SYNONYMS_XML
    )
    SELECT REGEXP_SUBSTR( str ,'(.*?)(</core:value>|$)', 1, LEVEL, NULL, 1 ) AS element
    FROM   tbl
    CONNECT BY LEVEL <= regexp_count(str, '</core:value>')+1);
    
    
   select el from (
      select distinct UPPER(SUBSTR(element, 
  INSTR(element, '<core:value>') + LENGTH('<core:value>'))) el from       
      (   with tbl(str) as (
      select trim_name FROM SBREXT.MSDR_SYNONYMS_XML
    )
    SELECT REGEXP_SUBSTR( str ,'(.*?)(</core:value>|$)', 1, LEVEL, NULL, 1 ) AS element
    FROM   tbl
    CONNECT BY LEVEL <= regexp_count(str, '</core:value>')+1)
  )   where el is not null;