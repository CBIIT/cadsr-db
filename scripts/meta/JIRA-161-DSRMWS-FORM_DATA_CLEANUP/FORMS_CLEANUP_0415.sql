set serveroutput on size 1000000
SPOOL DSRMWS-161DEV.log  
--select distinct QTL_NAME from sbrext.quest_contents_ext;
SET AUTOCOMMIT OFF
SET SERVEROUTPUT ON
set linesize 200

select '1. VALID_VALUES_ATT_EXT' TABLE_NAME ,a.*,b.*,(a."Records in caDSR"-b."Records to be Migrated") "Records to be deleted"
from
(select  count(*) "Records in caDSR" from sbrext.VALID_VALUES_ATT_EXT)a,
(select  count(*) "Records to be Migrated" from sbrext.VALID_VALUES_ATT_EXT 
where  qc_idseq in
(
select vv.qc_idseq from 
sbrext.quest_contents_ext vv,
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and q.P_MOD_IDSEQ=m.QC_IDSEQ
and vv.P_QST_IDSEQ=q.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE'
and q.qtl_name = 'QUESTION'
and vv.qtl_name = 'VALID_VALUE')) b
UNION
select '2. QUEST_ATTRIBUTES_EXT' TABLE_NAME ,a.*,b.*,(a.a-b.b) "Records to be deleted"
from
(select  count(*) a from QUEST_ATTRIBUTES_EXT)a,
(select  count(*) b from QUEST_ATTRIBUTES_EXT 
where  qc_idseq in
(
select q.qc_idseq from 
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and q.P_MOD_IDSEQ=m.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE'
and q.qtl_name = 'QUESTION')) b
UNION
select '4. PROTOCOL_QC_EXT' TABLE_NAME ,a.*,b.*,(a."Records in caDSR"-b."Records to be Migrated") "Records to be deleted"
from
(select  count(*) "Records in caDSR" from sbrext.PROTOCOL_QC_EXT)a,
(select  count(*) "Records to be Migrated" from sbrext.PROTOCOL_QC_EXT 
where  qc_idseq  in (select qc_idseq from
sbrext.quest_contents_ext f
where  qtl_name in('CRF','TEMPLATE'))) b
UNION
--records have to be deleted before cleaning sbrext.TRIGGERED_ACTIONS_EXT  and QUEST_CONTENTS_EXT
select '3. TA_PROTO_CSI_EXT' TABLE_NAME ,a.*,b.*,(a."Records in caDSR"-b."Records to be Migrated") "Records to be deleted"
from
(select  count(*) "Records in caDSR" from sbrext.TA_PROTO_CSI_EXT)a,
(select  count(*) "Records to be Migrated" from sbrext.TA_PROTO_CSI_EXT  tp,
(select  TP_IDSEQ from sbrext.TA_PROTO_CSI_EXT   t,AC_CSI a
where t.AC_CSI_IDSEQ=a.AC_CSI_IDSEQ and t.AC_CSI_IDSEQ is not null
union
select  TP_IDSEQ from sbrext.TA_PROTO_CSI_EXT  t,
sbrext.PROTOCOL_QC_EXT p ,sbrext.quest_contents_ext f
where f.qtl_name in('CRF','TEMPLATE')
and f.qc_idseq=p.QC_IDSEQ and t.PROTO_IDSEQ=p.PROTO_IDSEQ)PP,
--VALID TA records 
(select TA_IDSEQ FROM sbrext.TRIGGERED_ACTIONS_EXT TA,
--VALID_SR
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
and q.qtl_name = 'QUESTION'and vv.qtl_name = 'VALID_VALUE') SR,
--VALID TR
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
and q.qtl_name = 'QUESTION' and vv.qtl_name = 'VALID_VALUE') TR
where TA.S_QC_IDSEQ =SR.qc_idseq and  TA.T_QC_IDSEQ=TR.qc_idseq)TA
where TP.TA_IDSEQ =TA.TA_IDSEQ
and PP.TP_IDSEQ = tp.TP_IDSEQ) b 
--records have to be deleted before cleaning sbrext.QUEST_VV_EXT  and QUEST_CONTENTS_EXT
UNION
select '5. TRIGGERED_ACTIONS_EXT' TABLE_NAME ,a.*,b.*,(a."Records in caDSR"-b."Records to be Migrated") "Records to be deleted"
from
(select  count(*) "Records in caDSR" from sbrext.TRIGGERED_ACTIONS_EXT)a,
(select  count(*) "Records to be Migrated" from sbrext.TRIGGERED_ACTIONS_EXT TA,
--VALID_SR
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
and q.qtl_name = 'QUESTION'and vv.qtl_name = 'VALID_VALUE') SR,
--VALID TR
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
and q.qtl_name = 'QUESTION' and vv.qtl_name = 'VALID_VALUE') TR
where TA.S_QC_IDSEQ =SR.qc_idseq and  TA.T_QC_IDSEQ=TR.qc_idseq
) b;
/
select 'Records before cleanup' QUEST_CONTENTS_EXT ,f.*,m.*,q.*,v.*,fi.*,i.*,ff.*,mi.*,qi.*,vi.* 
from

(select count(qc_idseq) "FORMS" from sbrext.quest_contents_ext 
where  qtl_name in('CRF','TEMPLATE'))f,
(select counT(*) "MODULES" from sbrext.quest_contents_ext where qtl_name = 'MODULE')m,
(select count(*) "QUESTIONS" from sbrext.quest_contents_ext where qtl_name = 'QUESTION' )q,
(select count(*) "VALID VALUES" from sbrext.quest_contents_ext where qtl_name = 'VALID_VALUE' )v,
(select counT(*) "FORM_INSTR" from sbrext.quest_contents_ext where qtl_name = 'FORM_INSTR')fi,
(select count(*) "INSTRUCTIONS" from sbrext.quest_contents_ext where qtl_name = 'INSTRUCTIONS' )i,
(select count(*) "FOOTER" from sbrext.quest_contents_ext where qtl_name = 'FOOTER' )ff,
(select counT(*) "MODULE_INSTR" from sbrext.quest_contents_ext where qtl_name = 'MODULE_INSTR')mi,
(select count(*) "QUESTION_INSTR" from sbrext.quest_contents_ext where qtl_name = 'QUESTION_INSTR' )qi,
(select count(*) "VALUE_INSTR" from sbrext.quest_contents_ext where qtl_name = 'VALUE_INSTR' )vi
UNION
select 'Records to be migrated' QUEST_CONTENTS_EXT ,f.*,m.*,q.*,v.*,fi.*,i.*,ff.*,mi.*,qi.*,vi.* 
from
(select count(qc_idseq) "FORMS" from sbrext.quest_contents_ext 
where  qtl_name in('CRF','TEMPLATE'))f,
--MODULE
(select counT(*) "MODULES" from sbrext.quest_contents_ext m,sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq and f.qtl_name in('CRF','TEMPLATE')and m.qtl_name = 'MODULE')m,
--QUESTION
(select count(*) "QUESTIONS" from sbrext.quest_contents_ext q,sbrext.quest_contents_ext m,sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq and q.P_MOD_IDSEQ=m.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')and m.qtl_name = 'MODULE' and q.qtl_name = 'QUESTION' )q,
--VALID_VALUE
(select count(*) "VALID VALUES" from sbrext.quest_contents_ext vv,
sbrext.quest_contents_ext q,sbrext.quest_contents_ext m,sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq and q.P_MOD_IDSEQ=m.QC_IDSEQ and vv.P_QST_IDSEQ=q.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE') and m.qtl_name = 'MODULE' and q.qtl_name = 'QUESTION' and vv.qtl_name = 'VALID_VALUE' )v,
--FORM_INSTR
(select counT(*) "FORM_INSTR" from sbrext.quest_contents_ext f,sbrext.quest_contents_ext foot  
where  foot.dn_crf_idseq=f.qc_idseq and  f.qtl_name in('CRF','TEMPLATE') and foot.qtl_name in 'FORM_INSTR')fi,
--INSTRUCTIONS
(select count(*) "INSTRUCTIONS" from sbrext.quest_contents_ext f,sbrext.quest_contents_ext foot  
where  foot.dn_crf_idseq=f.qc_idseq and  f.qtl_name in('CRF','TEMPLATE') and foot.qtl_name ='INSTRUCTIONS')i,
--FOOTER
(select count(*) "FOOTER" from sbrext.quest_contents_ext f,sbrext.quest_contents_ext foot  
where  foot.dn_crf_idseq=f.qc_idseq and f.qtl_name in('CRF','TEMPLATE') and foot.qtl_name in 'FOOTER' )ff,
--MODULE INSTR
(select counT(*) "MODULE_INSTR" from sbrext.quest_contents_ext  del,
(select instr.qc_idseq from sbrext.quest_contents_ext instr,
sbrext.quest_contents_ext  m where instr.qtl_name= 'MODULE_INSTR' 
and m.qtl_name ='MODULE' and instr.P_MOD_IDSEQ=m.QC_IDSEQ) good
where del.qtl_name= 'MODULE_INSTR' and good.QC_IDSEQ=del.QC_IDSEQ)mi,
--QUESTION_INSTR
(select count(*) "QUESTION_INSTR" from sbrext.quest_contents_ext i,
 (select q.qc_idseq from sbrext.quest_contents_ext q,sbrext.quest_contents_ext m,sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq and q.P_MOD_IDSEQ=m.QC_IDSEQ and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE' and q.qtl_name = 'QUESTION') q
where i.qtl_name = 'QUESTION_INSTR' and i.P_QST_IDSEQ=q.QC_IDSEQ)qi,
--VALUE_INSTR
(select count(*) "VALUE_INSTR" from sbrext.quest_contents_ext i , 
(select vv.qc_idseq from sbrext.quest_contents_ext vv,
sbrext.quest_contents_ext q,sbrext.quest_contents_ext m,sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq and q.P_MOD_IDSEQ=m.QC_IDSEQ and vv.P_QST_IDSEQ=q.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE') and m.qtl_name = 'MODULE'and q.qtl_name = 'QUESTION'
and vv.qtl_name = 'VALID_VALUE')good
where i.qtl_name = 'VALUE_INSTR' and good.qc_idseq=i.P_VAL_IDSEQ )vi

UNION
/**RECORDS TO BE DELETED**/
select 'Records to cleanup' QUEST_CONTENTS_EXT ,f.*,m.*,q.*,v.*,fi.*,i.*,ff.*,mi.*,qi.*,vi.* 
from
(select 0 "FORMS" from dual)f,
--MODULE
 (select count(del.qc_idseq) "MODULE"
from sbrext.quest_contents_ext del ,
(select m.qc_idseq from 
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE'
) good
where del.qtl_name = 'MODULE'
and good.qc_idseq(+)=del.QC_IDSEQ 
 and good.qc_idseq is null)m,
--QUESTION
(select count(del.qc_idseq) "QUESTION"
from sbrext.quest_contents_ext del ,
(select q.qc_idseq from 
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and q.P_MOD_IDSEQ=m.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE'
and q.qtl_name = 'QUESTION'
) good
where del.qtl_name = 'QUESTION'
and good.qc_idseq(+)=del.QC_IDSEQ 
 and good.qc_idseq is null
)q,
--VALID VALUES
(select count(del.qc_idseq) "VALID VALUES" 
from sbrext.quest_contents_ext del , 
(select vv.qc_idseq from 
sbrext.quest_contents_ext vv,
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and q.P_MOD_IDSEQ=m.QC_IDSEQ
and vv.P_QST_IDSEQ=q.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE'
and q.qtl_name = 'QUESTION'
and vv.qtl_name = 'VALID_VALUE')good
where del.qtl_name = 'VALID_VALUE'
and good.qc_idseq(+)=del.QC_IDSEQ 
and good.qc_idseq is null )v,
--FORM_INSTR
(select counT(*) "FORM_INSTR" from sbrext.quest_contents_ext foot,
(select * from sbrext.quest_contents_ext where qtl_name in('CRF','TEMPLATE'))f  
where  foot.dn_crf_idseq=f.qc_idseq(+) and f.qc_idseq is null
and foot.qtl_name in 'FORM_INSTR')fi,
--INSTRUCTIONS
(select count(*) "INSTRUCTIONS" from sbrext.quest_contents_ext foot,
(select * from sbrext.quest_contents_ext where qtl_name in('CRF','TEMPLATE'))f  
where  foot.dn_crf_idseq=f.qc_idseq(+) and f.qc_idseq is null 
and foot.qtl_name ='INSTRUCTIONS')i,
--FOOTER
(select count(*) "FOOTER" from sbrext.quest_contents_ext foot,
(select * from sbrext.quest_contents_ext where qtl_name in('CRF','TEMPLATE'))f  
where  foot.dn_crf_idseq=f.qc_idseq(+) and f.qc_idseq is null
and foot.qtl_name in 'FOOTER' )ff,
--MODULE INSTR
(select counT(*) "MODULE_INSTR" from sbrext.quest_contents_ext  inst  ,
(select m.qc_idseq from sbrext.quest_contents_ext f,
sbrext.quest_contents_ext  m 
where  f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name ='MODULE' 
and f.qc_idseq=m.DN_CRF_IDSEQ) good
where  good.QC_IDSEQ(+)=inst.P_MOD_IDSEQ 
and good.QC_IDSEQ is null
and inst.qtl_name= 'MODULE_INSTR')mi,
--QUESTION_INSTR
(select count(*) "QUESTION_INSTR" from sbrext.quest_contents_ext i,
 (select q.qc_idseq from sbrext.quest_contents_ext q,sbrext.quest_contents_ext m,sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq and q.P_MOD_IDSEQ=m.QC_IDSEQ and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE' and q.qtl_name = 'QUESTION') q
where i.qtl_name = 'QUESTION_INSTR' and i.P_QST_IDSEQ=q.QC_IDSEQ(+) and q.QC_IDSEQ is NULL )qi,
--VALUE_INSTR
(select count(*) "VALUE_INSTR" from sbrext.quest_contents_ext i , 
(select vv.qc_idseq from sbrext.quest_contents_ext vv,
sbrext.quest_contents_ext q,sbrext.quest_contents_ext m,sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq and q.P_MOD_IDSEQ=m.QC_IDSEQ and vv.P_QST_IDSEQ=q.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE') and m.qtl_name = 'MODULE'and q.qtl_name = 'QUESTION'
and vv.qtl_name = 'VALID_VALUE')good
where i.qtl_name = 'VALUE_INSTR' and good.qc_idseq(+)=i.P_VAL_IDSEQ
and  good.qc_idseq is null)vi

/
begin
dbms_output.put_line('Cleanup begins');
end;
/
begin
dbms_output.put_line('Cleanup VALID_VALUES_ATT_EXT');
end;
/
delete from  sbrext.VALID_VALUES_ATT_EXT 
where  qc_idseq in
(select qc_idseq from sbrext.quest_contents_ext where qtl_name = 'VALID_VALUE'
 MINUS
select vv.qc_idseq from 
sbrext.quest_contents_ext vv,
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and q.P_MOD_IDSEQ=m.QC_IDSEQ
and vv.P_QST_IDSEQ=q.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE'
and q.qtl_name = 'QUESTION'
and vv.qtl_name = 'VALID_VALUE');
/
begin
dbms_output.put_line('Cleanup VALID_VALUES of QUEST_CONTENTS_EXT');
end;
/
delete from sbrext.quest_contents_ext
where  qc_idseq in
(select del.qc_idseq
from sbrext.quest_contents_ext del , 
(select vv.qc_idseq from 
sbrext.quest_contents_ext vv,
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and q.P_MOD_IDSEQ=m.QC_IDSEQ
and vv.P_QST_IDSEQ=q.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE'
and q.qtl_name = 'QUESTION'
and vv.qtl_name = 'VALID_VALUE')good
where del.qtl_name = 'VALID_VALUE'
and good.qc_idseq(+)=del.QC_IDSEQ 
and good.qc_idseq is null);
/
begin
dbms_output.put_line('Cleanup QUEST_ATTRIBUTES_EXT');
end;
/
delete   from sbrext.QUEST_ATTRIBUTES_EXT
where QC_IDSEQ   in
(
select del.qc_idseq 
from sbrext.quest_contents_ext del ,
(select q.qc_idseq from 
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and q.P_MOD_IDSEQ=m.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE'
and q.qtl_name = 'QUESTION'
) good
where del.qtl_name = 'QUESTION'
and good.qc_idseq(+)=del.QC_IDSEQ 
 and good.qc_idseq is null);
 /
begin
dbms_output.put_line('Cleanup QUESTIONS of QUEST_CONTENTS_EXT');
end;
/ 
delete from sbrext.quest_contents_ext where qc_idseq in
(
select del.qc_idseq 
from sbrext.quest_contents_ext del ,
(select q.qc_idseq from 
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and q.P_MOD_IDSEQ=m.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE'
and q.qtl_name = 'QUESTION'
) good
where del.qtl_name = 'QUESTION'
and good.qc_idseq(+)=del.QC_IDSEQ 
 and good.qc_idseq is null);
 /
begin
dbms_output.put_line('Cleanup MODULES of QUEST_CONTENTS_EXT');
end; 
 /
 delete  from sbrext.quest_contents_ext where qc_idseq in(
select del.qc_idseq 
from sbrext.quest_contents_ext del ,
(select m.qc_idseq from 
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE'
) good
where del.qtl_name = 'MODULE'
and good.qc_idseq(+)=del.QC_IDSEQ 
 and good.qc_idseq is null) ;
/ 
 begin
dbms_output.put_line('Cleanup FORM_INSTR of QUEST_CONTENTS_EXT');
end;
delete from
sbrext.quest_contents_ext foot  
where foot.qtl_name= 'FORM_INSTR' 
and dn_crf_idseq not in 
(select qc_idseq from sbrext.quest_contents_ext 
where qtl_name in('CRF','TEMPLATE') ) ;
/
begin
dbms_output.put_line('Cleanup INSTRUCTIONS of QUEST_CONTENTS_EXT');
end;
/
delete from
sbrext.quest_contents_ext foot  
where foot.qtl_name= 'INSTRUCTIONS' 
and dn_crf_idseq not in 
(select qc_idseq from sbrext.quest_contents_ext 
where qtl_name in('CRF','TEMPLATE') ) ;
/
begin
dbms_output.put_line('Cleanup FOOTERS of QUEST_CONTENTS_EXT');
end;
/
delete from
sbrext.quest_contents_ext foot  
where foot.qtl_name= 'FOOTER' 
and dn_crf_idseq not in 
(select qc_idseq from sbrext.quest_contents_ext 
where qtl_name in('CRF','TEMPLATE') ) ;
/
begin
dbms_output.put_line('Cleanup MODULE_INSTR of QUEST_CONTENTS_EXT');
end;
/
delete from
sbrext.quest_contents_ext foot  
where foot.qtl_name= 'MODULE_INSTR' 
and p_mod_idseq not in 
(select qc_idseq from sbrext.quest_contents_ext 
where qtl_name ='MODULE' ) ;
/
begin
dbms_output.put_line('Cleanup QUESTION_INSTR of QUEST_CONTENTS_EXT');
end;
/
delete from
sbrext.quest_contents_ext foot  
where foot.qtl_name= 'QUESTION_INSTR' 
and p_qst_idseq not in 
(select qc_idseq from sbrext.quest_contents_ext 
where qtl_name ='QUESTION' ) ;
/
begin
dbms_output.put_line('Cleanup VALUE_INSTR of QUEST_CONTENTS_EXT');
end;
/
delete   from
sbrext.quest_contents_ext foot  
where foot.qtl_name= 'VALUE_INSTR' 
and P_VAL_IDSEQ not in 
(select qc_idseq from sbrext.quest_contents_ext 
where qtl_name ='VALID_VALUE' ) ;
/
select 'VALID_VALUES_ATT_EXT' TABLE_NAME ,a.*,b.*,(a."Records in caDSR"-b."Records to be Migrated") "Records to be deleted"
from
(select  count(*) "Records in caDSR" from sbrext.VALID_VALUES_ATT_EXT)a,
(select  count(*) "Records to be Migrated" from sbrext.VALID_VALUES_ATT_EXT 
where  qc_idseq in
(
select vv.qc_idseq from 
sbrext.quest_contents_ext vv,
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and q.P_MOD_IDSEQ=m.QC_IDSEQ
and vv.P_QST_IDSEQ=q.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE'
and q.qtl_name = 'QUESTION'
and vv.qtl_name = 'VALID_VALUE')) b
UNION
select 'QUEST_ATTRIBUTES_EXT' TABLE_NAME ,a.*,b.*,(a.a-b.b) "Records to be deleted"
from
(select  count(*) a from QUEST_ATTRIBUTES_EXT)a,
(select  count(*) b from QUEST_ATTRIBUTES_EXT 
where  qc_idseq in
(
select q.qc_idseq from 
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and q.P_MOD_IDSEQ=m.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE'
and q.qtl_name = 'QUESTION')) b;
/
select 'Records after cleanup' QUEST_CONTENTS ,al.*,f.*,m.*,q.*,v.*,fi.*,i.*,ff.*,mi.*,qi.*,vi.* 
from
(select counT(*) "All Form Elements" from sbrext.quest_contents_ext )al,
(select count(qc_idseq) "FORMS" from sbrext.quest_contents_ext 
where  qtl_name in('CRF','TEMPLATE'))f,
(select counT(*) "MODULES" from sbrext.quest_contents_ext where qtl_name = 'MODULE')m,
(select count(*) "QUESTIONS" from sbrext.quest_contents_ext where qtl_name = 'QUESTION' )q,
(select count(*) "VALID VALUES" from sbrext.quest_contents_ext where qtl_name = 'VALID_VALUE' )v,
(select counT(*) "FORM_INSTR" from sbrext.quest_contents_ext where qtl_name = 'FORM_INSTR')fi,
(select count(*) "INSTRUCTIONS" from sbrext.quest_contents_ext where qtl_name = 'INSTRUCTIONS' )i,
(select count(*) "FOOTER" from sbrext.quest_contents_ext where qtl_name = 'FOOTER' )ff,
(select counT(*) "MODULE_INSTR" from sbrext.quest_contents_ext where qtl_name = 'MODULE_INSTR')mi,
(select count(*) "QUESTION_INSTR" from sbrext.quest_contents_ext where qtl_name = 'QUESTION_INSTR' )qi,
(select count(*) "VALUE_INSTR" from sbrext.quest_contents_ext where qtl_name = 'VALUE_INSTR' )vi;
/
begin
dbms_output.put_line('Tables to be cleanup ');
end;

select 'QC_RECS_EXT' TABLE_NAME ,a.*,b.*,(a."Records in caDSR"-b."Records to be Migrated") "Records to be deleted"
from
(select  count(*) "Records in caDSR" from sbrext.QC_RECS_EXT)a,
(select  count(*) "Records to be Migrated" from sbrext.QC_RECS_EXT 
where QR_IDSEQ in (
select  QR_IDSEQ  
from sbrext.QC_RECS_EXT,
sbrext.quest_contents_ext c,
sbrext.quest_contents_ext p
where P_QC_IDSEQ=p.qc_idseq
and C_QC_IDSEQ =c.qc_idseq)) b
--QC_RECS_EXT	2662969	2661725

UNION
select 'QUEST_VV_EXT' TABLE_NAME ,a.*,b.*,(a.a-b.b) "Records to be deleted"
from
(select  count(*) a from QUEST_VV_EXT)a,
(select  count(*) b from QUEST_VV_EXT 
where  QV_IDSEQ in
(
select  QV_IDSEQ
from sbrext.QUEST_VV_EXT,
(select qc_idseq from sbrext.quest_contents_ext where qtl_name = 'QUESTION')q,
(select*from sbrext.quest_contents_ext   where  qtl_name = 'VALID_VALUE') v
where  QUEST_IDSEQ =q.qc_idseq
and (VV_IDSEQ=v.qc_idseq )
UNION
select QV_IDSEQ
from sbrext.QUEST_VV_EXT,
(select qc_idseq from sbrext.quest_contents_ext where qtl_name = 'QUESTION')q
where  QUEST_IDSEQ =q.qc_idseq
and VV_IDSEQ is NULL 
)) b
UNION
select 'PROTOCOL_QC_EXT' TABLE_NAME ,a.*,b.*,(a.a-b.b) "Records to be deleted"
from
(select  count(*) a from PROTOCOL_QC_EXT)a,
(select  count(*) b from PROTOCOL_QC_EXT 
where  PQ_IDSEQ in
(
select PQ_IDSEQ from PROTOCOL_QC_EXT p,
sbrext.quest_contents_ext f
where  qtl_name in('CRF','TEMPLATE')
and  f.qc_idseq=p.qc_idseq)) b
UNION
select 'TRIGGERED_ACTIONS_EXT' TABLE_NAME ,a.*,b.*,d.d "Records to be deleted"
from
(select  count(*) a from sbrext.TRIGGERED_ACTIONS_EXT)a,
(select  count(*) b from sbrext.TRIGGERED_ACTIONS_EXT
where  TA_IDSEQ in
(
select TA_IDSEQ  from 
(select TA_IDSEQ from sbrext.TRIGGERED_ACTIONS_EXT t,
sbrext.quest_contents_ext q
where S_QC_IDSEQ =qc_idseq 
union 
select TA_IDSEQ from sbrext.TRIGGERED_ACTIONS_EXT t,
sbrext.quest_contents_ext q
where T_QC_IDSEQ=qc_idseq) ))b,
(select  count(*) d from 
(select TA_IDSEQ d from(
select del.TA_IDSEQ from sbrext.TRIGGERED_ACTIONS_EXT del,
(select TA_IDSEQ from sbrext.TRIGGERED_ACTIONS_EXT t,
sbrext.quest_contents_ext q
where S_QC_IDSEQ =qc_idseq 
union 
select TA_IDSEQ from sbrext.TRIGGERED_ACTIONS_EXT t,
sbrext.quest_contents_ext q
where T_QC_IDSEQ=qc_idseq) good
where  del.TA_IDSEQ=good.TA_IDSEQ(+)
and good.TA_IDSEQ is null) )) d
UNION
select 'TA_PROTO_CSI_EXT' TABLE_NAME ,a.*,b.*,d.d "Records to be deleted"
from
(select count(TP_IDSEQ) a from sbrext.TA_PROTO_CSI_EXT )a,
(select count(TP_IDSEQ) b from 
(select  TP_IDSEQ from sbrext.TA_PROTO_CSI_EXT   t,
AC_CSI a
where t.AC_CSI_IDSEQ=a.AC_CSI_IDSEQ and t.AC_CSI_IDSEQ is not null
union
select  TP_IDSEQ from sbrext.TA_PROTO_CSI_EXT  t,
sbrext.PROTOCOL_QC_EXT p where t.PROTO_IDSEQ is not null
and t.PROTO_IDSEQ=p.PROTO_IDSEQ
)) b,
(select count(TP_IDSEQ)d from 
(select del.TP_IDSEQ from sbrext.TA_PROTO_CSI_EXT del,
(select  TP_IDSEQ from sbrext.TA_PROTO_CSI_EXT   t,
AC_CSI a
where t.AC_CSI_IDSEQ=a.AC_CSI_IDSEQ and t.AC_CSI_IDSEQ is not null
union
select  TP_IDSEQ from sbrext.TA_PROTO_CSI_EXT  t,
sbrext.PROTOCOL_QC_EXT p where t.PROTO_IDSEQ is not null
and t.PROTO_IDSEQ=p.PROTO_IDSEQ
) good
where  del.TP_IDSEQ=good.TP_IDSEQ(+)
and good.TP_IDSEQ is null ) )d ;
/
begin
dbms_output.put_line('Cleanup begins');
end;
begin
dbms_output.put_line('Cleanup sbrext.PROTOCOL_QC_EXT');
end;
delete from sbrext.PROTOCOL_QC_EXT where QC_IDSEQ not in (
select qc_idseq from sbrext.quest_contents_ext where  qtl_name in('CRF','TEMPLATE'));
begin
dbms_output.put_line('Cleanup sbrext.TA_PROTO_CSI_EXT');
end;
delete from sbrext.TA_PROTO_CSI_EXT where TP_IDSEQ  in (
select del.TP_IDSEQ from sbrext.TA_PROTO_CSI_EXT del,
(select  TP_IDSEQ from sbrext.TA_PROTO_CSI_EXT   t,
AC_CSI a
where t.AC_CSI_IDSEQ=a.AC_CSI_IDSEQ and t.AC_CSI_IDSEQ is not null
union
select  TP_IDSEQ from sbrext.TA_PROTO_CSI_EXT  t,
sbrext.PROTOCOL_QC_EXT p where t.PROTO_IDSEQ is not null
and t.PROTO_IDSEQ=p.PROTO_IDSEQ
) good
where  del.TP_IDSEQ=good.TP_IDSEQ(+)
and good.TP_IDSEQ is null  );
begin
dbms_output.put_line('Cleanup sbrext.QC_RECS_EXT');
end;
delete from sbrext.QC_RECS_EXT where QR_IDSEQ in
(select a.QR_IDSEQ  from sbrext.QC_RECS_EXT a,
(select  QR_IDSEQ  from sbrext.QC_RECS_EXT 
where QR_IDSEQ in (
select  QR_IDSEQ  
from sbrext.QC_RECS_EXT,
sbrext.quest_contents_ext c,
sbrext.quest_contents_ext p
where P_QC_IDSEQ=p.qc_idseq
and C_QC_IDSEQ =c.qc_idseq)
)good
where a.QR_IDSEQ =good.QR_IDSEQ(+)
and good.QR_IDSEQ is null);
begin
dbms_output.put_line('Cleanup sbrext.QUEST_VV_EXT');
end;
delete 
from QUEST_VV_EXT where QV_IDSEQ in
(select   a.QV_IDSEQ  from QUEST_VV_EXT a,
(select  QV_IDSEQ
from sbrext.QUEST_VV_EXT,
(select qc_idseq from sbrext.quest_contents_ext where qtl_name = 'QUESTION')q,
(select*from sbrext.quest_contents_ext   where  qtl_name = 'VALID_VALUE') v
where  QUEST_IDSEQ =q.qc_idseq
and (VV_IDSEQ=v.qc_idseq )
UNION
select QV_IDSEQ
from sbrext.QUEST_VV_EXT,
(select qc_idseq from sbrext.quest_contents_ext where qtl_name = 'QUESTION')q
where  QUEST_IDSEQ =q.qc_idseq
and VV_IDSEQ is NULL 
) good 
where a.QV_IDSEQ=good.QV_IDSEQ(+)
and good.QV_IDSEQ is null);
begin
dbms_output.put_line('Cleanup sbrext.TRIGGERED_ACTIONS_EXT');
end;
delete 
from sbrext.TRIGGERED_ACTIONS_EXT where TA_IDSEQ in
(
select del.TA_IDSEQ from sbrext.TRIGGERED_ACTIONS_EXT del,
(select TA_IDSEQ from sbrext.TRIGGERED_ACTIONS_EXT t,
sbrext.quest_contents_ext q
where S_QC_IDSEQ =qc_idseq 
union 
select TA_IDSEQ from sbrext.TRIGGERED_ACTIONS_EXT t,
sbrext.quest_contents_ext q
where T_QC_IDSEQ=qc_idseq) good
where  del.TA_IDSEQ=good.TA_IDSEQ(+)
and good.TA_IDSEQ is null) ;
begin
dbms_output.put_line('Tables after cleanup ');
end;

select 'QC_RECS_EXT' TABLE_NAME ,a.*,b.*,(a."Records in caDSR"-b."Records to be Migrated") "Records to be deleted"
from
(select  count(*) "Records in caDSR" from sbrext.QC_RECS_EXT)a,
(select  count(*) "Records to be Migrated" from sbrext.QC_RECS_EXT 
where QR_IDSEQ in (
select  QR_IDSEQ  
from sbrext.QC_RECS_EXT,
sbrext.quest_contents_ext c,
sbrext.quest_contents_ext p
where P_QC_IDSEQ=p.qc_idseq
and C_QC_IDSEQ =c.qc_idseq)) b
--QC_RECS_EXT	2662969	2661725

UNION
select 'QUEST_VV_EXT' TABLE_NAME ,a.*,b.*,(a.a-b.b) "Records to be deleted"
from
(select  count(*) a from QUEST_VV_EXT)a,
(select  count(*) b from QUEST_VV_EXT 
where  QV_IDSEQ in
(
select  QV_IDSEQ
from sbrext.QUEST_VV_EXT,
(select qc_idseq from sbrext.quest_contents_ext where qtl_name = 'QUESTION')q,
(select*from sbrext.quest_contents_ext   where  qtl_name = 'VALID_VALUE') v
where  QUEST_IDSEQ =q.qc_idseq
and (VV_IDSEQ=v.qc_idseq )
UNION
select QV_IDSEQ
from sbrext.QUEST_VV_EXT,
(select qc_idseq from sbrext.quest_contents_ext where qtl_name = 'QUESTION')q
where  QUEST_IDSEQ =q.qc_idseq
and VV_IDSEQ is NULL 
)) b
UNION
select 'PROTOCOL_QC_EXT' TABLE_NAME ,a.*,b.*,(a.a-b.b) "Records to be deleted"
from
(select  count(*) a from PROTOCOL_QC_EXT)a,
(select  count(*) b from PROTOCOL_QC_EXT 
where  PQ_IDSEQ in
(
select PQ_IDSEQ from PROTOCOL_QC_EXT p,
sbrext.quest_contents_ext f
where  qtl_name in('CRF','TEMPLATE')
and  f.qc_idseq=p.qc_idseq)) b
UNION
select 'TRIGGERED_ACTIONS_EXT' TABLE_NAME ,a.*,b.*,d.d "Records to be deleted"
from
(select  count(*) a from sbrext.TRIGGERED_ACTIONS_EXT)a,
(select  count(*) b from sbrext.TRIGGERED_ACTIONS_EXT
where  TA_IDSEQ in
(
select TA_IDSEQ  from 
(select TA_IDSEQ from sbrext.TRIGGERED_ACTIONS_EXT t,
sbrext.quest_contents_ext q
where S_QC_IDSEQ =qc_idseq 
union 
select TA_IDSEQ from sbrext.TRIGGERED_ACTIONS_EXT t,
sbrext.quest_contents_ext q
where T_QC_IDSEQ=qc_idseq) ))b,
(select  count(*) d from 
(select TA_IDSEQ d from(
select del.TA_IDSEQ from sbrext.TRIGGERED_ACTIONS_EXT del,
(select TA_IDSEQ from sbrext.TRIGGERED_ACTIONS_EXT t,
sbrext.quest_contents_ext q
where S_QC_IDSEQ =qc_idseq 
union 
select TA_IDSEQ from sbrext.TRIGGERED_ACTIONS_EXT t,
sbrext.quest_contents_ext q
where T_QC_IDSEQ=qc_idseq) good
where  del.TA_IDSEQ=good.TA_IDSEQ(+)
and good.TA_IDSEQ is null) )) d
UNION
select 'TA_PROTO_CSI_EXT' TABLE_NAME ,a.*,b.*,d.d "Records to be deleted"
from
(select count(TP_IDSEQ) a from sbrext.TA_PROTO_CSI_EXT )a,
(select count(TP_IDSEQ) b from 
(select  TP_IDSEQ from sbrext.TA_PROTO_CSI_EXT   t,
AC_CSI a
where t.AC_CSI_IDSEQ=a.AC_CSI_IDSEQ and t.AC_CSI_IDSEQ is not null
union
select  TP_IDSEQ from sbrext.TA_PROTO_CSI_EXT  t,
sbrext.PROTOCOL_QC_EXT p where t.PROTO_IDSEQ is not null
and t.PROTO_IDSEQ=p.PROTO_IDSEQ
)) b,
(select count(TP_IDSEQ)d from 
(select del.TP_IDSEQ from sbrext.TA_PROTO_CSI_EXT del,
(select  TP_IDSEQ from sbrext.TA_PROTO_CSI_EXT   t,
AC_CSI a
where t.AC_CSI_IDSEQ=a.AC_CSI_IDSEQ and t.AC_CSI_IDSEQ is not null
union
select  TP_IDSEQ from sbrext.TA_PROTO_CSI_EXT  t,
sbrext.PROTOCOL_QC_EXT p where t.PROTO_IDSEQ is not null
and t.PROTO_IDSEQ=p.PROTO_IDSEQ
) good
where  del.TP_IDSEQ=good.TP_IDSEQ(+)
and good.TP_IDSEQ is null ) )d ;
/
ROllback;
SPOOL OFF;


