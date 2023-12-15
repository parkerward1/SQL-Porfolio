Dataset: UFO Sightings
Source: The NATIONAL UFO Reporting Center https://nuforc.org/subndx/?id=all
Author: Parker Ward


--  Select state and the count of ufo sightings from the ufo_sightings table
SELECT state, COUNT(*) AS sighting_count FROM ufo_sightings GROUP BY state;

-- Find the 5 States with the Highest UFO Sighting
SELECT state, SUM(duration) AS total_duration
FROM ufo_sightings
WHERE duration IS NOT NULL
GROUP BY state
ORDER BY total_duration DESC
LIMIT 5;

-- Find the top 5 states with the highest average sighting duration, considering only states with more than 10 sightings
WITH StateAverages AS (
    SELECT state, AVG(duration) AS avg_duration
    FROM ufo_sightings
    GROUP BY state
    HAVING COUNT(*) > 10
)

SELECT state, avg_duration
FROM StateAverages
ORDER BY avg_duration DESC
LIMIT 5;

-- Find the state with the highest number of sightings and its count
SELECT state, COUNT(*) AS sighting_count
FROM ufo_sightings
GROUP BY state
ORDER BY sighting_count DESC
LIMIT 1;

-- Calculate the percentage of sigtings that occur in the US
SELECT
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ufo_sightings)) AS percentage_in_us
FROM ufo_sightings
WHERE country = 'United States';

-- Retrieve sightings from the last 7 days
SELECT * FROM ufo_sightings
WHERE posted >= NOW() - INTERVAL '7 days';

--Find the top 5 cities with the highest number of sightings 
SELECT city, COUNT(*) AS sighting_count
FROM ufo_sightings
WHERE country = 'Canada'
GROUP BY city
ORDER BY sighting_count DESC
LIMIT 5;

-- Retrieve sightings with a summary containing the word "bright" and a duration longer than 15 minutes
SELECT * FROM ufo_sightings
WHERE LOWER(summary) LIKE '%bright%' AND duration > 15;

-- Find the cities where the most recent sightings were reported 
SELECT DISTINCT ON (state) state, city, posted
FROM ufo_sightings
ORDER BY posted DESC;


-- Find the top 10 cities with the highest number of sightings for each country
SELECT country, city, sighting_count
FROM (
    SELECT country, city, ROW_NUMBER() OVER (PARTITION BY country ORDER BY sighting_count DESC) AS rn
    FROM (
        SELECT country, city, COUNT(*) AS sighting_count
        FROM ufo_sightings
        GROUP BY country, city
    ) AS city_counts
) AS ranked_cities
WHERE rn <= 10;

