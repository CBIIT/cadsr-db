DROP VIEW SBREXT.MDSR_CONTEXT_GROUP_749_VW;

/* Formatted on 3/5/2019 5:14:09 PM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW SBREXT.MDSR_CONTEXT_GROUP_749_VW
(
    NAME,
    CONTE_IDSEQ,
    DE_IDSEQ,
    GROUP_NUMBER
)
AS
      SELECT c.name,
             c.CONTE_IDSEQ,
             de.DE_IDSEQ,
             CASE
                 WHEN     NAME = 'NCIP'
                      AND (   de.cde_id < 5473
                           OR (de.cde_id = 5473 AND de.version <= 9))
                 THEN
                     1
                 WHEN NAME = 'NCIP' AND de.cde_id = 5473 AND de.version > 9
                 THEN
                     2
                 WHEN     NAME = 'NCIP'
                      AND de.cde_id < = 2930271
                      AND de.cde_id > 5473
                 THEN
                     3
                 WHEN     NAME = 'NCIP'
                      AND de.cde_id > 2930271
                      AND de.cde_id < = 3371875
                 THEN
                     4
                 WHEN NAME = 'NCIP' AND de.cde_id > 3371875
                 THEN
                     5
                 WHEN NAME = 'CTEP' AND de.cde_id < 2180548
                 THEN
                     6
                 WHEN NAME = 'CTEP' AND de.cde_id >= 2180548
                 THEN
                     7
                 WHEN NAME = 'NCI Standards'
                 THEN
                     8
                 WHEN NAME = 'NHLBI' AND de.cde_id < 2978236
                 THEN
                     9
                 WHEN NAME = 'NHLBI' AND de.cde_id >= 2978236
                 THEN
                     10
                 WHEN NAME = 'caCORE'
                 THEN
                     11
                 WHEN NAME IN ('CCR', 'COG', 'NIDCR')
                 THEN
                     12
                 WHEN NAME IN ('Alliance', 'DCP', 'ECOG-ACRIN')
                 THEN
                     13
                 WHEN NAME IN ('BBRB',
                               'NRG',
                               'Theradex',
                               'PS-CC',
                               'SPOREs')
                 THEN
                     14
                 ELSE
                     15
             END    GROUP_NUMBER
        FROM sbr.contexts c, sbr.data_elements de
       WHERE     c.CONTE_IDSEQ = de.CONTE_IDSEQ
             AND de.ASL_NAME NOT IN ('%RETIRED WITHDRAWN%', 'RETIRED DELETED')
             AND c.NAME NOT IN ('TEST', 'Training')
    ORDER BY GROUP_NUMBER;


DROP VIEW SBREXT.MDSR_DE_XML_749_VW;

/* Formatted on 3/5/2019 5:14:09 PM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW SBREXT.MDSR_DE_XML_749_VW
(
    GROUP_NUMBER,
    "DataElementList"
)
AS
    SELECT a.GROUP_NUMBER,
           CAST (
               MULTISET (
                     SELECT de.cde_id
                                CDEPublicID,
                            de.version
                                CDEVersion,
                            de.preferred_name
                                DataElementShortName,
                            de.long_name
                                DataElementLongName,
                            de_conte.name
                                DataElementContext,
                            de.ASL_NAME
                                DataElementStatus,
                            CAST (
                                MULTISET (
                                    SELECT des_conte.name,
                                           '',
                                           des.name,
                                           des.detl_name,
                                           des.lae_name
                                      FROM (SELECT *
                                              FROM sbr.designations
                                             WHERE DETL_NAME <>
                                                   'USED_BY') des,
                                           sbr.contexts des_conte
                                     WHERE     de.de_idseq =
                                               des.AC_IDSEQ(+)
                                           AND des.conte_idseq =
                                               des_conte.conte_idseq(+))
                                    AS MDSR_749_ALTERNATENAM_LIST_T)
                                "AlternateNameList",
                            CAST (
                                MULTISET (
                                    SELECT rd.name,
                                           rd.ORG_IDSEQ,
                                           rd.DCTL_NAME,
                                           rd.doc_text,
                                           rd.url,
                                           rd.LAE_NAME,
                                           rd.DISPLAY_ORDER
                                      FROM SBR.REFERENCE_DOCUMENTS rd
                                     WHERE     rd.ac_idseq(+) = de.de_idseq
                                           AND LOWER (rd.DCTL_NAME) LIKE
                                                   '%question text%')
                                    AS MDSR_749_REFERENCEDOC_LIST_T)
                                "ReferrenceDocumentList",
                            dec.dec_id,
                            dec.version
                                dec_version,
                            CAST (
                                MULTISET (
                                    SELECT vd.vd_id,
                                           vd.version,
                                           vd.long_name,
                                           vd.DTL_NAME,
                                           DECODE (vd.vd_type_flag,
                                                   'E', 'Enumerated',
                                                   'N', 'NonEnumerated',
                                                   NULL),
                                           CAST (
                                               MULTISET (
                                                   SELECT pv.VALUE,
                                                          vm.long_name
                                                              short_meaning,
                                                          vm.preferred_definition,
                                                          sbrext_common_routines.get_concepts (
                                                              vm.condr_idseq)
                                                              MeaningConcepts,
                                                          vm.vm_id,
                                                          vm.version,
                                                          CAST (
                                                              MULTISET (
                                                                  SELECT des_conte.name,
                                                                         NULL,
                                                                         des.name,
                                                                         des.detl_name,
                                                                         des.lae_name
                                                                    FROM (SELECT *
                                                                            FROM sbr.designations
                                                                           WHERE DETL_NAME <>
                                                                                 'USED_BY')
                                                                         des,
                                                                         sbr.contexts
                                                                         des_conte
                                                                   WHERE     vm.vm_idseq =
                                                                             des.AC_IDSEQ(+)
                                                                         AND des.conte_idseq =
                                                                             des_conte.conte_idseq(+))
                                                                  AS MDSR_749_ALTERNATENAM_LIST_T)
                                                              "AlternateNameList"
                                                     FROM sbr.permissible_values
                                                          pv,
                                                          sbr.vd_pvs    vp,
                                                          value_meanings vm
                                                    WHERE     vp.vd_idseq =
                                                              vd.vd_idseq
                                                          AND vp.pv_idseq =
                                                              pv.pv_idseq
                                                          AND pv.vm_idseq =
                                                              vm.vm_idseq)
                                                   AS MDSR_749_PVs_LIST_T)
                                               valid_values
                                      FROM sbr.value_domains vd
                                     WHERE vd.vd_idseq = de.vd_idseq)
                                    AS MDSR_749_ValueDomain_LIST_T)
                                "ValueDomain"
                       FROM (SELECT *
                               FROM sbr.data_elements
                              WHERE ASL_NAME NOT IN
                                        ('%RETIRED WITHDRAWN%',
                                         'RETIRED DELETED')) de,
                            sbrext.MDSR_CONTEXT_GROUP_749_VW de_conte,
                            SBR.DATA_ELEMENT_CONCEPTS       dec
                      WHERE     de.de_idseq = de_conte.de_idseq
                            AND de.dec_idseq = dec.dec_idseq(+)
                            AND de_conte.GROUP_NUMBER = a.GROUP_NUMBER --AND cde_id in('2529097','2768794','3147627','2974175','2768794')
                   ORDER BY de_conte.GROUP_NUMBER, cde_id, de.version)
                   AS MDSR_CDE_749_LIST_T)    "DataElementList"
      FROM (  SELECT DISTINCT GROUP_NUMBER
                FROM sbrext.MDSR_CONTEXT_GROUP_749_VW c
            --WHERE GROUP_NUMBER = 3
            ORDER BY GROUP_NUMBER) a;
