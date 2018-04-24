ALTER TABLE ncbi_species DROP CONSTRAINT IF EXISTS ncbi_species_pkey;
ALTER TABLE ncbi_species ALTER COLUMN name_id DROP DEFAULT;
DROP SEQUENCE IF EXISTS ncbi_species_name_id_seq;
DROP INDEX IF EXISTS ncbi_species_name_id_idx;
DROP INDEX IF EXISTS ncbi_species_tax_id_idx;
DROP INDEX IF EXISTS ncbi_species_superkingdom_idx;
DROP INDEX IF EXISTS ncbi_species_kingdom_idx;
DROP INDEX IF EXISTS ncbi_species_phylum_idx;
DROP INDEX IF EXISTS ncbi_species_class_idx;
DROP INDEX IF EXISTS ncbi_species_species_idx;
DROP INDEX IF EXISTS ncbi_species_unique_species_idx;
DROP INDEX IF EXISTS ncbi_species_name_class_idx;

ALTER TABLE ncbi_species ADD PRIMARY KEY (name_id);
CREATE INDEX ncbi_species_tax_id_idx ON ncbi_species (tax_id);
CREATE INDEX ncbi_species_superkingdom_idx ON ncbi_species (superkingdom);
CREATE INDEX ncbi_species_kingdom_idx ON ncbi_species (kingdom);
CREATE INDEX ncbi_species_phylum_idx ON ncbi_species (phylum);
CREATE INDEX ncbi_species_class_idx ON ncbi_species ("class");
CREATE INDEX ncbi_species_species_idx ON ncbi_species (species);
CREATE INDEX ncbi_species_unique_species_idx ON ncbi_species (unique_species);
CREATE INDEX ncbi_species_name_class_idx ON ncbi_species (name_class);