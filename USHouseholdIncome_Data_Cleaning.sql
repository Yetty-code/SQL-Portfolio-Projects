--  US Household Income Data Cleaning

-- Skills used: Window Functions, Subquery, Aggregate Functions

-- select rows from table
SELECT * 
FROM us_project.us_householdincome_copy;

SELECT * 
FROM us_project.us_householdincome_statistics_copy;

-- From the us_householdincome_statistics_copy table, the column name is incorrect,let us correct it
 ALTER TABLE us_project.us_householdincome_statistics_copy RENAME COLUMN `ï»¿id` TO `id`;
----------------------------------------------------------------------------------------------------------------------
-- Let's count the rows in each table
SELECT COUNT(id)
FROM us_project.us_householdincome_copy;
SELECT COUNT(id)
FROM us_project.us_householdincome_statistics_copy;

-- let's identify if there are duplicates
SELECT id,COUNT(id)
FROM us_project.us_householdincome_copy
GROUP BY id
HAVING COUNT(id) > 1 ;

-- let's delete those duplicates
DELETE FROM us_project.us_householdincome_copy
WHERE row_id IN
 (
SELECT row_id
FROM (SELECT row_id,
	id,
	ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
	FROM us_project.us_householdincome_copy) duplicates
WHERE row_num > 1)
;
-- let's check if the statistics data contain duplicates
SELECT id, COUNT(id)
FROM us_project.us_householdincome_statistics_copy
GROUP BY id
HAVING COUNT(id) > 1;
# There are no duplicates in the statistics dataset

-- Let's stanadardize our data
SELECT State_Name, COUNT(State_Name)
FROM us_project.us_householdincome_copy
GROUP BY State_Name;

-- We need to standardize State_Name column
UPDATE us_project.us_householdincome_copy
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

-- let's also standardize for Alabama
UPDATE us_project.us_householdincome_copy
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

-- We noticed a missing entry in the Place column, let's check
 SELECT *
FROM us_project.us_householdincome_copy
WHERE Place = '';

-- let's dig deeper to as to know what to populate the missing entry with
 SELECT *
FROM us_project.us_householdincome_copy
WHERE County = 'Autauga County'
AND City ='Vinemont' ;

-- Let's update the Place column
UPDATE us_householdincome_copy
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City ='Vinemont';

-- Let's check the Type column if we need to update or standardize
 SELECT Type, COUNT(Type)
FROM us_project.us_householdincome_copy
GROUP BY Type;

-- we saw 'Borough' and 'Boroughs', lets set to Borough
UPDATE us_householdincome_copy
SET Type = 'Borough'
WHERE Type = 'Boroughs';

-- let's check ALand and AWater
 SELECT ALand, AWater
FROM us_project.us_householdincome_copy
WHERE ALand = 0 OR ALand = '' OR ALand IS NULL
AND AWater = 0 OR AWater = '' OR AWater IS NULL;