--QUEST_VV_EXT
--218296 records to be migrated 218296
select count(*) from  sbrext.QUEST_VV_EXT QV,
(select QVQ.* from sbrext.QUEST_VV_EXT QVQ,
(select q.qc_idseq from sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq and q.P_MOD_IDSEQ=m.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE' and q.qtl_name = 'QUESTION') GOOD
where QVQ.QUEST_IDSEQ=GOOD.QC_IDSEQ(+)
and GOOD.QC_IDSEQ is null
UNION
select QVQ.* from sbrext.QUEST_VV_EXT QVQ,
(select vv.qc_idseq from sbrext.quest_contents_ext vv,
sbrext.quest_contents_ext q,sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f where f.qc_idseq=m.dn_crf_idseq 
and q.P_MOD_IDSEQ=m.QC_IDSEQ and vv.P_QST_IDSEQ=q.QC_IDSEQ 
and f.qtl_name in('CRF','TEMPLATE') and m.qtl_name = 'MODULE' 
and q.qtl_name = 'QUESTION' and vv.qtl_name = 'VALID_VALUE') GOOD
where QVQ.VV_IDSEQ=GOOD.QC_IDSEQ(+)
and GOOD.QC_IDSEQ is null
and QVQ.VV_IDSEQ IS NOT NULL) NOT_VAL
WHERE QV.QV_IDSEQ=NOT_VAL.QV_IDSEQ(+)
and NOT_VAL.QV_IDSEQ is null;

--INVALID
select*from QUEST_VV_EXT;

select count(*) from (
select QVQ.* from QUEST_VV_EXT QVQ,
(select q.qc_idseq from sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq and q.P_MOD_IDSEQ=m.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE' and q.qtl_name = 'QUESTION') GOOD
where QVQ.QUEST_IDSEQ=GOOD.QC_IDSEQ(+)
and GOOD.QC_IDSEQ is null
UNION
select QVQ.* from QUEST_VV_EXT QVQ,
(select vv.qc_idseq from sbrext.quest_contents_ext vv,
sbrext.quest_contents_ext q,sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f where f.qc_idseq=m.dn_crf_idseq 
and q.P_MOD_IDSEQ=m.QC_IDSEQ and vv.P_QST_IDSEQ=q.QC_IDSEQ 
and f.qtl_name in('CRF','TEMPLATE') and m.qtl_name = 'MODULE' 
and q.qtl_name = 'QUESTION' and vv.qtl_name = 'VALID_VALUE') GOOD
where QVQ.VV_IDSEQ=GOOD.QC_IDSEQ(+)
and GOOD.QC_IDSEQ is null
and QVQ.VV_IDSEQ IS NOT NULL)