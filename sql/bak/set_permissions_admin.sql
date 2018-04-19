-- 
-- Assign admin level access to all tables in schema in db
-- 

GRANT CONNECT ON DATABASE :db TO :usr;
\c :db

GRANT USAGE ON SCHEMA :sch TO :usr;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA :sch TO :usr;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA :sch TO :usr;
