set serveroutput on size 1000000
SPOOL cadsrFORMBUILD-592.log
CREATE OR REPLACE TRIGGER sbrext.QC_AIU_ROW
   AFTER INSERT OR UPDATE
   ON sbrext.quest_contents_ext
   REFERENCING OLD AS old NEW AS new
   FOR EACH ROW
-- PL/SQL Block
DECLARE
   qc_long_name_v   VARCHAR2 (255);
BEGIN
   -- Truncate Long Name column if column length is greater than 255 characters
   IF LENGTHB (:new.long_name) > 255
   THEN
      qc_long_name_v   := CONCAT ( (SUBSTRB (:new.long_name, 0, 250)), '...');
   ELSE
      qc_long_name_v   := :new.long_name;
   END IF;

   IF INSERTING
   THEN
      admincomponent_crud.crud_proc (pm_crudflag => 'I',
                                     pm_ideseq => :new.qc_idseq,
                                     pm_name => :new.preferred_name,
                                     pm_version => :new.version,
                                     pm_definition => :new.preferred_definition,
                                     pm_longname => qc_long_name_v,
                                     pm_context => :new.conte_idseq,
                                     pm_adminstatus => :new.asl_name,
                                     pm_latestversion => :new.latest_version_ind,
                                     pm_deleted => 'No',
                                     pm_admcomptype => 'QUEST_CONTENT',
                                     pm_begin_date => SYSDATE,
                                     pm_end_date => :new.end_date,
                                     pm_origin => :new.origin,
                                     pm_date_created => SYSDATE,
                                     pm_created_by => :new.created_by,
                                     pm_public_id => :new.qc_id
      );
   -- create QCID in designation

   /*if nvl(meta_global_pkg.transaction_type,'null') <> 'VERSION' then
        META_CONFIG_MGMT.CREATEDES(:NEW.QC_IDSEQ,:NEW.CONTE_IDSEQ,'QC_ID',:new.qc_id);

     end if; */
   ELSE
      admincomponent_crud.crud_proc (pm_crudflag => 'U',
                                     pm_ideseq => :new.qc_idseq,
                                     pm_name => :new.preferred_name,
                                     pm_version => :new.version,
                                     pm_definition => :new.preferred_definition,
                                     pm_longname => qc_long_name_v,
                                     pm_context => :new.conte_idseq,
                                     pm_adminstatus => :new.asl_name,
                                     pm_latestversion => :new.latest_version_ind,
                                     pm_deleted => :new.deleted_ind,
                                     pm_admcomptype => 'QUEST_CONTENT',
                                     pm_begin_date => :new.begin_date,
                                     pm_end_date => :new.end_date,
                                     pm_change_note => :new.change_note,
                                     pm_origin => :new.origin,
                                     pm_date_modified => SYSDATE,
                                     pm_modified_by => :new.modified_by,
                                     pm_public_id => :new.qc_id
      );
   END IF;
END;
/
SPOOL OFF