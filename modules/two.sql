-- First example
WITH trips_by_day AS
(
SELECT DATE(start_date) AS trip_date,
    COUNT(*) as num_trips
FROM `bigquery-public-data.san_francisco.bikeshare_trips`
WHERE EXTRACT(YEAR FROM start_date) = 2015
GROUP BY trip_date
)
SELECT *,
    SUM(num_trips) 
        OVER (
            ORDER BY trip_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
            ) AS cumulative_trips
    FROM trips_by_day

-- Second example
SELECT bike_number,
    TIME(start_date) AS trip_time,
    FIRST_VALUE(start_station_id)
        OVER (
            PARTITION BY bike_number
            ORDER BY start_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            ) AS first_station_id,
    LAST_VALUE(end_station_id)
        OVER (
            PARTITION BY bike_number
            ORDER BY start_date
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            ) AS last_station_id,
    start_station_id,
    end_station_id
FROM `bigquery-public-data.san_francisco.bikeshare_trips`
WHERE DATE(start_date) = '2015-10-25'