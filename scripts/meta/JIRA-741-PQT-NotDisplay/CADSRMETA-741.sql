set serveroutput on size 1000000
SPOOL cadsrmeta-741.log
CREATE OR REPLACE PROCEDURE SBR.MDSR_CLEAN_DE_QUEST AS
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

commit;
dbms_output.put_line('cde_id, version:'||i.cde_id||'v'||i.version); 
  EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
        dbms_output.put_line('errmsg - '||errmsg||', '||' cde_id, version:'||i.cde_id||'v'||i.version);    
        raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);          
 end;
  end loop;

END MDSR_CLEAN_DE_QUEST;
/
execute SBR.MDSR_CLEAN_DE_QUEST
/
CREATE OR REPLACE TRIGGER sbr.MDSR_RD_AFTER_DELETE
AFTER DELETE
   ON sbr.REFERENCE_DOCUMENTS
   FOR EACH ROW
declare
errmsg VARCHAR2(2000):='';
BEGIN

   update sbr.data_elements
   set question = null
   where de_idseq = :old.ac_idseq
   and :old.DCTL_NAME='Preferred Question Text'
   and QUESTION=:old.DOC_TEXT;
   
   EXCEPTION
    WHEN OTHERS THEN  
    errmsg := 'An error was encountered when attempting to delete reference document for rd_idseq - '||:old.rd_idseq||'. ORA-'||SQLCODE||'-'||substr(SQLERRM,1,500) ;	
   raise_application_error(-20001,errmsg);

END;
/
SPOOL OFF
