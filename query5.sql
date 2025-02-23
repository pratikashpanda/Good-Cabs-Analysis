/*
5.	Weekend vs. Weekday Trip Demand by City
•	Compare the total trips taken on weekdays versus weekends for each city over the six-month period. 
	Identify cities with a strong preference for either weekend or weekday trips to understand demand variations.
*/
WITH Trip_demand AS (
	SELECT 
		c.city_name AS City_name,
		d.day_type AS Day_type,
		COUNT(f.trip_id) AS Total_trips
	FROM fact_trips f
	JOIN dim_city c on c.city_id = f.city_id
	JOIN dim_date d on d.date = f.date
	GROUP BY City_name, Day_type
    ),
    Trip_comparision AS (
    SELECT
		City_name,
        SUM(CASE
				WHEN Day_Type='Weekday' THEN Total_trips
                ELSE 0
			END) AS Weekday_trips,
		SUM(CASE
				WHEN Day_Type='Weekend' THEN Total_trips
                ELSE 0
			END) AS Weekend_trips		
    FROM Trip_demand
    GROUP BY City_name
    )
    
SELECT 
	City_name,
    Weekday_trips,
    Weekend_trips,
    Weekday_trips - Weekend_trips AS Trip_diff,
    CASE
		WHEN Weekday_trips>Weekend_trips THEN 'Weekday'
        WHEN Weekend_trips>Weekday_trips THEN 'Weekend'
        ELSE 'Equal'
	END AS Preference
FROM Trip_comparision
ORDER BY Trip_diff;