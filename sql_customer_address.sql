
-- drop database
DROP DATABASE IF EXISTS SHIP_DATABASE;

-- select new database
USE DATABASE SNOWFLAKE_SAMPLE_DATA;

-- select schema TPCDS_SF100TCL
USE SCHEMA TPCDS_SF100TCL;

-- lets create a new database
CREATE DATABASE IF NOT EXISTS CUSTOMER_DATA;

-- lets create a new schema
CREATE SCHEMA IF NOT EXISTS CUSTOMER_DATA;

-- extracting the data from snowflake into new database, so we can create views.
CREATE OR REPLACE TABLE CUSTOMER_DATA AS 
SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCDS_SF100TCL CUSTOMER_DATA;  -- this query should insert data from the samplek database into our newly created databse

USE DATABASE CUSTOMER_DATA;

USE SCHEMA CUSTOMER_DATA;
--select table
SELECT * FROM CUSTOMER_DATA LIMIT 10;

-- select table customer address
SELECT * FROM CUSTOMER_DATA LIMIT 10;

-- lets count the number of cities  
SELECT COUNT(DISTINCT CA_CITY) FROM CUSTOMER_DATA;

SELECT COUNT(DISTINCT "CA_CITY") AS unique_cities FROM CUSTOMER_DATA; -- there are 986 unique cities

-- this query is going to find  the top 10 cities with the most customers
SELECT "CA_CITY", COUNT(*) AS address_count
FROM CUSTOMER_DATA
GROUP BY "CA_CITY"
ORDER BY address_count DESC;


SELECT *
FROM CUSTOMER_DATA
WHERE "CA_CITY" = 'Birmingham';


SELECT * FROM CUSTOMER_DATA
WHERE "CA_GMT_OFFSET" = (SELECT MAX("CA_GMT_OFFSET") FROM CUSTOMER_DATA); -- these are all addresses with the hightest GMT OFFSET

--we can optimize the above query by using an index
CREATE INDEX idx_gmt_offset ON CUSTOMER_DATA("CA_GMT_OFFSET");


SELECT * FROM CUSTOMER_DATA
WHERE "CA_GMT_OFFSET" = (SELECT MIN("CA_GMT_OFFSET") FROM CUSTOMER_DATA); -- these are all addresses with the lowest GMT OFFSET

-- these are addresses with location type family
SELECT * FROM CUSTOMER_DATA WHERE "CA_LOCATION_TYPE" = 'single family';


-- lets create a view that shows the number of addresses per city
CREATE OR REPLACE VIEW address_count_per_city AS
SELECT "CA_CITY", COUNT(*) AS address_count
FROM CUSTOMER_DATA
GROUP BY "CA_CITY"
ORDER BY address_count DESC;

-- we can use views to, 
-- 1. simplify complex queries
-- 2. hide complexity
-- 3. reuse queries
-- 4. improve performance
-- 5. provide security

-- lets group by zip codes
SELECT "CA_ZIP", COUNT(*) AS address_count
FROM CUSTOMER_DATA
GROUP BY "CA_ZIP"
ORDER BY address_count DESC;


-- lets group by state
SELECT "CA_STATE", COUNT(*) AS address_count
FROM CUSTOMER_DATA
GROUP BY "CA_STATE"
ORDER BY address_count DESC;


-- lets group by country
SELECT "CA_COUNTRY", COUNT(*) AS address_count
FROM CUSTOMER_DATA
GROUP BY "CA_COUNTRY"
ORDER BY address_count DESC;
