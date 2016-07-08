alter table temp_permissible_values add(begin_date date,end_date date)
/

create or replace procedure     upd_pv_new
as
cursor c_upd_pv is select * from temp_permissible_values;
tvp_idseq VD_PVS.VP_IDSEQ%TYPE;
tpv_idseq VD_PVS.PV_IDSEQ%TYPE;
tpv_idseq2 VD_PVS.PV_IDSEQ%TYPE;
tvd_idseq VD_PVS.VD_IDSEQ%TYPE;
tvm_idseq PERMISSIBLE_VALUES.VM_IDSEQ%TYPE;
tshortmeaning PERMISSIBLE_VALUES.SHORT_MEANING%TYPE;
tmeaning_desc PERMISSIBLE_VALUES.MEANING_DESCRIPTION%TYPE;
t_pv_id PERMISSIBLE_VALUES.PV_IDSEQ%TYPE;
errmsg VARCHAR2(500);
t_begin_date date;
t_end_date date;

begin
for i in c_upd_pv loop
    begin
        Begin
        -- Step 1
            SELECT VD_PVS.VP_IDSEQ, VD_PVS.PV_IDSEQ, VD_PVS.VD_IDSEQ, pv.VM_IDSEQ ValueMeaningID, pv.SHORT_MEANING, pv.MEANING_DESCRIPTION,pv.begin_date,pv.end_date
            into tvp_idseq, tpv_idseq, tvd_idseq, tvm_idseq, tshortmeaning, tmeaning_desc,t_begin_date ,t_end_date
            FROM VD_PVS, PERMISSIBLE_VALUES pv
            WHERE VD_PVS.VD_IDSEQ = ( SELECT vd.VD_IDSEQ FROM VALUE_DOMAINS vd WHERE VD_ID = i.value_domain_id AND VERSION = i.value_domain_ver )
            AND VD_PVS.PV_IDSEQ = pv.PV_IDSEQ
            AND  ltrim(rtrim(pv.VALUE)) = ltrim(rtrim(i.existing_pv));
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                  dbms_output.put_line('Existing PV Not Found - '||i.value_domain_id||';'||ltrim(rtrim(i.existing_pv)));
            insert into PERMISSIBLE_VALUES_ERR VALUES (i.VALUE_DOMAIN_ID, i.VALUE_DOMAIN_VER, i.LONGNAME, i.TYPE, i.EXISTING_PV, i.DATE_MODIFIED, i.MODIFIED_BY, i.NEW_PV, 'Row Not Updated Due to Existing PV Not Found', sysdate);
            goto nextrec;
        END;

        Begin
        
          dbms_output.put_line('step2 - '||i.new_pv);
        -- Step 2
            SELECT PV_IDSEQ into tpv_idseq2
            FROM PERMISSIBLE_VALUES
            WHERE VM_IDSEQ = tvm_idseq
            AND VALUE = i.new_pv;
            
            UPDATE PERMISSIBLE_VALUES set 
            begin_date=case    when i.begin_date is not null then i.begin_date end
            , end_date=case   when i.end_date is not null then i.end_date  end
            WHERE VM_IDSEQ = tvm_idseq
            AND VALUE = i.new_pv;
        -- If Step 2 returns a value
         UPDATE VD_PVS set PV_IDSEQ = tpv_idseq2, date_modified = sysdate
            ,begin_date=case    when i.begin_date is not null then i.begin_date end
            , end_date=case   when i.end_date is not null then i.end_date  end
             WHERE VP_IDSEQ = tvp_idseq;
            IF SQL%ROWCOUNT = 0 THEN
              dbms_output.put_line('step3 - '||i.new_pv);
            insert into PERMISSIBLE_VALUES_ERR VALUES (i.VALUE_DOMAIN_ID, i.VALUE_DOMAIN_VER, i.LONGNAME, i.TYPE, i.EXISTING_PV, i.DATE_MODIFIED, i.MODIFIED_BY, i.NEW_PV, 'Row Not Updated Due to Value Domain ID Not Found', sysdate);
            END IF;
        EXCEPTION
     
            WHEN NO_DATA_FOUND THEN  --Insert New Record in PV
            Begin
               
         dbms_output.put_line('step4 - '||i.new_pv);
            select sbr.admincomponent_crud.cmr_guid into t_pv_id from dual;
            INSERT INTO PERMISSIBLE_VALUES (PV_IDSEQ
            , VALUE
            , SHORT_MEANING
            , MEANING_DESCRIPTION
            , BEGIN_DATE
             ,END_DATE
            , DATE_CREATED
            , CREATED_BY
            , DATE_MODIFIED
            , MODIFIED_BY
            , VM_IDSEQ)
            VALUES (t_pv_id
            , i.NEW_PV
            , tshortmeaning
            , tmeaning_desc
             ,case     when i.begin_date is not null then i.begin_date else sysdate end
            ,case      when i.end_date is not null then i.end_date end 
              ,sysdate
            , i.MODIFIED_BY
            , NULL
            , NULL
            , tvm_idseq);
            EXCEPTION
            WHEN OTHERS THEN
            errmsg := SQLERRM;
            insert into PERMISSIBLE_VALUES_ERR VALUES (i.VALUE_DOMAIN_ID, i.VALUE_DOMAIN_VER, i.LONGNAME, i.TYPE, i.EXISTING_PV, i.DATE_MODIFIED, i.MODIFIED_BY, i.NEW_PV, 'Error during Insert of New PV. '|| errmsg, sysdate);
            end;

            begin
            UPDATE VD_PVS SET PV_IDSEQ = t_pv_id, date_modified = sysdate 
             ,begin_date=case      
                      when i.begin_date is not null then i.begin_date end
             , end_date=case      
                      when i.end_date is not null then i.end_date end
            WHERE VP_IDSEQ = tvp_idseq;
            IF SQL%ROWCOUNT = 0 THEN
            insert into PERMISSIBLE_VALUES_ERR VALUES (i.VALUE_DOMAIN_ID, i.VALUE_DOMAIN_VER, i.LONGNAME, i.TYPE, i.EXISTING_PV, i.DATE_MODIFIED, i.MODIFIED_BY, i.NEW_PV, 'Row Not Updated Due to vp_idseq Not Found', sysdate);
            END IF;
            exception
            WHEN OTHERS THEN
            errmsg := SQLERRM;
             dbms_output.put_line('errmsg1 - '||errmsg);
            insert into PERMISSIBLE_VALUES_ERR VALUES (i.VALUE_DOMAIN_ID, i.VALUE_DOMAIN_VER, i.LONGNAME, i.TYPE, i.EXISTING_PV, i.DATE_MODIFIED, i.MODIFIED_BY, i.NEW_PV, 'Error in Update of VD_PVS '|| errmsg, sysdate);
            end;
        END;
    EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
         dbms_output.put_line('errmsg2 - '||errmsg);
        insert into PERMISSIBLE_VALUES_ERR VALUES (i.VALUE_DOMAIN_ID, i.VALUE_DOMAIN_VER, i.LONGNAME, i.TYPE, i.EXISTING_PV, i.DATE_MODIFIED, i.MODIFIED_BY, i.NEW_PV, errmsg, sysdate);
    end;
    <<nextrec>>
     Null; -- process next record.
end loop;
commit;
end;