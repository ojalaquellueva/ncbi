-- --------------------------------------------------------
-- Remove useless records in ncbi_species
-- --------------------------------------------------------

-- the following are mostly metagenomes, etc, definitely not plant species
DELETE FROM ncbi_taxa
WHERE superkingdom IS NULL
;