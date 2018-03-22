select*from quest_contents_ext where qc_id=5590325
                    
           SELECT a.*, b.EDITABLE_IND, b.QC_ID, c.RULE, d.PREFERRED_NAME as DE_SHORT_NAME, d.PREFERRED_DEFINITION as DE_PREFERRED_DEFINITION, d.CREATED_BY as DE_CREATED_BY,
                            b.DATE_CREATED as QUESTION_DATE_CREATED, b.DATE_MODIFIED as QUESTION_DATE_MODIFIED, e.NAME as DE_CONTEXT_NAME
                             FROM SBREXT.FB_QUESTIONS_VIEW a, CABIO31_QUESTIONS_VIEW b,
                              COMPLEX_DATA_ELEMENTS_VIEW c, 
                              SBR.DATA_ELEMENTS_VIEW d, SBR.CONTEXTS_VIEW e
                             where a.MODULE_IDSEQ = '430203EE-CCBA-6162-E053-F662850A2532' 
                             and a.ques_idseq=b.QC_IDSEQ 
                             and b.DE_IDSEQ = c.P_DE_IDSEQ(+) 
                             and b.de_idseq = d.de_idseq(+)
                             and d.CONTE_IDSEQ = e.CONTE_IDSEQ(+)