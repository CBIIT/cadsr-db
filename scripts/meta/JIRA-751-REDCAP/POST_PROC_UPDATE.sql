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
CREATE OR REPLACE PROCEDURE SBREXT.MDSR_RECAP_MODE_FIX_SQL(p_run IN NUMBER) as


CURSOR c_mod IS
select form_name,trim(section_new) correct_mod_name,m.long_name ,m.preferred_definition,SECTION_SEQ ,m.display_order ,m.QC_IDSEQ,m.qc_id,m.VERSION,
m.modified_by,m.DATE_MODIFIED,m.created_by,m.date_created,m.QTL_NAME
from sbrext.quest_contents_ext f,
sbrext.quest_contents_ext m,
SBREXT.MDSR_REDCAP_SECTION_FL r
where m.dn_crf_idseq =f.qc_idseq 
and f.long_name =r.form_name
and f.QTL_NAME='CRF'
and  m.QTL_NAME ='MODULE'
and SECTION_SEQ=m.display_order
--and m.date_created>sysdate-11
and trim(section_new)<>trim(m.long_name)
and NVL(m.modified_by,'FORMLOADER') ='FORMLOADER';


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
     set preferred_definition= rec.correct_mod_name,long_name=rec.correct_mod_name
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