-- --------------------------------------------------------
-- Add accepted scientific name column to table nodes
-- --------------------------------------------------------

ALTER TABLE nodes DROP COLUMN IF EXISTS scientific_name;
ALTER TABLE nodes ADD COLUMN scientific_name text default null;

UPDATE nodes a
SET scientific_name=b.name_txt
FROM names b
WHERE b.tax_id=a.tax_id
AND b.name_class='scientific name'
;

CREATE INDEX nodes_scientific_name_idx ON nodes (scientific_name);