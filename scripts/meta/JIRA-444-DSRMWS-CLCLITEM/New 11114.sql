set serveroutput on size 1000000
SPOOL cadsrmeta-749c.log  

CREATE OR REPLACE TYPE MDSR_749_ALTERNATENAME_ITEM_T          as object(
"ContextName"                             VARCHAR2(30),
"ContextVersion"                        VARCHAR2(10),
"AlternateName"                                VARCHAR2(2000)
,"AlternateNameType"                                VARCHAR2(20)
,"Language"                        VARCHAR2(30)

)
/
CREATE OR REPLACE TYPE MDSR_749_ALTERNATENAM_LIST_T    as table of MDSR_749_ALTERNATENAME_ITEM_T
/

CREATE OR REPLACE TYPE MDSR_749_PV_VD_ITEM_T          as object(ValidValue varchar2(255),
    ValueMeaning varchar2(255),
    MeaningDescription varchar2(2000),
    MeaningConcepts varchar2(2000),
    MeaningConceptOrigin               varchar2(2000),
	  MeaningConceptDisplayOrder varchar2(2000),
    PvBeginDate Date,
    PvEndDate Date,
    VmPublicId Number,
    VmVersion Number(4,2),
    "ALTERNATENAMELIST"    MDSR_749_ALTERNATENAM_LIST_T)
 /   
CREATE OR REPLACE TYPE MDSR_749_PV_VD_LIST_T    as table of MDSR_749_PV_VD_ITEM_T
/
CREATE OR REPLACE TYPE MDSR_749_PV_VD_LIST_T  as table of MDSR_749_PV_VD_ITEM_T
/
CREATE OR REPLACE TYPE "CDEBROWSER_VD_T749"                                          AS OBJECT
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
  "PermissibleValues"     MDSR_749_PV_VD_LIST_T,
  "ValueDomainConcepts"    Concepts_list_t
);
/
DROP VIEW ONEDATA_WA.CDEBROWSER_COMPLEX_DE_VIEW_N;

/* Formatted on 9/25/2020 1:47:01 PM (QP5 v5.354) */
CREATE OR REPLACE FORCE VIEW ONEDATA_WA.CDEBROWSER_COMPLEX_DE_VIEW_N
(
    ITEM_ID,
    VER_NR,
    CRTL_NAME,
    DESCRIPTION,
    METHODS,
    RULE,
    CONCAT_CHAR,
    "DataElementsList"
)
BEQUEATH DEFINER
AS
    SELECT cde.ITEM_ID,
           cde.ver_NR,
           ctl.OBJ_KEY_DESC,
           ctl.OBJ_KEY_DEF,
           cde.DERV_MTHD,
           cde.DERV_RUL,
           cde.CONCAT_CHAR,
           CAST (
               MULTISET (
                   SELECT de.item_id,
                          de.ITEM_NM,
                          de.ITEM_LONG_NM,
                          de.ITEM_DESC,
                          de.VER_NR,
                          de.ADMIN_STUS_NM_DN,
                          de.CNTXT_NM_DN,
                          cdr.DISP_ORD
                     FROM NCI_ADMIN_ITEM_REL cdr, ADMIN_ITEM de
                    WHERE     cdr.C_ITEM_ID = de.ITEM_ID
                          --AND DE.ITEM_ID=2181785
                          AND cdr.C_ITEM_VER_NR = de.VER_NR
                          AND de.admin_item_typ_id = 4
                          AND cde.ITEM_ID = cdr.p_ITEM_ID(+)
                          AND cde.VER_NR = cdr.p_ITEM_VER_NR(+))
                   AS data_element_derivation_list_t)    "DataElementsList"
      FROM DE cde, OBJ_KEY ctl
     WHERE cde.DERV_TYP_ID = ctl.OBJ_KEY_ID AND ctl.OBJ_TYP_ID = 21;


DROP VIEW ONEDATA_WA.CDEBROWSER_CS_VIEW;

/* Formatted on 9/25/2020 1:47:01 PM (QP5 v5.354) */
CREATE OR REPLACE FORCE VIEW ONEDATA_WA.CDEBROWSER_CS_VIEW
(
    DE_ITEM_ID,
    DE_VER_NR,
    CS_ITEM_ID,
    CS_ITEM_NM,
    CS_ITEM_LONG_NM,
    CS_PREF_DEF,
    CS_VER_NR,
    CS_ADMIN_STUS,
    CS_CNTXT_NM,
    CS_CNTXT_VER_NR,
    CSI_LONG_NM,
    CSI_PREF_DEF,
    CSI_ITEM_ID,
    CSI_VER_NR,
    CSI_ITEM_NM
)
BEQUEATH DEFINER
AS
    SELECT ac_csi.c_item_id         de_item_id,
           ac_csi.c_item_ver_nr     de_ver_nr,
           cs.item_id               cs_item_id,
           cs.item_nm               cs_item_nm,
           cs.item_long_nm          cs_item_long_nm,
           cs.item_desc             cs_pref_def,
           cs.ver_nr                cs_ver_nr,
           cs.admin_stus_nm_dn      cs_admin_stus,
           cs.cntxt_nm_dn           cs_cntxt_nm,
           cs.cntxt_ver_nr          cs_cntxt_ver_nr,
           csi.item_long_nm         csi_long_nm--,csi.csitl_name
                                               ,
           csi.item_desc            csi_pref_def,
           csi.item_id              csi_item_id,
           csi.ver_nr               csi_ver_nr,
           csi.item_nm              csi_item_nm
      FROM admin_item                  cs,
           NCI_ADMIN_ITEM_REL_ALT_KEY  cs_csi,
           ADMIN_ITEM                  csi,
           NCI_ALT_KEY_ADMIN_ITEM_REL  ac_csi
     WHERE     cs.item_id = cs_csi.CNTXT_CS_ITEM_ID
           AND cs.ver_nr = cs_csi.CNTXT_CS_VER_NR
           AND csi.item_id = cs_csi.c_item_id
           AND csi.ver_nr = cs_csi.c_item_ver_nr
           AND cs_csi.nci_pub_id = ac_csi.nci_pub_id
           AND cs_csi.nci_ver_nr = ac_csi.nci_ver_nr;


DROP VIEW ONEDATA_WA.CDEBROWSER_CS_VIEW_N;

/* Formatted on 9/25/2020 1:47:01 PM (QP5 v5.354) */
CREATE OR REPLACE FORCE VIEW ONEDATA_WA.CDEBROWSER_CS_VIEW_N
(
    DE_ITEM_ID,
    DE_VER_NR,
    CS_ITEM_ID,
    CS_ITEM_NM,
    CS_ITEM_LONG_NM,
    CS_PREF_DEF,
    CS_VER_NR,
    CS_ADMIN_STUS,
    CS_CNTXT_NM,
    CS_CNTXT_VER_NR,
    CSI_LONG_NM,
    CSITL_NM,
    CSI_PREF_DEF,
    CSI_ITEM_ID,
    CSI_VER_NR,
    CSI_ITEM_NM
)
BEQUEATH DEFINER
AS
    SELECT ac_csi.c_item_id         de_item_id,
           ac_csi.c_item_ver_nr     de_ver_nr,
           cs.item_id               cs_item_id,
           cs.item_nm               cs_item_nm,
           cs.item_long_nm          cs_item_long_nm,
           cs.item_desc             cs_pref_def,
           cs.ver_nr                cs_ver_nr,
           cs.admin_stus_nm_dn      cs_admin_stus,
           cs.cntxt_nm_dn           cs_cntxt_nm,
           cs.cntxt_ver_nr          cs_cntxt_ver_nr,
           csi.item_long_nm         csi_long_nm,
           o.NCI_CD                 csitl_nm,
           csi.item_desc            csi_pref_def,
           csi.item_id              csi_item_id,
           csi.ver_nr               csi_ver_nr,
           csi.item_nm              csi_item_nm
      FROM admin_item                  cs,
           NCI_ADMIN_ITEM_REL_ALT_KEY  cs_csi,
           ADMIN_ITEM                  csi,
           NCI_ALT_KEY_ADMIN_ITEM_REL  ac_csi,
           OBJ_KEY                     o,
           NCI_CLSFCTN_SCHM_ITEM       ncsi
     WHERE     cs.item_id = cs_csi.CNTXT_CS_ITEM_ID
           AND cs.ver_nr = cs_csi.CNTXT_CS_VER_NR
           AND csi.item_id = cs_csi.c_item_id
           AND csi.ver_nr = cs_csi.c_item_ver_nr
           AND cs_csi.nci_pub_id = ac_csi.nci_pub_id
           AND cs_csi.nci_ver_nr = ac_csi.nci_ver_nr
           AND csi.item_id = ncsi.item_id
           AND csi.ver_nr = ncsi.ver_nr
           AND ncsi.CSI_TYP_ID = o.obj_key_id;


DROP VIEW ONEDATA_WA.CDEBROWSER_DE_DEC_VIEW;

/* Formatted on 9/25/2020 1:47:01 PM (QP5 v5.354) */
CREATE OR REPLACE FORCE VIEW ONEDATA_WA.CDEBROWSER_DE_DEC_VIEW
(
    DE_ID,
    DE_VERSION,
    DEC_PREFERRED_NAME,
    DEC_LONG_NAME,
    PREFERRED_DEFINITION,
    DEC_VERSION,
    ASL_NAME,
    DEC_CONTEXT_NAME,
    DEC_CONTEXT_VERSION,
    OC_PREFERRED_NAME,
    OC_VERSION,
    OC_LONG_NAME,
    OC_CONTEXT_NAME,
    OC_CONTEXT_VERSION,
    PT_PREFERRED_NAME,
    PT_VERSION,
    PT_LONG_NAME,
    PT_CONTEXT_NAME,
    PT_CONTEXT_VERSION,
    CD_PREFERRED_NAME,
    CD_VERSION,
    CD_LONG_NAME,
    CD_CONTEXT_NAME,
    CD_CONTEXT_VERSION,
    OBJ_CLASS_QUALIFIER,
    PROPERTY_QUALIFIER,
    OC_ID,
    PROP_ID,
    CD_ID,
    DEC_ID,
    DEC_ORIGIN,
    OC_IDSEQ,
    PROP_IDSEQ,
    OC_CONDR_IDSEQ,
    PROP_CONDR_IDSEQ
)
BEQUEATH DEFINER
AS
    SELECT de.item_id               de_id,
           de.ver_nr                de_version,
           dec.ITEM_NM              dec_preferred_name,
           dec.ITEM_LONG_NM         dec_long_name,
           dec.ITEM_DESC            PREFERRED_DEFINITION,
           dec.ver_nr               dec_version,
           dec.admin_stus_nm_dn     ASL_NAME,
           dec.CNTXT_NM_DN          dec_context_name,
           dec.CNTXT_ver_NR         dec_context_version,
           oc.ITEM_NM               oc_preferred_name,
           oc.VER_NR                oc_version,
           oc.ITEM_LONG_NM          oc_long_name,
           oc.CNTXT_NM_DN           oc_context_name,
           oc.ver_NR                oc_context_version,
           pt.ITEM_NM               pt_preferred_name,
           pt.ver_NR                pt_version,
           pt.item_long_nm          pt_long_name,
           pt.CNTXT_NM_DN           pt_context_name,
           pt.cntxt_VER_NR          pt_context_version,
           cd.ITEM_NM               cd_preferred_name,
           cd.ver_NR                cd_version,
           cd.ITEM_LONG_NM          cd_long_name,
           cd.CNTXT_NM_DN           cd_context_name,
           cd.cntxt_ver_NR          cd_context_version,
           de_conc.obj_cls_qual     obj_class_qualifier,
           de_conc.prop_qual        property_qualifier,
           oc.item_id               oc_id,
           pt.item_id               prop_id,
           cd.item_id               cd_id,
           dec.item_id              dec_id,
           dec.origin               dec_origin,
           oc.nci_idseq             oc_idseq,
           pt.nci_idseq             prop_idseq,
           oc.nci_idseq             oc_condr_idseq,
           pt.nci_idseq             prop_condr_idseq
      FROM DE          de,
           ADMIN_ITEM  dec,
           DE_CONC     de_conc,
           ADMIN_ITEM  oc,
           ADMIN_ITEM  pt,
           ADMIN_ITEM  cd
     WHERE     de.de_conc_item_id = dec.item_id
           AND dec.item_id = de_conc.item_id
           AND dec.ver_nr = de_conc.ver_nr
           AND de_conc.obj_cls_item_id = oc.item_id
           AND de_conc.prop_item_id = pt.item_id
           AND de_conc.conc_dom_item_id = cd.item_id
           AND de.de_conc_ver_nr = dec.ver_nr
           AND de_conc.obj_cls_ver_nr = oc.ver_nr
           AND de_conc.prop_ver_nr = pt.ver_nr
           AND de_conc.conc_dom_ver_nr = cd.ver_nr
           AND dec.admin_item_typ_id = 2
           AND oc.admin_item_typ_id = 5
           AND pt.admin_item_typ_id = 6
           AND cd.admin_item_typ_id = 1;


DROP VIEW ONEDATA_WA.DE_CDE1_XML_GENERATOR_749VW;

/* Formatted on 9/25/2020 1:47:01 PM (QP5 v5.354) */
CREATE OR REPLACE FORCE VIEW ONEDATA_WA.DE_CDE1_XML_GENERATOR_749VW
(
    RAI,
    PUBLICID,
    LONGNAME,
    PREFERREDNAME,
    PREFERREDDEFINITION,
    VERSION,
    WORKFLOWSTATUS,
    CONTEXTNAME,
    CONTEXTVERSION,
    ORIGIN,
    REGISTRATIONSTATUS,
    "dateModified",
    DATAELEMENTCONCEPT,
    VALUEDOMAIN,
    REFERENCEDOCUMENTSLIST,
    CLASSIFICATIONSLIST,
    ALTERNATENAMELIST,
    DATAELEMENTDERIVATION
)
BEQUEATH DEFINER
AS
    SELECT                                                     ---de.de_idseq,
           '2.16.840.1.113883.3.26.2'                     "RAI",
           ai.ITEM_ID                                     "PublicId",
           ai.ITEM_LONG_NM                                "LongName",
           ai.ITEM_NM                                     "PreferredName",
           ai.ITEM_DESC                                   "PreferredDefinition",
           ai.VER_NR                                      "Version",
           ai.ADMIN_STUS_NM_DN                            "WorkflowStatus",
           ai.CNTXT_NM_DN                                 "ContextName",
           ai.CNTXT_VER_NR                                "ContextVersion",
           NVL (ai.origin, ai.ORIGIN_ID_DN)               "Origin",
           ai.REGSTR_STUS_NM_DN                           "RegistrationStatus",
           ai.LST_UPD_DT                                  "dateModified",
           cdebrowser_dec_t (
               dec.dec_id,
               dec.dec_long_name,
               dec.PREFERRED_DEFINITION,
               dec.dec_preferred_name,
               dec.dec_version,
               dec.ASL_NAME,
               dec.dec_context_name,
               dec.dec_context_version,
               admin_component_with_id_ln_t (dec.cd_id,
                                             dec.cd_context_name,
                                             dec.cd_context_version,
                                             dec.cd_long_name,
                                             dec.cd_version,
                                             dec.cd_preferred_name),
               admin_component_with_con_t (
                   dec.oc_id,
                   dec.oc_context_name,
                   dec.oc_context_version,
                   dec.oc_long_name,
                   dec.oc_version,
                   dec.oc_preferred_name,
                   CAST (
                       MULTISET (
                             SELECT con.item_long_nm
                                        preferred_name,
                                    con.item_nm
                                        long_name,
                                    con.item_id
                                        con_id,
                                    con.def_src
                                        definition_source,
                                    NVL (con.origin, con.ORIGIN_ID_DN)
                                        origin,
                                    cncpt.evs_src
                                        evs_Source,
                                    com.NCI_PRMRY_IND
                                        primary_flag_ind,
                                    com.nci_ord
                                        display_order
                               FROM cncpt_admin_item   com,
                                    Admin_item         con,
                                    ONEDATA_WA.VW_CNCPT cncpt
                              WHERE     dec.oc_id = com.item_id(+)
                                    AND dec.oc_version = com.ver_nr(+)
                                    AND com.cncpt_item_id = con.item_id(+)
                                    AND com.cncpt_ver_nr = con.ver_nr(+)
                                    AND con.admin_item_typ_id(+) = 49
                                    AND com.cncpt_item_id = cncpt.item_id(+)
                                    AND com.cncpt_ver_nr = cncpt.ver_nr(+)
                           ORDER BY nci_ord DESC)
                           AS Concepts_list_t)),
               admin_component_with_con_t (
                   dec.prop_id,
                   dec.pt_context_name,
                   dec.pt_context_version,
                   dec.pt_long_name,
                   dec.pt_version,
                   dec.pt_preferred_name,
                   CAST (
                       MULTISET (
                             SELECT con.item_long_nm
                                        preferred_name,
                                    con.item_nm
                                        long_name,
                                    con.item_id
                                        con_id,
                                    con.def_src
                                        definition_source,
                                    NVL (con.origin, con.ORIGIN_ID_DN)
                                        origin,
                                    cncpt.evs_src
                                        evs_Source,
                                    com.NCI_PRMRY_IND
                                        primary_flag_ind,
                                    com.nci_ord
                                        display_order
                               FROM cncpt_admin_item   com,
                                    Admin_item         con,
                                    ONEDATA_WA.VW_CNCPT cncpt
                              WHERE     dec.prop_id = com.item_id(+)
                                    AND dec.pt_version = com.ver_nr(+)
                                    AND com.cncpt_item_id = con.item_id(+)
                                    AND com.cncpt_ver_nr = con.ver_nr(+)
                                    AND con.admin_item_typ_id(+) = 49
                                    AND com.cncpt_item_id = cncpt.item_id(+)
                                    AND com.cncpt_ver_nr = cncpt.ver_nr(+)
                           ORDER BY nci_ord DESC)
                           AS Concepts_list_t)),
               dec.obj_class_qualifier,
               dec.property_qualifier,
               dec.dec_origin)                            "DataElementConcept",
           -- select
           CDEBROWSER_VD_T749 (
               vdai.item_id,
               vdai.item_long_nm,
               vdai.item_desc,
               vdai.item_nm,
               vdai.ver_nr,
               vdai.admin_stus_nm_dn,
               vdai.cntxt_nm_dn,
               vdai.cntxt_ver_nr,
               admin_component_with_id_ln_T (cd.item_id,
                                             cd.cntxt_nm_dn,
                                             cd.cntxt_ver_nr,
                                             cd.item_long_nm,
                                             cd.ver_nr,
                                             cd.item_nm),                /* */
               vd.dttype_id,
               DECODE (vd.VAL_DOM_TYP_ID,
                       17, 'Enumerated',
                       18, 'Non-enumerated'),
               vd.uom_id,
               vd.VAL_DOM_FMT_ID,
               vd.VAL_DOM_MAX_CHAR,
               vd.VAL_DOM_MIN_CHAR,
               vd.NCI_DEC_PREC,
               vd.CHAR_SET_ID,
               vd.VAL_DOM_HIGH_VAL_NUM,
               vd.VAL_DOM_LOW_VAL_NUM,
               NVL (vdai.origin, vdai.ORIGIN_ID_DN),
               admin_component_with_con_t (
                   rep.item_id,
                   rep.cntxt_nm_dn,
                   rep.CNTXT_VER_NR,
                   rep.ITEM_LONG_NM,
                   rep.VER_NR,
                   rep.ITEM_NM,
                   CAST (
                       MULTISET (
                             SELECT con.item_long_nm
                                        preferred_name,
                                    con.item_nm
                                        long_name,
                                    con.item_id
                                        con_id,
                                    con.def_src
                                        definition_source,
                                    NVL (con.origin, con.ORIGIN_ID_DN)
                                        origin,
                                    cncpt.evs_src
                                        evs_Source,
                                    com.NCI_PRMRY_IND
                                        primary_flag_ind,
                                    com.nci_ord
                                        display_order
                               FROM cncpt_admin_item   com,
                                    Admin_item         con,
                                    ONEDATA_WA.VW_CNCPT cncpt
                              WHERE     rep.item_id = com.item_id(+)
                                    AND rep.ver_nr = com.ver_nr(+)
                                    AND com.cncpt_item_id = con.item_id(+)
                                    AND com.cncpt_ver_nr = con.ver_nr(+)
                                    AND con.admin_item_typ_id(+) = 49
                                    AND com.cncpt_item_id = cncpt.item_id(+)
                                    AND com.cncpt_ver_nr = cncpt.ver_nr(+)
                           ORDER BY nci_ord DESC)
                           AS Concepts_list_t)),
               CAST (
                   MULTISET (
                       SELECT pv.PERM_VAL_NM,
                              pv.PERM_VAL_DESC_TXT,
                              vm.item_desc,
                              nci_11179.get_concepts (vm.item_id,
                                                      vm.ver_nr)
                                  MeaningConcepts,
                              /*  SBREXT.MDSR_CDEBROWSER.get_condr_origin (
                                    vm.condr_idseq)
                                    MeaningConceptOrigin,  */
                              nci_11179.get_concepts (vm.item_id, vm.ver_nr)
                                  MeaningConceptOrigin,
                              nci_11179.get_concept_order (vm.item_id,
                                                           vm.ver_nr)
                                  MeaningConceptDisplayOrder,
                              pv.PERM_VAL_BEG_DT,
                              pv.PERM_VAL_END_DT,
                              vm.item_id,
                              vm.ver_nr,
                              CAST (
                                  MULTISET (
                                      SELECT des.cntxt_nm_dn,
                                             TO_CHAR (des.cntxt_ver_nr),
                                             des.NM_DESC,
                                             ok.obj_key_desc,
                                             TO_CHAR (des.lang_id)   -- decode
                                        FROM alt_nms des, obj_key ok
                                       WHERE     vm.item_id = des.item_id(+)
                                             AND vm.ver_nr = des.ver_nr(+)
                                             AND des.NM_TYP_ID =
                                                 ok.obj_key_id(+))
                                      AS MDSR_749_ALTERNATENAM_LIST_T)
                                  "AlternateNameList"
                         FROM PERM_VAL pv, ADMIN_ITEM vm
                        WHERE     pv.val_dom_item_id = vd.item_id
                              AND pv.Val_dom_ver_nr = vd.ver_nr
                              AND pv.NCI_VAL_MEAN_ITEM_ID = vm.ITEM_ID
                              AND pv.NCI_VAL_MEAN_VER_NR = vm.VER_NR
                              AND vm.ADMIN_ITEM_TYP_ID = 53)
                       AS MDSR_749_PV_VD_LIST_T),
               CAST (
                   MULTISET (
                         SELECT con.item_long_nm
                                    preferred_name,
                                con.item_nm
                                    long_name,
                                con.item_id
                                    con_id,
                                con.def_src
                                    definition_source,
                                NVL (con.origin, con.ORIGIN_ID_DN)
                                    origin,
                                cncpt.evs_src
                                    evs_Source,
                                com.NCI_PRMRY_IND
                                    primary_flag_ind,
                                com.nci_ord
                                    display_order
                           FROM cncpt_admin_item   com,
                                Admin_item         con,
                                ONEDATA_WA.VW_CNCPT cncpt
                          WHERE     vd.item_id = com.item_id(+)
                                AND vd.ver_nr = com.ver_nr(+)
                                AND com.cncpt_item_id = con.item_id(+)
                                AND com.cncpt_ver_nr = con.ver_nr(+)
                                AND con.admin_item_typ_id(+) = 49
                                AND com.cncpt_item_id = cncpt.item_id(+)
                                AND com.cncpt_ver_nr = cncpt.ver_nr(+)
                       ORDER BY nci_ord DESC)
                       AS Concepts_list_t))               "ValueDomain",
           CAST (
               MULTISET (
                   SELECT rd.ref_nm,
                          -- org.name,
                          ok.OBJ_KEY_DESC,
                          ok.obj_key_desc,
                          rd.ref_desc,
                          rd.URL,
                          TO_CHAR (rd.lang_id),
                          rd.disp_ord
                     FROM REF rd, obj_key ok
                    WHERE     rd.REF_TYP_ID = ok.obj_key_id(+)
                          --, sbr.organizations org
                          AND de.item_id = rd.item_id
                          AND de.ver_nr = rd.ver_nr)
                   AS cdebrowser_rd_list_t)               "ReferenceDocumentsList",
           CAST (
               MULTISET (
                   SELECT admin_component_with_id_t (csv.cs_item_id,
                                                     csv.cs_cntxt_nm,
                                                     csv.cs_cntxt_ver_nr,
                                                     csv.cs_item_long_nm,
                                                     csv.cs_ver_nr),
                          csv.csi_item_nm,
                          csv.csitl_nm,
                          csv.csi_item_id,
                          csv.csi_ver_nr
                     FROM cdebrowser_cs_view_n csv
                    WHERE     de.item_id = csv.de_item_id
                          AND de.ver_nr = csv.de_ver_nr)
                   AS cdebrowser_csi_list_t)              "ClassificationsList",
           CAST (
               MULTISET (
                   SELECT des.cntxt_nm_dn,
                          TO_CHAR (des.cntxt_ver_nr),
                          des.NM_DESC,
                          ok.obj_key_desc,
                          TO_CHAR (des.lang_id)
                     FROM alt_nms des, obj_key ok
                    WHERE     de.item_id = des.item_id
                          AND de.ver_nr = des.ver_nr
                          AND des.nm_typ_id = ok.obj_key_id(+))
                   AS cdebrowser_altname_list_t)          "AlternateNameList",
           derived_data_element_t (ccd.CRTL_NAME,
                                   ccd.DESCRIPTION,
                                   ccd.METHODS,
                                   ccd.RULE,
                                   ccd.CONCAT_CHAR,
                                   "DataElementsList")    "DataElementDerivation"
      FROM ADMIN_ITEM                    ai,
           cdebrowser_de_dec_view        dec,
           admin_item                    vdai,
           ADMIN_ITEM                    cd,
           ADMIN_ITEM                    rep,
           value_dom                     vd,
           de                            de,
           CDEBROWSER_COMPLEX_DE_VIEW_N  ccd
     WHERE     ai.item_id = dec.de_id
           AND ai.ver_nr = dec.de_version
           AND ai.ADMIN_STUS_NM_DN NOT IN
                   ('RETIRED WITHDRAWN', 'RETIRED DELETED')
           AND ai.item_id = de.item_id
           AND ai.ver_nr = de.ver_nr
           AND ai.admin_item_typ_id = 4
           AND cd.admin_item_typ_id = 1
           AND cd.item_id = vd.CONC_DOM_ITEM_ID
           AND cd.ver_nr = vd.CONC_DOM_VER_NR
           AND rep.ADMIN_ITEM_TYP_ID = 7
           AND rep.item_id = vd.REP_CLS_ITEM_ID(+)
           AND rep.ver_nr = vd.REP_CLS_VER_NR(+)
           AND de.val_dom_item_id = vdai.item_id
           AND de.val_dom_ver_nr = vdai.ver_nr
           AND vdai.admin_item_typ_id = 3
           AND de.val_dom_item_id = vd.item_id
           AND de.val_dom_ver_nr = vd.ver_nr
           AND ai.item_id = ccd.item_id(+)
           AND ai.ver_nr = ccd.ver_nr(+);

CREATE OR REPLACE FORCE VIEW ONEDATA_WA.ONEDATA_WA_DE_CDE1_XML_GENERATOR_749VW
(
    RAI,
    PUBLICID,
    LONGNAME,
    PREFERREDNAME,
    PREFERREDDEFINITION,
    VERSION,
    WORKFLOWSTATUS,
    CONTEXTNAME,
    CONTEXTVERSION,
    ORIGIN,
    REGISTRATIONSTATUS,
    "dateModified",
    DATAELEMENTCONCEPT,
    VALUEDOMAIN,
    REFERENCEDOCUMENTSLIST,
    CLASSIFICATIONSLIST,
    ALTERNATENAMELIST,
    DATAELEMENTDERIVATION
)
BEQUEATH DEFINER
AS
    SELECT                                                     ---de.de_idseq,
           '2.16.840.1.113883.3.26.2'                     "RAI",
           ai.ITEM_ID                                     "PublicId",
           ai.ITEM_LONG_NM                                "LongName",
           ai.ITEM_NM                                     "PreferredName",
           ai.ITEM_DESC                                   "PreferredDefinition",
           ai.VER_NR                                      "Version",
           ai.ADMIN_STUS_NM_DN                            "WorkflowStatus",
           ai.CNTXT_NM_DN                                 "ContextName",
           ai.CNTXT_VER_NR                                "ContextVersion",
           NVL (ai.origin, ai.ORIGIN_ID_DN)               "Origin",
           ai.REGSTR_STUS_NM_DN                           "RegistrationStatus",
           ai.LST_UPD_DT                                  "dateModified",
           cdebrowser_dec_t (
               dec.dec_id,
               dec.dec_long_name,
               dec.PREFERRED_DEFINITION,
               dec.dec_preferred_name,
               dec.dec_version,
               dec.ASL_NAME,
               dec.dec_context_name,
               dec.dec_context_version,
               admin_component_with_id_ln_t (dec.cd_id,
                                             dec.cd_context_name,
                                             dec.cd_context_version,
                                             dec.cd_long_name,
                                             dec.cd_version,
                                             dec.cd_preferred_name),
               admin_component_with_con_t (
                   dec.oc_id,
                   dec.oc_context_name,
                   dec.oc_context_version,
                   dec.oc_long_name,
                   dec.oc_version,
                   dec.oc_preferred_name,
                   CAST (
                       MULTISET (
                             SELECT con.item_long_nm
                                        preferred_name,
                                    con.item_nm
                                        long_name,
                                    con.item_id
                                        con_id,
                                    con.def_src
                                        definition_source,
                                    NVL (con.origin, con.ORIGIN_ID_DN)
                                        origin,
                                    cncpt.evs_src
                                        evs_Source,
                                    com.NCI_PRMRY_IND
                                        primary_flag_ind,
                                    com.nci_ord
                                        display_order
                               FROM cncpt_admin_item   com,
                                    Admin_item         con,
                                    ONEDATA_WA.VW_CNCPT cncpt
                              WHERE     dec.oc_id = com.item_id(+)
                                    AND dec.oc_version = com.ver_nr(+)
                                    AND com.cncpt_item_id = con.item_id(+)
                                    AND com.cncpt_ver_nr = con.ver_nr(+)
                                    AND con.admin_item_typ_id(+) = 49
                                    AND com.cncpt_item_id = cncpt.item_id(+)
                                    AND com.cncpt_ver_nr = cncpt.ver_nr(+)
                           ORDER BY nci_ord DESC)
                           AS Concepts_list_t)),
               admin_component_with_con_t (
                   dec.prop_id,
                   dec.pt_context_name,
                   dec.pt_context_version,
                   dec.pt_long_name,
                   dec.pt_version,
                   dec.pt_preferred_name,
                   CAST (
                       MULTISET (
                             SELECT con.item_long_nm
                                        preferred_name,
                                    con.item_nm
                                        long_name,
                                    con.item_id
                                        con_id,
                                    con.def_src
                                        definition_source,
                                    NVL (con.origin, con.ORIGIN_ID_DN)
                                        origin,
                                    cncpt.evs_src
                                        evs_Source,
                                    com.NCI_PRMRY_IND
                                        primary_flag_ind,
                                    com.nci_ord
                                        display_order
                               FROM cncpt_admin_item   com,
                                    Admin_item         con,
                                    ONEDATA_WA.VW_CNCPT cncpt
                              WHERE     dec.prop_id = com.item_id(+)
                                    AND dec.pt_version = com.ver_nr(+)
                                    AND com.cncpt_item_id = con.item_id(+)
                                    AND com.cncpt_ver_nr = con.ver_nr(+)
                                    AND con.admin_item_typ_id(+) = 49
                                    AND com.cncpt_item_id = cncpt.item_id(+)
                                    AND com.cncpt_ver_nr = cncpt.ver_nr(+)
                           ORDER BY nci_ord DESC)
                           AS Concepts_list_t)),
               dec.obj_class_qualifier,
               dec.property_qualifier,
               dec.dec_origin)                            "DataElementConcept",
           -- select
           CDEBROWSER_VD_T749 (
               vdai.item_id,
               vdai.item_long_nm,
               vdai.item_desc,
               vdai.item_nm,
               vdai.ver_nr,
               vdai.admin_stus_nm_dn,
               vdai.cntxt_nm_dn,
               vdai.cntxt_ver_nr,
               admin_component_with_id_ln_T (cd.item_id,
                                             cd.cntxt_nm_dn,
                                             cd.cntxt_ver_nr,
                                             cd.item_long_nm,
                                             cd.ver_nr,
                                             cd.item_nm),                /* */
               vd.dttype_id,
               DECODE (vd.VAL_DOM_TYP_ID,
                       17, 'Enumerated',
                       18, 'Non-enumerated'),
               vd.uom_id,
               vd.VAL_DOM_FMT_ID,
               vd.VAL_DOM_MAX_CHAR,
               vd.VAL_DOM_MIN_CHAR,
               vd.NCI_DEC_PREC,
               vd.CHAR_SET_ID,
               vd.VAL_DOM_HIGH_VAL_NUM,
               vd.VAL_DOM_LOW_VAL_NUM,
               NVL (vdai.origin, vdai.ORIGIN_ID_DN),
               admin_component_with_con_t (
                   rep.item_id,
                   rep.cntxt_nm_dn,
                   rep.CNTXT_VER_NR,
                   rep.ITEM_LONG_NM,
                   rep.VER_NR,
                   rep.ITEM_NM,
                   CAST (
                       MULTISET (
                             SELECT con.item_long_nm
                                        preferred_name,
                                    con.item_nm
                                        long_name,
                                    con.item_id
                                        con_id,
                                    con.def_src
                                        definition_source,
                                    NVL (con.origin, con.ORIGIN_ID_DN)
                                        origin,
                                    cncpt.evs_src
                                        evs_Source,
                                    com.NCI_PRMRY_IND
                                        primary_flag_ind,
                                    com.nci_ord
                                        display_order
                               FROM cncpt_admin_item   com,
                                    Admin_item         con,
                                    ONEDATA_WA.VW_CNCPT cncpt
                              WHERE     rep.item_id = com.item_id(+)
                                    AND rep.ver_nr = com.ver_nr(+)
                                    AND com.cncpt_item_id = con.item_id(+)
                                    AND com.cncpt_ver_nr = con.ver_nr(+)
                                    AND con.admin_item_typ_id(+) = 49
                                    AND com.cncpt_item_id = cncpt.item_id(+)
                                    AND com.cncpt_ver_nr = cncpt.ver_nr(+)
                           ORDER BY nci_ord DESC)
                           AS Concepts_list_t)),
               CAST (
                   MULTISET (
                       SELECT pv.PERM_VAL_NM,
                              pv.PERM_VAL_DESC_TXT,
                              vm.item_desc,
                              nci_11179.get_concepts (vm.item_id,
                                                      vm.ver_nr)
                                  MeaningConcepts,
                              /*  SBREXT.MDSR_CDEBROWSER.get_condr_origin (
                                    vm.condr_idseq)
                                    MeaningConceptOrigin,  */
                              nci_11179.get_concepts (vm.item_id, vm.ver_nr)
                                  MeaningConceptOrigin,
                              nci_11179.get_concept_order (vm.item_id,
                                                           vm.ver_nr)
                                  MeaningConceptDisplayOrder,
                              pv.PERM_VAL_BEG_DT,
                              pv.PERM_VAL_END_DT,
                              vm.item_id,
                              vm.ver_nr,
                              CAST (
                                  MULTISET (
                                      SELECT des.cntxt_nm_dn,
                                             TO_CHAR (des.cntxt_ver_nr),
                                             des.NM_DESC,
                                             ok.obj_key_desc,
                                             TO_CHAR (des.lang_id)   -- decode
                                        FROM alt_nms des, obj_key ok
                                       WHERE     vm.item_id = des.item_id(+)
                                             AND vm.ver_nr = des.ver_nr(+)
                                             AND des.NM_TYP_ID =
                                                 ok.obj_key_id(+))
                                      AS MDSR_749_ALTERNATENAM_LIST_T)
                                  "AlternateNameList"
                         FROM PERM_VAL pv, ADMIN_ITEM vm
                        WHERE     pv.val_dom_item_id = vd.item_id
                              AND pv.Val_dom_ver_nr = vd.ver_nr
                              AND pv.NCI_VAL_MEAN_ITEM_ID = vm.ITEM_ID
                              AND pv.NCI_VAL_MEAN_VER_NR = vm.VER_NR
                              AND vm.ADMIN_ITEM_TYP_ID = 53)
                       AS MDSR_749_PV_VD_LIST_T),
               CAST (
                   MULTISET (
                         SELECT con.item_long_nm
                                    preferred_name,
                                con.item_nm
                                    long_name,
                                con.item_id
                                    con_id,
                                con.def_src
                                    definition_source,
                                NVL (con.origin, con.ORIGIN_ID_DN)
                                    origin,
                                cncpt.evs_src
                                    evs_Source,
                                com.NCI_PRMRY_IND
                                    primary_flag_ind,
                                com.nci_ord
                                    display_order
                           FROM cncpt_admin_item   com,
                                Admin_item         con,
                                ONEDATA_WA.VW_CNCPT cncpt
                          WHERE     vd.item_id = com.item_id(+)
                                AND vd.ver_nr = com.ver_nr(+)
                                AND com.cncpt_item_id = con.item_id(+)
                                AND com.cncpt_ver_nr = con.ver_nr(+)
                                AND con.admin_item_typ_id(+) = 49
                                AND com.cncpt_item_id = cncpt.item_id(+)
                                AND com.cncpt_ver_nr = cncpt.ver_nr(+)
                       ORDER BY nci_ord DESC)
                       AS Concepts_list_t))               "ValueDomain",
           CAST (
               MULTISET (
                   SELECT rd.ref_nm,
                          -- org.name,
                          ok.OBJ_KEY_DESC,
                          ok.obj_key_desc,
                          rd.ref_desc,
                          rd.URL,
                          TO_CHAR (rd.lang_id),
                          rd.disp_ord
                     FROM REF rd, obj_key ok
                    WHERE     rd.REF_TYP_ID = ok.obj_key_id(+)
                          --, sbr.organizations org
                          AND de.item_id = rd.item_id
                          AND de.ver_nr = rd.ver_nr)
                   AS cdebrowser_rd_list_t)               "ReferenceDocumentsList",
           CAST (
               MULTISET (
                   SELECT admin_component_with_id_t (csv.cs_item_id,
                                                     csv.cs_cntxt_nm,
                                                     csv.cs_cntxt_ver_nr,
                                                     csv.cs_item_long_nm,
                                                     csv.cs_ver_nr),
                          csv.csi_item_nm,
                          csv.csitl_nm,
                          csv.csi_item_id,
                          csv.csi_ver_nr
                     FROM cdebrowser_cs_view_n csv
                    WHERE     de.item_id = csv.de_item_id
                          AND de.ver_nr = csv.de_ver_nr)
                   AS cdebrowser_csi_list_t)              "ClassificationsList",
           CAST (
               MULTISET (
                   SELECT des.cntxt_nm_dn,
                          TO_CHAR (des.cntxt_ver_nr),
                          des.NM_DESC,
                          ok.obj_key_desc,
                          TO_CHAR (des.lang_id)
                     FROM alt_nms des, obj_key ok
                    WHERE     de.item_id = des.item_id
                          AND de.ver_nr = des.ver_nr
                          AND des.nm_typ_id = ok.obj_key_id(+))
                   AS cdebrowser_altname_list_t)          "AlternateNameList",
           derived_data_element_t (ccd.CRTL_NAME,
                                   ccd.DESCRIPTION,
                                   ccd.METHODS,
                                   ccd.RULE,
                                   ccd.CONCAT_CHAR,
                                   "DataElementsList")    "DataElementDerivation"
      FROM ADMIN_ITEM                    ai,
           cdebrowser_de_dec_view        dec,
           admin_item                    vdai,
           ADMIN_ITEM                    cd,
           ADMIN_ITEM                    rep,
           value_dom                     vd,
           de                            de,
           CDEBROWSER_COMPLEX_DE_VIEW_N  ccd
     WHERE     ai.item_id = dec.de_id
           AND ai.ver_nr = dec.de_version
           AND ai.ADMIN_STUS_NM_DN NOT IN
                   ('RETIRED WITHDRAWN', 'RETIRED DELETED')
           AND ai.item_id = de.item_id
           AND ai.ver_nr = de.ver_nr
           AND ai.admin_item_typ_id = 4
           AND cd.admin_item_typ_id = 1
           AND cd.item_id = vd.CONC_DOM_ITEM_ID
           AND cd.ver_nr = vd.CONC_DOM_VER_NR
           AND rep.ADMIN_ITEM_TYP_ID = 7
           AND rep.item_id = vd.REP_CLS_ITEM_ID(+)
           AND rep.ver_nr = vd.REP_CLS_VER_NR(+)
           AND de.val_dom_item_id = vdai.item_id
           AND de.val_dom_ver_nr = vdai.ver_nr
           AND vdai.admin_item_typ_id = 3
           AND de.val_dom_item_id = vd.item_id
           AND de.val_dom_ver_nr = vd.ver_nr
           AND ai.item_id = ccd.item_id(+)
           AND ai.ver_nr = ccd.ver_nr(+);
CREATE OR REPLACE FORCE VIEW SBREXT_DE_CDE1_XML_GENERATOR_749VW
(
    RAI,
    PUBLICID,
    LONGNAME,
    PREFERREDNAME,
    PREFERREDDEFINITION,
    VERSION,
    WORKFLOWSTATUS,
    CONTEXTNAME,
    CONTEXTVERSION,
    ORIGIN,
    REGISTRATIONSTATUS,
    DATAELEMENTCONCEPT,
    VALUEDOMAIN,
    REFERENCEDOCUMENTSLIST,
    CLASSIFICATIONSLIST,
    ALTERNATENAMELIST,
    DATAELEMENTDERIVATION
)
AS
    SELECT --de.de_idseq,
    '2.16.840.1.113883.3.26.2' "RAI" ,
           de.CDE_ID
               "PublicId",
           de.long_name
               "LongName",
           de.preferred_name
               "PreferredName",
           de.preferred_definition
               "PreferredDefinition",
           de.version
               "Version",
           de.ASL_NAME
               "WorkflowStatus",
           de_conte.name
               "ContextName",
           de_conte.version
               "ContextVersion",
           de.origin
               "Origin",
           ar.registration_status
               "RegistrationStatus",
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
                       MULTISET (
                             SELECT con.preferred_name,
                                    con.long_name,
                                    con.con_id,
                                    con.definition_source,
                                    con.origin,
                                    con.evs_Source,
                                    com.primary_flag_ind,
                                    com.display_order
                               FROM component_concepts_ext com,
                                    concepts_ext          con
                              WHERE     dec.oc_condr_idseq = com.condr_IDSEQ(+)
                                    AND com.con_idseq = con.con_idseq(+)
                           ORDER BY display_order DESC) AS Concepts_list_t)),
               admin_component_with_con_t (
                   dec.prop_id,
                   dec.pt_context_name,
                   dec.pt_context_version,
                   dec.pt_preferred_name,
                   dec.pt_version,
                   dec.pt_long_name,
                   CAST (
                       MULTISET (
                             SELECT con.preferred_name,
                                    con.long_name,
                                    con.con_id,
                                    con.definition_source,
                                    con.origin,
                                    con.evs_Source,
                                    com.primary_flag_ind,
                                    com.display_order
                               FROM component_concepts_ext com,
                                    concepts_ext          con
                              WHERE     dec.prop_condr_idseq =
                                        com.condr_IDSEQ(+)
                                    AND com.con_idseq = con.con_idseq(+)
                           ORDER BY display_order DESC) AS Concepts_list_t)),
               dec.obj_class_qualifier,
               dec.property_qualifier,
               dec.dec_origin)
               "DataElementConcept",
   CDEBROWSER_VD_T749 (
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
                       'E', 'Enumerated',
                       'N', 'NonEnumerated'),
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
                       MULTISET (
                             SELECT con.preferred_name,
                                    con.long_name,
                                    con.con_id,
                                    con.definition_source,
                                    con.origin,
                                    con.evs_Source,
                                    com.primary_flag_ind,
                                    com.display_order
                               FROM component_concepts_ext com,
                                    concepts_ext          con
                              WHERE     rep.condr_idseq = com.condr_IDSEQ(+)
                                    AND com.con_idseq = con.con_idseq(+)
                           ORDER BY display_order DESC) AS Concepts_list_t)),
               CAST (
                   MULTISET (
                       SELECT pv.VALUE,
                              pv.short_meaning,
                              vm.preferred_definition,
                              sbrext_common_routines.get_concepts (
                                  vm.condr_idseq)
                                  MeaningConcepts,
                              MDSR_CDEBROWSER.get_condr_origin (
                                  vm.condr_idseq)
                                  MeaningConceptOrigin,
                              MDSR_CDEBROWSER.get_concept_order (
                                  vm.condr_idseq)
                                  MeaningConceptDisplayOrder,
                              vp.begin_date,
                              vp.end_date,
                              vm.vm_id,
                              vm.version,
                              CAST (
                                  MULTISET (
                                      SELECT des_conte.name,
                                             des_conte.version,
                                             des.name,
                                             des.detl_name,
                                             des.lae_name
                                             FROM
                                         sbr.designations  des,
                                             sbr.contexts  des_conte
                                       WHERE     vm.vm_idseq =
                                                 des.AC_IDSEQ(+)
                                             AND des.conte_idseq =
                                                 des_conte.conte_idseq(+))
                                      AS MDSR_749_ALTERNATENAM_LIST_T)
                                  "AlternateNameList"
                         FROM sbr.permissible_values  pv,
                              sbr.vd_pvs              vp,
                              value_meanings          vm
                        WHERE     vp.vd_idseq = vd.vd_idseq
                              AND vp.pv_idseq = pv.pv_idseq
                              AND pv.vm_idseq = vm.vm_idseq)
                       AS MDSR_749_PV_VD_LIST_T),
               CAST (
                   MULTISET (
                         SELECT con.preferred_name,
                                con.long_name,
                                con.con_id,
                                con.definition_source,
                                con.origin,
                                con.evs_Source,
                                com.primary_flag_ind,
                                com.display_order
                           FROM component_concepts_ext com, concepts_ext con
                          WHERE     vd.condr_idseq = com.condr_IDSEQ(+)
                                AND com.con_idseq = con.con_idseq(+)
                       ORDER BY display_order DESC) AS Concepts_list_t))
               "ValueDomain",
           CAST (
               MULTISET (
                   SELECT rd.name,
                          org.name,
                          rd.DCTL_NAME,
                          rd.doc_text,
                          rd.URL,
                          rd.lae_name,
                          rd.display_order
                     FROM sbr.reference_documents rd, sbr.organizations org
                    WHERE     de.de_idseq = rd.ac_idseq
                          AND rd.ORG_IDSEQ = org.ORG_IDSEQ(+))
                   AS cdebrowser_rd_list_t)
               "ReferenceDocumentsList",
           CAST (
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
                     FROM cdebrowser_cs_view csv
                    WHERE de.de_idseq = csv.ac_idseq)
                   AS cdebrowser_csi_list_t)
               "ClassificationsList",
           CAST (
               MULTISET (
                   SELECT des_conte.name,
                          des_conte.version,
                          des.name,
                          des.detl_name,
                          des.lae_name
                     FROM sbr.designations des, sbr.contexts des_conte
                    WHERE     de.de_idseq = des.AC_IDSEQ(+)
                          AND des.conte_idseq = des_conte.conte_idseq(+))
                   AS cdebrowser_altname_list_t)
               "AlternateNameList",
           derived_data_element_t (ccd.crtl_name,
                                   ccd.description,
                                   ccd.methods,
                                   ccd.rule,
                                   ccd.concat_char,
                                   "DataElementsList")
               "DataElementDerivation"
      FROM sbr.data_elements                  de,
           cdebrowser_de_dec_view      dec,
           sbr.contexts                       de_conte,
           sbr.value_domains                  vd,
           sbr.contexts                       vd_conte,
           sbr.contexts                       cd_conte,
           sbr.conceptual_domains             cd,
           sbr.ac_registrations               ar,
           cdebrowser_complex_de_view  ccd,
           representations_ext         rep,
           sbr.contexts                       rep_conte
     WHERE     de.de_idseq = dec.de_idseq
           AND de.conte_idseq = de_conte.conte_idseq
           AND de.vd_idseq = vd.vd_idseq
           AND vd.conte_idseq = vd_conte.conte_idseq
           AND vd.cd_idseq = cd.cd_idseq
           AND cd.conte_idseq = cd_conte.conte_idseq
           AND de.de_idseq = ar.ac_idseq(+)
           AND de.de_idseq = ccd.p_de_idseq(+)
           AND vd.rep_idseq = rep.rep_idseq(+)
           AND rep.conte_idseq = rep_conte.conte_idseq(+)
           AND de.ASL_NAME NOT IN ('RETIRED WITHDRAWN', 'RETIRED DELETED')
           AND upper(de_conte.name) NOT IN ('TEST','TRAINING');
  /       
CREATE OR REPLACE SYNONYM CDEBROWSER.DE_CDE1_XML_GENERATOR_749VW FOR DE_CDE1_XML_GENERATOR_749VW;
CREATE OR REPLACE SYNONYM CDEVALIDATE.DE_CDE1_XML_GENERATOR_749VW FOR DE_CDE1_XML_GENERATOR_749VW;
CREATE OR REPLACE SYNONYM SBR.DE_CDE1_XML_GENERATOR_749VW FOR DE_CDE1_XML_GENERATOR_749VW;
CREATE OR REPLACE SYNONYM UMLLOADER_COOPERM.DE_CDE1_XML_GENERATOR_749VW FOR DE_CDE1_XML_GENERATOR_749VW;
CREATE OR REPLACE SYNONYM READONLY.DE_CDE1_XML_GENERATOR_749VW FOR DE_CDE1_XML_GENERATOR_749VW;
CREATE OR REPLACE SYNONYM GUEST.DE_CDE1_XML_GENERATOR_749VW FOR DE_CDE1_XML_GENERATOR_749VW;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DE_CDE1_XML_GENERATOR_749VW TO CDEBROWSER;
GRANT SELECT ON DE_CDE1_XML_GENERATOR_749VW TO CDEVALIDATE;
GRANT DELETE, INSERT, SELECT, UPDATE ON DE_CDE1_XML_GENERATOR_749VW TO DER_USER;
GRANT SELECT ON DE_CDE1_XML_GENERATOR_749VW TO DEV_READ_ONLY;
GRANT SELECT ON DE_CDE1_XML_GENERATOR_749VW TO READONLY;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DE_CDE1_XML_GENERATOR_749VW TO SBR WITH GRANT OPTION;
CREATE OR REPLACE PUBLIC SYNONYM CDEBROWSER_VD_T749  FOR CDEBROWSER_VD_T749 ;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_749_PV_VD_ITEM_T FOR MDSR_749_PV_VD_ITEM_T;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_749_PV_VD_LIST_T FOR MDSR_749_PV_VD_LIST_T;
GRANT EXECUTE, DEBUG ON CDEBROWSER_VD_T749 TO  PUBLIC;
GRANT EXECUTE, DEBUG ON CDEBROWSER_VD_T749 TO SBR WITH GRANT OPTION;
GRANT EXECUTE, DEBUG ON MDSR_749_PV_VD_ITEM_T TO  PUBLIC;
GRANT EXECUTE, DEBUG ON MDSR_749_PV_VD_ITEM_T TO SBR WITH GRANT OPTION;
GRANT EXECUTE, DEBUG ON MDSR_749_PV_VD_LIST_T TO PUBLIC;
GRANT EXECUTE, DEBUG ON MDSR_749_PV_VD_LIST_T TO SBR WITH GRANT OPTION;
GRANT EXECUTE, DEBUG ON MDSR_749_ALTERNATENAM_LIST_T TO PUBLIC;
GRANT EXECUTE, DEBUG ON MDSR_749_ALTERNATENAM_LIST_T TO SBR WITH GRANT OPTION;
GRANT EXECUTE, DEBUG ON MDSR_749_ALTERNATENAME_ITEM_T TO PUBLIC;
GRANT EXECUTE, DEBUG ON MDSR_749_ALTERNATENAME_ITEM_T TO SBR WITH GRANT OPTION;

SPOOL OFF