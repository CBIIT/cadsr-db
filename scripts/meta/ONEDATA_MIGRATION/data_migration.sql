exec sp_preprocess;


--- Run in Work Area

spool wa_load.txt;

alter trigger TR_NCI_ALT_NMS_DENORM_INS disable;
alter trigger TR_NCI_AI_DENORM_INS disable;
alter trigger OD_TR_ADMIN_ITEM disable;
alter trigger TR_AI_AUD_TS disable;
alter trigger TR_AI_EXT_TAB_INS disable;


exec onedata_wa.sp_truncate_all;
exec onedata_wa.sp_migrate_lov;
exec onedata_wa.sp_create_ai_1;
exec onedata_wa.sp_create_ai_2;
exec onedata_wa.sp_create_ai_3;
exec onedata_wa.sp_create_ai_4;
exec onedata_wa.sp_create_pv;
exec onedata_wa.sp_create_csi;
exec onedata_wa.sp_create_ai_cncpt;
exec onedata_wa.sp_create_form_ext;
exec onedata_wa.sp_create_form_rel;
exec onedata_wa.sp_create_form_question_rel;
exec onedata_wa.sp_create_form_vv_inst;
exec onedata_wa.sp_create_form_vv_inst_2;
exec onedata_wa.sp_create_form_ta;
exec onedata_wa.sp_create_ai_children;
exec onedata_wa.sp_org_contact;

alter trigger TR_NCI_ALT_NMS_DENORM_INS enable;
alter trigger TR_NCI_AI_DENORM_INS enable;
alter trigger OD_TR_ADMIN_ITEM enable;
alter trigger TR_AI_AUD_TS enable;
alter trigger TR_AI_EXT_TAB_INS enable;

spool off;

analyze table admin_item compute statistics;
analyze table nci_admin_item_rel_alt_key compute statistics;
analyze table PERM_VAL compute statistics;


--- Run in Release Area

alter trigger TR_NCI_ALT_NMS_DENORM_INS disable;
alter trigger TR_NCI_AI_DENORM_INS disable;
alter trigger TR_AI_EXT_TAB_INS disable;

exec onedata_ra.sp_truncate_all;
exec onedata_ra.sp_insert_all;

alter trigger TR_NCI_ALT_NMS_DENORM_INS enable;
alter trigger TR_NCI_AI_DENORM_INS enable;
alter trigger TR_AI_EXT_TAB_INS enable;

analyze table admin_item compute statistics;
analyze table nci_admin_item_rel_alt_key compute statistics;
