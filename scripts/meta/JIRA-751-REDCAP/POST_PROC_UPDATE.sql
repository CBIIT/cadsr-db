CREATE TABLE SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
(
  QC_IDSEQ                    CHAR(36 BYTE)     ,
  QC_ID                       NUMBER            ,
  VERSION                     NUMBER(4,2)       ,
  QTL_NAME                    VARCHAR2(30 BYTE) ,    
  PREFERRED_DEFINITION        VARCHAR2(2000 BYTE) ,
  LONG_NAME                   VARCHAR2(4000 BYTE),  
  DATE_CREATED                DATE       ,
  CREATED_BY                  VARCHAR2(30 BYTE) ,
  DATE_MODIFIED               DATE,
  MODIFIED_BY                 VARCHAR2(30 BYTE)  ,
  DATE_INSERTED date
);
CREATE TABLE SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR
(
  
  QC_ID                       NUMBER            ,  
  QTL_NAME                    VARCHAR2(30 BYTE) ,    
  ERR_MSG       VARCHAR2(2000 BYTE) ,    
  DATE_CREATED                DATE       
);
CREATE OR REPLACE PROCEDURE MDSR_RECAP_FORM_FIX_SQL as

CURSOR c_form IS
select long_name,rf.FORM_NAME_NEW,rf.preferred_definition correct_def,q.preferred_definition,q.modified_by,q.DATE_MODIFIED,qc_id,qc_idseq,created_by,date_created,QTL_NAME,version
from sbrext.quest_contents_ext q,
SBREXT.MDSR_REDCAP_FORM_FL rf
where q.long_name=rf.FORM_NAME_NEW
and q.qtl_name='CRF'
and length(trim(q.preferred_definition))<>length(trim(rf.preferred_definition))
and NVL(modified_by,'FORMLOADER') ='FORMLOADER';


 l_FORM_name      VARCHAR2 (100):='NA';
   l_where       VARCHAR2 (1000);
   l_SQL         CLOB:=null;
   l_update       VARCHAR2 (4000);
   l_qtl        VARCHAR2 (3):='CRF';
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
   formatme CLOB;
   formatstr CLOB ;
BEGIN
FOR rec IN c_form LOOP
BEGIN
      l_FORM_name:=rec.long_name;
      UPDATE sbrext.quest_contents_ext  set preferred_definition=rec.correct_def
      where rec.qc_idseq=rec.qc_idseq;
      insert into SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.LONG_NAME ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE);

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME, errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END;
/
