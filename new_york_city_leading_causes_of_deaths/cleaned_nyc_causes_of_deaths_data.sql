CREATE TABLE causes_of_deaths_staging
LIKE causes_of_deaths;

INSERT INTO causes_of_deaths_staging
SELECT *
FROM causes_of_deaths;

ALTER TABLE causes_of_deaths_staging
RENAME COLUMN `Year` TO year,
RENAME COLUMN `Leading Cause` TO leading_cause,
RENAME COLUMN Sex TO sex,
RENAME COLUMN `Race Ethnicity` TO race_ethnicity,
RENAME COLUMN Deaths TO deaths,
RENAME COLUMN `Death Rate` TO death_rate,
RENAME COLUMN `Age Adjusted Death Rate` TO age_adjusted_death_rate;

SELECT DISTINCT death_rate, age_adjusted_death_rate
FROM causes_of_deaths_staging
WHERE death_rate NOT REGEXP '^[0-9]+$';

UPDATE causes_of_deaths_staging
SET death_rate = NULL
WHERE death_rate IN ('.', 'N/A', '');

UPDATE causes_of_deaths_staging
SET age_adjusted_death_rate = NULL
WHERE age_adjusted_death_rate IN ('.', 'N/A', '');

ALTER TABLE causes_of_deaths_staging
MODIFY COLUMN death_rate DECIMAL(6,1);

UPDATE causes_of_deaths
SET leading_cause = TRIM(leading_cause),
sex = TRIM(sex),
race_ethnicity = TRIM(race_ethnicity);

CREATE TABLE causes_of_deaths_clean
LIKE causes_of_deaths_staging;

INSERT INTO causes_of_deaths_clean
SELECT DISTINCT *
FROM causes_of_deaths_staging;

SELECT `year`, leading_cause, sex, race_ethnicity, deaths, death_rate, age_adjusted_death_rate, COUNT(*)
FROM causes_of_deaths_staging
GROUP BY `year`, leading_cause, sex, race_ethnicity, deaths, death_rate, age_adjusted_death_rate
HAVING COUNT(*) > 1;

DROP TABLE causes_of_deaths_staging;

RENAME TABLE causes_of_deaths_clean TO causes_of_deaths_staging;

SELECT `year`, leading_cause, sex, race_ethnicity, deaths, death_rate, age_adjusted_death_rate, COUNT(*)
FROM causes_of_deaths_staging
GROUP BY `year`, leading_cause, sex, race_ethnicity, deaths, death_rate, age_adjusted_death_rate
HAVING COUNT(*) > 1;

SELECT (SELECT COUNT(*) FROM causes_of_deaths) AS before_rows,
(SELECT COUNT(*) FROM causes_of_deaths_staging) AS after_rows;

SELECT *
FROM causes_of_deaths_clean;







