CREATE OR REPLACE procedure SBREXT.MDSR_call_webservice as
  t_http_req  utl_http.req;
  t_http_resp  utl_http.resp; 
  t_response_text clob;
  t_code varchar2(60);
  errm varchar2(200);
  CURSOR C is 
  
  /* */  select distinct preferred_name NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME
    FROM SBREXT.MDSR_CONDR_ID_CONCEPT_EXT x,
    sbrext.concepts_ext  c
    where  trim(CONCEPT_CODE)=trim(c.preferred_name)
    union     
    SELECT distinct dr.NAME NAME,trim(UPPER(C.LONG_NAME)) CONCEPT_NAME
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
 
begin
  --UTL_HTTP.SET_WALLET('file:/data10/oradata/DSRDEV/WALLET2', 'h2vVrSde6y');
for i in C loop
    begin
  t_code:=i.NAME;
  t_http_req:= utl_http.begin_request('https://lexevscts2.nci.nih.gov/lexevscts2/codesystem/NCI_Thesaurus/entity/'||t_code||'?format=xml','GET','HTTP/1.1');
   t_http_resp:= utl_http.get_response(t_http_req);
  UTL_HTTP.read_text(t_http_resp, t_response_text);
    Insert into MDSR_SYNONYMS_XML(code,long_name,DATE_CREATED,RESP_STATUS,CONCEPT_NAME) values (t_code,t_response_text,SYSDATE,t_http_resp.status_code,i.CONCEPT_NAME);
  commit;
  --DBMS_OUTPUT.put_line('Response> status_code: "' || t_http_resp.status_code || '"');
  --DBMS_OUTPUT.put_line('Response> reason_phrase: "' ||t_http_resp.reason_phrase || '"');    
  --DBMS_OUTPUT.put_line('Response> data:' ||t_response_text); 

  
  EXCEPTION
   WHEN OTHERS then
   errm := SUBSTR(SQLERRM,1,199);
      insert into SBREXT.MDSR_DUP_VM_ERR VALUES('MDSR_DUP_VM_ERR', 'SBREXT.MDSR_call_webservice','SBREXT.MDSR_SYNONYMS_XML',t_code,i.CONCEPT_NAME,errm,sysdate );

   END;
   utl_http.end_response(t_http_resp); 
   END LOOP;
      
end;
/