CREATE OR REPLACE TRIGGER REFDOC_ITEMS_VMS_BIU_ROW_TRM_SPC
BEFORE INSERT OR UPDATE ON SBR.REFERENCE_DOCUMENTS
FOR EACH ROW
DECLARE

errmsg VARCHAR2(200);
BEGIN 
         :new.NAME:= regexp_replace(:new.NAME, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
         :new.DOC_TEXT:= regexp_replace(:new.DOC_TEXT, '(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)',null);
        
EXCEPTION
     WHEN OTHERS THEN
      errmsg := 'RD_IDSEQ:'||:new.RD_IDSEQ||';'||substr(SQLERRM,1,100);     
       insert into SBREXT.TRRG_TRM_SPC_ERROR_LOG VALUES('REFDOC_ITEMS_VMS_BIU_ROW_TRM_SPC','SBR.REFERENCE_DOCUMENTS', sysdate ,errmsg);
      RAISE_APPLICATION_ERROR(-20001,errmsg );

END;

