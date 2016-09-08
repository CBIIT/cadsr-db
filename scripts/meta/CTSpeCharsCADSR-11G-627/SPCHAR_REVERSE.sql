merge into SBR.PERMISSIBLE_VALUES t1
using (select PV_IDSEQ,short_meaning,MEANING_DESCRIPTION,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY PV_IDSEQ) AS maxdate,DATE_INSERT,PV_IDSEQ,short_meaning,MEANING_DESCRIPTION from SBR.CT_PERMISSIBLE_VALUES_BKUP)
where maxdate=DATE_INSERT ) t2
on (t1.PV_IDSEQ = t2.PV_IDSEQ)
when matched then 
update set t1.short_meaning = t2.short_meaning,t1.MEANING_DESCRIPTION = t2.MEANING_DESCRIPTION;
/*merge into SBR.PERMISSIBLE_VALUES t1
using (select *
from SBR.CT_PERMISSIBLE_VALUES_BKUP ) t2
on (t1.PV_IDSEQ = t2.PV_IDSEQ)
when matched then 
update set t1.short_meaning = t2.short_meaning,t1.MEANING_DESCRIPTION = t2.MEANING_DESCRIPTION;

select PV_IDSEQ,short_meaning,MEANING_DESCRIPTION,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY PV_IDSEQ) AS maxdate,DATE_INSERT,PV_IDSEQ,short_meaning,MEANING_DESCRIPTION from SBR.CT_PERMISSIBLE_VALUES_BKUP)
where maxdate=DATE_INSERT;*/

merge into SBR.VALUE_MEANINGS t1
using (select VM_IDSEQ,LONG_NAME,preferred_definition,SHORT_MEANING ,DESCRIPTION,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY VM_IDSEQ) AS maxdate,DATE_INSERT,VM_IDSEQ,LONG_NAME,preferred_definition,
SHORT_MEANING ,DESCRIPTION from SBR.CT_VALUE_MEANINGS_BKUP)
where maxdate=DATE_INSERT ) t2
on (t1.VM_IDSEQ = t2.VM_IDSEQ)
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition,
t1.short_meaning = t2.short_meaning,t1.DESCRIPTION = t2.DESCRIPTION;
/*
merge into SBR.VALUE_MEANINGS t1
using (select *from SBR.CT_VALUE_MEANINGS_BKUP ) t2
on (t1.VM_IDSEQ = t2.VM_IDSEQ)
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition,
t1.short_meaning = t2.short_meaning,t1.DESCRIPTION = t2.DESCRIPTION;


select VM_IDSEQ,LONG_NAME,preferred_definition,SHORT_MEANING ,DESCRIPTION,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY VM_IDSEQ) AS maxdate,DATE_INSERT,VM_IDSEQ,LONG_NAME,preferred_definition,
SHORT_MEANING ,DESCRIPTION from SBR.CT_VALUE_MEANINGS_BKUP)
where maxdate=DATE_INSERT;*/

merge into SBR.VALUE_DOMAINS t1
using (select VD_IDSEQ,LONG_NAME,preferred_definition,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY VD_IDSEQ) AS maxdate,DATE_INSERT,VD_IDSEQ,LONG_NAME,preferred_definition from SBR.CT_VALUE_DOMAINS_BKUP)
where maxdate=DATE_INSERT ) t2
on (t1.VD_IDSEQ = t2.VD_IDSEQ)
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition;

/*merge into SBR.VALUE_DOMAINS t1
using (select *
from SBR.CT_VALUE_DOMAINS_BKUP ) t2
on (t1.VD_IDSEQ = t2.VD_IDSEQ)
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition;


select VD_IDSEQ,LONG_NAME,preferred_definition,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY VD_IDSEQ) AS maxdate,DATE_INSERT,VD_IDSEQ,LONG_NAME,preferred_definition from SBR.CT_VALUE_DOMAINS_BKUP)
where maxdate=DATE_INSERT;*/




merge into SBR.DATA_ELEMENT_CONCEPTS t1
using (select DEC_IDSEQ ,LONG_NAME,preferred_definition,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY DEC_IDSEQ ) AS maxdate,DATE_INSERT,DEC_IDSEQ ,LONG_NAME,preferred_definition from SBR.CT_DATA_ELEMENT_CONCEPTS_BKUP)
where maxdate=DATE_INSERT ) t2
on (t1.DEC_IDSEQ  = t2.DEC_IDSEQ )
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition;/*merge into SBR.DATA_ELEMENT_CONCEPTS t1
using (select *
from SBR.CT_DATA_ELEMENT_CONCEPTS_BKUP ) t2
on (t1.DEC_IDSEQ  = t2.DEC_IDSEQ )
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition;


select DEC_IDSEQ ,LONG_NAME,preferred_definition,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY DEC_IDSEQ ) AS maxdate,DATE_INSERT,DEC_IDSEQ ,LONG_NAME,preferred_definition from SBR.CT_DATA_ELEMENT_CONCEPTS_BKUP)
where maxdate=DATE_INSERT;*/

merge into SBR.DATA_ELEMENTS t1
using (select DE_IDSEQ ,LONG_NAME,preferred_definition,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY DE_IDSEQ ) AS maxdate,DATE_INSERT,DE_IDSEQ ,LONG_NAME,preferred_definition from SBR.CT_DATA_ELEMENTS_BKUP)
where maxdate=DATE_INSERT ) t2
on (t1.DEC_IDSEQ  = t2.DEC_IDSEQ )
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition;
/*select DE_IDSEQ ,LONG_NAME,preferred_definition,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY DE_IDSEQ ) AS maxdate,DATE_INSERT,DE_IDSEQ ,LONG_NAME,preferred_definition from SBR.CT_DATA_ELEMENTS_BKUP)
where maxdate=DATE_INSERT*/
merge into SBR.REFERENCE_DOCUMENTS t1
using (select RD_IDSEQ,NAME,DOC_TEXT,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY RD_IDSEQ) AS maxdate,DATE_INSERT,RD_IDSEQ,NAME,DOC_TEXT from SBR.CT_REF_DOC_BKUP)
where maxdate=DATE_INSERT ) t2
on (t1.RD_IDSEQ = t2.RD_IDSEQ)
when matched then 
update set t1.NAME = t2.NAME,t1.DOC_TEXT = t2.DOC_TEXT;

/*merge into SBR.REFERENCE_DOCUMENTS t1
using (select *
from SBR.CT_REF_DOC_BKUP ) t2
on (t1.RD_IDSEQ = t2.RD_IDSEQ)
when matched then 
update set t1.NAME = t2.NAME,t1.DOC_TEXT = t2.DOC_TEXT;


select RD_IDSEQ,NAME,DOC_TEXT,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY RD_IDSEQ) AS maxdate,DATE_INSERT,RD_IDSEQ,NAME,DOC_TEXT from SBR.CT_REF_DOC_BKUP)
where maxdate=DATE_INSERT;*/

merge into SBR.CD_VMS t1
using (select CV_IDSEQ,short_meaning,DESCRIPTION,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY CV_IDSEQ) AS maxdate,DATE_INSERT,CV_IDSEQ,short_meaning,DESCRIPTION from SBR.CT_CD_VMS_BKUP)
where maxdate=DATE_INSERT ) t2
on (t1.CV_IDSEQ = t2.CV_IDSEQ)
when matched then 
update set t1.short_meaning = t2.short_meaning,t1.DESCRIPTION = t2.DESCRIPTION;
/*
merge into SBR.CD_VMS t1
using (select *
from SBR.CT_CD_VMS_BKUP ) t2
on (t1.CV_IDSEQ = t2.CV_IDSEQ)
when matched then 
update set t1.short_meaning = t2.short_meaning,t1.DESCRIPTION = t2.DESCRIPTION;

select CV_IDSEQ,short_meaning,DESCRIPTION,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY CV_IDSEQ) AS maxdate,DATE_INSERT,CV_IDSEQ,short_meaning,DESCRIPTION from SBR.CT_CD_VMS_BKUP)
where maxdate=DATE_INSERT;*/

merge into SBREXT.QUEST_CONTENTS_EXT t1
using (select *
from SBREXT.CT_QUEST_CONTENTS_EXT_BKUP ) t2
on (t1.QC_IDSEQ = t2.QC_IDSEQ)
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition;

/*select QC_IDSEQ,LONG_NAME,preferred_definition,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY QC_IDSEQ) AS maxdate,DATE_INSERT,QC_IDSEQ,LONG_NAME,preferred_definition from SBREXT.CT_QUEST_CONTENTS_EXT_BKUP P)
where maxdate=DATE_INSERT;


merge into SBREXT.QUEST_CONTENTS_EXT t1
using (select QC_IDSEQ,LONG_NAME,preferred_definition,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY QC_IDSEQ) AS maxdate,DATE_INSERT,QC_IDSEQ,LONG_NAME,preferred_definition from SBREXT.CT_QUEST_CONTENTS_EXT_BKUP P)
where maxdate=DATE_INSERT ) t2
on (t1.QC_IDSEQ = t2.QC_IDSEQ)
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition;*/
merge into SBREXT.OBJECT_CLASSES_EXT t1
using (select  OC_IDSEQ ,LONG_NAME,preferred_definition,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY  OC_IDSEQ ) AS maxdate,DATE_INSERT, OC_IDSEQ ,LONG_NAME,preferred_definition from SBREXT.CT_OBJECT_CLASSES_EXT_BKUP)
where maxdate=DATE_INSERT ) t2
on (t1.OC_IDSEQ  = t2.OC_IDSEQ )
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition;

/*merge into SBREXT.OBJECT_CLASSES_EXT t1
using (select *
from SBREXT.CT_OBJECT_CLASSES_EXT_BKUP ) t2
on (t1.OC_IDSEQ  = t2. OC_IDSEQ )
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition;

select  OC_IDSEQ ,LONG_NAME,preferred_definition,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY  OC_IDSEQ ) AS maxdate,DATE_INSERT, OC_IDSEQ ,LONG_NAME,preferred_definition from SBREXT.CT_OBJECT_CLASSES_EXT_BKUP)
where maxdate=DATE_INSERT*/


merge into SBREXT.REPRESENTATIONS_EXT t1
using (select  REP_IDSEQ ,LONG_NAME,preferred_definition,maxdate,DATE_INSERT from(
select max(DATE_INSERT)OVER (PARTITION BY REP_IDSEQ ) AS maxdate,DATE_INSERT, REP_IDSEQ ,LONG_NAME,preferred_definition from SBREXT.CT_REPRESENTATIONS_EXT_BKUP)
where maxdate=DATE_INSERT ) t2
on (t1.REP_IDSEQ  = t2.REP_IDSEQ )
when matched then 
update set t1.LONG_NAME = t2.LONG_NAME,t1.preferred_definition = t2.preferred_definition;