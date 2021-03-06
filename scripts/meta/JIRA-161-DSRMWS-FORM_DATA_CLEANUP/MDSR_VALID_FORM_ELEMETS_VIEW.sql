CREATE OR REPLACE FORCE VIEW SBREXT.MDSR_VALID_FORM_ELEMETS_VIEW
(
   QTL_NAME, QC_IDSEQ
    )
AS
      SELECT QTL_NAME,QC_IDSEQ
      from SBREXT.QUEST_CONTENTS_EXT
      WHERE  qtl_name in('CRF','TEMPLATE')
    UNION
       SELECT M.QTL_NAME,M.QC_IDSEQ
      from SBREXT.QUEST_CONTENTS_EXT F,
           SBREXT.QUEST_CONTENTS_EXT M
      WHERE  F.qtl_name in('CRF','TEMPLATE')
         AND M.QTL_NAME='INSTRUCTIONS'
         AND M.DN_CRF_IDSEQ=F.QC_IDSEQ
    UNION
       SELECT M.QTL_NAME,M.QC_IDSEQ
      from SBREXT.QUEST_CONTENTS_EXT F,
           SBREXT.QUEST_CONTENTS_EXT M
      WHERE  F.qtl_name in('CRF','TEMPLATE')
         AND M.QTL_NAME='FOOTER'
         AND M.DN_CRF_IDSEQ=F.QC_IDSEQ
    UNION
       SELECT M.QTL_NAME,M.QC_IDSEQ
      from SBREXT.QUEST_CONTENTS_EXT F,
           SBREXT.QUEST_CONTENTS_EXT M
      WHERE  F.qtl_name in('CRF','TEMPLATE')
         AND M.QTL_NAME='FORM_INSTR'
         AND M.DN_CRF_IDSEQ=F.QC_IDSEQ     

      UNION
      SELECT M.QTL_NAME,M.QC_IDSEQ
      from SBREXT.QUEST_CONTENTS_EXT F,
           SBREXT.QUEST_CONTENTS_EXT M
      WHERE  F.qtl_name in('CRF','TEMPLATE')
         AND M.QTL_NAME='MODULE'
         AND M.DN_CRF_IDSEQ=F.QC_IDSEQ
    UNION
      SELECT Q.QTL_NAME,Q.QC_IDSEQ
      from SBREXT.QUEST_CONTENTS_EXT F,
           SBREXT.QUEST_CONTENTS_EXT M,
           SBREXT.QUEST_CONTENTS_EXT Q
      WHERE  F.qtl_name in('CRF','TEMPLATE')
         AND M.QTL_NAME='MODULE'
         AND Q.QTL_NAME='MODULE_INSTR'
         AND M.DN_CRF_IDSEQ=F.QC_IDSEQ
         AND Q.P_MOD_IDSEQ=M.QC_IDSEQ     
      UNION
      SELECT Q.QTL_NAME,Q.QC_IDSEQ
      from SBREXT.QUEST_CONTENTS_EXT F,
           SBREXT.QUEST_CONTENTS_EXT M,
           SBREXT.QUEST_CONTENTS_EXT Q
      WHERE  F.qtl_name in('CRF','TEMPLATE')
         AND M.QTL_NAME='MODULE'
         AND Q.QTL_NAME='QUESTION'
         AND M.DN_CRF_IDSEQ=F.QC_IDSEQ
         AND Q.P_MOD_IDSEQ=M.QC_IDSEQ
    UNION
      SELECT V.QTL_NAME,V.QC_IDSEQ
      from SBREXT.QUEST_CONTENTS_EXT F,
           SBREXT.QUEST_CONTENTS_EXT M,
           SBREXT.QUEST_CONTENTS_EXT Q,
           SBREXT.QUEST_CONTENTS_EXT V
      WHERE  F.qtl_name in('CRF','TEMPLATE')
         AND M.QTL_NAME='MODULE'
         AND Q.QTL_NAME='QUESTION'
         AND V.QTL_NAME='QUESTION_INSTR'
         AND M.DN_CRF_IDSEQ=F.QC_IDSEQ
         AND Q.P_MOD_IDSEQ=M.QC_IDSEQ
         AND V.P_QST_IDSEQ = Q.QC_IDSEQ
    UNION
      SELECT V.QTL_NAME,V.QC_IDSEQ
      from SBREXT.QUEST_CONTENTS_EXT F,
           SBREXT.QUEST_CONTENTS_EXT M,
           SBREXT.QUEST_CONTENTS_EXT Q,
           SBREXT.QUEST_CONTENTS_EXT V
      WHERE  F.qtl_name in('CRF','TEMPLATE')
         AND M.QTL_NAME='MODULE'
         AND Q.QTL_NAME='QUESTION'
         AND V.QTL_NAME='VALID_VALUE'
         AND M.DN_CRF_IDSEQ=F.QC_IDSEQ
         AND Q.P_MOD_IDSEQ=M.QC_IDSEQ
         AND V.P_QST_IDSEQ = Q.QC_IDSEQ         
     UNION
      SELECT I.QTL_NAME,I.QC_IDSEQ
      from SBREXT.QUEST_CONTENTS_EXT F,
           SBREXT.QUEST_CONTENTS_EXT M,
           SBREXT.QUEST_CONTENTS_EXT Q,
           SBREXT.QUEST_CONTENTS_EXT V,
           SBREXT.QUEST_CONTENTS_EXT I
      WHERE  F.qtl_name in('CRF','TEMPLATE')
         AND M.QTL_NAME='MODULE'
         AND Q.QTL_NAME='QUESTION'
         AND V.QTL_NAME='VALID_VALUE'
         AND I.QTL_NAME='VALUE_INSTR'
         AND M.DN_CRF_IDSEQ=F.QC_IDSEQ
         AND Q.P_MOD_IDSEQ=M.QC_IDSEQ
         AND V.P_QST_IDSEQ = Q.QC_IDSEQ
         AND i.P_VAL_IDSEQ = V.QC_IDSEQ
       order by 1;
       
