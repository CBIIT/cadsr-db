CREATE OR REPLACE TRIGGER DES_ITEMS_VMS_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.DESIGNATIONS
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.NAME := regexp_replace(:new.NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'DESIG_IDSEQ:'||:new.DESIG_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('DES_ITEMS_VMS_BIU_ROW_TRM_SPC','SBR.DESIGNATIONS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;
