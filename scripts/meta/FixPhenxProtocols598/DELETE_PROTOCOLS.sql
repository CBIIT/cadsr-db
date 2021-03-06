set serveroutput on size 1000000
SPOOL cadsrmeta-598d.log
delete from SBREXT.PROTOCOL_QC_EXT where  PROTO_IDSEQ in(select PROTO_IDSEQ  from protocols_ext where preferred_name like 'PX%');
delete from SBREXT.protocols_ext where preferred_name like 'PX%';
delete from SBR.ADMINISTERED_COMPONENTS where ACTL_NAME='PROTOCOL' and PREFERRED_NAME like 'PX%';
commit;
delete from SBREXT.protocols_EXT_TEMP;
delete from SBREXT.PROTOCOLS_EXT_ERROR_LOG;
commit;
rename PROTOCOLS_EXT_ERROR_LOG to MDSR_PROTOCOLS_ERR_LOG;
rename protocols_EXT_TEMP to MDSR_PROTOCOLS_TEMP;
CREATE OR REPLACE PUBLIC SYNONYM CT_PROPERTIES_EXT_BKUP FOR SBREXT.CT_PROPERTIES_EXT_BKUP;
CREATE OR REPLACE PUBLIC SYNONYM CT_REPRESENTATIONS_EXT_BKUP FOR SBREXT.CT_REPRESENTATIONS_EXT_BKUP;
CREATE OR REPLACE PUBLIC SYNONYM CT_OBJECT_CLASSES_EXT_BKUP FOR SBREXT.CT_OBJECT_CLASSES_EXT_BKUP;
CREATE OR REPLACE PUBLIC SYNONYM CT_VALID_VALUES_ATT_EXT_BKUP FOR SBREXT.CT_VALID_VALUES_ATT_EXT_BKUP;
CREATE OR REPLACE PUBLIC SYNONYM META_SPCHAR_ERROR_LOG FOR SBREXT.META_SPCHAR_ERROR_LOG;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_PROTOCOLS_TEMP FOR SBREXT.MDSR_PROTOCOLS_TEMP;
CREATE OR REPLACE PUBLIC SYNONYM MDSR_PROTOCOLS_ERR_LOG FOR SBREXT.MDSR_PROTOCOLS_ERR_LOG;
GRANT SELECT ON CT_PROPERTIES_EXT_BKUP TO PUBLIC;
GRANT SELECT ON CT_REPRESENTATIONS_EXT_BKUP TO PUBLIC;
GRANT SELECT ON CT_OBJECT_CLASSES_EXT_BKUP TO PUBLIC;
GRANT SELECT ON CT_VALID_VALUES_ATT_EXT_BKUP TO PUBLIC;
GRANT SELECT ON META_SPCHAR_ERROR_LOG TO PUBLIC;
GRANT SELECT ON MDSR_PROTOCOLS_TEMP TO PUBLIC;
GRANT SELECT ON MDSR_PROTOCOLS_ERR_LOG TO PUBLIC;
SPOOL OFF