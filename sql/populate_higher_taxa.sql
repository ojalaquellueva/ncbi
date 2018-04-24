-- --------------------------------------------------------
-- Adds higher taxa to table ncbi_species
-- --------------------------------------------------------

UPDATE ncbi_species a
SET "class"=b.scientific_name
FROM nodes b
WHERE a.left_index>b.left_index
AND a.right_index<b.right_index
AND b.rank='class'
;

UPDATE ncbi_species a
SET "phylum"=b.scientific_name
FROM nodes b
WHERE a.left_index>b.left_index
AND a.right_index<b.right_index
AND b.rank='phylum'
;

UPDATE ncbi_species a
SET "kingdom"=b.scientific_name
FROM nodes b
WHERE a.left_index>b.left_index
AND a.right_index<b.right_index
AND b.rank='kingdom'
;

UPDATE ncbi_species a
SET "superkingdom"=b.scientific_name
FROM nodes b
WHERE a.left_index>b.left_index
AND a.right_index<b.right_index
AND b.rank='superkingdom'
;

UPDATE ncbi_species a
SET is_embryophyte=1
FROM nodes b
WHERE a.left_index>b.left_index
AND a.right_index<b.right_index
AND b.scientific_name='Embryophyta'
;

UPDATE ncbi_species a
SET major_higher_taxon='Embryophyta'
WHERE is_embryophyte=1
;

UPDATE ncbi_species a
SET major_higher_taxon=superkingdom
WHERE major_higher_taxon IS NULL
AND superkingdom IS NOT NULL
AND superkingdom IN ('Viruses', 'Bacteria', 'Viroids', 'Archaea')
;

UPDATE ncbi_species a
SET major_higher_taxon='Animalia'
WHERE kingdom='Metazoa'
;

UPDATE ncbi_species a
SET major_higher_taxon='Fungi'
WHERE kingdom='Fungi'
;

UPDATE ncbi_species a
SET major_higher_taxon='Green algae'
WHERE major_higher_taxon IS NULL
AND "class" in (
'Charophyceae',
'Chlorodendrophyceae',
'Chlorokybophyceae',
'Chlorophyceae',
'Coleochaetophyceae',
'Klebsormidiophyceae',
'Mamiellophyceae',
'Mesostigmatophyceae',
'Nephroselmidophyceae',
'Pedinophyceae',
'Trebouxiophyceae',
'Ulvophyceae',
'Zygnemophyceae'
);


UPDATE ncbi_species a
SET major_higher_taxon='Algae'
WHERE major_higher_taxon IS NULL
AND kingdom='Viridiplantae'
;

UPDATE ncbi_species a
SET major_higher_taxon=
CASE
WHEN phylum='Apicomplexa' THEN 'Misc unicellular eukaryotes'
WHEN phylum='Aurearenophyceae' THEN 'Algae'
WHEN phylum='Bacillariophyta' THEN 'Algae'
WHEN phylum='Bolidophyceae' THEN 'Algae'
WHEN phylum='Chromerida' THEN 'Protists'
WHEN phylum='Colponemidia' THEN 'Protists'
WHEN phylum='Euglenida' THEN 'Euglenophyta'
WHEN phylum='Eustigmatophyceae' THEN 'Algae'
WHEN phylum='Haplosporidia' THEN 'Protists'
WHEN phylum='Phaeophyceae' THEN 'Brown algae'
WHEN phylum='Picozoa' THEN 'Misc unicellular eukaryotes'
WHEN phylum='Pinguiophyceae' THEN 'Algae'
WHEN phylum='Xanthophyceae' THEN 'Algae'
ELSE major_higher_taxon
END
WHERE major_higher_taxon IS NULL
;

UPDATE ncbi_species a
SET major_higher_taxon=
CASE
WHEN "class"='Phyllopharyngea' THEN 'Protists'
WHEN "class"='Rhodellophyceae' THEN 'Red Algae'
WHEN "class"='Dictyochophyceae' THEN 'Algae'
WHEN "class"='Oligohymenophorea' THEN 'Protists'
WHEN "class"='Polycystinea' THEN 'Radiolarians'
WHEN "class"='Oomycetes' THEN 'Misc unicellular eukaryotes'
WHEN "class"='Labyrinthulomycetes' THEN 'Protists'
WHEN "class"='Glaucocystophyceae' THEN 'Algae'
WHEN "class"='Cryptophyta' THEN 'Algae'
WHEN "class"='Chrysomerophyceae' THEN 'Algae'
WHEN "class"='Chrysophyceae' THEN 'Algae'
WHEN "class"='Florideophyceae' THEN 'Red Algae'
WHEN "class"='Compsopogonophyceae' THEN 'Red Algae'
WHEN "class"='Acantharea' THEN 'Misc unicellular eukaryotes'
WHEN "class"='Synurophyceae' THEN 'Algae'
WHEN "class"='Aphelidea' THEN 'Fungus allies'
WHEN "class"='Raphidophyceae' THEN 'Algae'
WHEN "class"='Actinophryidae' THEN 'Protists'
WHEN "class"='Synchromophyceae' THEN 'Algae'
WHEN "class"='Globothalamea' THEN 'Protists'
WHEN "class"='Ichthyosporea' THEN 'Protists'
WHEN "class"='Stylonematophyceae' THEN 'Red Algae'
WHEN "class"='Karyorelictea' THEN 'Protists'
WHEN "class"='Bangiophyceae' THEN 'Red Algae'
WHEN "class"='Heterolobosea' THEN 'Protists'
WHEN "class"='Prostomatea' THEN 'Protists'
WHEN "class"='Dinophyceae' THEN 'Misc unicellular eukaryotes'
WHEN "class"='Phaeothamniophyceae' THEN 'Algae'
WHEN "class"='Plagiopylea' THEN 'Protists'
WHEN "class"='Spirotrichea' THEN 'Protists'
WHEN "class"='Heterotrichea' THEN 'Protists'
WHEN "class"='Nassophorea' THEN 'Protists'
WHEN "class"='Litostomatea' THEN 'Protists'
WHEN "class"='Colpodea' THEN 'Protists'
WHEN "class"='Armophorea' THEN 'Protists'
WHEN "class"='Pelagophyceae' THEN 'Algae'
WHEN "class"='Hyphochytriomycetes' THEN 'Protists'
WHEN "class"='Placididea' THEN 'Algae'
WHEN "class"='Katablepharidophyta' THEN 'Misc unicellular eukaryotes'
ELSE major_higher_taxon
END
WHERE major_higher_taxon IS NULL
;

-- Some lumping for now
UPDATE ncbi_species
SET major_higher_taxon='Algae'
WHERE major_higher_taxon ILIKE '%algae%'
;
UPDATE ncbi_species
SET major_higher_taxon='Fungi'
WHERE major_higher_taxon='Fungus allies'
;
UPDATE ncbi_species
SET major_higher_taxon='Undetermined non-embryophyte'
WHERE major_higher_taxon IS NULL
;




