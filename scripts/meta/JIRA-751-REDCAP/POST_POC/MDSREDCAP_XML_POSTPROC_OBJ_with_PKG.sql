set serveroutput on size 1000000
SPOOL cadsrmeta-751ppobj.log  


create index SBREXT.MDSR_PROTO_Q_INDX on SBREXT.MDSR_REDCAP_PROTOCOL_CSV (PROTOCOL);
create index SBREXT.MDSR_FN_Q_INDX on SBREXT.MDSR_REDCAP_PROTOCOL_CSV (form_name_new);
create index SBREXT.MDSR_FQ_INDX on SBREXT.MDSR_REDCAP_PROTOCOL_CSV (question);
create index SBREXT.MDSR_FSEC_INDX on SBREXT.MDSR_REDCAP_PROTOCOL_CSV (section_seq);
create index SBREXT.MDSR_FSEC_Q_INDX on SBREXT.MDSR_REDCAP_PROTOCOL_CSV (section_q_seq);
create index SBREXT.MDSR_QLOAD_Q_INDX on SBREXT.MDSR_REDCAP_PROTOCOL_CSV (LOAD_SEQ);
CREATE TABLE SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR
(
  QC_ID         NUMBER,
  QTL_NAME      VARCHAR2(30 BYTE),
  ERR_MSG       VARCHAR2(2000 BYTE),
  DATE_CREATED  DATE
);
CREATE TABLE SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
(
  QC_IDSEQ              CHAR(36 BYTE),
  QC_ID                 NUMBER,
  VERSION               NUMBER(4,2),
  QTL_NAME              VARCHAR2(30 BYTE),
  PREFERRED_DEFINITION  VARCHAR2(2000 BYTE),
  LONG_NAME             VARCHAR2(4000 BYTE),
  DATE_CREATED          DATE,
  CREATED_BY            VARCHAR2(30 BYTE),
  DATE_MODIFIED         DATE,
  MODIFIED_BY           VARCHAR2(30 BYTE),
  DATE_INSERTED         DATE,
  UPDATED_FIELD         VARCHAR2(50 BYTE)
);
CREATE TABLE SBREXT.MDSR_AFTERUPLOD_MODIFIED_REC
(
  QC_ID         NUMBER,
  VERSION               NUMBER(4,2),
  PROTOCOL VARCHAR2(100 BYTE),
  comment_note      VARCHAR2(200 BYTE),
  DATE_CREATED  DATE,
  LOAD_SEQ  NUMBER
);  
GRANT SELECT ON SBREXT.MDSR_AFTERUPLOD_MODIFIED_REC TO PUBLIC;
GRANT SELECT ON SBREXT.MDSR_REDCAP_PROTOCOL_CSV TO PUBLIC;
GRANT SELECT ON SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK TO PUBLIC;
GRANT SELECT ON SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR TO PUBLIC;

GRANT SELECT ON SBREXT.MSDREDCAP_FORM_CSV TO PUBLIC;
GRANT SELECT ON SBREXT.MSDREDCAP_SECTION_CSV TO PUBLIC;
GRANT SELECT ON SBREXT.MSDREDCAP_VALUE_CODE_CSV TO PUBLIC;

create index SBREXT.MDSR_VV_PROTO_Q_INDX on SBREXT.MSDREDCAP_VALUE_CODE_CSV (PROTOCOL);
create index SBREXT.MDSR_VVFN_Q_INDX on SBREXT.MSDREDCAP_VALUE_CODE_CSV (form_name);
create index SBREXT.MDSR_VVQ_INDX on SBREXT.MSDREDCAP_VALUE_CODE_CSV (question);
create index SBREXT.MDSR_VVQLOAD_Q_INDX on SBREXT.MSDREDCAP_VALUE_CODE_CSV (LOAD_SEQ);

CREATE OR REPLACE FORCE VIEW SBREXT.MDSR_DUP_QUESTION_FROM_XML_VW
(
    QC_ID,
    VERSION,
    PREFERRED_NAME,
    PROTOCOL,
    QUEST_SUM,
    QUEST_SUM_CSV
    ,comments
)
AS
select qc_id,
             version,
             preferred_name,
             protocol,
             quest_sum,
             quest_sum_csv,
             comment_note 
             from
     ( (SELECT qc_id,
             version,
             preferred_name,
             protocol,
             quest_sum,
             quest_sum_csv,
             'DUPL' comment_note
        FROM (  SELECT COUNT (*) quest_sum_csv, PROTOCOL, form_name_new
                  FROM sbrext.MDSR_REDCAP_PROTOCOL_CSV
                 WHERE protocol NOT LIKE 'Instr%' AND load_seq = 1
              GROUP BY PROTOCOL, form_name_new) a,
             (  SELECT COUNT (*)     quest_sum,
                       q.dn_crf_idseq,
                       f.qc_id,
                       p.preferred_name,
                       f.version
                  FROM sbrext.quest_contents_ext f,
                       sbrext.quest_contents_ext q,
                       sbrext.PROTOCOL_QC_EXT pp,
                       sbrext.PROTOCOLS_EXT   p
                 WHERE     f.QTL_NAME = 'CRF'
                       AND q.dn_crf_idseq = f.qc_idseq
                       AND q.QTL_NAME = 'QUESTION'
                       AND p.preferred_name LIKE 'PX%'
                       AND f.QC_IDSEQ = pp.QC_IDSEQ
                       AND p.PROTO_IDSEQ = pp.PROTO_IDSEQ
              GROUP BY q.dn_crf_idseq,
                       f.qc_id,
                       p.preferred_name,
                       f.version) b
       WHERE protocol = preferred_name AND quest_sum > quest_sum_csv )      
       UNION       
       (SELECT distinct 
             qc_id,
             version,            
             protocol,
             protocol,
             0,
             0,           
             'MODIFIED' comment_note
                  FROM SBREXT.MDSR_AFTERUPLOD_MODIFIED_REC
                  )   )
    ORDER BY 1,2,3;
/
GRANT SELECT ON SBREXT.MDSR_DUP_QUESTION_FROM_XML_VW TO PUBLIC;
/
GRANT SELECT ON SBREXT.MDSR_DUP_QUESTION_FROM_XML_VW TO PUBLIC
/

CREATE OR REPLACE PACKAGE SBREXT.MDSREDCAP_XML_POSTPOC IS
call_procs BOOLEAN := TRUE;
--  Repository User-Defined Error Messages
NO_ERR VARCHAR2(2) := 'B';
PROCEDURE INSERT_UPDATED_FORMS(p_run in NUMBER);
PROCEDURE FNAME_NO_PRPROTOCOL(p_run in NUMBER);
PROCEDURE FORMNAME_PROTO(p_run in NUMBER);
PROCEDURE FORM_INSTR(p_run in NUMBER);
PROCEDURE MODE_SECTION(p_run in NUMBER);
PROCEDURE FORM_PREFDEF(p_run in NUMBER);
PROCEDURE QUESTION_INSTR(p_run in NUMBER);
PROCEDURE QUESTION_TRUNC(p_run in NUMBER);
PROCEDURE QUESTION_NOMATCH(p_run in NUMBER);
PROCEDURE RUN_POSTPROC(p_run in NUMBER);

END MDSREDCAP_XML_POSTPOC;
/
CREATE OR REPLACE PACKAGE BODY SBREXT.MDSREDCAP_XML_POSTPOC IS
PROCEDURE INSERT_UPDATED_FORMS(p_run IN NUMBER) as
--insert postupload modified from ID

 l_FORM_name      VARCHAR2 (300):='NA';
     errmsg VARCHAR2(800):='Non';
   v_protocol VARCHAR2(50):='';
BEGIN

      
      insert into SBREXT.MDSR_AFTERUPLOD_MODIFIED_REC
          ( QC_ID ,  VERSION ,  PROTOCOL, comment_note,  DATE_CREATED,LOAD_SEQ)      
          SELECT DISTINCT f.qc_id,
                               f.version,                            
                               rf.protocol,                               
                               'MODIFIED' ,
                               SYSDATE,
                               p_run  
                 FROM sbrext.quest_contents_ext f,
                      sbrext.quest_contents_ext q,
                      sbrext.PROTOCOL_QC_EXT   pp,
                      sbrext.PROTOCOLS_EXT     p,
                      SBREXT.MSDREDCAP_FORM_CSV rf
                WHERE     f.QTL_NAME = 'CRF'
                      AND (   q.dn_crf_idseq = f.qc_idseq
                           OR q.QC_IDSEQ = f.qc_idseq)
                      AND TRIM (p.preferred_name) = TRIM (rf.PROTOCOL)
                      AND f.QC_IDSEQ = pp.QC_IDSEQ
                      AND p.PROTO_IDSEQ = pp.PROTO_IDSEQ
                      and rf.load_seq=p_run
                      AND NVL (q.modified_by, 'FORMLOADER') <> 'FORMLOADER';


NO_ERR  := 'A';
call_procs := TRUE;
  commit;

    EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,500);
         dbms_output.put_line('errmsg insert - '||errmsg);
         call_procs  := FALSE;
         rollback;
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values('NA',' FNAME', errmsg ,SYSDATE);
     commit;
     
  
     END INSERT_UPDATED_FORMS;

PROCEDURE FNAME_NO_PRPROTOCOL(p_run IN NUMBER) as
--1. if protocol preferred name not in from long name 
CURSOR c_form IS

select q.long_name,rf.FORM_NAME_NEW,rf.preferred_definition correct_def,q.preferred_definition,
p.PROTOCOL_ID,p.PREFERRED_NAME,q.modified_by,q.DATE_MODIFIED,
q.qc_id,q.qc_idseq,q.created_by,q.date_created,q.QTL_NAME,q.version
from sbrext.quest_contents_ext q,
sbrext.PROTOCOL_QC_EXT pp,
SBREXT.MSDREDCAP_FORM_CSV  rf,
sbrext.PROTOCOLS_EXT p,
SBREXT.MDSR_DUP_QUESTION_FROM_XML_VW vw
where rf.protocol=trim(p.preferred_name)
and q.qc_id=vw.qc_id(+)
and VW.qc_id is null
and q.QC_IDSEQ=pp.QC_IDSEQ
and instr(q.long_name ,rf.PROTOCOL)=0
and p.PROTO_IDSEQ=pp.PROTO_IDSEQ
--and p.PREFERRED_NAME like '%PX121603%'
and q.qtl_name='CRF'
and NVL(q.modified_by,'FORMLOADER') ='FORMLOADER'
order by 2;


 l_FORM_name      VARCHAR2 (300):='NA';
     errmsg VARCHAR2(800):='Non';
   v_protocol VARCHAR2(50):='';
BEGIN
FOR rec IN c_form LOOP
BEGIN
      l_FORM_name:=rec.long_name;
      UPDATE sbrext.quest_contents_ext set date_modified= sysdate,modified_by='SBREXT',CHANGE_NOTE='Modified by The FL Post Process Fix', long_name=rec.FORM_NAME_NEW
      where qc_idseq=rec.qc_idseq;
      commit;
      insert into SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED,UPDATED_FIELD)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.LONG_NAME ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE,'LONG_NAME');

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,500);
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME||' FNAME', errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END FNAME_NO_PRPROTOCOL;

PROCEDURE FORMNAME_PROTO(p_run IN NUMBER) as
-- If all forms loaded with truncated long name ,but from long name includes protocol preferred name
CURSOR c_form IS
select long_name,rf.FORM_NAME_NEW,rf.preferred_definition correct_def,
q.preferred_definition,q.modified_by,q.DATE_MODIFIED,q.qc_id,q.qc_idseq,q.created_by,q.date_created,q.QTL_NAME,q.version
from sbrext.quest_contents_ext q,
SBREXT.MSDREDCAP_FORM_CSV rf,
SBREXT.MDSR_DUP_QUESTION_FROM_XML_VW vw
where instr(q.long_name,trim(rf.PROTOCOL))>0
and q.qc_id=vw.qc_id(+)
and VW.qc_id is null
and rf.load_seq=p_run
--and q.LONG_NAME like 'PhenX PX251601%'
and q.qtl_name='CRF'
and trim(rf.FORM_NAME_NEW)<>trim(long_name)
and NVL(modified_by,'FORMLOADER') ='FORMLOADER'
order by 1;


 l_FORM_name      VARCHAR2 (300):='NA';
   errmsg VARCHAR2(800):='Non';
   v_protocol VARCHAR2(50):='';
 
BEGIN
FOR rec IN c_form LOOP
BEGIN
      l_FORM_name:=rec.long_name;
      UPDATE sbrext.quest_contents_ext set date_modified= sysdate,modified_by='SBREXT',CHANGE_NOTE='Modified by The FL Post Process Fix', long_name=rec.FORM_NAME_NEW
      where qc_idseq=rec.qc_idseq;
      commit;
      insert into SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED,UPDATED_FIELD)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.LONG_NAME ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE,'LONG_NAME');

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,500);
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME||' FNAME', errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
	 END FORMNAME_PROTO;

PROCEDURE FORM_INSTR(p_run IN NUMBER) as


CURSOR c_mod IS
select i.long_name,rf.FORM_NAME_NEW,rf.instructions,i.preferred_definition,i.modified_by,i.DATE_MODIFIED,i.qc_id,i.qc_idseq,i.created_by,i.date_created,i.QTL_NAME,i.version

from sbrext.quest_contents_ext f,
sbrext.quest_contents_ext i,
SBREXT.MDSR_DUP_QUESTION_FROM_XML_VW vw,
SBREXT.MSDREDCAP_FORM_CSV rf
where i.dn_crf_idseq =f.qc_idseq 
and f.long_name =rf.FORM_NAME_NEW
and f.qc_id=vw.qc_id(+)
and VW.qc_id is null
and rf.load_seq=p_run
and f.QTL_NAME='CRF'
and  i.QTL_NAME ='FORM_INSTR'
and trim(rf.instructions)<>trim(i.preferred_definition)
and NVL(i.modified_by,'FORMLOADER') ='FORMLOADER';


 l_FORM_name      VARCHAR2 (100):='NA';
     errmsg VARCHAR2(800):='Non';

BEGIN
FOR rec IN c_mod LOOP
BEGIN


       
     UPDATE sbrext.quest_contents_ext set date_modified= sysdate,modified_by='SBREXT',CHANGE_NOTE='Modified by The FL Post Process Fix', preferred_definition= rec.instructions,long_name=rec.FORM_NAME_NEW
     where   qc_idseq =rec.qc_idseq;
     commit;
      insert into SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED,UPDATED_FIELD)     VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.LONG_NAME ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE,'FORM_INSTR');

     
  commit;

    EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,500);
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME||' FNAME', errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END FORM_INSTR;

PROCEDURE MODE_SECTION(p_run IN NUMBER) as
--If SECTION Long Name Truncated

CURSOR c_mod IS
select form_name,trim(section_new) correct_mod_name,m.long_name ,m.preferred_definition,SECTION_SEQ ,m.display_order ,m.QC_IDSEQ,m.qc_id,m.VERSION,
m.modified_by,m.DATE_MODIFIED,m.created_by,m.date_created,m.QTL_NAME
from sbrext.quest_contents_ext f,
sbrext.quest_contents_ext m,
SBREXT.MSDREDCAP_SECTION_CSV r,
SBREXT.MDSR_DUP_QUESTION_FROM_XML_VW vw
where m.dn_crf_idseq =f.qc_idseq 
and f.qc_id=vw.qc_id(+)
and VW.qc_id is null
and r.LOAD_SEQ=p_run
and f.long_name =r.form_name
and f.QTL_NAME='CRF'
and  m.QTL_NAME ='MODULE'
and SECTION_SEQ=m.display_order
and load_seq=p_run
and trim(section_new)<>trim(m.long_name)
and NVL(m.modified_by,'FORMLOADER') ='FORMLOADER';


 l_FORM_name      VARCHAR2 (100):='NA';
   errmsg VARCHAR2(800):='Non';
   v_protocol VARCHAR2(50):='';
BEGIN
FOR rec IN c_mod LOOP
BEGIN


       
     UPDATE sbrext.quest_contents_ext set date_modified= sysdate,modified_by='SBREXT',CHANGE_NOTE='Modified by The FL Post Process Fix', preferred_definition= rec.correct_mod_name,long_name=rec.correct_mod_name
     where   qc_idseq =rec.qc_idseq;
     commit;
      insert into sbrext.MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED,UPDATED_FIELD)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.LONG_NAME ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE,'MODE_NAME');

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,500);
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into sbrext.MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME, errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END MODE_SECTION;

PROCEDURE FORM_PREFDEF(p_run IN NUMBER) 
as
--find from with truncated preferred _definitions
CURSOR c_form IS
select q.long_name,rf.FORM_NAME_NEW,rf.preferred_definition correct_def,q.preferred_definition,q.modified_by,q.DATE_MODIFIED,q.qc_id,q.qc_idseq,q.created_by,q.date_created,q.QTL_NAME,q.version
from sbrext.quest_contents_ext q,
SBREXT.MSDREDCAP_FORM_CSV rf,
SBREXT.MDSR_DUP_QUESTION_FROM_XML_VW vw
where q.long_name=rf.FORM_NAME_NEW
and q.qc_id=vw.qc_id(+)
and VW.qc_id is null
and rf.LOAD_SEQ=p_run
--and q.LONG_NAME like '%PX662102%'
and q.qtl_name='CRF'
and trim(q.preferred_definition)<>trim(rf.preferred_definition)
and NVL(modified_by,'FORMLOADER') ='FORMLOADER';


   errmsg VARCHAR2(800):='Non';
   v_protocol VARCHAR2(50):='';

BEGIN
FOR rec IN c_form LOOP
BEGIN
     
      UPDATE sbrext.quest_contents_ext set date_modified= sysdate,modified_by='SBREXT',CHANGE_NOTE='Modified by The FL Post Process Fix', preferred_definition=rec.correct_def
      where qc_idseq=rec.qc_idseq;
        commit;
      insert into SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED,UPDATED_FIELD)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.LONG_NAME ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE,'PREF_DEF');

  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,500);
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME||' DEF', errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END FORM_PREFDEF;

PROCEDURE QUESTION_INSTR(p_run IN NUMBER) as

--Find Question Instructions with truncated long name

CURSOR c_quest IS
select form_name_new,m.long_name mod_name,form_question correct_question,instructions,
i.long_name incorrect_instr,m.display_order mod_order, i.display_order ,i.PREFERRED_DEFINITION,
i.qc_id,i.VERSION,i.QC_IDSEQ,i.QTL_NAME,i.CREATED_BY,i.MODIFIED_BY,i.date_modified,i.DATE_CREATED
from sbrext.quest_contents_ext f,
SBREXT.MDSR_REDCAP_PROTOCOL_CSV r,
sbrext.quest_contents_ext  q,
sbrext.quest_contents_ext  i,
sbrext.quest_contents_ext  m,
SBREXT.MDSR_DUP_QUESTION_FROM_XML_VW vw
where m.dn_crf_idseq =f.qc_idseq 
and f.qc_id=vw.qc_id(+)
and VW.qc_id is null
and r.LOAD_SEQ=p_run
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
--and r.PROTOCOL='PX011402'
and instructions||'; Question in xml doesn''t contain valid CDE public id and version. Unable to validate question in xml.'<>i.long_name
order by 1,5,6;


 l_FORM_name      VARCHAR2 (100):='NA';
   errmsg VARCHAR2(800):='Non';
   v_protocol VARCHAR2(50):='';
BEGIN
FOR rec IN c_quest LOOP
BEGIN


       
     UPDATE sbrext.quest_contents_ext set date_modified= sysdate,modified_by='SBREXT',CHANGE_NOTE='Modified by The FL Post Process Fix', preferred_definition= rec.instructions||'; Question in xml doesn''t contain valid CDE public id and version. Unable to validate question in xml.',long_name=rec.instructions||'; Question in xml doesn''t contain valid CDE public id and version. Unable to validate question in xml.'
     where   qc_idseq =rec.qc_idseq;
      insert into  SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED,UPDATED_FIELD)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.incorrect_instr ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE,'QUESTION INSTRUCTION');

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,500);
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME, errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END QUESTION_INSTR;

PROCEDURE QUESTION_TRUNC(p_run IN NUMBER) as

--Find Question Instructions with truncated long name
CURSOR c_quest IS
select form_name_new,q.long_name long_name,form_question correct_question,instructions,
m.display_order mod_order, q.display_order ,q.PREFERRED_DEFINITION,
q.qc_id,q.VERSION,q.QC_IDSEQ,q.QTL_NAME,q.CREATED_BY,q.MODIFIED_BY,
q.date_modified,q.DATE_CREATED
from sbrext.quest_contents_ext f,
SBREXT.MDSR_REDCAP_PROTOCOL_CSV r,
sbrext.quest_contents_ext  q,
sbrext.quest_contents_ext  m,
SBREXT.MDSR_DUP_QUESTION_FROM_XML_VW vw

where m.dn_crf_idseq =f.qc_idseq 
and f.qc_id=vw.qc_id(+)
and VW.qc_id is null
and r.load_seq=p_run
and f.long_name=r.form_name_new
and q.p_MOD_IDSEQ=m.qc_idseq
and f.QTL_NAME='CRF'
and m.QTL_NAME='MODULE'
and q.QTL_NAME ='QUESTION'
and m.display_order=r.SECTION_SEQ
and q.display_order=r.SECTION_Q_SEQ
and NVL(q.modified_by,'FORMLOADER') ='FORMLOADER'
and instr(form_question,trim(q.long_name))>0
and trim(form_question)<>trim(q.long_name)
order by 1,5,6;

   errmsg VARCHAR2(800):='Non';
   v_protocol VARCHAR2(50):='';
  
BEGIN
FOR rec IN c_quest LOOP
BEGIN


       
     UPDATE sbrext.quest_contents_ext set date_modified= sysdate,modified_by='SBREXT',CHANGE_NOTE='Modified by The FL Post Process Fix', preferred_definition= rec.correct_question,long_name=rec.correct_question
     where   qc_idseq =rec.qc_idseq;
     commit;
      insert into SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED,UPDATED_FIELD)       VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.long_name ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE,'QUEST DEF AND NAME');

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,500);
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME, errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END QUESTION_TRUNC;

PROCEDURE QUESTION_NOMATCH(p_run IN NUMBER) as

--Find from Questions with not matching long name 
CURSOR c_quest IS

select form_name_new,q.long_name long_name,form_question correct_question,instructions,
m.display_order mod_order, q.display_order ,q.PREFERRED_DEFINITION,
q.qc_id,q.VERSION,q.QC_IDSEQ,q.QTL_NAME,q.CREATED_BY,q.MODIFIED_BY,
q.date_modified,q.DATE_CREATED
from sbrext.quest_contents_ext f,
SBREXT.MDSR_REDCAP_PROTOCOL_CSV r,
sbrext.quest_contents_ext  q,
sbrext.quest_contents_ext  m,
SBREXT.MDSR_DUP_QUESTION_FROM_XML_VW vw

where m.dn_crf_idseq =f.qc_idseq 
and f.qc_id=vw.qc_id(+)
and VW.qc_id is null
and f.long_name=r.form_name_new
and q.p_MOD_IDSEQ=m.qc_idseq
and f.QTL_NAME='CRF'
and m.QTL_NAME='MODULE'
and q.QTL_NAME ='QUESTION'
and m.display_order=r.SECTION_SEQ
and q.display_order=r.SECTION_Q_SEQ
and r.load_seq=p_run
and NVL(q.modified_by,'FORMLOADER') ='FORMLOADER'
and instr(form_question,trim(q.long_name))=0
and trim(form_question)<>trim(q.long_name)
order by 1,5,6;

   errmsg VARCHAR2(800):='Non';
   v_protocol VARCHAR2(50):='';
  
BEGIN
FOR rec IN c_quest LOOP
BEGIN
       
     UPDATE sbrext.quest_contents_ext set date_modified= sysdate,modified_by='SBREXT',CHANGE_NOTE='Modified by The FL Post Process Fix', preferred_definition= rec.correct_question,long_name=rec.correct_question
     where   qc_idseq =rec.qc_idseq;
     commit;
      insert into SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED,UPDATED_FIELD)       VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.long_name ,  rec.DATE_CREATED,
  rec.CREATED_BY , rec.DATE_MODIFIED,rec.MODIFIED_BY, SYSDATE,'QUEST DEF AND NAME');

     
  commit;
      
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,500);
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values(rec.QC_ID,rec.QTL_NAME, errmsg ,SYSDATE);
     commit;
     END;
     END LOOP;
     END QUESTION_NOMATCH;
     
     PROCEDURE RUN_POSTPROC(p_run IN NUMBER) as
--insert postupload modified from ID

     errmsg VARCHAR2(800):='Non';
   v_protocol VARCHAR2(50):='';
BEGIN

      INSERT_UPDATED_FORMS(p_run);
      IF NO_ERR = 'A' and call_procs = TRUE
      THEN
        FORMNAME_PROTO(p_run );
        FNAME_NO_PRPROTOCOL(p_run); 
        FORM_INSTR(p_run);
        MODE_SECTION(p_run);
        FORM_PREFDEF(p_run);
        QUESTION_INSTR(p_run);
        QUESTION_TRUNC(p_run);
        QUESTION_NOMATCH(p_run);
      END IF; 
 --dbms_output.put_line('insert - '||call_procs||NO_ERR);
 dbms_output.put_line('errmsg insert - '||NO_ERR);
 
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := substr(SQLERRM,1,500);
         dbms_output.put_line('errmsg insert - '||errmsg);
         call_procs  := FALSE;
         rollback;
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values('NA','POSTPROC_RUN', errmsg ,SYSDATE);
     commit;
     
  
     END RUN_POSTPROC;

END MDSREDCAP_XML_POSTPOC;
/
SPOOL OFF
