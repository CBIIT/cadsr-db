desc CDEBROWSER_VD_T749;

CREATE OR REPLACE TYPE ONEDATA_WA.CDEBROWSER_VD_T749                                          AS OBJECT
( "PublicId"         NUMBER,
  "PreferredName"          VARCHAR2 (30),
  "PreferredDefinition"    VARCHAR2 (2000),
  "LongName"      VARCHAR2(255),
  "Version"                NUMBER (4,2),
  "WorkflowStatus"         VARCHAR2 (20),
  "ContextName"         VARCHAR2 (30),
  "ContextVersion"     NUMBER (4,2),
--  "ConceptualDomain"    admin_component_with_id_ln_t,
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
--  "Representation"    admin_component_with_con_t,
  "PermissibleValues"     MDSR_749_PV_VD_LIST_T
 --, "ValueDomainConcepts"    Concepts_list_t
);


select       
        CDEBROWSER_VD_T749 (
               vdai.item_id,
               vdai.item_long_nm,
               vdai.item_desc,
               vdai.item_nm,
               vdai.ver_nr,
               vdai.admin_stus_nm_dn,
               vdai.cntxt_nm_dn,
               vdai.cntxt_ver_nr,
               /*  admin_component_with_id_ln_T (cd.item_id,
                                               cd.cntxt_nm_dn,
                                               cd.cntxt_ver_nr,
                                               cd.item_nm,
                                               cd.ver_nr,
                                               cd.item_long_nm), */
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
               vdai.origin,
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
                       AS MDSR_749_PV_VD_LIST_T) 
                                                )
               "ValueDomain"
      FROM ADMIN_ITEM              ai,
           cdebrowser_de_dec_view  dec,
           admin_item              vdai,
           value_dom               vd,
           de                      de
     WHERE     ai.item_id = dec.de_id
           AND ai.ver_nr = dec.de_version
           AND ai.ADMIN_STUS_NM_DN NOT IN
                   ('RETIRED WITHDRAWN', 'RETIRED DELETED')
           AND ai.item_id = de.item_id
           AND ai.ver_nr = de.ver_nr
           AND ai.admin_item_typ_id = 4
           AND de.val_dom_item_id = vdai.item_id
           AND de.val_dom_ver_nr = vdai.ver_nr
           AND vdai.admin_item_typ_id = 3
           AND de.val_dom_item_id = vd.item_id
           AND de.val_dom_ver_nr = vd.ver_nr;
