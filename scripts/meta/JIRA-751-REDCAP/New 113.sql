select rf.form_name,section_SEQ,section_Q_SEQ,QUEST_TB_QUESTION,modified_by,DATE_MODIFIED
from 
MSDRDEV.REDCAP_PROTOCOL_form rf,
REDCAP_PROTOCOL_TEST  qs
where qs.protocol=rf.protocol
and rf.form_name like '%PX810401%'
 order by rf.form_name,section_SEQ;
 
--UPDATE sbrext.quest_contents_ext  set 

select long_name,'Does the subject suffer from any handicap which prevents an accurate measurement from standing height or arm span length? (standardisation_lungvolumemeasurement_subject_otherhandicap)' new_Q_name
  from sbrext.quest_contents_ext 
    where  DISPLAY_ORDER=10 and qtl_name= 'QUESTION' and P_MOD_IDSEQ in 
      (select qc_idseq from sbrext.quest_contents_ext where  DISPLAY_ORDER=0 and qtl_name='MODULE' 
      and  dn_crf_idseq in (select qc_idseq from sbrext.quest_contents_ext where  qtl_name='CRF'  
      and instr(long_name,'PX810401')>0  ))       
      and NVL(modified_by ,'FORMLOADER') ='FORMLOADER' ;
      
    -- UPDATE sbrext.quest_contents_ext  set long_name='Does the subject currently suffer from upper respiratory or any other contagious disease or illness? (standardisation_lungvolumemeasurement_subject_diseaseor_illness)' 
    
      --select long_name,'Does the subject currently suffer from upper respiratory or any other contagious disease or illness? (standardisation_lungvolumemeasurement_subject_diseaseor_illness)' new_name
      from sbrext.quest_contents_ext 
        where  DISPLAY_ORDER=25 and qtl_name= 'QUESTION' and P_MOD_IDSEQ in 
      (select qc_idseq from sbrext.quest_contents_ext where  DISPLAY_ORDER=0 and qtl_name='MODULE' 
      and  dn_crf_idseq in (select qc_idseq from sbrext.quest_contents_ext where  qtl_name='CRF'  
      and instr(long_name,'PX810401')>0  )  )     
      and NVL(modified_by ,'FORMLOADER') ='FORMLOADER' ;