# World Life Expectancy Exploratory Data Analysis

SELECT *
FROM worldlifeexpectancy_copy;

-- Calcualte Average GDP
SELECT ROUND(AVG(`Life expectancy`),1)
FROM worldlifeexpectancy_copy;
# The average life expectancy is 69 world wide

-- Let's see the minimum and maximum life expectancy per country
SELECT Country, MIN(`Life expectancy`) AS Min_Life_Exp,
MAX(`Life expectancy`) AS Max_Life_Exp
FROM worldlifeexpectancy_copy
GROUP BY Country
HAVING MIN_LIFE_EXP <> 0
AND MAX_LIFE_EXP <> 0
ORDER BY Country DESC;

-- Let's see which countries have made the biggest strides from lowest to highest life expectancy
SELECT Country,
MIN(`Life expectancy`) AS Min_Life_Exp,
MAX(`Life expectancy`) AS Max_Life_Exp,
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),1) AS Life_Increase_15_yrs
FROM worldlifeexpectancy_copy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_yrs DESC;
#  Countries like Haiti, Zimbabwe and Eritrea have made huge strides in life expectancy
# Countries like Guyana, Seychelles and Kuwait have very low increase in 15 yrs because their minimum and maximum life expectancy is high already

-- let's see the average life expectancy by year
SELECT YEAR,
ROUND(AVG(`Life expectancy`),2)
FROM worldlifeexpectancy_copy
WHERE `Life expectancy` <> 0
GROUP BY Year
ORDER BY Year;
# In General, there is an increase from 2007 to 2022

-- Let's see the average life expectancy and average GDP
SELECT Country, 
ROUND(AVG(`Life expectancy`),1) AS Life_exp, 
ROUND(AVG(GDP),1) AS GDP
FROM worldlifeexpectancy_copy
GROUP BY Country
HAVING Life_exp > 0
AND GDP > 0
ORDER BY GDP ASC;


SELECT Country, 
ROUND(AVG(`Life expectancy`),1) AS Life_exp, 
ROUND(AVG(GDP),1) AS GDP
FROM worldlifeexpectancy_copy
GROUP BY Country
HAVING Life_exp > 0
AND GDP > 0
ORDER BY GDP DESC;
# There is a positive correlation between the average life expectancy and the average GDP
# As the country's life expectancy is increasing the average GDP is also increasing

-- let's categorize the GDP into high GDP. 
SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END ) High_GDP_life_exp,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN `Life expectancy` ELSE NULL END ) Low_GDP_life_exp
FROM worldlifeexpectancy_copy;
# There are 1326 countries that have GDP greater than 1500. Out of these 1326 countries their average life expectancy is 74 years.
# There are 1612 countries that have GDP lower than 1500. Out of these 1612 countries their average life expectancy is 65 years.
# Low GDP countries have 10 years less than high GDP countries

-- Let's see BMI and Life expectancy
SELECT 
CASE 
	WHEN BMI < 18.5 THEN 'Underweight'
    WHEN BMI >= 18.5 AND BMI < 25 THEN 'Normal'
    WHEN BMI >=25 AND BMI < 30 THEN 'Overweight'
    WHEN BMI >= 30 THEN 'Obese'
END AS BMI_Category,
ROUND(AVG(`Life expectancy`),1) AS avg_life_exp,
COUNT(Country) AS count
FROM worldlifeexpectancy_copy
GROUP BY BMI_Category
ORDER BY BMI_Category
;
# There are 1728 countries with average life expectancy of 74 years who are Obese
# There are 693 countries with average life expectancy of 63 years who are underweight

-- Let's find the average life expectancy by status
SELECT Status,
ROUND(AVG(`Life expectancy`),1)
FROM worldlifeexpectancy_copy
GROUP BY Status;
# In Developing countries the average life expectancy is 67 years whereas  in developed countries the average life expectancy is 79 years

-- Let's see the status, average life expectancy and Country
SELECT Status, 
COUNT(DISTINCT Country),
ROUND(AVG(`Life expectancy`),1)
FROM worldlifeexpectancy_copy
GROUP BY Status;
# There are 32 developed countries with life expectancy of about 80 years 
# There are 161 developing countries with life expectancy of 67 years

-- Total Adult Mortality by Country and Year
SELECT Country,
Year,
`Life expectancy`,
`Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_total
FROM worldlifeexpectancy_copy;