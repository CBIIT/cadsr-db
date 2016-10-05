set serveroutput on size 1000000
SPOOL cadsrmeta-618p.log

CREATE OR REPLACE PROCEDURE SBR.META_UPLOAD_CONTACT_SP IS

---contacts do not exist
CURSOR C1 IS
select distinct u.Public_ID,u.VERSION ,u.RANK_ORDER,
u.ORGANISATION,u.LNAME,u.FNAME, u.CTL_NAME ,u.CYBER_ADDRESS
from SBR.META_UPLOAD_CONTACT u
 left outer join  SBR.CONTACT_COMMS c
 on c.ctl_name=u.ctl_name
 and c.cyber_address=u.cyber_address 
 where  ccomm_IDSEQ is null;
 
 ---CDE do not exist 
CURSOR C2 IS
select distinct u.Public_ID,u.VERSION,u.RANK_ORDER,
u.ORGANISATION,u.LNAME,u.FNAME, u.CTL_NAME ,u.CYBER_ADDRESS
from SBR.META_UPLOAD_CONTACT u
 left outer join  SBR.DATA_ELEMENTS  e
 on cde_id=  Public_ID
 and u.version=e.version
 where  DE_IDSEQ is null;
 
---CDE have contacts
CURSOR C3 IS
select distinct u.Public_ID,u.VERSION,u.RANK_ORDER,
u.ORGANISATION,u.LNAME,u.FNAME, u.CTL_NAME ,u.CYBER_ADDRESS,C.ORG_IDSEQ,C.PER_IDSEQ
from SBR.META_UPLOAD_CONTACT u  
inner join  SBR.DATA_ELEMENTS  e
on cde_id=  Public_ID
and u.version=e.version
inner join SBREXT.CABIO31_AC_CONTACTS_VIEW  c
on DE_IDSEQ=AC_IDSEQ;

errmsg VARCHAR(110);
v_cnt NUMBER ;
v_check NUMBER;


 v_PERID VARCHAR(50);
 v_ORGID VARCHAR(50);

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
   from SBR.META_UPLOAD_CONTACT u
 where ctl_name=q_rec.ctl_name
 and cyber_address=q_rec.cyber_address ;
 
 UPDATE  SBR.META_UPLOAD_CONTACT set COMMENTS='ERROR'
 where Public_ID=q_rec.Public_ID 
and VERSION=q_rec.VERSION
 and ctl_name=q_rec.ctl_name 
 and cyber_address=q_rec.cyber_address;

 EXCEPTION WHEN OTHERS THEN
  errmsg := substr(SQLERRM,1,100);
   insert into SBR.META_UPLOAD_ERROR_LOG VALUES( errmsg, SYSDATE,   'SBR.META_UPLOAD_CONTACT_SP',  q_rec.Public_ID||','||q_rec.VERSION||','||q_rec.ctl_name||','||q_rec.cyber_address||','||q_rec.ORGANISATION||','||errmsg
   ) ; 
   commit;
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
 where  Public_ID=  rec.Public_ID
 and u.version=rec.version;
  
 
 UPDATE  SBR.META_UPLOAD_CONTACT set COMMENTS='ERROR'
 where Public_ID=rec.Public_ID 
and VERSION=rec.VERSION
 and ctl_name=rec.ctl_name 
 and cyber_address=rec.cyber_address;
 commit;
  EXCEPTION WHEN OTHERS THEN
  errmsg := substr(SQLERRM,1,100);
  
   insert into SBR.META_UPLOAD_ERROR_LOG VALUES( errmsg, SYSDATE,   'SBR.META_UPLOAD_CONTACT_SP',   rec.Public_ID||','||rec.VERSION||','||rec.ctl_name||','||rec.cyber_address||','||errmsg);
   commit; 
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
  
  
  select PER_IDSEQ, ORG_IDSEQ into  v_PERID, v_ORGID
  from SBR.CONTACT_COMMS c
  where  c.ctl_name=q_rec.ctl_name
  and c.cyber_address=q_rec.cyber_address ;
  
  dbms_output.put_line('this is PER_IDSEQ, ORG_IDSEQ:'||v_PERID||','||v_PERID);
  IF NVL(v_PERID,'NF') <> q_rec.PER_IDSEQ and NVL(v_ORGID,'NF') <> q_rec.ORG_IDSEQ
  THEN
  
   insert into SBR.META_UPLOAD_ERROR_LOG
   select
   'CDE has contacts',
   SYSDATE,
   'SBR.META_UPLOAD_CONTACT_SP',
   q_rec.ctl_name||','||q_rec.cyber_address||','||q_rec.ORGANISATION
   from SBR.META_UPLOAD_CONTACT u  
 where  Public_ID=  q_rec.Public_ID
 and q_rec.version=version;


 UPDATE  SBR.META_UPLOAD_CONTACT set COMMENTS='ERROR'
 where Public_ID=q_rec.Public_ID and VERSION=q_rec.VERSION
 and ctl_name=q_rec.ctl_name and cyber_address=q_rec.cyber_address;
 commit;
 ELSE
  UPDATE  SBR.META_UPLOAD_CONTACT set COMMENTS='CDE has same contacts'
 where Public_ID=q_rec.Public_ID and VERSION=q_rec.VERSION
 and ctl_name=q_rec.ctl_name and cyber_address=q_rec.cyber_address;
 END IF;
 
 EXCEPTION WHEN OTHERS THEN
  errmsg := substr(SQLERRM,1,100);
  insert into SBR.META_UPLOAD_ERROR_LOG VALUES(   errmsg,
   SYSDATE,
   'SBR.META_UPLOAD_CONTACT_SP',
   q_rec.Public_ID||','||q_rec.VERSION||','||q_rec.ctl_name||','||q_rec.cyber_address||','||q_rec.ORGANISATION||','||errmsg) ; 
   commit; 
 END;
END LOOP;
END IF;





DECLARE

CURSOR C5 IS
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
 FOR q_rec IN C5 LOOP
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
 and cyber_address=q_rec.cyber_address and per_IDSEQ is not null;
 V_ORG_ID:=null;
 else
 select ORG_IDSEQ into V_ORG_ID from SBR.CONTACT_COMMS c
 where  ctl_name=q_rec.ctl_name
 and cyber_address=q_rec.cyber_address and ORG_IDSEQ is not null;
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
  insert into SBR.META_UPLOAD_ERROR_LOG VALUES(   errmsg,   SYSDATE,   'SBR.META_UPLOAD_CONTACT_SP',   q_rec.Public_ID||','||q_rec.VERSION||','||q_rec.ctl_name||','||q_rec.cyber_address||','||q_rec.ORGANISATION||','||errmsg
   ); 
   commit; 
 
 END;
END LOOP;
END IF;
END; 

END;
/
 exec SBR.META_UPLOAD_CONTACT_SP;
SPOOL OFF