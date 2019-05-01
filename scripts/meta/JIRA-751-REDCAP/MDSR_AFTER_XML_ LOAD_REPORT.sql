--1 .Find dup questions
select  qc_id,  preferred_name,protocol,quest_sum,quest_sum_csv from

(SELECT COUNT (*) quest_sum_csv, PROTOCOL, form_name_new
                  FROM MDSR_REDCAP_PROTOCOL_CSV
                 WHERE protocol NOT LIKE 'Instr%'
                 and load_seq=1
              GROUP BY PROTOCOL, form_name_new) a,
              
              
              (SELECT COUNT (*) quest_sum, q.dn_crf_idseq,f.qc_id, p.preferred_name
                 FROM sbrext.quest_contents_ext f,
                 sbrext.quest_contents_ext q,
                 sbrext.PROTOCOL_QC_EXT pp,
                 sbrext.PROTOCOLS_EXT p
                 WHERE  f.QTL_NAME='CRF'
                 and  q.dn_crf_idseq =f.qc_idseq 
                 and q.QTL_NAME ='QUESTION' 
                and p.preferred_name like 'PX%'
                and f.QC_IDSEQ=pp.QC_IDSEQ
              and p.PROTO_IDSEQ=pp.PROTO_IDSEQ
              GROUP BY q.dn_crf_idseq,f.qc_id, p.preferred_name) b
              where protocol=preferred_name
              and quest_sum>quest_sum_csv;


--2. if protocol preferred name not in from long name 
select q.long_name,rf.FORM_NAME_NEW,rf.preferred_definition correct_def,q.preferred_definition,
p.PROTOCOL_ID,p.PREFERRED_NAME,q.modified_by,q.DATE_MODIFIED,
q.qc_id,q.qc_idseq,q.created_by,q.date_created,q.QTL_NAME,q.version
from sbrext.quest_contents_ext q,
sbrext.PROTOCOL_QC_EXT pp,
sbrext.MSDREDCAP_FORM_CSV  rf,
sbrext.PROTOCOLS_EXT p
where rf.protocol=trim(p.preferred_name)
and q.QC_IDSEQ=pp.QC_IDSEQ
and instr(q.long_name ,rf.PROTOCOL)=0
and p.PROTO_IDSEQ=pp.PROTO_IDSEQ
and load_seq=1
--and protocol not in ( list from check 1)
--and p.PREFERRED_NAME like '%PX121603%'
and q.qtl_name='CRF'
and NVL(q.modified_by,'FORMLOADER') ='FORMLOADER'
order by 2;

--3. If all forms loaded with truncated long name ,but from long name includes protocol preferred name


select long_name,rf.FORM_NAME_NEW,rf.preferred_definition correct_def,
q.preferred_definition,q.modified_by,q.DATE_MODIFIED,qc_id,qc_idseq,created_by,date_created,QTL_NAME,version
from sbrext.quest_contents_ext q,
SBREXT.MSDREDCAP_FORM_CSV rf
where instr(q.long_name,trim(PROTOCOL))>0
--and q.LONG_NAME like 'PhenX PX251601%'
and q.qtl_name='CRF'
and trim(rf.FORM_NAME_NEW)<>trim(long_name)
and load_seq=1
--and protocol not in ( list from check 1)
and NVL(q.modified_by,'FORMLOADER') ='FORMLOADER'
order by 2;

--4. find from with truncated preferred _definitions
select long_name,rf.FORM_NAME_NEW,rf.preferred_definition correct_def,q.preferred_definition,q.modified_by,q.DATE_MODIFIED,qc_id,qc_idseq,created_by,date_created,QTL_NAME,version
from sbrext.quest_contents_ext q,
sbrext.MSDREDCAP_FORM_CSV rf
where q.long_name=rf.FORM_NAME_NEW
--and q.LONG_NAME like '%PX662102%'
--and protocol not in ( list from check 1)
and load_seq=1
and q.qtl_name='CRF'
and length(trim(q.preferred_definition))<>length(trim(rf.preferred_definition))
and NVL(modified_by,'FORMLOADER') ='FORMLOADER';

--5.Find from Sections with truncated section long name

select form_name,trim(section_new) correct_mod_name,m.long_name ,m.preferred_definition,SECTION_SEQ ,m.display_order ,m.QC_IDSEQ,m.qc_id,m.VERSION,
m.modified_by,m.DATE_MODIFIED,m.created_by,m.date_created,m.QTL_NAME
from sbrext.quest_contents_ext f,
sbrext.quest_contents_ext m,
sbrext.MSDREDCAP_SECTION_CSV r
where m.dn_crf_idseq =f.qc_idseq 
and f.long_name =r.form_name
and f.QTL_NAME='CRF'
and  m.QTL_NAME ='MODULE'
and SECTION_SEQ=m.display_order
--and protocol not in ( list from check 1)
and load_seq=p_run
and trim(section_new)<>trim(m.long_name)
and NVL(m.modified_by,'FORMLOADER') ='FORMLOADER';

--6.Find from Questions with truncated Question long name 
select form_name_new,q.long_name long_name,form_question correct_question,instructions,
m.display_order mod_order, q.display_order ,q.PREFERRED_DEFINITION,
q.qc_id,q.VERSION,q.QC_IDSEQ,q.QTL_NAME,q.CREATED_BY,q.MODIFIED_BY,
q.date_modified,q.DATE_CREATED
from sbrext.quest_contents_ext f,
MDSR_REDCAP_PROTOCOL_CSV r,
sbrext.quest_contents_ext  q,
sbrext.quest_contents_ext  m

where m.dn_crf_idseq =f.qc_idseq 
and f.long_name=r.form_name_new
and q.p_MOD_IDSEQ=m.qc_idseq
and f.QTL_NAME='CRF'
and m.QTL_NAME='MODULE'
and q.QTL_NAME ='QUESTION'
and m.display_order=r.SECTION_SEQ
and q.display_order=r.SECTION_Q_SEQ
--and protocol not in ( list from check 1)
and load_seq=p_run
and NVL(q.modified_by,'FORMLOADER') ='FORMLOADER'
and instr(form_question,trim(q.long_name))>0
and trim(form_question)<>trim(q.long_name)
order by 1,5,6;

--7.Find from Questions with not matching long name 
select form_name_new,q.long_name long_name,form_question correct_question,instructions,
m.display_order mod_order, q.display_order ,q.PREFERRED_DEFINITION,
q.qc_id,q.VERSION,q.QC_IDSEQ,q.QTL_NAME,q.CREATED_BY,q.MODIFIED_BY,
q.date_modified,q.DATE_CREATED
from sbrext.quest_contents_ext f,
MDSR_REDCAP_PROTOCOL_CSV r,
sbrext.quest_contents_ext  q,
sbrext.quest_contents_ext  m

where m.dn_crf_idseq =f.qc_idseq 
and f.long_name=r.form_name_new
and q.p_MOD_IDSEQ=m.qc_idseq
and f.QTL_NAME='CRF'
and m.QTL_NAME='MODULE'
and q.QTL_NAME ='QUESTION'
and m.display_order=r.SECTION_SEQ
and q.display_order=r.SECTION_Q_SEQ
and NVL(q.modified_by,'FORMLOADER') ='FORMLOADER'
and instr(form_question,trim(q.long_name))>0
and trim(form_question)<>trim(q.long_name)
order by 1,5,6;
--8.Find Question Instructions with truncated long name
select form_name_new,m.long_name mod_name,form_question correct_question,instructions,
i.long_name incorrect_instr,m.display_order mod_order, i.display_order ,i.PREFERRED_DEFINITION,
i.qc_id,i.VERSION,i.QC_IDSEQ,i.QTL_NAME,i.CREATED_BY,i.MODIFIED_BY,i.date_modified,i.DATE_CREATED
from sbrext.quest_contents_ext f,
MDSR_REDCAP_PROTOCOL_CSV r,
sbrext.quest_contents_ext  q,
sbrext.quest_contents_ext  i,
sbrext.quest_contents_ext  m

where m.dn_crf_idseq =f.qc_idseq 
and f.long_name=r.form_name_new
and q.p_MOD_IDSEQ=m.qc_idseq
and i.P_QST_IDSEQ =q.QC_IDSEQ
and f.QTL_NAME='CRF'
and m.QTL_NAME='MODULE'
and q.QTL_NAME ='QUESTION'
and i.QTL_NAME ='QUESTION_INSTR'
and m.display_order=r.SECTION_SEQ
and q.display_order=r.SECTION_Q_SEQ
and NVL(i.modified_by,'FORMLOADER') ='FORMLOADER'
and instructions is not null--and protocol not in ( list from check 1)
and load_seq=p_run
--and r.PROTOCOL='PX011402'
and instructions||'; Question in xml doesn''t contain valid CDE public id and version. Unable to validate question in xml.'<>i.long_name
order by 1,5,6;

--9. if not all questions where loaded ;




select  qc_id,  preferred_name,protocol,quest_sum,quest_sum_csv from

(SELECT COUNT (*) quest_sum_csv, PROTOCOL, form_name_new
                  FROM MDSR_REDCAP_PROTOCOL_CSV
                 WHERE protocol NOT LIKE 'Instr%'
                 and load_seq=1
              GROUP BY PROTOCOL, form_name_new) a,
              
              
              (SELECT COUNT (*) quest_sum, q.dn_crf_idseq,f.qc_id, p.preferred_name
                 FROM sbrext.quest_contents_ext f,
                 sbrext.quest_contents_ext q,
                 sbrext.PROTOCOL_QC_EXT pp,
                 sbrext.PROTOCOLS_EXT p
                 WHERE  f.QTL_NAME='CRF'
                 and  q.dn_crf_idseq =f.qc_idseq 
                 and q.QTL_NAME ='QUESTION' 
                and p.preferred_name like 'PX%'
                and f.QC_IDSEQ=pp.QC_IDSEQ
              and p.PROTO_IDSEQ=pp.PROTO_IDSEQ
              GROUP BY q.dn_crf_idseq,f.qc_id, p.preferred_name) b
              where protocol=preferred_name
              and quest_sum< quest_sum_csv;