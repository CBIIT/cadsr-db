CREATE OR REPLACE TRIGGER CS_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.CLASSIFICATION_SCHEMES
FOR EACH ROW
DECLARE
errmsg VARCHAR2(200);
BEGIN 
         :new.long_name := regexp_replace(:new.long_name, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_name := regexp_replace(:new.preferred_name, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_definition := regexp_replace(:new.preferred_definition,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'CS_IDSEQ:'||:new.cs_idseq||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('CS_BIU_ROW_TRM_SPC','SBR.CLASSIFICATION_SCHEMES', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;

