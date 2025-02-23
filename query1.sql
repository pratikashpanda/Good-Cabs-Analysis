/*
	1. Top and bottom performing cities
		Identify the top 3 and bottom 3 cities by total trips over the entire analysis period.
*/

-- Top 3 cities 
SELECT 
	city_name AS City_name,
    COUNT(f.trip_id) AS Total_trips
FROM dim_city c
JOIN fact_trips f on c.city_id = f.city_id
GROUP BY City_name
ORDER BY Total_trips desc
LIMIT 3;


-- Bottom 3 cities
SELECT 
	city_name AS City_name,
    COUNT(f.trip_id) AS Total_trips
FROM dim_city c
JOIN fact_trips f on c.city_id = f.city_id
GROUP BY City_name
ORDER BY Total_trips
LIMIT 3;