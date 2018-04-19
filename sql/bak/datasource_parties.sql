-- --------------------------------------------------------
-- --------------------------------------------------------
-- Extract user records from table datasource
-- --------------------------------------------------------
-- --------------------------------------------------------

SET search_path TO :sch;

-- --------------------------------------------------------
-- Extract parties
-- --------------------------------------------------------

INSERT INTO party (
fullname,
first_name,
last_name,
email
)
SELECT DISTINCT
b.primary_contact_fullname,
b.primary_contact_firstname,
b.primary_contact_lastname,
b.primary_contact_email
FROM :sch_adb.datasource b
WHERE b.primary_contact_fullname IS NOT NULL
;

-- flag institutions and other non-persons
UPDATE party
SET is_person=0
WHERE first_name IS NULL OR TRIM(first_name)=''
;


