set serveroutput on size 1000000
SPOOL cadsrmeta-598p.log
  
CREATE OR REPLACE PROCEDURE SBREXT.UPLOAD_VALIDATE_PROTOCOL AS 

cursor c_prot is select * 
from sbrext.MDSR_PROTOCOLS_TEMP ;
errmsg VARCHAR2(4000):=''; 
v_proto_idseq  VARCHAR2(500) ;
v_protoid number;
v_conte_idseq  VARCHAR2(500) ;
v_org_idseq  VARCHAR2(500) ;
v_cnt number:=0;
v_length number :=0;

begin
for i in c_prot loop
  
   begin 
          errmsg  :=''; 
          IF   i.PROTOCOL_ID is null then
          errmsg:='PROTOCOL id IS NULL';
          end if;
          
          IF   i.PREFERRED_name is null then
          IF  length(NVL(errmsg,'A'))>1 THEN
          errmsg:= errmsg||';PREFERRED name IS NULL';
          ELSE 
          errmsg:= errmsg||'PREFERRED name IS NULL';
          END IF;         
          end if;
          
          IF   i.PREFERRED_DEFINITION is null then
          IF  length(NVL(errmsg,'A'))>1 THEN
          errmsg:= errmsg||';PREFERRED_DEFINITION IS NULL';
          ELSE 
          errmsg:= errmsg||'PREFERRED_DEFINITION IS NULL';
          END IF;
          END IF;
          
          IF   i.long_name is null then
          IF  length(errmsg)>1 THEN
          errmsg:= errmsg||';Long name IS NULL';
          ELSE 
          errmsg:= errmsg||'Long name IS NULL';
          END IF;         
          end if; 
          
          IF i.workflow  is null then
          IF  length(errmsg)>1 THEN
          errmsg:= errmsg||';Workflow IS NULL';
          ELSE 
          errmsg:= errmsg||'Workflow  IS NULL';
          END IF;         
          end if; 
          
            
           
          v_cnt:=0;
          IF   i.CONTEXT  is null then
          IF  length(errmsg)>1 THEN
          errmsg:= errmsg||'; Context IS NULL';
          ELSE 
          errmsg:= errmsg||' Context  IS NULL';
          END IF;  
          else
          select count(*)  into v_cnt from sbr.contexts where trim(name) =trim(i.CONTEXT);
          IF v_cnt = 0 THEN 
          if length(errmsg)>1 THEN
           errmsg:= errmsg||';Invailid Context ';
           else
           errmsg:= errmsg||'Invailid Context ';
           end if;
           else 
           select conte_idseq into v_conte_idseq from sbr.contexts where trim(name) =trim(i.CONTEXT);
           end if;          
           end if;  
      
          /*v_cnt:=0;
          SELECT     count(*)   into v_cnt
          FROM PROTOCOLS_EXT p
          WHERE    ltrim(rtrim(p.protocol_id)) = ltrim(rtrim(i.protocol_id));
          
          IF v_cnt > 0 THEN
          IF  length(errmsg)>1 THEN
          errmsg:= errmsg||'; Exsisting Protocol';
          ELSE
          errmsg:=  'Exsisting Protocol';
          END IF;
          END  IF;   */ 
            
          v_cnt:=0;  
          IF i.lead_org is not null then
          select count(*) into v_cnt from SBR.ORGANIZATIONS where name=i.lead_org;
             
          IF v_cnt = 0 THEN 
          if length(errmsg)>1 THEN
          errmsg:= errmsg||';Invailid Organisation ';
          else
          errmsg:= errmsg||'Invailid Organisation ';
          end if;
          end if; 
          end if; 
          
          
          
          IF   length(trim(i.origin))> 500 then 
          DBMS_output.put_line('Origin IS '||length(trim(i.origin))||' Characters;It has to be not over 500');
          IF  length(errmsg)>1 THEN
          errmsg:= errmsg||'; Origin IS '||length(trim(i.origin))||' Characters;It has to be not over 500' ;
          ELSE 
          errmsg:= errmsg||' Origin IS '||length(trim(i.origin))||' Characters;It has to be not over 500' ;
          END IF;         
          end if; 
          
          
           IF   length(trim(i.PREFERRED_DEFINITION))> 2000 then 
          DBMS_output.put_line('PREFERRED DEFINITION IS '||length(trim(i.PREFERRED_DEFINITION))||' Characters;It has to be not over 2000');
          IF  length(errmsg)>1 THEN
          errmsg:= errmsg||'; PREFERRED DEFINITIONIS '||length(trim(i.PREFERRED_DEFINITION))||' Characters;It has to be not over 2000' ;
          ELSE 
          errmsg:= errmsg||' PREFERRED DEFINITION IS '||length(trim(i.PREFERRED_DEFINITION))||' Characters;It has to be not over 2000' ;
          END IF;         
          end if; 
          
          IF trim(i.TYPE) not IN ('Treatment trials', 'Prevention trials', 'Screening trials', 'Quality of Life trials') THEN
           DBMS_output.put_line(' TYPE '||trim(i.TYPE)||' violated check constraint') ;
           i.TYPE:=null;
          /*IF  length(errmsg)>1 THEN
          errmsg:= errmsg||'; TYPE '||trim(i.TYPE)||' is violated check constraint' ;
          ELSE 
          errmsg:= errmsg||' TYPE '||trim(i.TYPE)||' is violated check constraint' ;
          END IF;  */       
          end if; 
        
        IF length(errmsg)>1 then 
         dbms_output.put_line('err+ length - '||length(errmsg)||'errmsg1 - '||errmsg);
         
           insert into MDSR_PROTOCOLS_ERR_LOG VALUES (i.PROTOCOL_ID,sysdate,errmsg, i.PREFERRED_name, i.LONG_NAME,i.PREFERRED_DEFINITION,   i.CONTEXT, i.WORKFLOW,i.origin ,i.TYPE,i.PHASE,i.LEAD_ORG); 
       -- goto nextrec; 
         end IF; 
   
  
   
        IF (NVL(errmsg,'A'))='A' or errmsg='' then 
  

            select sbr.admincomponent_crud.cmr_guid into v_PROTO_IDSEQ from dual;
            select cde_id_seq.nextval into V_protoid from dual;
      
            INSERT INTO protocols_EXT (PROTO_IDSEQ
            ,version
            ,CONTE_IDSEQ
            ,PREFERRED_NAME 
	        ,PREFERRED_DEFINITION 
            ,ASL_NAME 
	        ,LONG_NAME
            ,TYPE  
	        ,PHASE 
	        ,LEAD_ORG
            ,PROTOCOL_ID
            ,PROTO_ID
            ,DATE_CREATED
            ,CREATED_BY
            
            )
            
           VALUES (v_PROTO_IDSEQ
            ,'1'
            , v_CONTE_IDSEQ
            ,i.PREFERRED_NAME 
	        ,i.PREFERRED_DEFINITION 
            ,i.workflow
	        ,i.LONG_NAME
            ,NULL
	        ,i.PHASE
	        ,V_org_idseq
            ,i.PROTOCOL_ID
            ,v_protoid--TO_NUMBER(REGEXP_REPLACE(trim(i.PROTOCOL_ID),'[^0-9]+', ''))--TO_NUMBER(REGEXP_REPLACE(i.PROTOCOL_ID,'[^a-zA-Z'']',''))--remove alpha characters from string 
            ,SYSDATE
            ,'DWARZEL'
            
            );
            end if; 
        
         
 EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
         dbms_output.put_line('errmsg5 - '||errmsg);
                insert into MDSR_PROTOCOLS_ERR_LOG VALUES (i.PROTOCOL_ID,sysdate,errmsg, i.PREFERRED_name, i.LONG_NAME,i.PREFERRED_DEFINITION,   i.CONTEXT, i.WORKFLOW,i.origin ,i.TYPE,i.PHASE,i.LEAD_ORG); 
 commit;
 end;  

 end loop;
 commit;
 end;
/
EXEC SBREXT.UPLOAD_VALIDATE_PROTOCOL;
SPOOL OFF
