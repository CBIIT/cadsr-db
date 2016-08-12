select PV_IDSEQ ,VALUE,SHORT_MEANING,MEANING_DESCRIPTION ,date_modified from SBR.PERMISSIBLE_VALUES;

select PV_IDSEQ ,VALUE,SHORT_MEANING,MEANING_DESCRIPTION ,date_modified
from SBR.PERMISSIBLE_VALUES 
where INSTR(short_meaning,'&'||'gt;')>0 or
INSTR(short_meaning,'&'||'lt;')>0 or
INSTR(short_meaning,'&'||'amp;')>0 or
INSTR(short_meaning,'&'||'#35;')>0 or
INSTR(short_meaning,'&'||'#36;')>0 or
INSTR(short_meaning,'&'||'#37;')>0 or
INSTR(short_meaning,'&'||'#40;')>0 or
INSTR(short_meaning,'&'||'#41;')>0 or
INSTR(short_meaning,'&'||'#42;')>0 or
INSTR(short_meaning,'&'||'#43;')>0 or
INSTR(short_meaning,'&'||'#44;')>0 or
INSTR(short_meaning,'&'||'#45;')>0 or
INSTR(short_meaning,'&'||'#46;')>0 or
INSTR(short_meaning,'&'||'#47;')>0 or
INSTR(short_meaning,'&'||'#61;')>0 or
INSTR(short_meaning,'&'||'#63;')>0 or
INSTR(short_meaning,'&'||'#91;')>0 or
INSTR(short_meaning,'&'||'#92;')>0 or
INSTR(short_meaning,'&'||'#93;')>0 or
INSTR(short_meaning,'&'||'#94;')>0 or
INSTR(short_meaning,'&'||'#123;')>0 or
INSTR(short_meaning,'&'||'#125;')>0 or
INSTR(short_meaning,'&'||'#126;')>0 ;


create table SBR.CT_FIX_PERMISSIBLE_VALUES
(
  PV_IDSEQ             CHAR(36 BYTE)            NOT NULL,
  VALUE                VARCHAR2(255 BYTE)       NOT NULL,
  SHORT_MEANING        VARCHAR2(255 BYTE)       NOT NULL,
  MEANING_DESCRIPTION  VARCHAR2(2000 BYTE),
  DATE_MODIFIED        DATE,
  MODIFIED_BY          VARCHAR2(30 BYTE),
  VM_IDSEQ             CHAR(36 BYTE)            NOT NULL
);