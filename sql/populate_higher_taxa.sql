-- --------------------------------------------------------
-- Adds higher taxa to table ncbi_taxa
-- --------------------------------------------------------

UPDATE ncbi_taxa a
SET "class"=b.scientific_name
FROM nodes b
WHERE a.left_index>b.left_index
AND a.right_index<b.right_index
AND b.rank='class'
;

UPDATE ncbi_taxa a
SET "phylum"=b.scientific_name
FROM nodes b
WHERE a.left_index>b.left_index
AND a.right_index<b.right_index
AND b.rank='phylum'
;

UPDATE ncbi_taxa a
SET "kingdom"=b.scientific_name
FROM nodes b
WHERE a.left_index>b.left_index
AND a.right_index<b.right_index
AND b.rank='kingdom'
;

UPDATE ncbi_taxa a
SET "superkingdom"=b.scientific_name
FROM nodes b
WHERE a.left_index>b.left_index
AND a.right_index<b.right_index
AND b.rank='superkingdom'
;