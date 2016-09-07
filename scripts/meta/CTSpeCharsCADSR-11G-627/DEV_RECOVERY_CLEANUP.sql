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

merge into SBR.REFERENCE_DOCUMENTS t1
using (select *
from SBR.CT_REF_DOC_BKUP ) t2
on (t1.RD_IDSEQ = t2.RD_IDSEQ)
when matched then 
update set t1.NAME = t2.NAME,t1.DOC_TEXT = t2.DOC_TEXT;

merge into SBR.CD_VMS t1
using (select *
from SBR.CT_CD_VMS_BKUP ) t2
on (t1.CV_IDSEQ = t2.CV_IDSEQ)
when matched then 
update set t1.short_meaning = t2.short_meaning,t1.DESCRIPTION = t2.DESCRIPTION;


merge into SBR.VALUE_DOMAINS t1
using (select *
from SBR.CT_VALUE_DOMAINS_BKUP ) t2
on (t1.VD_IDSEQ = t2.VD_IDSEQ)
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition;

merge into SBR.VALUE_MEANINGS t1
using (select *
from SBR.CT_VALUE_MEANINGS_BKUP ) t2
on (t1.VM_IDSEQ = t2.VM_IDSEQ)
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition,
t1.short_meaning = t2.short_meaning,t1.DESCRIPTION = t2.DESCRIPTION;

merge into SBR.PERMISSIBLE_VALUES t1
using (select *
from SBR.CT_PERMISSIBLE_VALUES_BKUP ) t2
on (t1.PV_IDSEQ = t2.PV_IDSEQ)
when matched then 
update set t1.short_meaning = t2.short_meaning,t1.MEANING_DESCRIPTION = t2.MEANING_DESCRIPTION;



merge into SBREXT.PROPERTIES_EXT t1
using (select *
from SBREXT.CT_PROPERTIES_EXT_BKUP ) t2
on (t1.PROP_IDSEQ = t2.PROP_IDSEQ)
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition;


merge into SBREXT.QUEST_CONTENTS_EXT t1
using (select *
from SBREXT.CT_QUEST_CONTENTS_EXT_BKUP ) t2
on (t1.QC_IDSEQ = t2.QC_IDSEQ)
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition;


merge into SBREXT.VALID_VALUES_ATT_EXT t1
using (select *
from SBREXT.CT_VALID_VALUES_ATT_EXT_BKUP ) t2
on (t1.QC_IDSEQ = t2.QC_IDSEQ)
when matched then 
update set t1.MEANING_TEXT = t2.MEANING_TEXT,t1.DESCRIPTION_TEXT = t2.DESCRIPTION_TEXT;




delete from SBREXT.CT_PROPERTIES_EXT_BKUP;--
delete  from SBREXT.CT_QUEST_CONTENTS_EXT_BKUP;
delete  from SBREXT.CT_VALID_VALUES_ATT_EXT_BKUP ;--

delete from SBR.CT_PERMISSIBLE_VALUES_BKUP;
delete  from SBR.CT_VALUE_MEANINGS_BKUP;
delete from SBR.CT_VALUE_DOMAINS_BKUP;
delete from SBR.CT_CD_VMS_BKUP; --
delete from SBR.CT_REF_DOC_BKUP;


select QC_IDSEQ          ,
  MEANING_TEXT      ,  
  DATE_MODIFIED     ,
  SYSDATE,
  MODIFIED_BY       ,
  DESCRIPTION_TEXT
from SBREXT.VALID_VALUES_ATT_EXT 
where ((((instr(MEANING_TEXT ,'&'||'#')> 0  and instr(MEANING_TEXT ,';')> 0)
or INSTR(MEANING_TEXT,'&'||'gt;')>0 
or INSTR(MEANING_TEXT,'&'||'lt;')>0 
or  INSTR(MEANING_TEXT,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(MEANING_TEXT) not like'%¿%')
or
(((instr(DESCRIPTION_TEXT ,'&'||'#')> 0  and instr(DESCRIPTION_TEXT ,';')> 0)
or INSTR(DESCRIPTION_TEXT,'&'||'gt;')>0 
or INSTR(DESCRIPTION_TEXT,'&'||'lt;')>0 
or  INSTR(DESCRIPTION_TEXT,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(DESCRIPTION_TEXT) not like'%¿%'));





select CV_IDSEQ,
CD_IDSEQ            ,
SHORT_MEANING        ,
DESCRIPTION  ,
DATE_MODIFIED       ,
SYSDATE,
MODIFIED_BY         ,
VM_IDSEQ   
from SBR.CD_VMS 
where ((((instr(short_meaning ,'&'||'#')> 0  and instr(short_meaning ,';')> 0)
or INSTR(short_meaning,'&'||'gt;')>0 
or INSTR(short_meaning,'&'||'lt;')>0 
or  INSTR(short_meaning,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(short_meaning) not like'%¿%')
or
(((instr(DESCRIPTION ,'&'||'#')> 0  and instr(DESCRIPTION ,';')> 0)
or INSTR(DESCRIPTION,'&'||'gt;')>0 
or INSTR(DESCRIPTION,'&'||'lt;')>0 
or  INSTR(DESCRIPTION,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(DESCRIPTION) not like'%¿%'));


select
RD_IDSEQ,
ORG_IDSEQ    ,
AC_IDSEQ   ,
ACH_IDSEQ   ,
AR_IDSEQ      ,
NAME         ,
DOC_TEXT ,
DATE_MODIFIED       ,
SYSDATE,
MODIFIED_BY
from SBR.REFERENCE_DOCUMENTS

where ((((instr(NAME ,'&'||'#')> 0  and instr(NAME ,';')> 0)
or INSTR(NAME,'&'||'gt;')>0 
or INSTR(NAME,'&'||'lt;')>0 
or  INSTR(NAME,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(name) not like'%¿%')
or
(((instr(DOC_TEXT ,'&'||'#')> 0  and instr(NAME ,';')> 0)
or INSTR(DOC_TEXT,'&'||'gt;')>0 
or INSTR(DOC_TEXT,'&'||'lt;')>0 
or  INSTR(NAME,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(DOC_TEXT) not like'%¿%'))
and RD_IDSEQ not in (select distinct RD_IDSEQ from SBR.CT_REF_DOC_BKUP where comments='Duplicate') ;




select PV_IDSEQ            ,
VALUE               ,
SHORT_MEANING        ,
MEANING_DESCRIPTION  ,
DATE_MODIFIED       ,
SYSDATE,
MODIFIED_BY         ,
VM_IDSEQ   
from SBR.PERMISSIBLE_VALUES 
where ((((instr(short_meaning ,'&'||'#')> 0  and instr(short_meaning ,';')> 0)
or INSTR(short_meaning,'&'||'gt;')>0 
or INSTR(short_meaning,'&'||'lt;')>0 
or  INSTR(short_meaning,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(short_meaning) not like'%¿%')
or
(((instr(MEANING_DESCRIPTION ,'&'||'#')> 0  and instr(MEANING_DESCRIPTION ,';')> 0)
or INSTR(MEANING_DESCRIPTION,'&'||'gt;')>0 
or INSTR(MEANING_DESCRIPTION,'&'||'lt;')>0 
or  INSTR(MEANING_DESCRIPTION,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(MEANING_DESCRIPTION) not like'%¿%'));


select SHORT_MEANING        ,
  DESCRIPTION         ,
  DATE_MODIFIED        ,
  SYSDATE        ,
  MODIFIED_BY          ,  
  VM_IDSEQ              ,
  PREFERRED_NAME        ,
  PREFERRED_DEFINITION  ,
  LONG_NAME             ,
  VERSION              ,
  VM_ID                , 
  CHANGE_NOTE             
from SBR.VALUE_MEANINGS
where ((((instr(short_meaning ,'&'||'#')> 0  and instr(short_meaning ,';')> 0)
or INSTR(short_meaning,'&'||'gt;')>0 
or INSTR(short_meaning,'&'||'lt;')>0 
or  INSTR(short_meaning,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(short_meaning) not like'%¿%')
or
(((instr(DESCRIPTION ,'&'||'#')> 0  and instr(DESCRIPTION ,';')> 0)
or INSTR(DESCRIPTION,'&'||'gt;')>0 
or INSTR(DESCRIPTION,'&'||'lt;')>0 
or  INSTR(DESCRIPTION,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(DESCRIPTION) not like'%¿%'))
or((((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) not like'%¿%')
or
(((instr(preferred_definition ,'&'||'#')> 0  and instr(preferred_definition ,';')> 0)
or INSTR(preferred_definition,'&'||'gt;')>0 
or INSTR(preferred_definition,'&'||'lt;')>0 
or  INSTR(preferred_definition,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(preferred_definition) not like'%¿%'));


select     VD_IDSEQ   ,
           VD_ID ,
           VERSION ,                   
           PREFERRED_NAME,
           PREFERRED_DEFINITION,
           LONG_NAME,         
           DATE_MODIFIED, 
           SYSDATE    ,       
           MODIFIED_BY
from SBR.VALUE_DOMAINS
where ((((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) not like'%¿%')
or
(((instr(preferred_definition ,'&'||'#')> 0  and instr(preferred_definition ,';')> 0)
or INSTR(preferred_definition,'&'||'gt;')>0 
or INSTR(preferred_definition,'&'||'lt;')>0 
or  INSTR(preferred_definition,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(preferred_definition) not like'%¿%'));



select     QC_IDSEQ,                   
           PREFERRED_NAME,
           PREFERRED_DEFINITION,
           LONG_NAME,         
           DATE_MODIFIED, 
           SYSDATE    ,       
           MODIFIED_BY
from SBREXT.QUEST_CONTENTS_EXT
where ((((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) not like'%¿%')
or
(((instr(PREFERRED_DEFINITION ,'&'||'#')> 0  and instr(PREFERRED_DEFINITION ,';')> 0)
or INSTR(PREFERRED_DEFINITION,'&'||'gt;')>0 
or INSTR(PREFERRED_DEFINITION,'&'||'lt;')>0 
or  INSTR(PREFERRED_DEFINITION,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(PREFERRED_DEFINITION) not like'%¿%'));



select 
PROP_IDSEQ              ,
  PREFERRED_NAME        ,
  LONG_NAME            ,
  PREFERRED_DEFINITION  ,
  CONTE_IDSEQ           ,
  VERSION               ,
  ASL_NAME              ,  
  CHANGE_NOTE           ,
  DEFINITION_SOURCE     ,
  SYSDATE           ,
  DATE_MODIFIED        ,
  MODIFIED_BY          ,
  PROP_ID     
from SBREXT.PROPERTIES_EXT 
where ((((instr(LONG_NAME ,'&'||'#')> 0  and instr(LONG_NAME ,';')> 0)
or INSTR(LONG_NAME,'&'||'gt;')>0 
or INSTR(LONG_NAME,'&'||'lt;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(LONG_NAME) not like'%¿%')
or
(((instr(PREFERRED_DEFINITION ,'&'||'#')> 0  and instr(PREFERRED_DEFINITION ,';')> 0)
or INSTR(PREFERRED_DEFINITION,'&'||'gt;')>0 
or INSTR(PREFERRED_DEFINITION,'&'||'lt;')>0 
or  INSTR(PREFERRED_DEFINITION,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(PREFERRED_DEFINITION) not like'%¿%'));



select QC_IDSEQ          ,
  MEANING_TEXT      ,  
  DATE_MODIFIED     ,
  SYSDATE,
  MODIFIED_BY       ,
  DESCRIPTION_TEXT
from SBREXT.VALID_VALUES_ATT_EXT 
where ((((instr(MEANING_TEXT ,'&'||'#')> 0  and instr(MEANING_TEXT ,';')> 0)
or INSTR(MEANING_TEXT,'&'||'gt;')>0 
or INSTR(MEANING_TEXT,'&'||'lt;')>0 
or  INSTR(MEANING_TEXT,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(MEANING_TEXT) not like'%¿%')
or
(((instr(DESCRIPTION_TEXT ,'&'||'#')> 0  and instr(DESCRIPTION_TEXT ,';')> 0)
or INSTR(DESCRIPTION_TEXT,'&'||'gt;')>0 
or INSTR(DESCRIPTION_TEXT,'&'||'lt;')>0 
or  INSTR(DESCRIPTION_TEXT,'&'||'amp;')>0)
and  UTL_I18N.UNESCAPE_REFERENCE(DESCRIPTION_TEXT) not like'%¿%'));





