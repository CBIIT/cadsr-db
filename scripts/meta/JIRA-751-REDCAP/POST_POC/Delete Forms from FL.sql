select count(*)
--delete
from 
VALID_VALUES_ATT_EXT  where QC_IDSEQ in(select QC_IDSEQ
from QUEST_CONTENTS_EXT 
where dn_crf_idseq in(select q.qc_idseq from sbrext.quest_contents_ext q,
sbrext.PROTOCOL_QC_EXT pp,
sbrext.MSDREDCAP_FORM_CSV  rf,
sbrext.PROTOCOLS_EXT p
where rf.protocol=trim(p.preferred_name)
and q.QC_IDSEQ=pp.QC_IDSEQ
and p.PROTO_IDSEQ=pp.PROTO_IDSEQ
and load_seq=1
and q.date_created>sysdate-40 and q.date_created<sysdate-1 and q.CREATED_BY='FORMLOADER' 
and q.QTL_NAME='CRF'));


select count(*)
--select distinct *--dn_crf_idseq
--delete 
from sbrext.QUEST_CONTENTS_EXT 
where  dn_crf_idseq in (select q.qc_idseq from sbrext.quest_contents_ext q,
sbrext.PROTOCOL_QC_EXT pp,
sbrext.MSDREDCAP_FORM_CSV  rf,
sbrext.PROTOCOLS_EXT p
where rf.protocol=trim(p.preferred_name)
and q.QC_IDSEQ=pp.QC_IDSEQ
and p.PROTO_IDSEQ=pp.PROTO_IDSEQ
and load_seq=1
and q.date_created>sysdate-40 and q.date_created<sysdate-1 and q.CREATED_BY='FORMLOADER' 
and q.QTL_NAME='CRF')
and QTL_NAME='VALID_VALUE';






select count(*)
--delete 
--select count(*)
from  QUEST_ATTRIBUTES_EXT  where QC_IDSEQ in(select QC_IDSEQ
--select count(*)--*
from QUEST_CONTENTS_EXT 
where dn_crf_idseq in (select q.qc_idseq from sbrext.quest_contents_ext q,
sbrext.PROTOCOL_QC_EXT pp,
sbrext.MSDREDCAP_FORM_CSV  rf,
sbrext.PROTOCOLS_EXT p
where rf.protocol=trim(p.preferred_name)
and q.QC_IDSEQ=pp.QC_IDSEQ
and p.PROTO_IDSEQ=pp.PROTO_IDSEQ
and load_seq=1
and q.date_created>sysdate-40 --and q.date_created<sysdate-1 
and q.CREATED_BY='FORMLOADER' 
and q.QTL_NAME='CRF'
and q.qc_id=6729645));



select count(*)
--select distinct *--dn_crf_idseq
--delete 
from sbrext.QUEST_CONTENTS_EXT 
where  dn_crf_idseq in (select q.qc_idseq from sbrext.quest_contents_ext q,
sbrext.PROTOCOL_QC_EXT pp,
sbrext.MSDREDCAP_FORM_CSV  rf,
sbrext.PROTOCOLS_EXT p
where rf.protocol=trim(p.preferred_name)
and q.QC_IDSEQ=pp.QC_IDSEQ
and p.PROTO_IDSEQ=pp.PROTO_IDSEQ
and load_seq=1
and q.date_created>sysdate-40 --and q.date_created<sysdate-1 
and q.CREATED_BY='FORMLOADER' 
and q.QTL_NAME='CRF')
and QTL_NAME = 'QUESTION_INSTR';

select count(*)
--select distinct *--dn_crf_idseq
--delete 
from sbrext.QUEST_CONTENTS_EXT 
where  dn_crf_idseq in (select q.qc_idseq from sbrext.quest_contents_ext q,
sbrext.PROTOCOL_QC_EXT pp,
sbrext.MSDREDCAP_FORM_CSV  rf,
sbrext.PROTOCOLS_EXT p
where rf.protocol=trim(p.preferred_name)
and q.QC_IDSEQ=pp.QC_IDSEQ
and p.PROTO_IDSEQ=pp.PROTO_IDSEQ
and load_seq=1
and q.date_created>sysdate-40 --and q.date_created<sysdate-1 
and q.CREATED_BY='FORMLOADER' 
and q.QTL_NAME='CRF')
and QTL_NAME = 'QUESTION';


delete 
--select*
from sbrext.QUEST_CONTENTS_EXT 
where  dn_crf_idseq in (select q.qc_idseq 
from sbrext.quest_contents_ext q,
sbrext.PROTOCOL_QC_EXT pp,
sbrext.MSDREDCAP_FORM_CSV  rf,
sbrext.PROTOCOLS_EXT p
where rf.protocol=trim(p.preferred_name)
and q.QC_IDSEQ=pp.QC_IDSEQ
and p.PROTO_IDSEQ=pp.PROTO_IDSEQ
and load_seq=1
and q.date_created>sysdate-40 --and q.date_created<sysdate-1 
and q.CREATED_BY='FORMLOADER' 
and q.QTL_NAME='CRF')
and  QTL_NAME<>'CRF';


select *
--delete                                                                   --   delete 
 from  sbrext.PROTOCOL_QC_EXT   where QC_IDSEQ in
(select q.QC_IDSEQ
---select *
from sbrext.quest_contents_ext q,
sbrext.PROTOCOL_QC_EXT pp,
sbrext.MSDREDCAP_FORM_CSV  rf,
sbrext.PROTOCOLS_EXT p
where rf.protocol=trim(p.preferred_name)
and q.QC_IDSEQ=pp.QC_IDSEQ
and p.PROTO_IDSEQ=pp.PROTO_IDSEQ
and load_seq=1
and q.date_created>sysdate-40 --and --q.date_created<sysdate-1 
and q.CREATED_BY='FORMLOADER' 
and q.QTL_NAME='CRF'
) ;

delete  
--select*
from QUEST_CONTENTS_EXT
where qc_idseq in (select q.qc_idseq from sbrext.quest_contents_ext q,
sbrext.MSDREDCAP_FORM_CSV  rf
where  load_seq=1
and q.date_created>sysdate-40 --and q.date_created<sysdate-1 
and instr(rf.form_name_new,trim(q.long_name))>0
and q.CREATED_BY='FORMLOADER' 
and q.QTL_NAME='CRF');


