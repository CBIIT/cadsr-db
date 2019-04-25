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
AS 
/* Formatted on 4/25/2019 5:51:01 PM (QP5 v5.336) */
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
       (SELECT PREFERRED_DEFINITION, P_QST_IDSEQ
          FROM SBREXT.QUEST_CONTENTS_EXT
         WHERE qtl_name = 'QUESTION_INSTR') INS,
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

DROP MATERIALIZED VIEW SBREXT.MDSR_FB_QUEST_MODULE_MVW;

CREATE MATERIALIZED VIEW SBREXT.MDSR_FB_QUEST_MODULE_MVW 
    (MOD_IDSEQ,CRF_IDSEQ,MOD_ID,VERSION,CONTE_IDSEQ,
     WORKFLOW,PREFERRED_NAME,PREFERRED_DEFINITION,LONG_NAME,LATEST_VERSION_IND,
     DISPLAY_ORDER,REPEAT_NO,CONTEXT,MOD_INSTRUCTION,USAGETYPE)
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
AS 
/* Formatted on 4/25/2019 5:51:01 PM (QP5 v5.336) */
SELECT MOD.QC_IDSEQ                MOD_IDSEQ,
       MOD.DN_CRF_IDSEQ            CRF_IDSEQ,
       MOD.QC_ID                   MOD_ID,
       MOD.VERSION,
       MOD.CONTE_IDSEQ,
       MOD.ASL_NAME                WORKFLOW,
       MOD.PREFERRED_NAME,
       MOD.PREFERRED_DEFINITION,
       MOD.LONG_NAME,
       MOD.LATEST_VERSION_IND,
       MOD.DISPLAY_ORDER,
       MOD.repeat_no,
       CM.NAME                     CONTEXT,
       INS.PREFERRED_DEFINITION    Mod_instruction,
       CASE
           WHEN MOD.long_NAME LIKE 'Mandatory%' THEN 'Mandatory'
           WHEN MOD.long_NAME LIKE 'Conditional%' THEN 'Conditional'
           WHEN MOD.long_NAME LIKE 'Optional%' THEN 'Optional'
           ELSE 'None'
       END                         AS usageType
  FROM SBREXT.QUEST_CONTENTS_EXT  MOD,
       SBR.CONTEXTS               CM,
       -- QC_RECS_EXT qr,
       -- SBR.CONTEXTS FRC,
       SBREXT.QUEST_CONTENTS_EXT  FR,
       (SELECT PREFERRED_DEFINITION, P_MOD_IDSEQ
          FROM SBREXT.QUEST_CONTENTS_EXT
         WHERE qtl_name = 'MODULE_INSTR') INS
 WHERE                                --AND    MOD.QC_IDSEQ = qr.C_QC_IDSEQ(+)
           MOD.DN_CRF_IDSEQ = FR.QC_IDSEQ
       --AND FR.CONTE_IDSEQ = FRC.CONTE_IDSEQ
       AND MOD.CONTE_IDSEQ = CM.CONTE_IDSEQ
       AND INS.P_MOD_IDSEQ(+) = MOD.QC_IDSEQ
       AND fr.CONTE_IDSEQ NOT IN
               ('29A8FB18-0AB1-11D6-A42F-0010A4C1E842',
                'E5CA1CEF-E2C6-3073-E034-0003BA3F9857')
       AND FR.ASL_NAME = 'RELEASED'
       AND (FR.QTL_NAME = 'CRF' OR FR.QTL_NAME = 'TEMPLATE')
       AND MOD.qtl_name = 'MODULE'
       AND MOD.DELETED_IND = 'No';


COMMENT ON MATERIALIZED VIEW SBREXT.MDSR_FB_QUEST_MODULE_MVW IS 'snapshot table for snapshot SBREXT.MDSR_FB_QUEST_MODULE_MVW';

DROP MATERIALIZED VIEW SBREXT.MDSR_FB_VALID_VALUE_MVW;

CREATE MATERIALIZED VIEW SBREXT.MDSR_FB_VALID_VALUE_MVW 
    (FORM_ID,FORM_IDSEQ,MOD_ID,MOD_IDSEQ,QUEST_ID,
     QUEST_IDSEQ,VV_IDSEQ,"TRIM(QV.DISPLAY_ORDER)",LONG_NAME,MEANING_TEXT,
     DESCRIPTION_TEXT,VM_ID,VM_VERSION,VP_IDSEQ,INSTRUCTION)
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
AS 
/* Formatted on 4/25/2019 5:51:01 PM (QP5 v5.336) */
SELECT QF.qc_id                       FORM_ID,
       QF.qc_idseq                    FORM_IDSEQ,
       QM.qc_id                       MOD_ID,
       QM.qc_idseq                    MOD_IDseq,
       qq.qc_id                       QUEST_ID,
       qq.qc_idseq                    QUEST_IDseq,
       QV.QC_IDSEQ                    VV_IDSEQ,
       TRIM (QV.DISPLAY_ORDER),
       TRIM (QV.long_name)            long_name,
       TRIM (VV.MEANING_TEXT)         MEANING_TEXT,
       TRIM (VV.DESCRIPTION_TEXT)     DESCRIPTION_TEXT,
       vm_id,
       vm_version,
       QV.VP_idseq,
       ins.PREFERRED_DEFINITION       INSTRUCTION
  FROM QUEST_CONTENTS_EXT    QV,
       QUEST_CONTENTS_EXT    QQ,
       QUEST_CONTENTS_EXT    QF,
       QUEST_CONTENTS_EXT    QM,
       VALID_VALUES_ATT_EXT  VV,
       (SELECT PREFERRED_DEFINITION, P_VAL_IDSEQ
          FROM SBREXT.QUEST_CONTENTS_EXT
         WHERE qtl_name = 'VALUE_INSTR') INS,
       (SELECT VP_IDSEQ, vm.vm_id vm_id, vm.version vm_version
          FROM SBR.VALUE_MEANINGS      vm,
               SBR.PERMISSIBLE_VALUES  pv,
               SBR.VD_PVS              vp
         WHERE vm.vm_idseq = pv.VM_idseq AND pv.pv_idseq = vp.pv_idseq) VP
 WHERE     QV.P_QST_IDSEQ = QQ.qc_idseq
       AND QQ.P_mod_idseq = QM.QC_IDSEQ
       AND QM.DN_CRF_idseq = QF.QC_IDSEQ
       AND VV.QC_IDSEQ = QV.QC_IDSEQ
       AND QV.QC_IDSEQ = INS.P_VAL_IDSEQ(+)
       AND QV.VP_idseq = VP.VP_IDSEQ(+)
       AND QV.QTL_NAME = 'VALID_VALUE'
       AND QQ.QTL_NAME = 'QUESTION'
       AND QF.ASL_NAME = 'RELEASED'
       AND (QF.QTL_NAME = 'CRF' OR QF.QTL_NAME = 'TEMPLATE')
       AND QM.QTL_NAME = 'MODULE'
       AND QF.CONTE_IDSEQ NOT IN
               ('29A8FB18-0AB1-11D6-A42F-0010A4C1E842',
                'E5CA1CEF-E2C6-3073-E034-0003BA3F9857');


COMMENT ON MATERIALIZED VIEW SBREXT.MDSR_FB_VALID_VALUE_MVW IS 'snapshot table for snapshot SBREXT.MDSR_FB_VALID_VALUE_MVW';

CREATE OR REPLACE PUBLIC SYNONYM MDSR_FB_QUESTION_MVW FOR SBREXT.MDSR_FB_QUESTION_MVW;

CREATE OR REPLACE PUBLIC SYNONYM MDSR_FB_QUEST_MODULE_MVW FOR SBREXT.MDSR_FB_QUEST_MODULE_MVW;

CREATE OR REPLACE PUBLIC SYNONYM MDSR_FB_VALID_VALUE_MVW FOR SBREXT.MDSR_FB_VALID_VALUE_MVW;

CREATE INDEX SBREXT.MDSR_FB_MODF_ID_INX ON SBREXT.MDSR_FB_QUEST_MODULE_MVW
(CRF_IDSEQ)
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

CREATE INDEX SBREXT.MDSR_FB_MOD_ID_INX ON SBREXT.MDSR_FB_QUEST_MODULE_MVW
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

CREATE INDEX SBREXT.MDSR_FB_VQ_ID_INX ON SBREXT.MDSR_FB_VALID_VALUE_MVW
(QUEST_IDSEQ)
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

CREATE INDEX SBREXT.MDSR_FB_VVP_ID_INX ON SBREXT.MDSR_FB_VALID_VALUE_MVW
(VP_IDSEQ)
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

CREATE INDEX SBREXT.MDSR_FB_VV_ID_INX ON SBREXT.MDSR_FB_VALID_VALUE_MVW
(VV_IDSEQ)
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

GRANT SELECT ON SBREXT.MDSR_FB_QUEST_MODULE_MVW TO PUBLIC;

GRANT SELECT ON SBREXT.MDSR_FB_VALID_VALUE_MVW TO PUBLIC;
