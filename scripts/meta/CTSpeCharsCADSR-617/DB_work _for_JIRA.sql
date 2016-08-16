create table SBR.CT_PERMISSIBLE_VALUES_BACKUP
(
  PV_IDSEQ             CHAR(36 BYTE)            NOT NULL,
  VALUE                VARCHAR2(255 BYTE)       NOT NULL,
  SHORT_MEANING        VARCHAR2(255 BYTE)       NOT NULL,
  MEANING_DESCRIPTION  VARCHAR2(2000 BYTE),
  DATE_MODIFIED        DATE,
  MODIFIED_BY          VARCHAR2(30 BYTE),
  VM_IDSEQ             CHAR(36 BYTE)            NOT NULL
)
/
create table SBR.CT_VALUE_MEANINGS_BACKUP
(
  SHORT_MEANING         VARCHAR2(255 BYTE)      NOT NULL,
  DESCRIPTION           VARCHAR2(2000 BYTE),
  DATE_MODIFIED         DATE,
  MODIFIED_BY           VARCHAR2(30 BYTE),  
  VM_IDSEQ              CHAR(36 BYTE)           NOT NULL,
  PREFERRED_NAME        VARCHAR2(30 BYTE)       NOT NULL,
  PREFERRED_DEFINITION  VARCHAR2(2000 BYTE)     NOT NULL,
  LONG_NAME             VARCHAR2(255 BYTE),  
  VERSION               NUMBER                  NOT NULL,
  VM_ID                 NUMBER                  NOT NULL,
  CHANGE_NOTE           VARCHAR2(2000 BYTE)
)
/
CREATE OR REPLACE PROCEDURE SBR.CT_fix_sp_char_PV IS
v_date  date  ;
V_sdate date:=sysdate;
/******************************************************************************
   NAME:       CT_fix_sp_char_VM
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     CT_fix_sp_char_VM
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)
     
******************************************************************************/
BEGIN   


select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into SBR.CT_PERMISSIBLE_VALUES_BACKUP
(
  PV_IDSEQ            ,
  VALUE               ,
  SHORT_MEANING        ,
  MEANING_DESCRIPTION  ,
  DATE_MODIFIED       ,
  MODIFIED_BY         ,
  VM_IDSEQ             
)

select PV_IDSEQ            ,
  VALUE               ,
  SHORT_MEANING        ,
  MEANING_DESCRIPTION  ,
   DATE_MODIFIED       ,
  MODIFIED_BY         ,
  VM_IDSEQ   
from SBR.PERMISSIBLE_VALUES 
where INSTR(short_meaning,'&'||'gt;')>0 or
INSTR(short_meaning,'&'||'lt;')>0 or
INSTR(short_meaning,'&'||'amp;')>0 or
INSTR(short_meaning,'&'||'#32;')>0 or
INSTR(short_meaning,'&'||'#33;')>0 or
INSTR(short_meaning,'&'||'#34;')>0 or
INSTR(short_meaning,'&'||'#35;')>0 or
INSTR(short_meaning,'&'||'#36;')>0 or
INSTR(short_meaning,'&'||'#37;')>0 or
INSTR(short_meaning,'&'||'#38;')>0 or
INSTR(short_meaning,'&'||'#39;')>0 or
INSTR(short_meaning,'&'||'#40;')>0 or
INSTR(short_meaning,'&'||'#41;')>0 or
INSTR(short_meaning,'&'||'#42;')>0 or
INSTR(short_meaning,'&'||'#43;')>0 or
INSTR(short_meaning,'&'||'#44;')>0 or
INSTR(short_meaning,'&'||'#45;')>0 or
INSTR(short_meaning,'&'||'#46;')>0 or
INSTR(short_meaning,'&'||'#47;')>0 or
INSTR(short_meaning,'&'||'#60;')>0 or
INSTR(short_meaning,'&'||'#61;')>0 or
INSTR(short_meaning,'&'||'#62;')>0 or
INSTR(short_meaning,'&'||'#63;')>0 or
INSTR(short_meaning,'&'||'#64;')>0 or
INSTR(short_meaning,'&'||'#91;')>0 or
INSTR(short_meaning,'&'||'#92;')>0 or
INSTR(short_meaning,'&'||'#93;')>0 or
INSTR(short_meaning,'&'||'#94;')>0 or
INSTR(short_meaning,'&'||'#123;')>0 or
INSTR(short_meaning,'&'||'#124;')>0 or
INSTR(short_meaning,'&'||'#125;')>0 or
INSTR(short_meaning,'&'||'#126;')>0 or
INSTR(short_meaning,'&'||'#176;')>0 or
INSTR(short_meaning,'&'||'#177;')>0 or
INSTR(short_meaning,'&'||'#178;')>0 or
INSTR(short_meaning,'&'||'#179;')>0 or
INSTR(short_meaning,'&'||'#181;')>0 or
INSTR(short_meaning,'&'||'#191;')>0  ;
 --1  replace '&gt;' by '>'     
UPDATE SBR.PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'gt;','>') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'gt;','>'),
                              date_modified=v_date
 where INSTR(short_meaning,'&'||'gt;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'gt;')>0 ;
         
         UPDATE SBR.PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#62;','>') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#62;','>'),
                              date_modified=v_date
 where INSTR(short_meaning,'&'||'#62;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#62;')>0 ;
--2  replace '&lt;' by '<'

UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'lt;','<') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'lt;','<'),
                             date_modified=v_date
 where INSTR(short_meaning,'&'||'lt;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'lt;')>0 ;
         
 UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#60;','<') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#60;','<'),
                             date_modified=v_date
 where INSTR(short_meaning,'&'||'#60;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#60;')>0 ;        
         
--3  replace '&amp;' by '<'
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'amp;','&') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'amp;','&'),
                              date_modified=v_date
 where INSTR(short_meaning,'&'||'amp;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'amp;')>0  ;
         
 --3  replace '&amp;' by '<'
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#38;','&') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#38;','&'),
                              date_modified=v_date
 where INSTR(short_meaning,'&'||'#38;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#38;')>0  ;        
         
 
    ---   replace &#32; by '  '    
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#32;',' '),
                             MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#32;',' '),
                       date_modified=v_date
 where INSTR(short_meaning,'&'||'#32;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#32;')>0 ;   
                    
   ---   replace &#33; by !        
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#33;','!'),
                             MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#33;','!'),
                       date_modified=v_date
 where INSTR(short_meaning,'&'||'#33;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#33;')>0 ;    
         
    ---   replace &#34; by "       
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#34;','"'),
                             MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#34;','"'),
                       date_modified=v_date
 where INSTR(short_meaning,'&'||'#34;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#34;')>0 ;                  
         
   -- 4   $    &#35; 
           
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#35;','#'),
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#35;','#'),
                             date_modified=v_date
 where INSTR(short_meaning,'&'||'#35;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#35;')>0  ; 
           
   -- 5   $    &#36; 
           
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#36;','$'),
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#36;','$'),
                             date_modified=v_date
 where INSTR(short_meaning,'&'||'#36;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#36;')>0 ; 
   --6    %   &#37;          
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#37;','%'),
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#37;','%'),
                              date_modified=v_date
 where INSTR(short_meaning,'&'||'#37;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#37;')>0 ; 
         
  --6    &#39;    single quote      
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#39;',''''),
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#39;',''''),
                              date_modified=v_date
 where INSTR(short_meaning,'&'||'#39;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#39;')>0 ;         
             
           
    -- 7   (   &#40; 
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#40;','('),
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#40;','('),
                              date_modified=v_date
 where INSTR(short_meaning,'&'||'#40;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#40;')>0 ;
    --    )   &#41; 
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#41;',')'),
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#41;',')'),
                              date_modified=v_date
 where INSTR(short_meaning,'&'||'#41;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#41;')>0 ;          
                             
   --    *   &#42; 
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#42;','*'),
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#42;','*'),
date_modified=v_date
 where INSTR(short_meaning,'&'||'#42;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#42;')>0 ;  
           
   --    +    &#43; 
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#43;','+'),
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#43;','+'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#43;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#43;')>0 ;  
           
    --    -    &#45; 
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#45;','-'),
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#45;','-'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#45;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#45;')>0 ;     
         
            
    --    '.'    &#46; 
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#46;','.'),
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#46;','.'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#46;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#46;')>0 ;            
         
     --    /    &#47; 
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#47;','/'),
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#47;','/'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#47;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#47;')>0  ;
 --    =    &#61;        
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#61;','=') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#61;','='),
           date_modified=v_date
 where INSTR(short_meaning,'&'||'#61;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#61;')>0  ; 
           
 --    ?   &#63;        
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#63;','?') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#63;','?'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#63;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#63;')>0 ;
 
  --    ?   &#63;        
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#64;','@') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#64;','@'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#64;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#64;')>0 ;
                     
 --   [   &#91;  opening bracket      
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#91;','[') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#91;','['),
           date_modified=v_date
 where INSTR(short_meaning,'&'||'#91;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#91;')>0 ;  
           
  --   \   &#92;  backslash      
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#92;','\') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#92;','\'),
           date_modified=v_date
 where INSTR(short_meaning,'&'||'#92;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#92;')>0  ; 
           
 --  ]   &#93;  closing bracket      
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#93;',']') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#93;',']'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#93;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#93;')>0 ; 
           
 --  ^  &#94;  caret - circumflex     
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#94;','^') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#94;','^'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#94;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#94;')>0  ;  
           
           
 --  {  &#123;  opening brace     
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#123;','{') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#123;','{'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#123;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#123;')>0 ;  
         
         
 --  {  &#123;  opening brace     
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#124;','{') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#124;','|'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#124;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#124;')>0 ;          
           
 --  {  &#125;  closing brace    
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#125;','}') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#125;','}'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#125;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#125;')>0  ;                       

 --  ~  &#125;  equivalency sign - tilde    
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#126;','~') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#126;','~'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#126;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#126;')>0  ;  
         
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#191;','') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#191;',''),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#191;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#191;')>0  ;  
         
--  °  &#176;    degree sign
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#176;','°') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#176;','°'),
                       date_modified=v_date
 where INSTR(short_meaning,'&'||'#176;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#176;')>0 ;  
           
            --  ±  &#177;  plus-or-minus sign   
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#177;','±') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#177;','±'),
               date_modified=v_date
 where INSTR(short_meaning,'&'||'#177;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#177;')>0 ;  
            --  ² &#178;  superscript two - squared    
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#178;','²') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#178;','²'),
             date_modified=v_date
 where INSTR(short_meaning,'&'||'#178;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#178;')>0 ;
             
            --  ³  &#179;  superscript three - cubed   
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#179;','³') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#179;','³'),            
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#179;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#179;')>0;  
           
            --  µ  &#181;   micro sign  
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#181;','µ') ,                              
            MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#181;','µ'),                                 
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#181;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#181;')>0  ;  
         
           
           
           
                                                                               
 commit;  
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;-- Consider logging the error and then re-raise
       RAISE;
END CT_fix_sp_char_PV;
/
CREATE OR REPLACE PROCEDURE SBR.CT_fix_sp_char_VM IS
tmpVar NUMBER;
V_date date:=sysdate;
/******************************************************************************
   NAME:       CT_fix_sp_char_VM
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/11/2016   trushi2       1. Created this procedure.

   NOTES:
      Object Name:     CT_fix_sp_char_VM
      Sysdate:         8/11/2016
      Date and Time:   8/11/2016, 12:31:43 PM, and 8/11/2016 12:31:43 PM
      Username:        trushi2 (set in TOAD Options, Procedure Editor)
     
******************************************************************************/
BEGIN   

select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into  SBR.CT_VALUE_MEANINGS_BACKUP
(
  SHORT_MEANING        ,
  DESCRIPTION         ,
  DATE_MODIFIED        ,
  MODIFIED_BY          ,  
  VM_IDSEQ              ,
  PREFERRED_NAME        ,
  PREFERRED_DEFINITION  ,
  LONG_NAME             ,
  VERSION              ,
  VM_ID                 ,
  CHANGE_NOTE           
)
select SHORT_MEANING        ,
  DESCRIPTION         ,
  SYSDATE        ,
  'SBR'          ,  
  VM_IDSEQ              ,
  PREFERRED_NAME        ,
  PREFERRED_DEFINITION  ,
  LONG_NAME             ,
  VERSION              ,
  VM_ID                , 
  CHANGE_NOTE             
from SBR.VALUE_MEANINGS
where INSTR(short_meaning,'&'||'gt;')>0 or
INSTR(short_meaning,'&'||'lt;')>0 or
INSTR(short_meaning,'&'||'amp;')>0 or
INSTR(short_meaning,'&'||'#32;')>0 or
INSTR(short_meaning,'&'||'#33;')>0 or
INSTR(short_meaning,'&'||'#34;')>0 or
INSTR(short_meaning,'&'||'#35;')>0 or
INSTR(short_meaning,'&'||'#36;')>0 or
INSTR(short_meaning,'&'||'#37;')>0 or
INSTR(short_meaning,'&'||'#38;')>0 or
INSTR(short_meaning,'&'||'#39;')>0 or
INSTR(short_meaning,'&'||'#40;')>0 or
INSTR(short_meaning,'&'||'#41;')>0 or
INSTR(short_meaning,'&'||'#42;')>0 or
INSTR(short_meaning,'&'||'#43;')>0 or
INSTR(short_meaning,'&'||'#44;')>0 or
INSTR(short_meaning,'&'||'#45;')>0 or
INSTR(short_meaning,'&'||'#46;')>0 or
INSTR(short_meaning,'&'||'#47;')>0 or
INSTR(short_meaning,'&'||'#60;')>0 or
INSTR(short_meaning,'&'||'#61;')>0 or
INSTR(short_meaning,'&'||'#62;')>0 or
INSTR(short_meaning,'&'||'#63;')>0 or
INSTR(short_meaning,'&'||'#64;')>0 or
INSTR(short_meaning,'&'||'#91;')>0 or
INSTR(short_meaning,'&'||'#92;')>0 or
INSTR(short_meaning,'&'||'#93;')>0 or
INSTR(short_meaning,'&'||'#94;')>0 or
INSTR(short_meaning,'&'||'#123;')>0 or
INSTR(short_meaning,'&'||'#124;')>0 or
INSTR(short_meaning,'&'||'#125;')>0 or
INSTR(short_meaning,'&'||'#126;')>0 or
INSTR(short_meaning,'&'||'#176;')>0 or
INSTR(short_meaning,'&'||'#177;')>0 or
INSTR(short_meaning,'&'||'#178;')>0 or
INSTR(short_meaning,'&'||'#179;')>0 or
INSTR(short_meaning,'&'||'#181;')>0 or
INSTR(short_meaning,'&'||'#191;')>0  ;

 --replace '&gt;' by '>'     
UPDATE SBR.value_meanings set short_meaning=replace(short_meaning,'&'||'gt;','>') ,
                              description=replace(description,'&'||'gt;','>'),
            preferred_definition=replace(preferred_definition,'&'||'gt;','>'),
                                  long_name=replace(long_name,'&'||'gt;','>'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'gt;')>0 or
         INSTR(description,'&'||'gt;')>0 or
INSTR(preferred_definition,'&'||'gt;')>0 or
           INSTR(long_name,'&'||'gt;')>0 ;
           
 UPDATE SBR.value_meanings set short_meaning=replace(short_meaning,'&'||'#62;','>') ,
                              description=replace(description,'&'||'#62;','>'),
            preferred_definition=replace(preferred_definition,'&'||'#62;','>'),
                                  long_name=replace(long_name,'&'||'#62;','>'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#62;')>0 or
         INSTR(description,'&'||'#62;')>0 or
INSTR(preferred_definition,'&'||'#62;')>0 or
           INSTR(long_name,'&'||'#62;')>0 ;          
           
--replace '&lt;' by '<'

UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'lt;','<') ,
                              description=replace(description,'&'||'lt;','<'),
            preferred_definition=replace(preferred_definition,'&'||'lt;','<'),
                                  long_name=replace(long_name,'&'||'lt;','<'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'lt;')>0 or
         INSTR(description,'&'||'lt;')>0 or
INSTR(preferred_definition,'&'||'lt;')>0 or
           INSTR(long_name,'&'||'lt;')>0 ;
           
 --replace '&l#60;' by '<'

UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#60;','<') ,
                              description=replace(description,'&'||'#60;','<'),
            preferred_definition=replace(preferred_definition,'&'||'#60;','<'),
                                  long_name=replace(long_name,'&'||'#60;','<'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#60;')>0 or
         INSTR(description,'&'||'#60;')>0 or
INSTR(preferred_definition,'&'||'#60;')>0 or
           INSTR(long_name,'&'||'#60;')>0 ;          
           
           
--replace '&amp;' by '<'
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'amp;','&') ,
                              description=replace(description,'&'||'amp;','&'),
            preferred_definition=replace(preferred_definition,'&'||'amp;','&'),
                                  long_name=replace(long_name,'&'||'amp;','&'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'amp;')>0 or
         INSTR(description,'&'||'amp;')>0 or
INSTR(preferred_definition,'&'||'amp;')>0 or
           INSTR(long_name,'&'||'amp;')>0 ;
--replace '&38;' by '<'
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#38;','&') ,
                              description=replace(description,'&'||'#38;','&'),
            preferred_definition=replace(preferred_definition,'&'||'#38;','&'),
                                  long_name=replace(long_name,'&'||'#38;','&'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#38;')>0 or
         INSTR(description,'&'||'#38;')>0 or
INSTR(preferred_definition,'&'||'#38;')>0 or
           INSTR(long_name,'&'||'#38;')>0 ;  
           
   ---   replace &#33; by !        
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#32;',' '),
                              description=replace(description,'&'||'#32;',' '),
            preferred_definition=replace(preferred_definition,'&'||'#32;',' '),
                                  long_name=replace(long_name,'&'||'#32;',' '),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#32;')>0 or
         INSTR(description,'&'||'#32;')>0 or
INSTR(preferred_definition,'&'||'#32;')>0 or
           INSTR(long_name,'&'||'#32;')>0 ;              
                    
   ---   replace &#33; by !        
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#33;','!'),
                              description=replace(description,'&'||'#33;','!'),
            preferred_definition=replace(preferred_definition,'&'||'#33;','!'),
                                  long_name=replace(long_name,'&'||'#33;','!'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#33;')>0 or
         INSTR(description,'&'||'#33;')>0 or
INSTR(preferred_definition,'&'||'#33;')>0 or
           INSTR(long_name,'&'||'#33;')>0 ;   
           
   ---   replace &#34; by "double quotes!        
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#34;','"'),
                              description=replace(description,'&'||'#34;','"'),
            preferred_definition=replace(preferred_definition,'&'||'#34;','"'),
                                  long_name=replace(long_name,'&'||'#34;','"'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#34;')>0 or
         INSTR(description,'&'||'#34;')>0 or
INSTR(preferred_definition,'&'||'#34;')>0 or
           INSTR(long_name,'&'||'#34;')>0 ;                       
   --    $    &#35; 
           
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#35;','#'),
                              description=replace(description,'&'||'#35;','#'),
            preferred_definition=replace(preferred_definition,'&'||'#35;','#'),
                                  long_name=replace(long_name,'&'||'#35;','#'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#35;')>0 or
         INSTR(description,'&'||'#35;')>0 or
INSTR(preferred_definition,'&'||'#35;')>0 or
           INSTR(long_name,'&'||'#35;')>0 ; 
           
   --    $    &#36; 
           
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#36;','$'),
                              description=replace(description,'&'||'#36;','$'),
            preferred_definition=replace(preferred_definition,'&'||'#36;','$'),
                                  long_name=replace(long_name,'&'||'#36;','$'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#36;')>0 or
         INSTR(description,'&'||'#36;')>0 or
INSTR(preferred_definition,'&'||'#36;')>0 or
           INSTR(long_name,'&'||'#36;')>0 ; 
   --    %   &#37;          
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#37;','%'),
                              description=replace(description,'&'||'#37;','%'),
            preferred_definition=replace(preferred_definition,'&'||'#37;','%'),
                                  long_name=replace(long_name,'&'||'#37;','%'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#37;')>0 or
         INSTR(description,'&'||'#37;')>0 or
INSTR(preferred_definition,'&'||'#37;')>0 or
           INSTR(long_name,'&'||'#37;')>0 ;    
           
   --    %   &#37;          
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#39;',''''),
                              description=replace(description,'&'||'#39;',''''),
            preferred_definition=replace(preferred_definition,'&'||'#39;',''''),
                                  long_name=replace(long_name,'&'||'#39;',''''),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#39;')>0 or
         INSTR(description,'&'||'#39;')>0 or
INSTR(preferred_definition,'&'||'#39;')>0 or
           INSTR(long_name,'&'||'#39;')>0 ;           
           
            
           
    --    (   &#40; 
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#40;','('),
                              description=replace(description,'&'||'#40;','('),
            preferred_definition=replace(preferred_definition,'&'||'#40;','('),
                                  long_name=replace(long_name,'&'||'#40;','('),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#40;')>0 or
         INSTR(description,'&'||'#40;')>0 or
INSTR(preferred_definition,'&'||'#40;')>0 or
           INSTR(long_name,'&'||'#40;')>0 ;
    --    )   &#41; 
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#41;',')'),
                              description=replace(description,'&'||'#41;',')'),
            preferred_definition=replace(preferred_definition,'&'||'#41;',')'),
                                  long_name=replace(long_name,'&'||'#41;',')'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#41;')>0 or
         INSTR(description,'&'||'#41;')>0 or
INSTR(preferred_definition,'&'||'#41;')>0 or
           INSTR(long_name,'&'||'#41;')>0 ;          
                             
   --    *   &#42; 
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#42;','*'),
                              description=replace(description,'&'||'#42;','*'),
            preferred_definition=replace(preferred_definition,'&'||'#42;','*'),
                                  long_name=replace(long_name,'&'||'#42;','*'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#42;')>0 or
         INSTR(description,'&'||'#42;')>0 or
INSTR(preferred_definition,'&'||'#42;')>0 or
           INSTR(long_name,'&'||'#42;')>0 ;  
           
   --    +    &#43; 
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#43;','+'),
                              description=replace(description,'&'||'#43;','+'),
            preferred_definition=replace(preferred_definition,'&'||'#43;','+'),
                                  long_name=replace(long_name,'&'||'#43;','+'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#43;')>0 or
         INSTR(description,'&'||'#43;')>0 or
INSTR(preferred_definition,'&'||'#43;')>0 or
           INSTR(long_name,'&'||'#43;')>0 ;  
           
            
    --    -    &#45; 
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#44;',','),
                              description=replace(description,'&'||'#44;',','),
            preferred_definition=replace(preferred_definition,'&'||'#44;',','),
                                  long_name=replace(long_name,'&'||'#44;',','),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#44;')>0 or
         INSTR(description,'&'||'#44;')>0 or
INSTR(preferred_definition,'&'||'#44;')>0 or
           INSTR(long_name,'&'||'#44;')>0 ;           
           
    --    -    &#45; 
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#45;','-'),
                              description=replace(description,'&'||'#45;','-'),
            preferred_definition=replace(preferred_definition,'&'||'#45;','-'),
                                  long_name=replace(long_name,'&'||'#45;','-'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#45;')>0 or
         INSTR(description,'&'||'#45;')>0 or
INSTR(preferred_definition,'&'||'#45;')>0 or
           INSTR(long_name,'&'||'#45;')>0 ;    
           
    --    .    &#46; 
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#46;','.'),
                              description=replace(description,'&'||'#46;','.'),
            preferred_definition=replace(preferred_definition,'&'||'#46;','.'),
                                  long_name=replace(long_name,'&'||'#46;','.'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#46;')>0 or
         INSTR(description,'&'||'#46;')>0 or
INSTR(preferred_definition,'&'||'#46;')>0 or
           INSTR(long_name,'&'||'#46;')>0 ;            
                  
                               
     --    /    &#47; 
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#47;','/'),
                              description=replace(description,'&'||'#47;','/'),
            preferred_definition=replace(preferred_definition,'&'||'#47;','/'),
                                  long_name=replace(long_name,'&'||'#47;','/'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#47;')>0 or
         INSTR(description,'&'||'#47;')>0 or
INSTR(preferred_definition,'&'||'#47;')>0 or
           INSTR(long_name,'&'||'#47;')>0 ;
 --    =    &#61;        
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#61;','=') ,
                              description=replace(description,'&'||'#61;','='),
            preferred_definition=replace(preferred_definition,'&'||'#61;','='),
                                  long_name=replace(long_name,'&'||'#61;','='),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#61;')>0 or
         INSTR(description,'&'||'#61;')>0 or
INSTR(preferred_definition,'&'||'#61;')>0 or
           INSTR(long_name,'&'||'#61;')>0 ; 
           
 --    ?   &#63;        
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#63;','?') ,
                              description=replace(description,'&'||'#63;','?'),
            preferred_definition=replace(preferred_definition,'&'||'#63;','?'),
                                  long_name=replace(long_name,'&'||'#63;','?'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#63;')>0 or
         INSTR(description,'&'||'#63;')>0 or
INSTR(preferred_definition,'&'||'#63;')>0 or
           INSTR(long_name,'&'||'#63;')>0 ;
           
 --    @  &#64;        
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#64;','@') ,
                              description=replace(description,'&'||'#64;','@'),
            preferred_definition=replace(preferred_definition,'&'||'#64;','@'),
                                  long_name=replace(long_name,'&'||'#64;','@'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#64;')>0 or
         INSTR(description,'&'||'#64;')>0 or
INSTR(preferred_definition,'&'||'#64;')>0 or
           INSTR(long_name,'&'||'#64;')>0 ;           
           
           
 --   [   &#91;  opening bracket      
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#91;','[') ,
                              description=replace(description,'&'||'#91;','['),
            preferred_definition=replace(preferred_definition,'&'||'#91;','['),
                                  long_name=replace(long_name,'&'||'#91;','['),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#91;')>0 or
         INSTR(description,'&'||'#91;')>0 or
INSTR(preferred_definition,'&'||'#91;')>0 or
           INSTR(long_name,'&'||'#91;')>0 ;  
           
  --   \   &#92;  backslash      
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#92;','\') ,
                              description=replace(description,'&'||'#92;','\'),
            preferred_definition=replace(preferred_definition,'&'||'#92;','\'),
                                  long_name=replace(long_name,'&'||'#92;','\'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#92;')>0 or
         INSTR(description,'&'||'#92;')>0 or
INSTR(preferred_definition,'&'||'#92;')>0 or
           INSTR(long_name,'&'||'#92;')>0 ; 
           
 --  ]   &#93;  closing bracket      
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#93;',']') ,
                              description=replace(description,'&'||'#93;',']'),
            preferred_definition=replace(preferred_definition,'&'||'#93;',']'),
                                  long_name=replace(long_name,'&'||'#93;',']'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#93;')>0 or
         INSTR(description,'&'||'#93;')>0 or
INSTR(preferred_definition,'&'||'#93;')>0 or
           INSTR(long_name,'&'||'#93;')>0 ; 
           
 --  ^  &#94;  caret - circumflex     
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#94;','^') ,
                              description=replace(description,'&'||'#94;','^'),
            preferred_definition=replace(preferred_definition,'&'||'#94;','^'),
                                  long_name=replace(long_name,'&'||'#94;','^'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#94;')>0 or
         INSTR(description,'&'||'#94;')>0 or
INSTR(preferred_definition,'&'||'#94;')>0 or
           INSTR(long_name,'&'||'#94;')>0 ;  
           
           
 --  {  &#123;  opening brace     
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#123;','{') ,
                              description=replace(description,'&'||'#123;','{'),
            preferred_definition=replace(preferred_definition,'&'||'#123;','{'),
                                  long_name=replace(long_name,'&'||'#123;','{'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#123;')>0 or
         INSTR(description,'&'||'#123;')>0 or
INSTR(preferred_definition,'&'||'#123;')>0 or
           INSTR(long_name,'&'||'#123;')>0 ;  
           
  --  {  &#123;  opening brace     
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#124;','|') ,
                              description=replace(description,'&'||'#124;','|'),
            preferred_definition=replace(preferred_definition,'&'||'#124;','|'),
                                  long_name=replace(long_name,'&'||'#124;','|'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#124;')>0 or
         INSTR(description,'&'||'#124;')>0 or
INSTR(preferred_definition,'&'||'#124;')>0 or
           INSTR(long_name,'&'||'#124;')>0 ;          
           
           
 --  {  &#125;  closing brace    
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#125;','}') ,
                              description=replace(description,'&'||'#125;','}'),
            preferred_definition=replace(preferred_definition,'&'||'#125;','}'),
                                  long_name=replace(long_name,'&'||'#125;','}'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#125;')>0 or
         INSTR(description,'&'||'#125;')>0 or
INSTR(preferred_definition,'&'||'#125;')>0 or
           INSTR(long_name,'&'||'#125;')>0 ;                       

 --  ~  &#126;  equivalency sign - tilde    
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#126;','~') ,
                              description=replace(description,'&'||'#126;','~'),
            preferred_definition=replace(preferred_definition,'&'||'#126;','~'),
                                  long_name=replace(long_name,'&'||'#126;','~'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#126;')>0 or
         INSTR(description,'&'||'#126;')>0 or
INSTR(preferred_definition,'&'||'#126;')>0 or
           INSTR(long_name,'&'||'#126;')>0 ;    
           
           
 --  °  &#176;    degree sign
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#176;','°') ,
                              description=replace(description,'&'||'#176;','°'),
            preferred_definition=replace(preferred_definition,'&'||'#176;','°'),
                                  long_name=replace(long_name,'&'||'#176;','°'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#176;')>0 or
         INSTR(description,'&'||'#176;')>0 or
INSTR(preferred_definition,'&'||'#176;')>0 or
           INSTR(long_name,'&'||'#176;')>0 ;  
           
            --  ±  &#177;  plus-or-minus sign   
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#177;','±') ,
                              description=replace(description,'&'||'#177;','±'),
            preferred_definition=replace(preferred_definition,'&'||'#177;','±'),
                                  long_name=replace(long_name,'&'||'#177;','±'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#177;')>0 or
         INSTR(description,'&'||'#177;')>0 or
INSTR(preferred_definition,'&'||'#177;')>0 or
           INSTR(long_name,'&'||'#177;')>0 ;  
            --  ² &#178;  superscript two - squared    
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#178;','²') ,
                              description=replace(description,'&'||'#178;','²'),
            preferred_definition=replace(preferred_definition,'&'||'#178;','²'),
                                  long_name=replace(long_name,'&'||'#178;','²'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#178;')>0 or
         INSTR(description,'&'||'#178;')>0 or
INSTR(preferred_definition,'&'||'#178;')>0 or
           INSTR(long_name,'&'||'#178;')>0 ;
             
            --  ³  &#179;  superscript three - cubed   
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#179;','³') ,
                              description=replace(description,'&'||'#179;','³'),
            preferred_definition=replace(preferred_definition,'&'||'#179;','³'),
                                  long_name=replace(long_name,'&'||'#179;','³'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#179;')>0 or
         INSTR(description,'&'||'#179;')>0 or
INSTR(preferred_definition,'&'||'#179;')>0 or
           INSTR(long_name,'&'||'#179;')>0 ;  
           
            --  µ  &#181;   micro sign  
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#181;','µ') ,
                              description=replace(description,'&'||'#181;','µ'),
            preferred_definition=replace(preferred_definition,'&'||'#181;','µ'),
                                  long_name=replace(long_name,'&'||'#181;','µ'),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#181;')>0 or
         INSTR(description,'&'||'#181;')>0 or
INSTR(preferred_definition,'&'||'#181;')>0 or
           INSTR(long_name,'&'||'#181;')>0 ;  
         
           
           
           
           
  --  ¿ &#191;  inverted question mark   
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#191;','') ,
                              description=replace(description,'&'||'#191;',''),
            preferred_definition=replace(preferred_definition,'&'||'#191;',''),
                                  long_name=replace(long_name,'&'||'#191;',''),
            date_modified=v_date
 where INSTR(short_meaning,'&'||'#191;')>0 or
         INSTR(description,'&'||'#191;')>0 or
INSTR(preferred_definition,'&'||'#191;')>0 or
           INSTR(long_name,'&'||'#191;')>0 ;          
           
           
           
                                                                      
 commit;  
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;-- Consider logging the error and then re-raise
       RAISE;
END CT_fix_sp_char_vM;
/