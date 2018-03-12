select   *from sbrext.quest_contents_ext where qc_id='3460779' or DN_CRF_IDSEQ='BFFFF54D-924E-6589-E040-BB89AD4358F6' order by QTL_NAME

select distinct QTL_NAME from sbrext.quest_contents_ext where ASL_NAME='RELEASED'

QUESTION
VALID_VALUE
FORM_INSTR
VALUE_INSTR
CRF
MODULE
QUESTION_INSTR
TEMPLATE
MODULE_INSTR

select  DN_CRF_IDSEQ,qc_ID,qc_idseq,QTL_NAME from sbrext.quest_contents_ext where ASL_NAME='RELEASED' and QTL_NAME in ('FORM_INSTR','VALUE_INSTR','QUESTION_INSTR','MODULE_INSTR')
 and DN_CRF_IDSEQ in(
 select qc_idseq from sbrext.quest_contents_ext where ASL_NAME='RELEASED' and QTL_NAME in('CRF','TEMPLATE')
 )order by  DN_CRF_IDSEQ,QTL_NAME


select*from sbrext.quest_contents_ext where qc_idseq='16D0D1CF-B7EB-34E6-E044-0003BA3F9857'
order by  QTL_NAME DN_CRF_IDSEQ='2F1DA7F6-7603-10CA-E044-0003BA3F9857' or