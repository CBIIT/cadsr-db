CREATE OR REPLACE VIEW MDSR_STANDART_CDE_TYPE
AS
     SELECT distinct case when MD.long_NAME LIKE 'Mandatory%'Then 'Mandatory'
     when MD.long_NAME LIKE 'Optional%'Then 'Optional' 
     when MD.long_NAME LIKE 'Conditional%'Then 'Conditional' 
     end 
     MODULE_TYPE,
      case when MD.long_NAME LIKE 'Mandatory%'Then '1'
     when MD.long_NAME LIKE 'Optional%'Then '2' 
     when MD.long_NAME LIKE 'Conditional%'Then '3' 
     end 
     MODULE_ORDER,            
            CDE_ID,
            DE.VERSION DE_VERSION,
            DE.LONG_NAME DE_NAME
       FROM SBREXT.QUEST_CONTENTS_EXT FR,
            SBREXT.QUEST_CONTENTS_EXT MD,
            SBREXT.QUEST_CONTENTS_EXT Q,
            SBR.DATA_ELEMENTS DE,
            SBREXT.PROTOCOL_QC_EXT PQ,
            SBREXT.PROTOCOLS_EXT p
      WHERE     MD.DN_CRF_IDSEQ = FR.QC_IDSEQ
            AND PQ.QC_IDSEQ = FR.QC_IDSEQ
            AND PQ.PROTO_IDSEQ = P.PROTO_IDSEQ
            AND TRIM (FR.QTL_NAME) = 'CRF'
            AND FR.ASL_NAME = 'RELEASED'
            AND FR.conte_idseq = '6BDC8E1A-E021-BC44-E040-BB89AD4365F6'
            AND Q.P_MOD_IDSEQ = MD.QC_IDSEQ
            AND TRIM (MD.QTL_NAME) = 'MODULE'
            AND TRIM (Q.QTL_NAME) = 'QUESTION'           
            AND Q.DE_IDSEQ = DE.DE_IDSEQ
            AND P.LONG_NAME = 'NCI Standard Template Forms'
   ORDER BY MODULE_ORDER,            
            CDE_ID,
            DE.VERSION  
	    
/

CREATE OR REPLACE TYPE CDE_MODE_RECORD_TYPE AS OBJECT
( 
    CDE_ID       NUMBER,
      DE_VERSION       NUMBER(4,2),
      LONG_NAME       varchar2(500),
      MODE_TYPE      varchar2(50),
      MODE_ORDER number(1)
);

create or replace type CDE_MODE_TABLE_TYPE as table of CDE_MODE_RECORD_TYPE/
create or replace package MDSR_CDE_595_PKG 
 as 
    TYPE CDE_REC IS RECORD
   (
      CDE_ID        SBR.DATA_ELEMENTS.CDE_ID%TYPE,
      DE_VERSION       SBR.DATA_ELEMENTS.VERSION%TYPE
   );

  type CDEArray  IS TABLE OF CDE_REC index by binary_integer; 
  
  TYPE CDE_REC_OUT
IS
  RECORD
  (
      CDE_ID        SBR.DATA_ELEMENTS.CDE_ID%TYPE,
      DE_VERSION       SBR.DATA_ELEMENTS.VERSION%TYPE,
      LONG_NAME       SBR.DATA_ELEMENTS.LONG_NAME%TYPE,
      MODE_TYPE      varchar2(50),
      MODE_ORDER number(1)
       )
/

TYPE CDE_SET_OUT  IS
      REF  CURSOR   RETURN CDE_REC_OUT;
 
  procedure CDE_report(p_inputs in out CDEArray ); 
   procedure take_CDE_set(p_inputs in out CDEArray,
                      p_recordset OUT CDE_SET_OUT );  

  
  end
  /
create or replace package body MDSR_CDE_595_PKG 
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
 end; 
 ///
 declare 
  my_data MDSR_CDE_595_PKG.CDEArray; 
 begin 
  my_data(1).CDE_ID := 1234; 
  my_data(1).DE_VERSION := 10; 
  
  my_data(2).CDE_ID := 1234; 
  my_data(2).DE_VERSION := 10; 
  
  MDSR_CDE_595_PKG.CDE_report( my_data ); 
  end; 
  
declare 
  my_data MDSR_CDE_595_PKG.CDEArray; 
   c_recordset MDSR_CDE_595_PKG.CDE_SET_OUT;
 begin 
  my_data(1).CDE_ID := 62589; 
  my_data(1).DE_VERSION := 6; 
  
  my_data(2).CDE_ID := 2003586; 
  my_data(2).DE_VERSION := 6;   
 -- c_recordset CDE_SET_OUT;--refcursor;

MDSR_CDE_595_PKG.take_CDE_set(my_data,:c_recordset );
end; 

create or replace function MDSR_F_CURREF return  sys_refcursor
IS
V_refcur sys_refcursor;
  my_data MDSR_CDE_595_PKG.CDEArray; 
   c_recordset MDSR_CDE_595_PKG.CDE_SET_OUT;
   V_ref sys_refcursor;
 begin 
  my_data(1).CDE_ID := 62589; 
  my_data(1).DE_VERSION := 6; 
  
  my_data(2).CDE_ID := 2003586; 
  my_data(2).DE_VERSION := 6;   
 -- c_recordset CDE_SET_OUT;--refcursor;

MDSR_CDE_595_PKG.take_CDE_set(my_data,V_ref );
return V_ref;
end;

select MDSR_F_CURREF  from dual;
