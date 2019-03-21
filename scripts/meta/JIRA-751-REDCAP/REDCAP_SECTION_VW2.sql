DROP VIEW MSDRDEV.REDCAP_SECTION_VW2;

/* Formatted on 3/20/2019 8:09:36 PM (QP5 v5.336) */
CREATE OR REPLACE FORCE VIEW MSDRDEV.REDCAP_SECTION_VW2
(
    PROTOCOL,
    QUESTION
)
AS
    SELECT DISTINCT p.protocol PROTOCOL, p.QUESTION
      FROM REDCAP_PROTOCOL_TEST  p
           LEFT OUTER JOIN REDCAP_SECTION_new s
               ON     p.protocol = s.protocol
                  AND p.QUESTION = s.QUESTION
                  AND p.SECTION IS NOT NULL
     WHERE s.protocol || s.QUESTION IS NULL;
