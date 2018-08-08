CREATE OR REPLACE TRIGGER MDSR_RD_AFTER_DELETE
AFTER DELETE
   ON REFERENCE_DOCUMENTS
   FOR EACH ROW

DECLARE


BEGIN

   update data_elements
   set question = null
   where de_idseq = :old.ac_idseq
   and :old.DCTL_NAME='Preferred Question Text'
   and QUESTION=:old.DOC_TEXT;
   
   EXCEPTION
    WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('ErrorCode: '||SQLCODE);
    raise_application_error(-20000, SQLCODE);

END;
