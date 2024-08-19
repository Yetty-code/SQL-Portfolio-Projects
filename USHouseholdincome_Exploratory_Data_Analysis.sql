# US Household Income Exploratory Data Analysis

# Skills used: Joins, Aggregate Function

SELECT *
FROM us_householdincome_copy;

SELECT *
FROM us_householdincome_statistics_copy;

-- Let's check the total area of land and water by state
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_householdincome_copy
GROUP BY State_Name
ORDER BY 3 DESC;
# Texas, California,Missouri and Minnesota have the highest Land Area
# District of Columbia, Rhode Island, Delaware, Puerto Rico, Hawaii have the lowest Land Area

-- Top 10 Sates by Land Area 
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_householdincome_copy
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;
# Texas, California,Missouri and Minnesota, Illinois, Kansas, Oklahoma, Iowa,Wisconsin  and Michigan are the top 10 states with the highest # Land Area


-- Top 10 Sates by Water Area 
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_householdincome_copy
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10;
# Michigan,Texas,Florida,Minnesota,Louisiana,California, Alaska,North Carolina,Washington and Wisconsin are the top 10 states with the highest
# Water Area

-- let's join both tables
SELECT *
FROM us_householdincome_copy u
INNER JOIN us_householdincome_statistics_copy us
	ON u.id = us.id
WHERE Mean <> 0;

SELECT u.State_Name,
County, 
`Type`,
`Primary`, 
Mean,
Median
FROM us_householdincome_copy u
INNER JOIN us_householdincome_statistics_copy us
	ON u.id = us.id
WHERE Mean <> 0;

-- Bottom 5 Average household income by state
SELECT u.State_Name,
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_householdincome_copy u
INNER JOIN us_householdincome_statistics_copy us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 ASC
LIMIT 5;

-- Top 5 Average household income by state
SELECT u.State_Name,
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_householdincome_copy u
INNER JOIN us_householdincome_statistics_copy us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 5;

-- Median household income by state
SELECT u.State_Name,
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_householdincome_copy u
INNER JOIN us_householdincome_statistics_copy us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 DESC
;
#  New Jersey, Wyoming,Alaska and Connecticut have the highest median household income

-- Average Household Income by Type
SELECT Type,
COUNT(Type),
ROUND(AVG(Mean),1),
ROUND(AVG(Median),1)
FROM us_householdincome_copy u
INNER JOIN us_householdincome_statistics_copy us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY Type
ORDER BY 3 DESC
;
# Municipality has the highest average household income
# Urban and Community has the lowest average household income

-- Let's check the states that have Community as Type
SELECT *
FROM us_householdincome_copy
WHERE Type = 'Urban'
 ;
 #  Puerto Rico has the lowest average  household income with Type Urban and Community
 
 --  State and City with high average household income
 SELECT u.State_Name,
 City,
ROUND(AVG(Mean),1)
FROM us_householdincome_copy u
INNER JOIN us_householdincome_statistics_copy us
	ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY 3 DESC;
# Alaska,Delta Junction has the highest average household income followed by New Jersey,Pennsylvania and Maryland


 

