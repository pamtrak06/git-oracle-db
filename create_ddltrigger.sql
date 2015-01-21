CREATE OR REPLACE TYPE magic.after_ddl_queue_type AS object
    (
     ddl_timestamp DATE,
     sysevent VARCHAR2(100),
     ora_login_user VARCHAR2(50),
     ora_instance_num NUMBER,
     ora_database_name VARCHAR2(50),
     ora_dict_obj_name VARCHAR2(100),
     ora_dict_obj_type VARCHAR2(100),
     ora_dict_obj_owner VARCHAR2(50),
     host VARCHAR2(100),
     ip VARCHAR2(15),
     os_user VARCHAR2(50),
     ddl_text clob
    );
 
CREATE OR REPLACE TRIGGER magic.after_ddl after ddl ON database
DECLARE
 ddl_text_var dbms_standard.ora_name_list_t;       --This is the type ora_name_list_t, is table of varchar2(64)
 full_ddl_text clob;                               --There will be stored the full DDL text
 message after_ddl_queue_type;
BEGIN
  IF(ora_sysevent IN ('TRUNCATE','ANALYZE'))
  THEN
    NULL;--smth may be here in future
  ELSE
 FOR i IN 1..ora_sql_txt(ddl_text_var) LOOP        --This portion of code calculates the full DDL text, because ddl_text_var
   full_ddl_text:=full_ddl_text||ddl_text_var(i);  --is just a table of 64 byte pieces of DDL, we need to subtract them
 END LOOP;                                 --to get full DDL.
 message:=after_ddl_queue_type(SYSDATE,
                               ora_sysevent,
                               ora_login_user,
                               ora_instance_num,
                               ora_database_name,
                               ora_dict_obj_name,
                               ora_dict_obj_type,
                               ora_dict_obj_owner,
                               SYS_CONTEXT('userenv','HOST'),
                               SYS_CONTEXT('userenv','IP_ADDRESS'),
                               SYS_CONTEXT('userenv','OS_USER'),
                               full_ddl_text);
 INSERT INTO magic.ddllog VALUES(message.ddl_timestamp,message.sysevent,message.ora_login_user,message.ora_instance_num
 ,message.ora_database_name,message.ora_dict_obj_name,message.ora_dict_obj_type,message.ora_dict_obj_owner,message.host,
 message.ip,message.os_user,message.ddl_text,NULL);
                 END IF;
END;
