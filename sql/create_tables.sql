-- --------------------------------------------------------
-- Generate tables for database ncbi
-- --------------------------------------------------------

DROP TABLE IF EXISTS names CASCADE;
CREATE TABLE names (
tax_id bigint default null,
name_txt text default null,
unique_name text default null,
name_class text default null
);
COMMENT ON TABLE names IS 'Name(s) of nodes (=taxa)';
-- COMMENT ON COLUMN names.name_id IS 'Artificial pkey, not in original file';
-- name_id serial not null primary key,

DROP TABLE IF EXISTS citations CASCADE;
CREATE TABLE citations (
cit_id bigint default null,
cit_key text default null,
pubmed_id integer default null,
medline_id integer default null,
url text default null,
citation_text text default null,
taxid_list text default null
);

DROP TABLE IF EXISTS delnodes CASCADE;
CREATE TABLE delnodes (
tax_id bigint default null
);

DROP TABLE IF EXISTS division CASCADE;
CREATE TABLE division (
division_id bigint default null,
division_cde text default null,
division_name text default null,
comments text default null
);

DROP TABLE IF EXISTS gencode CASCADE;
CREATE TABLE gencode (
genetic_code_id bigint default null,
abbreviation text default null,
name text default null,
cde text default null,
starts text default null
);

DROP TABLE IF EXISTS merged CASCADE;
CREATE TABLE merged (
old_tax_id bigint default null,
new_tax_id bigint default null
);
COMMENT ON TABLE merged IS 'Merged nodes';
COMMENT ON COLUMN merged.old_tax_id IS 'id of nodes which has been merged';
COMMENT ON COLUMN merged.new_tax_id IS 'id of nodes which is result of merging';

DROP TABLE IF EXISTS nodes CASCADE;
CREATE TABLE nodes (
tax_id bigint default null,
parent_tax_id bigint default null,
rank text default null,
embl_code text default null,
division_id integer default null,
inherited_div_flag integer default null,
genetic_code_id integer default null,
inherited_gc_flag integer default null,
mitochondrial_genetic_code_id integer default null,
inherited_mgc_flag integer default null,
genbank_hidden_flag integer default null,
hidden_subtree_root_flag integer default null,
comments text default null
);
COMMENT ON TABLE merged IS 'Taxonomic nodes (=taxa)';