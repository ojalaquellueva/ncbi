-- 
-- Renames current production schema to "[production_schema_name]_bak" and 
-- replaces with development schema
--

BEGIN;

DROP SCHEMA IF EXISTS :prod_schema_bak CASCADE;
ALTER SCHEMA :prod_schema RENAME TO :prod_schema_bak;
ALTER SCHEMA :dev_schema RENAME TO :prod_schema;

COMMIT;