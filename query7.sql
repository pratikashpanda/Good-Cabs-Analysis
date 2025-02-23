/*
7.	Monthly Target Achievement Analysis for Key Metrics
 	 For each city, evaluate monthly performance against targets for total trips, new passengers, and average passenger ratings from targets db. 
     Determine if each metric met, exceeded, or missed the target, and calculate the percentage difference. 
     Identify any consistent patterns in target achievement, particularly across tourism versus business-focused cities.
*/
WITH passengers AS (
	SELECT
		p.city_id AS City_id,
        MONTH(p.month) AS `Month`,
        SUM(p.new_passengers) AS Actual_new_passenger
    FROM trips_db.fact_passenger_summary p
    GROUP BY City_id, `Month`
	),
    trips AS (
    SELECT
		f.city_id AS City_id,
        MONTH(f.date) AS `Month`,
        COUNT(f.trip_id) AS Actual_trips,
        ROUND(AVG(f.passenger_rating),2) AS Actual_passenger_ratings
    FROM trips_db.fact_trips f
    GROUP BY City_id, `Month`
    ),
    total_trips AS (
    SELECT
		t.City_id,
		t.`Month`,
		t.Actual_trips,
		t.Actual_passenger_ratings,
		p.Actual_new_passenger
    FROM trips t
    JOIN passengers p ON t.City_id = p.City_id
					 AND t.`Month` = p.`Month`
    ),
    actual_trips_data AS (
		SELECT
			t.City_id,
            c.city_name AS City_name,
			t.`Month`,
			t.Actual_trips,
			t.Actual_passenger_ratings,
			t.Actual_new_passenger
        FROM total_trips t
        JOIN trips_db.dim_city c ON t.City_id = c.city_id
    ),
    targets AS (
		SELECT
			t.city_id as City_id,
            MONTH(t.month) AS `Month`,
            t.total_target_trips AS Total_target_trips,
            p.target_new_passengers AS Target_new_passengers
        FROM monthly_target_trips t
        JOIN monthly_target_new_passengers p 
			ON t.city_id = p.city_id
			AND t.month = p.month									
    ),
    target_trips_data AS (
		SELECT
			t.City_id,
            t.`Month`,
            t.Total_target_trips,
            t.Target_new_passengers,
            r.target_avg_passenger_rating AS Target_avg_passenger_rating
        FROM targets t 
        JOIN city_target_passenger_rating r ON t.city_id = r.city_id
    ),
    comparisions AS (
		SELECT
			t.City_id,
            a.City_name,
            t.`Month`,
            t.Total_target_trips,
            a.Actual_trips,
            ROUND(((a.Actual_trips - t.Total_target_trips)*100 / t.Total_target_trips), 2) AS Trip_diff_percent,
            CASE
				WHEN a.Actual_trips >= t.Total_target_trips THEN 'MET/EXCEEDED'
                ELSE 'MISSED'
			END AS Trip_target_status,
            t.Target_new_passengers,
            a.Actual_new_passenger,
            ROUND(((a.Actual_new_passenger - t.Target_new_passengers)*100 / t.Target_new_passengers), 2) AS Passenger_diff_percent,
			CASE
				WHEN a.Actual_new_passenger >= t.Target_new_passengers THEN 'MET/EXCEEDED'
                ELSE 'MISSED'
			END AS Passenger_target_status,
            t.Target_avg_passenger_rating,
            a.Actual_passenger_ratings,
            ROUND(((a.Actual_passenger_ratings - t.Target_avg_passenger_rating)*100 / t.Target_avg_passenger_rating), 2) AS Rating_diff_percent,
            CASE
				WHEN a.Actual_passenger_ratings >= t.Target_avg_passenger_rating THEN 'MET/EXCEEDED'
                ELSE 'MISSED'
			END AS Rating_target_status
		FROM target_trips_data t
		JOIN actual_trips_data a
			ON t.City_id = a.City_id
			AND t.`Month` = a.`Month`
    )
    

SELECT 
	City_name,
    `Month`,
    Trip_diff_percent,
    Trip_target_status,
    Passenger_diff_percent,
    Passenger_target_status,
    Rating_diff_percent,
    Rating_target_status
FROM comparisions;