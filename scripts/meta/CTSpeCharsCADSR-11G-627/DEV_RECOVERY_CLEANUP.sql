create database link SBREXT_QA_db_link 
connect to SBREXT 
identified by osrqa528 
using '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=ncidb-q110-d.nci.nih.gov)(PORT=1551))(CONNECT_DATA=(SID=DSRQA)))';

create database link SBR_QA_db_link 
connect to SBR
identified by osrqa528 
using '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=ncidb-q110-d.nci.nih.gov)(PORT=1551))(CONNECT_DATA=(SID=DSRQA)))';


select distinct PROP_IDSEQ from SBREXT.CT_PROPERTIES_EXT_BKUP;--
select   QC_IDSEQ from SBREXT.CT_QUEST_CONTENTS_EXT_BKUP;
select distinct QC_IDSEQ  from SBREXT.CT_VALID_VALUES_ATT_EXT_BKUP order by QC_IDSEQ ;--

select distinct PV_IDSEQ from SBR.CT_PERMISSIBLE_VALUES_BKUP;
select   distinct VM_IDSEQ from SBR.CT_VALUE_MEANINGS_BKUP;
select  Vd_IDSEQ from SBR.CT_VALUE_DOMAINS_BKUP;
select   CV_IDSEQ from SBR.CT_CD_VMS_BKUP; --
select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP;--


insert into SBREXT.CT_PROPERTIES_EXT_BKUP select * from SBREXT.CT_PROPERTIES_EXT_BKUP@SBREXT_QA_db_link;
insert into SBREXT.CT_QUEST_CONTENTS_EXT_BKUP select*from SBREXT.CT_QUEST_CONTENTS_EXT_BKUP@SBREXT_QA_db_link;
insert into SBREXT.CT_VALID_VALUES_ATT_EXT_BKUP select*from SBREXT.CT_VALID_VALUES_ATT_EXT_BKUP@SBREXT_QA_db_link;

insert into SBR.CT_PERMISSIBLE_VALUES_BKUP select*from SBR.CT_PERMISSIBLE_VALUES_BKUP@SBR_QA_db_link;
insert into SBR.CT_VALUE_MEANINGS_BKUP select*from SBR.CT_VALUE_MEANINGS_BKUP@SBR_QA_db_link;
insert into SBR.CT_VALUE_DOMAINS_BKUP select*from SBR.CT_VALUE_DOMAINS_BKUP@SBR_QA_db_link;
insert into SBR.CT_CD_VMS_BKUP select*from SBR.CT_CD_VMS_BKUP@SBR_QA_db_link;
insert into SBR.CT_REF_DOC_BKUP select*from SBR.CT_REF_DOC_BKUP@SBR_QA_db_link;