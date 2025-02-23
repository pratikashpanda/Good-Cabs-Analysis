/*
6.	Repeat Passenger Frequency and City Contribution Analysis
•	Analyse the frequency of trips taken by repeat passengers in each city (e.g., % of repeat passengers taking 2 trips, 3 trips, etc.). 
	Identify which cities contribute most to higher trip frequencies among repeat passengers, and examine if there are distinguishable patterns 
	between tourism-focused and business-focused cities.
*/
WITH repeat_passengers AS (
	SELECT 
		c.city_name AS City_name,
		r.trip_count AS Total_trips,
		SUM(r.repeat_passenger_count) AS Repeat_passenger_count
	FROM dim_city c
	JOIN dim_repeat_trip_distribution r on c.city_id = r.city_id
	GROUP BY City_name, Total_trips
    ),
    total_passengers AS (
    SELECT
		City_name,
        Total_trips,
        Repeat_passenger_count,
        SUM(Repeat_passenger_count) OVER (PARTITION BY City_name) AS Total_city_passengers
	FROM repeat_passengers
    )
    
select 
	City_name,
    ROUND(SUM(CASE WHEN Total_trips = 2 THEN Repeat_passenger_count*100 / Total_city_passengers END), 2) AS '2-trips',
    ROUND(SUM(CASE WHEN Total_trips = 3 THEN Repeat_passenger_count*100 / Total_city_passengers END), 2) AS '3-trips',
    ROUND(SUM(CASE WHEN Total_trips = 4 THEN Repeat_passenger_count*100 / Total_city_passengers END), 2) AS '4-trips',
    ROUND(SUM(CASE WHEN Total_trips = 5 THEN Repeat_passenger_count*100 / Total_city_passengers END), 2) AS '5-trips',
    ROUND(SUM(CASE WHEN Total_trips = 6 THEN Repeat_passenger_count*100 / Total_city_passengers END), 2) AS '6-trips',
    ROUND(SUM(CASE WHEN Total_trips = 7 THEN Repeat_passenger_count*100 / Total_city_passengers END), 2) AS '7-trips',
    ROUND(SUM(CASE WHEN Total_trips = 8 THEN Repeat_passenger_count*100 / Total_city_passengers END), 2) AS '8-trips',
    ROUND(SUM(CASE WHEN Total_trips = 9 THEN Repeat_passenger_count*100 / Total_city_passengers END), 2) AS '9-trips',
    ROUND(SUM(CASE WHEN Total_trips = 10 THEN Repeat_passenger_count*100 / Total_city_passengers END), 2) AS '10-trips'
from total_passengers
GROUP BY City_name;