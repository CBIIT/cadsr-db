set serveroutput on size 1000000
SPOOL cadsrmeta-708.log
ALTER TABLE SBREXT.MDSR_CONCEPTS_EXT_ERROR_LOG
ADD (CHANGE_NOTE varchar2(4000),
       DB_PROC varchar2(100))
 / 
 ALTER TABLE MDSR_CONCEPTS_EXT_ERROR_LOG
 MODIFY (ERROR_MSG varchar2(4000) ,
          PREFERRED_DEFINITION varchar2(4000),
          SOURCE_DEFINITION varchar2(1000))
 /
 ALTER TABLE SBREXT.MDSR_CONCEPTS_EXT_ERROR_LOG
ADD (CHANGE_NOTE varchar2(4000),
       DB_PROC varchar2(100))     
/       
ALTER TABLE SBREXT.MDSR_CONCEPTS_EXT_TEMP
MODIFY (  PREFERRED_DEFINITION varchar2(4000),
SOURCE_DEFINITION varchar2(1000))
/
 ALTER TABLE SBREXT.MDSR_CONCEPTS_EXT_TEMP
  ADD (CHANGE_NOTE varchar2(4000),
  UPLOAD_DATE DATE default SYSDATE);
 /
  CREATE TABLE SBREXT.MDSR_CONCEPTS_EXT_HIST_LOG
(
  PREFERRED_NAME        VARCHAR2(300 BYTE),
  LONG_NAME             VARCHAR2(500 BYTE),
  PREFERRED_DEFINITION  VARCHAR2(4000 BYTE),
  EVS_SOURCE            VARCHAR2(300 BYTE),
  ORIGIN                VARCHAR2(300 BYTE),
  SOURCE_DEFINITION     VARCHAR2(1000 BYTE),
  CHANGE_NOTE           VARCHAR2(4000 BYTE),
  UPLOAD_DATE           DATE    DEFAULT SYSDATE
)
/
CREATE OR REPLACE PUBLIC SYNONYM MDSR_CONCEPTS_EXT_HIST_LOG FOR SBREXT.MDSR_CONCEPTS_EXT_HIST_LOG
/
GRANT SELECT ON MDSR_CONCEPTS_EXT_HIST_LOG TO PUBLIC
/
INSERT INTO  SBREXT.MDSR_CONCEPTS_EXT_HIST_LOG;
commit;
delete from SBREXT.MDSR_CONCEPTS_EXT_TEMP;
commit;
CREATE OR REPLACE PROCEDURE SBREXT.UPLOAD_VALIDATE_CONCEPTS AS

cursor c_load is
    select PREFERRED_NAME ,  LONG_NAME ,  PREFERRED_DEFINITION,EVS_SOURCE, ORIGIN, SOURCE_DEFINITION,CHANGE_NOTE
    from
    (select count(*) cnt,trim(PREFERRED_NAME) PREFERRED_NAME,  trim(LONG_NAME) LONG_NAME,
    trim(PREFERRED_DEFINITION)PREFERRED_DEFINITION,trim(EVS_SOURCE) EVS_SOURCE,
    trim(ORIGIN) ORIGIN, trim(SOURCE_DEFINITION) SOURCE_DEFINITION ,CHANGE_NOTE from SBREXT."MDSR_CONCEPTS_EXT_TEMP"   
    group BY PREFERRED_NAME ,  LONG_NAME ,  PREFERRED_DEFINITION,EVS_SOURCE, ORIGIN, SOURCE_DEFINITION,CHANGE_NOTE)
    ORDER BY LONG_NAME;

errmsg VARCHAR2(4000):='';
v_cnt number;
v_source number;
v_conte_idseq  VARCHAR2(50) ;
v_con_idseq  VARCHAR2(50) ;
v_con_id number;
BEGIN

for i in c_load loop

begin

errmsg :='';

         IF i.PREFERRED_NAME is null or i.LONG_NAME is null  or i.PREFERRED_DEFINITION is null
            THEN
             errmsg :=' The columns: , LONG_NAME and PREFERRED_DEFINITION must hold values; ';

            end if;

             dbms_output.put_line(i.LONG_NAME||'i.LONG_NAME');

        
         IF  i.EVS_SOURCE is null or i.ORIGIN is null or i.SOURCE_DEFINITION is null
            THEN
            i.EVS_SOURCE :=NVL(i.EVS_SOURCE,'NCI_CONCEPT_CODE');
            i.ORIGIN :=NVL(i.ORIGIN,'NCI Thesuarus');
            i.SOURCE_DEFINITION := NVL(i.SOURCE_DEFINITION,'NCI');
            end if;
            


            SELECT count(*) into v_source
            FROM SBREXT.CONCEPT_SOURCES_LOV_EXT
            WHERE   trim(CONCEPT_SOURCE) = trim(i.EVS_SOURCE)
            and i.EVS_SOURCE is not null;

             IF v_source < 1 and i.EVS_SOURCE is not null THEN
            errmsg :=errmsg||'Invalid SOURCE '||i.EVS_SOURCE||'; ';
            end if;
            IF length(trim(i.PREFERRED_NAME))>30 then
                errmsg :=errmsg||'PREFERRED_NAME is '||length(trim(i.PREFERRED_NAME))||' Characters. It must not exceed 30; ';
            END IF;
            
            IF length(trim(i.LONG_NAME))>255 then                
                errmsg :=errmsg||'LONG_NAME is '||length(trim(i.LONG_NAME))||' Characters. It must not exceed 255; ';             
            END IF;


            IF length(trim(i.PREFERRED_DEFINITION))>2000 then
                  errmsg :=errmsg||'PREFERRED_DEFINITION is '||length(trim(i.PREFERRED_DEFINITION))||' Characters. It must not exceed 2000; ';            
            END IF;
           --dbms_output.put_line(i.EVS_SOURCE||'');

            select CONTE_IDSEQ into v_CONTE_IDSEQ from contexts
            where trim(name)='NCIP' and version=1;
            SELECT count(*) into v_cnt
            FROM CONCEPTS_EXT
            WHERE   trim(PREFERRED_NAME) = trim(i.PREFERRED_NAME);

            IF v_cnt > 0 THEN
            errmsg :=errmsg||'Existing PREFERRED_NAME; ';
            end if;
         

            IF length(trim(errmsg))>1 then
              dbms_output.put_line('errmsg2 - ');
            insert into MDSR_CONCEPTS_EXT_ERROR_LOG VALUES (errmsg,sysdate,i.PREFERRED_NAME,i.LONG_NAME ,i.PREFERRED_DEFINITION,i.EVS_SOURCE,i.ORIGIN,i.SOURCE_DEFINITION,i.CHANGE_NOTE,'UPLOAD_VALIDATE_CONCEPTS');
            commit;
            ELSE
               dbms_output.put_line('errmsg2 - ');
              select cde_id_seq.nextval into v_con_id      from dual;

              select admincomponent_crud.cmr_guid into v_con_idseq from dual;

              select CONTE_IDSEQ into v_CONTE_IDSEQ from contexts
              where trim(name)='NCIP' and version=1;
             -- dbms_output.put_line('v_con_id - '||v_con_id||',v_con_idseq-'||v_con_idseq||',v_CONTE_IDSEQ-'||v_CONTE_IDSEQ);
              insert into SBREXT.CONCEPTS_EXT
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
                  EVS_SOURCE ,
                  CHANGE_NOTE)
              VALUES

                  (v_CON_IDSEQ,                    --CON_IDSEQ            NOT NULL,
                   i.PREFERRED_NAME,              --PREFERRED_NAME        NOT NULL,
                   i.LONG_NAME,                   --LONG_NAME
                   i.PREFERRED_DEFINITION,        --PREFERRED_DEFINITION  NOT NULL,
                   v_CONTE_IDSEQ,                 --CONTE_IDSEQ           NOT NULL,
                   1,                             --  VERSION             NOT NULL,
                   'RELEASED',                    -- ASL_NAME             NOT NULL,
                   'Yes',                         --LATEST_VERSION_IND
                    i.SOURCE_DEFINITION  ,  --DEFINITION_SOURCE
                   sysdate,                       --DATE_CREATED
                    i.ORIGIN ,         --ORIGIN
                   'SBREXT',                      -- CREATED_BY
                   v_CON_ID,                      --CON_ID NOT NULL,
                   i.EVS_SOURCE,
                   i.CHANGE_NOTE );                --EVS_SOURCE
    commit;
            END IF;

  EXCEPTION
    WHEN OTHERS THEN
       errmsg := substr(SQLERRM,1,2000);
        dbms_output.put_line('errmsg3 - '||errmsg);
                  insert into MDSR_CONCEPTS_EXT_ERROR_LOG VALUES (errmsg,sysdate,i.PREFERRED_NAME,i.LONG_NAME ,i.PREFERRED_DEFINITION,
				  i.EVS_SOURCE, i.ORIGIN, i.SOURCE_DEFINITION,i.CHANGE_NOTE,'UPLOAD_VALIDATE_CONCEPTS');
 end;
  end loop;

commit;

END ;
/
CREATE OR REPLACE PROCEDURE SBREXT.MDSR_UPLOAD_UPDATE_CONCEPTS AS

cursor c_load is
    select PREFERRED_NAME ,  LONG_NAME ,  PREFERRED_DEFINITION,EVS_SOURCE, ORIGIN, SOURCE_DEFINITION, CHANGE_NOTE
    from
    (select count(*) cnt,trim(PREFERRED_NAME) PREFERRED_NAME,  trim(LONG_NAME) LONG_NAME,
    trim(PREFERRED_DEFINITION)PREFERRED_DEFINITION,trim(EVS_SOURCE) EVS_SOURCE,
    trim(ORIGIN) ORIGIN, trim(SOURCE_DEFINITION) SOURCE_DEFINITION, CHANGE_NOTE from SBREXT."MDSR_CONCEPTS_EXT_TEMP"
    where PREFERRED_NAME is not null
    --where PREFERRED_NAME='C131048'
    group BY PREFERRED_NAME ,  LONG_NAME ,  PREFERRED_DEFINITION,EVS_SOURCE, ORIGIN, SOURCE_DEFINITION, CHANGE_NOTE)
    ORDER BY LONG_NAME;

errmsg VARCHAR2(2000):='';
v_pname  VARCHAR2(100) ;
v_lname  VARCHAR2(500) ;
v_desc  VARCHAR2(3000) ;
v_cnt number;
v_source number;
v_conte_idseq  VARCHAR2(50) ;
v_con_idseq  VARCHAR2(50) ;
v_con_id number;
BEGIN

for i in c_load loop

begin

errmsg :='';
----
         IF i.LONG_NAME is null  or i.PREFERRED_DEFINITION is null or i.PREFERRED_NAME is null
            THEN
             errmsg :=' The columns:PREFERRED_NAME,LONG_NAME, PREFERRED_DEFINITION must hold values; ';

            end if;

             dbms_output.put_line(i.LONG_NAME||'i.LONG_NAME');

         IF  i.EVS_SOURCE is null or i.ORIGIN is null or i.SOURCE_DEFINITION is null
            THEN
            i.EVS_SOURCE :=NVL(i.EVS_SOURCE,'NCI_CONCEPT_CODE');
            i.ORIGIN :=NVL(i.ORIGIN,'NCI Thesuarus');
            i.SOURCE_DEFINITION := NVL(i.SOURCE_DEFINITION,'NCI');
            end if;


            SELECT count(*) into v_source
            FROM SBREXT.CONCEPT_SOURCES_LOV_EXT
            WHERE   trim(CONCEPT_SOURCE) = trim(i.EVS_SOURCE)
            and i.EVS_SOURCE is not null;

             IF v_source < 1 and i.EVS_SOURCE is not null THEN
            errmsg :=errmsg||'Invalid SOURCE '||i.EVS_SOURCE||'; ';
            end if;

           --dbms_output.put_line(i.EVS_SOURCE||'');

           

            IF length(trim(errmsg))>1 then
            -- dbms_output.put_line('errmsg2 - '||errmsg);
            insert into MDSR_CONCEPTS_EXT_ERROR_LOG VALUES (errmsg,sysdate,i.PREFERRED_NAME,i.LONG_NAME ,i.PREFERRED_DEFINITION,
                  i.EVS_SOURCE, i.ORIGIN, i.SOURCE_DEFINITION,i.CHANGE_NOTE,'UPLOAD_VALIDATE_CONCEPTS');
           ELSE
           
                       SELECT count(*) into v_cnt
            FROM CONCEPTS_EXT
            WHERE   trim(PREFERRED_NAME) = trim(i.PREFERRED_NAME)       ;

           
            IF v_cnt > 0 THEN
            UPDATE SBREXT.CONCEPTS_EXT set LONG_NAME=i.LONG_NAME ,
            PREFERRED_DEFINITION=i.PREFERRED_DEFINITION,
            EVS_SOURCE=i.EVS_SOURCE,ORIGIN=i.ORIGIN,
            DEFINITION_SOURCE=i.SOURCE_DEFINITION,
            CHANGE_NOTE=i.CHANGE_NOTE,
            MODIFIED_BY='SBREXT',
            DATE_MODIFIED=SYSDATE
            WHERE   trim(PREFERRED_NAME) = trim(i.PREFERRED_NAME)
            and version=1 and CONTE_IDSEQ=v_CONTE_IDSEQ;
            commit;
       
            END IF;
      end if;
  EXCEPTION
    WHEN OTHERS THEN
        errmsg := substr(SQLERRM,1500);
        dbms_output.put_line('errmsg3 - '||errmsg);
                  insert into MDSR_CONCEPTS_EXT_ERROR_LOG VALUES (errmsg,sysdate,i.PREFERRED_NAME,i.LONG_NAME ,i.PREFERRED_DEFINITION,
                  i.EVS_SOURCE, i.ORIGIN, i.SOURCE_DEFINITION,i.CHANGE_NOTE,'MDSR_UPLOAD_UPDATE_CONCEPTS');
 end;
  end loop;

commit;

END ;
/
SPOOL OFF