/*
3.	Average Ratings by City and Passenger Type
•	Calculate the average passenger and driver ratings for each city, segmented by passenger type (new vs. repeat). 
	Identify cities with the highest and lowest average ratings.
*/

WITH avg_ratings AS(
	SELECT 
		c.city_name AS City_name,
		f.passenger_type AS Passenger_type,
		ROUND(AVG(f.passenger_rating), 2) AS Avg_pass_rating,
		ROUND(AVG(f.driver_rating), 2) AS Avg_driver_rating
	FROM fact_trips f
	JOIN dim_city c on c.city_id = f.city_id
	GROUP BY City_name, Passenger_type
	),
    rating_rankings AS (
		SELECT
			City_name,
            Passenger_type,
            Avg_pass_rating,
            Avg_driver_rating,
            RANK() OVER (ORDER BY Avg_pass_rating DESC) AS highest_pass_ranking,
            RANK() OVER (ORDER BY Avg_pass_rating ASC) AS lowest_pass_ranking,
            RANK() OVER (ORDER BY Avg_driver_rating DESC) AS highest_driver_ranking,
            RANK() OVER (ORDER BY Avg_driver_rating ASC) AS lowest_driver_ranking
		FROM avg_ratings
    )
    
SELECT 
	City_name,
	Passenger_type,
	Avg_pass_rating,
	Avg_driver_rating,
    CASE
		WHEN highest_pass_ranking=1 THEN 'Highest Passenger Ranking'
        WHEN lowest_pass_ranking=1 THEN 'Lowest Passenger Ranking'
        WHEN highest_driver_ranking=1 THEN 'Highest Driver Ranking'
        WHEN lowest_driver_ranking=1 THEN 'Lowest Driver Ranking'
	END AS Rank_status
FROM rating_rankings
WHERE highest_pass_ranking = 1 OR lowest_pass_ranking = 1 OR highest_driver_ranking=1 OR  lowest_driver_ranking=1;
