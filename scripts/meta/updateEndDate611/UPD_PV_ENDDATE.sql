CREATE OR REPLACE PROCEDURE SBR.upd_pv_enddate(p_vd_ID IN number,p_ver in varchar,p_value in varchar ,p_date in varchar)
AS
errmsg VARCHAR2(2000);
begin
        UPDATE SBR.PERMISSIBLE_VALUES pv
        SET END_DATE = to_date(p_date,'DD-MON-YY')
        WHERE pv.VALUE = p_value 
        and pv.PV_IDSEQ in
            (   SELECT pvs.PV_IDSEQ
                FROM VD_PVS pvs,VALUE_DOMAINS vd
                WHERE pvs.VD_IDSEQ = vd.VD_IDSEQ
                and VD_ID=p_vd_ID
                AND VERSION = p_ver);
                            
        UPDATE SBR.vd_pvs  pvs
        SET END_DATE = to_date(p_date,'DD-MON-YY')    
        WHERE VD_IDSEQ in ( 
                select vd_idseq 
                from value_domains 
                where VD_ID=p_vd_ID
                AND VERSION = p_ver)
            and PV_IDSEQ in 
                (select PV.PV_IDSEQ from permissible_values pv,vd_pvs pvs, value_domains vd
                where  PV.PV_IDSEQ =pvs.PV_IDSEQ
                AND  pvs.vd_idseq= VD.VD_IDSEQ 
                AND VD.vd_id =p_vd_ID and VD.VERSION = p_ver
                and pv.value = p_value );
   commit;    
 EXCEPTION

    WHEN OTHERS THEN
    rollback;
     errmsg :='ERROR when update END_DATE for vd_ID='||p_vd_ID||', ver='||p_ver||' ,PV value='||p_value;
     errmsg :=  substr(trim(errmsg||':'|| SQLERRM),1,1900);
     dbms_output.put_line(errmsg);
    insert into PERMISSIBLE_VALUES_ERR  (COMMENTS,DATE_PROCESSED)VALUES ( errmsg, sysdate);

 commit; 
end;
/
exec SBR.upd_pv_enddate(2787943 ,'1','mU/mL' ,'23-JUN-16')
/