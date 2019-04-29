DROP PROCEDURE MSDRDEV.MDSR_RECAP_FNAME_NOPR_FIX_SQL;

CREATE OR REPLACE PROCEDURE MSDRDEV.MDSR_RECAP_FNAME_NOPR_FIX_SQL(p_run IN NUMBER) as

CURSOR c_form IS

select q.long_name,rf.FORM_NAME_NEW,rf.preferred_definition correct_def,q.preferred_definition,
p.PROTOCOL_ID,p.PREFERRED_NAME,q.modified_by,q.DATE_MODIFIED,
q.qc_id,q.qc_idseq,q.created_by,q.date_created,q.QTL_NAME,q.version
from sbrext.quest_contents_ext q,
sbrext.PROTOCOL_QC_EXT pp,
MSDREDCAP_FORM_CSV  rf,
sbrext.PROTOCOLS_EXT p
where rf.protocol=trim(p.preferred_name)
and q.QC_IDSEQ=pp.QC_IDSEQ
and instr(q.long_name ,rf.PROTOCOL)=0
and p.PROTO_IDSEQ=pp.PROTO_IDSEQ
--and p.PREFERRED_NAME like '%PX121603%'
and q.qtl_name='CRF'
and NVL(q.modified_by,'FORMLOADER') ='FORMLOADER'
order by 2;
 --select * from sbrext.PROTOCOL_QC_EXT where qc_idseq='875C5F86-61EB-26E2-E053-246C850A811E'

--select * from sbrext.quest_contents_ext where long_name like '%PX121603%'

 l_FORM_name      VARCHAR2 (300):='NA';
   l_where       VARCHAR2 (1000);
   l_SQL         CLOB:=null;
   l_update       VARCHAR2 (4000);
   l_qtl        VARCHAR2 (3):='CRF';
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(800):='Non';
   v_protocol VARCHAR2(50):='';
   formatme CLOB;
   formatstr CLOB ;
BEGIN
FOR rec IN c_form LOOP
BEGIN
      l_FORM_name:=rec.long_name;
      UPDATE sbrext.quest_contents_ext  set long_name=rec.FORM_NAME_NEW
      where qc_idseq=rec.qc_idseq;
      commit;
      insert into MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED,UPDATED_FIELD)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.LONG_NAME ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE,'LONG_NAME');

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME||' FNAME', errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END;
/


DROP PROCEDURE MSDRDEV.MDSR_RECAP_FORMNAME_FIX_SQL;

CREATE OR REPLACE PROCEDURE MSDRDEV.MDSR_RECAP_FORMNAME_FIX_SQL(p_run IN NUMBER) as

CURSOR c_form IS
select long_name,rf.FORM_NAME_NEW,rf.preferred_definition correct_def,q.preferred_definition,q.modified_by,q.DATE_MODIFIED,qc_id,qc_idseq,created_by,date_created,QTL_NAME,version
from sbrext.quest_contents_ext q,
SBREXT.MDSR_REDCAP_FORM_FL rf
where q.long_name like '%'||PROTOCOL||'%'
--and q.LONG_NAME like 'PhenX PX251601%'
and q.qtl_name='CRF'
and trim(rf.FORM_NAME_NEW)<>trim(long_name)
--and NVL(modified_by,'FORMLOADER') ='FORMLOADER'
;


 l_FORM_name      VARCHAR2 (300):='NA';
   l_where       VARCHAR2 (1000);
   l_SQL         CLOB:=null;
   l_update       VARCHAR2 (4000);
   l_qtl        VARCHAR2 (3):='CRF';
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(800):='Non';
   v_protocol VARCHAR2(50):='';
   formatme CLOB;
   formatstr CLOB ;
BEGIN
FOR rec IN c_form LOOP
BEGIN
      l_FORM_name:=rec.long_name;
      UPDATE sbrext.quest_contents_ext  set long_name=rec.FORM_NAME_NEW
      where qc_idseq=rec.qc_idseq;
      commit;
      insert into MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED,UPDATED_FIELD)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.LONG_NAME ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE,'LONG_NAME');

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME||' FNAME', errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END;
/


DROP PROCEDURE MSDRDEV.MDSR_RECAP_FORM_FIX_SQL;

CREATE OR REPLACE PROCEDURE MSDRDEV.MDSR_RECAP_FORM_FIX_SQL--(p_run IN NUMBER) 
as

CURSOR c_form IS
select long_name,rf.FORM_NAME_NEW,rf.preferred_definition correct_def,q.preferred_definition,q.modified_by,q.DATE_MODIFIED,qc_id,qc_idseq,created_by,date_created,QTL_NAME,version
from sbrext.quest_contents_ext q,
MSDREDCAP_FORM_CSV rf
where q.long_name=rf.FORM_NAME_NEW
--and q.LONG_NAME like '%PX662102%'
and q.qtl_name='CRF'
and length(trim(q.preferred_definition))<>length(trim(rf.preferred_definition))
and NVL(modified_by,'FORMLOADER') ='FORMLOADER';


 l_FORM_name      VARCHAR2 (500):='NA';
   l_where       VARCHAR2 (1000);
   l_SQL         CLOB:=null;
   l_update       VARCHAR2 (4000);
   l_qtl        VARCHAR2 (3):='CRF';
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(800):='Non';
   v_protocol VARCHAR2(50):='';
   formatme CLOB;
   formatstr CLOB ;
BEGIN
FOR rec IN c_form LOOP
BEGIN
      l_FORM_name:=rec.long_name;
    --   dbms_output.put_line('errmsg insert - '||rec.long_name);
    --   dbms_output.put_line('errmsg insert - '||rec.correct_def);
    UPDATE sbrext.quest_contents_ext  set preferred_definition=rec.correct_def
      where qc_idseq=rec.qc_idseq;
        commit;
      insert into MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED,UPDATED_FIELD)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.LONG_NAME ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE,'PREF_DEF'); /* */
--dbms_output.put_line('errmsg insert - '||rec.correct_def);
     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,500);
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME||' DEF', errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END;
/


DROP PROCEDURE MSDRDEV.MDSR_RECAP_FORM_PR_DEF_FIX_SQL;

CREATE OR REPLACE PROCEDURE MSDRDEV.MDSR_RECAP_FORM_PR_DEF_FIX_SQL--(p_run IN NUMBER) 
as

CURSOR c_form IS
select long_name,rf.FORM_NAME_NEW,rf.preferred_definition correct_def,q.preferred_definition,q.modified_by,q.DATE_MODIFIED,qc_id,qc_idseq,created_by,date_created,QTL_NAME,version
from sbrext.quest_contents_ext q,
MSDREDCAP_FORM_CSV rf
where q.long_name=rf.FORM_NAME_NEW
--and q.LONG_NAME like '%PX662102%'
and q.qtl_name='CRF'
and length(trim(q.preferred_definition))<>length(trim(rf.preferred_definition))
and NVL(modified_by,'FORMLOADER') ='FORMLOADER';


 l_FORM_name      VARCHAR2 (500):='NA';
   l_where       VARCHAR2 (1000);
   l_SQL         CLOB:=null;
   l_update       VARCHAR2 (4000);
   l_qtl        VARCHAR2 (3):='CRF';
   I_FR_ID  VARCHAR2 (30);
   errmsg VARCHAR2(800):='Non';
   v_protocol VARCHAR2(50):='';
   formatme CLOB;
   formatstr CLOB ;
BEGIN
FOR rec IN c_form LOOP
BEGIN
      l_FORM_name:=rec.long_name;
    --   dbms_output.put_line('errmsg insert - '||rec.long_name);
    --   dbms_output.put_line('errmsg insert - '||rec.correct_def);
    UPDATE sbrext.quest_contents_ext  set preferred_definition=rec.correct_def
      where qc_idseq=rec.qc_idseq;
        commit;
      insert into MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED,UPDATED_FIELD)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.LONG_NAME ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE,'PREF_DEF'); /* */
--dbms_output.put_line('errmsg insert - '||rec.correct_def);
     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,500);
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME||' DEF', errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END;
/


DROP PROCEDURE MSDRDEV.MDSR_RECAP_MODE_FIX_SQL;

CREATE OR REPLACE PROCEDURE MSDRDEV.MDSR_RECAP_MODE_FIX_SQL(p_run IN NUMBER) as


CURSOR c_mod IS
select form_name,trim(section_new) correct_mod_name,m.long_name ,m.preferred_definition,SECTION_SEQ ,m.display_order ,m.QC_IDSEQ,m.qc_id,m.VERSION,
m.modified_by,m.DATE_MODIFIED,m.created_by,m.date_created,m.QTL_NAME
from sbrext.quest_contents_ext f,
sbrext.quest_contents_ext m,
MSDREDCAP_SECTION_CSV r
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
     commit;
      insert into MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED,UPDATED_FIELD)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.LONG_NAME ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE,'MODE_NAME');

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME, errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END;
/


DROP PROCEDURE MSDRDEV.MDSR_RECAP_QUESTINSTR_FIX_SQL;

CREATE OR REPLACE PROCEDURE MSDRDEV.MDSR_RECAP_QUESTINSTR_FIX_SQL(p_run IN NUMBER) as



CURSOR c_quest IS
select form_name_new,m.long_name mod_name,form_question correct_question,instructions,
i.long_name incorrect_instr,m.display_order mod_order, i.display_order ,i.PREFERRED_DEFINITION,
i.qc_id,i.VERSION,i.QC_IDSEQ,i.QTL_NAME,i.CREATED_BY,i.MODIFIED_BY,i.date_modified,i.DATE_CREATED
from sbrext.quest_contents_ext f,
MDSR_REDCAP_PROTOCOL_CSV r,
sbrext.quest_contents_ext  q,
sbrext.quest_contents_ext  i,
sbrext.quest_contents_ext  m

where m.dn_crf_idseq =f.qc_idseq 
and f.long_name=r.form_name_new
and q.p_MOD_IDSEQ=m.qc_idseq
and i.P_QST_IDSEQ =q.QC_IDSEQ
and f.QTL_NAME='CRF'
and m.QTL_NAME='MODULE'
and q.QTL_NAME ='QUESTION'
and i.QTL_NAME ='QUESTION_INSTR'
and m.display_order=r.SECTION_SEQ
and q.display_order=r.SECTION_Q_SEQ
and NVL(i.modified_by,'FORMLOADER') ='FORMLOADER'
and instructions is not null
and r.PROTOCOL='PX011402'
and instructions||'; Question in xml doesn''t contain valid CDE public id and version. Unable to validate question in xml.'<>i.long_name
order by 1,5,6;


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
FOR rec IN c_quest LOOP
BEGIN


       
     UPDATE sbrext.quest_contents_ext  
     set preferred_definition= rec.instructions||'; Question in xml doesn''t contain valid CDE public id and version. Unable to validate question in xml.',long_name=rec.instructions||'; Question in xml doesn''t contain valid CDE public id and version. Unable to validate question in xml.'
     where   qc_idseq =rec.qc_idseq;
      insert into  MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED,UPDATED_FIELD)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.incorrect_instr ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE,'QUESTION INSTRUCTION');

     
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


DROP PROCEDURE MSDRDEV.MDSR_RECAP_QUEST_FIX_SQL;

CREATE OR REPLACE PROCEDURE MSDRDEV.MDSR_RECAP_QUEST_FIX_SQL as


CURSOR c_quest IS
select form_name_new,q.long_name long_name,form_question correct_question,instructions,
m.display_order mod_order, q.display_order ,q.PREFERRED_DEFINITION,
q.qc_id,q.VERSION,q.QC_IDSEQ,q.QTL_NAME,q.CREATED_BY,q.MODIFIED_BY,
q.date_modified,q.DATE_CREATED
from sbrext.quest_contents_ext f,
MDSR_REDCAP_PROTOCOL_CSV r,
sbrext.quest_contents_ext  q,
sbrext.quest_contents_ext  m

where m.dn_crf_idseq =f.qc_idseq 
and f.long_name=r.form_name_new
and q.p_MOD_IDSEQ=m.qc_idseq
and f.QTL_NAME='CRF'
and m.QTL_NAME='MODULE'
and q.QTL_NAME ='QUESTION'
and m.display_order=r.SECTION_SEQ
and q.display_order=r.SECTION_Q_SEQ
and NVL(q.modified_by,'FORMLOADER') ='FORMLOADER'
and instr(form_question,trim(q.long_name))=0
and trim(form_question)<>trim(q.long_name)
order by 1,5,6;



   errmsg VARCHAR2(800):='Non';
   v_protocol VARCHAR2(50):='';
  
BEGIN
FOR rec IN c_quest LOOP
BEGIN


       
     UPDATE sbrext.quest_contents_ext  
     set preferred_definition= rec.correct_question,long_name=rec.correct_question
     where   qc_idseq =rec.qc_idseq;
     commit;
      insert into MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED,UPDATED_FIELD)       VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.long_name ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE,'QUEST DEF AND NAME');

     
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
