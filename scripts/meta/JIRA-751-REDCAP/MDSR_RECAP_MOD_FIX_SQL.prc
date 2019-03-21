CREATE OR REPLACE PROCEDURE MSDRDEV.MDSR_RECAP_MODE_FIX_SQL as

CURSOR c_form IS
select rf.form_name,mod.long_name ,section_SEQ,SECTION--rf.preferred_definition--,modified_by,DATE_MODIFIED
from sbrext.quest_contents_ext q,
sbrext.quest_contents_ext mod,
MSDRDEV.REDCAP_PROTOCOL_FORM rf,
REDCAP_SECTION  sec
where q.long_name=rf.form_name
and sec.protocol=rf.protocol
and mod.dn_crf_idseq=q.qc_idseq
and section_SEQ=mod.DISPLAY_ORDER
and rf.form_name='PhenX PX510501 - Alcohol Breathalyzer'
and q.qtl_name='CRF'
and mod.qtl_name='MODULE'
and length(trim(mod.long_name))<>length(trim(SECTION))
--and mod.modified_by is null;

CURSOR c_mod IS
select rf.form_name,section_SEQ,NVL (TRIM (sec.SECTION), 'N/A') SECTION--rf.preferred_definition--,modified_by,DATE_MODIFIED
from 
MSDRDEV.REDCAP_PROTOCOL_form rf,
REDCAP_SECTION  sec
where sec.protocol=rf.protocol
and NVL (TRIM (sec.SECTION), 'N/A')<>'N/A'
and rf.form_name like '%PX741401%'
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
from sbrext.quest_contents_ext mod
where dn_crf_idseq in (select qc_idseq from sbrext.quest_contents_ext where  qtl_name='CRF' and long_name  like '%PX741401%')--rec.form_name)
--and DISPLAY_ORDER=rec.section_SEQ
and mod.qtl_name='MODULE'
--and length(trim(mod.long_name))<>length(trim(SECTION))
and NVL(mod.modified_by ,'FORMLOADER') ='FORMLOADER';

IF v_ctn>0 then 

       
      formatstr:='UPDATE sbrext.quest_contents_ext  set preferred_definition= ''%s'',long_name=''%s'' where  DISPLAY_ORDER=%d and dn_crf_idseq in (select qc_idseq from sbrext.quest_contents_ext where  qtl_name=''%s''  and long_name =''%s'' ) and and NVL(mod.modified_by ,''%s'') =''%s'' and qtl_name= ''%s'';';
      --formatstr:=q'[formatstr]';
      formatme := utl_lms.format_message(formatstr, REPLACE(rec.SECTION,'''',''''''),REPLACE(rec.SECTION,'''',''''''),rec.section_SEQ,'CRF',  REPLACE(rec.form_name,'''',''''''),'FORMLOADER','FORMLOADER', 'MODULE');
 insert into MSDRDEV.REDCAP_FIX_SQL(QTL_NAME ,  SQL_TEXT,  FORM_NAME ,  CREATED_DATE ,  LOAD_VER) VALUES ('MODULE', formatme,rec.section_SEQ||' , '||rec.form_name ,SYSDATE,1);

        commit; 
ELSE   null;
end if;
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
               --  insert into MDSR_PROC_ERR_LOG VALUES('MDSR_RECAP_FORM_FIX_SQL','FORM',rec.form_name, sysdate ,errmsg);
     
       insert into SBREXT.MDSR_CDE_XML_REPORT_ERR VALUES ('MODULE',  errmsg, sysdate);

     commit;
 

     END;
     END LOOP;
     END;
/
