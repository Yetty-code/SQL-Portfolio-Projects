# World Life Expectancy Project (Data Cleaning)

SELECT *
FROM worldlifeexpectancy_copy;

-- We shall start by identifying duplicate entries using Countyr and Year columns
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM worldlifeexpectancy_copy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1;

-- let us use a window function and subquery to create a row number 

SELECT Row_ID,
CONCAT(Country, Year),
ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS row_num
FROM worldlifeexpectancy_copy;
-- Use a subquery
SELECT *
FROM (
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS row_num
	FROM worldlifeexpectancy_copy
) AS row_table
WHERE row_num >1;

-- let us Delete the duplicate rows from the table
DELETE FROM worldlifeexpectancy_copy
WHERE 
	Row_ID IN (
	SELECT Row_ID
	FROM (
	SELECT Row_ID,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS row_num
	FROM worldlifeexpectancy_copy
) AS row_table
WHERE row_num >1
);

-- let's go back to the data
SELECT *
FROM worldlifeexpectancy_copy;

-- There are some missing values in the status, let's check
SELECT *
FROM worldlifeexpectancy_copy
WHERE Status = '';

-- Lets check the Distinct entries in the Status column
SELECT DISTINCT(Status)
FROM worldlifeexpectancy_copy
WHERE Status <> '';

-- let's fetch DISTINCT countries where status is 'Developing'
SELECT DISTINCT(Country)
FROM worldlifeexpectancy_copy
WHERE Status = 'Developing';

-- We are going to update the status of countries that are 'Developing'
UPDATE worldlifeexpectancy_copy
SET Status = 'Developing'
WHERE Country IN(SELECT DISTINCT(Country)
	FROM worldlifeexpectancy_copy
	WHERE Status = 'Developing'
) ;

-- The above code didn't work because we cannot UPDATE in the FROM clause
-- We are going to do a SELF JOIN to tie the table to itself and set status to Developing and filter 
UPDATE worldlifeexpectancy_copy t1
JOIN worldlifeexpectancy_copy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing';

-- let's fetch DISTINCT countries where status is 'Developed'
SELECT DISTINCT(Country)
FROM worldlifeexpectancy_copy
WHERE Status = 'Developed'; 

-- Let's check if there are still missing status
SELECT *
FROM worldlifeexpectancy_copy
WHERE Status = '';

-- We have 1 row from United States of America and from the previous code, we can see that its status is Developed 
-- Let us update it just as we updated the countries with developing status by tieing the table to itself
UPDATE worldlifeexpectancy_copy t1
JOIN worldlifeexpectancy_copy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed';

-- There are some missing values in the Life expectancy column
-- let's check 
SELECT *
FROM worldlifeexpectancy_copy
WHERE `Life expectancy` = '';
-- There are 2 rows. we are going to populate the life expectancy of these rows by using the average function on the data before
 -- the missiing value and the data after the missing value
 
 -- We are going to use a SELF JOIN twice and join ON Country and Year
 
 SELECT t1.Country, t1.Year, t1.`Life expectancy`,
 t2.Country, t2.Year, t2.`Life expectancy`,
 t3.Country, t3.Year, t3.`Life expectancy`
 FROM worldlifeexpectancy_copy t1
JOIN worldlifeexpectancy_copy t2
		ON t1.Country = t2.Country
        AND t1.Year = t2.Year - 1
JOIN worldlifeexpectancy_copy t3
		ON t1.Country = t3.Country
        AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = '';

-- let us add an average of t2.Life expectancy and t3.Life expectancy and round to 1 d.p
 SELECT t1.Country, t1.Year, t1.`Life expectancy`,
 t2.Country, t2.Year, t2.`Life expectancy`,
 t3.Country, t3.Year, t3.`Life expectancy`,
 ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
 FROM worldlifeexpectancy_copy t1
JOIN worldlifeexpectancy_copy t2
		ON t1.Country = t2.Country
        AND t1.Year = t2.Year - 1
JOIN worldlifeexpectancy_copy t3
		ON t1.Country = t3.Country
        AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = '';

-- We will use the average computed to populate the Life expectancy with missing values
-- We will JOIN the table twice and SET the Life expectancy column to the average populated

UPDATE worldlifeexpectancy_copy t1
JOIN worldlifeexpectancy_copy t2
		ON t1.Country = t2.Country
        AND t1.Year = t2.Year - 1
JOIN worldlifeexpectancy_copy t3
		ON t1.Country = t3.Country
        AND t1.Year = t3.Year + 1
SET t1.`Life expectancy`= ROUND((t2.`Life expectancy` + t3.`Life expectancy`)/2,1)
WHERE t1.`Life expectancy` = '';

-- Let's check the data
SELECT *
FROM worldlifeexpectancy_copy;