CREATE DATABASE world_layoffs;
USE world_layoffs;

SELECT *
FROM layoffs;

-- Data Cleaning Process 
-- 	Remove Duplicates
-- 	Starndardize the Data 
-- 	Dealing with Null Values and Blank Values
-- 	Remove unnecessary Columns 

-- Creating a duplicate
CREATE TABLE layoffs_copy
LIKE layoffs;

INSERT layoffs_copy
SELECT *
FROM layoffs;

-- Checking for duplicate 
WITH duplicates AS 
(
	SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY company, location, industry,
    total_laid_off, percentage_laid_off,'date',
    stage, country, funds_raised_millions
    ) AS row_num
	FROM layoffs_copy
)
SELECT *
FROM duplicates
WHERE row_num > 1;

 SELECT *
 FROM layoffs_copy 
 WHERE company = 'Cazoo';
-- Creating a Table to remove duplicates
CREATE TABLE `layoffs_copy1` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_copy1
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY company, location, industry,
    total_laid_off, percentage_laid_off,'date',
    stage, country, funds_raised_millions
    ) AS row_num
FROM layoffs_copy;
-- Remove the Duplicates
SELECT *
FROM layoffs_copy1
WHERE row_num > 1;

DELETE 
FROM layoffs_copy1
WHERE row_num > 1;

SELECT *
FROM layoffs_copy1;

-- Standardize the Data
SELECT company, TRIM(company)
FROM layoffs_copy1;

UPDATE layoffs_copy1
SET  company = TRIM(company);

SELECT 
	DISTINCT industry
FROM layoffs_copy1
ORDER BY 1;

UPDATE  layoffs_copy1
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


SELECT 
	 distinct location, country
FROM layoffs_copy1
ORDER BY 1;
-- This will turn 'MalmÃ¶' into 'Malmö
UPDATE layoffs_copy1
SET location = REPLACE(location, 'MalmÃ¶', 'Malmö')
WHERE location LIKE 'Malm%Ã¶';

-- Fix the Ã¼ encoding
UPDATE layoffs_copy1
SET location = REPLACE(location, 'DÃ¼sseldorf', 'Düsseldorf')
WHERE location LIKE 'D%sseldorf';

-- Standardize
UPDATE layoffs_copy1
SET location = 'Düsseldorf'
WHERE location = 'Dusseldorf';

-- Remove trailing periods from country names
UPDATE layoffs_copy1
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE '%.';

UPDATE layoffs_copy1
SET location = TRIM(TRAILING '.' FROM location)
WHERE location LIKE '%.';

ALTER TABLE layoffs_copy1
DROP COLUMN row_num;

CREATE TABLE `layoffs1` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  row_num int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs1
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY company, location, industry,
    total_laid_off, percentage_laid_off,'date',
    stage, country, funds_raised_millions
    ) AS row_num
FROM layoffs_copy1;

SELECT *
FROM layoffs1
WHERE row_num > 1;

DELETE 
FROM layoffs1
WHERE row_num > 1;
-- Let's also fix the date columns:
SELECT *
FROM layoffs1;

-- we can use str to date to update this field
UPDATE layoffs1
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- now we can convert the data type properly
ALTER TABLE layoffs1
MODIFY COLUMN `date` DATE;

-- remove any columns and rows we need to

SELECT *
FROM layoffs1
WHERE total_laid_off IS NULL;


SELECT *
FROM layoffs1
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Delete Useless data we can't really use
DELETE FROM layoffs1
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * 
FROM layoffs1;

ALTER TABLE layoffs1
DROP COLUMN row_num;

SELECT * 
FROM layoffs1;


