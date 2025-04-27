DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
( 
show_id VARCHAR(5),
type VARCHAR(10),
title VARCHAR(250),
director VARCHAR(550),
casts VARCHAR(1050),
country VARCHAR(550),
date_added VARCHAR(55),
release_year INT,
rating VARCHAR(15),
duration VARCHAR(15),
listed_in VARCHAR(250),
description VARCHAR(550)
);

SELECT * FROM netflix;

SELECT 
COUNT(*) as total_content FROM netflix;

SELECT 
   DISTINCT type
FROM netflix;
--Business Problems

--1. count the number of movies vs TV shows
SELECT 
type,
count(*) as total_content
FROM netflix
GROUP BY TYPE;

--2. Find the most commom rating for movies and TV shows
WITH RatingCounts AS(
SELECT 
 type,
 rating,
  COUNT(*) As rating_count
 FROM netflix
 GROUP BY type, rating
),
RankedRatings AS(
SELECT
  type,
  rating,
  rating_count,
  RANK()OVER(PARTITION BY type ORDER BY rating_count DESC)
FROM RatingCounts
)
SELECT
 type,
 rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;

--3.List all movies released in a specific year(e.g. 2020)
SELECT *
FROM netflix
WHERE release_year = 2020;

--4.Find the top 5 countries with the most content on netflix.
SELECT *
FROM
(
  SELECT 
   UNNEST(STRING_TO_ARRAY(country, ',')) AS  country,
   COUNT(*) AS TOTAL_CONTENT
  FROM netflix
  GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;

--5.Identify the longest movie
SELECT * FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;

--6. Find content added in the last 5 years
SELECT* FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--7.Find all movies/TV shows by Director 'Rajiv Chilaka'
SELECT* 
FROM(
  SELECT* ,
    UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
  FROM netflix
) AS t 
WHERE director_name ='Rajiv Chilaka';

--8. List all TV shows with more than 5 shows
SELECT* FROM netflix
WHERE type ='TV Show'
 AND SPLIT_PART(duration, ' ', 1)::INT >5;

--9.Count the number of content Items in each genre
SELECT
 UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
 COUNT(*) AS total_content
 FROM netflix
 GROUP BY 1 ;

--10.Find each year and the average numbers of content release in india on netflix.
SELECT
 country,
 release_year,
 COUNT(show_id) AS total_release,
 ROUND(
     COUNT(show_id)::numeric /
	 (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric* 100, 2
 ) AS avg_release
 FROM netflix
 WHERE country = 'India'
 GROUP BY country, release_year
 ORDER BY avg_release DESC
 LIMIT 5;

 --11.List all movies that are Documentaries.
 SELECT * FROM netflix
 WHERE listed_in LIKE '%Documentaries';

--12. Find all content without a Director
SELECT*
FROM netflix
WHERE director IS NULL;

--13. Find How many movies actor 'Amitabh Bachchan' appeared in the last 10 years.
SELECT*
FROM netflix
WHERE casts LIKE '%Amitabh Bachchan%'
 AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) -10;

--14. Find the top 10 actors who have appeared in the highest number of movies produced in india.
SELECT
   UNNEST(STRING_TO_ARRAY(casts, ',')) AS  actor,
   COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

--15. Categorize content based on the presence of 'Kill' and 'Violence' keywords.
SELECT
  category,
  COUNT(*) AS content_count
 FROM(
  SELECT
    CASE
	  WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
	  ELSE 'Good'
	 END AS category
	FROM netflix
 ) AS categorized_content
 GROUP BY category;

 -- END OF PROJECT--