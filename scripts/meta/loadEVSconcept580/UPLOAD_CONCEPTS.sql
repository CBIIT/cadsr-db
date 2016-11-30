set serveroutput on size 1000000
SPOOL cadsrmeta-580b.log

CREATE OR REPLACE PROCEDURE SBREXT.UPLOAD_VALIDATE_CONCEPTS AS 

cursor c_load is 
 select PREFERRED_NAME ,  LONG_NAME ,  PREFERRED_DEFINITION   
 from
 (select count(*) cnt,trim(PREFERRED_NAME) PREFERRED_NAME,  trim(LONG_NAME) LONG_NAME,
  trim(PREFERRED_DEFINITION)PREFERRED_DEFINITION from SBREXT."MDSR_CONCEPTS_EXT_TEMP"
  where PREFERRED_NAME is not null
   group BY PREFERRED_NAME ,  LONG_NAME ,  PREFERRED_DEFINITION)
--   where PREFERRED_NAME='C126939'
   ORDER BY LONG_NAME;
   
errmsg VARCHAR2(2000):='';
v_pname  VARCHAR2(100) ;
v_lname  VARCHAR2(500) ;
v_desc  VARCHAR2(3000) ;
v_cnt number;
v_conte_idseq  VARCHAR2(50) ;
v_con_idseq  VARCHAR2(50) ;
v_con_id number;
BEGIN

for i in c_load loop

begin     

   
select CONTE_IDSEQ into v_CONTE_IDSEQ from contexts
              where trim(name)='NCIP' and version=1; 
SELECT count(*) into v_cnt
            FROM CONCEPTS_EXT
            WHERE   trim(PREFERRED_NAME) = trim(i.PREFERRED_NAME)
            and version=1 and CONTE_IDSEQ=v_CONTE_IDSEQ;
            
            IF v_cnt > 0 THEN
            errmsg :='Existing PREFERRED_NAME ';
            end if;
            
            IF length(trim(i.PREFERRED_NAME))>30 then
                IF length(trim(errmsg))>1 then 
                errmsg :=errmsg||';PREFERRED_NAME is '||length(trim(i.PREFERRED_NAME))||' Characters. It must not xceed 30';
                ELSE
                errmsg :=errmsg||'PREFERRED_NAME is '||length(trim(i.PREFERRED_NAME))||' Characters. It must not xceed 30';
                END IF;
            END IF;
               IF length(trim(i.LONG_NAME))>255 then
                IF length(trim(errmsg))>1 then 
                errmsg :=errmsg||';LONG_NAME is '||length(trim(i.LONG_NAME))||' Characters. It must not xceed 255';
                ELSE
                errmsg :=errmsg||'LONG_NAME is '||length(trim(i.LONG_NAME))||' Characters. It must not xceed 255';
                END IF;
            END IF;
            
            
            IF length(trim(i.PREFERRED_DEFINITION))>2000 then
                IF length(trim(errmsg))>1 then 
                errmsg :=errmsg||';PREFERRED_DEFINITION is '||length(trim(i.PREFERRED_DEFINITION))||' Characters. It must not xceed 2000';
                ELSE
                errmsg :=errmsg||'PREFERRED_DEFINITION is '||length(trim(i.PREFERRED_DEFINITION))||' Characters. It must not xceed 2000';
                END IF;
            END IF;
            IF length(trim(errmsg))>1 then
             dbms_output.put_line('errmsg2 - '||errmsg);
            insert into MDSR_CONCEPTS_EXT_ERROR_LOG VALUES (errmsg,sysdate,i.PREFERRED_NAME,i.LONG_NAME ,i.PREFERRED_DEFINITION);
              
           ELSE
           
              select cde_id_seq.nextval into v_con_id      from dual;           
           
              select admincomponent_crud.cmr_guid into v_con_idseq from dual;
              
              select CONTE_IDSEQ into v_CONTE_IDSEQ from contexts
              where trim(name)='NCIP' and version=1;
              dbms_output.put_line('v_con_id - '||v_con_id||',v_con_idseq-'||v_con_idseq||',v_CONTE_IDSEQ-'||v_CONTE_IDSEQ);
             insert into CONCEPTS_EXT
              (   CON_IDSEQ              ,
                  PREFERRED_NAME         ,
                  LONG_NAME              ,
                  PREFERRED_DEFINITION   ,
                  CONTE_IDSEQ           ,
                  VERSION               ,
                  ASL_NAME              ,
                  LATEST_VERSION_IND    ,
                  DEFINITION_SOURCE     ,
                  DATE_CREATED         ,
                  ORIGIN                ,
                  CREATED_BY          ,
                  CON_ID                ,
                  EVS_SOURCE )
              VALUES 
              
                  (v_CON_IDSEQ,                    --CON_IDSEQ            NOT NULL,
                   i.PREFERRED_NAME,              --PREFERRED_NAME        NOT NULL,
                   i.LONG_NAME,                   --LONG_NAME
                   i.PREFERRED_DEFINITION,         --PREFERRED_DEFINITION  NOT NULL,
                   v_CONTE_IDSEQ,                  --CONTE_IDSEQ           NOT NULL,
                   1,                              --  VERSION             NOT NULL,
                   'RELEASED',                     -- ASL_NAME             NOT NULL,
                   'Yes',                          --LATEST_VERSION_IND 
                   'NCI',                          ---DEFINITION_SOURCE
                    sysdate,                      --DATE_CREATED
                   'NCI Thesaurus',               --ORIGIN   
                   'SBREXT',                      -- CREATED_BY
                    v_CON_ID,                     --CON_ID NOT NULL,
                   'EVS_CONCEPT_CODE' );          --EVS_SOURCE
    commit;                
            END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
        errmsg := SQLERRM;
        dbms_output.put_line('errmsg3 - '||errmsg);
                  insert into MDSR_CONCEPTS_EXT_ERROR_LOG VALUES (errmsg,sysdate,i.PREFERRED_NAME,i.LONG_NAME ,i.PREFERRED_DEFINITION);
 end;   
  end loop;

commit;

END ;
/
exec SBREXT.UPLOAD_VALIDATE_CONCEPTS;
SPOOL OFF