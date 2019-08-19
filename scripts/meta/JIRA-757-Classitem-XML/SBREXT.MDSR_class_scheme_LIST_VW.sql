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