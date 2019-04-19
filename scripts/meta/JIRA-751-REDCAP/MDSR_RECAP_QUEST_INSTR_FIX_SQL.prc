CREATE OR REPLACE PROCEDURE SBREXT.MDSR_RECAP_QUEST_FIX_SQL(p_run IN NUMBER) as



CURSOR c_quest IS
select form_name_new,m.long_name mod_name,form_question correct_question,instructions,
i.long_name incorrect_instr,m.display_order mod_order, i.display_order ,i.PREFERRED_DEFINITION,
i.qc_id,i.VERSION,i.QC_IDSEQ,i.QTL_NAME,i.CREATED_BY,i.MODIFIED_BY,i.date_modified,i.DATE_CREATED
from sbrext.quest_contents_ext f,
SBREXT.MDSR_REDCAP_QC_FL r,
sbrext.quest_contents_ext  q,
sbrext.quest_contents_ext  i,
sbrext.quest_contents_ext  m
--,REDCAP_SECTION_751 s
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
and instr(i.long_name,instructions)=0
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
     set preferred_definition= rec.instructions,long_name=rec.instructions
     where   qc_idseq =rec.qc_idseq;
      insert into SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
          ( QC_IDSEQ,  QC_ID ,  VERSION ,  QTL_NAME, PREFERRED_DEFINITION   ,  LONG_NAME ,  DATE_CREATED,
  CREATED_BY , DATE_MODIFIED,MODIFIED_BY,  DATE_INSERTED)      VALUES
       ( rec.QC_IDSEQ,  rec.QC_ID ,  rec.VERSION ,  rec.QTL_NAME, rec.PREFERRED_DEFINITION   ,  rec.incorrect_instr ,  rec.DATE_CREATED,
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