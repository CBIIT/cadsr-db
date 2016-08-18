CREATE OR REPLACE PROCEDURE SBREXT.CT_FIX_QUEST_CONTENTS_EXT IS
v_date  date  ;
V_sdate date:=sysdate;
/******************************************************************************
   NAME:       CT_FIX_QUEST_CONTENTS_EXT
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

update SBREXT.QUEST_CONTENTS_EXT SET LONG_NAME =SUBSTR (LONG_NAME, 0, 250)||'...'
where LENGTH (LONG_NAME) > 255
and (
INSTR(LONG_NAME,'&'||'gt;')>0 or
INSTR(LONG_NAME,'&'||'lt;')>0 or
INSTR(LONG_NAME,'&'||'amp;')>0 or
INSTR(LONG_NAME,'&'||'#')>0);

commit;
select to_date(to_char(sysdate,'mm/dd/yyyy')||'12:34:56','mm/dd/yyyyhh24:mi:ss')
into v_date from dual;

insert into  SBREXT.CT_QUEST_CONTENTS_EXT_BKUP
(
           QC_IDSEQ,                   
           PREFERRED_NAME,
           PREFERRED_DEFINITION,
           LONG_NAME,         
           DATE_MODIFIED,            
           MODIFIED_BY          
)

select     QC_IDSEQ,                   
           PREFERRED_NAME,
           PREFERRED_DEFINITION,
           LONG_NAME,         
           DATE_MODIFIED,                
           MODIFIED_BY
from SBREXT.QUEST_CONTENTS_EXT
where INSTR(PREFERRED_NAME,'&'||'gt;')>0 or
INSTR(PREFERRED_NAME,'&'||'lt;')>0 or
INSTR(PREFERRED_NAME,'&'||'amp;')>0 or
INSTR(PREFERRED_NAME,'&'||'#')>0 or 
INSTR(PREFERRED_DEFINITION,'&'||'gt;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'lt;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'amp;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#')>0  or
INSTR(LONG_NAME,'&'||'gt;')>0 or
INSTR(LONG_NAME,'&'||'lt;')>0 or
INSTR(LONG_NAME,'&'||'amp;')>0 or
INSTR(LONG_NAME,'&'||'#')>0;
/*
where INSTR(PREFERRED_DEFINITION,'&'||'gt;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'lt;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'amp;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#32;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#33;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#34;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#35;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#36;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#37;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#38;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#39;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#40;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#41;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#42;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#43;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#44;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#45;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#46;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#47;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#60;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#61;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#62;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#63;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#64;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#91;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#92;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#93;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#94;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#123;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#124;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#125;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#126;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#176;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#177;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#178;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#179;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#181;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#191;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#8804;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#8805;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#8800;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#8223;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#945;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#946;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#947;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#948;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#954;')>0 or
INSTR(PREFERRED_DEFINITION,'&'||'#955;')>0; */ 
 --1  replace '&gt;' by '>'     
 
 update QUEST_CONTENTS_EXT set  date_modified=v_date,
LONG_NAME= replace(LONG_NAME,'src=&#x6a;&#x61;&#x76;&#x61;&#x73;&#x63;&#x72;&#x69;&#x70;&#x74;&#x3a;alert&#x28;8481&#x29;','src=javascript:alert(8481);')
where INSTR(LONG_NAME,'src=&#x6a;&#x61;&#x76;&#x61;&#x73;&#x63;&#x72;&#x69;&#x70;&#x74;&#x3a;alert&#x28;8481&#x29;')>0 ;

update QUEST_CONTENTS_EXT set  date_modified=v_date,
PREFERRED_DEFINITION= replace(PREFERRED_DEFINITION,'src=&#x6a;&#x61;&#x76;&#x61;&#x73;&#x63;&#x72;&#x69;&#x70;&#x74;&#x3a;alert&#x28;8481&#x29;','src=javascript:alert(8481);')
where INSTR(PREFERRED_DEFINITION,'src=&#x6a;&#x61;&#x76;&#x61;&#x73;&#x63;&#x72;&#x69;&#x70;&#x74;&#x3a;alert&#x28;8481&#x29;')>0 ;


UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'gt;','>') ,   
PREFERRED_NAME=replace(PREFERRED_NAME,'&'||'gt;','>') ,  
LONG_NAME=replace(LONG_NAME,'&'||'gt;','>') ,                        
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'gt;')>0 
or  INSTR(LONG_NAME,'&'||'gt;')>0 ;
         
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#62;','>') , 
PREFERRED_NAME=replace(PREFERRED_NAME,'&'||'#62;','>') ,  
LONG_NAME=replace(LONG_NAME,'&'||'#62;','>') ,                               
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#62;')>0 
or  INSTR(LONG_NAME,'&'||'#62;')>0 ;
 
--2  replace '&lt;' by '<'

UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'lt;','<') ,  
PREFERRED_NAME=replace(PREFERRED_NAME,'&'||'lt;','<') ,
LONG_NAME=replace(LONG_NAME,'&'||'lt;','<') ,                              
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'lt;')>0
or  INSTR(LONG_NAME,'&'||'lt:')>0 ;
         
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#60;','<') , 
PREFERRED_NAME=replace(PREFERRED_NAME,'&'||'#60;','<') , 
LONG_NAME=replace(LONG_NAME,'&'||'#60;','<') ,                               
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#60;')>0 
or  INSTR(LONG_NAME,'&'||'#60;')>0 ;        
         
--3  replace '&amp;' by '<'
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'amp;','&') ,  
PREFERRED_NAME=replace(PREFERRED_NAME,'&'||'amp;','&') ,  
LONG_NAME=replace(LONG_NAME,'&'||'amp;','&') ,                           
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'amp;')>0 
or  INSTR(LONG_NAME,'&'||'amp;')>0 ;
--3  replace '&amp;' by '<'
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#38;','&') ,
PREFERRED_NAME=replace(PREFERRED_NAME,'&'||'#38;','&') , 
LONG_NAME=replace(LONG_NAME,'&'||'#38;','&') ,                              
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#38;')>0 
or  INSTR(LONG_NAME,'&'||'#38;')>0 ;        
         
 
---   replace &#32; by '  '    
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#32;',' '), 

LONG_NAME=replace(LONG_NAME,'&'||'#32;',' '),                             
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#32;')>0 
or  INSTR(LONG_NAME,'&'||'#32;')>0 ;  
                    
---   replace &#33; by !        
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#33;','!'), 

LONG_NAME=replace(LONG_NAME,'&'||'#33;','!'),                          
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#33;')>0
or  INSTR(LONG_NAME,'&'||'#33;')>0 ;  
         
---   replace &#34; by "       
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#34;','"'), 

LONG_NAME=replace(LONG_NAME,'&'||'#34;','"'),                          
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#34;')>0 
or  INSTR(LONG_NAME,'&'||'#34;')>0 ;                  
         
-- 4   #    &#35; 
           
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#35;','#'),  

LONG_NAME=replace(LONG_NAME,'&'||'#34;','"'),                              
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#35;')>0 
or  INSTR(LONG_NAME,'&'||'#35;')>0 ;
           
-- 5   $    &#36; 
           
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#36;','$'), 

LONG_NAME=replace(LONG_NAME,'&'||'#36;','$'),                                
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#36;')>0 
or  INSTR(LONG_NAME,'&'||'#36;')>0 ; 
--6    %   &#37;          
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#37;','%'), 

LONG_NAME=replace(LONG_NAME,'&'||'#37;','%'),                                
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#37;')>0
or  INSTR(LONG_NAME,'&'||'#37;')>0 ;
         
--6    &#39;    single quote      
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#39;',''''), 

LONG_NAME=replace(LONG_NAME,'&'||'#39;',''''),                               
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#39;')>0
or  INSTR(LONG_NAME,'&'||'#39;')>0 ;        
             
           
-- 7   (   &#40; 
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#40;','('),

LONG_NAME=replace(LONG_NAME,'&'||'#40;','('),                                
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#40;')>0
or  INSTR(LONG_NAME,'&'||'#40;')>0 ;
--    )   &#41; 
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#41;',')'),
 
LONG_NAME=replace(LONG_NAME,'&'||'#41;',')'),                                 
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#41;')>0 
or  INSTR(LONG_NAME,'&'||'#41;')>0 ;
--    *   &#42; 
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#42;','*'),
 
LONG_NAME=replace(LONG_NAME,'&'||'#42;','*'),                              
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#42;')>0 
or  INSTR(LONG_NAME,'&'||'#42;')>0 ;
--    +    &#43; 
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#43;','+'),  
 
LONG_NAME=replace(LONG_NAME,'&'||'#43;','+'),                           
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#43;')>0 
or  INSTR(LONG_NAME,'&'||'#43;')>0 ;  
           
--    -    &#45; 
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#45;','-'),

LONG_NAME=replace(LONG_NAME,'&'||'#45;','-'),                               
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#45;')>0 
or  INSTR(LONG_NAME,'&'||'#45;')>0 ;    
         
            
--    '.'    &#46; 
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#46;','.'),  

LONG_NAME=replace(LONG_NAME,'&'||'#46;','.'),                               
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#46;')>0 
or  INSTR(LONG_NAME,'&'||'#46;')>0 ;
--    /    &#47; 
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#47;','/'),

LONG_NAME=replace(LONG_NAME,'&'||'#47;','/'),  
                            
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#47;')>0 
or  INSTR(LONG_NAME,'&'||'#47;')>0 ;
--    =    &#61;        
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#61;','=') ,

LONG_NAME=replace(LONG_NAME,'&'||'#61;','=') ,  
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#61;')>0 
or  INSTR(LONG_NAME,'&'||'#61;')>0 ;
           
--    ?   &#63;        
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#63;','?') ,

LONG_NAME=replace(LONG_NAME,'&'||'#63;','?') , 
                            
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#63;')>0  
or  INSTR(LONG_NAME,'&'||'#63;')>0 ;
 
--    @  &#64;        
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#64;','@') ,

LONG_NAME=replace(LONG_NAME,'&'||'#64;','@') ,  
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#64;')>0  
or  INSTR(LONG_NAME,'&'||'#64;')>0 ;
                     
--   [   &#91;  opening bracket      
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#91;','[') ,

LONG_NAME=replace(LONG_NAME,'&'||'#91;',')'),
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#91;')>0 
or  INSTR(LONG_NAME,'&'||'#91;')>0 ;
--   \   &#92;  backslash      
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#92;','\') ,

LONG_NAME=replace(LONG_NAME,'&'||'#92;',')'),
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#92;')>0  
or  INSTR(LONG_NAME,'&'||'#92;')>0 ;
           
--  ]   &#93;  closing bracket      
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#93;',']') ,

LONG_NAME=replace(LONG_NAME,'&'||'#93;',')'),
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#93;')>0 
or  INSTR(LONG_NAME,'&'||'#93;')>0 ;
           
--  ^  &#94;  caret - circumflex     
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#94;','^') ,

LONG_NAME=replace(LONG_NAME,'&'||'#94;','^') ,
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#94;')>0 
or  INSTR(LONG_NAME,'&'||'#94;')>0 ; 
           
           
--  {  &#123;  opening brace     
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#123;','{') ,
LONG_NAME=replace(LONG_NAME,'&'||'#123;','{') , 
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#123;')>0 
or  INSTR(LONG_NAME,'&'||'#123;')>0 ;  
         
         
--  |  &#1234;  opening brace     
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#124;','|') ,

LONG_NAME=replace(LONG_NAME,'&'||'#124;','|') , 
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#124;')>0 
or  INSTR(LONG_NAME,'&'||'#124;')>0 ;         
           
--  }  &#125;  closing brace    
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#125;','}') ,

LONG_NAME=replace(LONG_NAME,'&'||'#125;','}') , 
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#125;')>0  
or  INSTR(LONG_NAME,'&'||'#125;')>0 ;
--  ~  &#126;  equivalency sign - tilde    
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#126;','~') ,

LONG_NAME=replace(LONG_NAME,'&'||'#126;','~') ,  
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#126;')>0 
or  INSTR(LONG_NAME,'&'||'#126;')>0 ;  
         
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#191;','') ,
LONG_NAME=replace(LONG_NAME,'&'||'#191;','') ,  
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#191;')>0 
or  INSTR(LONG_NAME,'&'||'#191;')>0 ;  
         
--  °  &#176;    degree sign
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#176;','°') ,
LONG_NAME=replace(LONG_NAME,'&'||'#176;','°') , 
       date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#176;')>0 
 
or  INSTR(LONG_NAME,'&'||'#176;')>0 ; 
           
--  ±  &#177;  plus-or-minus sign   
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#177;','±') ,
LONG_NAME=replace(LONG_NAME,'&'||'#177;','±') ,  
 date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#177;')>0 
or  INSTR(LONG_NAME,'&'||'#177;')>0 ;  
--  ² &#178;  superscript two - squared    
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#178;','²') ,
LONG_NAME=replace(LONG_NAME,'&'||'#178;','²') ,
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#178;')>0 
or  INSTR(LONG_NAME,'&'||'#178;')>0 ;            
--  ³  &#179;  superscript three - cubed   
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#179;','³') ,
LONG_NAME=replace(LONG_NAME,'&'||'#179;','³') ,
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#179;')>0 
or  INSTR(LONG_NAME,'&'||'#179;')>0 ;  
           
--  µ  &#181;   micro sign  
UPDATE QUEST_CONTENTS_EXT set PREFERRED_DEFINITION=replace(PREFERRED_DEFINITION,'&'||'#181;','µ') ,
LONG_NAME=replace(LONG_NAME,'&'||'#181;','µ') , 
date_modified=v_date
where INSTR(PREFERRED_DEFINITION,'&'||'#181;')>0
or  INSTR(LONG_NAME,'&'||'#181;')>0;  
         
           
 update QUEST_CONTENTS_EXT set  date_modified=v_date,
   PREFERRED_DEFINITION =
CASE

WHEN INSTR(PREFERRED_DEFINITION,'&'||'#8804;')>0 then  replace(PREFERRED_DEFINITION,'&'||'#8804;','<=')
WHEN INSTR(PREFERRED_DEFINITION,'&'||'#8805;')>0 then  replace(PREFERRED_DEFINITION,'&'||'#8805;','>=')
WHEN INSTR(PREFERRED_DEFINITION,'&'||'#8800;')>0 then  replace(PREFERRED_DEFINITION,'&'||'#8800;','<>')
WHEN INSTR(PREFERRED_DEFINITION,'&'||'#8223;')>0 then  replace(PREFERRED_DEFINITION,'&'||'#8223;','''')
WHEN INSTR(PREFERRED_DEFINITION,'&'||'#8322;')>0 then  replace(PREFERRED_DEFINITION,'&'||'#8322;','²')
end
where  INSTR(PREFERRED_DEFINITION,'&'||'#8804;')>0 
or INSTR(PREFERRED_DEFINITION,'&'||'#8805;')>0 
or INSTR(PREFERRED_DEFINITION,'&'||'#8800;')>0
or INSTR(PREFERRED_DEFINITION,'&'||'#8223;')>0
or INSTR(PREFERRED_DEFINITION,'&'||'#8322;')>0;  


 update QUEST_CONTENTS_EXT set  date_modified=v_date,
 LONG_NAME =
CASE
WHEN INSTR(LONG_NAME,'&'||'#8804;')>0 then  substr(replace(LONG_NAME,'&'||'#8804;','<='),1,250)
WHEN INSTR(LONG_NAME,'&'||'#8805;')>0 then  substr(replace(LONG_NAME,'&'||'#8805;','>='),1,250)
WHEN INSTR(LONG_NAME,'&'||'#8805;')>0 then  substr(replace(LONG_NAME,'&'||'#8800;','<>'),1,250)
WHEN INSTR(LONG_NAME,'&'||'#8223;')>0 then  substr(replace(LONG_NAME,'&'||'#8223;',''''),1,250)
WHEN INSTR(LONG_NAME,'&'||'#8322;')>0 then  replace(LONG_NAME,'&'||'#8322;','²')
end
where   INSTR(LONG_NAME,'&'||'#8804;')>0 
or INSTR(LONG_NAME,'&'||'#8805;')>0 
or INSTR(LONG_NAME,'&'||'#8800;')>0
or INSTR(LONG_NAME,'&'||'#8223;')>0
or INSTR(LONG_NAME,'&'||'#8322;')>0;             
           
 update QUEST_CONTENTS_EXT set  date_modified=v_date,
   PREFERRED_DEFINITION =
CASE

WHEN INSTR(PREFERRED_DEFINITION,'&'||'#945;')>0 then  replace(PREFERRED_DEFINITION,'&'||'#945;','alpha')
WHEN INSTR(PREFERRED_DEFINITION,'&'||'#946;')>0 then  replace(PREFERRED_DEFINITION,'&'||'#946;','beta')
WHEN INSTR(PREFERRED_DEFINITION,'&'||'#947;')>0 then  replace(PREFERRED_DEFINITION,'&'||'#947;','gamma')
WHEN INSTR(PREFERRED_DEFINITION,'&'||'#948;')>0 then  replace(PREFERRED_DEFINITION,'&'||'#948;','delta')
WHEN INSTR(PREFERRED_DEFINITION,'&'||'#954;')>0 then  replace(PREFERRED_DEFINITION,'&'||'#954;','lambda')
WHEN INSTR(PREFERRED_DEFINITION,'&'||'#955;')>0 then  replace(PREFERRED_DEFINITION,'&'||'#955;','kappa')
WHEN INSTR(PREFERRED_DEFINITION,'&'||'#223;')>0 then  substr(replace(PREFERRED_DEFINITION,'&'||'#223;','eszett'),1,250)
end

where  INSTR(PREFERRED_DEFINITION,'&'||'#945;')>0 
or INSTR(PREFERRED_DEFINITION,'&'||'#946;')>0 
or INSTR(PREFERRED_DEFINITION,'&'||'#947;')>0
or INSTR(PREFERRED_DEFINITION,'&'||'#948;')>0
or INSTR(PREFERRED_DEFINITION,'&'||'#954;')>0
or INSTR(PREFERRED_DEFINITION,'&'||'#955;')>0
or INSTR(PREFERRED_DEFINITION,'&'||'#223;')>0
;

 update QUEST_CONTENTS_EXT set  date_modified=v_date,
LONG_NAME =
CASE
WHEN INSTR(LONG_NAME,'&'||'#945;')>0 then  substr(replace(LONG_NAME,'&'||'#945;','alpha'),1,250)
WHEN INSTR(LONG_NAME,'&'||'#946;')>0 then  substr(replace(LONG_NAME,'&'||'#946;','beta'),1,250)
WHEN INSTR(LONG_NAME,'&'||'#947;')>0 then  substr(replace(LONG_NAME,'&'||'#947;','gamma'),1,250)
WHEN INSTR(LONG_NAME,'&'||'#948;')>0 then  substr(replace(LONG_NAME,'&'||'#948;','delta'),1,250)
WHEN INSTR(LONG_NAME,'&'||'#954;')>0 then  substr(replace(LONG_NAME,'&'||'#954;','lambda'),1,250)
WHEN INSTR(LONG_NAME,'&'||'#955;')>0 then  substr(replace(LONG_NAME,'&'||'#955;','kappa'),1,250)
WHEN INSTR(LONG_NAME,'&'||'#223;')>0 then  substr(replace(LONG_NAME,'&'||'#955;','eszett'),1,250)
end
where INSTR(LONG_NAME,'&'||'#945;')>0 
or INSTR(LONG_NAME,'&'||'#946;')>0 
or INSTR(LONG_NAME,'&'||'#947;')>0
or INSTR(LONG_NAME,'&'||'#948;')>0
or INSTR(LONG_NAME,'&'||'#954;')>0
or INSTR(LONG_NAME,'&'||'#955;')>0
or INSTR(LONG_NAME,'&'||'#223;')>0
; 
update QUEST_CONTENTS_EXT set  date_modified=v_date,
preferred_definition =
CASE
WHEN INSTR(preferred_definition,'&'||'#x61;')>0 then  replace(preferred_definition,'&'||'#x61;','a')
WHEN INSTR(preferred_definition,'&'||'#x62;')>0 then  replace(preferred_definition,'&'||'#x62;','b')
WHEN INSTR(preferred_definition,'&'||'#x63;')>0 then  replace(preferred_definition,'&'||'#x63;','c')
WHEN INSTR(preferred_definition,'&'||'#x64;')>0 then  replace(preferred_definition,'&'||'#x64;','d')
WHEN INSTR(PREFERRED_DEFINITION,'&'||'#565256;')>0 then  replace(PREFERRED_DEFINITION,'&'||'#565256;','red color')
WHEN INSTR(PREFERRED_DEFINITION,'&'||'#8594;')>0 then  replace(PREFERRED_DEFINITION,'&'||'#8594;','rightwards arrow')
WHEN INSTR(PREFERRED_DEFINITION,'&'||'#8596;')>0 then  replace(PREFERRED_DEFINITION,'&'||'#8596;','left right arrow')
WHEN INSTR(PREFERRED_DEFINITION,'&'||'#3425;')>0 then  replace(PREFERRED_DEFINITION,'&'||'#3425;','LL')
end
where INSTR(preferred_definition,'&'||'#x61;')>0 or
 INSTR(preferred_definition,'&'||'#x62;')>0 or
INSTR(preferred_definition,'&'||'#x63;')>0 or
 INSTR(preferred_definition,'&'||'#x64;')>0 or
   INSTR(preferred_definition,'&'||'#3425;')>0 or
 INSTR(preferred_definition,'&'||'#8596;')>0 or
 INSTR(preferred_definition,'&'||'#8594;')>0 or
INSTR(preferred_definition,'&'||'#3425;')>0 ;  

update QUEST_CONTENTS_EXT set  date_modified=v_date,
LONG_NAME=
CASE
WHEN INSTR(LONG_NAME,'&'||'#x61;')>0 then  replace(LONG_NAME,'&'||'#x61;','a')
WHEN INSTR(LONG_NAME,'&'||'#x62;')>0 then  replace(LONG_NAME,'&'||'#x62;','b')
WHEN INSTR(LONG_NAME,'&'||'#x63;')>0 then  replace(LONG_NAME,'&'||'#x63;','c')
WHEN INSTR(LONG_NAME,'&'||'#x64;')>0 then  replace(LONG_NAME,'&'||'#x64;','d')
WHEN INSTR(LONG_NAME,'&'||'#565256;')>0 then replace(LONG_NAME,'&'||'#565256;','red color')
WHEN INSTR(LONG_NAME,'&'||'#8594;')>0 then  replace(LONG_NAME,'&'||'#8594;','rightwards arrow')
WHEN INSTR(LONG_NAME,'&'||'#8596;')>0 then  replace(LONG_NAME,'&'||'#8596;','left right arrow')
WHEN INSTR(LONG_NAME,'&'||'#3425;')>0 then  replace(LONG_NAME,'&'||'#3425;','LL')
end
where INSTR(LONG_NAME,'&'||'#x61;')>0 or
 INSTR(LONG_NAME,'&'||'#x62;')>0 or
 INSTR(LONG_NAME,'&'||'#x63;')>0 or
 INSTR(LONG_NAME,'&'||'#x64;')>0 or 
 INSTR(LONG_NAME,'&'||'#3425;')>0 or
 INSTR(LONG_NAME,'&'||'#8596;')>0 or
 INSTR(LONG_NAME,'&'||'#8594;')>0 or
INSTR(LONG_NAME,'&'||'#3425;')>0 ;

                                                                             
 commit;  
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;-- Consider logging the error and then re-raise
       RAISE;
END CT_FIX_QUEST_CONTENTS_EXT;
/