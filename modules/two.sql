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

-- Excercise 1
WITH trips_by_day AS
(
SELECT DATE(trip_start_timestamp) AS trip_date,
    COUNT(*) as num_trips
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE trip_start_timestamp > '2016-01-01' AND trip_start_timestamp < '2016-04-01'
GROUP BY trip_date
ORDER BY trip_date
)
SELECT trip_date,
    AVG(num_trips)
    OVER (
        ORDER BY trip_date
        ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
        ) AS avg_num_trips
FROM trips_by_day

-- Exercise 2
SELECT pickup_community_area,
    trip_start_timestamp,
    trip_end_timestamp,
    RANK()
        OVER (
            PARTITION BY pickup_community_area,
            ORDER BY trip_start_timestamp
        ) AS trip_number
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE DATE(trip_start_timestamp) = '2013-10-03'

-- Exercise 3
SELECT taxi_id,
    trip_start_timestamp,
    trip_end_timestamp,
    TIMESTAMP_DIFF(
        trip_start_timestamp, 
        --____ 
            OVER (
                PARTITION BY --____ 
                ORDER BY --____), 
        MINUTE) as prev_break
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE DATE(trip_start_timestamp) = '2013-10-03'