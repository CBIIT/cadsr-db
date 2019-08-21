set serveroutput on size 1000000
SPOOL cadsrmeta-757.log  

CREATE OR REPLACE VIEW SBREXT.MDSR_class_scheme_ITEM_VW
(
    CS_IDSEQ,
    PREFERRED_NAME,
    LONG_NAME,
    PREFERRED_DEFINITION,
    VERSION,
    ASL_NAME,
    CS_CONTEXT_NAME,
    CS_CONTEXT_VERSION,
    CSI_NAME,
    CSITL_NAME,
    DESCRIPTION,
    CSI_ID,
    CSI_VERSION,
    CSI_CONTEXT_NAME,
    CS_ID
)
as 
(SELECT     cs.cs_idseq,
            cs.preferred_name,
            cs.long_name,
            cs.preferred_definition,
            cs.version,
            cs.asl_name,
            cs_conte.name                cs_context_name,
            cs_conte.version             cs_context_version,
            csi.long_name                csi_name,
            csi.csitl_name,
            csi.preferred_definition     description,
            csi.csi_id,
            csi.version                  csi_version,
            csi_conte.name               csi_context_name,
            cs.cs_id
       FROM sbr.classification_schemes  cs,
            sbr.cs_items                csi,
            sbr.cs_csi                  csc,           
            sbr.contexts                cs_conte,
            sbr.contexts                csi_conte            
      WHERE csc.cs_idseq = cs.cs_idseq
            AND csc.csi_idseq = csi.csi_idseq
            AND cs.conte_idseq = cs_conte.conte_idseq
            AND csi.conte_idseq = csi_conte.conte_idseq
            AND csi_conte.name not in ('TEST','Training')
            AND cs_conte.name not in ('TEST','Training')          
            AND cs.ASL_NAME='RELEASED'
            )
/
 CREATE OR REPLACE   VIEW SBREXT.MDSR_class_scheme_LIST_VW
 as select  CAST (
               MULTISET (
                   SELECT admin_component_with_id_t (csv.cs_id,
                                                     csv.cs_context_name,
                                                     csv.cs_context_version,
                                                     csv.preferred_name,
                                                     csv.version),
                          csv.csi_name,
                          csv.csitl_name,
                          csv.csi_id,
                          csv.csi_version
                     FROM SBREXT.MDSR_class_scheme_ITEM_VW csv
                    WHERE a.cs_idseq = csv.cs_idseq)
                   AS cdebrowser_csi_list_t)
               "ClassificationsList"
               from
               (select distinct cs_id,version,preferred_name,cs_idseq
               from SBREXT.MDSR_class_scheme_ITEM_VW
               order by preferred_name,cs_id) a
/
GRANT SELECT ON  SBREXT.MDSR_class_scheme_LIST_VW TO CDEBROWSER
/
GRANT  SELECT ON  SBREXT.MDSR_class_scheme_LIST_VW TO DER_USER
/
GRANT SELECT ON  SBREXT.MDSR_class_scheme_LIST_VW TO READONLY
/
GRANT SELECT ON  SBREXT.MDSR_class_scheme_LIST_VW TO GUEST
/
GRANT SELECT ON  SBREXT.MDSR_class_scheme_LIST_VW TO SBR WITH GRANT OPTION
/
GRANT SELECT ON  SBREXT.MDSR_class_scheme_ITEM_VW TO CDEBROWSER
/
GRANT  SELECT ON  SBREXT.MDSR_class_scheme_ITEM_VW TO DER_USER
/
GRANT SELECT ON  SBREXT.MDSR_class_scheme_ITEM_VW TO READONLY
/
GRANT SELECT ON  SBREXT.MDSR_class_scheme_ITEM_VW TO GUEST
/
GRANT SELECT ON  SBREXT.MDSR_class_scheme_ITEM_VW TO SBR WITH GRANT OPTION
/
SPOOL OFF