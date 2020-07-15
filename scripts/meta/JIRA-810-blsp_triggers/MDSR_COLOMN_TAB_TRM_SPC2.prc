CREATE OR REPLACE PROCEDURE MDSR_COLOMN_TAB_TRM_SPC2(P_Table_name VARCHAR2, P_col_name VARCHAR2,P_col_val varchar2) IS
    TYPE loc_array_type IS TABLE OF VARCHAR2(40)
        INDEX BY binary_integer;
    dml_str VARCHAR2        (200);
    loc_array    loc_array_type;
BEGIN
        dml_str := 'UPDATE ' || P_Table_name || ' set date_modified=SYSDATE WHERE '||P_col_name||'='''|| P_col_val||'''';
        DBMS_OUTPUT.PUT_LINE(dml_str);
   EXECUTE IMMEDIATE dml_str ;
   commit;
   -- END LOOP;
END;
/