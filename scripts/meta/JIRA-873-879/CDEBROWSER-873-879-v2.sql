set serveroutput on size 1000000
SPOOL CDEBROWSER-879.log
CREATE OR REPLACE package SBREXT.MDSR_CDEBROWSER is

FUNCTION get_concept_order(p_condr_idseq in varchar2) return varchar2;
end MDSR_CDEBROWSER;
/
CREATE OR REPLACE package body SBREXT.MDSR_CDEBROWSER is

 Function get_concept_order(p_condr_idseq in varchar2) return varchar2 is

cursor con is
select display_order
from sbrext.component_Concepts_ext m, sbrext.concepts_ext c
where condr_idseq = p_condr_idseq
and m.con_idseq = c.con_idseq
order by display_order desc;
v_order_sq varchar2(4000):= null;

begin

for c_rec in con loop

if v_order_sq is null then
  v_order_sq := c_rec.display_order;
 
else
   v_order_sq := v_order_sq||','||c_rec.display_order;

end if;

end loop;

return v_order_sq;

end get_concept_order;
end MDSR_CDEBROWSER;
/
CREATE OR REPLACE PUBLIC SYNONYM MDSR_CDEBROWSER FOR SBREXT.MDSR_CDEBROWSER
/
GRANT EXECUTE,DEBUG ON SBREXT.MDSR_CDEBROWSER TO APPLICATION_USER
/
GRANT EXECUTE,DEBUG ON SBREXT.MDSR_CDEBROWSER TO CDEBROWSER
/
GRANT EXECUTE,DEBUG ON SBREXT.MDSR_CDEBROWSER TO DATA_LOADER
/
GRANT EXECUTE,DEBUG ON SBREXT.MDSR_CDEBROWSER TO SBR
/
GRANT EXECUTE,DEBUG ON SBREXT.MDSR_CDEBROWSER TO READONLY
/
GRANT EXECUTE,DEBUG ON SBREXT.sbrext_common_routines TO READONLY
/
CREATE OR REPLACE  TYPE  SBREXT.DE_VALID_VALUE_T_MDSR   as object(
    ValidValue varchar2(255),
    ValueMeaning varchar2(255),
    MeaningDescription varchar2(2000),
    MeaningConcepts varchar2(2000),
    MeaningConceptOrigin               varchar2(2000),
	MeaningConceptDisplayOrder varchar2(2000),
    PvBeginDate Date,
    PvEndDate Date,
    VmPublicId Number,
    VmVersion Number(4,2))
/    
CREATE OR REPLACE TYPE SBREXT.DE_VALID_VALUE_LIST_T_MDSR as table of DE_VALID_VALUE_T_MDSR
/
 CREATE OR REPLACE TYPE   SBREXT.CDEBROWSER_VD_T_MDSR  AS OBJECT
( "PublicId"         NUMBER,
  "PreferredName"          VARCHAR2 (30),
  "PreferredDefinition"    VARCHAR2 (2000),
  "LongName"      VARCHAR2(255),
  "Version"                NUMBER (4,2),
  "WorkflowStatus"         VARCHAR2 (20),
  "ContextName"         VARCHAR2 (30),
  "ContextVersion"     NUMBER (4,2),
  "ConceptualDomain"    admin_component_with_id_ln_t,
  "Datatype"               VARCHAR2 (20),
  "ValueDomainType"        VARCHAR2 (50),
  "UnitOfMeasure"          VARCHAR2 (20),
  "DisplayFormat"          VARCHAR2 (20),
  "MaximumLength"          NUMBER (8),
  "MinimumLength"          NUMBER (8),
  "DecimalPlace"           NUMBER (2),
  "CharacterSetName"       VARCHAR2 (20),
  "MaximumValue"           VARCHAR2 (255),
  "MinimumValue"           VARCHAR2 (255),
  "Origin"    VARCHAR2(240),
  "Representation"    admin_component_with_con_t,
  "PermissibleValues"    DE_VALID_VALUE_LIST_T_MDSR,
  "ValueDomainConcepts"    Concepts_list_t
)
/
CREATE OR REPLACE PUBLIC SYNONYM DE_VALID_VALUE_T_MDSR FOR DE_VALID_VALUE_T_MDSR
/
CREATE OR REPLACE PUBLIC SYNONYM DE_VALID_VALUE_LIST_T_MDSR FOR DE_VALID_VALUE_LIST_T_MDSR
/
CREATE OR REPLACE PUBLIC SYNONYM CDEBROWSER_VD_T_MDSR FOR CDEBROWSER_VD_T_MDSR
/
GRANT EXECUTE, DEBUG ON DE_VALID_VALUE_T_MDSR TO CDEBROWSER
/
GRANT EXECUTE, DEBUG ON DE_VALID_VALUE_LIST_T_MDSR TO CDEBROWSER
/
GRANT EXECUTE, DEBUG ON CDEBROWSER_VD_T_MDSR TO CDEBROWSER
/
GRANT EXECUTE, DEBUG ON CDEBROWSER_VD_T_MDSR TO DER_USER
/
GRANT EXECUTE, DEBUG ON DE_VALID_VALUE_T_MDSR TO DER_USER
/
GRANT EXECUTE, DEBUG ON DE_VALID_VALUE_LIST_T_MDSR TO DER_USER
/
GRANT EXECUTE, DEBUG ON CDEBROWSER_VD_T_MDSR TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON DE_VALID_VALUE_T_MDSR TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON DE_VALID_VALUE_LIST_T_MDSR TO SBR WITH GRANT OPTION
/
GRANT EXECUTE, DEBUG ON SBREXT.CDEBROWSER_VD_T_MDSR TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.DE_VALID_VALUE_T_MDSR TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.DE_VALID_VALUE_LIST_T_MDSR TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.ADMIN_COMPONENT_WITH_ID_LN_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.ADMIN_COMPONENT_WITH_CON_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.ADMIN_COMPONENT_WITH_ID_T to READONLY 
/
GRANT EXECUTE, DEBUG ON SBREXT.CDEBROWSER_DEC_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.DERIVED_DATA_ELEMENT_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.CONCEPT_DETAIL_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.CONCEPTS_LIST_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.CDEBROWSER_ALTNAME_T2 TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.CDEBROWSER_ALTNAME_LIST_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.CDEBROWSER_CSI_T TO READONLY
/    
GRANT EXECUTE, DEBUG ON SBREXT.CDEBROWSER_CSI_LIST_T TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.data_element_derivation_t TO READONLY
/
GRANT EXECUTE, DEBUG ON SBREXT.DATA_ELEMENT_DERIVATION_LIST_T TO READONLY
/                                     
GRANT EXECUTE, DEBUG ON SBREXT.CDEBROWSER_RD_T TO READONLY  
/ 
GRANT EXECUTE, DEBUG ON SBREXT.CDEBROWSER_RD_LIST_T TO READONLY 
/
GRANT EXECUTE, DEBUG ON SBREXT.CDEBROWSER_CSI_T to READONLY 
/
GRANT EXECUTE, DEBUG ON SBREXT.CDEBROWSER_CSI_LIST_T to READONLY 
/ 
CREATE OR REPLACE SYNONYM READONLY.CDEBROWSER_COMPLEX_DE_VIEW FOR CDEBROWSER_COMPLEX_DE_VIEW
/
GRANT SELECT ON CDEBROWSER_COMPLEX_DE_VIEW TO READONLY
/
CREATE OR REPLACE FORCE VIEW SBREXT.DE_CDE1_XML_GENERATOR_VIEW (DE_IDSEQ, PUBLICID, LONGNAME, PREFERREDNAME, PREFERREDDEFINITION, VERSION, WORKFLOWSTATUS, CONTEXTNAME, CONTEXTVERSION, ORIGIN, REGISTRATIONSTATUS, DATAELEMENTCONCEPT, VALUEDOMAIN, REFERENCEDOCUMENTSLIST, CLASSIFICATIONSLIST, ALTERNATENAMELIST, DATAELEMENTDERIVATION) AS 
  SELECT   de.de_idseq,
            de.CDE_ID "PublicId",
            de.long_name "LongName",
            de.preferred_name "PreferredName",
            de.preferred_definition "PreferredDefinition",
            de.version "Version",
            de.ASL_NAME "WorkflowStatus",
            de_conte.name "ContextName",
            de_conte.version "ContextVersion",
            de.origin "Origin",
            ar.registration_status "RegistrationStatus",
            cdebrowser_dec_t (
               dec.dec_id,
               dec.dec_preferred_name,
               dec.PREFERRED_DEFINITION,
               dec.dec_long_name,
               dec.dec_version,
               dec.ASL_NAME,
               dec.dec_context_name,
               dec.dec_context_version,
               admin_component_with_id_ln_t (dec.cd_id,
                                             dec.cd_context_name,
                                             dec.cd_context_version,
                                             dec.cd_preferred_name,
                                             dec.cd_version,
                                             dec.cd_long_name),
               admin_component_with_con_t (
                  dec.oc_id,
                  dec.oc_context_name,
                  dec.oc_context_version,
                  dec.oc_preferred_name,
                  dec.oc_version,
                  dec.oc_long_name,
                  CAST (
                     MULTISET(  SELECT   con.preferred_name,
                                         con.long_name,
                                         con.con_id,
                                         con.definition_source,
                                         con.origin,
                                         con.evs_Source,
                                         com.primary_flag_ind,
                                         com.display_order
                                  FROM   sbrext.component_concepts_ext com,
                                         sbrext.concepts_ext con
                                 WHERE   dec.oc_condr_idseq =
                                            com.condr_IDSEQ(+)
                                         AND com.con_idseq = con.con_idseq(+)
                              ORDER BY   display_order DESC) AS Concepts_list_t
                  )
               ),
               admin_component_with_con_t (
                  dec.prop_id,
                  dec.pt_context_name,
                  dec.pt_context_version,
                  dec.pt_preferred_name,
                  dec.pt_version,
                  dec.pt_long_name,
                  CAST (
                     MULTISET(  SELECT   con.preferred_name,
                                         con.long_name,
                                         con.con_id,
                                         con.definition_source,
                                         con.origin,
                                         con.evs_Source,
                                         com.primary_flag_ind,
                                         com.display_order
                                  FROM   sbrext.component_concepts_ext com,
                                         sbrext.concepts_ext con
                                 WHERE   dec.prop_condr_idseq =
                                            com.condr_IDSEQ(+)
                                         AND com.con_idseq = con.con_idseq(+)
                              ORDER BY   display_order DESC) AS Concepts_list_t
                  )
               ),
               dec.obj_class_qualifier,
               dec.property_qualifier,
               dec.dec_origin
            )
               "DataElementConcept",
            CDEBROWSER_VD_T_MDSR (
               vd.vd_id,
               vd.preferred_name,
               vd.preferred_definition,
               vd.long_name,
               vd.version,
               vd.asl_name,
               vd_conte.name,
               vd_conte.version,
               admin_component_with_id_ln_T (cd.cd_id,
                                             cd_conte.name,
                                             cd_conte.version,
                                             cd.preferred_name,
                                             cd.version,
                                             cd.long_name),
               vd.dtl_name,
               DECODE (vd.vd_type_flag,
                       'E',
                       'Enumerated',
                       'N',
                       'NonEnumerated'),
               vd.uoml_name,
               vd.forml_name,
               vd.max_length_num,
               vd.min_length_num,
               vd.decimal_place,
               vd.char_set_name,
               vd.high_value_num,
               vd.low_value_num,
               vd.origin,
               admin_component_with_con_t (
                  rep.rep_id,
                  rep_conte.name,
                  rep_conte.version,
                  rep.preferred_name,
                  rep.version,
                  rep.long_name,
                  CAST (
                     MULTISET(  SELECT   con.preferred_name,
                                         con.long_name,
                                         con.con_id,
                                         con.definition_source,
                                         con.origin,
                                         con.evs_Source,
                                         com.primary_flag_ind,
                                         com.display_order
                                  FROM   sbrext.component_concepts_ext com,
                                         sbrext.concepts_ext con
                                 WHERE   rep.condr_idseq = com.condr_IDSEQ(+)
                                         AND com.con_idseq = con.con_idseq(+)
                              ORDER BY   display_order DESC) AS Concepts_list_t
                  )
               ),
               CAST (
                  MULTISET(SELECT   pv.VALUE,
                                    pv.short_meaning,
                                    vm.preferred_definition,
                                    SBREXT.sbrext_common_routines.get_concepts (
                                       vm.condr_idseq
                                    )
                                       MeaningConcepts,
                                    replace(SBREXT.sbrext_common_routines.get_condr_origin (
                                       vm.condr_idseq
                                    ),':',',')
                                       MeaningConceptOrigin,
                                    SBREXT.MDSR_CDEBROWSER.get_concept_order(
                                       vm.condr_idseq
                                    )
                                       MeaningConceptDisplayOrder,
                                    vp.begin_date,
                                    vp.end_date,
                                    vm.vm_id,
                                    vm.version
                             FROM   sbr.permissible_values pv,
                                    sbr.vd_pvs vp,
                                    sbr.value_meanings vm
                            WHERE       vp.vd_idseq = vd.vd_idseq
                                    AND vp.pv_idseq = pv.pv_idseq
                                    AND pv.vm_idseq = vm.vm_idseq) AS DE_VALID_VALUE_LIST_T_MDSR
               ),
               CAST (
                  MULTISET(  SELECT   con.preferred_name,
                                      con.long_name,
                                      con.con_id,
                                      con.definition_source,
                                      con.origin,
                                      con.evs_Source,
                                      com.primary_flag_ind,
                                      com.display_order
                               FROM   sbrext.component_concepts_ext com,
                                      sbrext.concepts_ext con
                              WHERE   vd.condr_idseq = com.condr_IDSEQ(+)
                                      AND com.con_idseq = con.con_idseq(+)
                           ORDER BY   display_order DESC) AS Concepts_list_t
               )
            )
               "ValueDomain",
            CAST (
               MULTISET(SELECT   rd.name,
                                 org.name,
                                 rd.DCTL_NAME,
                                 rd.doc_text,
                                 rd.URL,
                                 rd.lae_name,
                                 rd.display_order
                          FROM   sbr.reference_documents rd,
                                 sbr.organizations org
                         WHERE   de.de_idseq = rd.ac_idseq
                                 AND rd.ORG_IDSEQ = org.ORG_IDSEQ(+)) AS cdebrowser_rd_list_t
            )
               "ReferenceDocumentsList",
            CAST (
               MULTISET (
                  SELECT   admin_component_with_id_t (csv.cs_id,
                                                      csv.cs_context_name,
                                                      csv.cs_context_version,
                                                      csv.preferred_name,
                                                      csv.version),
                           csv.csi_name,
                           csv.csitl_name,
                           csv.csi_id,
                           csv.csi_version
                    FROM   sbrext.cdebrowser_cs_view csv
                   WHERE   de.de_idseq = csv.ac_idseq
               ) AS cdebrowser_csi_list_t
            )
               "ClassificationsList",
            CAST (
               MULTISET(SELECT   des_conte.name,
                                 des_conte.version,
                                 des.name,
                                 des.detl_name,
                                 des.lae_name
                          FROM   sbr.designations des, sbr.contexts des_conte
                         WHERE   de.de_idseq = des.AC_IDSEQ(+)
                                 AND des.conte_idseq =
                                       des_conte.conte_idseq(+)) AS cdebrowser_altname_list_t
            )
               "AlternateNameList",
            derived_data_element_t (ccd.crtl_name,
                                    ccd.description,
                                    ccd.methods,
                                    ccd.rule,
                                    ccd.concat_char,
                                    "DataElementsList")
               "DataElementDerivation"
     FROM   sbr.data_elements de,
            sbrext.cdebrowser_de_dec_view dec,
            sbr.contexts de_conte,
            sbr.value_domains vd,
            sbr.contexts vd_conte,
            sbr.contexts cd_conte,
            sbr.conceptual_domains cd,
            sbr.ac_registrations ar,
            sbrext.cdebrowser_complex_de_view ccd,
            sbrext.representations_ext rep,
            sbr.contexts rep_conte
    WHERE       de.de_idseq = dec.de_idseq
            AND de.conte_idseq = de_conte.conte_idseq
            AND de.vd_idseq = vd.vd_idseq
            AND vd.conte_idseq = vd_conte.conte_idseq
            AND vd.cd_idseq = cd.cd_idseq
            AND cd.conte_idseq = cd_conte.conte_idseq
            AND de.de_idseq = ar.ac_idseq(+)
            AND de.de_idseq = ccd.p_de_idseq(+)
            AND vd.rep_idseq = rep.rep_idseq(+)
            AND rep.conte_idseq = rep_conte.conte_idseq(+)
/
CREATE OR REPLACE SYNONYM UMLLOADER_COOPERM.DE_CDE1_XML_GENERATOR_VIEW FOR DE_CDE1_XML_GENERATOR_VIEW
/
CREATE OR REPLACE SYNONYM CDEBROWSER.DE_CDE1_XML_GENERATOR_VIEW FOR DE_CDE1_XML_GENERATOR_VIEW
/
CREATE OR REPLACE SYNONYM SBR.DE_CDE1_XML_GENERATOR_VIEW FOR DE_CDE1_XML_GENERATOR_VIEW
/
CREATE OR REPLACE SYNONYM READONLY.DE_CDE1_XML_GENERATOR_VIEW FOR DE_CDE1_XML_GENERATOR_VIEW
/
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DE_CDE1_XML_GENERATOR_VIEW TO CDEBROWSER
/
GRANT DELETE, INSERT, SELECT, UPDATE ON DE_CDE1_XML_GENERATOR_VIEW TO DER_USER
/
GRANT SELECT ON DE_CDE1_XML_GENERATOR_VIEW TO UMLLOADER_COOPERM
/
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DE_CDE1_XML_GENERATOR_VIEW TO SBR WITH GRANT OPTION
/
GRANT SELECT ON DE_CDE1_XML_GENERATOR_VIEW TO READONLY
/
SPOOL OFF
