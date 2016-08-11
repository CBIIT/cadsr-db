CREATE OR REPLACE PROCEDURE CT_fix_sp_char_VM IS
tmpVar NUMBER;
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
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'gt;','>') ,
                              description=replace(description,'&'||'gt;','>'),
            preferred_definition=replace(preferred_definition,'&'||'gt;','>'),
                                  long_name=replace(long_name,'&'||'gt;','>')
 where INSTR(short_meaning,'&'||'gt;')>0 or
         INSTR(description,'&'||'gt;')>0 or
INSTR(preferred_definition,'&'||'gt;')>0 or
           INSTR(long_name,'&'||'gt;')>0 ;
--replace '&lt;' by '<'

UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'lt;','<') ,
                              description=replace(description,'&'||'lt;','<'),
            preferred_definition=replace(preferred_definition,'&'||'lt;','<'),
                                  long_name=replace(long_name,'&'||'lt;','<')
 where INSTR(short_meaning,'&'||'lt;')>0 or
         INSTR(description,'&'||'lt;')>0 or
INSTR(preferred_definition,'&'||'lt;')>0 or
           INSTR(long_name,'&'||'lt;')>0 ;
--replace '&amp;' by '<'
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'amp;','&') ,
                              description=replace(description,'&'||'amp;','&'),
            preferred_definition=replace(preferred_definition,'&'||'amp;','&'),
                                  long_name=replace(long_name,'&'||'amp;','&')
 where INSTR(short_meaning,'&'||'amp;')>0 or
         INSTR(description,'&'||'amp;')>0 or
INSTR(preferred_definition,'&'||'amp;')>0 or
           INSTR(long_name,'&'||'amp;')>0 ;
   --    $    &#35; 
           
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#35;','#'),
                              description=replace(description,'&'||'#35;','#'),
            preferred_definition=replace(preferred_definition,'&'||'#35;','#'),
                                  long_name=replace(long_name,'&'||'#35;','#')
 where INSTR(short_meaning,'&'||'#35;')>0 or
         INSTR(description,'&'||'#35;')>0 or
INSTR(preferred_definition,'&'||'#35;')>0 or
           INSTR(long_name,'&'||'#35;')>0 ; 
           
   --    $    &#36; 
           
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#36;','$'),
                              description=replace(description,'&'||'#36;','$'),
            preferred_definition=replace(preferred_definition,'&'||'#36;','$'),
                                  long_name=replace(long_name,'&'||'#36;','$')
 where INSTR(short_meaning,'&'||'#36;')>0 or
         INSTR(description,'&'||'#36;')>0 or
INSTR(preferred_definition,'&'||'#36;')>0 or
           INSTR(long_name,'&'||'#36;')>0 ; 
   --    %   &#37;          
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#37;','%'),
                              description=replace(description,'&'||'#37;','%'),
            preferred_definition=replace(preferred_definition,'&'||'#37;','%'),
                                  long_name=replace(long_name,'&'||'#37;','%')
 where INSTR(short_meaning,'&'||'#37;')>0 or
         INSTR(description,'&'||'#37;')>0 or
INSTR(preferred_definition,'&'||'#37;')>0 or
           INSTR(long_name,'&'||'#37;')>0 ;     
           
    --    (   &#40; 
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#40;','('),
                              description=replace(description,'&'||'#40;','('),
            preferred_definition=replace(preferred_definition,'&'||'#40;','('),
                                  long_name=replace(long_name,'&'||'#40;','(')
 where INSTR(short_meaning,'&'||'#40;')>0 or
         INSTR(description,'&'||'#40;')>0 or
INSTR(preferred_definition,'&'||'#40;')>0 or
           INSTR(long_name,'&'||'#40;')>0 ;
    --    )   &#41; 
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#41;',')'),
                              description=replace(description,'&'||'#41;',')'),
            preferred_definition=replace(preferred_definition,'&'||'#41;',')'),
                                  long_name=replace(long_name,'&'||'#41;',')')
 where INSTR(short_meaning,'&'||'#41;')>0 or
         INSTR(description,'&'||'#41;')>0 or
INSTR(preferred_definition,'&'||'#41;')>0 or
           INSTR(long_name,'&'||'#41;')>0 ;          
                             
   --    *   &#42; 
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#42;','*'),
                              description=replace(description,'&'||'#42;','*'),
            preferred_definition=replace(preferred_definition,'&'||'#42;','*'),
                                  long_name=replace(long_name,'&'||'#42;','*')
 where INSTR(short_meaning,'&'||'#42;')>0 or
         INSTR(description,'&'||'#42;')>0 or
INSTR(preferred_definition,'&'||'#42;')>0 or
           INSTR(long_name,'&'||'#42;')>0 ;  
           
   --    +    &#43; 
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#43;','+'),
                              description=replace(description,'&'||'#43;','+'),
            preferred_definition=replace(preferred_definition,'&'||'#43;','+'),
                                  long_name=replace(long_name,'&'||'#43;','+')
 where INSTR(short_meaning,'&'||'#43;')>0 or
         INSTR(description,'&'||'#43;')>0 or
INSTR(preferred_definition,'&'||'#43;')>0 or
           INSTR(long_name,'&'||'#43;')>0 ;  
           
    --    -    &#45; 
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#45;','-'),
                              description=replace(description,'&'||'#45;','-'),
            preferred_definition=replace(preferred_definition,'&'||'#45;','-'),
                                  long_name=replace(long_name,'&'||'#45;','-')
 where INSTR(short_meaning,'&'||'#45;')>0 or
         INSTR(description,'&'||'#45;')>0 or
INSTR(preferred_definition,'&'||'#45;')>0 or
           INSTR(long_name,'&'||'#45;')>0 ;           
                               
     --    /    &#47; 
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#47;','/'),
                              description=replace(description,'&'||'#47;','/'),
            preferred_definition=replace(preferred_definition,'&'||'#47;','/'),
                                  long_name=replace(long_name,'&'||'#47;','/')
 where INSTR(short_meaning,'&'||'#47;')>0 or
         INSTR(description,'&'||'#47;')>0 or
INSTR(preferred_definition,'&'||'#47;')>0 or
           INSTR(long_name,'&'||'#47;')>0 ;
 --    =    &#61;        
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#61;','=') ,
                              description=replace(description,'&'||'#61;','='),
            preferred_definition=replace(preferred_definition,'&'||'#61;','='),
                                  long_name=replace(long_name,'&'||'#61;','=')
 where INSTR(short_meaning,'&'||'#61;')>0 or
         INSTR(description,'&'||'#61;')>0 or
INSTR(preferred_definition,'&'||'#61;')>0 or
           INSTR(long_name,'&'||'#61;')>0 ; 
           
 --    ?   &#63;        
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#63;','?') ,
                              description=replace(description,'&'||'#63;','?'),
            preferred_definition=replace(preferred_definition,'&'||'#63;','?'),
                                  long_name=replace(long_name,'&'||'#63;','?')
 where INSTR(short_meaning,'&'||'#63;')>0 or
         INSTR(description,'&'||'#63;')>0 or
INSTR(preferred_definition,'&'||'#63;')>0 or
           INSTR(long_name,'&'||'#63;')>0 ;
           
 --   [   &#91;  opening bracket      
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#91;','[') ,
                              description=replace(description,'&'||'#91;','['),
            preferred_definition=replace(preferred_definition,'&'||'#91;','['),
                                  long_name=replace(long_name,'&'||'#91;','[')
 where INSTR(short_meaning,'&'||'#91;')>0 or
         INSTR(description,'&'||'#91;')>0 or
INSTR(preferred_definition,'&'||'#91;')>0 or
           INSTR(long_name,'&'||'#91;')>0 ;  
           
  --   \   &#92;  backslash      
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#92;','\') ,
                              description=replace(description,'&'||'#92;','\'),
            preferred_definition=replace(preferred_definition,'&'||'#92;','\'),
                                  long_name=replace(long_name,'&'||'#92;','\')
 where INSTR(short_meaning,'&'||'#92;')>0 or
         INSTR(description,'&'||'#92;')>0 or
INSTR(preferred_definition,'&'||'#92;')>0 or
           INSTR(long_name,'&'||'#92;')>0 ; 
           
 --  ]   &#93;  closing bracket      
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#93;',']') ,
                              description=replace(description,'&'||'#93;',']'),
            preferred_definition=replace(preferred_definition,'&'||'#93;',']'),
                                  long_name=replace(long_name,'&'||'#93;',']')
 where INSTR(short_meaning,'&'||'#93;')>0 or
         INSTR(description,'&'||'#93;')>0 or
INSTR(preferred_definition,'&'||'#93;')>0 or
           INSTR(long_name,'&'||'#93;')>0 ; 
           
 --  ^  &#94;  caret - circumflex     
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#94;','^') ,
                              description=replace(description,'&'||'#94;','^'),
            preferred_definition=replace(preferred_definition,'&'||'#94;','^'),
                                  long_name=replace(long_name,'&'||'#94;','^')
 where INSTR(short_meaning,'&'||'#94;')>0 or
         INSTR(description,'&'||'#94;')>0 or
INSTR(preferred_definition,'&'||'#94;')>0 or
           INSTR(long_name,'&'||'#94;')>0 ;  
           
           
 --  {  &#123;  opening brace     
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#123;','{') ,
                              description=replace(description,'&'||'#123;','{'),
            preferred_definition=replace(preferred_definition,'&'||'#123;','{'),
                                  long_name=replace(long_name,'&'||'#123;','{')
 where INSTR(short_meaning,'&'||'#123;')>0 or
         INSTR(description,'&'||'#123;')>0 or
INSTR(preferred_definition,'&'||'#123;')>0 or
           INSTR(long_name,'&'||'#123;')>0 ;  
           
 --  {  &#125;  closing brace    
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#125;','}') ,
                              description=replace(description,'&'||'#125;','}'),
            preferred_definition=replace(preferred_definition,'&'||'#125;','}'),
                                  long_name=replace(long_name,'&'||'#125;','}')
 where INSTR(short_meaning,'&'||'#125;')>0 or
         INSTR(description,'&'||'#125;')>0 or
INSTR(preferred_definition,'&'||'#125;')>0 or
           INSTR(long_name,'&'||'#125;')>0 ;                       

 --  ~  &#125;  equivalency sign - tilde    
UPDATE value_meanings set short_meaning=replace(short_meaning,'&'||'#126;','~') ,
                              description=replace(description,'&'||'#126;','~'),
            preferred_definition=replace(preferred_definition,'&'||'#126;','~'),
                                  long_name=replace(long_name,'&'||'#126;','~')
 where INSTR(short_meaning,'&'||'#126;')>0 or
         INSTR(description,'&'||'#126;')>0 or
INSTR(preferred_definition,'&'||'#126;')>0 or
           INSTR(long_name,'&'||'#126;')>0 ;                                                               
 commit;  
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       NULL;-- Consider logging the error and then re-raise
       RAISE;
END CT_fix_sp_char_VM;



/
