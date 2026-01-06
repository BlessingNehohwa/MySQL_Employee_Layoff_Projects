-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. REMOVING DUPLICATES

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- identifying duplicates

SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;  -- If there is 2 it means there is duplicates

-- we create a CTE (common table expression)
WITH duplicate_cte AS
(
SELECT*,
ROW_NUMBER () OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)

SELECT *
FROM duplicate_cte
WHERE row_num > 1;
 
SELECT *
FROM layoffs_staging
WHERE company='casper'
;
-- this did not work because in Mysql if you try to the delete inside a cte it will say update hence not possible
-- we have to do it another way by creating another table and deletinng the duplicates duplicates.

-- LAYOFFS_STAGING2 CREATED

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2;
INSERT layoffs_staging2

    -- identifying duplicates
SELECT *,
ROW_NUMBER () OVER(
PARTITION BY company,location,
  industry,total_laid_off,percentage_laid_off,
  'date',stage ,country,funds_raised_millions
) 
AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2;

-- ***** DELETING THE DUPLICATE ROWS
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;
-- ALL DONE

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2;

-- If you have a unique column its so much easy to do it




--
-- 2. STANDADIZING  DATA spell checking
-- Finding issues and fixing them
--

SELECT DISTINCT (company)  -- to remove company names spaces between them
FROM layoffs_staging2;

SELECT company,(TRIM(company))  -- we Use TRIM to remove the white spaces on the left and right nof the company name
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company= TRIM(company);

SELECT *
FROM layoffs_staging2;



-- Checking the INDUSTRY column
SELECT DISTINCT industry  
FROM layoffs_staging2
ORDER BY 1;  -- We have two null spaces and same industry names slightly named differently

SELECT  * 
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'; -- removing any words after the word Crypto

SELECT DISTINCT industry  
FROM layoffs_staging2
ORDER by 1;

-- Checking  at LOCATI0N column
SELECT DISTINCT location  
FROM layoffs_staging2
ORDER by 1;  -- All looks good


-- Checking  at COUNTRY column
SELECT DISTINCT country
FROM layoffs_staging2
ORDER by 1;                     -- United states has a wrong spelling with . added

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT *
FROM layoffs_staging2;


SELECT DISTINCT country 
FROM layoffs_staging2
ORDER by 1;  


-- checking and changing the DATE column
SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging2;


UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`,'%m/%d/%Y');

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;



--
-- 3. NULL VALUES OR Blanks values
--
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;   -- We check and see if we should remove these but unfortunately

UPDATE layoffs_staging2
SET industry = Null
WHERE industry='';

SELECT *                      -- INDUSTRY seems to have some null values which are important and need to be populated
FROM layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT company
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE company='airbnb';

SELECT *
FROM layoffs_staging2 t1    
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry='')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1 
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE company='airbnb';

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;  -- These columns are not important in what we want to use the data for ,so we need to remove them

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;



--
-- 4. REMOVE any Columns
--


ALTER TABLE layoffs_staging2     -- deleting column row_num
DROP COLUMN row_num;

SELECT *
FROM layoffs_staging2;



