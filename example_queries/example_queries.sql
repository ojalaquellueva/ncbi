select tax_id, parent_tax_id, rank, scientific_name, left_index, right_index
from nodes
order by tax_id
limit 12;

select distinct rank from nodes
order by rank
;

-- Higher taxa for a plant
SELECT scientific_name, rank
FROM nodes
WHERE left_index<=
(SELECT left_index FROM nodes WHERE scientific_name='Citrus medica')
AND right_index>=
(SELECT right_index FROM nodes WHERE scientific_name='Citrus medica')
ORDER BY left_index ASC
;

-- Higher taxa for an animal
SELECT scientific_name, rank
FROM nodes
WHERE left_index<=
(SELECT left_index FROM nodes WHERE scientific_name='Bos taurus')
AND right_index>=
(SELECT right_index FROM nodes WHERE scientific_name='Bos taurus')
ORDER BY left_index ASC
;

-- Higher taxa for a fungus
SELECT scientific_name, rank
FROM nodes
WHERE left_index<=
(SELECT left_index FROM nodes WHERE scientific_name='Boletus edulis')
AND right_index>=
(SELECT right_index FROM nodes WHERE scientific_name='Boletus edulis')
ORDER BY left_index ASC
;

-- Higher taxa for a green algae
SELECT scientific_name, rank
FROM nodes
WHERE left_index<=
(SELECT left_index FROM nodes WHERE scientific_name='Volvox')
AND right_index>=
(SELECT right_index FROM nodes WHERE scientific_name='Volvox')
ORDER BY left_index ASC
;

-- Superkingdoms
SELECT scientific_name, rank
FROM nodes
WHERE rank='superkingdom'
;

-- Kingdoms
SELECT scientific_name, rank
FROM nodes
WHERE rank='kingdom'
;

SELECT species, b.family
FROM 
(
SELECT species, left_index, right_index
FROM ncbi_species 
WHERE species like 'Larrea %'
AND name_class='scientific name'
) a, 
(
SELECT scientific_name as family, left_index, right_index
FROM nodes WHERE rank='family'
) b
WHERE a.left_index>b.left_index
AND a.right_index<b.right_index
; 
