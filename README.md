# Netflix Movies and TV Shows Data Analysis using SQL

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives
- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from kaggle dataset:
- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)
## Dashboard
- <a href="https://github.com/Pooja012/netflix.project/blob/main/Book1.twbx">Dashboard</a>
## Schema
```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions
The following SQL queries were developed to answer specific business questions:

1.**count the number of movies vs TV shows**
```sql
SELECT 
type,
count(*) as total_content
FROM netflix
GROUP BY TYPE;
```
**objective**: Determine the distribution of content types on Netflix.

2.**Find the most commom rating for movies and TV shows**
```sql
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
```
**objective**: Identify the most frequently occurring rating for each type of content.

3.**List all movies released in a specific year(e.g. 2020)**
```sql
SELECT *
FROM netflix
WHERE release_year = 2020;
```
**objective**: Retrieve all movies released in a specific year.

4.**Find the top 5 countries with the most content on netflix.**
```sql
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
```
**objective**:Identify the top 5 countries with the highest number of content items.

5.**Identify the longest movie**
```sql
SELECT * FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;
```
**objective**:Find the movie with the longest duration.

6.**Find content added in the last 5 years**
```sql
SELECT* FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```
**objective**:Retrieve content added to Netflix in the last 5 years.

7.**Find all movies/TV shows by Director 'Rajiv Chilaka'**
```sql
SELECT* 
FROM(
  SELECT* ,
    UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
  FROM netflix
) AS t 
WHERE director_name ='Rajiv Chilaka';
```
**objective**: List all content directed by 'Rajiv Chilaka'.

8.**List all TV shows with more than 5 shows**
```sql
SELECT* FROM netflix
WHERE type ='TV Show'
 AND SPLIT_PART(duration, ' ', 1)::INT >5;
```
**objective**: Identify TV shows with more than 5 seasons.

9.**Count the number of content Items in each genre**
```sql
SELECT
 UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
 COUNT(*) AS total_content
 FROM netflix
 GROUP BY 1 ;
```
**objective**:Count the number of content items in each genre.

10.**Find each year and the average numbers of content release in india on netflix.**
```sql
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
```
**objective**: Calculate and rank years by the average number of content releases by India.

11.**List all movies that are Documentaries.**
```sql
 SELECT * FROM netflix
 WHERE listed_in LIKE '%Documentaries';
```
**objective**: Retrieve all movies classified as documentaries.

12.**Find all content without a Director.**
```sql
SELECT*
FROM netflix
WHERE director IS NULL;
```
**objective**: List content that does not have a director.

13.**Find How many movies actor 'Amitabh Bachchan' appeared in the last 10 years.**
```sql
SELECT*
FROM netflix
WHERE casts LIKE '%Amitabh Bachchan%'
 AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) -10;
```
**objective**: Count the number of movies featuring 'Salman Khan' in the last 10 years.

14.**Find the top 10 actors who have appeared in the highest number of movies produced in india.**
```sql
SELECT
   UNNEST(STRING_TO_ARRAY(casts, ',')) AS  actor,
   COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;
```
**objective**: Identify the top 10 actors with the most appearances in Indian-produced movies.

15.**Categorize content based on the presence of 'Kill' and 'Violence' keywords.**
```sql
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
```
**objective**: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion
- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:**  Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
## Dash Board
![image](https://github.com/Pooja012/netflix.project/blob/main/Netflix.png)
**Thank you**
