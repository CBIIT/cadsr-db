set serveroutput on size 1000000
SPOOL cadsrmeta-741.log
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
        dbms_output.put_line('errmsg - '||errmsg||', '||' cde_id, version:'||i.cde_id||'v'||i.version);    
        raise_application_error(-20000, SQLCODE||', '||' cde_id, version:'||i.cde_id||'v'||i.version);          
 end;
  end loop;

commit;

END MDSR_CLEAN_DE_QUEST;
/
GRANT EXECUTE,DEBUG ON SBREXT.MDSR_CLEAN_DE_QUEST TO SBR
/
execute SBREXT.MDSR_CLEAN_DE_QUEST
/
CREATE OR REPLACE TRIGGER sbr.MDSR_RD_AFTER_DELETE
AFTER DELETE
   ON sbr.REFERENCE_DOCUMENTS
   FOR EACH ROW

DECLARE
errmsg VARCHAR2(2000):='';
BEGIN

   update sbr.data_elements
   set question = null
   where de_idseq = :old.ac_idseq
   and :old.DCTL_NAME='Preferred Question Text'
   and QUESTION=:old.DOC_TEXT;
   
   EXCEPTION
    WHEN OTHERS THEN 
     DBMS_OUTPUT.PUT_LINE('ErrorCode: '||SQLCODE||', de_idseq:'||:old.ac_idseq);
    raise_application_error(-20000, SQLCODE||', de_idseq:'||:old.ac_idseq);

END;
/
SPOOL OFF