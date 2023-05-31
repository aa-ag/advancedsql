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