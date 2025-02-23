/*8.	Highest and Lowest Repeat Passenger Rate (RPR%) by City and Month
 	I. Analyse the Repeat Passenger Rate (RPR%) for each city across the sixmonth period. Identify the top 2 and bottom 2 cities 
    based on their RPR% to determine which locations have the strongest and weakest rates.
 	II. Similarly, analyse the RPR% by month across all cities and identify the months with the highest and lowest repeat passenger rates. 
    This will help to pinpoint any seasonal patterns or months with higher repeat passenger loyalty.
*/
WITH passengers as (
		SELECT
			city_id AS City_id,
			MONTH(month) AS months,
			SUM(new_passengers) AS New_passengers,
			SUM(repeat_passengers) AS Repeat_passengers
		FROM trips_db.fact_passenger_summary
		GROUP BY City_id, months
	),
    repeat_passenger_rate AS (
		SELECT
			c.city_name AS City_name,
            p.months,
            p.New_passengers,
            p.Repeat_passengers,
            ROUND((p.Repeat_passengers*100) / (p.New_passengers + p.Repeat_passengers), 2) AS RPR_percent
        FROM passengers p 
        JOIN trips_db.dim_city c
			ON p.City_id = c.city_id
    ),
    Avg_RPR_by_city AS (
		SELECT
			City_name,
            ROUND(AVG(RPR_percent),2) AS RPR_percent
        FROM repeat_passenger_rate
        GROUP BY City_name
    ),
    Avg_RPR_by_month AS (
		SELECT
			months,
            ROUND(AVG(RPR_percent),2) AS RPR_percent
        FROM repeat_passenger_rate
        GROUP BY months
    )

-- cities with 2 highest and 2 lowest RPR%
(
SELECT *
FROM Avg_RPR_by_city
ORDER BY RPR_percent DESC
LIMIT 2
)
UNION ALL
(
SELECT *
FROM Avg_RPR_by_city
ORDER BY RPR_percent ASC
LIMIT 2
);

-- we can only run one query at once

-- month with highest and lowest RPR%
(
SELECT *
FROM Avg_RPR_by_month
ORDER BY RPR_percent DESC
LIMIT 1
)
UNION ALL
(
SELECT *
FROM Avg_RPR_by_month
ORDER BY RPR_percent ASC
LIMIT 1
);