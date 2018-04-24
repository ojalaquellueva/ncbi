-- --------------------------------------------------------
-- Creates table ncbi_taxa by joining names to nodes
-- and populating denomalized higher taxon fields
-- --------------------------------------------------------

DROP TABLE IF EXISTS ncbi_taxa;
CREATE TABLE ncbi_taxa (
name_id bigint not null,
tax_id bigint not null,
rank text not null,
superkingdom text default null,
kingdom text default null,
phylum text default null,
"class" text default null,
taxon text not null,
unique_taxon text default null,
name_class text default null,
left_index bigint default null,
right_index bigint default null
);

-- Add all names where rank=speces
INSERT INTO ncbi_taxa (
name_id,
tax_id,
taxon,
unique_taxon,
name_class,
left_index,
right_index,
rank
)
SELECT 
a.name_id,
a.tax_id,
a.name_txt,
a.unique_name,
a.name_class,
b.left_index,
b.right_index,
'species'
FROM names a JOIN nodes b
ON a.tax_id=b.tax_id
WHERE b.rank='species'
;

-- Add all names where rank=speces
INSERT INTO ncbi_taxa (
name_id,
tax_id,
taxon,
unique_taxon,
name_class,
left_index,
right_index,
rank
)
SELECT 
a.name_id,
a.tax_id,
a.name_txt,
a.unique_name,
a.name_class,
b.left_index,
b.right_index,
'species'
FROM names a JOIN nodes b
ON a.tax_id=b.tax_id
WHERE b.rank='family'
;

CREATE INDEX ncbi_taxa_left_index_idx ON ncbi_taxa (left_index);
CREATE INDEX ncbi_taxa_right_index_idx ON ncbi_taxa (right_index);

