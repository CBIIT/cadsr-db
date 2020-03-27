
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
select 'Records To be Migrated' QUEST_CONTENTS_EXT ,m.*,q.*,v.*
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
and vv.qtl_name = 'VALID_VALUE' )v;
/
select 'VALID_VALUES_ATT_EXT' TABLE_NAME ,a.*,b.*
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
select 'QUEST_ATTRIBUTES_EXT' TABLE_NAME ,a.*,b.*
from
(select  count(*) "Currently in caDSR" from QUEST_ATTRIBUTES_EXT)a,
(select  count(*) "To be Migrated" from QUEST_ATTRIBUTES_EXT 
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
;
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
select 'VALID_VALUES_ATT_EXT' TABLE_NAME ,a.*,b.*
from
(select  count(*) "Records before cleanup" from sbrext.VALID_VALUES_ATT_EXT)a,
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
select 'QUEST_ATTRIBUTES_EXT' TABLE_NAME ,a.*,b.*
from
(select  count(*) "Records in caDSR" from QUEST_ATTRIBUTES_EXT)a,
(select  count(*) "Records in caDSR to be Migrated" from QUEST_ATTRIBUTES_EXT 
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
;
/
ROllback;
SPOOL OFF;