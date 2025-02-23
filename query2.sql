/*
2.	Average Fare per Trip by City
  	Calculate the average fare per trip for each city and compare it with the city's average trip distance.
    Identify the cities with the highest and lowest average fare per trip to assess pricing efficiency 
    across locations.
*/

WITH Avg_per_city AS (
		SELECT 
			city_name AS City_name,
			ROUND(AVG(f.fare_amount),2) AS Average_fare,
			ROUND(AVG(f.distance_travelled_km),2) AS Average_distance
		FROM dim_city c
		JOIN fact_trips f on c.city_id = f.city_id
		GROUP BY City_name
	),
    ranking AS (
		SELECT 
			City_name,
            Average_fare,
            Average_distance,
            RANK() OVER(ORDER BY Average_fare DESC) AS Highest_rank,
            RANK() OVER(ORDER BY Average_fare ASC) AS Lowest_rank
        FROM Avg_per_city
    )
    
SELECT 
	City_name,
	Average_fare,
	Average_distance,
    CASE
		WHEN Highest_rank = 1 THEN 'Highest'
        WHEN Lowest_rank = 1 THEN 'Lowest'
	END AS Rank_status
FROM ranking
WHERE Highest_rank = 1 OR Lowest_rank = 1;

-- HIGHEST AVERAGE FARE PER TRIP
SELECT 
	city_name AS City_name,
    ROUND(AVG(f.fare_amount),2) AS Average_fare,
    ROUND(AVG(f.distance_travelled_km),2) AS Average_distance
FROM dim_city c
JOIN fact_trips f on c.city_id = f.city_id
GROUP BY City_name
ORDER BY Average_fare DESC
LIMIT 1;

-- LOWEST AVERAGE FARE PER TRIP
SELECT 
	city_name AS City_name,
    ROUND(AVG(f.fare_amount),2) AS Average_fare,
    ROUND(AVG(f.distance_travelled_km),2) AS Average_distance
FROM dim_city c
JOIN fact_trips f on c.city_id = f.city_id
GROUP BY City_name
ORDER BY Average_fare
LIMIT 1;
