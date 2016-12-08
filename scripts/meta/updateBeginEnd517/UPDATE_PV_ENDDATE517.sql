set serveroutput on size 1000000
SPOOL cadsrmeta-517b.log

CREATE OR REPLACE PROCEDURE SBR.MDSR_UPDATE_PV_ENDDATE
AS
errmsg VARCHAR2(2000);
cursor c_upd_pv is select * from sbr.MDSR_PV_UP_ENDDATE_TEMP;
tvp_idseq VD_PVS.VP_IDSEQ%TYPE;
tpv_idseq VD_PVS.PV_IDSEQ%TYPE;
tpv_idseq2 VD_PVS.PV_IDSEQ%TYPE;
tvd_idseq VD_PVS.VD_IDSEQ%TYPE;
tvm_idseq PERMISSIBLE_VALUES.VM_IDSEQ%TYPE;
tshortmeaning PERMISSIBLE_VALUES.SHORT_MEANING%TYPE;
tmeaning_desc PERMISSIBLE_VALUES.MEANING_DESCRIPTION%TYPE;
t_pv_id PERMISSIBLE_VALUES.PV_IDSEQ%TYPE;
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
            WHERE VD_PVS.VD_IDSEQ = ( SELECT vd.VD_IDSEQ FROM VALUE_DOMAINS vd WHERE VD_ID = i.vd_id AND VERSION = i.vd_ver )
            AND VD_PVS.PV_IDSEQ = pv.PV_IDSEQ
            AND  trim(pv.VALUE) = trim(i.pv_value);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                  dbms_output.put_line('Existing PV Not Found - '||i.vd_id||';'||trim(i.pv_value));
            insert into SBR.MDSR_PV_UPDATE_ERR VALUES (i.VD_ID, i.VD_VER, i.pv_value, 'Row Not Updated Due to Existing PV Not Found', sysdate);
            goto nextrec;
        END;

        UPDATE SBR.PERMISSIBLE_VALUES pv
        set date_modified = sysdate 
             ,begin_date=case      
                      when i.begin_date is not null then i.begin_date else pv.begin_date end
             , end_date=case      
                      when i.end_date is not null then i.end_date else pv.end_date end
              ,modified_by=i.modified_by
        WHERE  trim(pv.VALUE) = trim(i.pv_value) 
        and pv.PV_IDSEQ in
            (   SELECT pvs.PV_IDSEQ
                FROM VD_PVS pvs,VALUE_DOMAINS vd
                WHERE pvs.VD_IDSEQ = vd.VD_IDSEQ
                and VD_ID = i.vd_id
                AND VERSION = i.vd_ver);
                            
        UPDATE SBR.vd_pvs  pvs
        set date_modified = sysdate 
             ,begin_date=case      
                      when i.begin_date is not null then i.begin_date else pvs.begin_date end
             , end_date=case      
                      when i.end_date is not null then i.end_date else pvs.end_date end
                      ,modified_by=i.modified_by
        WHERE VD_IDSEQ in ( 
                select vd_idseq 
                from value_domains 
                where VD_ID = i.vd_id
                AND VERSION = i.vd_ver)
            and PV_IDSEQ in 
                (select PV.PV_IDSEQ from permissible_values pv,vd_pvs pvs1, value_domains vd
                where  PV.PV_IDSEQ = pvs1.PV_IDSEQ
                AND  pvs1.vd_idseq = VD.VD_IDSEQ 
                AND VD.vd_id = i.vd_id and VD.VERSION = i.vd_ver
                and trim(pv.VALUE) = trim(i.pv_value) );
   commit;    
 EXCEPTION

    WHEN OTHERS THEN
    rollback;
     errmsg := 'ERROR when update END_DATE for vd_ID='||i.vd_id||', ver='||i.vd_ver||' ,PV value='||trim(i.pv_value);
     errmsg := substr(trim(errmsg||':'|| SQLERRM),1,1900);
     dbms_output.put_line(errmsg);
    insert into MDSR_PV_UPDATE_ERR(COMMENTS,DATE_PROCESSED) VALUES (errmsg, sysdate);
    end;
    <<nextrec>>
    Null;
end loop;
 commit; 
end;
/

SPOOL OFF