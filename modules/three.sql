SELECT hits.page.pagePath as path,
    COUNT(hits.page.pagePath) as counts
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`, 
    UNNEST(hits) as hits
WHERE hits.type="PAGE" and hits.hitNumber=1
GROUP BY path
ORDER BY counts DESC