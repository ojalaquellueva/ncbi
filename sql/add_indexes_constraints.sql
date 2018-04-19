-- --------------------------------------------------------
-- Indexes 
-- --------------------------------------------------------

-- names
DROP INDEX IF EXISTS names_tax_id_idx;
DROP INDEX IF EXISTS names_name_txt_idx;
DROP INDEX IF EXISTS names_unique_name_idx;
DROP INDEX IF EXISTS names_name_class_idx;
CREATE INDEX names_tax_id_idx ON names (tax_id);
CREATE INDEX names_name_txt_idx ON names (name_txt);
CREATE INDEX names_unique_name_idx ON names (unique_name);
CREATE INDEX names_name_class_idx ON names (name_class);

-- delnodes
DROP INDEX IF EXISTS delnodes_tax_id_idx;
CREATE INDEX delnodes_tax_id_idx ON delnodes (tax_id);

-- merged
DROP INDEX IF EXISTS merged_old_tax_id_idx;
DROP INDEX IF EXISTS merged_new_tax_id_idx;
CREATE INDEX merged_old_tax_id_idx ON merged (old_tax_id);
CREATE INDEX merged_new_tax_id_idx ON merged (new_tax_id);

-- nodes
DROP INDEX IF EXISTS nodes_tax_id_idx;
DROP INDEX IF EXISTS nodes_is_provider_idx;
DROP INDEX IF EXISTS nodes_rank_idx;
DROP INDEX IF EXISTS nodes_division_id_idx;
CREATE INDEX nodes_tax_id_idx ON "nodes" (tax_id);
CREATE INDEX nodes_parent_tax_id_idx ON "nodes" (parent_tax_id);
CREATE INDEX nodes_rank_idx ON "nodes" (rank);
CREATE INDEX nodes_division_id_idx ON "nodes" (division_id);

-- division
DROP INDEX IF EXISTS division_division_id_idx;
DROP INDEX IF EXISTS division_division_cde_idx;
DROP INDEX IF EXISTS division_division_name_idx;
CREATE INDEX division_division_id_idx ON "division" (division_id);
CREATE INDEX division_division_cde_idx ON "division" (division_cde);
CREATE INDEX division_division_name_idx ON "division" (division_name);

-- --------------------------------------------------------
-- Constraints 
-- --------------------------------------------------------

ALTER TABLE nodes DROP CONSTRAINT IF EXISTS division_id_fkey;
ALTER TABLE nodes DROP CONSTRAINT IF EXISTS parent_tax_id_fkey;
ALTER TABLE merged DROP CONSTRAINT IF EXISTS new_tax_id_fkey;
ALTER TABLE names DROP CONSTRAINT IF EXISTS tax_id_fkey;
ALTER TABLE division DROP CONSTRAINT IF EXISTS division_pkey;
ALTER TABLE nodes DROP CONSTRAINT IF EXISTS nodes_pkey;

ALTER TABLE division
ADD PRIMARY KEY (division_id);

ALTER TABLE nodes
ADD PRIMARY KEY (tax_id);

ALTER TABLE names
ADD CONSTRAINT tax_id_fkey 
FOREIGN KEY (tax_id) 
REFERENCES nodes (tax_id) 
ON DELETE CASCADE;

ALTER TABLE merged
ADD CONSTRAINT new_tax_id_fkey 
FOREIGN KEY (new_tax_id) 
REFERENCES nodes (tax_id) 
ON DELETE CASCADE;

ALTER TABLE nodes
ADD CONSTRAINT parent_tax_id_fkey 
FOREIGN KEY (parent_tax_id) 
REFERENCES nodes (tax_id) 
ON DELETE CASCADE;

ALTER TABLE nodes
ADD CONSTRAINT division_id_fkey 
FOREIGN KEY (division_id) 
REFERENCES division (division_id) 
ON DELETE CASCADE;

