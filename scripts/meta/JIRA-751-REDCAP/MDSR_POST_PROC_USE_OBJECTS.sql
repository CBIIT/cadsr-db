
create index SBREXT.MDSR_PROTO_Q_INDX on SBREXT.MDSR_REDCAP_PROTOCOL_CSV (PROTOCOL);
create index SBREXT.MDSR_FN_Q_INDX on SBREXT.MDSR_REDCAP_PROTOCOL_CSV (form_name_new);
create index SBREXT.MDSR_FQ_INDX on SBREXT.MDSR_REDCAP_PROTOCOL_CSV (question);
create index SBREXT.MDSR_FSEC_INDX on SBREXT.MDSR_REDCAP_PROTOCOL_CSV (section_seq);
create index SBREXT.MDSR_FSEC_Q_INDX on SBREXT.MDSR_REDCAP_PROTOCOL_CSV (section_q_seq);
create index SBREXT.MDSR_QLOAD_Q_INDX on SBREXT.MDSR_REDCAP_PROTOCOL_CSV (LOAD_SEQ);
CREATE TABLE SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR
(
  QC_ID         NUMBER,
  QTL_NAME      VARCHAR2(30 BYTE),
  ERR_MSG       VARCHAR2(2000 BYTE),
  DATE_CREATED  DATE
);
CREATE TABLE SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK
(
  QC_IDSEQ              CHAR(36 BYTE),
  QC_ID                 NUMBER,
  VERSION               NUMBER(4,2),
  QTL_NAME              VARCHAR2(30 BYTE),
  PREFERRED_DEFINITION  VARCHAR2(2000 BYTE),
  LONG_NAME             VARCHAR2(4000 BYTE),
  DATE_CREATED          DATE,
  CREATED_BY            VARCHAR2(30 BYTE),
  DATE_MODIFIED         DATE,
  MODIFIED_BY           VARCHAR2(30 BYTE),
  DATE_INSERTED         DATE,
  UPDATED_FIELD         VARCHAR2(50 BYTE)
);
GRANT SELECT ON SBREXT.MDSR_REDCAP_PROTOCOL_CSV TO PUBLIC;
GRANT SELECT ON SBREXT.MDSR_QUEST_CONTENTS_REDCAP_BK TO PUBLIC;
GRANT SELECT ON SBREXT.MDSR_QUEST_CONTENTS_UPDATE_ERR TO PUBLIC;

GRANT SELECT ON SBREXT.MSDREDCAP_FORM_CSV TO PUBLIC;
GRANT SELECT ON SBREXT.MSDREDCAP_SECTION_CSV TO PUBLIC;
GRANT SELECT ON SBREXT.MSDREDCAP_VALUE_CODE_CSV TO PUBLIC;

create index SBREXT.MDSR_VV_PROTO_Q_INDX on SBREXT.MSDREDCAP_VALUE_CODE_CSV (PROTOCOL);
create index SBREXT.MDSR_VVFN_Q_INDX on SBREXT.MSDREDCAP_VALUE_CODE_CSV (form_name);
create index SBREXT.MDSR_VVQ_INDX on SBREXT.MSDREDCAP_VALUE_CODE_CSV (question);
create index SBREXT.MDSR_VVQLOAD_Q_INDX on SBREXT.MSDREDCAP_VALUE_CODE_CSV (LOAD_SEQ);

CREATE OR REPLACE FORCE VIEW SBREXT.MDSR_DUP_QUESTION_FROM_XML_VW
(
    QC_ID,
    VERSION,
    PREFERRED_NAME,
    PROTOCOL,
    QUEST_SUM,
    QUEST_SUM_CSV
)
AS
      SELECT qc_id,
             version,
             preferred_name,
             protocol,
             quest_sum,
             quest_sum_csv
        FROM (  SELECT COUNT (*) quest_sum_csv, PROTOCOL, form_name_new
                  FROM sbrext.MDSR_REDCAP_PROTOCOL_CSV
                 WHERE protocol NOT LIKE 'Instr%' AND load_seq = 1
              GROUP BY PROTOCOL, form_name_new) a,
             (  SELECT COUNT (*)     quest_sum,
                       q.dn_crf_idseq,
                       f.qc_id,
                       p.preferred_name,
                       f.version
                  FROM sbrext.quest_contents_ext f,
                       sbrext.quest_contents_ext q,
                       sbrext.PROTOCOL_QC_EXT pp,
                       sbrext.PROTOCOLS_EXT   p
                 WHERE     f.QTL_NAME = 'CRF'
                       AND q.dn_crf_idseq = f.qc_idseq
                       AND q.QTL_NAME = 'QUESTION'
                       AND p.preferred_name LIKE 'PX%'
                       AND f.QC_IDSEQ = pp.QC_IDSEQ
                       AND p.PROTO_IDSEQ = pp.PROTO_IDSEQ
              GROUP BY q.dn_crf_idseq,
                       f.qc_id,
                       p.preferred_name,
                       f.version) b
       WHERE protocol = preferred_name AND quest_sum > quest_sum_csv
    ORDER BY qc_id, version;


GRANT SELECT ON SBREXT.MDSR_DUP_QUESTION_FROM_XML_VW TO PUBLIC;
