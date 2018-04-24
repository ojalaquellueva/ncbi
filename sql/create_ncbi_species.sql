-- --------------------------------------------------------
-- Creates table ncbi_species by joining names to nodes
-- and populating denomalized higher taxon fields
-- --------------------------------------------------------

DROP TABLE IF EXISTS ncbi_species;
CREATE TABLE ncbi_species (
name_id bigint not null,
tax_id bigint not null,
superkingdom text default null,
kingdom text default null,
phylum text default null,
"class" text default null,
species text not null,
unique_species text default null,
name_class text default null,
left_index bigint default null,
right_index bigint default null
);

-- Add all names where rank=speces
INSERT INTO ncbi_species (
name_id,
tax_id,
species,
unique_species,
name_class,
left_index,
right_index

)
SELECT 
a.name_id,
a.tax_id,
a.name_txt,
a.unique_name,
a.name_class,
b.left_index,
b.right_index
FROM names a JOIN nodes b
ON a.tax_id=b.tax_id
WHERE b.rank='species'
;

CREATE INDEX ncbi_species_left_index_idx ON ncbi_species (left_index);
CREATE INDEX ncbi_species_right_index_idx ON ncbi_species (right_index);

