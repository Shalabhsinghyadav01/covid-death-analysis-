-- Step 1: Add a new temporary column
ALTER TABLE `project Portfolio`.covid_deaths
ADD COLUMN date_temp DATE;

-- Step 2: Convert the dates
UPDATE `project Portfolio`.covid_deaths
SET date_temp = STR_TO_DATE(date, '%m/%d/%y');

-- Step 3: Drop the old column
ALTER TABLE `project Portfolio`.covid_deaths
DROP COLUMN date;

-- Step 4: Rename the new column
ALTER TABLE `project Portfolio`.covid_deaths
CHANGE COLUMN date_temp date DATE;