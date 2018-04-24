-- --------------------------------------------------------
-- Add integer PK to table names
-- --------------------------------------------------------

ALTER TABLE names DROP COLUMN IF EXISTS name_id;

ALTER TABLE names ADD COLUMN name_id bigserial primary key;
