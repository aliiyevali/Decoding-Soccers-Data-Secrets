/*
Data 1 Imported Successfuly
*/

SHOW data_directory;

CREATE TABLE First500 (
    "Unnamed: 0" SERIAL PRIMARY KEY,
    "Name" TEXT,
    "Shirt Number" Text,
    "Age" VARCHAR(255),
    "Sub-Position" TEXT,
    "Country" TEXT,
    "Height" VARCHAR(255), -- Assuming height is stored as a decimal, adjust precision/scale as needed
	"DiffPercent" VARCHAR(255),	
	DifferenceValue VARCHAR(255),
    "Matches" INTEGER,
    "Goals" INTEGER,
    "Assists" TEXT,
    "Cards" VARCHAR(255),
    "Minutes" VARCHAR(255),
    "Value" Text, -- Assuming a numeric type for value, adjust precision/scale as needed
    "Links" TEXT,
    "Foot" TEXT,
    "Isfoot" TEXT,
    "Injury_Sum" INTEGER,
    "Achievements" TEXT
);
Drop Table First500;
SHOW data_directory;

COPY first500 FROM '/Library/PostgreSQL/16/data/Diff.csv' WITH (FORMAT CSV, HEADER, DELIMITER ',');

Select * from first500;

/* Adjusting some columns of table 1 */

UPDATE First500
SET "Value" = TRIM(BOTH E'\n' FROM "Value");
UPDATE First500
SET "Shirt Number" = TRIM(BOTH E'\n' FROM "Shirt Number");

/* Importing second table successfuly */

CREATE TABLE Most500 (
    "Unnamed: 0" SERIAL PRIMARY KEY,
    "Name" TEXT,
    "Shirt Number" Text,
    "Age" VARCHAR(255),
    "Sub-Position" TEXT,
    "Country" TEXT,
    "Height" VARCHAR(255), -- Assuming height is stored as a decimal, adjust precision/scale as needed
    "Matches" INTEGER,
    "Goals" INTEGER,
    "Assists" TEXT,
    "Cards" VARCHAR(255),
    "Minutes" VARCHAR(255),
    "Value" Text, -- Assuming a numeric type for value, adjust precision/scale as needed
    "Links" TEXT,
    "Foot" TEXT,
    "Isfoot" TEXT,
    "Injury_Sum" INTEGER,
    "Achievements" TEXT
);

COPY Most500 FROM '/Library/PostgreSQL/16/data/Most.csv' WITH (FORMAT CSV, HEADER, DELIMITER ',');

/* Adjusting some columns of table 2 */

UPDATE Most500
SET "Value" = TRIM(BOTH E'\n' FROM "Value");
UPDATE Most500
SET "Shirt Number" = TRIM(BOTH E'\n' FROM "Shirt Number");

/* Data Cleaning */

ALTER TABLE first500 
DROP CONSTRAINT first500_pkey;

ALTER TABLE first500 
DROP COLUMN "Unnamed: 0";

/* Shirt Number */

UPDATE first500
SET "Shirt Number" = REPLACE("Shirt Number", '#', ' ');

ALTER TABLE first500 ADD COLUMN "New Shirt Number" INTEGER;

UPDATE first500
SET "New Shirt Number" = CAST("Shirt Number" AS INTEGER);

Alter table first500
Drop column "Shirt Number";

ALTER TABLE first500 RENAME COLUMN "New Shirt Number" TO "Shirt Number";

/* Age */

UPDATE first500
SET "Age" = CASE
              WHEN "Age" LIKE '%-%' THEN '0'
              ELSE COALESCE(substring("Age" from '\((\d+)\)'), '0')
            END;

Alter table first500
Add column Ages INTEGER;

Update first500
Set "ages"=Cast("Age" as INTEGER);

Alter table first500
Drop Column "Age";

/* Height */

Update first500
Set "Height"=Replace("Height",'m','');

ALTER TABLE first500 
ADD COLUMN "Heights" DECIMAL(3,2);

UPDATE first500
SET "Heights" = case 
				   When "Height" like '%,%' Then CAST(REPLACE(TRIM("Height"), ',', '.') AS Decimal(3,2))
				   Else 0
			    end;
				
Alter table first500
Drop column "Height";

/* Difference Percentage */

Update first500
Set "DiffPercent"=Replace("DiffPercent",'%','');

ALTER TABLE first500 
ADD COLUMN "Difference Percentage" DECIMAL(6,1);

UPDATE first500
SET "Difference Percentage" = Case 
							  When "DiffPercent" like '%.%' Then Cast("DiffPercent" As Decimal(6,1))
							  Else 0
							  End ;
				
Alter table first500
Drop column "DiffPercent";

/* Difference Value*/
Alter table first500 
Add column "Progress" Decimal(5,2);

Update first500 
Set "Progress" = Cast(Replace(Replace("differencevalue",'+€',' '),'m',' ')as Decimal(5,2));

Alter table first500
Drop column "differencevalue";

/* Assists */
Alter table first500
Add column "Assist" Integer;
			 
UPDATE first500
SET "Assist" = CASE
                 WHEN "Assists" LIKE '%-%' THEN 0
                 ELSE CAST("Assists" AS INTEGER)
               END;
			   
Alter table first500
Drop column "Assists";

/* Cards */
Alter table first500
Add column "Yellow Cards" text;

Alter table first500
Add column "Red Cards" text;

UPDATE first500
SET "Yellow Cards" = LEFT("Cards", 2);

UPDATE first500
SET "Red Cards" = Right("Cards", 2);

Alter table first500
Add column "Yellow Cards Count" integer, Add column "Red Cards Count" integer;

UPDATE first500
SET "Yellow Cards Count" = CASE
                             WHEN "Yellow Cards" LIKE '%-%' THEN 0
                             ELSE CAST(REGEXP_REPLACE("Yellow Cards", '[^0-9]', '', 'g') AS INTEGER)
                           END;
UPDATE first500
SET "Red Cards Count" = CASE
                             WHEN "Red Cards" LIKE '%-%' THEN 0
                             ELSE CAST(REGEXP_REPLACE("Red Cards", '[^0-9]', '', 'g') AS INTEGER)
                           END;
						   
Alter table first500
Drop column "Red Cards",Drop COlumn"Yellow Cards",Drop column "Cards";

/* Minutes */
UPDATE first500
SET "Minutes" = REPLACE("Minutes", '''', ' ');

UPDATE first500
SET "Minutes" = REPLACE("Minutes", '.', '');

Alter table first500
Add column Minutos integer;

update first500
set "minutos"= Case when "Minutes" isnull then 0
					Else Cast("Minutes" as Integer)
					End;

Alter table first500
Drop column "Minutes";

/*  Value  */

Alter table first500
Add column playervalue text;

Update first500
set "playervalue"= SPLIT_PART("Value",'m',1);

Update first500
set "playervalue"=Replace("playervalue",'€','');

Update first500
set "playervalue"=Replace("playervalue",'.','');

Alter table first500
Add column "Valuecounts" Integer;

Update first500
Set "Valuecounts"=Cast("playervalue" as Integer);

ALTER TABLE first500
RENAME COLUMN "Valuecounts" TO "Currentvalue(M)";

/* Foot */

Alter table first500
Add column "PrefFoot" text;

				
UPDATE first500
SET "PrefFoot" =
  CASE
    WHEN "Foot" !~ '[0-9]' THEN "Foot"
    WHEN "Foot" ~ '[0-9]' And "Isfoot" !~ '[0-9]' Then "Isfoot"
    WHEN "Foot" ~ '[0-9]' And "Isfoot" ~ '[0-9]' Then 'Unknown'
  END;
  
Alter table first500
Drop column "playervalue",Drop column "Isfoot" , Drop Column "Foot";

/* Moving on to the next table */

ALTER TABLE Most500 
DROP COLUMN "Unnamed: 0";

/* Shirt Number */

UPDATE most500
SET "Shirt Number" = REPLACE("Shirt Number", '#', ' ');

ALTER TABLE Most500 ADD COLUMN "New Shirt Number" INTEGER;

UPDATE most500
SET "New Shirt Number" = CAST("Shirt Number" AS INTEGER);

Alter table most500
Drop column "Shirt Number";

ALTER TABLE most500 RENAME COLUMN "New Shirt Number" TO "Shirt Number";

/* Age */

UPDATE most500
SET "Age" = CASE
              WHEN "Age" LIKE '%-%' THEN '0'
              ELSE COALESCE(substring("Age" from '\((\d+)\)'), '0')
            END;

Alter table most500
Add column Ages INTEGER;

Update most500
Set "ages"=Cast("Age" as INTEGER);

Alter table most500
Drop Column "Age";

/* Height */

Update most500
Set "Height"=Replace("Height",'m','');

ALTER TABLE most500 
ADD COLUMN "Heights" DECIMAL(3,2);

UPDATE most500
SET "Heights" = case 
				   When "Height" like '%,%' Then CAST(REPLACE(TRIM("Height"), ',', '.') AS Decimal(3,2))
				   Else 0
			    end;
				
Alter table most500
Drop column "Height";

/* Difference Percentage */

Update first500
Set "DiffPercent"=Replace("DiffPercent",'%','');

ALTER TABLE first500 
ADD COLUMN "Difference Percentage" DECIMAL(6,1);

UPDATE first500
SET "Difference Percentage" = Case 
							  When "DiffPercent" like '%.%' Then Cast("DiffPercent" As Decimal(6,1))
							  Else 0
							  End ;
				
Alter table first500
Drop column "DiffPercent";

/* Difference Value*/
Alter table first500 
Add column "Progress" Decimal(5,2);

Update first500 
Set "Progress" = Cast(Replace(Replace("differencevalue",'+€',' '),'m',' ')as Decimal(5,2));

Alter table first500
Drop column "differencevalue";

/* Assists */
Alter table most500
Add column "Assist" Integer;
			 
UPDATE most500
SET "Assist" = CASE
                 WHEN "Assists" LIKE '%-%' THEN 0
                 ELSE CAST("Assists" AS INTEGER)
               END;
			   
Alter table most500
Drop column "Assists";

/* Cards */
Alter table most500
Add column "Yellow Cards" text;

Alter table most500
Add column "Red Cards" text;

UPDATE most500
SET "Yellow Cards" = LEFT("Cards", 2);

UPDATE most500
SET "Red Cards" = Right("Cards", 2);

Alter table most500
Add column "Yellow Cards Count" integer, Add column "Red Cards Count" integer;

UPDATE most500
SET "Yellow Cards Count" = CASE
                             WHEN "Yellow Cards" LIKE '%-%' THEN 0
                             ELSE CAST(REGEXP_REPLACE("Yellow Cards", '[^0-9]', '', 'g') AS INTEGER)
                           END;
UPDATE most500
SET "Red Cards Count" = CASE
                             WHEN "Red Cards" LIKE '%-%' THEN 0
                             ELSE CAST(REGEXP_REPLACE("Red Cards", '[^0-9]', '', 'g') AS INTEGER)
                           END;
						   
Alter table most500
Drop column "Red Cards",Drop COlumn"Yellow Cards",Drop column "Cards";

/* Minutes */
UPDATE most500
SET "Minutes" = REPLACE("Minutes", '''', ' ');

UPDATE most500
SET "Minutes" = REPLACE("Minutes", '.', '');

Alter table most500
Add column Minutos integer;

update most500
set "minutos"= Case when "Minutes" isnull then 0
					Else Cast("Minutes" as Integer)
					End;

Alter table most500
Drop column "Minutes";

/*  Value  */

Alter table most500
Add column playervalue text;

Update most500
set "playervalue"= SPLIT_PART("Value",'m',1);

Update most500
set "playervalue"=Replace("playervalue",'€','');

Update most500
set "playervalue"=Replace("playervalue",'.','');

Alter table most500
Add column "Valuecounts" Integer;

Update most500
Set "Valuecounts"=Cast("playervalue" as Integer);

ALTER TABLE most500
RENAME COLUMN "Valuecounts" TO "Currentvalue(M)";

/* Foot */

Alter table most500
Add column "PrefFoot" text;
				
UPDATE most500
SET "PrefFoot" =
  CASE
    WHEN "Foot" !~ '[0-9]' THEN "Foot"
    WHEN "Foot" ~ '[0-9]' And "Isfoot" !~ '[0-9]' Then "Isfoot"
    WHEN "Foot" ~ '[0-9]' And "Isfoot" ~ '[0-9]' Then 'Unknown'
  END;
  
Alter table most500
Drop column "playervalue",Drop column "Isfoot" , Drop Column "Foot";
  
/* Tables are almost ready */

Alter table most500 
Add column "Difference Percentage" Decimal(6,1);
Alter table most500 
Add column "Progress" Decimal(5,2);

SELECT ages, COUNT(*) as count
FROM most500
GROUP BY ages
ORDER BY count DESC;

SELECT ages, COUNT(*) as count
FROM first500
GROUP BY ages
ORDER BY count DESC;

UPDATE first500
SET "ages" = (
  SELECT AVG("ages")
  FROM first500
)
WHERE "ages" = 0;

Select "PrefFoot", Count(*) as count
From most500
Group by "PrefFoot";

Update most500
Set "PrefFoot"='Unknown'
Where "PrefFoot" like '%-%';

Select "PrefFoot", Count(*) as count
From first500
Group by "PrefFoot";

Update first500
Set "PrefFoot"='Unknown'
Where "PrefFoot" like '%-%';

Update first500
Set "Country"='Unknown'
Where "Country" like '%1%';

Update most500
Set "Country"='Unknown'
Where "Country" like '%1%';

Select "Sub-Position", Count(*)
from most500
Group by "Sub-Position";

Update most500
Set "Sub-Position"='Unknown'
Where "Sub-Position" like '%21%' or "Sub-Position"='Czechia';

Select "Sub-Position", Count(*)
from first500
Group by "Sub-Position";

Update first500
Set "Sub-Position"='Unknown'
Where "Sub-Position" like '%U21%' or "Sub-Position"='Czechia' or "Sub-Position"='Classico'or "Sub-Position"='Egypt' or "Sub-Position"='South Africa' or "Sub-Position" like '%GG11%' or "Sub-Position"='0';

/* Analysing tables */

SELECT f.*
FROM first500 AS f
Left JOIN most500 AS m ON f."Name" = m."Name"
WHERE m."Name" IS NULL;

SELECT m.*
FROM most500 AS m
LEFT JOIN first500 AS f ON m."Name" = f."Name"
WHERE f."Name" IS NULL;

SELECT f.*
FROM most500 AS m
Inner JOIN first500 AS f ON m."Name" = f."Name";

SELECT f.*
FROM most500 AS m
Full JOIN first500 AS f ON m."Name" = f."Name";

/* Craeting Final Dataframe that will be included in Statistics */

SELECT COALESCE(m."Name", f."Name") AS "Name",
       COALESCE(m."Sub-Position", f."Sub-Position") AS "Sub-Position",
       COALESCE(m."Country", f."Country") AS "Country",
       COALESCE(m."Matches", f."Matches") AS "Matches",
       COALESCE(m."Goals", f."Goals") AS "Goals",
       COALESCE(m."Value", f."Value") AS "Value",
       COALESCE(m."Links", f."Links") AS "Links",
       COALESCE(m."Injury_Sum", f."Injury_Sum") AS "Injury_Sum",
       COALESCE(m."Achievements", f."Achievements") AS "Achievements",
       COALESCE(m."Shirt Number", f."Shirt Number") AS "Shirt Number",
       COALESCE(m."ages", f."ages") AS "ages",
       COALESCE(m."Heights", f."Heights") AS "Heights",
       COALESCE(m."Difference Percentage", f."Difference Percentage") AS "Difference Percentage",
       f."Progress",
       COALESCE(m."Assist", f."Assist") AS "Assist",
       COALESCE(m."Yellow Cards Count", f."Yellow Cards Count") AS "Yellow Cards Count",
       COALESCE(m."Red Cards Count", f."Red Cards Count") AS "Red Cards Count",
       COALESCE(m."minutos", f."minutos") AS "minutos",
       COALESCE(m."Currentvalue(M)", f."Currentvalue(M)") AS "Currentvalue(M)",
       COALESCE(m."PrefFoot", f."PrefFoot") AS "PrefFoot"
FROM most500 AS m
FULL OUTER JOIN first500 AS f ON m."Name" = f."Name";


