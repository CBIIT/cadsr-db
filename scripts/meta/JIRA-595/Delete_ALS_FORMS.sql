select count(*)
--delete
from 
VALID_VALUES_ATT_EXT  where QC_IDSEQ in(select QC_IDSEQ
from QUEST_CONTENTS_EXT 
where dn_crf_idseq in(select --*--q.qc_id,
q.qc_idseq 
from sbrext.quest_contents_ext q,
sbr.contexts c
where q.CONTE_IDSEQ=c.CONTE_IDSEQ
and c.NAME='TEST'
--and q.qc_id>666666
--and q.date_created>sysdate-40 
and q.CREATED_BY='CDEVALIDATE' 
and q.QTL_NAME='CRF'));

--select* from sbr.contexts
select count(*)
--select distinct *--dn_crf_idseq
--delete 
from sbrext.QUEST_CONTENTS_EXT 
where  dn_crf_idseq in (select q.qc_idseq from sbrext.quest_contents_ext q,
sbr.contexts c
where q.CONTE_IDSEQ=c.CONTE_IDSEQ
and c.NAME='TEST'
--and q.qc_id>666666
--and q.date_created>sysdate-40 
and q.CREATED_BY='CDEVALIDATE' 
and q.QTL_NAME='CRF')
and QTL_NAME='VALID_VALUE';






select count(*)
--delete 
--select count(*)
from  QUEST_ATTRIBUTES_EXT  where QC_IDSEQ in(select QC_IDSEQ
--select count(*)--*
from QUEST_CONTENTS_EXT 
where dn_crf_idseq in (select q.qc_idseq from sbrext.quest_contents_ext q,
sbr.contexts c
where q.CONTE_IDSEQ=c.CONTE_IDSEQ
and c.NAME='TEST'
--and q.qc_id>666666
--and q.date_created>sysdate-40 
and q.CREATED_BY='CDEVALIDATE' 
and q.QTL_NAME='CRF'));



select count(*)
--select distinct *--dn_crf_idseq
--delete 
from sbrext.QUEST_CONTENTS_EXT 
where  dn_crf_idseq in (select q.qc_idseq from sbrext.quest_contents_ext q,
sbr.contexts c
where q.CONTE_IDSEQ=c.CONTE_IDSEQ
and c.NAME='TEST'
--and q.qc_id>666666
--and q.date_created>sysdate-40 
and q.CREATED_BY='CDEVALIDATE' 
and q.QTL_NAME='CRF')
and QTL_NAME = 'QUESTION_INSTR';

select count(*)
--select distinct *--dn_crf_idseq
--delete 
from sbrext.QUEST_CONTENTS_EXT 
where  dn_crf_idseq in (select q.qc_idseq from sbrext.quest_contents_ext q,
sbr.contexts c
where q.CONTE_IDSEQ=c.CONTE_IDSEQ
and c.NAME='TEST'
--and q.qc_id>666666
--and q.date_created>sysdate-40 
and q.CREATED_BY='CDEVALIDATE' 
and q.QTL_NAME='CRF')
and QTL_NAME = 'QUESTION';


delete 
--select*
from sbrext.QUEST_CONTENTS_EXT 
where  dn_crf_idseq in ((select q.qc_idseq from sbrext.quest_contents_ext q,
sbr.contexts c
where q.CONTE_IDSEQ=c.CONTE_IDSEQ
and c.NAME='TEST'
--and q.qc_id>666666
--and q.date_created>sysdate-40 
and q.CREATED_BY='CDEVALIDATE' 
and q.QTL_NAME='CRF'))
and  QTL_NAME<>'CRF';


select *
--delete                                                                   --   delete 
 from  sbrext.PROTOCOL_QC_EXT   where QC_IDSEQ in
(select q.qc_idseq from sbrext.quest_contents_ext q,
sbr.contexts c
where q.CONTE_IDSEQ=c.CONTE_IDSEQ
and c.NAME='TEST'
--and q.qc_id>666666
--and q.date_created>sysdate-40 
and q.CREATED_BY='CDEVALIDATE' 
and q.QTL_NAME='CRF'
) ;

delete  
--select*
from QUEST_CONTENTS_EXT
where qc_idseq in (select q.qc_idseq from sbrext.quest_contents_ext q,
sbr.contexts c
where q.CONTE_IDSEQ=c.CONTE_IDSEQ
and c.NAME='TEST'
--and q.qc_id>666666
--and q.date_created>sysdate-40 
and q.CREATED_BY='CDEVALIDATE' 
and q.QTL_NAME='CRF');


