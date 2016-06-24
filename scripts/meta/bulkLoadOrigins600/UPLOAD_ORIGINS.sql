

Alter table SBREXT. SOURCES_EXT modify (SRC_NAME varchaR2(500))
/

   
    CREATE TABLE "SBREXT"."ORIGIN_TEMP" 
   (	"SRC_NAME" VARCHAR2(1000), 
	"DESCRIPTION" VARCHAR2(3000) )
/
   
   CREATE TABLE "SBREXT"."ORIGIN_TEMP_ERROR_LOG" 
   (	"SRC_NAME" VARCHAR2(1000), 
	"DESCRIPTION" VARCHAR2(3000), 
	"INSERT_DATE" DATE, 
	"ERROR_TEXT" VARCHAR2(2000) )
/



CREATE OR REPLACE PROCEDURE SBREXT.UPLOAD_VALIDATE_ORIGINS AS 

cursor c_load is 
 select SRC_NAME, DESCRIPTION  from
 (select count(*) cnt,trim(SRC_NAME)SRC_NAME, trim(DESCRIPTION) DESCRIPTION from SBREXT."ORIGIN_TEMP"
 where SRC_NAME is not null
   group BY SRC_NAME, DESCRIPTION
   ORDER BY SRC_NAME, DESCRIPTION);
   
errmsg VARCHAR2(2000):='';
 
v_name  VARCHAR2(500) ;
v_desc  VARCHAR2(2000) ;
v_cnt number;
BEGIN

for i in c_load loop

begin     

errmsg:='';     
SELECT count(*) into v_cnt
            FROM SOURCES_EXT
            WHERE   trim(SRC_NAME) = trim(i.SRC_NAME);
            
            IF v_cnt > 0 THEN
            errmsg :='Exsisting ORIGIN';
            end if;
            IF length(trim(i.SRC_NAME))>500 then
            IF length(trim(errmsg))>1 then 
            errmsg :=errmsg||';Origin Name is '||length(trim(i.SRC_NAME))||' Characters. It must not xceed 500';
            ELSE
            errmsg :=errmsg||'Origin Name is '||length(trim(i.SRC_NAME))||' Characters. It must not xceed 500';
            END IF;
            END IF;
            
             IF length(trim(i.DESCRIPTION))>2000 then
            IF length(trim(errmsg))>1 then 
            errmsg :=errmsg||';DESCRIPTION is '||length(trim(i.SRC_NAME))||' Characters. It must not xceed 2000';
            ELSE
            errmsg :=errmsg||'DESCRIPTION is '||length(trim(i.SRC_NAME))||' Characters. It must not xceed 2000';
            END IF;
            END IF;
            IF length(trim(errmsg))>1 then
             dbms_output.put_line('errmsg2 - '||errmsg);
            insert into ORIGIN_TEMP_ERROR_LOG VALUES (i.SRC_NAME,i.DESCRIPTION,sysdate,errmsg);
              
           ELSE
              insert into SOURCES_EXT 
              (	"SRC_NAME" , 	"DESCRIPTION" , 	"DATE_CREATED" , 	"CREATED_BY")
              VALUES ( i.SRC_NAME,i.DESCRIPTION,sysdate,'SBREXT' );
            END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
        dbms_output.put_line('errmsg2 - '||errmsg);
               insert into ORIGIN_TEMP_ERROR_LOG VALUES ( i.SRC_NAME,i.DESCRIPTION,sysdate,errmsg );
 end;   
  end loop;

commit;

END UPLOAD_VALIDATE_ORIGINS;
/