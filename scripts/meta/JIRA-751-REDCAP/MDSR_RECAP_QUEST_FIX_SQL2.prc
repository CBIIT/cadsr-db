CREATE OR REPLACE PROCEDURE MSDRDEV.MDSR_RECAP_QUEST_FIX_SQL as


CURSOR c_mod IS
select rf.form_name,section_SEQ,section_Q_SEQ,QUEST_TB_QUESTION,r.protocol--,modified_by,DATE_MODIFIED
from 
MSDRDEV.REDCAP_PROTOCOL_form rf,
REDCAP_PROTOCOL_TEST  r
where r.protocol=rf.protocol
and rf.form_name like '%PX810401%'
 order by rf.form_name,section_SEQ;


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

select count(*) into v_ctn
from sbrext.quest_contents_ext q,
sbrext.quest_contents_ext mod,
sbrext.quest_contents_ext f
where mod.dn_crf_idseq=f.qc_idseq
and q.P_MOD_IDSEQ=mod.qc_idseq
and mod.DISPLAY_ORDER=rec.section_SEQ
and q.DISPLAY_ORDER = rec.section_Q_SEQ
and instr(f.long_name,rec.protocol)>0
and mod.qtl_name='MODULE'
and f.qtl_name='CRF'
and q.qtl_name='QUESTION'
and length(trim(q.long_name))<>length(trim(rec.QUEST_TB_QUESTION))
and NVL(q.modified_by ,'FORMLOADER') ='FORMLOADER';

IF v_ctn>0 then 

       
      formatstr:='UPDATE sbrext.quest_contents_ext  set long_name=''%s'' 
      where  DISPLAY_ORDER=%d and qtl_name= ''%s'' and P_MOD_IDSEQ in 
      (select qc_idseq from sbrext.quest_contents_ext where  DISPLAY_ORDER=%d and qtl_name=''%s'' 
      and  dn_crf_idseq in (select qc_idseq from sbrext.quest_contents_ext where  qtl_name=''%s''  
      and instr(long_name,''%s'')>0  )  )     
      and NVL(modified_by ,''%s'') =''%s'' ;';
      --formatstr:=q'[formatstr]';
      formatme := utl_lms.format_message(formatstr,REPLACE(rec.QUEST_TB_QUESTION,'''',''''''), 
      REPLACE(rec.section_Q_SEQ,'''',''''''),'QUESTION',REPLACE(rec.section_SEQ,'''',''''''), 'MODULE','CRF',  
      REPLACE(rec.protocol,'''',''''''),'FORMLOADER','FORMLOADER');
 insert into MSDRDEV.REDCAP_FIX_SQL(QTL_NAME ,  SQL_TEXT,  FORM_NAME ,  CREATED_DATE ,  LOAD_VER) VALUES ('QUESTION', formatme,rec.section_Q_SEQ||' , '||rec.protocol ,SYSDATE,1);

        commit; 
ELSE   null;
end if;
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
               --  insert into MDSR_PROC_ERR_LOG VALUES('MDSR_RECAP_FORM_FIX_SQL','FORM',rec.form_name, sysdate ,errmsg);
     
       insert into SBREXT.MDSR_CDE_XML_REPORT_ERR VALUES ('QUESTION',  errmsg, sysdate);

     commit;
 

     END;
     END LOOP;
     END;
/