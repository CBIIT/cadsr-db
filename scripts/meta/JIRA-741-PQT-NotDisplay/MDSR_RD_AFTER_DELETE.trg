CREATE OR REPLACE TRIGGER SBR.MDSR_RD_AFTER_DELETE
AFTER DELETE
   ON SBR.REFERENCE_DOCUMENTS
   FOR EACH ROW
DECLARE
errmsg VARCHAR2(2000):='';
BEGIN

   update data_elements
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