CREATE OR REPLACE PROCEDURE SBR.CT_fix_sp_char_PV IS
tmpVar NUMBER;
V_date date;
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



 --replace '&gt;' by '>'     
UPDATE SBR.PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'gt;','>') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'gt;','>'),
                              date_modified=v_date
 where INSTR(short_meaning,'&'||'gt;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'gt;')>0 ;
--replace '&lt;' by '<'

UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'lt;','<') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'lt;','<'),
                             date_modified=v_date
 where INSTR(short_meaning,'&'||'lt;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'lt;')>0 ;
--replace '&amp;' by '<'
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'amp;','&') ,
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'amp;','&'),
                              date_modified=v_date
 where INSTR(short_meaning,'&'||'amp;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'amp;')>0  ;
   --    $    &#35; 
           
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#35;','#'),
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#35;','#'),
                             date_modified=v_date
 where INSTR(short_meaning,'&'||'#35;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#35;')>0  ; 
           
   --    $    &#36; 
           
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#36;','$'),
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#36;','$'),
                             date_modified=v_date
 where INSTR(short_meaning,'&'||'#36;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#36;')>0 ; 
   --    %   &#37;          
UPDATE PERMISSIBLE_VALUES set short_meaning=replace(short_meaning,'&'||'#37;','%'),
                              MEANING_DESCRIPTION=replace(MEANING_DESCRIPTION,'&'||'#37;','%'),
                              date_modified=v_date
 where INSTR(short_meaning,'&'||'#37;')>0 or
         INSTR(MEANING_DESCRIPTION,'&'||'#37;')>0 ;     
           
    --    (   &#40; 
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
 commit;  
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;-- Consider logging the error and then re-raise
       RAISE;
END CT_fix_sp_char_PV;
/



