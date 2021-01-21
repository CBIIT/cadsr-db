DROP MATERIALIZED VIEW SBREXT.MDSR_FB_QUESTION_MVW;

CREATE MATERIALIZED VIEW SBREXT.MDSR_FB_QUESTION_MVW 
    (FORM_ID,FORM_IDSEQ,MOD_IDSEQ,QUES_IDSEQ,QUES_ID,
     QUES_VERSION,QTL_NAME,CONTE_IDSEQ,Q_CONTEXT,DATE_CREATED,
     DATE_MODIFIED,DISPLAY_ORDER,WORKFLOW,Q_PREFERRED_NAME,Q_PREFERRED_DEFINITION,
     DE_IDSEQ,Q_LONG_NAME,DATECREATED,QUESTION,DE_VERSION,
     DE_LONG_NAME,CDE_ID,VD_IDSEQ,DE_WORKFLOW,DE_PREFERRED_NAME,
     D_PREFERRED_DEFINITION,DE_CONTEXT,EDITABLE_IND,MANDATORY_IND,Q_INSTRUCTION,
     ISDERIVED,MULTIVALUE)
TABLESPACE SBREXT
PCTUSED    0
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOCACHE
NOLOGGING
NOCOMPRESS
BUILD IMMEDIATE
REFRESH FORCE ON DEMAND
WITH PRIMARY KEY
ENABLE QUERY REWRITE
AS 
/* Formatted on 1/20/2021 7:17:11 PM (QP5 v5.354) */
SELECT FR.QC_ID                                          form_id,
       FR.QC_IDseq                                       form_idSEQ,
       QQ.p_mod_idseq                                    mod_idseq,
       QQ.QC_IDSEQ                                       QUES_IDSEQ,
       QQ.QC_ID                                          QUES_ID,
       QQ.VERSION                                        QUES_VERSION,
       QQ.QTL_NAME,
       QQ.CONTE_IDSEQ,
       QC.name                                           Q_context,
       QQ.date_created,
       QQ.DATE_MODIFIED,
       QQ.DISPLAY_ORDER,
       QQ.ASL_NAME                                       WORKFLOW,
       QQ.PREFERRED_NAME                                 Q_PREFERRED_NAME,
       QQ.PREFERRED_DEFINITION                           Q_PREFERRED_DEFINITION,
       QQ.DE_IDSEQ,
       QQ.LONG_NAME                                      Q_LONG_NAME,
       QQ.date_Created                                   dateCreated,
       de.QUESTION,
       de.VERSION                                        DE_VERSION,
       de.LONG_NAME                                      DE_LONG_NAME,
       de.CDE_ID,
       --  de.DE_IDSEQ,
       de.VD_IDSEQ,
       de.ASL_NAME                                       DE_WORKFLOW,
       DE.PREFERRED_NAME                                 DE_PREFERRED_NAME,
       DE.PREFERRED_DEFINITION                           D_PREFERRED_DEFINITION,
       DC.name                                           DE_context,
       qa.EDITABLE_IND,
       qa.MANDATORY_IND,
       INS.PREFERRED_DEFINITION                          Q_instruction,
       DECODE (cdv.P_DE_IDSEQ, NULL, 'false', 'true')    isDerived,
       CASE
           WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%check all%'
           THEN
               'Yes'
           WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%mark all%'
           THEN
               'Yes'
           WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%select all%'
           THEN
               'Yes'
           WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%choose all%'
           THEN
               'Yes'
           WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%all that%'
           THEN
               'Yes'
           WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%enter all%'
           THEN
               'Yes'
           WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%report all%'
           THEN
               'Yes'
           WHEN LOWER (INS.PREFERRED_DEFINITION) LIKE '%include all%'
           THEN
               'Yes'
           ELSE
               'No'
       END                                               multiValue
  --   select distinct FR.QC_ID
  FROM QUEST_CONTENTS_EXT              qq,
       QUEST_ATTRIBUTES_EXT            qa,
       QUEST_CONTENTS_EXT              FR,
       SBR.CONTEXTS                    QC,
       
        (  select a.P_QST_IDSEQ,a.preferred_definition from
          (SELECT min(qc_id) OVER(PARTITION BY P_QST_IDSEQ ) as minqc_id,qc_id,qc_idseq,P_QST_IDSEQ,preferred_definition
           FROM QUEST_CONTENTS_EXT 
            WHERE QTL_NAME = 'QUESTION_INSTR'  )a
            where a.minqc_id=a.qc_id) INS,
       SBR.COMPLEX_DATA_ELEMENTS_VIEW  cdv,
       SBR.DATA_ELEMENTS               de,
       SBR.CONTEXTS                    DC
 WHERE     QQ.QC_IDSEQ = qa.QC_IDSEQ
       AND QQ.DN_CRF_IDSEQ = FR.QC_IDSEQ
       AND QQ.CONTE_IDSEQ = QC.CONTE_IDSEQ(+)
       AND DE.CONTE_IDSEQ = DC.CONTE_IDSEQ(+)
       AND INS.P_QST_IDSEQ(+) = QQ.QC_IDSEQ
       AND fr.CONTE_IDSEQ NOT IN
               ('29A8FB18-0AB1-11D6-A42F-0010A4C1E842',
                'E5CA1CEF-E2C6-3073-E034-0003BA3F9857')
       AND FR.ASL_NAME = 'RELEASED'
       AND (FR.QTL_NAME = 'CRF' OR FR.QTL_NAME = 'TEMPLATE')
       AND QQ.qtl_name = 'QUESTION'
       AND cdv.P_DE_IDSEQ(+) = qq.DE_IDSEQ
       AND QQ.DE_IDSEQ = de.DE_IDSEQ(+);


COMMENT ON MATERIALIZED VIEW SBREXT.MDSR_FB_QUESTION_MVW IS 'snapshot table for snapshot SBREXT.MDSR_FB_QUESTION_MVW';

CREATE OR REPLACE PUBLIC SYNONYM MDSR_FB_QUESTION_MVW FOR SBREXT.MDSR_FB_QUESTION_MVW;

CREATE INDEX SBREXT.MDSR_FB_QDE_ID_INX ON SBREXT.MDSR_FB_QUESTION_MVW
(DE_IDSEQ)
LOGGING
TABLESPACE SBREXT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SBREXT.MDSR_FB_QF_ID_INX ON SBREXT.MDSR_FB_QUESTION_MVW
(FORM_IDSEQ)
LOGGING
TABLESPACE SBREXT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SBREXT.MDSR_FB_QM_ID_INX ON SBREXT.MDSR_FB_QUESTION_MVW
(MOD_IDSEQ)
LOGGING
TABLESPACE SBREXT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SBREXT.MDSR_FB_QVD_ID_INX ON SBREXT.MDSR_FB_QUESTION_MVW
(VD_IDSEQ)
LOGGING
TABLESPACE SBREXT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

CREATE INDEX SBREXT.MDSR_FB_Q_ID_INX ON SBREXT.MDSR_FB_QUESTION_MVW
(QUES_IDSEQ)
LOGGING
TABLESPACE SBREXT
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           );

GRANT SELECT ON SBREXT.MDSR_FB_QUESTION_MVW TO PUBLIC;
