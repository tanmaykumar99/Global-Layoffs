SELECT *
FROM layoffs;

## Changing Names of some columns to avoid repeated use of backticks

ALTER TABLE layoffs RENAME COLUMN `Location HQ` TO Location;
ALTER TABLE layoffs RENAME COLUMN `# Laid Off` TO Number_laid_off;
ALTER TABLE layoffs RENAME COLUMN `%` TO Percentage_laid_off;
ALTER TABLE layoffs RENAME COLUMN `$ Raised (mm)` TO Funds_raised_mil;
ALTER TABLE layoffs RENAME COLUMN `Date Added` TO Date_added;

## Creating a duplicate table before making further changes. This serves as an essential step
# in a real world scenario where data is automatically pulled from several sources
# and we don't want to make any changes to the raw data

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

## We will drop required columns from this database, as they may not serve a purpose
# in future ETL processes unless stated otherwise

ALTER TABLE layoffs_staging DROP COLUMN `Source`;
ALTER TABLE layoffs_staging DROP COLUMN Date_added;

## REMOVING DUPLICATES

## Due to absence of index like in SQL Server, we will create our own index
# with ROW_NUMBER

SELECT *,
ROW_NUMBER() OVER (
PARTITION BY Company, Location,
Industry, Number_laid_off, `Stage`, Funds_raised_mil,
`Date`, Percentage_laid_off, Country) AS row_num
FROM layoffs_staging;

## If row_num>1, it signifies presence of duplicates

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY Company, Location,
Industry, Number_laid_off, `Stage`, Funds_raised_mil,
`Date`, Percentage_laid_off, Country) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num>1;

CREATE TABLE `layoffs_staging2` (
  `Company` text,
  `Location` text,
  `Number_laid_off` text,
  `Date` text,
  `Percentage_laid_off` text,
  `Industry` text,
  `Stage` text,
  `Funds_raised_mil` text,
  `Country` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY Company, Location,
Industry, Number_laid_off, `Stage`, Funds_raised_mil,
`Date`, Percentage_laid_off, Country) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num>1;

ALTER TABLE layoffs_staging2 DROP COLUMN row_num;

## STANDARDIZING DATA

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);


## NOTE: Upon scanning the dataset, it is to be noticed that there are some companies
# that are labelled to have 2 different industries, as layoffs occured in separate
# divisions of the company. We will be keeping them as is for the scope of this project,
# but if someone wants to view these companies, they can do so by running the following query:

## SELECT Company, Industry
# FROM layoffs_staging2
# WHERE Company IN (
# SELECT Company
# FROM layoffs_staging2
# GROUP BY Company
# HAVING COUNT(DISTINCT Industry) > 1
# )
# ORDER BY 1;


## Going through the columns, we notice that certain cities outside of the US are
# of the format ',Non-U.S.' This would look better cleaned up

UPDATE layoffs_staging2
SET Location = REPLACE(Location, ',Non-U.S.', '');

## Anglicizing some city names (This should be avoided if a client is from the foreign host
# nation)

UPDATE layoffs_staging2
SET Location = CASE
    WHEN Location LIKE '%FlorianÃ³polis%' THEN 'Florianopolis'
    WHEN Location LIKE '%WrocÅ‚aw%' THEN 'Wrocław'
    WHEN Location LIKE '%FÃ¸rde%' THEN 'Førde'
    WHEN Location LIKE 'MalmÃ¶' THEN 'Malmo'
    WHEN Location LIKE 'DÃ¼sseldorf' THEN 'Dusseldorf'
    ELSE Location
END;

## Certain rows have two different cities clubbed together in one row. We should
# ideally split this

INSERT INTO layoffs_staging2 (Company, Location, Number_laid_off, `Date`,
Percentage_laid_off, Industry, Stage, Funds_raised_mil, Country)
VALUES 
  ('Deliveroo Australia', 'Melbourne', 120, '11/15/2022', '100%', 'Food', 'Post-IPO', '$1700', 'Australia'),
  ('Deliveroo Australia', 'Victoria', 120, '11/15/2022', '100%', 'Food', 'Post-IPO', '$1700', 'Canada'),
  ('Kleos Space', 'Luxembourg', '', '7/26/2023', '100%', 'Aerospace', 'Post-IPO', '$17', 'Luxembourg'),
  ('Kleos Space', 'Raleigh', '', '7/26/2023', '100%', 'Aerospace', 'Post-IPO', '$17', 'United States'),
  ('The Org', 'New Delhi', 13, '8/3/2022', '', 'HR', 'Series B', '$39', 'India'),
  ('The Org', 'New York City', 13, '8/3/2022', '', 'HR', 'Series B', '$39', 'United States');

UPDATE layoffs_staging2
SET Country = 'United Arab Emirates'
WHERE Country = 'UAE';

SELECT *
FROM layoffs_staging2;

## Changing Date from text type to Datetime

SELECT `Date`
FROM layoffs_staging2
WHERE STR_TO_DATE(`Date`, '%m/%d/%Y') IS NULL
  AND `Date` IS NOT NULL;
  
UPDATE layoffs_staging2
SET `Date` = STR_TO_DATE(`Date`, '%m/%d/%Y')
WHERE `Date` IS NOT NULL;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `Date` DATE;

## Populating blank or null values where possible

UPDATE layoffs_staging2
SET Country = 'Germany'
WHERE Company = 'Fit Analytics';

UPDATE layoffs_staging2
SET Country = 'Canada'
WHERE Company = 'Ludia';

UPDATE layoffs_staging2
SET Industry = 'Other'
WHERE Company = 'Appsmith';

UPDATE layoffs_staging2
SET Location = 'SF Bay Area'
WHERE Company = 'Product Hunt';

UPDATE layoffs_staging2
SET Stage = CASE
  WHEN Company = 'Advata' THEN 'Unknown'
  WHEN Company = 'Gatherly' THEN 'Acquired'
  WHEN Company = 'Relevel' THEN 'Seed'
  WHEN Company = 'Soundwide' THEN 'Subsidiary'
  WHEN Company = 'Spreetail' THEN 'Private Equity'
  WHEN Company = 'Verily' THEN 'Subsidiary'
  WHEN Company = 'Zapp' THEN 'Post-IPO'
  ELSE Stage
END
WHERE Company IN ('Advata', 'Gatherly', 'Relevel',
'Soundwide', 'Spreetail', 'Verily', 'Zapp');

## Replacing blank values with Nulls

UPDATE layoffs_staging2
SET 
  Number_laid_off = IF(Number_laid_off = '', NULL, Number_laid_off),
  Percentage_laid_off = IF(Percentage_laid_off = '', NULL, Percentage_laid_off),
  Funds_raised_mil = IF(Funds_raised_mil = '', NULL, Funds_raised_mil);


## Changing required columns into int type

SELECT Number_laid_off, Percentage_laid_off, Funds_raised_mil
FROM layoffs_staging2
WHERE 
  Number_laid_off REGEXP '[^0-9]' OR
  Percentage_laid_off REGEXP '[^0-9]' OR
  Funds_raised_mil REGEXP '[^0-9]';
  
UPDATE layoffs_staging2
SET Percentage_laid_off = REPLACE(Percentage_laid_off, '%', '');
UPDATE layoffs_staging2
SET Funds_raised_mil = REPLACE(Funds_raised_mil, '$', '');

ALTER TABLE layoffs_staging2
MODIFY COLUMN Number_laid_off INT,
MODIFY COLUMN Percentage_laid_off INT,
MODIFY COLUMN Funds_raised_mil INT;

## Best to delete rows which have no data for total laid off and percent. laid off
# as this will serve no purpose for the scope of this project

DELETE
FROM layoffs_staging2
WHERE Number_laid_off IS NULL
AND Percentage_laid_off IS NULL;

# ---------------------------------------------------------------------------------------

## EXPLORATORY DATA ANALYSIS

# 1. Which was the most lay-offs in one go, and which company did so?
SELECT MAX(Number_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE Number_laid_off = (
SELECT MAX(Number_laid_off)
FROM layoffs_staging2
);

# Intel was the company with most lay offs in one go, in April of 2025 
# at a whopping 22,000 of its employees laid off.


# 2. How many companies went out of business since 2020?
SELECT COUNT(*)
FROM layoffs_staging2
WHERE Percentage_laid_off = 100;

SELECT *
FROM layoffs_staging2
WHERE Percentage_laid_off = 100
ORDER BY Number_laid_off DESC;

# A total of 327 companies went out of business since 2020, with 100% of their workforce laid off,
# with Katerra having the most lay-offs at 2,434 personnels (June 2021), and  
# and TutorMundi having the least lay-offs at a mere 4 personnels (April 2020).

# 3. Which companies have had the most lay offs since 2020?
SELECT Company, SUM(Number_laid_off)
FROM layoffs_staging2
GROUP BY Company
ORDER BY 2 DESC;

## Top five companies with most layoffs since 2020 are as follows:
# 1. Intel       43,115 layoffs
# 2. Microsoft   30,013 layoffs
# 3. Amazon      27,940 layoffs
# 4. Meta	     24,700 layoffs
# 5. Tesla	     14,500 layoffs


# What industry got hit the worst in this 5 year period?
SELECT Industry, SUM(Number_laid_off)
FROM layoffs_staging2
GROUP BY Industry
ORDER BY 2 DESC;

## Top five industries with most layoffs since 2020 are as follows:
# 1. Hardware    		86,528 layoffs
# 2. Other       		80,992 layoffs
# 3. Consumer    		76,668 layoffs
# 4. Retail	     		73,721 layoffs
# 5. Transportation	    63,316 layoffs  (Possibly due to Covid impacting transportation)

# POINT TO NOTE: 'Other' has its numbers greatly boosted as all tech companies in this
# dataset were labelled as 'Other,' and we know that the Tech/Software industries were hit
# quite significantly with layoffs.

SELECT Industry, SUM(Number_laid_off)
FROM layoffs_staging2
GROUP BY Industry
ORDER BY 2;

# Conversely, the industries least affected are as follows:
# 1. AI    		        462  layoffs  (Possibly due to the AI industry being a relatively new industry)
# 2. Legal      		1056 layoffs
# 3. Product   		    2126 layoffs
# 4. Aerospace     		3472 layoffs
# 5. Construction	    3977 layoffs 


# 4. Which countries were hit the worst during this period?
SELECT Country, SUM(Number_laid_off)
FROM layoffs_staging2
GROUP BY Country
ORDER BY 2 DESC;

## Top five countries with most layoffs since 2020 are as follows:
# 1. USA 		    522,099 layoffs
# 2. India      	59,229  layoffs
# 3. Germany   		31,273  layoffs
# 4. UK    		    21,222  layoffs
# 5. Netherlands    19,425  layoffs

# NOTE: It could be that USA and India have the most layoffs because they also had/have
# the most hiring, especially in the tech, software, and hardware industries. It is also
# interesting to note that the 2nd placed India has only 12% of the total layoffs of 
# 1st placed USA.

# 5. Which year was hit the worst since 2020?
SELECT YEAR(`Date`) AS `Year`, SUM(Number_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`Date`)
ORDER BY 1;

# 2023 was the year with the most layoffs at a total of 264,220
# Conversely, 2021 reported the lowest numbers at a mere 15,823 layoffs
# 2025 has its counter at 80,150 layoffs as of July

# 6. What stage companies were hit the most and least?
SELECT Stage, SUM(Number_laid_off)
FROM layoffs_staging2
GROUP BY Stage
ORDER BY 2 DESC;

# Post-IPO companies were hit the most with 443,784 layoffs. This could be verified 
# by checking what stage the top 5 companies with most layoffs are at.
SELECT Company, Stage, SUM(Number_laid_off)
FROM layoffs_staging2
GROUP BY Company, Stage
ORDER BY 3 DESC;

# And it checks out, since not just the top 5, but the top 10 companies with most
# layoffs are Post-IPO.

# Conversely, Companies in their Seed phase were hit the least with only 2,221 layoffs


# 7. Progression of Layoffs
WITH Rolling_Total AS
(
SELECT SUBSTRING(`Date`,1,7) AS `MONTH`, SUM(Number_laid_off) AS `Total laid off`
FROM layoffs_staging2
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, `Total laid off`,
SUM(`Total laid off`) OVER(ORDER BY `MONTH`) AS `Rolling total`
FROM Rolling_Total;

# This data has been exported out to create a visualized time series in Tableau



# 8. What were the top 5 companies laying off the most each year?
WITH Company_Year (Company, `Year`, `Total laid off`) AS
(
SELECT Company, YEAR(`Date`), SUM(`Number_laid_off`)
FROM layoffs_staging2
GROUP BY Company, YEAR(`Date`)
ORDER BY 3 DESC
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY `Year`
ORDER BY `Total laid off` DESC) AS `Rank by year`
FROM Company_Year
)
SELECT DISTINCT *
FROM Company_Year_Rank
WHERE `Rank by year` <=5;

# This data has been exported out to create a visualized time series in Tableau

