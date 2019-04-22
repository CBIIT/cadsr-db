/*<TOAD_FILE_CHUNK>*/
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

/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PROCEDURE SBREXT.MDSR_RECAP_FRINST_FIX_SQL(p_run IN NUMBER) as


CURSOR c_mod IS
select i.long_name,rf.FORM_NAME_NEW,rf.instructions,i.preferred_definition,i.modified_by,i.DATE_MODIFIED,i.qc_id,i.qc_idseq,i.created_by,i.date_created,i.QTL_NAME,i.version

from sbrext.quest_contents_ext f,
sbrext.quest_contents_ext i,
SBREXT.MDSR_REDCAP_FORM_FL  rf
where i.dn_crf_idseq =f.qc_idseq 
and f.long_name =rf.FORM_NAME_NEW
and f.QTL_NAME='CRF'
and  i.QTL_NAME ='FORM_INSTR'
--and m.date_created>sysdate-11
and --i.long_name <>rf.FORM_NAME_NEW
trim(instructions)<>trim(i.preferred_definition)
and NVL(i.modified_by,'FORMLOADER') ='FORMLOADER';


 l_FORM_name      VARCHAR2 (100):='NA';
   l_where       VARCHAR2 (1000);
   l_SQL         CLOB:=null;
   l_update       VARCHAR2 (4000);
   l_qtl        VARCHAR2 (3):='CRF';
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
   v_ctn number;
   formatme CLOB;
   formatstr CLOB ;
BEGIN
FOR rec IN c_mod LOOP
BEGIN


       
     UPDATE sbrext.quest_contents_ext  
     set preferred_definition= rec.instructions,long_name=rec.FORM_NAME_NEW
     where   qc_idseq =rec.qc_idseq;
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

/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PROCEDURE SBREXT.MDSR_RECAP_INSERT_CSV as

 l_FORM_name      VARCHAR2 (100):='NA';
   l_where       VARCHAR2 (1000);
   l_SQL         CLOB:=null;
   l_update       VARCHAR2 (4000);
   l_qtl        VARCHAR2 (3):='CRF';
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(500):='Non';
   v_protocol VARCHAR2(50):='';
   v_ctn number;
   formatme CLOB;
   formatstr CLOB ;
BEGIN

delete from REDCAPPROTOCOL_TEMP where Form_Name='Form Name' or Form_Name is  null;
commit;
insert into MDSR_REDCAP_PROTOCOL_CSV
 (
 VARIABLE_FIELD_NAME ,
 FORM_NAME ,
 SECTION , 
 FIELD_TYPE ,
 FIELD_LABEL ,
 CHOICES ,
 FIELD_NOTE ,
 QUESTION ,
 TEXT_VALID_TYPE ,
 TEXT_VALID_MIN ,
 TEXT_VALID_MAX ,
 IDENTIFIER ,
 LOGIC ,
 REQUIRED ,
 CUSTOM_ALIGNMENT ,
 MATRIX_GROUP_NAME , 
 MATRIX_RANK ,
 PROTOCOL ,
 Q_NMB_SERV ,
 QUESTION_CSV 
)
select 
VARIABLE_FIELD_NAME ,
 FORM_NAME ,
 SECTION ,
 FIELD_TYPE ,
 substr(FIELD_LABEL, 1, 2000 ) ,
 CHOICES ,
 FIELD_NOTE ,
 TRIM(QUESTION) ,
 TEXT_VALID_TYPE ,
 TEXT_VALID_MIN ,
 TEXT_VALID_MAX ,
 IDENTIFIER ,
 TRIM(LOGIC) ,
 REQUIRED ,
 CUSTOM_ALIGNMENT ,
 MATRIX_GROUP_NAME ,
 MATRIX_RANK ,
 'PX'||SUBSTR(TRIM(FIELD_NOTE),-6) , 
 Q_NMB_SERV ,
 substr(FIELD_LABEL, 1, 4000 ) 
from REDCAPPROTOCOL_TEMP;

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values('MDSR_RECAP_INSERT_CSV','', errmsg ,SYSDATE);
     commit;
     END;
  

/

