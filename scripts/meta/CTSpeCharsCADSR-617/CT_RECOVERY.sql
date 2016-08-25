
MERGE INTO SBR.VALUE_MEANINGS V
USING
(-- For more complicated queries you can use WITH clause here
SELECT * FROM SBR.CT_VALUE_MEANINGS_BKUP
)b
ON(v.vm_idseq=b.vm_idseq
and v.vm_id=b.vm_id
)
WHEN MATCHED THEN UPDATE SET
v.long_name = b.long_name,
v.preferred_definition = b.preferred_definition,
v.SHORT_MEANING = b.SHORT_MEANING,
v.DESCRIPTION = b.DESCRIPTION,
v.modified_by=b.modified_by,
v.date_modified=v.date_modified;

MERGE INTO SBR.PERMISSIBLE_VALUES v
USING
(-- For more complicated queries you can use WITH clause here
SELECT * FROM SBR.CT_PERMISSIBLE_VALUES_BKUP
)b
ON(v.pv_idseq=b.pv_idseq)
WHEN MATCHED THEN UPDATE SET
v.SHORT_MEANING = b.SHORT_MEANING,
v.MEANING_DESCRIPTION = b.MEANING_DESCRIPTION,
v.modified_by=b.modified_by,
v.date_modified=v.date_modified;


MERGE INTO SBREXT.QUEST_CONTENTS_EXT V
USING
(-- For more complicated queries you can use WITH clause here
SELECT * FROM SBREXT.CT_QUEST_CONTENTS_EXT_BKUP 
)b
ON(v.qc_idseq=b.qc_idseq
and v.preferred_name=b.preferred_name)
WHEN MATCHED THEN UPDATE SET
v.long_name = b.long_name,
v.preferred_definition = b.preferred_definition,
v.modified_by=b.modified_by,
v.date_modified=v.date_modified;

MERGE INTO SBREXT.ALID_VALUES_ATT_EXT V
USING
(-- For more complicated queries you can use WITH clause here
SELECT * FROM SBREXT.CT_VALID_VALUES_ATT_EXT_BKUP
)b
ON(v.qc_idseq=b.qc_idseq)
WHEN MATCHED THEN UPDATE SET
v.MEANING_TEXT = b.MEANING_TEXT,
v.DESCRIPTION_TEXT = b.DESCRIPTION_TEXT,
v.modified_by=b.modified_by,
v.date_modified=v.date_modified;
