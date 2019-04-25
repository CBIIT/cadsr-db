DROP PACKAGE SBREXT.MDSR_CDE_595_PKG;

CREATE OR REPLACE package SBREXT.MDSR_CDE_595_PKG 
 as 
    TYPE CDE_REC IS RECORD
   (
      CDE_ID        SBR.DATA_ELEMENTS.CDE_ID%TYPE,
      DE_VERSION       SBR.DATA_ELEMENTS.VERSION%TYPE
   );
   
  -- CDEArray   CDE_REC;
  type CDEArray  IS TABLE OF CDE_REC index by binary_integer; 
  
  TYPE CDE_REC_OUT IS  RECORD
  (   CDE_ID        SBR.DATA_ELEMENTS.CDE_ID%TYPE,
      DE_VERSION       SBR.DATA_ELEMENTS.VERSION%TYPE,
      LONG_NAME       SBR.DATA_ELEMENTS.LONG_NAME%TYPE,
      MODE_TYPE      varchar2(50),
      MODE_ORDER number(1)
       );

 TYPE CDE_SET_OUT IS  REF  CURSOR RETURN CDE_REC_OUT;
 TYPE type_de_search IS REF CURSOR;   --RETURN de_search_result%ROWTYPE;
  
 -- type charArray is table of varchar2(255) index by binary_integer; 
 
  
 procedure rtrieve_cde_by_id(p_cde_id IN   NUMBER,p_version IN  NUMBER ,p_de_search_res OUT type_de_search);
 procedure CDE_report(p_inputs in out CDEArray ); 
 procedure take_CDE_set(p_inputs in out CDEArray,
                      p_recordset OUT CDE_SET_OUT ); 
  
 -- procedure CDE_report2( p_CDE_ID in charArray,   p_DE_VERSION in charArray ); 
  
  end;
/


DROP PACKAGE SBREXT.MDSR_CDE_DEMO_PKG;

CREATE OR REPLACE package SBREXT.MDSR_CDE_DEMO_PKG 
 as 
    TYPE CDE_REC IS RECORD
   (
      CDE_ID        SBR.DATA_ELEMENTS.CDE_ID%TYPE,
      DE_VERSION       SBR.DATA_ELEMENTS.VERSION%TYPE
   );
   
  -- CDEArray   CDE_REC;
  type CDEArray  IS TABLE OF CDE_REC index by binary_integer; 

  
 -- type charArray is table of varchar2(255) index by binary_integer; 
  
 
  procedure CDE_report(p_inputs in out CDEArray ); 
  
 -- procedure CDE_report2( p_CDE_ID in charArray,   p_DE_VERSION in charArray ); 
  
  end;
/

DROP PACKAGE BODY SBREXT.MDSR_CDE_595_PKG;

CREATE OR REPLACE package body SBREXT.MDSR_CDE_595_PKG 
 as 
 procedure CDE_report( p_inputs IN OUT  CDEArray ) 
 is 
 V_inputs CDEArray:=p_inputs;
 begin 
  --for i in 1 .. v_inputs.count loop 
  FOR i IN v_inputs.first .. v_inputs.last LOOP
  DBMS_OUTPUT.PUT_LINE('CDE = '|| v_inputs(i).CDE_ID ||'VERSION = '||v_inputs(i).DE_VERSION);
  end loop; 
  end; 
  
  procedure take_CDE_set(p_inputs in out CDEArray,
                      p_recordset OUT CDE_SET_OUT)
 is 
  V_inputs CDEArray:=p_inputs;
  L_DATA CDE_MODE_TABLE_TYPE:= CDE_MODE_TABLE_TYPE();
  l_cnt number default 0; 
  l_LONG_NAME varchar2(500);
  l_mod varchar2(50);
  l_order number(1);
 begin 
 FOR i IN v_inputs.first .. v_inputs.last LOOP
 ---populate PL/SQL table record by record
 l_data.extend; 
 SELECT DE_NAME,MODULE_TYPE,MODULE_ORDER 
 into l_LONG_NAME,l_mod,l_order 
 FROM MDSR_STANDART_CDE_TYPE 
 where CDE_ID=v_inputs(i).CDE_ID and DE_VERSION=v_inputs(i).DE_VERSION;
  l_data(i) := 
 CDE_MODE_RECORD_TYPE( v_inputs(i).CDE_ID, v_inputs(i).DE_VERSION,l_LONG_NAME, l_mod,l_order); 
--Exit when l_refCur%NOTFOUND or l_refCur%NOTFOUND Is  NULL ;
 --13      end loop ;
 --14     Close l_refCur ;

 end loop;
  
  open p_recordset for 
  select * 
  from TABLE ( cast ( l_data as CDE_MODE_TABLE_TYPE) );  

  end;  

  procedure rtrieve_cde_by_id(p_cde_id IN   NUMBER,p_version IN  NUMBER ,p_de_search_res OUT type_de_search)
 is 

 begin 
 OPEN p_de_search_res FOR select *from MDSR_STANDART_CDE_TYPE 
 where CDE_ID=P_CDE_ID and DE_VERSION=p_VERSION;
  


  end;  

 end;
/


DROP PACKAGE BODY SBREXT.MDSR_CDE_DEMO_PKG;

CREATE OR REPLACE package body SBREXT.MDSR_CDE_DEMO_PKG 
 as 
 procedure CDE_report( p_inputs IN OUT  CDEArray ) 
 is 
 V_inputs CDEArray:=p_inputs;
 begin 
  --for i in 1 .. v_inputs.count loop 
  FOR i IN v_inputs.first .. v_inputs.last LOOP
  DBMS_OUTPUT.PUT_LINE('CDE = '|| v_inputs(i).CDE_ID ||'VERSION = '||v_inputs(i).DE_VERSION);
  end loop; 
  end; 


 
 end;
/
