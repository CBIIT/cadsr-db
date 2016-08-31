CREATE TABLE SBR.META_UPLOAD_ERROR_LOG
(
  ERROR_MSG             VARCHAR2(3000 BYTE),
  UPLOAD_DATE           DATE,
  PROCEDURE_NAME        VARCHAR2(40 BYTE),
  RECORD_ID             VARCHAR2(300 BYTE)
);


CREATE TABLE SBR.META_UPLOAD_CONTACT
(Public_ID   NUMBER,
VERSION               NUMBER(4,2) ,
RANK_ORDER     NUMBER(3)  ,
ORGANISATION    VARCHAR2(100 BYTE),
LNAME VARCHAR2(50 BYTE),
FNAME VARCHAR2(50 BYTE),
CROLE  VARCHAR2(50 BYTE),
CTL_NAME  VARCHAR2(50 BYTE),
CYBER_ADDRESS  VARCHAR2(255 BYTE), 
COMMENTS VARCHAR2(500 BYTE) );


CREATE OR REPLACE PROCEDURE SBR.META_UPLOAD_CONTACT_SP IS


---contacts do not exist
CURSOR C1 IS
select u.Public_ID,u.VERSION ,u.RANK_ORDER,
u.ORGANISATION,u.LNAME,u.FNAME, u.CTL_NAME ,u.CYBER_ADDRESS
from SBR.META_UPLOAD_CONTACT u
 left outer join  SBR.CONTACT_COMMS c
 on c.ctl_name=u.ctl_name
 and c.cyber_address=u.cyber_address 
 where  ccomm_IDSEQ is null;
 
 ---CDE do not exist 
CURSOR C2 IS
select u.Public_ID,u.VERSION,u.RANK_ORDER,
u.ORGANISATION,u.LNAME,u.FNAME, u.CTL_NAME ,u.CYBER_ADDRESS
from SBR.META_UPLOAD_CONTACT u
 left outer join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
 where  DE_IDSEQ is null;
 
 ---CDE have contacts
 CURSOR C3 IS
 select u.Public_ID,u.VERSION,u.RANK_ORDER,
u.ORGANISATION,u.LNAME,u.FNAME, u.CTL_NAME ,u.CYBER_ADDRESS
from SBR.META_UPLOAD_CONTACT u  
 inner join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
inner join SBREXT.CABIO31_AC_CONTACTS_VIEW  c
on DE_IDSEQ=AC_IDSEQ;

errmsg VARCHAR(110);
v_cnt NUMBER ;
v_check_en NUMBER;

BEGIN


---contacts do not exist
select count(*) into v_cnt from 
SBR.META_UPLOAD_CONTACT u
 left outer join  SBR.CONTACT_COMMS c
 on c.ctl_name=u.ctl_name
 and c.cyber_address=u.cyber_address 
 where  ccomm_IDSEQ is null;
 
 IF(v_cnt > 0) THEN
 FOR q_rec IN C1 LOOP
  BEGIN
   
   insert into SBR.META_UPLOAD_ERROR_LOG
   select
   'contacts do not exist',
   SYSDATE,
   'SBR.META_UPLOAD_CONTACT_SP',
   q_rec.ctl_name||','||q_rec.cyber_address||','||q_rec.ORGANISATION
   from 
SBR.META_UPLOAD_CONTACT u
 left outer join  SBR.CONTACT_COMMS c
 on c.ctl_name=u.ctl_name
 and c.cyber_address=u.cyber_address 
 where  ccomm_IDSEQ is null;
 
 UPDATE  SBR.META_UPLOAD_CONTACT set COMMENTS='ERROR'
 where Public_ID=q_rec.Public_ID 
and VERSION=q_rec.VERSION
 and ctl_name=q_rec.ctl_name 
 and cyber_address=q_rec.cyber_address;
 commit;
 EXCEPTION WHEN NO_DATA_FOUND THEN
  NULL;
 END;
 
/*
---CDE do not exist 
  select*from SBR.META_UPLOAD_CONTACT u  
 left outer join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
 where  DE_IDSEQ is null;
 
 ---CDE have contacts
 select*from SBR.META_UPLOAD_CONTACT u  
 inner join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
inner join SBREXT.CABIO31_AC_CONTACTS_VIEW  c
on DE_IDSEQ=AC_IDSEQ;*/

END LOOP;
END IF;

---CDE do not exist 
select count(*) into v_cnt from SBR.META_UPLOAD_CONTACT u  
 left outer join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
 where  DE_IDSEQ is null;
 
 IF(v_cnt > 0) THEN
 FOR rec IN C2 LOOP
  BEGIN
   
   insert into SBR.META_UPLOAD_ERROR_LOG
   select
   'CDE do not exist',
   SYSDATE,
   'SBR.META_UPLOAD_CONTACT_SP',
  rec.Public_ID||','||rec.VERSION
  from SBR.META_UPLOAD_CONTACT u  
 left outer join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
 where  DE_IDSEQ is null;
  
 
 UPDATE  SBR.META_UPLOAD_CONTACT set COMMENTS='ERROR'
 where Public_ID=rec.Public_ID 
and VERSION=rec.VERSION
 and ctl_name=rec.ctl_name 
 and cyber_address=rec.cyber_address;
 commit;
 EXCEPTION WHEN NO_DATA_FOUND THEN
  NULL;
 END;
 


END LOOP;
END IF;
/*

 ---CDE have contacts
 select*from SBR.META_UPLOAD_CONTACT u  
 inner join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
inner join SBREXT.CABIO31_AC_CONTACTS_VIEW  c
on DE_IDSEQ=AC_IDSEQ;*/
select count(*) into v_cnt from SBR.META_UPLOAD_CONTACT u  
 inner join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
inner join SBREXT.CABIO31_AC_CONTACTS_VIEW  c
on DE_IDSEQ=AC_IDSEQ;
 
 IF(v_cnt > 0) THEN
 FOR q_rec IN C3 LOOP
  BEGIN
   
   insert into SBR.META_UPLOAD_ERROR_LOG
   select
   'CDE have contacts',
   SYSDATE,
   'SBR.META_UPLOAD_CONTACT_SP',
   q_rec.ctl_name||','||q_rec.cyber_address||','||q_rec.ORGANISATION
   from SBR.META_UPLOAD_CONTACT u  
 inner join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
inner join SBREXT.CABIO31_AC_CONTACTS_VIEW  c
on DE_IDSEQ=AC_IDSEQ;


 UPDATE  SBR.META_UPLOAD_CONTACT set COMMENTS='ERROR'
 where Public_ID=q_rec.Public_ID and VERSION=q_rec.VERSION
 and ctl_name=q_rec.ctl_name and cyber_address=q_rec.cyber_address;
 commit;
 
 EXCEPTION WHEN NO_DATA_FOUND THEN
  NULL;
 END;
END LOOP;
END IF;


DECLARE

CURSOR C4 IS
select *
from SBR.META_UPLOAD_CONTACT   where COMMENTS is null;

 v_acc_idseq VARCHAR(50);
 v_DEC_IDSEQ VARCHAR(50);
 v_DE_IDSEQ VARCHAR(50);
 V_CONTE_IDSEQ VARCHAR(50);
 V_VD_IDSEQ VARCHAR(50);
 v_PER_ID VARCHAR(50);
 v_ORG_ID VARCHAR(50);
begin
select count(*) into v_cnt from SBR.META_UPLOAD_CONTACT u  
 where COMMENTS is null;
 
 IF(v_cnt > 0) THEN
 FOR q_rec IN C4 LOOP
  BEGIN
   
 select admincomponent_crud.cmr_guid into v_acc_idseq from dual; 
  
  
 select e.DE_IDSEQ,e.CONTE_IDSEQ,e.VD_IDSEQ,e.DEC_IDSEQ
 into V_DE_IDSEQ,V_CONTE_IDSEQ,V_VD_IDSEQ,V_DEC_IDSEQ
 from  SBR.DATA_ELEMENTS  e
 where cde_id=  q_rec.Public_ID
 and VERSION=q_rec.version;
 If q_rec.Lname is not null then
 select per_IDSEQ into V_PER_ID from SBR.CONTACT_COMMS c
 where  ctl_name=q_rec.ctl_name
 and cyber_address=q_rec.cyber_address ;
 V_ORG_ID:=null;
 else
 select ORG_IDSEQ into V_ORG_ID from SBR.CONTACT_COMMS c
 where  ctl_name=q_rec.ctl_name
 and cyber_address=q_rec.cyber_address ;
 V_PER_ID:=null;
 end if;
 
    INSERT INTO SBR.AC_CONTACTS (ACC_IDSEQ                   ,
    ORG_IDSEQ  ,
    PER_IDSEQ      ,
    AC_IDSEQ       ,
    RANK_ORDER     ,
    DATE_CREATED  ,
    CREATED_BY     ,  
    CONTACT_ROLE 
    )
    VALUES (v_acc_idseq    ,
    V_ORG_ID  ,
    V_PER_ID        ,
    V_DE_IDSEQ     ,
    q_rec.RANK_ORDER     ,
    SYSDATE  ,
    'DWARZEL'     ,  
    q_rec.CROLE );

 
 EXCEPTION WHEN OTHERS THEN
  errmsg := substr(SQLERRM,1,100);
  insert into SBR.META_UPLOAD_ERROR_LOG
   select
   'CDE have contacts',
   SYSDATE,
   'SBR.META_UPLOAD_CONTACT_SP',
   q_rec.Public_ID||','||q_rec.VERSION||','||q_rec.ctl_name||','||q_rec.cyber_address||','||q_rec.ORGANISATION||','||errmsg
   from SBR.META_UPLOAD_CONTACT ; 
   commit; 
 
 END;
END LOOP;
END IF;
END; 

END;
/
exec SBR.META_UPLOAD_CONTACT_SP;