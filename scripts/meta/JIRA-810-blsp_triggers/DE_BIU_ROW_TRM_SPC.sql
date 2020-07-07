CREATE OR REPLACE TRIGGER DE_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.DATA_ELEMENTS
FOR EACH ROW
DECLARE
errmsg VARCHAR2(60);
BEGIN 
         :new.long_name := regexp_replace(:new.long_name, '(^[[:space:]]+)|([[:space:]]+$)',null);
         :new.preferred_name := regexp_replace(:new.preferred_name, '(^[[:space:]]+)|([[:space:]]+$)',null);
         :new.preferred_definition := regexp_replace(:new.preferred_definition, '(^[[:space:]]+)|([[:space:]]+$)',null);
EXCEPTION
     WHEN OTHERS THEN
      errmsg := substr(SQLERRM,1,50);     
       insert into SBREXT.META_SPCHAR_ERROR_LOG VALUES('META_FIX_DATA_ELEMENTS',   sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

ENd;