-- 
-- Assign select level access to all relations in schema in db
-- 

-- Read-only access
GRANT CONNECT ON DATABASE :db TO :usr;
\c :db
GRANT USAGE ON SCHEMA :sch TO :usr;
GRANT SELECT ON ALL TABLES IN SCHEMA :sch TO :usr;