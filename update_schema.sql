-- Create the user
CREATE USER MAGIC identified BY "YOUR_PASSWORD"
DEFAULT tablespace APP_TABLESPACE --your tablespace name
temporary tablespace TEMP_TABLESPACE --your temporary tablespace name
profile DEFAULT;
-- Grant/Revoke role privileges
grant CONNECT TO MAGIC;
grant resource TO MAGIC;
grant dba TO MAGIC;
-- Grant/Revoke system privileges
grant CREATE session TO MAGIC;
grant unlimited tablespace TO MAGIC;
