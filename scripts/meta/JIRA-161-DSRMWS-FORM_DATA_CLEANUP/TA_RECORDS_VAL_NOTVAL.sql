select distinct T_QTL_NAME from sbrext.TRIGGERED_ACTIONS_EXT ;
select distinct S_QTL_NAME from sbrext.TRIGGERED_ACTIONS_EXT ;
--ALL Valid RECORDS for MODULES,QUESTIONS,VALID_VALUES in QUEST_CONTENTS_EXT
select count(*)from 
(select * from sbrext.quest_contents_ext MQV where mqv.qtl_name in('MODULE','QUESTION','VALID_VALUE'))ALL_MQV,
(select m.qc_idseq from sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f where f.qc_idseq=m.dn_crf_idseq
and f.qtl_name in('CRF','TEMPLATE')and m.qtl_name = 'MODULE'
UNION
select q.qc_idseq from sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq and q.P_MOD_IDSEQ=m.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE' and q.qtl_name = 'QUESTION'
UNION
select vv.qc_idseq from sbrext.quest_contents_ext vv,
sbrext.quest_contents_ext q,sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f where f.qc_idseq=m.dn_crf_idseq 
and q.P_MOD_IDSEQ=m.QC_IDSEQ and vv.P_QST_IDSEQ=q.QC_IDSEQ 
and f.qtl_name in('CRF','TEMPLATE') and m.qtl_name = 'MODULE' 
and q.qtl_name = 'QUESTION' and vv.qtl_name = 'VALID_VALUE')GOOD
where ALL_MQV.QC_idseq=GOOD.QC_IDSEQ(+)
and GOOD.QC_IDSEQ is null;


--Invalid TRIGGERED_ACTIONS_EXT records
select count(*) from(
select * FROM sbrext.TRIGGERED_ACTIONS_EXT TA,
(select ALL_MQV.* from sbrext.quest_contents_ext ALL_MQV ,
(select m.qc_idseq from sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f where f.qc_idseq=m.dn_crf_idseq
and f.qtl_name in('CRF','TEMPLATE')and m.qtl_name = 'MODULE'
UNION
select q.qc_idseq from sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq and q.P_MOD_IDSEQ=m.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE' and q.qtl_name = 'QUESTION'
UNION
select vv.qc_idseq from sbrext.quest_contents_ext vv,
sbrext.quest_contents_ext q,sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f where f.qc_idseq=m.dn_crf_idseq 
and q.P_MOD_IDSEQ=m.QC_IDSEQ and vv.P_QST_IDSEQ=q.QC_IDSEQ 
and f.qtl_name in('CRF','TEMPLATE') and m.qtl_name = 'MODULE' 
and q.qtl_name = 'QUESTION' and vv.qtl_name = 'VALID_VALUE')GOOD
where ALL_MQV.QC_idseq=GOOD.QC_IDSEQ(+)
and GOOD.QC_IDSEQ is null
and ALL_MQV.qtl_name in('MODULE','QUESTION','VALID_VALUE')) INVAL 
where TA.T_QC_IDSEQ=INVAL.QC_IDSEQ --Invalid target
UNION
select * FROM sbrext.TRIGGERED_ACTIONS_EXT TA,
(select ALL_MQV.* from sbrext.quest_contents_ext ALL_MQV ,
(select m.qc_idseq from sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f where f.qc_idseq=m.dn_crf_idseq
and f.qtl_name in('CRF','TEMPLATE')and m.qtl_name = 'MODULE'
UNION
select q.qc_idseq from sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq and q.P_MOD_IDSEQ=m.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE' and q.qtl_name = 'QUESTION'
UNION
select vv.qc_idseq from sbrext.quest_contents_ext vv,
sbrext.quest_contents_ext q,sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f where f.qc_idseq=m.dn_crf_idseq 
and q.P_MOD_IDSEQ=m.QC_IDSEQ and vv.P_QST_IDSEQ=q.QC_IDSEQ 
and f.qtl_name in('CRF','TEMPLATE') and m.qtl_name = 'MODULE' 
and q.qtl_name = 'QUESTION' and vv.qtl_name = 'VALID_VALUE')GOOD
where ALL_MQV.QC_idseq=GOOD.QC_IDSEQ(+)
and GOOD.QC_IDSEQ is null
and ALL_MQV.qtl_name in('MODULE','QUESTION','VALID_VALUE')) INVAL 
where TA.S_QC_IDSEQ=INVAL.QC_IDSEQ) --Invalid source
;
---Valid 328 records to be migrated
select  count(*) b from sbrext.TRIGGERED_ACTIONS_EXT ta,
(select m.qc_idseq from sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f where f.qc_idseq=m.dn_crf_idseq
and f.qtl_name in('CRF','TEMPLATE')and m.qtl_name = 'MODULE'
UNION
select q.qc_idseq from sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq and q.P_MOD_IDSEQ=m.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE'and q.qtl_name = 'QUESTION'
UNION
select vv.qc_idseq from sbrext.quest_contents_ext vv,
sbrext.quest_contents_ext q,sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f 
where f.qc_idseq=m.dn_crf_idseq and q.P_MOD_IDSEQ=m.QC_IDSEQ
and vv.P_QST_IDSEQ=q.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')and m.qtl_name = 'MODULE'
and q.qtl_name = 'QUESTION'and vv.qtl_name = 'VALID_VALUE') s,
(select m.qc_idseq from sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f where f.qc_idseq=m.dn_crf_idseq
and f.qtl_name in('CRF','TEMPLATE')and m.qtl_name = 'MODULE'
UNION
select q.qc_idseq from sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq and q.P_MOD_IDSEQ=m.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE' and q.qtl_name = 'QUESTION'
UNION
select vv.qc_idseq from sbrext.quest_contents_ext vv,
sbrext.quest_contents_ext q,sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f where f.qc_idseq=m.dn_crf_idseq 
and q.P_MOD_IDSEQ=m.QC_IDSEQ and vv.P_QST_IDSEQ=q.QC_IDSEQ 
and f.qtl_name in('CRF','TEMPLATE') and m.qtl_name = 'MODULE' 
and q.qtl_name = 'QUESTION' and vv.qtl_name = 'VALID_VALUE') t
where S_QC_IDSEQ =s.qc_idseq and  T_QC_IDSEQ=t.qc_idseq;