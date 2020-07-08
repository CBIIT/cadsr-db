CREATE OR REPLACE TRIGGER DE_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.DATA_ELEMENTS
FOR EACH ROW
DECLARE
errmsg VARCHAR2(200);
BEGIN 
         :new.long_name := regexp_replace(:new.long_name, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_name := regexp_replace(:new.preferred_name, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.preferred_definition := regexp_replace(:new.preferred_definition,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'DE_IDSEQ:'||:new.DE_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('DE_BIU_ROW_TRM_SPC','SBR.DATA_ELEMENTS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

ENd;
/
SHOW ERRORS;
