select qc_idseq from sbrext.quest_contents_ext where  qtl_name='CRF'  and long_name ='PhenX PX741401 - Use Of Tobacco Products'


PhenX PX060701 - Current Environmental Tobacco Smoke Exposure


select preferred_DEFINITION,long_name,display_order,mod.qtl_name,qc_id ,mod.modified_by,date_modified,date_created
from sbrext.quest_contents_ext mod
where dn_crf_idseq in (select qc_idseq from sbrext.quest_contents_ext where  qtl_name='CRF' and long_name like 'PhenX PX741401%')--rec.form_name)
and mod.qtl_name='MODULE'
--and change_note is not null
and mod.modified_by <>'FORMLOADER'--NVL(mod.modified_by ,'FORMLOADER') ='FORMLOADER';

select preferred_DEFINITION,long_name,display_order,mod.qtl_name,qc_id ,mod.modified_by,date_modified,date_created
from sbrext.quest_contents_ext mod
where dn_crf_idseq in (select qc_idseq from sbrext.quest_contents_ext where  qtl_name='CRF' and long_name like 'PhenX PX%')--rec.form_name)
--and DISPLAY_ORDER=rec.section_SEQ
and mod.qtl_name='QUESTION'
--and length(trim(mod.long_name))<>length(trim(SECTION))
and mod.modified_by is null='FORMLOADER'

select preferred_DEFINITION,long_name,display_order,mod.qtl_name,qc_id ,mod.modified_by,date_modified,date_created
from sbrext.quest_contents_ext mod
where dn_crf_idseq in (select qc_idseq from sbrext.quest_contents_ext where  qtl_name='CRF' and long_name like 'PhenX PX%')--rec.form_name)
--and DISPLAY_ORDER=rec.section_SEQ
and mod.qtl_name='QUESTION'
--and length(trim(mod.long_name))<>length(trim(SECTION))
and mod.modified_by is null='FORMLOADER'


