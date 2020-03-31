set serveroutput on size 1000000
SPOOL DSRMWS-161.log  
--select distinct QTL_NAME from sbrext.quest_contents_ext;
SET AUTOCOMMIT OFF
SET SERVEROUTPUT ON
set linesize 200
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
(select count(*) "VALUE_INSTR" from sbrext.quest_contents_ext where qtl_name = 'VALUE_INSTR' )vi;
/
select 'Records in caDSR' QUEST_CONTENTS_EXT ,m.*,q.*,v.*
from
(select counT(*) "MODULES" from sbrext.quest_contents_ext m where  m.qtl_name = 'MODULE')m,
(select count(*) "QUESTIONS" from sbrext.quest_contents_ext q  where q.qtl_name = 'QUESTION')q,
(select count(*) "VALID VALUES" from sbrext.quest_contents_ext vv where vv.qtl_name = 'VALID_VALUE' )v
UNION
select 'Records to be Migrated' QUEST_CONTENTS_EXT ,m.*,q.*,v.*
from
(select counT(*) "MODULES" from 
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE')m,
(select count(*) "QUESTIONS" from 
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and q.P_MOD_IDSEQ=m.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE'
and q.qtl_name = 'QUESTION'
)q,
(select count(*) "VALID VALUES" from 
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
and vv.qtl_name = 'VALID_VALUE' )v
UNION
select 'Records to be Deleted' QUEST_CONTENTS_EXT ,m.*,q.*,v.*
from 
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
and good.qc_idseq is null )v;
/
select 'VALID_VALUES_ATT_EXT' TABLE_NAME ,a.*,b.*,(a."Records in caDSR"-b."Records to be Migrated") "Records need to be deleted"
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
select 'QUEST_ATTRIBUTES_EXT' TABLE_NAME ,a.*,b.*,(a.a-b.b) "Records need to be deleted"
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
select 'Records after cleanup' QUEST_CONTENTS ,f.*,m.*,q.*,v.*,fi.*,i.*,ff.*,mi.*,qi.*,vi.* 
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
(select count(*) "VALUE_INSTR" from sbrext.quest_contents_ext where qtl_name = 'VALUE_INSTR' )vi;
/
select 'Records in caDSR' QUEST_CONTENTS_EXT ,m.*,q.*,v.*
from
(select counT(*) "MODULES" from sbrext.quest_contents_ext m where  m.qtl_name = 'MODULE')m,
(select count(*) "QUESTIONS" from sbrext.quest_contents_ext q  where q.qtl_name = 'QUESTION')q,
(select count(*) "VALID VALUES" from sbrext.quest_contents_ext vv where vv.qtl_name = 'VALID_VALUE' )v
UNION
select 'Records to be Migrated' QUEST_CONTENTS_EXT ,m.*,q.*,v.*
from
(select counT(*) "MODULES" from 
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE')m,
(select count(*) "QUESTIONS" from 
sbrext.quest_contents_ext q,
sbrext.quest_contents_ext m,
sbrext.quest_contents_ext f
where f.qc_idseq=m.dn_crf_idseq
and q.P_MOD_IDSEQ=m.QC_IDSEQ
and f.qtl_name in('CRF','TEMPLATE')
and m.qtl_name = 'MODULE'
and q.qtl_name = 'QUESTION'
)q,
(select count(*) "VALID VALUES" from 
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
and vv.qtl_name = 'VALID_VALUE' )v
UNION
select 'Records to be Deleted' QUEST_CONTENTS_EXT ,m.*,q.*,v.*
from 
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
and good.qc_idseq is null )v;
/
select 'VALID_VALUES_ATT_EXT' TABLE_NAME ,a.*,b.*,(a."Records in caDSR"-b."Records to be Migrated") "Records need to be deleted"
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
select 'QUEST_ATTRIBUTES_EXT' TABLE_NAME ,a.*,b.*,(a.a-b.b) "Records need to be deleted"
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
begin
dbms_output.put_line('Tables to be cleanup ');
end;
select 'ADMINISTERED_COMPONENTS' TABLE_NAME ,a.*,b.*,(a."Records in caDSR"-b."Records to be Migrated") "Records need to be deleted"
from
(select  count(*) "Records in caDSR" from sbrext.ADMINISTERED_COMPONENTS)a,
(select  count(*) "Records to be Migrated" from sbrext.ADMINISTERED_COMPONENTS 
where  AC_idseq in
(
select qc_idseq from 

sbrext.quest_contents_ext q,
sbrext.ADMINISTERED_COMPONENTS A
where AC_idseq=q.QC_IDSEQ
and ACTL_NAME = 'QUEST_CONTENT')) b
UNION
select 'QC_RECS_EXT' TABLE_NAME ,a.*,b.*,(a.a-b.b) "Records need to be deleted"
from
(select  count(*) a from sbrext.QC_RECS_EXT)a,
(select  count(*) b from sbrext.QC_RECS_EXT 
where QR_IDSEQ in (
select  QR_IDSEQ  
from sbrext.QC_RECS_EXT,
sbrext.quest_contents_ext c,
sbrext.quest_contents_ext p
where P_QC_IDSEQ=p.qc_idseq
and C_QC_IDSEQ =c.qc_idseq)) b
--QC_RECS_EXT	2662969	2661725

UNION
select 'QUEST_VV_EXT' TABLE_NAME ,a.*,b.*,(a.a-b.b) "Records need to be deleted"
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
select 'PROTOCOL_QC_EXT' TABLE_NAME ,a.*,b.*,(a.a-b.b) "Records need to be deleted"
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
select 'TRIGGERED_ACTIONS_EXT' TABLE_NAME ,a.*,b.*,d.d "Records need to be deleted"
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
and good.TA_IDSEQ is null) )) d;
--select *from sbrext.QC_RECS_EXT;
/
begin
dbms_output.put_line('Cleanup begins');
end;
begin
dbms_output.put_line('Tables after cleanup ');
end;
/
ROllback;
SPOOL OFF;

/*

select count(*) from sbrext.TA_PROTO_CSI_EXT;
select * from sbrext.TA_PROTO_CSI_EXT where AC_CSI_IDSEQ is not null;

select * from sbrext.TA_PROTO_CSI_EXT where AC_CSI_IDSEQ;

select count(*) from sbrext.TA_PROTO_CSI_EXT where AC_CSI_IDSEQ not in (
select AC_CSI.AC_CSI_IDSEQ  from SBR.AC_CSI );*/ 

