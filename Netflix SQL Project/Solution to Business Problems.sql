-- 15 Netflix Business Problems & Solutions

1. Count the number of Movies vs TV Shows
SELECT type, COUNT(*) AS to
FROM netflix
GROUP BY type


2. Find the most common rating for movies and TV shows
SELECT rating,COUNT(1)
FROM netflix
GROUP BY type


3. List all movies released in a specific year (e.g., 2020)
SELECT title,release_year FROM netflix
WHERE release_year = 2020


4. Find the top 5 countries with the most content on Netflix
SELECT country,COUNT(title) as total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country
ORDER BY total_content DESC
LIMIT 5


5. Identify the longest movie
SELECT title,duration
FROM netflix
WHERE type = 'Movie'
SELECT * FROM netflix


6. Find content added in the last 5 years
SELECT * FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'


7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT * FROM netflix
WHERE director = 'Rajiv Chilaka'


8. List all TV shows with more than 5 seasons
SELECT * FROM netflix
WHERE type = 'TV Show'
AND duration LIKE '5%'


9. Count the number of content items in each genre
SELECT listed_in,COUNT(1)
FROM netflix
GROUP BY listed_in


10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!
SELECT country,release_year,COUNT(1) as no_of_content_released,
ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 
		,2
		)
		as avg_release

FROM netflix
WHERE country = 'India'
GROUP BY country,2
ORDER BY avg_release DESC
LIMIT 5

11. List all movies that are documentaries
SELECT * FROM netflix
WHERE type = 'Movie'
AND listed_in ILIKE '%documentaries%'


12. Find all content without a director
SELECT * FROM netflix
WHERE director IS NULL

13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT * FROM netflix
WHERE casts LIKE 'Salman%'
AND TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '10 years'


14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10


15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.

WITH cte AS(
SELECT *,
CASE WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
ELSE 'Good' END AS category
FROM netflix)

SELECT category,COUNT(*) as total_count
FROM cte
GROUP BY category



