CREATE OR REPLACE TRIGGER SBR.VM_BIU_ROW_ASSIGN_VALUES
-- PL/SQL Block
  BEFORE INSERT OR UPDATE
  ON SBR.VALUE_MEANINGS   REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
DECLARE
  v_count number;  -- count for similar record existing in admin_components table
  v_vm_count number;  -- count for similar record with data type as 'VALUEMEANING' existing in admin_components table
  v_version varchar2(10);
  v_conte_idseq char(36);
BEGIN

  if :new.latest_version_ind is null then
    :new.latest_version_ind:='Yes';
  end if;
  if :new.vm_idseq is null Then
    :new.vm_idseq :=admincomponent_crud.cmr_guid;
  end if;
  if :new.deleted_ind is null then
    :new.deleted_ind := 'No';
  end if;
  if :new.asl_name is null  or :new.asl_name = 'DRAFT NEW' then
    :new.asl_name := 'RELEASED';
  end if;


 if :new.conte_idseq is null then
    select value into :new.conte_idseq
    from tool_options_ext
    where property = 'DEFAULT_CONTEXT'
    and tool_name = 'caDSR';
  end if;

  if :new.version is null then
    :new.version := 1.0;
  end if;




  IF INSERTING THEN

    if :new.created_by is null Then
      :new.created_by:=admin_security_util.effective_user;
    end if;
    if :new.date_created is null Then
      :new.date_created:=sysdate;
    end if;

  -- if changes are made using the view then update the long_name
  -- if changes are made using the table then update the short_meaning
    if :new.long_name is null and :new.short_meaning is not null then
       :new.long_name := :new.short_meaning;
    elsif :new.short_meaning is null and :new.long_name is not null then
       :new.short_meaning := :new.long_name;
    end if;

  -- if changes are made using the view then update the preferred_definition
  -- if changes are made using the table then update the description
    if :new.preferred_definition is null and nvl(:new.description,:new.short_meaning) is not null then
       :new.preferred_definition := nvl(:new.description,:new.short_meaning);
    elsif :new.description is null and :new.preferred_definition is not null then
       :new.description := :new.preferred_definition;
    end if;


    if nvl(meta_global_pkg.transaction_type,'null') <> 'VERSION' then
	  select cde_id_seq.nextval into :new.vm_id
	  from dual;
	end if;

	if(:new.preferred_name is null) then

	  :new.preferred_name := :new.vm_id;
	end if;




	-- 08-Apr-2004, W. Ver Hoef - added inserts to ac_change_history_ext
	meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	  'VALUE_MEANINGS', :new.vm_idseq, 'VM_IDSEQ', null, :new.VM_IDSEQ);

	meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	  'VALUE_MEANINGS', :new.vm_idseq, 'VERSION', null, to_char(:new.VERSION));

	meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	  'VALUE_MEANINGS', :new.vm_idseq, 'PREFERRED_NAME', null, :new.PREFERRED_NAME);

	meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	  'VALUE_MEANINGS', :new.vm_idseq, 'CONTE_IDSEQ', null, :new.CONTE_IDSEQ);

	meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	  'VALUE_MEANINGS', :new.vm_idseq, 'PREFERRED_DEFINITION', null, :new.PREFERRED_DEFINITION);


	meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	  'VALUE_MEANINGS', :new.vm_idseq, 'ASL_NAME', null, :new.ASL_NAME);

	meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	  'VALUE_MEANINGS', :new.vm_idseq, 'DATE_CREATED', null, to_char(:new.DATE_CREATED,'MM/DD/YYYY'));

	meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	  'VALUE_MEANINGS', :new.vm_idseq, 'CREATED_BY', null, :new.CREATED_BY);

	IF :new.BEGIN_DATE IS NOT NULL THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	    'VALUE_MEANINGS', :new.vm_idseq, 'BEGIN_DATE', null, to_char(:new.BEGIN_DATE,'MM/DD/YYYY'));
	END IF;

	IF :new.END_DATE IS NOT NULL THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	    'VALUE_MEANINGS', :new.vm_idseq, 'END_DATE', null, to_char(:new.END_DATE,'MM/DD/YYYY'));
	END IF;

	IF :new.CHANGE_NOTE IS NOT NULL THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	    'VALUE_MEANINGS', :new.vm_idseq, 'CHANGE_NOTE', null, :new.CHANGE_NOTE);
	END IF;


	IF :new.LONG_NAME IS NOT NULL THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	    'VALUE_MEANINGS', :new.vm_idseq, 'LONG_NAME', null, :new.LONG_NAME);
	END IF;


	IF :new.LATEST_VERSION_IND IS NOT NULL THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	    'VALUE_MEANINGS', :new.vm_idseq, 'LATEST_VERSION_IND', null, :new.LATEST_VERSION_IND);
	END IF;

	IF :new.DELETED_IND IS NOT NULL THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	    'VALUE_MEANINGS', :new.vm_idseq, 'DELETED_IND', null, :new.DELETED_IND);
	END IF;

	IF :new.DATE_MODIFIED IS NOT NULL THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	    'VALUE_MEANINGS', :new.vm_idseq, 'DATE_MODIFIED', null, to_char(:new.DATE_MODIFIED,'MM/DD/YYYY'));
	END IF;

	IF :new.MODIFIED_BY IS NOT NULL THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	    'VALUE_MEANINGS', :new.vm_idseq, 'MODIFIED_BY', null, :new.MODIFIED_BY);
	END IF;


	IF :new.ORIGIN IS NOT NULL THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	    'VALUE_MEANINGS', :new.vm_idseq, 'ORIGIN', null, :new.ORIGIN);
	END IF;

	IF :new.VM_ID IS NOT NULL THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'INSERT',
	    'VALUE_MEANINGS', :new.vm_idseq, 'VM_ID', null, to_char(:new.VM_ID));
	END IF;

  ELSE
    -- if changes are made using the view then update the long_name
    -- if changes are made using the table then update the short_meaning
    if :new.short_meaning<> :old.short_meaning then
       :new.long_name := :new.short_meaning;
    elsif :new.long_name <> :old.long_name  then
       :new.short_meaning := :new.long_name;
    end if;

  -- if changes are made using the view then update the preferred_definition
  -- if changes are made using the table then update the description

    if nvl(:new.description,' ')<> nvl(:old.description,' ') then
       :new.preferred_Definition := nvl(:new.description,:old.preferred_definition);
    elsif :new.preferred_Definition <> :old.preferred_Definition  then
       :new.description := :new.preferred_Definition;
    end if;


    :new.modified_by := admin_security_util.effective_user;
       :new.date_modified := sysdate;


	IF nvl(:old.VERSION,-999) <> nvl(:new.VERSION,-999) THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'VERSION', to_char(:old.VERSION), to_char(:new.VERSION));
	END IF;

	IF nvl(:old.PREFERRED_NAME,'%$#@!') <> nvl(:new.PREFERRED_NAME,'%$#@!') THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'PREFERRED_NAME', :old.PREFERRED_NAME, :new.PREFERRED_NAME);
	END IF;

	IF nvl(:old.CONTE_IDSEQ,'%$#@!') <> nvl(:new.CONTE_IDSEQ,'%$#@!') THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'CONTE_IDSEQ', :old.CONTE_IDSEQ, :new.CONTE_IDSEQ);
	END IF;

	IF nvl(:old.PREFERRED_DEFINITION,'%$#@!') <> nvl(:new.PREFERRED_DEFINITION,'%$#@!') THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'PREFERRED_DEFINITION', :old.PREFERRED_DEFINITION, :new.PREFERRED_DEFINITION);
	END IF;

	IF nvl(:old.BEGIN_DATE,'01-Jan-1900') <> nvl(:new.BEGIN_DATE,'01-Jan-1900') THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'BEGIN_DATE', to_char(:old.BEGIN_DATE,'MM/DD/YYYY'), to_char(:new.BEGIN_DATE,'MM/DD/YYYY'));
	END IF;



	IF nvl(:old.END_DATE,'01-Jan-1900') <> nvl(:new.END_DATE,'01-Jan-1900') THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'END_DATE', to_char(:old.END_DATE,'MM/DD/YYYY'), to_char(:new.END_DATE,'MM/DD/YYYY'));
	END IF;

	IF nvl(:old.ASL_NAME,'%$#@!') <> nvl(:new.ASL_NAME,'%$#@!') THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'ASL_NAME', :old.ASL_NAME, :new.ASL_NAME);
	END IF;

	IF nvl(:old.CHANGE_NOTE,'%$#@!') <> nvl(:new.CHANGE_NOTE,'%$#@!') THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'CHANGE_NOTE', :old.CHANGE_NOTE, :new.CHANGE_NOTE);
	END IF;


	IF nvl(:old.LONG_NAME,'%$#@!') <> nvl(:new.LONG_NAME,'%$#@!') THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'LONG_NAME', :old.LONG_NAME, :new.LONG_NAME);
	END IF;


	IF nvl(:old.LATEST_VERSION_IND,'%$#@!') <> nvl(:new.LATEST_VERSION_IND,'%$#@!') THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'LATEST_VERSION_IND', :old.LATEST_VERSION_IND, :new.LATEST_VERSION_IND);
	END IF;

	IF nvl(:old.DELETED_IND,'%$#@!') <> nvl(:new.DELETED_IND,'%$#@!') THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'DELETED_IND', :old.DELETED_IND, :new.DELETED_IND);
	END IF;

	IF nvl(:old.DATE_CREATED,'01-Jan-1900') <> nvl(:new.DATE_CREATED,'01-Jan-1900') THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'DATE_CREATED', to_char(:old.DATE_CREATED,'MM/DD/YYYY'), to_char(:new.DATE_CREATED,'MM/DD/YYYY'));
	END IF;

	IF nvl(:old.CREATED_BY,'%$#@!') <> nvl(:new.CREATED_BY,'%$#@!') THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'CREATED_BY', :old.CREATED_BY, :new.CREATED_BY);
	END IF;

	IF nvl(:old.DATE_MODIFIED,'01-Jan-1900') <> nvl(:new.DATE_MODIFIED,'01-Jan-1900') THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'DATE_MODIFIED', to_char(:old.DATE_MODIFIED,'MM/DD/YYYY'), to_char(:new.DATE_MODIFIED,'MM/DD/YYYY'));
	END IF;

	IF nvl(:old.MODIFIED_BY,'%$#@!') <> nvl(:new.MODIFIED_BY,'%$#@!') THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'MODIFIED_BY', :old.MODIFIED_BY, :new.MODIFIED_BY);
	END IF;


	IF nvl(:old.ORIGIN,'%$#@!') <> nvl(:new.ORIGIN,'%$#@!') THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'ORIGIN', :old.ORIGIN, :new.ORIGIN);
	END IF;

	IF nvl(:old.VM_ID,-999) <> nvl(:new.VM_ID,-999) THEN
	  meta_config_mgmt.ins_ac_chg_hist_ext(:new.vm_idseq, 'UPDATE',
	    'VALUE_MEANINGS', :new.vm_idseq, 'VM_ID', to_char(:old.VM_ID), to_char(:new.VM_ID));
	END IF;

  END IF;

  -- END IF;
END;
/