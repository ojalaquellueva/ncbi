-- --------------------------------------------------------
-- Set recursive fkey to null in table nodes
-- MPTT algorithm requires NULL parent fkey for root
-- --------------------------------------------------------

UPDATE nodes
SET parent_tax_id=NULL
WHERE tax_id=1
;