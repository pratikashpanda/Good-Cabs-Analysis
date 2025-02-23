/*
4.	Peak and Low Demand Months by City
•	For each city, identify the month with the highest total trips (peak demand) and the month with the lowest total trips (low demand).
	This analysis will help Goodcabs understand seasonal patterns and adjust resources accordingly.
*/

WITH Trips_by_months AS (
	SELECT 
		c.city_name AS City_name,
		MONTHNAME(f.date) AS `Month`,
		COUNT(f.trip_id) AS Total_trips
	FROM fact_trips f
	JOIN dim_city c on c.city_id = f.city_id
	GROUP BY City_name, `Month`
    ),
    Demand_rankings AS (
		SELECT
			City_name,
            `Month`,
            Total_trips,
			RANK() OVER(PARTITION BY City_name ORDER BY Total_trips DESC) AS Peak_demand,
            RANK() OVER(PARTITION BY City_name ORDER BY Total_trips ASC ) AS Low_demand
        FROM Trips_by_months
    )
    
SELECT 
	City_name,
    `Month`,
    Total_trips,
    CASE
		WHEN Peak_demand=1 THEN 'Peak demand month'
        WHEN Low_demand=1 THEN 'Low demand month'
	END AS Demands
FROM Demand_rankings
WHERE Peak_demand=1 OR Low_demand=1;