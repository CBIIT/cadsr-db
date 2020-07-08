CREATE OR REPLACE TRIGGER CD_VMS_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.CD_VMS
FOR EACH ROW
DECLARE
errmsg VARCHAR2(200);
BEGIN 
         :new.DESCRIPTION := regexp_replace(:new.DESCRIPTION, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.SHORT_MEANING := regexp_replace(:new.SHORT_MEANING, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'CV_IDSEQ:'||:new.cv_idseq||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('CD_VMS_BIU_ROW_TRM_SPC','SBR.CD_VMS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
--select*from CD_VMS