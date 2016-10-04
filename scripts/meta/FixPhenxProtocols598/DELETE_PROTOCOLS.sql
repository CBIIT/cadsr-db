delete from SBREXT.PROTOCOL_QC_EXT where  PROTO_IDSEQ in(select PROTO_IDSEQ  from protocols_ext where preferred_name like 'PX%') ;
delete from SBREXT.protocols_ext where preferred_name like 'PX%';
delete from SBREXT.protocols_EXT_TEMP;
delete from SBREXT.PROTOCOLS_EXT_ERROR_LOG;
delete from SBR.ADMINISTERED_COMPONENTS where ACTL_NAME='PROTOCOL' and PREFERRED_NAME like 'PX%'