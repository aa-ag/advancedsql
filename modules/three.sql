SELECT device.browser AS device_browser,
    SUM(totals.transactions) as total_transactions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
GROUP BY device_browser
ORDER BY total_transactions DESC