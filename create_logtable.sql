-- Create table
CREATE TABLE MAGIC.DDLLOG
(
ddl_timestamp   DATE,
sysevent        VARCHAR2(100),
login_user      VARCHAR2(50),
instance_num    NUMBER,
database_name   VARCHAR2(50),
dict_obj_name   VARCHAR2(100),
dict_obj_type   VARCHAR2(100),
dict_obj_owner  VARCHAR2(50),
host            VARCHAR2(100),
ip              VARCHAR2(15),
os_user         VARCHAR2(50),
obj_current_ddl CLOB,
event_id        NUMBER
)
--tablespace APP_TABLESPACE
PCTFREE 10
initrans 1
maxtrans 255
storage
(
initial 64K
next 1M
minextents 1
maxextents unlimited
);
-- Create/Recreate indexes
CREATE INDEX MAGIC.DDLLOG_ID ON MAGIC.DDLLOG (EVENT_ID)
--tablespace APP_TABLESPACE
PCTFREE 10
initrans 2
maxtrans 255
storage
(
initial 64K
next 1M
minextents 1
maxextents unlimited
);
 
 
-- Create sequence
CREATE sequence MAGIC.EVENT_IDS
minvalue 1
maxvalue 1000000000000
START WITH 1
increment BY 1
cache 20;
 
 
CREATE OR REPLACE TRIGGER magic.tgr_id
before INSERT OR UPDATE ON magic.ddllog
FOR each ROW
DECLARE
BEGIN
IF (inserting AND :NEW.event_id IS NULL OR :NEW.event_id <= 0) THEN
SELECT magic.event_IDS.NEXTVAL INTO :NEW.event_id FROM dual ;
END IF ;
END ;
