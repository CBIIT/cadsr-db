CREATE OR REPLACE PROCEDURE SBREXT.MDSR_CLEAN_DE_QUEST AS
cursor C_DE is
 select  cde_id, version, ASL_NAME, latest_version_ind, DE_IDSEQ, Question 
from sbr.data_elements ,
( select AC_IDSEQ from sbr.REFERENCE_DOCUMENTS where DCTL_NAME = 'Preferred Question Text' )RD_PQT
where  QUESTION is not NULL
and DE_IDSEQ=AC_IDSEQ(+)
and AC_IDSEQ is null;

errmsg VARCHAR2(2000):='';


BEGIN

for i in C_DE loop

begin

UPDATE SBR.DATA_ELEMENTS set QUESTION=NULL
where DE_IDSEQ=i.DE_IDSEQ;

  EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
        dbms_output.put_line('errmsg2 - '||errmsg||', '||' cde_id, version:'||i.cde_id||'v'||i.version);    
        raise_application_error(-20000, SQLCODE);          
 end;
  end loop;

commit;

END MDSR_CLEAN_DE_QUEST;
/
