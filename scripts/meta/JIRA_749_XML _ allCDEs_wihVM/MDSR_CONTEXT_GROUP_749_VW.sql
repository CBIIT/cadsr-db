DROP VIEW SBREXT.MDSR_CONTEXT_GROUP_749_VW;

/* Formatted on 3/4/2019 5:05:19 PM (QP5 v5.336) */
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
                 WHEN NAME = 'NCIP' AND de.cde_id < 5473
                 THEN
                     1
                 WHEN NAME = 'NCIP' AND de.cde_id = 5473
                 THEN
                     2    
                 WHEN     NAME = 'NCIP'
                      AND de.cde_id < 2754246
                      AND de.cde_id > 5473
                 THEN
                     3
                 WHEN     NAME = 'NCIP'
                      AND de.cde_id >= 2754246
                      AND de.cde_id < 3191974
                 THEN
                     4
                 WHEN NAME = 'NCIP' AND de.cde_id >= 3191974
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
                 WHEN NAME = 'NHLBI'
                 THEN
                     9
                 WHEN NAME = 'NIDCR'
                 THEN
                     10
                 WHEN NAME IN ('CCR', 'COG', 'caCORE')
                 THEN
                     11
                 WHEN NAME IN ('Alliance', 'DCP', 'ECOG-ACRIN')
                 THEN
                     12
                 WHEN NAME IN ('BBRB',
                               'NRG',
                               'Theradex',
                               'PS-CC',
                               'SPOREs')
                 THEN
                     13
                 ELSE
                     14
             END    GROUP_NUMBER
        FROM sbr.contexts c, sbr.data_elements de
       WHERE     c.CONTE_IDSEQ = de.CONTE_IDSEQ
             AND de.ASL_NAME NOT IN ('%RETIRED WITHDRAWN%', 'RETIRED DELETED')
    ORDER BY GROUP_NUMBER;
