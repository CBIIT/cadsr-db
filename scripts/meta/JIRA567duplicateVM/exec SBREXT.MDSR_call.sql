exec SBREXT.MDSR_call_webservice;

exec  UTL_HTTP.SET_WALLET('file:/data10/oradata/DSRDEV/WALLET2', 'h2vVrSde6y');

select * from MDSR_SYNONYMS_XML where (end_SYN-start_SYN)>4000;
exec SBREXT.MDSR_UPDATE_SYNONYMS_XML;

select*from MDSR_SYNONYMS_XML where code='XC48789' 
create table  MDSR_SYNONYMS_XML_BKUP as select * from MDSR_SYNONYMS_XML;

select * from MDSR_SYNONYMS_XML_BKUP;
--delete from  MDSR_SYNONYMS_XML;
select* from SBREXT.MDSR_DUP_VM_ERR where date_created >sysdate-1;

select count(*) from MDSR_SYNONYMS_XML;


SELECT distinct NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME
FROM  SBR.VALUE_MEANINGS VM,
SBREXT.CON_DERIVATION_RULES_EXT DR,
 sbrext.concepts_ext  c ,
 (select count(*),CONDR_IDSEQ from SBR.VALUE_MEANINGS VM 
 where  UPPER(ASL_NAME) not like '%RETIRED%' and CONDR_IDSEQ is not null
 having count(*)>1GROUP BY CONDR_IDSEQ )VW
 
where    VW.CONDR_IDSEQ=VM.CONDR_IDSEQ
AND  VM.CONDR_IDSEQ=DR.CONDR_IDSEQ
AND DR.name=c.preferred_name
AND instr(dr.name,':')=0
and UPPER(VM.ASL_NAME) not like '%RETIRED%'
and trim(UPPER(VM.LONG_NAME))<>trim(UPPER(C.LONG_NAME)) ;