set serveroutput on size 1000000
SPOOL cadsrmeta-661a.log
CREATE TABLE SBR.MDSR_MODIFY_ERR_LOG
(
  SP_NAME        CHAR(36 BYTE)                  NOT NULL,
  DATE_MODIFIED  DATE,
  ERROR_TEXT     VARCHAR2(2000 BYTE)
)
/
CREATE OR REPLACE PROCEDURE SBR.MDSR_UPD_CONTE_IDSEQ (p_Context_old in varchar,p_Context_new in varchar,p_userName in varchar) AS
/*Procedure was created to update CONTE_IDSEQ in allrelated to Context tables
  1.parametr p_Context_old presents Context name which has to be replaced by new.
  2.parametr pp_Context_new presents new Context name
  
*/

Vold_conte_idseq VARCHAR2(60);
Vnew_conte_idseq VARCHAR2(60);
V_cnt_old number;
V_cnt_new number;
V_error VARCHAR2(2000);

BEGIN

V_error := NULL;
select COUNT(*) into V_cnt_old from contexts where name =p_Context_old ;--and version=p_ver_CNT;
IF V_cnt_old=0 THEN
V_error :='Old Context does not exist. ';
END IF;
select COUNT(*) into V_cnt_new from contexts where name =p_Context_new ;
IF V_cnt_new=0 THEN
V_error :=V_error||' Newd Context does not exist. ';
END IF;

If V_error is NOT NULL 
THEN
insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ', sysdate ,V_error);
    commit;
    
ELSE
select conte_idseq into Vold_conte_idseq from contexts where name =p_Context_old ;--and version=p_ver_CNT;
select conte_idseq into Vnew_conte_idseq from contexts where name =p_Context_new ;--and version=p_ver_CNT;

UPDATE SBR.ADMINISTERED_COMPONENTS set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBR.CLASSIFICATION_SCHEMES set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBR.CONCEPTUAL_DOMAINS set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBR.CS_ITEMS set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBR.DATA_ELEMENTS set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBR.DATA_ELEMENTS_BU set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBR.DATA_ELEMENT_CONCEPTS set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBR.DEFINITIONS set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBR.DESIGNATIONS set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBR.REFERENCE_DOCUMENTS set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBR.VALUE_DOMAINS set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBR.VALUE_MEANINGS set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBR.VD_PVS set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBREXT.CONCEPTS_EXT set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBREXT.OBJECT_CLASSES_EXT set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBREXT.OC_RECS_EXT set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBREXT.PROPERTIES_EXT set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBREXT.PROTOCOLS_EXT set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBREXT.QUEST_CONTENTS_EXT set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBREXT.REPRESENTATIONS_EXT set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBREXT.SN_RECIPIENT_EXT set CONTE_IDSEQ=Vnew_conte_idseq,MODIFIED_BY=p_userName,DATE_MODIFIED=SYSDATE where CONTE_IDSEQ=Vold_conte_idseq; 
UPDATE SBREXT.STAGE_LOAD_PDF set CONTE_IDSEQ=Vnew_conte_idseq where CONTE_IDSEQ=Vold_conte_idseq; 
END if;
commit;
exception
when NO_DATA_FOUND THEN
null; 
when others then
  V_error:=SQLCODE||substr(SQLERRM,1,500);
  --  V_error := substr(SQLERRM,1,2000);
      insert into SBR.MDSR_MODIFY_ERR_LOG VALUES('MDSR_UPD_CONTE_IDSEQ', sysdate ,V_error);
     commit;
END MDSR_UPD_CONTE_IDSEQ;
/
exec SBR.MDSR_UPD_CONTE_IDSEQ ('CDISC' ,'TEST','DWARZEL');
SPOOL OFF