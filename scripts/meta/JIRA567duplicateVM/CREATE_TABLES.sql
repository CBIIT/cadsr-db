select count(*),name from CON_DERIVATION_RULES_EXT where CONDR_IDSEQ in(

select distinct VM.CONDR_IDSEQ from sbr.VALUE_MEANINGS VM)

group by name having count(*)>1

select*from concepts_ext

select  FIN_VM,vm_id,VM_IDSEQ,CONDR_IDSEQ
from (
select max(VM_ID) over (partition by NAME order by NAME ) as FIN_VM,VM_ID,VM_IDSEQ,NAME,vm.CONDR_IDSEQ
from 
SBR.VALUE_MEANINGS VM,
CON_DERIVATION_RULES_EXT CN
where   VM.CONDR_IDSEQ=CN.CONDR_IDSEQ
--UPPER(ASL_NAME) not like '%RETIRED%'
and VM.CONDR_IDSEQ='F37D0428-BBB6-6787-E034-0003BA3F9857'
and VM.CONDR_IDSEQ is not NULL


select * from 
desc CON_DERIVATION_RULES_EXT


CREATE TABLE SBREXT.MDSR_VM_DUP_REF
(
  FIN_VM                NUMBER,
  FIN_IDSEQ             VARCHAR2(36 BYTE),
  VM_ID                 NUMBER                 ,
  VM_IDSEQ              VARCHAR2(36 BYTE)       ,
  CONCEPTS_NAME         VARCHAR2(255 BYTE),
  LONG_NAME             VARCHAR2(255 BYTE),
  PREFERRED_DEFINITION  VARCHAR2(2000 BYTE),
  DATE_CREATED          DATE,
  RUN_NUMBER            NUMBER,
  DES                   VARCHAR2(10 BYTE),
  DEFN                  VARCHAR2(10 BYTE),
  DES_CL                VARCHAR2(10 BYTE),
  DEFN_CL               VARCHAR2(10 BYTE),
  PROC                  VARCHAR2(10 BYTE)
)

CREATE TABLE SBREXT.MDSR_DUP_VM_ERR
(
  SP_NAME       CHAR(36 BYTE),
  TABLE_NAME    CHAR(50 BYTE),
  BLOCK_NAME    CHAR(80 BYTE),
  IDSEQ         CHAR(80 BYTE),
  PULICK_ID     CHAR(2000 BYTE),
  ERROR_TEXT    VARCHAR2(2000 BYTE),
  DATE_CREATED  DATE
)


select*from SBREXT.MDSR_VM_DUP_REF 