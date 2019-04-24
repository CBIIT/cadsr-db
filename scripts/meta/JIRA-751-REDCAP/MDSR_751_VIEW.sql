DROP VIEW MSDRDEV.REDCAP_FORM_COLLECT_CSV_VW;

/* Formatted on 4/24/2019 2:32:57 PM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW MSDRDEV.REDCAP_FORM_COLLECT_CSV_VW
(
    "collectionName",
    "collectionDescription",
    "group"
)
AS
    SELECT 'PhenX Protocols - ' || v.GROUP_NUMBER    "collectionName",
           'Load PhenX ' || v.protocols              "collectionDescription",
           CAST (
               MULTISET (
                     SELECT 'PhenX',
                            'dwarzel',
                               TO_CHAR (SYSDATE, 'YYYY-MM-DD')
                            || 'T'
                            || TO_CHAR (SYSDATE, 'HH24:MI:SS'),
                            p.form_name_new,
                            'Uploaded via FormLoader',
                            UTL_I18N.UNESCAPE_REFERENCE (
                                TRIM (p.preferred_definition)),
                            '2.16.840.1.113883.3.26.2',
                            '',
                            '1.0',
                            'DRAFT NEW',
                            'CRF',
                            REDCAP_HINSTRUCTIONS_T (
                                TRIM (
                                    UTL_I18N.UNESCAPE_REFERENCE (
                                        p.INSTRUCTIONS))),
                            '',
                            CAST (
                                MULTISET (
                                      SELECT NVL (TRIM (s.SECTION_SEQ), '0'),
                                             '0',
                                             'panh',
                                                TO_CHAR (SYSDATE, 'YYYY-MM-DD')
                                             || 'T'
                                             || TO_CHAR (SYSDATE, 'HH24:MI:SS'),
                                             TRIM (s.SECTION_new),
                                             TRIM (s.SECTION_new),
                                             CAST (
                                                 MULTISET (
                                                       SELECT MATRIX_GROUP_NAME,
                                                              MATRIX_RANK,
                                                              'false',
                                                              TRIM (
                                                                  q.section_Q_seq),
                                                                 TO_CHAR (
                                                                     SYSDATE,
                                                                     'YYYY-MM-DD')
                                                              || 'T'
                                                              || TO_CHAR (
                                                                     SYSDATE,
                                                                     'HH24:MI:SS'),
                                                              UTL_I18N.UNESCAPE_REFERENCE (
                                                                  TRIM (
                                                                      q.form_question)),
                                                              REDCAP_INSTRUCTIONS_T (
                                                                  SUBSTR (
                                                                      TRIM (
                                                                          UTL_I18N.UNESCAPE_REFERENCE (
                                                                              NVL (
                                                                                  q.INSTRUCTIONS,
                                                                                  'N/A'))),
                                                                      1,
                                                                      550)),
                                                              'No',
                                                              NVL (
                                                                  TRIM (q.REQUIRED),
                                                                  'No'),
                                                              'No',
                                                              CAST (
                                                                  MULTISET (
                                                                        SELECT TRIM (
                                                                                   VAL_ORDER),
                                                                               TRIM (
                                                                                   VAL_name),
                                                                               TRIM (
                                                                                   VAL_VALUE),
                                                                               CASE q.FIELD_TYPE
                                                                                   WHEN 'calc'
                                                                                   THEN
                                                                                          'Calculation: '
                                                                                       || TRIM (
                                                                                              VAL_VALUE)
                                                                                   ELSE
                                                                                       TRIM (
                                                                                           VAL_VALUE)
                                                                               END
                                                                          FROM REDCAP_VALUE_CODE_751
                                                                               u
                                                                         WHERE     u.question(+) =
                                                                                   q.question
                                                                               AND u.protocol(+) =
                                                                                   q.protocol
                                                                      ORDER BY VAL_ORDER)
                                                                      AS REDCAP_validValue_LIST_T)
                                                                  "ValidValue"
                                                         FROM MDSR_REDCAP_PROTOCOL_CSV
                                                              q
                                                        WHERE     q.protocol =
                                                                  s.protocol
                                                              AND s.SECTION_SEQ =
                                                                  q.SECTION_SEQ
                                                     ORDER BY q.section_Q_seq)
                                                     AS REDCAP_QUESTION_LIST_T)
                                                 "Question"
                                        FROM MSDREDCAP_SECTION_CSV s
                                       WHERE p.protocol = s.protocol(+)
                                    ORDER BY s.SECTION_SEQ)
                                    AS REDCAP_SECTION_LIST_T),
                            REDCAP_PROTOCOL_T (
                                TRIM (pe.protocol_id),
                                UTL_I18N.UNESCAPE_REFERENCE (TRIM (long_name)),
                                'PhenX',
                                TRIM (pe.preferred_name),
                                UTL_I18N.UNESCAPE_REFERENCE (
                                    NVL (TRIM (pe.preferred_definition),
                                         'The Protocol is Not Found')))
                                AS "form"
                       FROM (SELECT DISTINCT protocol,
                                             form_name_new,
                                             preferred_definition,
                                             INSTRUCTIONS
                               FROM MSDRDEV.MSDREDCAP_FORM_CSV) p,
                            MSDRDEV.REDCAP_XML_GROUP_CSV_VW g,
                            sbrext.protocols_ext           pe
                      WHERE     p.protocol = g.protocol
                            AND pe.preferred_name = p.protocol
                            AND g.GROUP_NUMBER = v.GROUP_NUMBER
                   ORDER BY p.protocol, form_name_new)
                   AS MSDRDEV.REDCAP_FORM_LIST_T)    AS "group"
      FROM REDCOP_PR_GROUP_CSV_VW v;


DROP VIEW MSDRDEV.REDCAP_XML_GROUP_CSV_VW;

/* Formatted on 4/24/2019 2:32:57 PM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW MSDRDEV.REDCAP_XML_GROUP_CSV_VW
(
    QUEST_SUM,
    PROTOCOL,
    GROUP_NUMBER
)
AS
      SELECT quest_sum,
             PROTOCOL,                                       --form_name_new ,
             CASE
                 WHEN quest_sum < 6 THEN 1
                 WHEN quest_sum >= 6 AND quest_sum <= 14 THEN 2
                 WHEN quest_sum >= 14 AND quest_sum <= 24 THEN 3
                 WHEN quest_sum > 24 AND quest_sum <= 38 THEN 4
                 WHEN quest_sum > 38 AND quest_sum <= 53 THEN 5
                 WHEN quest_sum > 53 AND quest_sum <= 100 THEN 6
                 WHEN quest_sum > 100 AND quest_sum <= 160 THEN 7
                 WHEN quest_sum > 160 AND quest_sum <= 240 THEN 8
                 WHEN quest_sum > 210 THEN 9
             END    group_number
        FROM (  SELECT COUNT (*) quest_sum, PROTOCOL, form_name_new
                  FROM MDSR_REDCAP_PROTOCOL_CSV
                 WHERE protocol NOT LIKE 'Instr%'
              GROUP BY PROTOCOL, form_name_new)
    ORDER BY 1, 2;


DROP VIEW MSDRDEV.REDCOP_PR_GROUP_CSV_VW;

/* Formatted on 4/24/2019 2:32:57 PM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW MSDRDEV.REDCOP_PR_GROUP_CSV_VW
(
    GROUP_NUMBER,
    PROTOCOLS
)
AS
      SELECT group_number,
             LISTAGG (protocol, ',') WITHIN GROUP (ORDER BY protocol)    protocols
        FROM REDCAP_XML_GROUP_CSV_VW
    GROUP BY group_number;
