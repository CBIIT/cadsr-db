/*<TOAD_FILE_CHUNK>*/
CREATE OR REPLACE PROCEDURE SBREXT.MDSR_RECAP_UPDATE_CSV2 as

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
--Update column QUESTION in table REDCAP_PROTOCOL_751 for each protocol starting from 0

merge into MDSR_REDCAP_PROTOCOL_CSV t1
using (select min(question)question,PROTOCOL
from MDSR_REDCAP_PROTOCOL_CSV group by PROTOCOL ) t2
on (t1.PROTOCOL = t2.PROTOCOL)
when matched then 
update set t1.question = t1.question-t2.question;

     
  commit;
--10.Populate sections in REDCAP_PROTOCOL_CSV:
--10.1. Find min Question Number for protocol which is >0 and set it to 0.

 UPDATE MDSR_REDCAP_PROTOCOL_CSV set FORM_Q_num=QUESTION-1  where protocol||form_name in
 --select distinct protocol||form_name from REDCAP_PROTOCOL_751  where protocol||form_name in
 (
 select protocol||form_name from(
 
 select MIN_QUEST, protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
 from(
 select  min(Question) over  (partition by protocol, form_name order by protocol, form_name ) as MIN_QUEST,
 protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
from MDSR_REDCAP_PROTOCOL_CSV)--where form_name='phenx_cancer_personal_and_family_history')
where MIN_QUEST>0 and MIN_QUEST=QUESTION
)
);
commit;
UPDATE MDSR_REDCAP_PROTOCOL_CSV set FORM_Q_num=QUESTION where protocol||form_name in
 --select distinct protocol||form_name,form_NAME_NEW from REDCAP_PROTOCOL_CSV where protocol||form_name in
 (
 select protocol||form_name from(
 
 select MIN_QUEST, protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
 from(
 select  min(Question) over  (partition by protocol, form_name order by protocol, form_name ) as MIN_QUEST,
 protocol, form_name,SECTION_SEQ,SECTION_Q_SEQ,QUESTION,SECTION
from MDSR_REDCAP_PROTOCOL_CSV where protocol not like 'Instructions%')
where MIN_QUEST=0 and MIN_QUEST=QUESTION
)
);
commit;
 UPDATE MDSR_REDCAP_PROTOCOL_CSV set instructions=substr(instructions,length(instructions)-1) 
 where substr(instructions,length(instructions)-1)=';'     ;
  commit;
    EXCEPTION
    WHEN OTHERS THEN
    errmsg := SQLERRM;
         dbms_output.put_line('errmsg insert - '||errmsg);
         rollback;     
       insert into SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR values('MDSR_RECAP_UPDATE_CSV','', errmsg ,SYSDATE);
     commit;
     END;
  

/