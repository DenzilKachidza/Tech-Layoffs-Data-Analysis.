/*
=========================================================
  📊 LAYOFFS DATA - EXPLORATORY DATA ANALYSIS & CLEANING
  Dataset: world_layoffs.layoffs_staging2
  Author: [Denzil Kachidza]
  Description:
    - Basic EDA to explore layoffs data
    - Identify trends, patterns, and outliers
    - Remove duplicate records before deeper analysis
=========================================================
*/

-- ======================================================
-- 🧹 1. CHECKING & REMOVING DUPLICATES
-- ======================================================

-- 🔍 Identify potential duplicates
SELECT company, location, industry, total_laid_off, date, COUNT(*) AS dup_count
FROM layoffs1
GROUP BY company, location, industry, total_laid_off, date
HAVING dup_count > 1;

-- ✅ (Optional) Add unique ID if not present
-- ALTER TABLE world_layoffs.layoffs_staging2
-- ADD COLUMN id INT PRIMARY KEY AUTO_INCREMENT;

-- 🗑️ Delete duplicates but keep one copy
DELETE FROM layoffs1
WHERE id IN (
  SELECT id FROM (
    SELECT id,
           ROW_NUMBER() OVER (
             PARTITION BY company, location, industry, total_laid_off, date
             ORDER BY id
           ) AS rn
    FROM layoffs1
  ) t
  WHERE rn > 1
);

-- ✅ Verify duplicates removed
SELECT company, location, industry, total_laid_off, date, COUNT(*) AS dup_count
FROM world_layoffs.layoffs_staging2
GROUP BY company, location, industry, total_laid_off, date
HAVING dup_count > 1;



-- ======================================================
-- 📊 2. BASIC EXPLORATION (EDA)
-- ======================================================

-- 🧭 View raw data
SELECT * 
FROM layoffs1;

-- 🧮 Max & Min layoffs
SELECT MAX(total_laid_off) AS max_laid_off
FROM layoffs1;

-- 📈 Max & Min layoff percentage
SELECT MAX(percentage_laid_off) AS max_pct, MIN(percentage_laid_off) AS min_pct
FROM layoffs1
WHERE percentage_laid_off IS NOT NULL;

-- 🏢 Companies with 100% layoffs
SELECT *
FROM layoffs1
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;



-- ======================================================
-- 🏭 3. AGGREGATION & GROUP-BY ANALYSIS
-- ======================================================

-- Top 5 biggest single layoffs
SELECT company, total_laid_off
FROM layoffs1
ORDER BY total_laid_off DESC
LIMIT 5;

-- Companies with the most total layoffs
SELECT company, SUM(total_laid_off) AS total
FROM layoffs1
GROUP BY company
ORDER BY total DESC
LIMIT 10;

-- Layoffs by location
SELECT location, SUM(total_laid_off) AS total
FROM layoffs1
GROUP BY location
ORDER BY total DESC
LIMIT 10;

-- Layoffs by country
SELECT country, SUM(total_laid_off) AS total
FROM layoffs1
GROUP BY country
ORDER BY total DESC;

-- Layoffs by year
SELECT YEAR(date) AS years, SUM(total_laid_off) AS total
FROM layoffs1
GROUP BY YEAR(date)
ORDER BY years ASC;

-- Layoffs by industry
SELECT industry, SUM(total_laid_off) AS total
FROM layoffs1
GROUP BY industry
ORDER BY total DESC;

-- Layoffs by stage
SELECT stage, SUM(total_laid_off) AS total
FROM layoffs1
GROUP BY stage
ORDER BY total DESC;



-- ======================================================
-- 🧠 4. ADVANCED ANALYSIS (Window Functions & Trends)
-- ======================================================

-- 🏆 Top 3 companies per year by layoffs
WITH Company_Year AS (
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS total_laid_off
  FROM layoffs1
  GROUP BY company, YEAR(date)
),
Company_Year_Rank AS (
  SELECT company, years, total_laid_off,
         DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

-- 📅 Rolling total of layoffs per month
WITH DATE_CTE AS (
  SELECT SUBSTRING(date,1,7) AS dates, SUM(total_laid_off) AS total_laid_off
  FROM layoffs1
  GROUP BY dates
  ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) AS rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;
