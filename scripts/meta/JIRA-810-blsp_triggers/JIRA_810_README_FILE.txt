Step1
Check records to be clean up before The DB script executed.
select *from (
select nvl(count(*),0) CTN , 'SBR.VALUE_DOMAINS',  'PREFERRED_DEFINITION' from SBR.VALUE_DOMAINS where  REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.VALUE_DOMAINS',  'FORML_NAME' from SBR.VALUE_DOMAINS where  REGEXP_like(FORML_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.DEFINITIONS',  'DEFINITION' from SBR.DEFINITIONS where  REGEXP_like(DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.DATA_ELEMENT_CONCEPTS',  'PREFERRED_DEFINITION' from SBR.DATA_ELEMENT_CONCEPTS where  REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.AC_STATUS_LOV',  'DESCRIPTION' from SBR.AC_STATUS_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.REFERENCE_FORMATS_LOV',  'DESCRIPTION' from SBR.REFERENCE_FORMATS_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.SUBJECTS',  'DESCRIPTION' from SBR.SUBJECTS where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.VALUE_MEANINGS',  'DESCRIPTION' from SBR.VALUE_MEANINGS where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.VALUE_MEANINGS',  'PREFERRED_DEFINITION' from SBR.VALUE_MEANINGS where  REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.VALUE_MEANINGS',  'LONG_NAME' from SBR.VALUE_MEANINGS where  REGEXP_like(LONG_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.COMPLEX_REP_TYPE_LOV',  'DESCRIPTION' from SBR.COMPLEX_REP_TYPE_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.DATA_ELEMENTS',  'PREFERRED_NAME' from SBR.DATA_ELEMENTS where  REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.DATA_ELEMENTS',  'LONG_NAME' from SBR.DATA_ELEMENTS where  REGEXP_like(LONG_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.PROGRAM_AREAS_LOV',  'DESCRIPTION' from SBR.PROGRAM_AREAS_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.PROGRAMS',  'NAME' from SBR.PROGRAMS where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.QUEST_ATTRIBUTES_EXT',  'DEFAULT_VALUE' from SBREXT.QUEST_ATTRIBUTES_EXT where  REGEXP_like(DEFAULT_VALUE,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.TOOL_OPTIONS_EXT',  'VALUE' from SBREXT.TOOL_OPTIONS_EXT where  REGEXP_like(VALUE,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.DEFINITION_TYPES_LOV_EXT',  'DESCRIPTION' from SBREXT.DEFINITION_TYPES_LOV_EXT where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.QUALIFIER_LOV_EXT',  'DESCRIPTION' from SBREXT.QUALIFIER_LOV_EXT where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.TS_TYPE_LOV_EXT',  'DESCRIPTION' from SBREXT.TS_TYPE_LOV_EXT where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.AC_ATT_TYPES_LOV_EXT',  'DESCRIPTION' from SBREXT.AC_ATT_TYPES_LOV_EXT where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.REPRESENTATIONS_EXT',  'PREFERRED_NAME' from SBREXT.REPRESENTATIONS_EXT where  REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.CONTACT_ROLES_EXT',  'DESCRIPTION' from SBREXT.CONTACT_ROLES_EXT where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.ADDR_TYPES_LOV',  'DESCRIPTION' from SBR.ADDR_TYPES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.AC_TYPES_LOV',  'DESCRIPTION' from SBR.AC_TYPES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.PERMISSIBLE_VALUES',  'SHORT_MEANING' from SBR.PERMISSIBLE_VALUES where  REGEXP_like(SHORT_MEANING,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.RELATIONSHIPS_LOV',  'DESCRIPTION' from SBR.RELATIONSHIPS_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.REGISTRARS',  'NAME' from SBR.REGISTRARS where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CS_ITEMS',  'LONG_NAME' from SBR.CS_ITEMS where  REGEXP_like(LONG_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.DESIGNATION_TYPES_LOV',  'DESCRIPTION' from SBR.DESIGNATION_TYPES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CD_VMS',  'DESCRIPTION' from SBR.CD_VMS where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.ACTIONS_LOV',  'DESCRIPTION' from SBR.ACTIONS_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.DATATYPES_LOV',  'DESCRIPTION' from SBR.DATATYPES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.RULE_FUNCTIONS_EXT',  'NAME' from SBREXT.RULE_FUNCTIONS_EXT where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.REPRESENTATION_LOV_EXT',  'DESCRIPTION' from SBREXT.REPRESENTATION_LOV_EXT where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.OC_RECS_EXT',  'LONG_NAME' from SBREXT.OC_RECS_EXT where  REGEXP_like(LONG_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.OBJECT_CLASSES_EXT',  'PREFERRED_NAME' from SBREXT.OBJECT_CLASSES_EXT where  REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.QUEST_CONTENTS_EXT',  'PREFERRED_DEFINITION' from SBREXT.QUEST_CONTENTS_EXT where  REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.CON_DERIVATION_RULES_EXT',  'NAME' from SBREXT.CON_DERIVATION_RULES_EXT where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.UNIT_OF_MEASURES_LOV',  'DESCRIPTION' from SBR.UNIT_OF_MEASURES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.DATA_ELEMENT_CONCEPTS',  'LONG_NAME' from SBR.DATA_ELEMENT_CONCEPTS where  REGEXP_like(LONG_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.PERMISSIBLE_VALUES',  'VALUE' from SBR.PERMISSIBLE_VALUES where  REGEXP_like(VALUE,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.SUBMITTERS',  'NAME' from SBR.SUBMITTERS where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.REFERENCE_DOCUMENTS',  'NAME' from SBR.REFERENCE_DOCUMENTS where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CM_STATES_LOV',  'DESCRIPTION' from SBR.CM_STATES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CLASSIFICATION_SCHEMES',  'LONG_NAME' from SBR.CLASSIFICATION_SCHEMES where  REGEXP_like(LONG_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.USER_ACCOUNTS',  'NAME' from SBR.USER_ACCOUNTS where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.GROUPS',  'DESCRIPTION' from SBR.GROUPS where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.VALUE_MEANINGS',  'PREFERRED_NAME' from SBR.VALUE_MEANINGS where  REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CONTEXTS',  'NAME' from SBR.CONTEXTS where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CONCEPTUAL_DOMAINS',  'LONG_NAME' from SBR.CONCEPTUAL_DOMAINS where  REGEXP_like(LONG_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.DATA_ELEMENTS',  'PREFERRED_DEFINITION' from SBR.DATA_ELEMENTS where  REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.ORGANIZATIONS',  'NAME' from SBR.ORGANIZATIONS where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.PROPERTIES_LOV',  'PROPL_NAME' from SBR.PROPERTIES_LOV where  REGEXP_like(PROPL_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.CART',  'NAME' from SBREXT.CART where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.TOOL_OPTIONS_EXT',  'DESCRIPTION' from SBREXT.TOOL_OPTIONS_EXT where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.OBJECT_CLASSES_EXT',  'LONG_NAME' from SBREXT.OBJECT_CLASSES_EXT where  REGEXP_like(LONG_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.SN_ALERT_EXT',  'NAME' from SBREXT.SN_ALERT_EXT where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.PROTOCOLS_EXT',  'LONG_NAME' from SBREXT.PROTOCOLS_EXT where  REGEXP_like(LONG_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.SN_QUERY_EXT',  'VALUE' from SBREXT.SN_QUERY_EXT where  REGEXP_like(VALUE,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.TOOL_PROPERTIES_EXT',  'VALUE' from SBREXT.TOOL_PROPERTIES_EXT where  REGEXP_like(VALUE,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.RULES_LOV',  'DESCRIPTION' from SBR.RULES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.REG_STATUS_LOV',  'DESCRIPTION' from SBR.REG_STATUS_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CSI_TYPES_LOV',  'DESCRIPTION' from SBR.CSI_TYPES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CS_ITEMS',  'PREFERRED_NAME' from SBR.CS_ITEMS where  REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CHARACTER_SET_LOV',  'DESCRIPTION' from SBR.CHARACTER_SET_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.LANGUAGES_LOV',  'DESCRIPTION' from SBR.LANGUAGES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.ADMINISTERED_COMPONENTS',  'PREFERRED_NAME' from SBR.ADMINISTERED_COMPONENTS where  REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.ADMINISTERED_COMPONENTS',  'LONG_NAME' from SBR.ADMINISTERED_COMPONENTS where  REGEXP_like(LONG_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CONCEPTUAL_DOMAINS',  'PREFERRED_NAME' from SBR.CONCEPTUAL_DOMAINS where  REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.APP_PRIV_LOV',  'DESCRIPTION' from SBR.APP_PRIV_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.APP_OBJECTS',  'NAME' from SBR.APP_OBJECTS where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.APP_COMPONENT_TYPES_LOV',  'DESCRIPTION' from SBR.APP_COMPONENT_TYPES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.OBJECT_CLASSES_EXT',  'DEFINITION_SOURCE' from SBREXT.OBJECT_CLASSES_EXT where  REGEXP_like(DEFINITION_SOURCE,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.ICD',  'SHORT_MEANING' from SBREXT.ICD where  REGEXP_like(SHORT_MEANING,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.ICD',  'DESCRIPTION' from SBREXT.ICD where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.TOOL_PROPERTIES_EXT',  'NAME' from SBREXT.TOOL_PROPERTIES_EXT where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.REPRESENTATIONS_EXT',  'DEFINITION_SOURCE' from SBREXT.REPRESENTATIONS_EXT where  REGEXP_like(DEFINITION_SOURCE,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CS_ITEMS',  'PREFERRED_DEFINITION' from SBR.CS_ITEMS where  REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.LIFECYCLES_LOV',  'DESCRIPTION' from SBR.LIFECYCLES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.DOCUMENT_TYPES_LOV',  'DESCRIPTION' from SBR.DOCUMENT_TYPES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.REFERENCE_BLOBS',  'NAME' from SBR.REFERENCE_BLOBS where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.USER_ACCOUNTS',  'DESCRIPTION' from SBR.USER_ACCOUNTS where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.SECURITY_CONTEXTS_LOV',  'DESCRIPTION' from SBR.SECURITY_CONTEXTS_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.VALUE_MEANINGS',  'SHORT_MEANING' from SBR.VALUE_MEANINGS where  REGEXP_like(SHORT_MEANING,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.ADMINISTERED_COMPONENTS',  'PREFERRED_DEFINITION' from SBR.ADMINISTERED_COMPONENTS where  REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CD_VMS',  'SHORT_MEANING' from SBR.CD_VMS where  REGEXP_like(SHORT_MEANING,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CS_TYPES_LOV',  'DESCRIPTION' from SBR.CS_TYPES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.APP_ROLES_LOV',  'DESCRIPTION' from SBR.APP_ROLES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.APP_OBJECTS_LOV',  'DESCRIPTION' from SBR.APP_OBJECTS_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.PROGRAMS',  'DESCRIPTION' from SBR.PROGRAMS where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.FORMATS_LOV',  'DESCRIPTION' from SBR.FORMATS_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.PROPERTIES_EXT',  'PREFERRED_DEFINITION' from SBREXT.PROPERTIES_EXT where  REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.PROPERTIES_EXT',  'DEFINITION_SOURCE' from SBREXT.PROPERTIES_EXT where  REGEXP_like(DEFINITION_SOURCE,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.SOURCES_EXT',  'DESCRIPTION' from SBREXT.SOURCES_EXT where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.QUEST_CONTENTS_EXT',  'PREFERRED_NAME' from SBREXT.QUEST_CONTENTS_EXT where  REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.QC_TYPE_LOV_EXT',  'DESCRIPTION' from SBREXT.QC_TYPE_LOV_EXT where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.CONCEPTS_EXT',  'PREFERRED_DEFINITION' from SBREXT.CONCEPTS_EXT where  REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.REPRESENTATIONS_EXT',  'PREFERRED_DEFINITION' from SBREXT.REPRESENTATIONS_EXT where  REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.VALUE_DOMAINS',  'LONG_NAME' from SBR.VALUE_DOMAINS where  REGEXP_like(LONG_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.DESIGNATIONS',  'NAME' from SBR.DESIGNATIONS where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.DATA_ELEMENT_CONCEPTS',  'PROPL_NAME' from SBR.DATA_ELEMENT_CONCEPTS where  REGEXP_like(PROPL_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.REL_USAGE_LOV',  'DESCRIPTION' from SBR.REL_USAGE_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.REFERENCE_DOCUMENTS',  'DOC_TEXT' from SBR.REFERENCE_DOCUMENTS where  REGEXP_like(DOC_TEXT,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.ADVANCE_RPT_LOV',  'DESCRIPTION' from SBR.ADVANCE_RPT_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.PROPERTIES_EXT',  'PREFERRED_NAME' from SBREXT.PROPERTIES_EXT where  REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.OC_RECS_EXT',  'PREFERRED_DEFINITION' from SBREXT.OC_RECS_EXT where  REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.OBJECT_CLASSES_EXT',  'PREFERRED_DEFINITION' from SBREXT.OBJECT_CLASSES_EXT where  REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.QC_DISPLAY_LOV_EXT',  'DESCRIPTION' from SBREXT.QC_DISPLAY_LOV_EXT where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.CONCEPT_SOURCES_LOV_EXT',  'DESCRIPTION' from SBREXT.CONCEPT_SOURCES_LOV_EXT where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.VALUE_DOMAINS',  'PREFERRED_NAME' from SBR.VALUE_DOMAINS where  REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.UNIT_OF_MEASURES_LOV',  'UOML_NAME' from SBR.UNIT_OF_MEASURES_LOV where  REGEXP_like(UOML_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.STEWARDS',  'NAME' from SBR.STEWARDS where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CS_ITEMS',  'DESCRIPTION' from SBR.CS_ITEMS where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.OBJECT_CLASSES_LOV',  'DESCRIPTION' from SBR.OBJECT_CLASSES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.LOOKUP_LOV',  'DESCRIPTION' from SBR.LOOKUP_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.VALUE_MEANINGS',  'DEFINITION_SOURCE' from SBR.VALUE_MEANINGS where  REGEXP_like(DEFINITION_SOURCE,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CONCEPTUAL_DOMAINS',  'PREFERRED_DEFINITION' from SBR.CONCEPTUAL_DOMAINS where  REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.COMM_TYPES_LOV',  'DESCRIPTION' from SBR.COMM_TYPES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.BUSINESS_ROLES_LOV',  'DESCRIPTION' from SBR.BUSINESS_ROLES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.PROPERTIES_EXT',  'LONG_NAME' from SBREXT.PROPERTIES_EXT where  REGEXP_like(LONG_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.OC_RECS_EXT',  'PREFERRED_NAME' from SBREXT.OC_RECS_EXT where  REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.QUEST_CONTENTS_EXT',  'LONG_NAME' from SBREXT.QUEST_CONTENTS_EXT where  REGEXP_like(LONG_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.GS_TABLES_LOV',  'NAME' from SBREXT.GS_TABLES_LOV where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.PROTOCOLS_EXT',  'PREFERRED_NAME' from SBREXT.PROTOCOLS_EXT where  REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.CONCEPTS_EXT',  'LONG_NAME' from SBREXT.CONCEPTS_EXT where  REGEXP_like(LONG_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.REPRESENTATIONS_EXT',  'LONG_NAME' from SBREXT.REPRESENTATIONS_EXT where  REGEXP_like(LONG_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.VALUE_DOMAINS',  'UOML_NAME' from SBR.VALUE_DOMAINS where  REGEXP_like(UOML_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.DEC_RECS',  'DESCRIPTION' from SBR.DEC_RECS where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.DATA_ELEMENT_CONCEPTS',  'PREFERRED_NAME' from SBR.DATA_ELEMENT_CONCEPTS where  REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.PERMISSIBLE_VALUES',  'MEANING_DESCRIPTION' from SBR.PERMISSIBLE_VALUES where  REGEXP_like(MEANING_DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CLASSIFICATION_SCHEMES',  'PREFERRED_NAME' from SBR.CLASSIFICATION_SCHEMES where  REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CLASSIFICATION_SCHEMES',  'PREFERRED_DEFINITION' from SBR.CLASSIFICATION_SCHEMES where  REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.LANGUAGES_LOV',  'NAME' from SBR.LANGUAGES_LOV where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.CONTEXTS',  'DESCRIPTION' from SBR.CONTEXTS where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.APP_VERSIONS',  'DESCRIPTION' from SBR.APP_VERSIONS where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.ADVANCE_RPT_LOV',  'NAME' from SBR.ADVANCE_RPT_LOV where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.PROPERTIES_LOV',  'DESCRIPTION' from SBR.PROPERTIES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.QUEST_VV_EXT',  'VALUE' from SBREXT.QUEST_VV_EXT where  REGEXP_like(VALUE,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.REVIEWER_FEEDBACK_LOV_EXT',  'DESCRIPTION' from SBREXT.REVIEWER_FEEDBACK_LOV_EXT where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.PROTOCOLS_EXT',  'PREFERRED_DEFINITION' from SBREXT.PROTOCOLS_EXT where  REGEXP_like(PREFERRED_DEFINITION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.CONCEPTS_EXT',  'PREFERRED_NAME' from SBREXT.CONCEPTS_EXT where  REGEXP_like(PREFERRED_NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBREXT.CONCEPTS_EXT',  'DEFINITION_SOURCE' from SBREXT.CONCEPTS_EXT where  REGEXP_like(DEFINITION_SOURCE,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3
 UNION
 select nvl(count(*),0) CTN , 'SBR.UI_LINKS',  'NAME' from SBR.UI_LINKS where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.UI_LINK_PARAMS',  'NAME' from SBR.UI_LINK_PARAMS where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.UI_METADATA',  'NAME' from SBR.UI_METADATA where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.UI_TYPES_LOV',  'DESCRIPTION' from SBR.UI_TYPES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.S_STANDARDS_LOV',  'DESCRIPTION' from SBR.S_STANDARDS_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.S_CMM_SA_MAP',  'DESCRIPTION' from SBR.S_CMM_SA_MAP where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.S_MANDATORY_TYPES_LOV',  'DESCRIPTION' from SBR.S_MANDATORY_TYPES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.UI_HIERARCHIES',  'NAME' from SBR.UI_HIERARCHIES where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.S_COMPLIANCE_STATUS_LOV',  'DESCRIPTION' from SBR.S_COMPLIANCE_STATUS_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.UI_ACTIVITIES_LOV',  'DESCRIPTION' from SBR.UI_ACTIVITIES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.UI_FRAMESETS',  'NAME' from SBR.UI_FRAMESETS where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.UI_ELEMENTS',  'NAME' from SBR.UI_ELEMENTS where  REGEXP_like(NAME,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.S_STANDARD_ATTRIBUTES',  'DESCRIPTION' from SBR.S_STANDARD_ATTRIBUTES where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.UI_AC_TYPES_LOV',  'DESCRIPTION' from SBR.UI_AC_TYPES_LOV where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3 
 UNION 
 select nvl(count(*),0) CTN , 'SBR.S_CMR_META_MODELS',  'DESCRIPTION' from SBR.S_CMR_META_MODELS where  REGEXP_like(DESCRIPTION,'(^([[:space:]]|[[:cntrl:]])+)|(([[:space:]]|[[:cntrl:]])+$)') group by 2,3
 )order by 2,3;
 
Step2
Send request to DBA team to do following actions on STAGE and PROD.
1.login in DB as SBR user
2.exec JIRA_810_ALL_triggers.sql (attached)
3.exec JIRA_810_CLEAN_SPS.sql (attached)
4.exec SBR.MDSR_TABLE_FIND_SPC(‘BEFORE’)
5.exec SBR.MDSR_TABLE_TRM_SPC_2
6. exec SBR.MDSR_TABLE_TRM_SPC_3
7. exec JIRA_810_UPDATE_WITH_TRIGGERS.sql
8.swnt us log files:
 Jira810-t.log
Jira810-p.log
Jira810-u.log

Step3
Run SQL in step1. It should not bring records>then 0;This checks if the Cleanup Procedure works well
Step 4

Run following statements and verify ,there are no leading/trailing spaces:

SELECT DESCRIPTION, 'SBR.AC_STATUS_LOV' MyTable, 'ASL_NAME' PK, 'RECOMMENDED TERM' PK_VAL FROM SBR.AC_STATUS_LOV WHERE ASL_NAME = 'RECOMMENDED TERM';
SELECT DESCRIPTION, 'SBR.AC_TYPES_LOV' MyTable, 'ACTL_NAME' PK, 'QUEST_CONTENT' PK_VAL FROM SBR.AC_TYPES_LOV WHERE ACTL_NAME = 'QUEST_CONTENT';
SELECT LONG_NAME, 'SBR.ADMINISTERED_COMPONENTS' MyTable, 'AC_IDSEQ' PK, '62095CB4-10B4-F4AA-E040-BB89AD4306B0' PK_VAL FROM SBR.ADMINISTERED_COMPONENTS WHERE AC_IDSEQ = '62095CB4-10B4-F4AA-E040-BB89AD4306B0';
SELECT PREFERRED_DEFINITION, 'SBR.ADMINISTERED_COMPONENTS' MyTable, 'AC_IDSEQ' PK, '99BA9DC8-33F0-4E69-E034-080020C9C0E0' PK_VAL FROM SBR.ADMINISTERED_COMPONENTS WHERE AC_IDSEQ = '99BA9DC8-33F0-4E69-E034-080020C9C0E0';
SELECT PREFERRED_NAME, 'SBR.ADMINISTERED_COMPONENTS' MyTable, 'AC_IDSEQ' PK, 'A703AB38-CE67-188D-E034-0003BA0B1A09' PK_VAL FROM SBR.ADMINISTERED_COMPONENTS WHERE AC_IDSEQ = 'A703AB38-CE67-188D-E034-0003BA0B1A09';
SELECT DESCRIPTION, 'SBR.CD_VMS' MyTable, 'CV_IDSEQ' PK, 'CADFFE8A-19EA-16C7-E034-0003BA12F5E7' PK_VAL FROM SBR.CD_VMS WHERE CV_IDSEQ = 'CADFFE8A-19EA-16C7-E034-0003BA12F5E7';
SELECT SHORT_MEANING, 'SBR.CD_VMS' MyTable, 'CV_IDSEQ' PK, 'D7F645D4-4D0A-68AD-E034-0003BA12F5E7' PK_VAL FROM SBR.CD_VMS WHERE CV_IDSEQ = 'D7F645D4-4D0A-68AD-E034-0003BA12F5E7';
SELECT LONG_NAME, 'SBR.CLASSIFICATION_SCHEMES' MyTable, 'CS_IDSEQ' PK, '1695FC8B-EB7D-06E2-E044-0003BA3F9857' PK_VAL FROM SBR.CLASSIFICATION_SCHEMES WHERE CS_IDSEQ = '1695FC8B-EB7D-06E2-E044-0003BA3F9857';
SELECT PREFERRED_DEFINITION, 'SBR.CLASSIFICATION_SCHEMES' MyTable, 'CS_IDSEQ' PK, '17618EC8-84AE-514D-E044-0003BA3F9857' PK_VAL FROM SBR.CLASSIFICATION_SCHEMES WHERE CS_IDSEQ = '17618EC8-84AE-514D-E044-0003BA3F9857';
SELECT PREFERRED_NAME, 'SBR.CLASSIFICATION_SCHEMES' MyTable, 'CS_IDSEQ' PK, 'A703AB38-CE67-188D-E034-0003BA0B1A09' PK_VAL FROM SBR.CLASSIFICATION_SCHEMES WHERE CS_IDSEQ = 'A703AB38-CE67-188D-E034-0003BA0B1A09';
SELECT PREFERRED_DEFINITION, 'SBR.CONCEPTUAL_DOMAINS' MyTable, 'CD_IDSEQ' PK, 'D86E246E-BBB4-0438-E034-0003BA12F5E7' PK_VAL FROM SBR.CONCEPTUAL_DOMAINS WHERE CD_IDSEQ = 'D86E246E-BBB4-0438-E034-0003BA12F5E7';
SELECT PREFERRED_NAME, 'SBR.CONCEPTUAL_DOMAINS' MyTable, 'CD_IDSEQ' PK, '63D982FA-DFBF-58C7-E040-BB89AD433E84' PK_VAL FROM SBR.CONCEPTUAL_DOMAINS WHERE CD_IDSEQ = '63D982FA-DFBF-58C7-E040-BB89AD433E84';
SELECT DESCRIPTION, 'SBR.CONTEXTS' MyTable, 'CONTE_IDSEQ' PK, 'EDA90DE9-80D9-1E28-E034-0003BA3F9857' PK_VAL FROM SBR.CONTEXTS WHERE CONTE_IDSEQ = 'EDA90DE9-80D9-1E28-E034-0003BA3F9857';
SELECT DESCRIPTION, 'SBR.CSI_TYPES_LOV' MyTable, 'CSITL_NAME' PK, 'SemanticCategory' PK_VAL FROM SBR.CSI_TYPES_LOV WHERE CSITL_NAME = 'SemanticCategory';
SELECT DESCRIPTION, 'SBR.CS_ITEMS' MyTable, 'CSI_IDSEQ' PK, 'D67A7FC0-A00B-202C-E034-0003BA12F5E7' PK_VAL FROM SBR.CS_ITEMS WHERE CSI_IDSEQ = 'D67A7FC0-A00B-202C-E034-0003BA12F5E7';
SELECT LONG_NAME, 'SBR.CS_ITEMS' MyTable, 'CSI_IDSEQ' PK, 'D950FF11-9A7F-7459-E034-0003BA12F5E7' PK_VAL FROM SBR.CS_ITEMS WHERE CSI_IDSEQ = 'D950FF11-9A7F-7459-E034-0003BA12F5E7';
SELECT PREFERRED_DEFINITION, 'SBR.CS_ITEMS' MyTable, 'CSI_IDSEQ' PK, 'D67A7FC0-A00B-202C-E034-0003BA12F5E7' PK_VAL FROM SBR.CS_ITEMS WHERE CSI_IDSEQ = 'D67A7FC0-A00B-202C-E034-0003BA12F5E7';
SELECT PREFERRED_NAME, 'SBR.CS_ITEMS' MyTable, 'CSI_IDSEQ' PK, '62A61C3F-59B5-C978-E040-BB89AD433A1E' PK_VAL FROM SBR.CS_ITEMS WHERE CSI_IDSEQ = '62A61C3F-59B5-C978-E040-BB89AD433A1E';
SELECT DESCRIPTION, 'SBR.CS_TYPES_LOV' MyTable, 'CSTL_NAME' PK, 'Publishing' PK_VAL FROM SBR.CS_TYPES_LOV WHERE CSTL_NAME = 'Publishing';
SELECT DESCRIPTION, 'SBR.DATATYPES_LOV' MyTable, 'DTL_NAME' PK, 'SVG' PK_VAL FROM SBR.DATATYPES_LOV WHERE DTL_NAME = 'SVG';
SELECT LONG_NAME, 'SBR.DATA_ELEMENTS' MyTable, 'DE_IDSEQ' PK, '99BA9DC8-3100-4E69-E034-080020C9C0E0' PK_VAL FROM SBR.DATA_ELEMENTS WHERE DE_IDSEQ = '99BA9DC8-3100-4E69-E034-080020C9C0E0';
SELECT PREFERRED_DEFINITION, 'SBR.DATA_ELEMENTS' MyTable, 'DE_IDSEQ' PK, '99BA9DC8-2754-4E69-E034-080020C9C0E0' PK_VAL FROM SBR.DATA_ELEMENTS WHERE DE_IDSEQ = '99BA9DC8-2754-4E69-E034-080020C9C0E0';
SELECT PREFERRED_NAME, 'SBR.DATA_ELEMENTS' MyTable, 'DE_IDSEQ' PK, '21D51BF7-FBCD-1D89-E044-0003BA3F9857' PK_VAL FROM SBR.DATA_ELEMENTS WHERE DE_IDSEQ = '21D51BF7-FBCD-1D89-E044-0003BA3F9857';
SELECT LONG_NAME, 'SBR.DATA_ELEMENT_CONCEPTS' MyTable, 'DEC_IDSEQ' PK, '99BA9DC8-44D7-4E69-E034-080020C9C0E0' PK_VAL FROM SBR.DATA_ELEMENT_CONCEPTS WHERE DEC_IDSEQ = '99BA9DC8-44D7-4E69-E034-080020C9C0E0';
SELECT PREFERRED_DEFINITION, 'SBR.DATA_ELEMENT_CONCEPTS' MyTable, 'DEC_IDSEQ' PK, '9E5F6F00-213A-1988-E034-080020C9C0E0' PK_VAL FROM SBR.DATA_ELEMENT_CONCEPTS WHERE DEC_IDSEQ = '9E5F6F00-213A-1988-E034-080020C9C0E0';
SELECT PREFERRED_NAME, 'SBR.DATA_ELEMENT_CONCEPTS' MyTable, 'DEC_IDSEQ' PK, '1B108005-0BDC-2583-E044-0003BA3F9857' PK_VAL FROM SBR.DATA_ELEMENT_CONCEPTS WHERE DEC_IDSEQ = '1B108005-0BDC-2583-E044-0003BA3F9857';
SELECT PROPL_NAME, 'SBR.DATA_ELEMENT_CONCEPTS' MyTable, 'DEC_IDSEQ' PK, 'B3190F58-660A-3704-E034-0003BA12F5E7' PK_VAL FROM SBR.DATA_ELEMENT_CONCEPTS WHERE DEC_IDSEQ = 'B3190F58-660A-3704-E034-0003BA12F5E7';
SELECT DEFINITION, 'SBR.DEFINITIONS' MyTable, 'DEFIN_IDSEQ' PK, '03FA4549-EA23-2537-E044-0003BA3F9857' PK_VAL FROM SBR.DEFINITIONS WHERE DEFIN_IDSEQ = '03FA4549-EA23-2537-E044-0003BA3F9857';
SELECT NAME, 'SBR.DESIGNATIONS' MyTable, 'DESIG_IDSEQ' PK, 'CFA8004C-6662-91E7-E040-BB89AD4343FD' PK_VAL FROM SBR.DESIGNATIONS WHERE DESIG_IDSEQ = 'CFA8004C-6662-91E7-E040-BB89AD4343FD';
SELECT DESCRIPTION, 'SBR.DESIGNATION_TYPES_LOV' MyTable, 'DETL_NAME' PK, 'OID, CTSU' PK_VAL FROM SBR.DESIGNATION_TYPES_LOV WHERE DETL_NAME = 'OID, CTSU';
SELECT FORML_NAME, 'SBR.FORMATS_LOV' MyTable, 'FORML_NAME' PK, '9.999' PK_VAL FROM SBR.FORMATS_LOV WHERE FORML_NAME = '9.999';
SELECT DESCRIPTION, 'SBR.GROUPS' MyTable, 'GRP_NAME' PK, 'TEST_FORM_BUILDER' PK_VAL FROM SBR.GROUPS WHERE GRP_NAME = 'TEST_FORM_BUILDER';
SELECT NAME, 'SBR.ORGANIZATIONS' MyTable, 'ORG_IDSEQ' PK, 'EF226B97-7F1F-1400-E034-0003BA3F9857' PK_VAL FROM SBR.ORGANIZATIONS WHERE ORG_IDSEQ = 'EF226B97-7F1F-1400-E034-0003BA3F9857';
SELECT MEANING_DESCRIPTION, 'SBR.PERMISSIBLE_VALUES' MyTable, 'PV_IDSEQ' PK, '99BA9DC8-4E1F-4E69-E034-080020C9C0E0' PK_VAL FROM SBR.PERMISSIBLE_VALUES WHERE PV_IDSEQ = '99BA9DC8-4E1F-4E69-E034-080020C9C0E0';
SELECT SHORT_MEANING, 'SBR.PERMISSIBLE_VALUES' MyTable, 'PV_IDSEQ' PK, 'D7F645D4-4D23-68AD-E034-0003BA12F5E7' PK_VAL FROM SBR.PERMISSIBLE_VALUES WHERE PV_IDSEQ = 'D7F645D4-4D23-68AD-E034-0003BA12F5E7';
SELECT VALUE, 'SBR.PERMISSIBLE_VALUES' MyTable, 'PV_IDSEQ' PK, '9B8825ED-D98C-0817-E034-080020C9C0E0' PK_VAL FROM SBR.PERMISSIBLE_VALUES WHERE PV_IDSEQ = '9B8825ED-D98C-0817-E034-080020C9C0E0';
SELECT DESCRIPTION, 'SBR.PROGRAM_AREAS_LOV' MyTable, 'PAL_NAME' PK, 'Other Govt Standards' PK_VAL FROM SBR.PROGRAM_AREAS_LOV WHERE PAL_NAME = 'Other Govt Standards';
SELECT DOC_TEXT, 'SBR.REFERENCE_DOCUMENTS' MyTable, 'RD_IDSEQ' PK, '9BFEB735-AC0A-4E99-E034-080020C9C0E0' PK_VAL FROM SBR.REFERENCE_DOCUMENTS WHERE RD_IDSEQ = '9BFEB735-AC0A-4E99-E034-080020C9C0E0';
SELECT NAME, 'SBR.REFERENCE_DOCUMENTS' MyTable, 'RD_IDSEQ' PK, '589E33E9-FC50-4A5A-E053-F662850A4DD3' PK_VAL FROM SBR.REFERENCE_DOCUMENTS WHERE RD_IDSEQ = '589E33E9-FC50-4A5A-E053-F662850A4DD3';
SELECT DESCRIPTION, 'SBR.RELATIONSHIPS_LOV' MyTable, 'RL_NAME' PK, 'ELEMENT_INSTRUCTION' PK_VAL FROM SBR.RELATIONSHIPS_LOV WHERE RL_NAME = 'ELEMENT_INSTRUCTION';
SELECT DESCRIPTION, 'SBR.SECURITY_CONTEXTS_LOV' MyTable, 'SCL_NAME' PK, 'TEST_SC' PK_VAL FROM SBR.SECURITY_CONTEXTS_LOV WHERE SCL_NAME = 'TEST_SC';
SELECT DESCRIPTION, 'SBR.UNIT_OF_MEASURES_LOV' MyTable, 'UOML_NAME' PK, 'Bq/g' PK_VAL FROM SBR.UNIT_OF_MEASURES_LOV WHERE UOML_NAME = 'Bq/g';
SELECT UOML_NAME, 'SBR.UNIT_OF_MEASURES_LOV' MyTable, 'UOML_NAME' PK, 'EU/Kg' PK_VAL FROM SBR.UNIT_OF_MEASURES_LOV WHERE UOML_NAME = 'EU/Kg';
SELECT NAME, 'SBR.USER_ACCOUNTS' MyTable, 'UA_NAME' PK, 'WILKENSL' PK_VAL FROM SBR.USER_ACCOUNTS WHERE UA_NAME = 'WILKENSL';
SELECT FORML_NAME, 'SBR.VALUE_DOMAINS' MyTable, 'VD_IDSEQ' PK, 'DB67BCB3-4C46-6E9A-E034-0003BA12F5E7' PK_VAL FROM SBR.VALUE_DOMAINS WHERE VD_IDSEQ = 'DB67BCB3-4C46-6E9A-E034-0003BA12F5E7';
SELECT LONG_NAME, 'SBR.VALUE_DOMAINS' MyTable, 'VD_IDSEQ' PK, '9E5AB971-8660-48F7-E034-080020C9C0E0' PK_VAL FROM SBR.VALUE_DOMAINS WHERE VD_IDSEQ = '9E5AB971-8660-48F7-E034-080020C9C0E0';
SELECT PREFERRED_DEFINITION, 'SBR.VALUE_DOMAINS' MyTable, 'VD_IDSEQ' PK, '99BA9DC8-22E1-4E69-E034-080020C9C0E0' PK_VAL FROM SBR.VALUE_DOMAINS WHERE VD_IDSEQ = '99BA9DC8-22E1-4E69-E034-080020C9C0E0';
SELECT PREFERRED_NAME, 'SBR.VALUE_DOMAINS' MyTable, 'VD_IDSEQ' PK, 'BFF123A5-B304-1C5B-E034-0003BA12F5E7' PK_VAL FROM SBR.VALUE_DOMAINS WHERE VD_IDSEQ = 'BFF123A5-B304-1C5B-E034-0003BA12F5E7';
SELECT UOML_NAME, 'SBR.VALUE_DOMAINS' MyTable, 'VD_IDSEQ' PK, '46251057-AE36-1A81-E044-0003BA3F9857' PK_VAL FROM SBR.VALUE_DOMAINS WHERE VD_IDSEQ = '46251057-AE36-1A81-E044-0003BA3F9857';
SELECT DESCRIPTION, 'SBR.VALUE_MEANINGS' MyTable, 'VM_IDSEQ' PK, '2509CE87-D4A3-5C23-E044-0003BA3F9857' PK_VAL FROM SBR.VALUE_MEANINGS WHERE VM_IDSEQ = '2509CE87-D4A3-5C23-E044-0003BA3F9857';
SELECT LONG_NAME, 'SBR.VALUE_MEANINGS' MyTable, 'VM_IDSEQ' PK, '2509CE88-07CB-5C23-E044-0003BA3F9857' PK_VAL FROM SBR.VALUE_MEANINGS WHERE VM_IDSEQ = '2509CE88-07CB-5C23-E044-0003BA3F9857';
SELECT PREFERRED_DEFINITION, 'SBR.VALUE_MEANINGS' MyTable, 'VM_IDSEQ' PK, '6B616F09-17E6-4E39-E040-BB89AD43186F' PK_VAL FROM SBR.VALUE_MEANINGS WHERE VM_IDSEQ = '6B616F09-17E6-4E39-E040-BB89AD43186F';
SELECT PREFERRED_NAME, 'SBR.VALUE_MEANINGS' MyTable, 'VM_IDSEQ' PK, '272F2F52-2E69-4EAB-E044-0003BA3F9857' PK_VAL FROM SBR.VALUE_MEANINGS WHERE VM_IDSEQ = '272F2F52-2E69-4EAB-E044-0003BA3F9857';
SELECT SHORT_MEANING, 'SBR.VALUE_MEANINGS' MyTable, 'VM_IDSEQ' PK, '588C741A-C542-280C-E053-F662850A227B' PK_VAL FROM SBR.VALUE_MEANINGS WHERE VM_IDSEQ = '588C741A-C542-280C-E053-F662850A227B';
SELECT DEFINITION_SOURCE, 'SBREXT.CONCEPTS_EXT' MyTable, 'CON_IDSEQ' PK, 'F37D0428-BAC8-6787-E034-0003BA3F9857' PK_VAL FROM SBREXT.CONCEPTS_EXT WHERE CON_IDSEQ = 'F37D0428-BAC8-6787-E034-0003BA3F9857';
SELECT LONG_NAME, 'SBREXT.CONCEPTS_EXT' MyTable, 'CON_IDSEQ' PK, 'F37D0428-D1A4-6787-E034-0003BA3F9857' PK_VAL FROM SBREXT.CONCEPTS_EXT WHERE CON_IDSEQ = 'F37D0428-D1A4-6787-E034-0003BA3F9857';
SELECT PREFERRED_DEFINITION, 'SBREXT.CONCEPTS_EXT' MyTable, 'CON_IDSEQ' PK, 'F37D0428-B760-6787-E034-0003BA3F9857' PK_VAL FROM SBREXT.CONCEPTS_EXT WHERE CON_IDSEQ = 'F37D0428-B760-6787-E034-0003BA3F9857';
SELECT PREFERRED_NAME, 'SBREXT.CONCEPTS_EXT' MyTable, 'CON_IDSEQ' PK, '750E3F18-3950-751A-E053-F662850A0077' PK_VAL FROM SBREXT.CONCEPTS_EXT WHERE CON_IDSEQ = '750E3F18-3950-751A-E053-F662850A0077';
SELECT DESCRIPTION, 'SBREXT.DEFINITION_TYPES_LOV_EXT' MyTable, 'DEFL_NAME' PK, 'WHO2002' PK_VAL FROM SBREXT.DEFINITION_TYPES_LOV_EXT WHERE DEFL_NAME = 'WHO2002';
SELECT DEFINITION_SOURCE, 'SBREXT.OBJECT_CLASSES_EXT' MyTable, 'OC_IDSEQ' PK, 'CC571B25-1D32-4065-E034-0003BA12F5E7' PK_VAL FROM SBREXT.OBJECT_CLASSES_EXT WHERE OC_IDSEQ = 'CC571B25-1D32-4065-E034-0003BA12F5E7';
SELECT LONG_NAME, 'SBREXT.OBJECT_CLASSES_EXT' MyTable, 'OC_IDSEQ' PK, 'DB6C8AC6-1B4F-3E75-E034-0003BA12F5E7' PK_VAL FROM SBREXT.OBJECT_CLASSES_EXT WHERE OC_IDSEQ = 'DB6C8AC6-1B4F-3E75-E034-0003BA12F5E7';
SELECT PREFERRED_DEFINITION, 'SBREXT.OBJECT_CLASSES_EXT' MyTable, 'OC_IDSEQ' PK, '3DC88065-CBB1-65BB-E044-0003BA3F9857' PK_VAL FROM SBREXT.OBJECT_CLASSES_EXT WHERE OC_IDSEQ = '3DC88065-CBB1-65BB-E044-0003BA3F9857';
SELECT PREFERRED_NAME, 'SBREXT.OBJECT_CLASSES_EXT' MyTable, 'OC_IDSEQ' PK, 'EA42FD24-B35D-66F8-E034-0003BA3F9857' PK_VAL FROM SBREXT.OBJECT_CLASSES_EXT WHERE OC_IDSEQ = 'EA42FD24-B35D-66F8-E034-0003BA3F9857';
SELECT LONG_NAME, 'SBREXT.OC_RECS_EXT' MyTable, 'OCR_IDSEQ' PK, '694379F9-9182-A3AD-E040-BB89AD436ADA' PK_VAL FROM SBREXT.OC_RECS_EXT WHERE OCR_IDSEQ = '694379F9-9182-A3AD-E040-BB89AD436ADA';
SELECT DEFINITION_SOURCE, 'SBREXT.PROPERTIES_EXT' MyTable, 'PROP_IDSEQ' PK, '2B98A16F-74C0-71B2-E044-0003BA3F9857' PK_VAL FROM SBREXT.PROPERTIES_EXT WHERE PROP_IDSEQ = '2B98A16F-74C0-71B2-E044-0003BA3F9857';
SELECT LONG_NAME, 'SBREXT.PROPERTIES_EXT' MyTable, 'PROP_IDSEQ' PK, 'BCFF845E-4E03-6994-E034-0003BA12F5E7' PK_VAL FROM SBREXT.PROPERTIES_EXT WHERE PROP_IDSEQ = 'BCFF845E-4E03-6994-E034-0003BA12F5E7';
SELECT PREFERRED_DEFINITION, 'SBREXT.PROPERTIES_EXT' MyTable, 'PROP_IDSEQ' PK, 'C77E9D04-26FC-3329-E040-BB89AD43594A' PK_VAL FROM SBREXT.PROPERTIES_EXT WHERE PROP_IDSEQ = 'C77E9D04-26FC-3329-E040-BB89AD43594A';
SELECT PREFERRED_NAME, 'SBREXT.PROPERTIES_EXT' MyTable, 'PROP_IDSEQ' PK, 'DE7DE01D-2542-E657-E040-BB89AD4356E9' PK_VAL FROM SBREXT.PROPERTIES_EXT WHERE PROP_IDSEQ = 'DE7DE01D-2542-E657-E040-BB89AD4356E9';
SELECT LONG_NAME, 'SBREXT.PROTOCOLS_EXT' MyTable, 'PROTO_IDSEQ' PK, 'EA0D24C6-B8A2-5AC3-E034-0003BA3F9857' PK_VAL FROM SBREXT.PROTOCOLS_EXT WHERE PROTO_IDSEQ = 'EA0D24C6-B8A2-5AC3-E034-0003BA3F9857';
SELECT PREFERRED_DEFINITION, 'SBREXT.PROTOCOLS_EXT' MyTable, 'PROTO_IDSEQ' PK, 'DA3EBC2E-60B5-2D3C-E034-0003BA12F5E7' PK_VAL FROM SBREXT.PROTOCOLS_EXT WHERE PROTO_IDSEQ = 'DA3EBC2E-60B5-2D3C-E034-0003BA12F5E7';
SELECT PREFERRED_NAME, 'SBREXT.PROTOCOLS_EXT' MyTable, 'PROTO_IDSEQ' PK, '33FAA9C4-FCF1-EFAD-E050-BB89AD430F83' PK_VAL FROM SBREXT.PROTOCOLS_EXT WHERE PROTO_IDSEQ = '33FAA9C4-FCF1-EFAD-E050-BB89AD430F83';
SELECT DESCRIPTION, 'SBREXT.QC_TYPE_LOV_EXT' MyTable, 'ROWID' PK, 'AAGKwcAAuAAAADjAAG' PK_VAL FROM SBREXT.QC_TYPE_LOV_EXT WHERE ROWID = 'AAGKwcAAuAAAADjAAG';
SELECT DESCRIPTION, 'SBREXT.QUALIFIER_LOV_EXT' MyTable, 'QUALIFIER_NAME' PK, 'Cataract' PK_VAL FROM SBREXT.QUALIFIER_LOV_EXT WHERE QUALIFIER_NAME = 'Cataract';
SELECT DEFAULT_VALUE, 'SBREXT.QUEST_ATTRIBUTES_EXT' MyTable, 'QUEST_IDSEQ' PK, '4D118176-1E47-5223-E053-F662850A1F8D' PK_VAL FROM SBREXT.QUEST_ATTRIBUTES_EXT WHERE QUEST_IDSEQ = '4D118176-1E47-5223-E053-F662850A1F8D';
SELECT LONG_NAME, 'SBREXT.QUEST_CONTENTS_EXT' MyTable, 'QC_IDSEQ' PK, '9CB6D1D2-A91C-34E4-E034-080020C9C0E0' PK_VAL FROM SBREXT.QUEST_CONTENTS_EXT WHERE QC_IDSEQ = '9CB6D1D2-A91C-34E4-E034-080020C9C0E0';
SELECT PREFERRED_DEFINITION, 'SBREXT.QUEST_CONTENTS_EXT' MyTable, 'QC_IDSEQ' PK, 'B4872926-4CD5-4610-E040-BB89AD435350' PK_VAL FROM SBREXT.QUEST_CONTENTS_EXT WHERE QC_IDSEQ = 'B4872926-4CD5-4610-E040-BB89AD435350';
SELECT PREFERRED_NAME, 'SBREXT.QUEST_CONTENTS_EXT' MyTable, 'QC_IDSEQ' PK, 'DAB2AAA8-0A90-252C-E034-0003BA12F5E7' PK_VAL FROM SBREXT.QUEST_CONTENTS_EXT WHERE QC_IDSEQ = 'DAB2AAA8-0A90-252C-E034-0003BA12F5E7';
SELECT DEFINITION_SOURCE, 'SBREXT.REPRESENTATIONS_EXT' MyTable, 'REP_IDSEQ' PK, '45C2CD83-1434-49F4-E053-F662850A023F' PK_VAL FROM SBREXT.REPRESENTATIONS_EXT WHERE REP_IDSEQ = '45C2CD83-1434-49F4-E053-F662850A023F';
SELECT LONG_NAME, 'SBREXT.REPRESENTATIONS_EXT' MyTable, 'REP_IDSEQ' PK, '35CB16D5-E2DA-5D4E-E050-BB89AD4344D5' PK_VAL FROM SBREXT.REPRESENTATIONS_EXT WHERE REP_IDSEQ = '35CB16D5-E2DA-5D4E-E050-BB89AD4344D5';
SELECT PREFERRED_DEFINITION, 'SBREXT.REPRESENTATIONS_EXT' MyTable, 'REP_IDSEQ' PK, '06674CCB-CED9-04A9-E044-0003BA3F9857' PK_VAL FROM SBREXT.REPRESENTATIONS_EXT WHERE REP_IDSEQ = '06674CCB-CED9-04A9-E044-0003BA3F9857';
SELECT PREFERRED_NAME, 'SBREXT.REPRESENTATIONS_EXT' MyTable, 'REP_IDSEQ' PK, '55B62667-03A3-609D-E053-F662850AC7EB' PK_VAL FROM SBREXT.REPRESENTATIONS_EXT WHERE REP_IDSEQ = '55B62667-03A3-609D-E053-F662850AC7EB';
SELECT DESCRIPTION, 'SBREXT.SOURCES_EXT' MyTable, 'ROWID' PK, 'AAGK7YAAuAAABkvAAV' PK_VAL FROM SBREXT.SOURCES_EXT WHERE ROWID = 'AAGK7YAAuAAABkvAAV';
SELECT SRC_NAME, 'SBREXT.SOURCES_EXT' MyTable, 'ROWID' PK, 'AAGK7YAAuAAABkxAAT' PK_VAL FROM SBREXT.SOURCES_EXT WHERE ROWID = 'AAGK7YAAuAAABkxAAT';
SELECT VALUE, 'SBREXT.TOOL_OPTIONS_EXT' MyTable, 'TOOL_IDSEQ' PK, '25256DD8-6181-6E8E-E044-0003BA3F9857' PK_VAL FROM SBREXT.TOOL_OPTIONS_EXT WHERE TOOL_IDSEQ = '25256DD8-6181-6E8E-E044-0003BA3F9857';


