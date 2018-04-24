-- --------------------------------------------------------
-- Remove useless records in ncbi_species
-- --------------------------------------------------------

-- the following are mostly metagenomes, etc, definitely not plant species
DELETE FROM ncbi_species
WHERE superkingdom IS NULL
;